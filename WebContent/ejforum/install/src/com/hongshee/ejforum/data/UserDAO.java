package com.hongshee.ejforum.data;

/**
 * <p>Title: UserDAO.java</p>
 * <p>Description: Forum user management data access object</p>
 * <p>Copyright: Hongshee Software 2007</p>
 * @author jackie du
 * @version 1.0
 */

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Set;
import java.util.Calendar;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.servlet.http.Cookie;

import org.apache.commons.fileupload.FileUploadBase.SizeLimitExceededException;

import com.hongshee.ejforum.common.AppContext;
import com.hongshee.ejforum.common.ForumSetting;
import com.hongshee.ejforum.common.CacheManager;
import com.hongshee.ejforum.common.IConstants;
import com.hongshee.ejforum.util.AppUtils;
import com.hongshee.ejforum.util.MyFileUpload;
import com.hongshee.ejforum.util.PageUtils;
import com.hongshee.ejforum.util.MyFileUpload.UploadVO;
import com.hongshee.ejforum.data.BoardDAO.BoardVO;
import com.hongshee.ejforum.data.GroupDAO.GroupVO;

public class UserDAO extends EntityDAO 
{
    private static UserDAO _dao = null;

    protected UserDAO()
    {}

    public static UserDAO getInstance()
    {
        if (_dao == null)
        {
            _dao = new UserDAO();
        }
        return _dao;
    } 
        
    /**
     * Register a new user
     * @param 
     *      request - HttpServletRequest
     * @return none
     * @throws SQLException
     * @since 1.0
     */
    public String registerUser(HttpServletRequest request) throws Exception
    {
        String[] reserveWords = null;
        ForumSetting setting = ForumSetting.getInstance();
        String text = setting.getString(ForumSetting.ACCESS, "reserveWords").replace("\r", "");
        if (text.length() > 0)
            reserveWords = text.split("\n");
        
        String userID = PageUtils.getParam(request,"userID").replace(" ", "");
        String nickname = PageUtils.getHTMLParam(request,"nickname");
        
        if (reserveWords != null && reserveWords.length > 0)
        {
            for (int i=0; i<reserveWords.length; i++)
            {
                text = reserveWords[i].trim();
                if (text.length() == 0) continue;
                if (userID.indexOf(text) >= 0 
                        || nickname.indexOf(text) >= 0)
                    return "注册失败：此用户名或昵称中包含不合法字符，请重新输入";
            }
        }
        
        String email = PageUtils.getParam(request,"email");
        if (email.length() == 0)
            return "注册失败：用户 Email 地址不能为空，请重新输入";
            
        Connection conn = null;
        PreparedStatement pstmtInsert = null;
        try
        {
            String remoteIP = PageUtils.getRemoteAddr(request);
            String groupID = "1";
            String pwd = PageUtils.getParam(request,"pwd");
            String digest = AppUtils.digestData(pwd);

            if (nickname == null || nickname.trim().length() == 0)
            {
                nickname = userID;
            }
            
            String state = "N";
            String registerType = setting.getString(ForumSetting.ACCESS, "registerType");
            if (registerType != null && registerType.equalsIgnoreCase("close"))
                state = "A";

            String isMailPub = PageUtils.getParam(request,"isMailPub");
            if (isMailPub == null || isMailPub.length() == 0)
                isMailPub = "F";
            
            int credits = setting.getInt(ForumSetting.CREDITS, "userInitValue");
            
            conn = dbManager.getConnection();
            pstmtInsert = conn.prepareStatement(adapter.User_Insert);
            pstmtInsert.setString(1, userID);
            pstmtInsert.setString(2, nickname);
            pstmtInsert.setString(3, digest);
            pstmtInsert.setString(4, email);
            pstmtInsert.setString(5, PageUtils.getHTMLParam(request,"icq"));
            pstmtInsert.setString(6, PageUtils.getHTMLParam(request,"webpage"));
            pstmtInsert.setString(7, PageUtils.getParam(request,"gender"));
            pstmtInsert.setString(8, PageUtils.getParam(request,"birth"));
            pstmtInsert.setString(9, PageUtils.getHTMLParam(request,"city"));
            pstmtInsert.setString(10, remoteIP);
            pstmtInsert.setString(11, PageUtils.getHTMLParam(request,"brief"));
            pstmtInsert.setString(12, isMailPub);
            pstmtInsert.setString(13, groupID);
            pstmtInsert.setInt(14, credits);
            pstmtInsert.setString(15, state);
            pstmtInsert.executeUpdate();
            
            if (state.equals("N"))
            {
                UserInfo userinfo = getUserInfo(userID, conn);
                if (userinfo != null)
                    userinfo.remoteIP = PageUtils.getRemoteAddr(request);
            
                HttpSession sess = request.getSession();
                // sess.setMaxInactiveInterval(1200);  //1200s, 20 minutes
                sess.setAttribute("userinfo", userinfo);
                sess.setAttribute("token", String.valueOf(System.currentTimeMillis()));

                Set<HttpSession> sessions = AppContext.getInstance().getSessions();
                sessions.add(sess);
            }
            else if (state.equals("A"))
            {
                String mailEvents = 
                    setting.getString(ForumSetting.FUNCTIONS, "mailEvents");
                if (mailEvents.indexOf("audit") >= 0)
                {
                    ArrayList<OptionVO> users = this.getAuditHandlers(conn);
                    if (users != null && users.size() > 0)
                    {
                        String[] toAddress = new String[users.size()];
                        for (int i=0; i<toAddress.length; i++)
                        {
                            toAddress[i] = users.get(i).value;
                        }
                        String subject = setting.getForumName() + ": 有新用户注册并等待审核";
                        String content = "等待审核用户：" + userID   
                                       + PageUtils.getSysMailFooter(request);
                        AppUtils.sendMail(toAddress, subject, content);
                    }
                }
            }
            return "OK";
        }
        catch(SQLException sqle)
        {
            if (isExistedID(userID, conn))
                return "注册失败：此用户名已经被人使用，请重新输入";
            else if (isExistedMail(email, conn))
                return "注册失败：此 Email 地址已经被其他用户使用，请重新输入";
            else
                throw sqle;
        }
        finally
        {
            dbManager.closePStatement(pstmtInsert);
            dbManager.closeConnection(conn);
        }
    }

    /**
     * Add root admin user to DB if it does not exists 
     * @param 
     *      adminUser - Root admin user ID
     *      adminMail - Root admin user email address
     * @return none
     * @throws Exception
     * @since 1.0
     */
    public void initAdminUser(String adminUserID, String adminMail) throws Exception
    {
        Connection conn = null;
        PreparedStatement pstmtInsert = null;
        try
        {
            conn = dbManager.getConnection();
            if (!isExistedID(adminUserID, conn))
            {
                String nickname = "系统管理员";
                String groupID = "A";
                String digest = AppUtils.digestData(adminUserID);
                digest = AppUtils.digestData(digest);

                int credits = ForumSetting.getInstance().getInt(ForumSetting.CREDITS, "userInitValue");
                
                pstmtInsert = conn.prepareStatement(adapter.User_Insert);
                pstmtInsert.setString(1, adminUserID);
                pstmtInsert.setString(2, nickname);
                pstmtInsert.setString(3, digest);
                pstmtInsert.setString(4, adminMail);
                pstmtInsert.setString(5, null);
                pstmtInsert.setString(6, null);
                pstmtInsert.setString(7, "U");
                pstmtInsert.setString(8, null);
                pstmtInsert.setString(9, null);
                pstmtInsert.setString(10, null);
                pstmtInsert.setString(11, null);
                pstmtInsert.setString(12, "F");
                pstmtInsert.setString(13, groupID);
                pstmtInsert.setInt(14, credits);
                pstmtInsert.setString(15, "N");
                pstmtInsert.executeUpdate();
            }
        }
        finally
        {
            dbManager.closePStatement(pstmtInsert);
            dbManager.closeConnection(conn);
        }
    }
    
