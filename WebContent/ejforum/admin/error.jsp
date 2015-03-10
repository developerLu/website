<%@ page contentType="text/html;charset=gbk" isErrorPage="true"%>
<%@ page import="com.hongshee.ejforum.util.PageUtils"%>
<%@ page import="com.hongshee.ejforum.common.AppException"%>
<%
	String adminPath = request.getContextPath() + "/admin";
	String errorMsg = (String)request.getAttribute("errorMsg");
	if (errorMsg == null)
	{ 	
		if (exception != null)
		{
			errorMsg = "服务端出现异常，请稍后再试 - " + exception.getMessage();
			if (!(exception instanceof AppException))
				PageUtils.log(request, "admin jsp error", errorMsg, exception);
		}
		if (errorMsg == null)	
			errorMsg = "服务端出现异常，请稍后再试。";
	}
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<HTML xmlns="http://www.w3.org/1999/xhtml">
<HEAD><META http-equiv=Content-Type content="text/html; charset=gbk">
<LINK href="<%= adminPath %>/style/admin.css" type=text/css rel=stylesheet>
</HEAD>
<BODY leftmargin="10" topmargin="10">
<table width="100%" border="0" cellpadding="2" cellspacing="6">
<tr><td>
	<table width="100%" border="0" cellpadding="0" cellspacing="0" class="guide">
	<tr><td><a href="#" 
		onClick="parent.location='<%= adminPath %>/index.htm'; return false;">后台首页</a>&nbsp;&raquo;&nbsp;提示信息
	</td></tr>
	</table><br/><br/><br/><br/><br/><br/><br/>
	<table width="500" border="0" cellpadding="0" cellspacing="0" align="center" class="info_tb">
	<tr class="header"><td>EasyJForum 提示</td></tr>
	<tr><td class="altbg2">
		<div align="center">
		<br/><br/><br/><%= errorMsg %><br/><br/><br/>
		<a href="javascript:history.go(-1);" class="mediumtxt">[&nbsp;点击这里返回上一页&nbsp;]</a><br/><br/></div>
		<br/><br/>
	</td></tr></table>
	<br/><br/><br/>
</td></tr></table>
<br/><br/>
<%= PageUtils.getAdminFooter(request) %>
</BODY></HTML>
