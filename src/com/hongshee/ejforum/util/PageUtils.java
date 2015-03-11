package com.hongshee.ejforum.util;

import com.hongshee.common.util.MyLogger;
import com.hongshee.ejforum.common.AppContext;
import com.hongshee.ejforum.common.AppException;
import com.hongshee.ejforum.common.CacheManager;
import com.hongshee.ejforum.common.ForumSetting;
import com.hongshee.ejforum.data.ActionLogDAO;
import com.hongshee.ejforum.data.BoardDAO;
import com.hongshee.ejforum.data.BoardDAO.BoardVO;
import com.hongshee.ejforum.data.GroupDAO;
import com.hongshee.ejforum.data.GroupDAO.GroupVO;
import com.hongshee.ejforum.data.OptionVO;
import com.hongshee.ejforum.data.SectionDAO;
import com.hongshee.ejforum.data.SectionDAO.SectionVO;
import com.hongshee.ejforum.data.UserDAO;
import com.hongshee.ejforum.data.UserDAO.UserInfo;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.Enumeration;
import java.util.Iterator;
import java.util.Set;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.servlet.RequestDispatcher;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

public class PageUtils
{
  private static Logger a = MyLogger.getLogger(PageUtils.class.getName());
  private static String b = null;
  private static String c = "";

  public static void log(HttpServletRequest paramHttpServletRequest, String paramString1, String paramString2, Throwable paramThrowable)
  {
    a.log(Level.WARNING, paramString2, paramThrowable);
    ActionLogDAO.getInstance().addErrorLog(paramHttpServletRequest, paramString1, paramString2);
    String param = ForumSetting.getInstance().getString(5, "mailEvents");
    if ((param).indexOf("error") >= 0)
      AppUtils.sendMail2Admin("EasyJForum error info", paramThrowable.toString());
  }

  public static String getVersion()
  {
    return "2.3";
  }

  public static String getTitle(String paramString)
  {
    Object localObject = ForumSetting.getInstance();
    StringBuilder param = new StringBuilder(paramString);
    localObject = ((ForumSetting)localObject).getString(4, "appendTitle");
    if (((String)localObject).length() > 0)
    	param.append(" - ").append((String)localObject);
    return ((String)param.toString());
  }

  public static String getMetas(String paramString, BoardDAO.BoardVO paramBoardVO)
  {
    StringBuilder localStringBuilder;
    Object localObject = ForumSetting.getInstance();
    (localStringBuilder = new StringBuilder()).append("<META http-equiv=Content-Type content=\"text/html;charset=gbk\">\n");
    localStringBuilder.append("<META name=keywords content=\"");
    if ((paramBoardVO != null) && (paramBoardVO.keywords != null) && (paramBoardVO.keywords.length() > 0))
      localStringBuilder.append(paramBoardVO.keywords).append(",");
    localStringBuilder.append(((ForumSetting)localObject).getString(4, "keywords")).append("\">\n");
    localStringBuilder.append("<META name=description content=\"");
    if ((((ForumSetting)localObject).getString(4, "description")).length() > 0)
    {
      localStringBuilder.append((String)localObject);
    }
    else
    {
      localStringBuilder.append(paramString);
      if (paramBoardVO != null)
        localStringBuilder.append(" - ").append(paramBoardVO.boardName);
    }
    localStringBuilder.append("\">\n");
    localStringBuilder.append("<META name=generator content=\"EasyJForum ").append("2.3").append("\">\n");
    localStringBuilder.append("<META name=author content=\"EasyJForum Team\">\n");
    localStringBuilder.append("<META name=copyright content=\"Hongshee Software\">\n");
    localStringBuilder.append("<META http-equiv=MSThemeCompatible content=\"Yes\">");
    return ((String)localStringBuilder.toString());
  }

  public static String getRSSLink(HttpServletRequest paramHttpServletRequest, String paramString, SectionDAO.SectionVO paramSectionVO, BoardDAO.BoardVO paramBoardVO)
  {
    String str;
    if ((str = ForumSetting.getInstance().getString(5, "RssStyle")).equals("B"))
      str = "0";
    else
      str = "1";
    String param = getForumURL(paramHttpServletRequest);
    StringBuilder localStringBuilder = new StringBuilder();
    if ((paramBoardVO != null) && (paramSectionVO != null))
      localStringBuilder.append("<LINK title=\"").append(paramBoardVO.boardName).append(" - ").append(paramString).append("\" href=\"").append(param).append("forum-").append(paramSectionVO.sectionID).append("-").append(paramBoardVO.boardID).append("-").append(str).append(".xml\" type=application/rss+xml rel=alternate>\n");
    else if (paramSectionVO != null)
      localStringBuilder.append("<LINK title=\"").append(paramSectionVO.sectionName).append(" - ").append(paramString).append("\" href=\"").append(param).append("forums-").append(paramSectionVO.sectionID).append("-").append(str).append(".xml\" type=text/x-opml rel=outline>\n");
    else
      localStringBuilder.append("<LINK title=\"").append(paramString).append("\" href=\"").append(param).append("forums-all-").append(str).append(".xml\" type=text/x-opml rel=outline>\n");
    return localStringBuilder.toString();
  }