    /**
     * Update user base info
     * @param 
     *      request - HttpServletRequest
     * @return none
     * @throws SQLException
     * @since 1.0
     */
    @SuppressWarnings("unchecked")
    public String updateUser(HttpServletRequest request, UserInfo userinfo) throws SQLException
    {
        String[] reserveWords = null;
        ForumSetting setting = ForumSetting.getInstance();
        String text = setting.getString(ForumSetting.ACCESS, "reserveWords").replace("\r", "");
        if (text.length() > 0)
            reserveWords = text.split("\n");
        
        String nickname = PageUtils.getHTMLParam(request,"nickname");
        if (reserveWords != null && reserveWords.length > 0)
        {
            for (int i=0; i<reserveWords.length; i++)
            {
                text = reserveWords[i].trim();
                if (text.length() == 0) continue;
                if (nickname.indexOf(text) >= 0)
                    return "更新失败：昵称中包含不合法字符，请重新输入";
            }
        }
        
        String isMailPub = request.getParameter("isMailPub");
        if (isMailPub == null || isMailPub.length() == 0)
            isMailPub = "F";
        
        ArrayList<Object> paramValues = new ArrayList<Object>();
        paramValues.add(nickname);
        paramValues.add(PageUtils.getParam(request,"email"));
        paramValues.add(PageUtils.getHTMLParam(request,"icq"));
        paramValues.add(PageUtils.getHTMLParam(request,"webpage"));
        paramValues.add(PageUtils.getParam(request,"gender"));
        paramValues.add(PageUtils.getParam(request,"birth"));
        paramValues.add(PageUtils.getHTMLParam(request,"city"));
        paramValues.add(isMailPub);
        paramValues.add(userinfo.userID);
        
        Connection conn = dbManager.getConnection();
        try
        {
            this.execUpdateSql(adapter.User_Update, paramValues, conn);
            userinfo.nickname = nickname;
            return "OK";
        }
        catch(SQLException sqle)
        {
            if (this.isExistedMail(PageUtils.getParam(request,"email"),
                                   userinfo.userID, conn))
                return "更新失败：此 Email 地址已经被其他用户使用，请重新输入";
            else
                throw sqle;
        }
        finally
        {
            dbManager.closeConnection(conn);
        }
    }

    /**
     * Modify user special info
     * @param 
     *      request - HttpServletRequest
     * @return none
     * @throws SQLException
     * @since 1.0
     */
    @SuppressWarnings("unchecked")
    public String modSpecInfo(HttpServletRequest request, UserInfo userinfo) throws SQLException
    {
        ArrayList<UploadVO> attaches = null;
        try
        {
            attaches = MyFileUpload.getInstance().upload(request, "avatar");
        }
        catch(SizeLimitExceededException e)
        {
            return "上传头像出错：文件大小超过限制，允许的最大值为：" 
                    + ((SizeLimitExceededException)e).getPermittedSize() + " 字节。";
        }
        catch(Exception e)
        {
            return "上传头像出错：" + e.getMessage();
        }
        
        String avatar = null;
        if (attaches != null && attaches.size() > 0)
        {
            UploadVO aFile = attaches.get(0);
            avatar = aFile.localname;
        }
        else
        {
            avatar = PageUtils.decodeAttr(
                    (String)request.getAttribute("urlavatar"));
        }
        
        if (avatar.startsWith("avatar/"))
            avatar = avatar.substring(7);
        
        String brief = PageUtils.decodeAttr((String)request.getAttribute("brief"))
                       .replace("\"", "&quot;").replace("<", "&lt;").replace(">", "&gt;");
        
        ArrayList<Object> paramValues = new ArrayList<Object>();
        paramValues.add(avatar);
        paramValues.add(brief);
        paramValues.add(userinfo.userID);
        
        this.execUpdateSql(adapter.User_ModSpecInfo, paramValues);
        return "OK";
    }
    
    /**
     * Do user login
     * @param 
     *      request - HttpServletRequest
     *      response - HttpServletResponse
     * @return success or fail message
     * @throws Exception
     * @since 1.0
     */
    public String doLogin(HttpServletRequest request, HttpServletResponse response) 
                                                                    throws Exception
    {
        String result = null;
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        try
        {
            String userID = PageUtils.getParam(request,"userID");
            String passwd = PageUtils.getParam(request,"pwd");
            
            conn = dbManager.getConnection();
            pstmt = conn.prepareStatement(adapter.User_Login);
            pstmt.setString(1, userID);
            rs = pstmt.executeQuery();
            if (rs.next())
            {
                char state = rs.getString(2).charAt(0);
                if (state == 'N' || state == 'P') // Normal, Seal Posting
                {
                    int loginCount = rs.getInt(3);
                    Timestamp updateTime = rs.getTimestamp(4);
                    if (updateTime == null
                            || updateTime.getTime() < (System.currentTimeMillis()-14400000)) // 4*3600*1000
                    {
                        loginCount = 0;  // Unlock user
                    }
                    else if (loginCount >= 5)
                    {
                        result = "帐户已经被锁定，请在4小时后再尝试登录";
                        return result;
                    }
                    
                    String digest = AppUtils.digestData(passwd);
                    String pwd = rs.getString(1);
                    if (pwd != null && pwd.equals(digest))
                    {
                        result = "OK";
                        loginCount = 0;

                        UserInfo userinfo = getUserInfo(userID, rs);
                        if (userinfo != null)
                            userinfo.remoteIP = PageUtils.getRemoteAddr(request);
                        
                        HttpSession sess = request.getSession();
                        // sess.setMaxInactiveInterval(1200);  //1200s, 20 minutes
                        sess.setAttribute("userinfo", userinfo);
                        sess.setAttribute("token", String.valueOf(System.currentTimeMillis()));
                        
                        Set<HttpSession> sessions = AppContext.getInstance().getSessions();
                        sessions.add(sess);
                        
                        String cookietime = request.getParameter("cookietime");
                        long loginExpire = 0;
                        try
                        {
                            loginExpire = Long.parseLong(cookietime)*1000; // Convert to milliseconds
                        }
                        catch(Exception e){ /* Ignored */ }
                        
                        if (loginExpire > 0)
                        {
                            loginExpire = System.currentTimeMillis() + loginExpire;
                        }
                        
                        String ejf_lsessid = 
                            AppUtils.encode32(String.valueOf(loginExpire) + "|" + userID);
                        
                        Cookie c = new Cookie("ejf_lsessid", ejf_lsessid); 
                        if (loginExpire > 0)
                            c.setMaxAge(86400000);  // 24*3600*1000, 1000 days
                        else
                            c.setMaxAge(0);
                        c.setPath(request.getContextPath());
                        response.addCookie(c);
                        
                        Timestamp stamp = new Timestamp(loginExpire);
                        
                        ArrayList<Object> paramList = new ArrayList<Object>();
                        paramList.add(loginCount);
                        paramList.add(stamp);
                        paramList.add(userID);
                        this.execUpdateSql(adapter.User_ModLoginExpire, paramList, conn);
                    }
                    else
                    {
                        loginCount = loginCount + 1;
                        if (loginCount >= 5)
                        {
                            result = "帐户已被锁定，请在4小时后再尝试登录";
                        }
                        else
                        {
                            result = "用户名和密码不匹配，您还可以尝试" 
                                   + String.valueOf(5-loginCount) + "次";
                        }
                        ArrayList<Object> paramList = new ArrayList<Object>();
                        paramList.add(String.valueOf(loginCount));
                        paramList.add(userID);
                        this.execUpdateSql(adapter.User_ModLoginCount, paramList, conn);
                    }
                }
                else
                {
                    result = "此用户尚未激活或已被封锁";
                }
            }
            else
            {
                result = "用户名不存在";
            }
        }
        finally
        {
            dbManager.closeResultSet(rs);
            dbManager.closePStatement(pstmt);
            dbManager.closeConnection(conn);
        }
        return result;
    }

    /**
     * Do user logout
     * @param 
     *      request - HttpServletRequest
     *      response - HttpServletResponse
     * @return none
     * @throws none
     * @since 1.0
     */
    public void doLogout(HttpServletRequest request, HttpServletResponse response) 
    {
        String tokenID = request.getParameter("sid");
        if (tokenID != null)
        {
            HttpSession sess = request.getSession(false);
            if (sess != null)
            {
                if (tokenID.equals((String)sess.getAttribute("token")))
                    sess.invalidate();
                else
                    return;
            }
            Cookie c = new Cookie("ejf_lsessid", null);   
            c.setMaxAge(0);
            c.setPath(request.getContextPath());
            response.addCookie(c);   
        }
    }
    
