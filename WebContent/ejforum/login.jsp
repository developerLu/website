<%@ page contentType="text/html;charset=gbk"%>
<%@ page import="java.net.URLEncoder"%>
<%@ page import="com.hongshee.ejforum.util.PageUtils"%>
<%@ page import="com.hongshee.ejforum.common.ForumSetting"%>
<%
	if (!request.isRequestedSessionIdFromCookie())
	{
		request.setAttribute("errorMsg", "请打开浏览器的 Cookie 支持功能, 或者将本站设为可信站点, 否则不能登录");
		request.getRequestDispatcher("/error.jsp").forward(request, response);
		return;
	}

	String ctxPath = request.getContextPath()+"/ejforum";
	String pageUrl = ctxPath + "/login.jsp";
	
    String fromPath = (String)request.getAttribute("fromPath");
	if (fromPath == null)
	{
	    fromPath = (String)request.getParameter("fromPath");
		if (fromPath == null)
		{
			fromPath = PageUtils.getPathFromReferer(request);
			if (fromPath.indexOf("login.jsp") >= 0 || fromPath.indexOf("register.jsp") >= 0)
				fromPath = "/";
		}
	}
	else
	{
		fromPath = URLEncoder.encode(fromPath);
		pageUrl = pageUrl + "?fromPath=" + fromPath;
	}
	String forumName = ForumSetting.getInstance().getForumName();
	String title = PageUtils.getTitle(forumName);
	String[] menus = PageUtils.getHeaderMenu(request, null);
	String homeUrl = ctxPath + "/index.jsp";
	String forumStyle = PageUtils.getForumStyle(request, response, null);
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<HTML xmlns="http://www.w3.org/1999/xhtml">
<HEAD>
<TITLE>用户登录 - <%= title %></TITLE>
<LINK href="<%= ctxPath %>/styles/<%= forumStyle %>/ejforum.css" type=text/css rel=stylesheet>
</HEAD>
<BODY onkeydown="if(event.keyCode==27) return false;">
<SCRIPT language=JavaScript>
if(self.parent.frames.length != 0) {
	self.parent.location = "<%= pageUrl %>";
}
</SCRIPT>
<SCRIPT src="<%= ctxPath %>/js/common.js" type=text/javascript></SCRIPT>
<SCRIPT src="<%= ctxPath %>/js/md5.js" type=text/javascript></SCRIPT>
<DIV class=wrap>
<DIV id=header>
<%= PageUtils.getHeader(request, title) %>
<%= PageUtils.getHeadAdBanner(request, null) %>
</DIV>
<%= menus[0] %>
<DIV id=nav><A href="<%= homeUrl %>"><%= forumName %></A> &raquo; 会员登录</DIV>
<FORM name=login onSubmit="checkfield(this); return false;" action="<%= ctxPath %>/perform.jsp?act=lgn" method=post>
<DIV class="mainbox formbox"><SPAN class=headactions>
<A class=notabs href="<%= ctxPath %>/help/member.jsp" target=_blank>登录帮助</A></SPAN> 
<H1>会员登录</H1>
<TABLE cellSpacing=0 cellPadding=0 summary=会员登录>
  <TBODY>
  <TR>
    <TH onclick=document.login.userID.focus();><LABEL for=userID>用户名</LABEL></TH>
    <TD><INPUT id=userID tabIndex=2 maxLength=40 size=25 name=userID> 
      &nbsp;<A href="<%= ctxPath %>/register.jsp?from=<%= fromPath %>">立即注册</A> 
      <INPUT type=hidden name=fromPath value="<%= fromPath %>"> </TD></TR>
  <TR>
    <TH><LABEL for=pwd1>密码</LABEL></TH>
    <TD><INPUT id=pwd1 tabIndex=5 type=password size=25 name=pwd1> 
	  &nbsp;<A href="<%= ctxPath %>/findpwd.jsp">忘记密码</A><INPUT type=hidden id=pwd name=pwd></TD></TR>
  <TR>
    <TH>登录有效期</TH>
    <TD><LABEL><INPUT class=radio tabIndex=8 type=radio value=0 name=cookietime CHECKED> 浏览器进程（约30分钟）</LABEL>
		<LABEL><INPUT class=radio tabIndex=9 type=radio value=3600 name=cookietime> 一小时</LABEL>
		<LABEL><INPUT class=radio tabIndex=10 type=radio value=86400 name=cookietime> 一天</LABEL>   
		<LABEL><INPUT class=radio tabIndex=11 type=radio value=2592000 name=cookietime> 一个月</LABEL> 
	    <LABEL><INPUT class=radio tabIndex=12 type=radio value=315360000 name=cookietime> 永久</LABEL> 
    </TD></TR>
  <TR class="btns">
    <TH>&nbsp;</TH>
    <TD height="30"><BUTTON class=submit tabIndex=100 name=loginsubmit type=submit 
      value="true">提交</BUTTON></TD></TR></TBODY></TABLE></DIV></FORM>
<SCRIPT type=text/javascript>
function checkfield(theform) {
	if(trim($('userID').value) == '') {
		alert('用户名不可以为空');return false;
	} else if(trim($('pwd1').value) == '') {
		alert('密码不可以为空');return false;
	} else {
		$('pwd').value = hex_md5(trim($('pwd1').value)); 
		$('pwd1').value = '';
		theform.submit();return false;
	}
}
</SCRIPT>
</DIV>
<%= menus[1]==null?"":menus[1] %>
<%= menus[2]==null?"":menus[2] %>
<%= PageUtils.getFooter(request, forumStyle) %>
</BODY></HTML>