  public static String getRSSFeeds(String paramString, boolean paramBoolean)
  {
    Object localObject;
    StringBuilder param = new StringBuilder();
    if (paramBoolean)
    {
    	param.append("<SCRIPT type=text/javascript>\n");
    	param.append("function checkAgent(){\n").append("if(!is_ie){\n").append("if(confirm(\"您使用的是非 IE 内核的浏览器，不能使用此订阅功能。\\n").append("建议您安装 Wisol Reader，是否转到其下载页面？\")){\n").append("window.open(\"http://www.wisol.net.cn/wisc.jsp\");return false;}\n").append("}else if(navigator.userAgent.indexOf('HS/Wisc') < 0){\n").append("if(confirm(\"订阅前需要安装 Wisol Reader，是否转到其下载页面？\")){\n").append("window.open(\"http://www.wisol.net.cn/wisc.jsp\");}return false;}\n").append("return true;\n}\n");
    	param.append("function subGroup(elemId){\n").append("if(!checkAgent()) return;\n").append("var obj = $(elemId + '_url');\n").append("var url = obj.href;\n").append("if(url.indexOf('?') < 0)\n").append("location.href='wisc://'+url+'?wisc_grpname='+$(elemId+'_name').innerHTML;\n").append("else\n").append("location.href='wisc://'+url+'&wisc_grpname='+$(elemId+'_name').innerHTML;\n").append("}\n");
    	param.append("function subChannel(elemId){\n").append("if(!checkAgent()) return;\n").append("var obj = $(elemId + '_url');\n").append("var url = obj.href;\n").append("if(url.indexOf('?') < 0)\n").append("location.href='wisc://'+url+'?wisc_chnname='+$(elemId+'_name').innerHTML;\n").append("else\n").append("location.href='wisc://'+url+'&wisc_chnname='+$(elemId+'_name').innerHTML;\n").append("}\n");
    	param.append("</SCRIPT>\n");
    }
    localObject = (CacheManager.getInstance()).getSections();
    if ((localObject) != null)
    {
      SectionDAO.SectionVO localSectionVO = null;
      BoardDAO.BoardVO localBoardVO = null;
      String str1 = null;
      String str2 = null;
      String str3 = String.valueOf(33) + "%";
      StringBuilder localStringBuilder = new StringBuilder();
      String str4 = ForumSetting.getInstance().getForumName();
      for (int j = 0; j < ((ArrayList)localObject).size(); ++j)
        if ((localSectionVO = (SectionDAO.SectionVO)(SectionDAO.SectionVO)((ArrayList)localObject).get(j)).boardList != null)
        {
        	param.append("<DIV class=\"mainbox forumlist\">\n");
        	param.append("<H3><A href=\"./index.jsp?sid=").append(localSectionVO.sectionID).append("\">").append(localSectionVO.sectionName).append("</A></H3>\n");
        	param.append("<TABLE id=\"section_").append(j).append("\" cellSpacing=0 cellPadding=0>\n");
          str2 = "./forums-" + localSectionVO.sectionID;
          param.append("<TBODY><TR>\n");
          param.append("<TH width=\"").append(str3).append("\">\n");
          param.append("<H2><A href=\"./index.jsp?sid=").append(localSectionVO.sectionID).append("\" id=\"g_").append(localSectionVO.sectionID).append("_name\">").append(str4).append('_').append(localSectionVO.sectionName).append("</A></H2>\n");
          param.append("<P style=\"margin-bottom:2px\">").append("包含本分区所有版块的&nbsp;RSS&nbsp;地址列表</P>\n");
          param.append("<P class=\"moderators\">").append("<IMG src=\"images/opml.gif\" border=0 align=absmiddle>&nbsp;\n");
          param.append("-&nbsp; <A href=\"").append(str2).append("-0.xml\" target=_blank>标题式</A>&nbsp;\n");
          param.append("-&nbsp; <A href=\"").append(str2).append("-1.xml\" target=_blank id=\"g_").append(localSectionVO.sectionID).append("_url\">全文式</A>&nbsp;\n");
          if (paramBoolean)
        	  param.append("-&nbsp; <A href=\"javascript:subGroup('g_").append(localSectionVO.sectionID).append("')\">订阅</A>");
          param.append("</P></TH>\n");
          int k = localSectionVO.boardList.size();
          int l = 0;
          for (int i1 = 0; i1 < k; ++i1){
            if ((localBoardVO = (BoardDAO.BoardVO)localSectionVO.boardList.get(i1)).state != 'I')
            {
              localStringBuilder.setLength(0);
              localStringBuilder.append("./forum-").append(localSectionVO.sectionID).append("-").append(localBoardVO.boardID);
              str1 = localStringBuilder.toString() + "-1.html";
              str2 = localStringBuilder.toString();
              if ((l + 1) % 3 == 0)
            	  param.append("<TBODY><TR>\n");
              param.append("<TH width=\"").append(str3).append("\">\n");
              param.append("<H2><A href=\"").append(str1).append("\" id=\"c_").append(localBoardVO.boardID).append("_name\">").append(localBoardVO.boardName).append("</A></H2>\n");
              param.append("<P style=\"margin-bottom:2px\">主题: ").append(localBoardVO.topics).append(", 帖数: ").append(localBoardVO.posts);
              if ((localBoardVO.allowGroups == null) || (localBoardVO.allowGroups.indexOf(71) < 0))
            	  param.append(" &nbsp;(&nbsp;私密&nbsp;)");
              param.append("</P>\n");
              param.append("<P class=\"moderators\">").append("<IMG src=\"images/rss.gif\" border=0 align=absmiddle>&nbsp;\n");
              param.append("-&nbsp; <A href=\"").append(str2).append("-0.xml\" target=_blank>标题式</A>&nbsp;\n");
              param.append("-&nbsp; <A href=\"").append(str2).append("-1.xml\" target=_blank id=\"c_").append(localBoardVO.boardID).append("_url\">全文式</A>&nbsp;\n");
              if (paramBoolean)
            	  param.append("-&nbsp; <A href=\"javascript:subChannel('c_").append(localBoardVO.boardID).append("')\">订阅</A>");
              param.append("</P></TH>\n");
              if ((l + 2) % 3 == 0)
            	  param.append("</TR></TBODY>\n");
              ++l;
            }
          if ((i1 = 3 - (l + 1) % 3) < 3)
          {
            for (int i = 0; i < i1; ++i)
            	param.append("<TH width=\"").append(str3).append("\" style=\"BACKGROUND-IMAGE:none\">&nbsp;</TH>");
            param.append("</TR></TBODY>\n");
          }
          param.append("</TABLE></DIV>\n");
        }
        }
    }
    return ((String)paramString.toString());
  }

  public static String getHeader(HttpServletRequest paramHttpServletRequest, String paramString)
  {
    StringBuilder localStringBuilder;
    String str = paramHttpServletRequest.getContextPath()+"/ejforum";
    Object localObject = (ForumSetting.getInstance()).getString(1, "forumLogo");
    String  param= getForumURL(paramHttpServletRequest);
    (localStringBuilder = new StringBuilder()).append("<H2>");
    if (((String)localObject).indexOf(".swf") > 0)
    {
      String[] paramS = ((String)localObject).split(",");
      param = param + "images/" + paramS[0];
      str = null;
      localObject = null;
      if (paramS.length > 2)
      {
        str = paramS[1];
        localObject = paramS[2];
      }
      else
      {
        str = "120";
        localObject = "60";
      }
      localStringBuilder.append("<SCRIPT type=text/javascript>").append("showFlash('").append(paramHttpServletRequest).append("','").append(str).append("','").append((String)localObject).append("');</SCRIPT>");
    }
    else
    {
      localStringBuilder.append("<A href=\"").append(str).append("/\"><IMG alt=\"").append(paramString).append("\" src=\"").append(str).append("/images/").append((String)localObject).append("\" border=0></A>");
    }
    localStringBuilder.append("</H2>");
    return ((String)localStringBuilder.toString());
  }