    /**
     * Quick login when session is keeped in cookie 
     * @param 
     *      loginUser - last login user ID
     *      loginExpire - login expire time
     * @return UserInfo
     * @throws Exception
     * @since 1.0
     */
    public UserInfo doQuickLogin(String loginUser, long loginExpire, 
                                               HttpServletRequest request) throws Exception
    {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        UserInfo userinfo = null;
        try
        {
            conn = dbManager.getConnection();
            pstmt = conn.prepareStatement(adapter.User_QuickLogin);
            pstmt.setString(1, loginUser);
            rs = pstmt.executeQuery();
            if (rs.next())
            {
                Timestamp loginStamp = rs.getTimestamp(1);
                if (loginStamp != null)
                {
                    if (loginStamp.getTime()/1000 == loginExpire/1000) // Trim millis, Client & Server login id must be same
                    {
                        userinfo = getUserInfo(loginUser, rs);
                        if (userinfo != null)
                            userinfo.remoteIP = PageUtils.getRemoteAddr(request);
                        // Re-construct session
                        HttpSession sess = request.getSession();
                        // sess.setMaxInactiveInterval(1200);  //1200s, 20 minutes
                        sess.setAttribute("userinfo", userinfo);
                        sess.setAttribute("token", String.valueOf(System.currentTimeMillis()));
    
                        Set<HttpSession> sessions = AppContext.getInstance().getSessions();
                        sessions.add(sess);
                        
                        ArrayList<Object> paramList = new ArrayList<Object>();
                        paramList.add(loginUser);
                        this.execUpdateSql(adapter.User_ModLastVisited, paramList, conn);
                    }
                    else
                    {
                        ArrayList<Object> paramList = new ArrayList<Object>();
                        paramList.add(null);
                        paramList.add(loginUser);
                        this.execUpdateSql(adapter.User_ClearLoginExpire, paramList, conn);
                    }
                }
            }
            return userinfo;
        }
        finally
        {
            dbManager.closeResultSet(rs);
            dbManager.closePStatement(pstmt);
            dbManager.closeConnection(conn);
        }
    }
    
    /**
     * Identify if user ID is existed in DB
     * @param 
     *      userID - user ID
     * @return true or false
     * @throws SQLException
     * @since 1.0
     */
    public boolean isExistedID(String userID) throws SQLException
    {
        Connection conn = null;
        try
        {
            conn = dbManager.getConnection();
            return isExistedID(userID, conn);
        }
        finally
        {
            dbManager.closeConnection(conn);
        }
    }

    public boolean isExistedID(String userID, Connection conn) throws SQLException
    {
        PreparedStatement pstmtQuery = null;
        ResultSet rs = null;
        try
        {
            pstmtQuery = conn.prepareStatement(adapter.User_IsExistedID);
            pstmtQuery.setString(1, userID);
            rs = pstmtQuery.executeQuery();
            
            boolean result = false;
            if(rs.next())
            {
                if (rs.getInt(1) >= 1)
                {
                    result = true;
                }
            }
            return result;
        }
        finally
        {
            dbManager.closeResultSet(rs);
            dbManager.closePStatement(pstmtQuery);
        }
    }

    /**
     * Identify if user email is existed in DB
     * @param 
     *      email - user email
     * @return true or false
     * @throws SQLException
     * @since 1.0
     */
    public boolean isExistedMail(String email) throws SQLException
    {
        Connection conn = null;
        try
        {
            conn = dbManager.getConnection();
            return isExistedMail(email, conn);
        }
        finally
        {
            dbManager.closeConnection(conn);
        }
    }

    private boolean isExistedMail(String email, Connection conn) throws SQLException
    {
        PreparedStatement pstmtQuery = null;
        ResultSet rs = null;
        try
        {
            pstmtQuery = conn.prepareStatement(adapter.User_IsExistedMail);
            pstmtQuery.setString(1, email);
            rs = pstmtQuery.executeQuery();
            
            boolean result = false;
            
            if(rs.next())
            {
                if (rs.getInt(1) >= 1)
                {
                    result = true;
                }
            }
            return result;
        }
        finally
        {
            dbManager.closeResultSet(rs);
            dbManager.closePStatement(pstmtQuery);
        }
    }

    private boolean isExistedMail(String email, String userID, Connection conn) 
                                                            throws SQLException
    {
        PreparedStatement pstmtQuery = null;
        ResultSet rs = null;
        try
        {
            pstmtQuery = conn.prepareStatement(adapter.User_GetIDFromMail);
            pstmtQuery.setString(1, email);
            rs = pstmtQuery.executeQuery();
            
            boolean result = false;
            
            if(rs.next())
            {
                if (!rs.getString(1).equalsIgnoreCase(userID))
                {
                    result = true;
                }
            }
            return result;
        }
        finally
        {
            dbManager.closeResultSet(rs);
            dbManager.closePStatement(pstmtQuery);
        }
    }
    
    public String[] getEmailsFromIDs(String[] userIDs, Connection conn) 
                                                    throws SQLException
    {
        String inSql = "select userID,email from ejf_user where userID in";
        StringBuilder sbuf = new StringBuilder(inSql);
        sbuf.append(" (");
        for (int i=0; i<userIDs.length; i++)
        {
            if (i > 0) sbuf.append(",");
            sbuf.append("'").append(userIDs[i]).append("'");
        }
        sbuf.append(")");

        PreparedStatement pstmtQuery = null;
        ResultSet rs = null;
        try
        {
            String[] emails = new String[userIDs.length];

            pstmtQuery = conn.prepareStatement(sbuf.toString());
            rs = pstmtQuery.executeQuery();
            
            while(rs.next())
            {
                for (int i=0; i<userIDs.length; i++)
                {
                    if (userIDs[i].equalsIgnoreCase(rs.getString(1)))
                    {
                        emails[i] = rs.getString(2);
                        break;
                    }
                }
            }
            return emails;
        }
        finally
        {
            dbManager.closeResultSet(rs);
            dbManager.closePStatement(pstmtQuery);
        }
    }
    
    /**
     * Execute finding password action
     * @param 
     *      request - HttpServletRequest
     * @return success or fail message
     * @throws SQLException
     * @since 1.0
     */
    public String findPasswd(HttpServletRequest request) throws Exception
    {
        String result = null;
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        try
        {
            String userID = PageUtils.getParam(request,"userID");
            String email = PageUtils.getParam(request,"email");
            conn = dbManager.getConnection();
            
            if (userID != null && userID.length() > 0)
            {
                pstmt = conn.prepareStatement(adapter.User_GetMailFromID);
                pstmt.setString(1, userID);
                rs = pstmt.executeQuery();
                if (rs.next())
                {
                    email = rs.getString(1);
                }
                else
                {
                    result = "找回密码失败: 此用户名不存在。";
                }
            }
            else if (email != null && email.length() > 0)
            {
                pstmt = conn.prepareStatement(adapter.User_GetIDFromMail);
                pstmt.setString(1, email);
                rs = pstmt.executeQuery();
                if (rs.next())
                {
                    userID = rs.getString(1);
                }                
                else
                {
                    result = "找回密码失败: 此Email不存在。";
                }
            }
            else
            {
                throw new Exception("Invalid request parameter");
            }

            if (userID != null && email != null)
            {
                long setpwdExpire = System.currentTimeMillis() + 3*24*3600*1000;  // In 3 days
                String setID = 
                    AppUtils.encode32(String.valueOf(setpwdExpire) + "|" + userID);
                
                Timestamp stamp = new Timestamp(setpwdExpire);
                
                ArrayList<Object> paramList = new ArrayList<Object>();
                paramList.add(stamp);
                paramList.add(userID);
                this.execUpdateSql(adapter.User_ModSetpwdExpire, paramList, conn);
                
                request.setAttribute("userID", userID);
                request.setAttribute("email", email);
                request.setAttribute("setID", setID);
                result = "OK";
            }
        }
        finally
        {
            dbManager.closeResultSet(rs);
            dbManager.closePStatement(pstmt);
            dbManager.closeConnection(conn);
        }
        return result;
    }

