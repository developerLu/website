<%@ page contentType="text/html;charset=gbk" errorPage="../error.jsp"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="java.util.HashMap"%>
<%@ page import="com.hongshee.ejforum.common.CacheManager"%>
<%@ page import="com.hongshee.ejforum.common.IConstants"%>
<%@ page import="com.hongshee.ejforum.util.PageUtils"%>
<%@ page import="com.hongshee.ejforum.util.AppUtils"%>
<%@ page import="com.hongshee.ejforum.data.UserDAO.UserInfo"%>
<%@ page import="com.hongshee.ejforum.data.UserDAO"%>
<%@ page import="com.hongshee.ejforum.data.GroupDAO.GroupVO"%>
<%
	UserInfo userinfo = PageUtils.getAdminUser(request, response);
	if (userinfo == null) return;
	
	CacheManager cache = CacheManager.getInstance();
    GroupVO userGroup = PageUtils.getGroupVO(userinfo, cache.getModerators());

	if (userGroup.rights.indexOf(IConstants.PERMIT_AUDIT_USER) < 0)
	{
		request.setAttribute("errorMsg", "您没有审核用户的权限");
		request.getRequestDispatcher("/admin/error.jsp").forward(request, response);
		return;
	}
	
	ArrayList userList = UserDAO.getInstance().getAuditingUsers();
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
            href="#">后台管理首页</A>&nbsp;&raquo;&nbsp;审核新用户</TD></TR></TBODY></TABLE><BR>
      <TABLE class=info_tb cellSpacing=0 cellPadding=0 width="100%" border=0>
        <TBODY>
        <TR class=header>
          <TD>
            <DIV style="FLOAT: left; MARGIN-LEFT: 0px; PADDING-TOP: 8px"><A 
            onclick="collapse_change('tip','../images')" href="#">技巧提示</A></DIV>
            <DIV style="FLOAT: right; PADDING-BOTTOM: 9px; MARGIN-RIGHT: 4px"><A 
            onclick="collapse_change('tip','../images')" href="#">
			<IMG id=menuimg_tip src="../images/menu_reduce.gif" border=0></A></DIV></TD></TR>
        <TBODY id=menu_tip>
        <TR>
          <TD>
            <UL>
              <LI>本功能仅在论坛选项的新用户注册方式中设置为“封闭式注册”时才有效。</LI>
              <LI>被“否决”的用户记录将会被立即删除，同时向注册者发送一封说明邮件。</LI>
		    </UL></TD></TR></TBODY></TABLE><BR>
      <FORM id="setting" name="setting" onSubmit="checkfields(this); return false;" action="../perform.jsp" method=post>
	  <INPUT type=hidden name="act" value="users_user_audit">
      <TABLE class=info_tb cellSpacing=0 cellPadding=0 width="100%" border=0>
        <TBODY>
        <TR class=header align=middle>
          <TD width="90">操作</TD>
          <TD width="100">用户名</TD>
          <TD width="100">注册时间</TD>
          <TD width="100">注册 IP</TD>
          <TD width="120">Email</TD>
          <TD width="160">操作理由</TD>
		</TR>
<%
	HashMap userMap = null;
	String userID = null;
	for (int i=0; i<userList.size(); i++)
	{
		userMap = (HashMap)userList.get(i);
		userID = (String)userMap.get("USERID");
%>		
        <TR class=smalltxt>
          <TD class=altbg1>
		  	<input type="radio" name="op_<%= userID %>" id="op_<%= userID %>_no" value="no" class="radio">&nbsp;否决<BR>
			<input type="radio" name="op_<%= userID %>" value="yes" checked class="radio">&nbsp;通过<BR>
			<input type="radio" name="op_<%= userID %>" value="ignore" class="radio">&nbsp;忽略</TD>
          <TD class=altbg2><B><A href="../../uspace.jsp?uid=<%= userID %>" target=_blank><%= userID %></A></B></TD>
          <TD class=altbg1 align=middle><%= AppUtils.formatSQLTimeStr((String)userMap.get("CREATETIME")) %></TD>
          <TD class=altbg2><%= (String)userMap.get("REMOTEIP") %></TD>
          <TD class=altbg1><%= (String)userMap.get("EMAIL") %></TD>
          <TD class=altbg2>
		  	<INPUT type=text name="remark" style="width:95%" maxlength="40">
			<INPUT type=hidden name="userID" value="<%= userID %>">
			<INPUT type=hidden name="email" value="<%= (String)userMap.get("EMAIL") %>"></TD></TR>
<%
	}
%>		  
		</TBODY></TABLE>
      <BR>
      <CENTER><INPUT class=button type=submit value="提 交"></CENTER></FORM></TD></TR></TBODY></TABLE><BR><BR>
<script language="javascript">
function checkfields(theform) {
	if (typeof(theform.userID) == "undefined")
	{
		alert('没有需要审核的新用户');
		return;
	}
	if (typeof(theform.userID.length) == "undefined")
	{
		if ($('op_' + theform.userID.value + '_no').checked)
		{
			if (trim(theform.remark.value) == "")
			{
				alert('请输入否决用户的理由');
				theform.remark.focus();
				return;
			}
		}
	}
	else
	{
		for (i=0; i<theform.userID.length; i++)
		{
			if ($('op_' + theform.userID[i].value + '_no').checked)
			{
				if (trim(theform.remark[i].value) == "")
				{
					alert('请输入否决用户的理由');
					theform.remark[i].focus();
					return;
				}
			}
		}
	}
	theform.submit();
}
</script>	  
<%= PageUtils.getAdminFooter(request) %>
</BODY></HTML>