  public static String[] getHeaderMenu(HttpServletRequest paramHttpServletRequest, UserDAO.UserInfo paramUserInfo)
  {
    StringBuilder localStringBuilder;
    Object localObject;
    String[] arrayOfString = new String[3];
    String str = paramHttpServletRequest.getContextPath()+"/ejforum";
    (localStringBuilder = new StringBuilder()).append("<DIV id=headermenu><UL>");
    if (paramUserInfo != null)
    {
    	Object sessionObj = paramHttpServletRequest.getSession(false);
      localObject = null;
      if (sessionObj != null)
        localObject = (String)((HttpSession )sessionObj).getAttribute("token");
      localStringBuilder.append("<LI><CITE><A href=\"").append(str).append("/uspace.jsp?uid=").append(paramUserInfo.userID).append("\">").append(paramUserInfo.userID).append("</A></CITE></LI>\n");
      localStringBuilder.append("<LI><A href=\"").append(str).append("/perform.jsp?act=lgt");
      if (localObject != null)
        localStringBuilder.append("&sid=").append((String)localObject);
      localStringBuilder.append("\">退出</A></LI>\n");
      localStringBuilder.append("<LI><A href=\"").append(str).append("/member/sms_list.jsp\">短消息");
      if (paramUserInfo.unreadSMs > 0)
        localStringBuilder.append("<B>(").append(paramUserInfo.unreadSMs).append(")</B>");
      localStringBuilder.append("</A></LI>\n");
    }
    else
    {
      localStringBuilder.append("<LI><A href=\"").append(str).append("/register.jsp\">注册</A></LI>\n");
      localStringBuilder.append("<LI><A href=\"").append(str).append("/login.jsp\">登录</A></LI>\n");
    }
    localStringBuilder.append("<LI><A href=\"").append(str).append("/feeds.jsp").append("\">订阅</A></LI>\n");
    GroupDAO.GroupVO groupVO=getGroupVO(paramUserInfo);
    if ((groupVO).rights.indexOf(66) >= 0)
      localStringBuilder.append("<LI><A href=\"").append(str).append("/userlist.jsp").append("\">会员列表</A></LI>\n");
    localStringBuilder.append("<LI><A href=\"").append(str).append("/advsearch.jsp").append("\">搜索</A></LI>\n");
    if (paramUserInfo != null)
      localStringBuilder.append("<LI class=dropmenu id=myspace onmouseover='showMenu(this.id)'").append(" style='BACKGROUND-POSITION:94%'><A href=\"").append(str).append("/member/my_topics.jsp\">我的空间</A></LI>\n");
    if (groupVO.rights.indexOf(68) >= 0)
      localStringBuilder.append("<LI class=dropmenu id=stats onmouseover='showMenu(this.id)'").append(" style='BACKGROUND-POSITION:94%'><A href=\"").append(str).append("/stat/baseinfo.jsp").append("\">统计</A></LI>\n");
    if ((paramUserInfo != null) && (groupVO.groupType == 'S'))
      localStringBuilder.append("<LI><A href=\"").append(str).append("/admin/login.jsp").append("\" target=\"_blank\">后台管理</A></LI>\n");
    localStringBuilder.append("<LI><A href=\"").append(str).append("/help/index.jsp\">帮助</A></LI>");
    if (((localObject = (ForumSetting.getInstance()).getString(3, "tsExchange")).equals("chs")) || (((String)localObject).equals("cht")))
      localStringBuilder.append("<LI><A name=\"StranLink\" id=\"StranLink\">繁體中文</A></LI>");
    localStringBuilder.append("</UL></DIV>\n");
    arrayOfString[0] = localStringBuilder.toString();
    if (paramUserInfo != null)
    {
      (localStringBuilder = new StringBuilder()).append("<UL class=\"popmenu_popup headermenu_popup\"").append(" id=myspace_menu style=\"DISPLAY: none;\">\n");
      localStringBuilder.append("<LI><A href=\"").append(str).append("/uspace.jsp?uid=").append(paramUserInfo.userID).append("\">个人信息页</A></LI>\n");
      localStringBuilder.append("<LI><A href=\"").append(str).append("/member/my_profile.jsp\">编辑个人资料</A></LI>\n");
      localStringBuilder.append("<LI><A href=\"").append(str).append("/member/sms_list.jsp\">短消息</A></LI>\n");
      localStringBuilder.append("<LI><A href=\"").append(str).append("/member/my_topics.jsp\">我的话题</A></LI>\n");
      localStringBuilder.append("<LI><A href=\"").append(str).append("/member/my_favors.jsp\">我的收藏</A></LI>\n");
      localStringBuilder.append("<LI><A href=\"").append(str).append("/member/my_friends.jsp\">我的好友</A></LI>");
      localStringBuilder.append("<LI><A href=\"").append(str).append("/member/my_rights.jsp\">我的权限</A></LI>\n");
      localStringBuilder.append("<LI><A href=\"").append(str).append("/member/my_credits.jsp\">积分交易记录</A></LI>\n");
      localStringBuilder.append("</UL>");
      arrayOfString[1] = localStringBuilder.toString();
    }
    if (groupVO.rights.indexOf(68) >= 0)
    {
      (localStringBuilder = new StringBuilder()).append("<UL class=\"popmenu_popup headermenu_popup\"").append(" id=stats_menu style=\"DISPLAY: none;\">\n");
      localStringBuilder.append("<LI><A href=\"").append(str).append("/stat/baseinfo.jsp\">基本概况</A> </LI>\n");
      localStringBuilder.append("<LI><A href=\"").append(str).append("/stat/flux.jsp\">访问量记录</A> </LI>\n");
      localStringBuilder.append("<LI><A href=\"").append(str).append("/stat/top_boards.jsp\">版块排行</A> </LI>\n");
      localStringBuilder.append("<LI><A href=\"").append(str).append("/stat/top_topics.jsp\">主题排行</A> </LI>\n");
      localStringBuilder.append("<LI><A href=\"").append(str).append("/stat/top_credits_users.jsp\">积分排行</A> </LI>\n");
      localStringBuilder.append("<LI><A href=\"").append(str).append("/stat/admins.jsp\">管理团队</A> </LI>");
      localStringBuilder.append("</UL>");
      arrayOfString[2] = localStringBuilder.toString();
    }
    return (arrayOfString);
  }