    /**
     * Reset user password
     * @param 
     *      request - HttpServletRequest
     * @return success or fail message
     * @throws SQLException
     * @since 1.0
     */
    public String resetPasswd(HttpServletRequest request) throws Exception
    {
        String result = null;
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        try
        {
            String setID = request.getParameter("sid");
            String userID = PageUtils.getParam(request, "userID");

            long setpwdExpired = Long.parseLong(setID);
            if (setpwdExpired > System.currentTimeMillis())
            {
                conn = dbManager.getConnection();
                pstmt = conn.prepareStatement(adapter.User_GetSetpwdExpire);
                pstmt.setString(1, userID);
                rs = pstmt.executeQuery();
                if (rs.next())
                {
                    Timestamp setpwdStamp = rs.getTimestamp(1);
                    if (setpwdStamp != null && setpwdStamp.getTime()/1000 == setpwdExpired/1000) // Client & Server login id must be same
                    {
                        String pwd = request.getParameter("pwd");
                        String digest = AppUtils.digestData(pwd);
                        ArrayList<Object> paramList = new ArrayList<Object>();
                        paramList.add(digest);
                        paramList.add(userID);
                        this.execUpdateSql(adapter.User_ModPasswd, paramList, conn);
                        result = "OK";
                    }
                    else
                    {
                        ArrayList<Object> paramList = new ArrayList<Object>();
                        paramList.add(null);
                        paramList.add(userID);
                        this.execUpdateSql(adapter.User_ModSetpwdExpire, paramList, conn);
                        result = "找回密码失败: 请求参数无效，请重新执行找回密码操作。";
                    }
                }                
                else
                {
                    result = "找回密码失败: 用户名无效。";
                }
            }
            else
            {
                result = "找回密码失败: 找回密码有效期已过。";
            }
        }
        finally
        {
            dbManager.closeResultSet(rs);
            dbManager.closePStatement(pstmt);
            dbManager.closeConnection(conn);
        }
        return result;
    }

    /**
     * Change user password
     * @param 
     *      request - HttpServletRequest
     * @return success or fail message
     * @throws SQLException
     * @since 1.0
     */
    public String changePasswd(HttpServletRequest request, UserInfo userinfo) 
                                                            throws Exception
    {
        String result = null;
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        try
        {
            String oldPasswd = PageUtils.getParam(request,"oldpwd");
            String passwd = PageUtils.getParam(request,"pwd");

            conn = dbManager.getConnection();
            pstmt = conn.prepareStatement(adapter.User_Login);
            pstmt.setString(1, userinfo.userID);
            rs = pstmt.executeQuery();
            if (rs.next())
            {
                String digest = AppUtils.digestData(oldPasswd);
                String pwd = rs.getString(1);
                if (pwd != null && pwd.equals(digest))
                {
                    digest = AppUtils.digestData(passwd);

                    ArrayList<Object> paramList = new ArrayList<Object>();
                    paramList.add(digest);
                    paramList.add(userinfo.userID);
                    this.execUpdateSql(adapter.User_ModPasswd, paramList, conn);
                    result = "OK";
                }
                else
                {
                    result = "修改密码失败: 原密码不正确。";
                }
            }
            else
            {
                result = "修改密码失败，请重新尝试。";
            }
        }
        finally
        {
            dbManager.closeResultSet(rs);
            dbManager.closePStatement(pstmt);
            dbManager.closeConnection(conn);
        }
        return result;
    }
    
    /**
     * Check if user & password is valid and return its group ID
     * @param 
     *      request - HttpServletRequest
     * @return true or false
     * @throws SQLException
     * @since 1.0
     */
    public char getUserGroupID(String userID, String passwd) throws Exception
    {
        char result = 'G';
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        try
        {
            conn = dbManager.getConnection();
            pstmt = conn.prepareStatement(adapter.User_Login);
            pstmt.setString(1, userID);
            rs = pstmt.executeQuery();
            if (rs.next())
            {
                String digest = AppUtils.digestData(passwd);
                String pwd = rs.getString(1);
                if (pwd != null && pwd.equals(digest))
                {
                    result = rs.getString("groupID").charAt(0);
                }
            }
        }
        finally
        {
            dbManager.closeResultSet(rs);
            dbManager.closePStatement(pstmt);
            dbManager.closeConnection(conn);
        }
        return result;
    }
    
    /**
     * Identify if a user has admin right 
     * @param 
     *      userID - User ID
     * @return true of false
     * @throws Exception
     * @since 1.0
     */
    public boolean isAdminUser(UserInfo userinfo) throws Exception
    {
        if (userinfo == null) return false;
        CacheManager cache = CacheManager.getInstance();
        GroupVO aGroup = PageUtils.getGroupVO(userinfo, cache.getModerators());
        if (aGroup.groupType == 'S')
            return true;
        else
            return false;
    }

    /**
     * Modify user admin group ID
     * @param 
     *      request - HttpServletRequest
     * @return result message
     * @throws SQLException
     * @since 1.0
     */
    public String modifyGroup(HttpServletRequest request) throws SQLException
    {
        String userID = PageUtils.getParam(request,"userID");
        if (AppContext.getInstance().getAdminUser().equals(userID))
        {
            return "不能修改系统管理员的管理组属性";
        }

        String groupID = PageUtils.getParam(request,"groupID");
        if (groupID.length() == 0)
            groupID = "1";

        ArrayList<Object> paramList = new ArrayList<Object>();
        paramList.add(groupID);
        paramList.add(userID);
        this.execUpdateSql(adapter.User_ModGroupID, paramList);
            
        return "OK";
    }
   
    /**
     * Login to admin console 
     * @param 
     *      userinfo - Session user info object
     *      pwd - User password
     * @return result message
     * @throws Exception
     * @since 1.0
     */
    public String doAdminLogin(UserInfo userinfo, String passwd) throws Exception
    {
        String result = null;
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        try
        {
            conn = dbManager.getConnection();
            pstmt = conn.prepareStatement(adapter.User_Login);
            pstmt.setString(1, userinfo.userID);
            rs = pstmt.executeQuery();
            if (rs.next())
            {
                String digest = AppUtils.digestData(passwd); 
                String pwd = rs.getString(1);
                if (pwd != null && pwd.equals(digest))
                {
                    result = "OK";
                    userinfo.isAdminOn = true;
                }                        
                else
                {
                    result = "用户名和密码不匹配";
                }
            }
            else
            {
                result = "用户名不存在";
            }
        }
        finally
        {
            dbManager.closeResultSet(rs);
            dbManager.closePStatement(pstmt);
            dbManager.closeConnection(conn);
        }
        return result;
    }

    /**
     * Delete users by query conditions
     * @param 
     *      request - HttpServletRequest
     * @return none
     * @throws SQLException
     * @since 1.0
     */
    public void deleteUsers(HttpServletRequest request) throws Exception
    {
        // Update state
        ArrayList<Object> paramValues = new ArrayList<Object>();
        String whereSql = this.buildSearchWhereSql(request, paramValues);
        whereSql = whereSql + " and userID <> ?";
        paramValues.add(AppContext.getInstance().getAdminUser());
        
        String removepost = PageUtils.getParam(request,"removepost");
        ArrayList<HashMap> userList = null;
        
        Connection conn = dbManager.getConnection();
        try
        {
            conn.setAutoCommit(false);
            
            if (removepost.equals("yes"))
            {
                String sql2 = "select userID,email from ejf_user" + whereSql;                
                userList = this.execSelectSql(sql2, paramValues, conn);
            }
            
            String sql = "delete from ejf_user" + whereSql;
            this.execUpdateSql(sql, paramValues, conn);
            
            if (userList != null && userList.size() > 0)
            {
                removeUserPosts(userList, conn);
                BoardDAO.getInstance().statBoardInfo(conn);
            }
            
            // Add admin log
            String reason = PageUtils.getParam(request,"reason");
            ActionLogDAO.getInstance().addAdminLog(request, "删除用户", reason, conn);
            
            conn.commit();
        }
        catch(SQLException se)
        {
            conn.rollback();
            throw se;
        }
        finally
        {
            dbManager.closeConnection(conn);
        }
    }

    /**
     * Delete user avatars by query conditions
     * @param 
     *      request - HttpServletRequest
     * @return none
     * @throws SQLException
     * @since 1.0
     */
    public void deleteAvatars(HttpServletRequest request) throws Exception
    {
        // Update state
        ArrayList<Object> paramValues = new ArrayList<Object>();
        String whereSql = this.buildSearchWhereSql(request, paramValues);
        whereSql = whereSql + " and userID <> ?";
        paramValues.add(AppContext.getInstance().getAdminUser());
        
        Connection conn = dbManager.getConnection();
        try
        {
            conn.setAutoCommit(false);
            
            String sql = "update ejf_user set avatar=''" + whereSql;
            this.execUpdateSql(sql, paramValues, conn);
            
            // Add admin log
            String reason = PageUtils.getParam(request,"reason");
            ActionLogDAO.getInstance().addAdminLog(request, "删除头像", reason, conn);
            
            conn.commit();
        }
        catch(SQLException se)
        {
            conn.rollback();
            throw se;
        }
        finally
        {
            dbManager.closeConnection(conn);
        }
    }
    
