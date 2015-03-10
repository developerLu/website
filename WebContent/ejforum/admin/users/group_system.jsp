<%@ page contentType="text/html;charset=gbk" errorPage="../error.jsp"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="com.hongshee.ejforum.util.PageUtils"%>
<%@ page import="com.hongshee.ejforum.common.CacheManager"%>
<%@ page import="com.hongshee.ejforum.data.UserDAO.UserInfo"%>
<%@ page import="com.hongshee.ejforum.data.GroupDAO.GroupVO"%>
<%
	UserInfo userinfo = PageUtils.getAdminUser(request, response);
	if (userinfo == null) return;
	
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
            href="#">后台管理首页</A>&nbsp;&raquo;&nbsp;系统用户组</TD></TR></TBODY></TABLE><BR>
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
              论坛用户组分为系统组和会员组，会员组以积分确定组别和权限，而系统组是论坛系统自行设定，不会由人为改变。</LI></UL>
            <UL>
             <LI>
	 系统组除“游客”外也可称为管理组，其中管理员可以管理整个论坛范围的帖子，版主和超级版主可管理范围由其所负责的版块决定。
			 </LI></UL>
		  </TD></TR></TBODY></TABLE><BR>
      <TABLE class=info_tb cellSpacing=0 cellPadding=0 width="100%" border=0>
        <TBODY>
        <TR class=header>
          <TD colSpan=4>系统用户组 - 点击详情编辑用户组权限设置</TD></TR>
        <TR class=category align=middle>
          <TD>组名称</TD>
          <TD>类型</TD>
          <TD>星星数</TD>
          <TD>权限</TD></TR>
<%
	if (groups != null)
	{
		GroupVO aGroup = null;
		for (int i=0; i<groups.size(); i++)
		{
			aGroup = (GroupVO)groups.get(i);
			if (aGroup.groupType == 'S')
			{
%>			
        <TR align=middle>
          <TD class=altbg1><%= aGroup.groupName %></TD>
          <TD class=altbg2>内置</TD>
          <TD class=altbg1><%= aGroup.stars %></TD>
          <TD class=altbg2>[&nbsp;<A href="group_info.jsp?id=<%= String.valueOf(aGroup.groupID) %>">详情</A>&nbsp;]</TD></TR>
<%
			}
		}
	}
%>			
        </TBODY></TABLE>
      </TD></TR></TBODY></TABLE><BR><BR>
<%= PageUtils.getAdminFooter(request) %>
</BODY></HTML>