  public static String getFooter(HttpServletRequest paramHttpServletRequest, String paramString)
  {
    ForumSetting localForumSetting;
    Object localObject1=null;
    StringBuilder localStringBuilder;
    String str1 = (localForumSetting = ForumSetting.getInstance()).getString(1, "timezone");
    String str2 = localForumSetting.getString(1, "footerMailAddr");
    String str3 = localForumSetting.getString(1, "siteUrl");
    String str5 = localForumSetting.getString(1, "certCode");
    String str6 = localForumSetting.getString(3, "showStyleList");
    Object localObject2 = (localForumSetting.getString(1, "dateFormat")).replace("mm", "MM");
    localObject2 = new SimpleDateFormat(localObject2 + " HH:mm");
    (localStringBuilder = new StringBuilder()).append("<DIV id=footer><DIV class=wrap><DIV id=footlinks>");
    localStringBuilder.append("<P>当前时区&nbsp;GMT");
    if (str1.indexOf(45) < 0)
      localStringBuilder.append("+");
    localStringBuilder.append(str1).append(", 现在时间是&nbsp;");
    localStringBuilder.append(((SimpleDateFormat)localObject2).format(new Date())).append("</P>\n<P>");
    int i = 1;
    if (str2.length() > 0)
    {
      localStringBuilder.append("<A href=\"mailto:");
      localStringBuilder.append(str2);
      localStringBuilder.append("\">联系我们</A>");
      i = 0;
    }
    if (str3.length() > 0)
    {
      if (i == 0)
        localStringBuilder.append("&nbsp;-&nbsp;");
      localStringBuilder.append("<A href=\"");
      localStringBuilder.append(str3);
      localStringBuilder.append("\" target=_blank>").append(localForumSetting.getString(1, "website")).append("</A>");
      i = 0;
    }
    if (str5.length() > 0)
    {
      if (i == 0)
        localStringBuilder.append("&nbsp;-&nbsp;");
      localStringBuilder.append("<A href=\"http://www.miibeian.gov.cn\" target=_blank>").append(str5).append("</A>");
      i = 0;
    }
    if (i == 0)
      localStringBuilder.append("&nbsp;-&nbsp;");
    localStringBuilder.append("<span class=\"scrolltop\" title=\"顶部\" onclick=\"").append("window.scrollTo(0,0);\">TOP</span>");
    if (str6.equals("yes"))
    {
      localStringBuilder.append("&nbsp;-&nbsp;");
      localStringBuilder.append("<SPAN class=dropmenu id=stylelist onmouseover=showMenu(this.id)").append(" style=\"BACKGROUND-POSITION:105% 45%\">界面风格</SPAN>\n");
      localStringBuilder.append("<DIV class=popmenu_popup id=stylelist_menu style=\"DISPLAY: none\"><UL>\n");
      OptionVO[] vo = localForumSetting.getStyles();
      if ((vo) != null)
      {
        str2 = null;
        for (int j = 0; j < vo.length; ++j)
          if (vo[j].name.charAt(0) == '1')
          {
            if ((str2 = vo[j].name.substring(2)).equals(paramString))
              localStringBuilder.append("<LI class=current>");
            else
              localStringBuilder.append("<LI>");
            localStringBuilder.append("<A href=\"javascript:changeStyle('");
            localStringBuilder.append(str2).append("')\">");
            localStringBuilder.append(vo[j].value);
            localStringBuilder.append("</A></LI>");
          }
      }
      localStringBuilder.append("</UL></DIV>");
    }
    localStringBuilder.append("</P></DIV>\n");
    localStringBuilder.append("<P class=copyright> Powered by <STRONG><A href=\"").append("http://www.inspur.com/\" target=_blank>");
    localStringBuilder.append("Inspur</A></STRONG> <EM>").append("2.3").append("</EM> &copy; 2005-").append(Calendar.getInstance().get(1));
  //  localStringBuilder.append(" <A\n href=\"http://www.hongshee.com/\"").append(" target=_blank>Hongshee software</A></P>");
    if ((localForumSetting.getString(5, "footRemark")).length() > 0)
      localStringBuilder.append("<P id=footnote>").append((String)localObject1).append("</P>");
    localStringBuilder.append("</DIV></DIV>");
    if (((str2 = localForumSetting.getString(3, "tsExchange")).equals("chs")) || (str2.equals("cht")))
    {
      String str4 = paramHttpServletRequest.getContextPath()+"/ejforum";
      localStringBuilder.append("<script src=\"").append(str4).append("/js/ts_exchange.js\" type=\"text/javascript\"></script>\n");
      localStringBuilder.append("<script type=\"text/javascript\">");
      if (str2.equals("chs"))
        localStringBuilder.append("var Default_isFT = 0;");
      else
        localStringBuilder.append("var Default_isFT = 1;");
      localStringBuilder.append("addLoadEvent(ts_exchange_init);");
      localStringBuilder.append("</script>\n");
    }
    return ((String)(String)localStringBuilder.toString());
  }

  public static String getHeadAdBanner(HttpServletRequest paramHttpServletRequest, BoardDAO.BoardVO paramBoardVO)
  {
	  StringBuilder param = new StringBuilder();
    if ((paramBoardVO != null) && (paramBoardVO.headAdCode != null) && (paramBoardVO.headAdCode.length() > 0))
    	param.append("<DIV id=ad_headerbanner>").append(paramBoardVO.headAdCode).append("</DIV>");
    else if (( (ForumSetting.getInstance()).getString(5, "headAdCode")).length() > 0)
    	param.append("<DIV id=ad_headerbanner>").append(paramBoardVO).append("</DIV>");
    return param.toString();
  }

  public static String getFootAdBanner(HttpServletRequest paramHttpServletRequest, BoardDAO.BoardVO paramBoardVO)
  {
	  StringBuilder param = new StringBuilder();
    if ((paramBoardVO != null) && (paramBoardVO.footAdCode != null) && (paramBoardVO.footAdCode.length() > 0))
    	param.append("<DIV id=ad_footerbanner>").append(paramBoardVO.footAdCode).append("</DIV>");
    else if ((( ForumSetting.getInstance()).getString(5, "footAdCode")).length() > 0)
    	param.append("<DIV id=ad_footerbanner>").append(paramBoardVO).append("</DIV>");
    return param.toString();
  }