    public void cleanExpiredUsers() throws Exception
    {
        int days = ForumSetting.getInstance().getInt(ForumSetting.ACCESS, "userExpireDays");
        if (days > 0)
        {
            Calendar cal = Calendar.getInstance();
            cal.add(Calendar.DATE, (-1)*days);
            
            SimpleDateFormat dateFormatter = new SimpleDateFormat("yyyy-MM-dd");
            String expireDate = dateFormatter.format(cal.getTime());
            ArrayList<Object> paramValues = new ArrayList<Object>();
            paramValues.add(java.sql.Date.valueOf(expireDate));
    
            this.execUpdateSql(adapter.User_CleanExpired, paramValues);
        }
    }
    
    private void removeUserPosts(ArrayList<HashMap> userList,
                                 Connection conn) throws SQLException
    {
        PreparedStatement pstmtUpdate1 = null;
        PreparedStatement pstmtUpdate2 = null;
        PreparedStatement pstmtUpdate3 = null;
        try
        {
            pstmtUpdate1 = conn.prepareStatement(adapter.Topic_RemoveByUser);
            pstmtUpdate2 = conn.prepareStatement(adapter.Reply_RemoveByUser);
            pstmtUpdate3 = conn.prepareStatement(adapter.Attach_RemoveByUser);
            
            String userID = null;
            for (int i=0; i<userList.size(); i++)
            {
                userID = (String)userList.get(i).get("USERID");
                pstmtUpdate1.setString(1, userID);
                pstmtUpdate1.addBatch();
                pstmtUpdate2.setString(1, userID);
                pstmtUpdate2.addBatch();
                pstmtUpdate3.setString(1, userID);
                pstmtUpdate3.addBatch();
            }
            pstmtUpdate1.executeBatch();
            pstmtUpdate2.executeBatch();
            pstmtUpdate3.executeBatch();
        }
        finally
        {
            dbManager.closePStatement(pstmtUpdate1);
            dbManager.closePStatement(pstmtUpdate2);
            dbManager.closePStatement(pstmtUpdate3);
        }
    }

    /**
     * Audit new users
     * @param 
     *      request - HttpServletRequest
     * @return none
     * @throws SQLException
     * @since 1.0
     */
    public void auditUsers(HttpServletRequest request) throws Exception
    {
        Connection conn = null;
        try
        {
            String[] userIDs = request.getParameterValues("userID");
            String[] emails = PageUtils.getParamValues(request,"email");
            String[] reasons = PageUtils.getParamValues(request,"remark");
            
            conn = dbManager.getConnection();
            for (int i=0; i<userIDs.length; i++)
            {
                auditUser(request, userIDs[i], emails[i], reasons[i], conn);
            }
        }
        finally
        {
            dbManager.closeConnection(conn);
        }
    }

    /**
     * Audit a user
     * @param 
     *      request - HttpServletRequest
     * @return none
     * @throws SQLException
     * @since 1.0
     */
    private void auditUser(HttpServletRequest request, String userID, 
                          String email, String reason, Connection conn) throws SQLException
    {
        String decodedUserID = PageUtils.decodeParam(userID, request);  
        String operation = PageUtils.getParam(request, "op_" + userID);

        String subject = ForumSetting.getInstance().getForumName();
        StringBuilder message = new StringBuilder();
        message.append("尊敬的").append(decodedUserID)
               .append("，您在").append(subject).append("的新用户申请");

        if (operation.equals("no"))
        {
            ArrayList<Object> paramValues = new ArrayList<Object>();
            paramValues.add(decodedUserID);
            this.execUpdateSql(adapter.User_Delete, paramValues, conn);
                
            subject = subject + ": 很抱歉，您的注册申请已被拒绝";
            message.append("已被拒绝，");
            if (reason.trim().length() > 0)
                message.append("拒绝的原因是：").append(reason).append("。<br>");
            message.append("您可以根据情况重新注册并等待审核。");
            message.append(PageUtils.getSysMailFooter(request));
            // Add admin log
            ActionLogDAO.getInstance().addAdminLog(request, "审核新用户", "否决: " + reason, conn);
            // Send notice
            AppUtils.sendMail(email,subject,message.toString()); 
        }
        else if (operation.equals("yes"))
        {
            String sql = adapter.User_ModState + " where userID=?";
            ArrayList<Object> paramValues = new ArrayList<Object>();
            paramValues.add("N");
            paramValues.add(decodedUserID);
            this.execUpdateSql(sql, paramValues, conn);

            subject = subject + ": 您的注册申请已通过审核";
            message.append("已通过审核，您现在可以登录论坛并畅所欲言了。");
            message.append(PageUtils.getSysMailFooter(request));
            // Add admin log
            ActionLogDAO.getInstance().addAdminLog(request, "审核新用户", "通过: " + reason, conn);
            // Send notice
            AppUtils.sendMail(email,subject,message.toString()); 
        }
    }
    
    /**
     * Modify users' state by query conditions
     * @param 
     *      request - HttpServletRequest
     * @return none
     * @throws SQLException
     * @since 1.0
     */
    public void modifyStates(HttpServletRequest request) throws Exception
    {
        Connection conn = null;
        PreparedStatement pstmtUpdate = null;
        ArrayList<HashMap> userList = null;
        try
        {
            // Update state
            String state = PageUtils.getParam(request,"newstate");

            ArrayList<Object> paramValues = new ArrayList<Object>();
            String whereSql = this.buildSearchWhereSql(request, paramValues);
            whereSql = whereSql + " and userID <> ?";
            paramValues.add(AppContext.getInstance().getAdminUser());
            
            String sql = adapter.User_ModState; 
            conn = dbManager.getConnection();
            
            pstmtUpdate = conn.prepareStatement(sql + whereSql);
            pstmtUpdate.setString(1, state);

            int count = paramValues.size();
            for (int i=0; i<count; i++)
            {
                pstmtUpdate.setObject(i+2, paramValues.get(i));
            }
            pstmtUpdate.executeUpdate();

            // Add admin log
            String reason = PageUtils.getParam(request,"reason");
            String action = "用户状态";
            if (state.charAt(0) == 'N')
                action = action + ":恢复正常";
            else if (state.charAt(0) == 'P')
                action = action + ":禁止发言";
            else if (state.charAt(0) == 'S')
                action = action + ":禁止访问";
                
            ActionLogDAO.getInstance().addAdminLog(request, action, reason, conn);
            
            String sendnotice = PageUtils.getParam(request,"sendnotice");
            if (sendnotice.equals("yes"))
            {
                String sql2 = "select userID,email from ejf_user" + whereSql;                
                userList = this.execSelectSql(sql2, paramValues, conn);
            }
        }
        finally
        {
            dbManager.closePStatement(pstmtUpdate);
            dbManager.closeConnection(conn);
        }
        // Send notice
        if (userList != null && userList.size() > 0)
        {
            this.sendNotice(request, userList);
        }                
    }

    private void sendNotice(HttpServletRequest request, 
                            ArrayList<HashMap> userList) throws Exception
    {
        String subject = PageUtils.getParam(request,"subject");
        String message = PageUtils.getParam(request,"message");
        String sendby = PageUtils.getParam(request,"sendby");
            
        if (sendby.equals("sms"))
        {
            HashMap aUserMap = null;
            String[] userIDs = new String[userList.size()];
                
            for (int i=0; i<userList.size(); i++)
            {
                aUserMap = userList.get(i);
                userIDs[i] = (String)aUserMap.get("USERID");
            }

            subject = "[系统消息]" + subject;
            String fromUser = null;
            UserInfo userinfo = PageUtils.getSessionUser(request);
            if (userinfo != null)
            {
                fromUser = userinfo.userID;
            }                        
            ShortMsgDAO.getInstance().addShortMsgs(fromUser, userIDs, subject, message);
        }
        else if (sendby.equals("email"))
        {
            HashMap aUserMap = null;
            String[] toAddrs = new String[userList.size()];
               
            for (int i=0; i<userList.size(); i++)
            {
                aUserMap = userList.get(i);
                toAddrs[i] = (String)aUserMap.get("EMAIL");
            }
            AppUtils.sendMail(toAddrs, subject,
                              message + PageUtils.getSysMailFooter(request)); 
        }
    }
    
