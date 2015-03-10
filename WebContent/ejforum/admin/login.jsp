<%@ page contentType="text/html;charset=gbk"%>
<%@ page import="java.net.URLEncoder, java.net.URLDecoder"%>
<%@ page import="java.util.Calendar"%>
<%@ page import="com.hongshee.ejforum.util.PageUtils"%>
<%@ page import="com.hongshee.ejforum.data.UserDAO"%>
<%@ page import="com.hongshee.ejforum.data.UserDAO.UserInfo"%>
<%
	String msg = null;
	String info = null;
    String fromPath = null;
	String ctxPath = request.getContextPath()+"/ejforum";
	String adminPath = ctxPath + "/admin";
	String pageUrl = adminPath + "/login.jsp";
	
	UserInfo userinfo = PageUtils.getLoginedUser(request, response);
	if (userinfo == null) return;

    if (userinfo.groupID == 'A')
	    PageUtils.checkAdminIP(request);
	
	UserDAO dao = UserDAO.getInstance();
	if (dao.isAdminUser(userinfo))
	{
		String pwd = PageUtils.getParam(request,"adminpwd");
		if (pwd != null && pwd.length() > 0)  // Perform login
		{
			String result = dao.doAdminLogin(userinfo, pwd);
			if (result != null && result.equals("OK"))
			{
			    fromPath = (String)request.getParameter("fromPath");
				if (fromPath == null || fromPath.trim().length() == 0 || fromPath.trim().equals("/"))
					fromPath = ctxPath + "/admin/index.htm";
				else
					fromPath = URLDecoder.decode(fromPath);
				response.sendRedirect(fromPath);
				return;
			}
			else
			{
				info = "&nbsp;&nbsp;-&nbsp;&nbsp;" + result;
			}
		}
	}
	else
	{
		msg = "您没有权限访问后台管理。";
	}
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<HTML xmlns="http://www.w3.org/1999/xhtml">
<HEAD><TITLE>EasyJForum Administration Center</TITLE>
<META http-equiv=Content-Type content="text/html; charset=gbk">
<LINK href="<%= adminPath %>/style/login.css" type=text/css rel=stylesheet>
</HEAD>
<BODY>
<SCRIPT src="<%= ctxPath %>/js/common.js" type=text/javascript></SCRIPT>
<SCRIPT src="<%= ctxPath %>/js/md5.js" type=text/javascript></SCRIPT>
<SCRIPT language=JavaScript>
if(self.parent.frames.length != 0) {
	self.parent.location = "<%= pageUrl %>";
}
</SCRIPT>
<BR><BR><BR><BR><BR>
<TABLE class=logintable cellSpacing=0 cellPadding=8 width=550 border=0>
  <TBODY>
  <TR>
    <TD width=60></TD>
    <TD width=100></TD>
    <TD></TD>
    <TD width=120></TD>
    <TD width=60></TD></TR>
  <TR style="HEIGHT: 40px">
    <TD>&nbsp;</TD>
    <TD class=line1 colspan="3" style="padding-bottom:0px"><SPAN 
      style="FONT-WEIGHT: bold; FONT-SIZE: 14px; COLOR: #ffff99">后台管理<%= info==null?"":info %></SPAN></TD>
    <TD>&nbsp;</TD></TR>
  <TR>
    <TD colSpan=5>&nbsp;</TD></TR>
<%
	if (msg == null) {
%>	
  <FORM name=login onSubmit="checkfields(this); return false;" action="<%= adminPath %>/login.jsp" method=post>
  <INPUT type=hidden name=fromPath value="<%= fromPath==null?"":fromPath %>">
  <TR>
    <TD>&nbsp;</TD>
    <TD align=right>用户名:</TD>
    <TD><%= userinfo.userID %></TD><TD></TD>
    <TD>&nbsp;</TD></TR>
  <TR>
    <TD>&nbsp;</TD>
    <TD align=right valign="top">密 码:</TD>
    <TD valign="top"><INPUT type=password size=20 id=adminpwd1 name=adminpwd1><br/><br/>
	    <INPUT type=hidden id=adminpwd name=adminpwd></TD>
    <TD>&nbsp;</TD>
    <TD>&nbsp;</TD></TR>
  <TR>
    <TD>&nbsp;</TD>
    <TD class=line1>&nbsp;</TD>
    <TD class=line1><INPUT class=button type=submit value="提 交"/><br/><br/>
<SCRIPT language=JavaScript>
document.login.adminpwd1.focus();
function checkfields(theform) {
	if(trim($('adminpwd1').value) == '') {
		alert('密码不可以为空');return false;
	} else {
		$('adminpwd').value = hex_md5(trim($('adminpwd1').value)); 
		$('adminpwd1').value = '';
		theform.submit();return false;
	}
}
</SCRIPT>
    </TD>
    <TD class=line1>&nbsp;</TD>
    <TD>&nbsp;</TD></TR></FORM>
<%
	} else {
%>	
	<TR><TD>&nbsp;</TD><TD align="center" colspan="3" ><%= msg %><br/><br/><br/></TD><TD>&nbsp;</TD></TR>
<%
	}
%>	
  <TR>
    <TD align="center" colSpan=5 height="45">Powered by <A 
      href="http://www.easyjforum.cn/" target=_blank>EasyJForum</A> &nbsp;&copy; 
      2005-<%= Calendar.getInstance().get(Calendar.YEAR) %> <A href="http://www.hongshee.com/" 
      target=_blank>Hongshee software</A><br/><br/></TD></TR>
</TBODY></TABLE>
</BODY></HTML>