  public static String getAdminFooter(HttpServletRequest paramHttpServletRequest)
  {

	  StringBuilder param = new StringBuilder();
    (param).append("<DIV class=footer><HR width=\"100%\" noShade size=0>\n");
    param.append("Powered by <A style=\"color:#666666\" href=\"").append("http://www.easyjforum.cn/\" target=_blank>");
    param.append("<B>EasyJForum</B></A> ").append("2.3").append(" &nbsp;&copy; 2005-").append(Calendar.getInstance().get(1));
    param.append(" <A\n style=\"color:#666666\" href=\"http://www.hongshee.com/\"").append(" target=_blank>Hongshee software</A></DIV>");
    return paramHttpServletRequest.toString();
  }

  public static String getSysMailFooter(HttpServletRequest paramHttpServletRequest)
  {
    StringBuilder localStringBuilder;
    (localStringBuilder = new StringBuilder()).append("<br><br>\n<a href=\"").append(getForumURL(paramHttpServletRequest)).append("\" target=\"_blank\">").append(ForumSetting.getInstance().getForumName()).append("</a><br>").append(AppUtils.getCurrentDateStr()).append("\n");
    return localStringBuilder.toString();
  }

  public static String getModeratorLink(String paramString)
  {
    Object localObject = null;
    String[] paramS = (paramString == null) ? null : paramString.split(",");
    if (((paramS) != null) && (paramS.length > 0))
    {
      localObject = new StringBuilder();
      for (int i = 0; i < paramS.length; ++i)
        if (paramS[i].length() != 0)
        {
          if (((StringBuilder)localObject).length() > 0)
            ((StringBuilder)localObject).append(", ");
          ((StringBuilder)localObject).append("<A href=\"uspace.jsp?uid=").append(paramS[i]);
          ((StringBuilder)localObject).append("\" target=\"_blank\">").append(paramS[i]).append("</A>");
        }
      localObject = ((StringBuilder)localObject).toString();
    }
    return ((String)localObject);
  }

  public static int getIntValue(String[] paramArrayOfString, int paramInt1, int paramInt2)
  {
    paramInt2 = paramInt2;
    if (paramArrayOfString.length > paramInt1)
      try
      {
        paramInt2 = Integer.parseInt(paramArrayOfString[paramInt1]);
      }
      catch (Exception localException)
      {
      }
    return paramInt2;
  }

  public static int getPageNo(String paramString)
  {
    if ((paramString == null) || (paramString.equals(c)))
      paramString = "1";
    int i = 1;
    try
    {
      i = Integer.parseInt(paramString);
    }
    catch (Exception localException)
    {
    }
    if (i < 1)
      i = 1;
    return i;
  }

  public static String getPageHTMLStr(int paramInt1, int paramInt2, int paramInt3, int paramInt4)
  {
    return getPageHTMLStr(paramInt1, paramInt2, paramInt3, paramInt4, null);
  }

  public static String getPageHTMLStr(int paramInt1, int paramInt2, int paramInt3, int paramInt4, String paramString)
  {
    StringBuilder localStringBuilder;
    paramInt3 = (paramInt1 - 1) / paramInt3 + 1;
    int i = 1;
    if (paramInt2 > 10)
      i = paramInt2 - 9;
    if ((paramInt3 > paramInt4) && (paramInt4 != 0))
      paramInt3 = paramInt4;
    if ((paramInt4 = i + 9) > paramInt3)
      paramInt4 = paramInt3;
    (localStringBuilder = new StringBuilder("<DIV class=pages>")).append("<EM>&nbsp;").append(paramInt1).append("&nbsp;</EM>");
    if (paramInt2 > 1)
      if (paramString == null)
      {
        localStringBuilder.append("<a href=\"javascript:viewPage('");
        localStringBuilder.append(paramInt2 - 1);
        localStringBuilder.append("');\" class=\"prev\">&nbsp;&lsaquo;&lsaquo;&nbsp;</a>");
      }
      else
      {
        localStringBuilder.append("<a href=\"").append(paramString);
        localStringBuilder.append("&page=").append(paramInt2 - 1);
        localStringBuilder.append("\" class=\"prev\">&nbsp;&lsaquo;&lsaquo;&nbsp;</a>");
      }
    for (paramInt1 = i; paramInt1 <= paramInt4; ++paramInt1)
      if (paramInt1 == paramInt2)
      {
        localStringBuilder.append("<strong>&nbsp;").append(paramInt1).append("&nbsp;</strong>");
      }
      else if (paramString == null)
      {
        localStringBuilder.append("<a href=\"javascript:viewPage('");
        localStringBuilder.append(paramInt1);
        localStringBuilder.append("');\">&nbsp;");
        localStringBuilder.append(paramInt1);
        localStringBuilder.append("&nbsp;</a>");
      }
      else
      {
        localStringBuilder.append("<a href=\"").append(paramString);
        localStringBuilder.append("&page=").append(paramInt1);
        localStringBuilder.append("\">&nbsp;");
        localStringBuilder.append(paramInt1);
        localStringBuilder.append("&nbsp;</a>");
      }
    if (paramInt4 < paramInt3)
      if (paramString == null)
      {
        localStringBuilder.append("<a href=\"javascript:viewPage('");
        localStringBuilder.append(paramInt3);
        localStringBuilder.append("');\">...&nbsp;");
        localStringBuilder.append(paramInt3);
        localStringBuilder.append("&nbsp;</a>");
      }
      else
      {
        localStringBuilder.append("<a href=\"").append(paramString);
        localStringBuilder.append("&page=").append(paramInt3);
        localStringBuilder.append("\">...&nbsp;");
        localStringBuilder.append(paramInt3);
        localStringBuilder.append("&nbsp;</a>");
      }
    if (paramInt2 < paramInt3)
      if (paramString == null)
      {
        localStringBuilder.append("<a href=\"javascript:viewPage('");
        localStringBuilder.append(paramInt2 + 1);
        localStringBuilder.append("');\" class=\"next\">&nbsp;&rsaquo;&rsaquo;&nbsp;</a>");
      }
      else
      {
        localStringBuilder.append("<a href=\"").append(paramString);
        localStringBuilder.append("&page=").append(paramInt2 + 1);
        localStringBuilder.append("\" class=\"next\">&nbsp;&rsaquo;&rsaquo;&nbsp;</a>");
      }
    localStringBuilder.append("</DIV>");
    return localStringBuilder.toString();
  }