    /**
     * Modify users' credits by query conditions
     * @param 
     *      request - HttpServletRequest
     * @return none
     * @throws SQLException
     * @since 1.0
     */
    public void modifyCredits(HttpServletRequest request) throws Exception
    {
        Connection conn = null;
        PreparedStatement pstmtUpdate = null;
        ArrayList<HashMap> userList = null;
        try
        {
            // Update credits
            String credits = PageUtils.getParam(request,"credits");
            credits = credits.replace('+', ' ').trim();

            ArrayList<Object> paramValues = new ArrayList<Object>();
            String whereSql = this.buildSearchWhereSql(request, paramValues);
            whereSql = whereSql + " and userID <> ?";
            paramValues.add(AppContext.getInstance().getAdminUser());
                
            String sql = "update ejf_user set credits = credits + ?";
            conn = dbManager.getConnection();
            
            pstmtUpdate = conn.prepareStatement(sql + whereSql);
            pstmtUpdate.setString(1, credits);

            int count = paramValues.size();
            for (int i=0; i<count; i++)
            {
                pstmtUpdate.setObject(i+2, paramValues.get(i));
            }
            pstmtUpdate.executeUpdate();

            // Add admin log
            String reason = PageUtils.getParam(request,"reason");
            if (Integer.parseInt(credits) > 0)
                reason = reason + ", 积分+" + credits;
            else
                reason = reason + ", 积分" + credits;
                
            ActionLogDAO.getInstance().addAdminLog(request, "积分奖惩", reason, conn);
            
            // Send notice
            String sendnotice = PageUtils.getParam(request,"sendnotice");
            if (sendnotice.equals("yes"))
            {
                String sql2 = "select userID, email from ejf_user" + whereSql;                
                userList = this.execSelectSql(sql2, paramValues, conn);
            }
        }
        finally
        {
            dbManager.closePStatement(pstmtUpdate);
            dbManager.closeConnection(conn);
        }
        // Send notice
        if (userList != null && userList.size() > 0)
        {
            this.sendNotice(request, userList);
        }
    }

    /**
     * Batch decrease users' posts and credits
     * @param 
     *      request - HttpServletRequest
     * @return none
     * @throws SQLException
     * @since 1.0
     */
    public void decPostsAndCredits(String[] users, int[] attaches, 
                                   UserInfo userinfo, int postCredits, 
                                   Connection conn) throws Exception
    {
        PreparedStatement pstmtUpdate = null;
        try
        {
            int attachCredits = ForumSetting.getInstance().getInt(ForumSetting.CREDITS, "upload");
            pstmtUpdate = conn.prepareStatement(adapter.User_DecPostsAndCredits);
            for (int i=0; i<users.length; i++)
            {
                if (users[i] == null || users[i].trim().length() == 0)
                    continue;
//                if (attaches[i] == 0) 
//                    continue;
                pstmtUpdate.setInt(1, postCredits + attaches[i] * attachCredits);
                pstmtUpdate.setString(2, users[i]);
                pstmtUpdate.addBatch();
                
                if (userinfo != null && userinfo.userID.equalsIgnoreCase(users[i]))
                {
                    userinfo.credits = 
                        userinfo.credits - postCredits - attaches[i] * attachCredits;
                }
            }
            pstmtUpdate.executeBatch();
        }
        finally
        {
            dbManager.closePStatement(pstmtUpdate);
        }
    }

    /**
     * Batch modify users' credits
     * @param 
     *      request - HttpServletRequest
     * @return none
     * @throws SQLException
     * @since 1.0
     */
    public void modifyCredits(String[] users, int credits, 
                              Connection conn) throws Exception
    {
        PreparedStatement pstmtUpdate = null;
        try
        {
            if (credits > 0)
                pstmtUpdate = conn.prepareStatement(adapter.User_IncCredits);
            else
                pstmtUpdate = conn.prepareStatement(adapter.User_DecCredits);
            
            for (int i=0; i<users.length; i++)
            {
                if (users[i] == null || users[i].trim().length() == 0)
                    continue;
                pstmtUpdate.setInt(1, credits);
                pstmtUpdate.setString(2, users[i]);
                pstmtUpdate.addBatch();
            }
            pstmtUpdate.executeBatch();
        }
        finally
        {
            dbManager.closePStatement(pstmtUpdate);
        }
    }
    
    /**
     * Build search user where sql clause by query conditions
     * @param 
     *      request - HttpServletRequest
     *      paramValues - Array list to be filled with search parameter
     * @return Where sql string
     * @throws none
     * @since 1.0
     */
    private String buildSearchWhereSql(HttpServletRequest request, ArrayList<Object> paramValues)
    {
        StringBuilder whereSql = new StringBuilder(" where 1=1");
            
        String userID = PageUtils.getParam(request, "userID");
        if (userID != null && userID.length() > 0)
        {
            if (userID.indexOf('*') >= 0)
            {
                whereSql.append(" and userID like ?");
                paramValues.add(userID.replace('*', '%'));
            }
            else
            {
                whereSql.append(" and userID=?");
                paramValues.add(userID);
            }
        }
            
        String state = PageUtils.getParam(request, "state");
        if (state != null && state.length() > 0)
        {
            whereSql.append(" and state=?");
            paramValues.add(state);
        }
            
        String[] groupIDs = request.getParameterValues("groupID");
        if (groupIDs != null && groupIDs.length > 0)
        {
            if (groupIDs.length > 1 || groupIDs[0].length() > 0) // not is '无限制'
            {
                whereSql.append(" and (1=0");
                String[] credits = null;
                for (int i=0; i<groupIDs.length; i++)
                {
                    if (groupIDs[i].length() == 0) continue;
                    if (groupIDs[i].length() == 1)
                    {
                        whereSql.append(" or groupID=?");
                        paramValues.add(groupIDs[i]);
                    }
                    else if (groupIDs[i].indexOf('_') > 0)
                    {
                        credits = groupIDs[i].split("_");
                        whereSql.append(" or (credits>=? and credits<?)");
                        paramValues.add(credits[0]);
                        paramValues.add(credits[1]);
                    }
                }
                whereSql.append(")");
            }
        }
            
        String advanceOptions = request.getParameter("advanceOptions");
        if (advanceOptions.equalsIgnoreCase("yes"))
        {
            String email = PageUtils.getParam(request, "email");
            if (email != null && email.length() > 0)
            {
                if (email.indexOf('*') >= 0)
                {
                    whereSql.append(" and email like ?");
                    paramValues.add(email.replace('*', '%'));
                }
                else
                {
                    whereSql.append(" and email=?");
                    paramValues.add(email);
                }
            }
                
            String maxCredits = PageUtils.getParam(request, "maxCredits");
            if (maxCredits != null && maxCredits.length() > 0)
            {
                try
                {
                    Integer.parseInt(maxCredits);  // Check integer
                    whereSql.append(" and credits<=?");
                    paramValues.add(maxCredits);
                }
                catch(Exception e){ /* Ignored */ }
            }
                
            String minCredits = PageUtils.getParam(request, "minCredits");
            if (minCredits != null && minCredits.length() > 0)
            {
                try
                {
                    Integer.parseInt(minCredits);  // Check integer
                    whereSql.append(" and credits>=?");
                    paramValues.add(minCredits);
                }
                catch(Exception e){ /* Ignored */ }
            }
                
            String maxPosts = PageUtils.getParam(request, "maxPosts");
            if (maxPosts != null && maxPosts.length() > 0)
            {
                try
                {
                    Integer.parseInt(maxPosts);  // Check integer
                    whereSql.append(" and posts>=?");
                    paramValues.add(maxPosts);
                }
                catch(Exception e){ /* Ignored */ }
            }

            String minPosts = PageUtils.getParam(request, "minPosts");
            if (minPosts != null && minPosts.length() > 0)
            {
                try
                {
                    Integer.parseInt(minPosts);  // Check integer
                    whereSql.append(" and posts>=?");
                    paramValues.add(minPosts);
                }
                catch(Exception e){ /* Ignored */ }
            }

            String remoteIP = PageUtils.getParam(request, "remoteIP");
            if (remoteIP != null && remoteIP.length() > 0)
            {
                whereSql.append(" and remoteIP like ?");
                paramValues.add(remoteIP + "%");
            }
                
            String maxCreateTime = PageUtils.getParam(request, "maxCreateTime");
            if (maxCreateTime != null && maxCreateTime.length() > 0)
            {
                try
                {
                    java.sql.Date createTime = java.sql.Date.valueOf(maxCreateTime);  // Check date format
                    whereSql.append(" and createTime<=?");
                    paramValues.add(createTime);
                }
                catch(Exception e){ /* Ignored */ }
            }
                
            String minCreateTime = PageUtils.getParam(request, "minCreateTime");
            if (minCreateTime != null && minCreateTime.length() > 0)
            {
                try
                {
                    java.sql.Date createTime = java.sql.Date.valueOf(minCreateTime);  // Check date format
                    whereSql.append(" and createTime>=?");
                    paramValues.add(createTime);
                }
                catch(Exception e){ /* Ignored */ }
            }

            String maxLastVisited = PageUtils.getParam(request, "maxLastVisited");
            if (maxLastVisited != null && maxLastVisited.length() > 0)
            {
                try
                {
                    java.sql.Date lastVisited = java.sql.Date.valueOf(maxLastVisited);  // Check date format
                    whereSql.append(" and lastVisited<=?");
                    paramValues.add(lastVisited);
                }
                catch(Exception e){ /* Ignored */ }
            }

            String minLastVisited = PageUtils.getParam(request, "minLastVisited");
            if (minLastVisited != null && minLastVisited.length() > 0)
            {
                try
                {
                    java.sql.Date lastVisited = java.sql.Date.valueOf(minLastVisited);  // Check date format
                    whereSql.append(" and lastVisited>=?");
                    paramValues.add(lastVisited);
                }
                catch(Exception e){ /* Ignored */ }
            }
        }
        return whereSql.toString();
    }
    
