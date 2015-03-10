<%@ page contentType="text/html;charset=gbk" errorPage="../error.jsp"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="com.hongshee.ejforum.util.PageUtils"%>
<%@ page import="com.hongshee.ejforum.common.CacheManager"%>
<%@ page import="com.hongshee.ejforum.data.UserDAO.UserInfo"%>
<%@ page import="com.hongshee.ejforum.data.GroupDAO.GroupVO"%>
<%
	UserInfo userinfo = PageUtils.getAdminUser(request, response);
	if (userinfo == null) return;
	String adminPath = request.getContextPath() + "/admin";
	
	CacheManager cache = CacheManager.getInstance();
    ArrayList groups = cache.getGroups();
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
          <TD><A 
            onclick="parent.location='../index.htm'; return false;" 
            href="#">后台管理首页</A>&nbsp;&raquo;&nbsp;会员用户组</TD></TR></TBODY></TABLE><BR>
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
              <LI>EasyJForum 
              论坛用户组分为系统组和会员组，会员组以积分确定组别和权限，而系统组是人为设定，不会由论坛系统自行改变。</LI></UL>
            <UL>
             <LI>系统组的设定不需要指定积分，会员组的积分按级别由低到高依序递增，但不应重叠，否则用户的权限将难以确定。</LI></UL>
		  </TD></TR></TBODY></TABLE><BR>
      <FORM id="setting" name="setting" onSubmit="checkfields(this); return false;" action="../perform.jsp" method=post>
	  <INPUT type=hidden name="act" value="users_group_member">
      <TABLE class=info_tb cellSpacing=0 cellPadding=0 width="100%" border=0>
        <TBODY>
        <TR class=header>
          <TD colSpan=7>会员用户组</TD></TR>
        <TR class=category align=middle>
          <TD>&nbsp;&nbsp;&nbsp;序号</TD>
          <TD>组名称</TD>
          <TD>积分大于</TD>
          <TD>积分小于</TD>
          <TD>星星数</TD>
          <TD>操作</TD></TR>
<%
	if (groups != null)
	{
		GroupVO aGroup = null;
		for (int i=0; i<groups.size(); i++)
		{
			aGroup = (GroupVO)groups.get(i);
			if (aGroup.groupType == 'M')
			{
%>			
        <TR align=middle>
          <TD class=altbg1 width="48">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<%= aGroup.groupID %>
		  	<INPUT type=hidden value="<%= aGroup.rights %>" name="rights"></TD>
          <TD class=altbg2><INPUT size=12 value="<%= aGroup.groupName %>" name="groupName" maxlength="15"></TD>
          <TD class=altbg1><INPUT size=6 value="<%= aGroup.minCredits %>" name="minCredits" maxlength="7"> </TD>
          <TD class=altbg2><%= aGroup.maxCredits %></TD>
		  <TD class=altbg1><INPUT size=2 value="<%= aGroup.stars %>" name="stars" maxlength="1"></TD>
          <TD class=altbg2 noWrap>[&nbsp;<A href="group_info.jsp?id=<%= String.valueOf(aGroup.groupID) %>">权限</A>&nbsp;]
	[&nbsp;<A href='javascript:deleteGroup("<%= String.valueOf(aGroup.groupID) %>", "<%= aGroup.groupName %>")'>删除</A>&nbsp;]
</TD></TR>
<%
			}
		}
	}
%>			
        <TBODY id=addnewgroup>
        <TR class=altbg1 align=middle>
          <TD>&nbsp;<INPUT type=hidden value="" name="rights"></TD>
		  <TD><INPUT size=12 name="groupName"></TD>
          <TD><INPUT size=6 name="minCredits" maxlength="7"></TD>
          <TD>&nbsp;</TD>
          <TD><INPUT size=2 name="stars" maxlength="1"></TD>
          <TD>[&nbsp;<A 
            onclick="newnode = $('addnewgroup2').firstChild.cloneNode(true); $('addnewgroup').appendChild(newnode)" 
            href="#">添加</A>&nbsp;]</TD></TR>
		</TBODY>
        <TBODY id=addnewgroup2 style="DISPLAY: none">
        <TR class=altbg1 align=middle>
          <TD>&nbsp;<INPUT type=hidden value="" name="rights"></TD>
          <TD><INPUT size=12 name="groupName"></TD>
          <TD><INPUT size=6 name="minCredits" maxlength="7"></TD>
          <TD>&nbsp;</TD>
          <TD><INPUT size=2 name="stars" maxlength="1"></TD>
          <TD>&nbsp;</TD></TR></TBODY></TABLE>
      <BR>
      <CENTER><INPUT class=button type=submit value="提 交"></CENTER>&nbsp;</FORM><BR>
      </TD></TR></TBODY></TABLE><BR><BR>
<script language="javascript">
function checkfields(theform) {
    var filter = /^[\d-]+$/;
	for (i=0; i<theform.minCredits.length; i++)
	{
		if (trim(theform.groupName[i].value) != '') {
		    if (!filter.test(trim(theform.minCredits[i].value))) {
    			alert('最小积分必须为负号或数字');
      			theform.minCredits[i].focus();
				return;
			}
		}
    }
    filter = /^\d+$/;
	for (i=0; i<theform.stars.length; i++)
	{
		if (trim(theform.groupName[i].value) != '') {
		    if (!filter.test(trim(theform.stars[i].value))) {
    			alert('星星数必须为整数');
      			theform.stars[i].focus();
				return;
			}
		}
    }
	theform.submit();
}
function deleteGroup(id,name)
{
	if (confirm('您确实要删除用户组"' + name + '"吗?'))
		window.location = "<%= adminPath %>" + "/perform.jsp?act=users_group_delete&id=" + id;
}
</script>	  
<%= PageUtils.getAdminFooter(request) %>
</BODY></HTML>