  public static String decodeParam(String paramString, HttpServletRequest paramHttpServletRequest)
  {
    if ((paramString = paramString) != null)
    {
      paramString = paramString.trim();
      String param = paramHttpServletRequest.getCharacterEncoding();
     // if ((((param) != null) && (!(param.equalsIgnoreCase("ISO-8859-1")))) || (paramString.length() <= 0))
      
    }else {
        try
        {
          paramString = new String(paramString.getBytes("ISO-8859-1"), "GBK");
        }
        catch (Exception localException)
        {
          paramString = c;
        }
	}
    return paramString;
  }

  public static String decodeAttr(String paramString)
  {
    if ((paramString = paramString) != null)
      if ((paramString = paramString.trim()).length() <= 0)
    	    return paramString;
    try
    {
      paramString = new String(paramString.getBytes("ISO-8859-1"), "GBK");
    }
    catch (Exception localException)
    {
      paramString = c;
    }
    return paramString;
  }

  public static String getParam(HttpServletRequest paramHttpServletRequest, String paramString)
  {
    return decodeParam(paramHttpServletRequest.getParameter(paramString), paramHttpServletRequest);
  }

  public static int getIntParam(HttpServletRequest paramHttpServletRequest, String paramString)
  {
	String paramString2=paramHttpServletRequest.getParameter(paramString);
    if (((paramString2 ) == null) || (paramString2.trim().length() == 0))
      return 0;
    return Integer.parseInt(paramString2);
  }

  public static String getHTMLParam(HttpServletRequest paramHttpServletRequest, String paramString)
  {
    return decodeParam(paramHttpServletRequest.getParameter(paramString), paramHttpServletRequest).replace("\"", "&quot;").replace("<", "&lt;").replace(">", "&gt;");
  }

  public static String[] getParamValues(HttpServletRequest paramHttpServletRequest, String paramString)
  {
		String[] paraString1=paramHttpServletRequest.getParameterValues(paramString);
    if (paraString1 != null)
      for (int i = 0; i < paraString1.length; ++i)
    	  paraString1[i] = decodeParam(paraString1[i], paramHttpServletRequest);
    return paraString1;
  }

  public static String getQueryFields(HttpServletRequest paramHttpServletRequest)
    throws Exception
  {
    StringBuilder localStringBuilder = new StringBuilder();
    String str = null;
    String[] arrayOfString = null;
    Enumeration localEnumeration = paramHttpServletRequest.getParameterNames();
    while (localEnumeration.hasMoreElements())
      if ((!((str = (String)(String)localEnumeration.nextElement()).equals("page"))) && (!(str.startsWith("exe_"))))
        if (((arrayOfString = paramHttpServletRequest.getParameterValues(str)) != null) && (arrayOfString.length > 0))
          for (int i = 0; i < arrayOfString.length; ++i)
            if ((arrayOfString[i] != null) && (arrayOfString[i].length() > 0))
              localStringBuilder.append("<input type=hidden name=\"").append(str).append("\"").append(" value=\"").append(decodeParam(arrayOfString[i], paramHttpServletRequest).replace("\"", "&quot;")).append("\">\n");
    return localStringBuilder.toString();
  }

  public static GroupDAO.GroupVO getGroupVO(UserDAO.UserInfo paramUserInfo)
  {
    CacheManager localCacheManager = CacheManager.getInstance();
    return getGroupVO(paramUserInfo, localCacheManager.getModerators());
  }

  public static GroupDAO.GroupVO getGroupVO(String paramString1, char paramChar, int paramInt, String paramString2)
  {
    Object localObject = null;
    localObject = CacheManager.getInstance();
    if ((paramString1 != null) && (paramString1.length() > 0))
      if (paramChar == 'A')
        localObject = ((CacheManager)localObject).getGroup(paramChar);
      else if (paramString2.indexOf("," + paramString1.toLowerCase() + ",") >= 0)
        if (paramChar <= '9')
          localObject = ((CacheManager)localObject).getGroup('M');
        else
          localObject = ((CacheManager)localObject).getGroup(paramChar);
      else
        localObject = ((CacheManager)localObject).getGroup(paramInt);
    else
      localObject = ((CacheManager)localObject).getGroup('G');
    return ((GroupDAO.GroupVO)localObject);
  }

  public static GroupDAO.GroupVO getGroupVO(UserDAO.UserInfo paramUserInfo, SectionDAO.SectionVO paramSectionVO, BoardDAO.BoardVO paramBoardVO)
  {
    Object localObject = null;
    localObject = CacheManager.getInstance();
    if (paramUserInfo == null)
    {
      localObject = ((CacheManager)localObject).getGroup('G');
    }
    else
    {
      localObject = getGroupVO(paramUserInfo.userID, paramUserInfo.groupID, paramUserInfo.credits, getModerators(paramSectionVO, paramBoardVO));
    }
    return ((GroupDAO.GroupVO)localObject);
  }

  public static GroupDAO.GroupVO getGroupVO(UserDAO.UserInfo paramUserInfo, String paramString)
  {
    Object localObject = null;
    localObject = CacheManager.getInstance();
    if (paramUserInfo == null)
      localObject = ((CacheManager)localObject).getGroup('G');
    else
      localObject = getGroupVO(paramUserInfo.userID, paramUserInfo.groupID, paramUserInfo.credits, paramString);
    return ((GroupDAO.GroupVO)localObject);
  }

  public static String getModerators(SectionDAO.SectionVO paramSectionVO, BoardDAO.BoardVO paramBoardVO)
  {
    StringBuilder localStringBuilder = new StringBuilder(",");
    if (paramSectionVO.moderator != null)
      localStringBuilder.append(paramSectionVO.moderator).append(',');
    if ((paramBoardVO != null) && (paramBoardVO.moderator != null))
      localStringBuilder.append(paramBoardVO.moderator).append(',');
    return localStringBuilder.toString();
  }