    /**
     * Search user by query conditions
     * @param 
     *      request - HttpServletRequest
     *      userList - User info list
     * @return Search result count
     * @throws SQLException
     * @since 1.0
     */
    public int searchUser(HttpServletRequest request, ArrayList<UserInfo> userList) 
                                                                throws SQLException
    {
        int totalCount = 0;
        Connection conn = null;
        PreparedStatement pstmtQuery = null;
        ResultSet rs = null;
        try
        {
            int resultCount = 50;
            try
            {
                resultCount = Integer.parseInt(PageUtils.getParam(request, "resultCount"));
            }
            catch(Exception e){ /* Ignored */ }

            int pageNo = 1;
            int pageRows = resultCount;

            ArrayList<Object> paramValues = new ArrayList<Object>();
            String whereSql = this.buildSearchWhereSql(request, paramValues); 
            
            String countSql = "select COUNT(*) from ejf_user" + whereSql;  
            
            // Get search result count first
            conn = dbManager.getConnection();
            totalCount = this.execSelectCountSql(countSql, paramValues, conn);
            
            if (totalCount > 0)
            {
                // Do search, only get 1 page
                String querySql = adapter.getPageQuerySql(
                                    new StringBuilder(adapter.User_QueryInfo + whereSql),
                                    pageNo, pageRows, totalCount);
                
                pstmtQuery = conn.prepareStatement(querySql);
                for (int i=0; i<paramValues.size(); i++)
                {
                    pstmtQuery.setObject(i+1, paramValues.get(i));
                }
                rs = pstmtQuery.executeQuery();
            
                UserInfo userinfo = null;
                while(rs.next())
                {
                    userinfo = new UserInfo();
                    userinfo.userID = rs.getString("userID");
                    userinfo.nickname = rs.getString("nickname");
                    userinfo.posts = rs.getInt("posts");
                    userinfo.credits = rs.getInt("credits");
                    userinfo.groupID = rs.getString("groupID").charAt(0);
                    userinfo.state = rs.getString("state").charAt(0);
                    userList.add(userinfo);
                }
            }
            return totalCount;
        }
        finally
        {
            dbManager.closeResultSet(rs);
            dbManager.closePStatement(pstmtQuery);
            dbManager.closeConnection(conn);
        }
    }

    /**
     * Search user by query conditions
     * @param 
     *      request - HttpServletRequest
     * @return Search result count
     * @throws SQLException
     * @since 1.0
     */
    public int searchUser(HttpServletRequest request) throws SQLException
    {
        Connection conn = null;
        try
        {
            ArrayList<Object> paramValues = new ArrayList<Object>();
            String whereSql = this.buildSearchWhereSql(request, paramValues); 
            String countSql = "select COUNT(*) from ejf_user" + whereSql;  
            
            conn = dbManager.getConnection();
            return this.execSelectCountSql(countSql, paramValues, conn);
        }
        finally
        {
            dbManager.closeConnection(conn);
        }
    }

    /**
     * 查询论坛会员信息
     * @param none
     * @return 统计信息
     * @throws SQLException
     * @since 1.0
     */
    public Object[] getUserList(String sortField, String key, 
                                int pageNo, int pageRows) throws SQLException
    {
        Object[] result = new Object[2];
        String querySql = adapter.User_GetList;
        String countSql = adapter.User_GetCount;

        ArrayList<Object> paramValues = new ArrayList<Object>();
        if (key != null && key.length() > 0)
        {
            querySql = querySql + " and userID like ?";
            countSql = countSql + " and userID like ?";
            paramValues.add("%" + key + "%");
        }

        int totalCount = 0;
        Connection conn = null;
        try
        {
            conn = dbManager.getConnection();
            totalCount = this.execSelectCountSql(countSql, paramValues, conn);
            if (totalCount > 0)
            {
                StringBuilder sbuf = new StringBuilder(querySql);
                sbuf.append(" order by ").append(sortField).append(" DESC");
                querySql = adapter.getPageQuerySql(sbuf, pageNo, pageRows, totalCount);
                result[1] = this.execSelectSql(querySql, paramValues, conn);
            }
        }
        finally
        {
            dbManager.closeConnection(conn);
        }
        // Get result page code
        if (totalCount > 0)
        {
            int pageCount = (totalCount - 1) / pageRows + 1;
            if (pageCount <= 1) return result;
            int maxPages =
                ForumSetting.getInstance().getInt(ForumSetting.MISC, "maxMemberPages");
            result[0] = 
                PageUtils.getPageHTMLStr(totalCount, pageNo, pageRows, maxPages);
        }        
        return result;
    }

    /**
     * 查询具有审核权限的用户信息
     * @param none
     * @return 用户 email 信息
     * @throws SQLException
     * @since 1.0
     */
    private ArrayList<OptionVO> getAuditHandlers(Connection conn) throws SQLException
    {
        PreparedStatement pstmtQuery = null;
        ResultSet rs = null;
        try
        {
            StringBuilder inSql = new StringBuilder(" (");
            ArrayList<GroupVO> groups = CacheManager.getInstance().getGroups();
            if (groups != null)
            {
                GroupVO aGroup = null;
                for (int i=0; i<groups.size(); i++)
                {
                    aGroup = groups.get(i);
                    if (aGroup.rights.indexOf(IConstants.PERMIT_AUDIT_USER) >= 0)
                    {
                        if (inSql.length() > 2) inSql.append(",");
                        inSql.append("'").append(aGroup.groupID).append("'");
                    }
                }
            }
            if (inSql.length() == 2)
                inSql.append("'A'");
            inSql.append(")");

            pstmtQuery = conn.prepareStatement(adapter.User_GetAuditHandler + inSql.toString());
            rs = pstmtQuery.executeQuery();
            
            ArrayList<OptionVO> result = new ArrayList<OptionVO>();
            OptionVO aUser = null;
            
            while(rs.next())
            {
                aUser = new OptionVO();
                aUser.name = rs.getString("userID");
                aUser.value = rs.getString("email");
                result.add(aUser);
            }
            return result;
        }
        finally
        {
            dbManager.closeResultSet(rs);
            dbManager.closePStatement(pstmtQuery);
        }
    }

