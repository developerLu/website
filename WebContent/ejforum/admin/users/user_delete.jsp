<%@ page contentType="text/html;charset=gbk" errorPage="../error.jsp"%>
<%@ page import="com.hongshee.ejforum.util.PageUtils"%>
<%@ page import="com.hongshee.ejforum.data.UserDAO.UserInfo"%>
<%
	UserInfo userinfo = PageUtils.getAdminUser(request, response);
	if (userinfo == null) return;
    String totalCount = PageUtils.getParam(request,"totalCount");
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<HTML xmlns="http://www.w3.org/1999/xhtml"><HEAD>
<META http-equiv=Content-Type content="text/html; charset=gbk">
<LINK href="../style/admin.css" type=text/css rel=stylesheet>
<SCRIPT src="../../js/common.js" type=text/javascript></SCRIPT>
<SCRIPT src="../js/admin.js" type=text/javascript></SCRIPT>
</HEAD>
<BODY topMargin=10>
<TABLE cellSpacing=6 cellPadding=2 width="100%" border=0>
  <TBODY>
  <TR>
    <TD>
      <TABLE class=guide cellSpacing=0 cellPadding=0 width="100%" border=0>
        <TBODY>
        <TR>
          <TD><A onclick="parent.location='../index.htm'; return false;" 
            href="#">后台管理首页</A>&nbsp;&raquo;&nbsp;编辑用户</TD></TR></TBODY></TABLE><BR>
      <FORM id="settings" name="settings" onSubmit="checkfields(this); return false;" action="../perform.jsp" method=post>
	  <INPUT type=hidden name="act" value="users_user_delete">
	  <%= PageUtils.getQueryFields(request) %>
      <TABLE class=info_tb cellSpacing=0 cellPadding=0 width="100%" border=0>
        <TBODY>
        <TR class=header>
          <TD colSpan=2>删除用户 -&nbsp; 符合条件的会员数: <%= totalCount %></TD></TR>
        <TBODY>
        <TR>
          <TD class=altbg1 width="45%"><B>删除该用户帖子:</B><BR><SPAN 
            class=smalltxt>在删除这个用户的同时，是否删除其所有的帖子和附件</SPAN></TD>
          <TD class=altbg2><INPUT class=radio type=radio value="yes" name="removepost"> 
            是 &nbsp; &nbsp; <INPUT class=radio type=radio CHECKED value="no" name="removepost"> 否 </TD></TR>
        <TR>
          <TD class=altbg1 vAlign=top width="45%"><B>操作理由:</B><BR><SPAN 
            class=smalltxt>删除用户的理由</SPAN></TD>
          <TD class=altbg2>
		  <INPUT type="text" size=60 name="reason" id="reason" maxlength="40"></TD></TR>
	</TBODY></TABLE><BR>
      <CENTER><INPUT class=button type=submit value="提 交" name=bansubmit></CENTER></FORM></TD></TR></TBODY></TABLE><BR><BR>
<script language="javascript">
function checkfields(theform) 
{
	if (trim($('reason').value) == '') {
		alert('请输入删除用户的理由');
		$('reason').focus();
		return;
	}
	if (confirm('本操作不可恢复，确实要继续吗？'))
	{
		theform.submit();
	}
}
</script>	  
<%= PageUtils.getAdminFooter(request) %>
</BODY></HTML>