  public static boolean isPermitted(BoardDAO.BoardVO paramBoardVO, GroupDAO.GroupVO paramGroupVO, char paramChar)
  {
	  boolean i = false;
    if (paramGroupVO.rights.indexOf(paramChar) >= 0)
    {
      i = true;
      if (paramBoardVO.acl != null){
        if ((paramBoardVO.acl.indexOf(paramChar + "_")) >= 0)
        {
          int j;
          String str;
          Object localObject = null;
          if ((j = paramBoardVO.acl.indexOf(44, paramChar)) > 0)
            str = paramBoardVO.acl.substring(paramChar + '\1', j);
          else
            str = paramBoardVO.acl.substring(paramChar + '\1');
          if (str.indexOf(paramGroupVO.groupID) < 0)
            i = false;
        }
      }
    }
    return i;
  }

  public static String getRelativePath(String paramString)
  {
    int i;
    String str;
    Object localObject = null;
    if ((i = paramString.indexOf("://")) > 0)
      if ((i = paramString.indexOf("/", i + 3)) > 0)
        str = paramString.substring(i);
      else
        str = "/";
    else
      str = paramString;
    return str;
  }

  public static String getRootPath(String paramString)
  {
    int i;
    String str;
    Object localObject = null;
    if ((i = paramString.indexOf("://")) > 0)
      if ((i = paramString.indexOf("/", i + 3)) > 0)
        str = paramString.substring(0, i);
      else
        str = paramString;
    else
      str = c;
    return str;
  }

  public static String getForumURL(HttpServletRequest paramHttpServletRequest)
  {
    if ((b == null) && (paramHttpServletRequest != null))
      b = getRootPath(paramHttpServletRequest.getRequestURL().toString()) + paramHttpServletRequest.getContextPath()+"/ejforum" + "/";
    return b;
  }

  public static String getForumStyle(HttpServletRequest paramHttpServletRequest, HttpServletResponse paramHttpServletResponse, BoardDAO.BoardVO paramBoardVO)
  {
    String str;
    Cookie localCookie;
    if (((str = paramHttpServletRequest.getParameter("style")) == null) || (str.length() == 0))
    {
      if ((localCookie = getCookie(paramHttpServletRequest, "ejf_cssid")) != null)
        str = localCookie.getValue();
      if ((str == null) || (str.length() == 0) || (str.equals("default")))
      {
        if ((paramBoardVO != null) && (paramBoardVO.viewStyle != null))
          str = paramBoardVO.viewStyle;
        if ((str == null) || (str.length() == 0) || (str.equals("default")))
          str = ForumSetting.getInstance().getDefaultStyle();
      }
      else if ((!(str.equals("default"))) && (!(ForumSetting.getInstance().isExistedStyle(str))))
      {
        str = ForumSetting.getInstance().getDefaultStyle();
        Cookie cookie=new Cookie("ejf_cssid", str);
        (cookie).setMaxAge(0);
        cookie.setPath(paramHttpServletRequest.getContextPath()+"/ejforum");
        paramHttpServletResponse.addCookie(cookie);
      }
    }
    else
    {
      (localCookie = new Cookie("ejf_cssid", str)).setMaxAge(315360000);
      localCookie.setPath(paramHttpServletRequest.getContextPath()+"/ejforum");
      paramHttpServletResponse.addCookie(localCookie);
    }
    return str;
  }

  public static String getPathFromReferer(HttpServletRequest paramHttpServletRequest)
  {
    String str1 = null;
    if ((str1 = paramHttpServletRequest.getHeader("referer")) != null)
    {
      String str2;
      if ((str2 = getRootPath(str1)).indexOf(paramHttpServletRequest.getServerName()) > 0)
        str1 = getRelativePath(str1);
      else
        str1 = "/";
    }
    else
    {
      str1 = "/";
    }
    return str1;
  }

  public static void checkReferer(HttpServletRequest paramHttpServletRequest)
    throws Exception
  {
    String str;
    if ((str = paramHttpServletRequest.getHeader("referer")) != null)
      if ((str = getRootPath(str)).indexOf(paramHttpServletRequest.getServerName()) < 0)
        throw new AppException("Illegal request");
  }

  public static boolean isUserAgent(HttpServletRequest paramHttpServletRequest)
  {
    String str;
    boolean i = false;
    if (((str = paramHttpServletRequest.getHeader("referer")) != null) && (str.length() > 0)){
    	String param = paramHttpServletRequest.getHeader("User-Agent");
      if (((param) != null) && (((param.indexOf("MSIE") >= 0) || (param.indexOf("Gecko") >= 0) || (param.indexOf("Opera") >= 0) || (param.indexOf("Chrome") >= 0) || (param.indexOf("Safari") >= 0))))
        i = true;
    }
    return i;
  }

  public static boolean isUserAgent2(HttpServletRequest paramHttpServletRequest)
  {
	    boolean i = false;
    String paramString= paramHttpServletRequest.getHeader("User-Agent");
    if (((paramString) != null) && (((paramString.indexOf("MSIE") >= 0) || (paramString.indexOf("Gecko") >= 0) || (paramString.indexOf("Opera") >= 0) || (paramString.indexOf("Chrome") >= 0) || (paramString.indexOf("Safari") >= 0))))
    	i = true;
    return i;
  }

  public static void checkIP(String paramString, HttpSession paramHttpSession)
    throws Exception
  {
    int i = 1;
    if ((paramString == null) || (paramString.length() == 0))
    {
      i = 0;
    }
    else
    {
      Object localObject;
      if ((localObject = (Integer)paramHttpSession.getAttribute("ipOK")) == null)
      {
        int j;
        String[] arrayOfString2;
        if (((arrayOfString2 = (ForumSetting.getInstance()).getAllowedIPs()).length > 0) && (arrayOfString2[0].length() > 0))
        {
          i = 0;
          for (j = 0; j < arrayOfString2.length; ++j)
            if ((arrayOfString2[j].length() > 0) && (paramString.startsWith(arrayOfString2[j])))
            {
              i = 1;
              paramHttpSession.setAttribute("ipOK", Integer.valueOf(1));
            }
        }
        else
        {
          String[] arrayOfString1 = ForumSetting.getInstance().getBannedIPs();
          for (int k = 0; k < arrayOfString1.length; ++k)
            if ((arrayOfString1[k].length() > 0) && (paramString.startsWith(arrayOfString1[k])))
            {
              i = 0;
              break;
            }
        }
        if (i != 0)
          label152: paramHttpSession.setAttribute("ipOK", Integer.valueOf(1));
      }
    }
    if (i == 0)
    {
      paramHttpSession.invalidate();
      throw new AppException("此 IP 地址对本论坛的访问已被禁止");
    }
  }