    /**
     * 查询具有处理举报权限的用户信息
     * @param none
     * @return 用户 email 信息
     * @throws SQLException
     * @since 1.0
     */
    public ArrayList<OptionVO> getReportHandlers(BoardVO aBoard, Connection conn) throws SQLException
    {
        PreparedStatement pstmtQuery = null;
        ResultSet rs = null;
        try
        {
            StringBuilder sbuf = new StringBuilder(adapter.User_GetReportHandler);
            if (aBoard.moderator != null)
            {
                StringBuilder inSql = new StringBuilder(" (");
                String[] users = aBoard.moderator.split(",");
                for (int i=0; i<users.length; i++)
                {
                    if (users[i].length() == 0) continue;
                    if (inSql.length() > 2) inSql.append(",");
                    inSql.append("'").append(users[i]).append("'");
                }
                inSql.append(")");
                if (inSql.length() > 3) 
                    sbuf.append(" or userID in").append(inSql.toString());
            }
            sbuf.append(")");
            
            pstmtQuery = conn.prepareStatement(sbuf.toString());
            rs = pstmtQuery.executeQuery();
            
            ArrayList<OptionVO> result = new ArrayList<OptionVO>();
            OptionVO aUser = null;
            
            while(rs.next())
            {
                aUser = new OptionVO();
                aUser.name = rs.getString("userID");
                aUser.value = rs.getString("email");
                result.add(aUser);
            }
            return result;
        }
        finally
        {
            dbManager.closeResultSet(rs);
            dbManager.closePStatement(pstmtQuery);
        }
    }
    
    /**
     * Modify users' credits by query conditions
     * @param 
     *      request - HttpServletRequest
     * @return none
     * @throws SQLException
     * @since 1.0
     */
    public void sendNotice(HttpServletRequest request) throws Exception
    {
        Connection conn = null;
        ArrayList<HashMap> userList = null;
        try
        {
            ArrayList<Object> paramValues = new ArrayList<Object>();
            String whereSql = this.buildSearchWhereSql(request, paramValues);
                
            conn = dbManager.getConnection();
            
            String sql = "select userID, email from ejf_user" + whereSql;                
            userList = this.execSelectSql(sql, paramValues, conn);
            
            // Add admin log
            String subject = PageUtils.getParam(request,"subject");
            if (subject.length() > 35)
                subject = subject.substring(0, 35) + "...";
            ActionLogDAO.getInstance().addAdminLog(request, "论坛通知", subject, conn);
        }
        finally
        {
            dbManager.closeConnection(conn);
        }
        // Send notice
        if (userList != null && userList.size() > 0)
        {
            this.sendNotice(request, userList);
        }
    }
    
    /**
     * Get user list to be auditing
     * @param none 
     * @return User list to be auditing
     * @throws SQLException
     * @since 1.0
     */
    public ArrayList<HashMap> getAuditingUsers() throws SQLException
    {
        return this.execSelectSql(adapter.User_GetAuditing, null);
    }
    
    /**
     * Get forum user info
     * @param 
     *      userID - user ID
     * @return User info object
     * @throws SQLException
     * @since 1.0
     */
    public UserVO getUserVO(String userID) throws SQLException
    {
        Connection conn = null;
        try
        {
            conn = dbManager.getConnection();
            return getUserVO(userID, conn);
        }
        finally
        {
            dbManager.closeConnection(conn);
        }
    }

    /**
     * Get forum user info
     * @param 
     *      userID - user ID
     *      conn - DB Connection
     * @return User info object
     * @throws SQLException
     * @since 1.0
     */
    public UserVO getUserVO(String userID, Connection conn) throws SQLException
    {
        PreparedStatement pstmtQuery = null;
        ResultSet rs = null;
        try
        {
            pstmtQuery = conn.prepareStatement(adapter.User_Select);
            pstmtQuery.setString(1, userID);
            rs = pstmtQuery.executeQuery();
            
            UserVO aUser = null;
            if(rs.next())
            {
                aUser = new UserVO();
                aUser.userID = userID;
                aUser.nickname = rs.getString("nickname");
                aUser.email = rs.getString("email");
                aUser.icq = rs.getString("icq");
                aUser.webpage = rs.getString("webpage");
                aUser.gender = rs.getString("gender").charAt(0);
                aUser.birth = rs.getString("birth");
                aUser.city = rs.getString("city");
                aUser.remoteIP = rs.getString("remoteIP");
                aUser.brief = rs.getString("brief");
                aUser.avatar = rs.getString("avatar");
                aUser.isMailPub = rs.getString("isMailPub").charAt(0);
                aUser.posts = rs.getString("posts");
                aUser.credits = rs.getInt("credits");
                aUser.groupID = rs.getString("groupID").charAt(0);
                aUser.lastVisited = AppUtils.formatSQLTimeStr(rs.getTimestamp("lastVisited"));
                aUser.state = rs.getString("state").charAt(0);
                aUser.createTime = AppUtils.formatSQLTimeStr(rs.getTimestamp("createTime"));
            }
            return aUser;
        }
        finally
        {
            dbManager.closeResultSet(rs);
            dbManager.closePStatement(pstmtQuery);
        }
    }
    
    /**
     * Get logined user info
     * @param 
     *      userID - user ID
     * @return User info object
     * @throws SQLException
     * @since 1.0
     */
    public UserInfo getUserInfo(String userID) throws SQLException
    {
        Connection conn = null;
        try
        {
            conn = dbManager.getConnection();
            return getUserInfo(userID, conn);
        }
        finally
        {
            dbManager.closeConnection(conn);
        }
    }

    /**
     * Get logined user info
     * @param 
     *      userID - user ID
     * @return User info object
     * @throws SQLException
     * @since 1.0
     */
    public UserInfo getUserInfo(String userID, Connection conn) throws SQLException
    {
        PreparedStatement pstmtQuery = null;
        ResultSet rs = null;
        try
        {
            pstmtQuery = conn.prepareStatement(adapter.User_QuickLogin);
            pstmtQuery.setString(1, userID);
            rs = pstmtQuery.executeQuery();
            if (rs.next())
            {
                return getUserInfo(userID, rs);
            }
            else
                return null;
        }
        finally
        {
            dbManager.closeResultSet(rs);
            dbManager.closePStatement(pstmtQuery);
        }
    }
    
    /**
     * Get logined user info
     * @param 
     *      userID - user ID
     *      conn - DB Connection
     * @return User info object
     * @throws SQLException
     * @since 1.0
     */
    private UserInfo getUserInfo(String userID, ResultSet rs) throws SQLException
    {
        UserInfo userinfo = new UserInfo();
        userinfo.userID = userID;
        userinfo.nickname = rs.getString("nickname");
        userinfo.posts = rs.getInt("posts");
        userinfo.unreadSMs = rs.getInt("unreadSMs");
        userinfo.credits = rs.getInt("credits");
        userinfo.groupID = rs.getString("groupID").charAt(0);
        userinfo.lastVisited = rs.getString("lastVisited");
        userinfo.state = rs.getString("state").charAt(0);

        if (userinfo.groupID <= '9')
        {
            String moderators = CacheManager.getInstance().getModerators();
            if (moderators.indexOf("," + userinfo.userID.toLowerCase() + ",") >= 0)
                userinfo.groupID = 'M';
        }
        return userinfo;
    }

    /**
     * Get user state string
     * @param 
     *      state - user state
     * @return state string
     * @throws none
     * @since 1.0
     */
    public String getStateStr(char state)
    {
        String result = null;
        switch(state) 
        {
            case 'N': result = "正常状态"; break;
            case 'P': result = "禁止发言"; break;
            case 'S': result = "禁止访问"; break;
            default: result = "正常状态";
        }
        return result;
    }
    
    public static class UserVO
    {
        public String userID = null;
        public String nickname = null;
        public String email = null;
        public String icq = null;
        public String webpage = null;
        public char gender = 'U';  // Unknown
        public String birth = null;
        public String city = null;
        public String remoteIP = null;
        public String avatar = null;
        public String brief = null;
        public char isMailPub = 'F';
        public String posts = null;
        public int credits = 0;
        public char groupID = '1';
        public String lastVisited = null;
        public char state = 'N';
        public String createTime = null;
    }
    
    public static class UserInfo implements java.io.Serializable
    {
        private static final long serialVersionUID = -4397719012392173299L;  // Session object
        
        public String userID = null;
        public String nickname = null;
        public String remoteIP = null;
        public int posts = 0;
        public int unreadSMs = 0;
        public int credits = 0;
        public char groupID = '1';
        public String lastVisited = null;
        //public String dateFormat = null;
        //public String timeZone = null;
        public char state = 'N';
        public boolean isAdminOn = false;
    }    
    
}