  public static void checkAdminIP(HttpServletRequest paramHttpServletRequest)
    throws Exception
  {
    Object localObject;
    String[] allowedAdminIPs=ForumSetting.getInstance().getAllowedAdminIPs();
    if (((allowedAdminIPs).length > 0) && (allowedAdminIPs[0].length() > 0))
    {
      int i = 0;
      String param = getRemoteAddr(paramHttpServletRequest);
      for (int j = 0; j < allowedAdminIPs.length; ++j)
        if ((allowedAdminIPs[j].length() > 0) && (param.startsWith(allowedAdminIPs[j])))
        {
          i = 1;
          break;
        }
      if (i == 0)
        throw new AppException("此 IP 地址对后台管理的访问已被禁止");
    }
  }

  public static String getRemoteAddr(HttpServletRequest paramHttpServletRequest)
  {
    String str;
    if ((str = paramHttpServletRequest.getHeader("x-forwarded-for")) == null)
    {
      str = paramHttpServletRequest.getRemoteAddr();
    }
    else
    {
      if ((str.lastIndexOf(44)) >= 0)
        str = str.substring(str.lastIndexOf(44) + 1);
      str = str.trim();
    }
    if ((str == null) || (str.length() == 0))
      str = "0.0.0.0";
    return str;
  }

  public static Cookie getCookie(HttpServletRequest paramHttpServletRequest, String paramString)
  {
    Object localObject = null;
    Cookie[] cookies=paramHttpServletRequest.getCookies();
    if ((cookies) != null)
      for (int i = 0; i < cookies.length; ++i)
        if (cookies[i].getName().equals(paramString))
        {
          localObject = cookies[i];
          break;
        }
    return (Cookie) localObject;
  }

  public static UserDAO.UserInfo getSessionUser(HttpServletRequest paramHttpServletRequest)
    throws Exception
  {
    Object localObject1 = paramHttpServletRequest.getSession();
    Object localObject2 =null;
    checkIP(getRemoteAddr(paramHttpServletRequest), (HttpSession)localObject1);
    if ((isUserAgent2(paramHttpServletRequest)) && (((HttpSession)localObject1).getAttribute("isAgent") == null))
    {
      ((HttpSession)localObject1).setAttribute("isAgent", "true");
      AppContext.getInstance().incSessionCount();
      AppContext.getInstance().setTopOnlines();
    }
    if ((localObject1 = (UserDAO.UserInfo)((HttpSession)localObject1).getAttribute("userinfo")) == null)
      try
      {
        UserDAO localUserDAO;
        long l;
        if ((localObject2 = getCookie(paramHttpServletRequest, "ejf_lsessid")) == null)
        	return ((UserDAO.UserInfo)(UserDAO.UserInfo)localObject1);
        String[] param= AppUtils.decode32(((Cookie)localObject2).getValue()).split("\\|");
        if ((param).length != 2)
        	return ((UserDAO.UserInfo)(UserDAO.UserInfo)localObject1);
        if ((l = Long.parseLong(param[0])) <= System.currentTimeMillis())
        	return ((UserDAO.UserInfo)(UserDAO.UserInfo)localObject1);
        Object localObject3 = param[1];
        localObject1 = (localUserDAO = UserDAO.getInstance()).doQuickLogin((String)localObject3, l, paramHttpServletRequest);
      }
      catch (Exception localException)
      {
      }
    label140: return ((UserDAO.UserInfo)(UserDAO.UserInfo)localObject1);
  }

  public static UserDAO.UserInfo getLoginedUser(HttpServletRequest paramHttpServletRequest, HttpServletResponse paramHttpServletResponse)
    throws Exception
  {
    UserDAO.UserInfo localUserInfo;
    if ((localUserInfo = getSessionUser(paramHttpServletRequest)) == null)
    {
      String str2;
      String str1 = paramHttpServletRequest.getRequestURI();
      if ((str2 = paramHttpServletRequest.getQueryString()) != null)
        str1 = str1 + "?" + str2;
      paramHttpServletRequest.setAttribute("fromPath", str1);
      paramHttpServletRequest.getRequestDispatcher("/ejforum/login.jsp").forward(paramHttpServletRequest, paramHttpServletResponse);
    }
    else
    {
      checkReferer(paramHttpServletRequest);
    }
    return localUserInfo;
  }

  public static UserDAO.UserInfo getAdminUser(HttpServletRequest paramHttpServletRequest, HttpServletResponse paramHttpServletResponse)
    throws Exception
  {
    UserDAO.UserInfo localUserInfo;
    if ((localUserInfo = getLoginedUser(paramHttpServletRequest, paramHttpServletResponse)) == null)
      return null;
    if (localUserInfo.groupID == 'A')
      checkAdminIP(paramHttpServletRequest);
    if (!(localUserInfo.isAdminOn))
    {
      paramHttpServletRequest.removeAttribute("fromPath");
      paramHttpServletRequest.getRequestDispatcher("/admin/login.jsp").forward(paramHttpServletRequest, paramHttpServletResponse);
      return null;
    }
    return localUserInfo;
  }

  public static ArrayList<UserDAO.UserInfo> getSessionAdminUsers()
  {
    ArrayList localArrayList = new ArrayList();
    Object localObject1 = ( AppContext.getInstance().getSessions()).iterator();
    Object localObject2 = null;
    localObject2 = null;
    while (((Iterator)localObject1).hasNext()){
    	localObject2 = (UserDAO.UserInfo)((HttpSession)((Iterator)localObject1).next()).getAttribute("userinfo");
      if (((localObject2) != null) && (((UserDAO.UserInfo)localObject2).isAdminOn))
        localArrayList.add(localObject2);
  }
    return ((ArrayList<UserDAO.UserInfo>)(ArrayList<UserDAO.UserInfo>)localArrayList);
  }

  public static UserDAO.UserInfo getSessionUser(String paramString)
  {
    Object localObject1 = null;
    Object localObject2 = (AppContext.getInstance().getSessions()).iterator();
    Object localObject3 = null;
    localObject3 = null;
    while (((Iterator)localObject2).hasNext())
    	localObject3=(UserDAO.UserInfo)( (HttpSession)((Iterator)localObject2).next()).getAttribute("userinfo");
      if (((localObject3) != null) && (((UserDAO.UserInfo)localObject3).userID.equalsIgnoreCase(paramString)))
        localObject1 = localObject3;
    return ((UserDAO.UserInfo)(UserDAO.UserInfo)localObject1);
  }
}