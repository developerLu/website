<%@ page contentType="text/html;charset=gbk" errorPage="../error.jsp"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="com.hongshee.ejforum.util.PageUtils"%>
<%@ page import="com.hongshee.ejforum.common.CacheManager"%>
<%@ page import="com.hongshee.ejforum.common.IConstants"%>
<%@ page import="com.hongshee.ejforum.data.GroupDAO.GroupVO"%>
<%@ page import="com.hongshee.ejforum.data.UserDAO"%>
<%@ page import="com.hongshee.ejforum.data.UserDAO.UserInfo"%>
<%@ page import="com.hongshee.ejforum.data.UserDAO.UserVO"%>
<%
	UserInfo userinfo = PageUtils.getAdminUser(request, response);
	if (userinfo == null) return;

	CacheManager cache = CacheManager.getInstance();
    GroupVO userGroup = PageUtils.getGroupVO(userinfo, cache.getModerators());

	if (userGroup.rights.indexOf(IConstants.PERMIT_EDIT_USER) < 0)
	{
		request.setAttribute("errorMsg", "您没有编辑用户的权限");
		request.getRequestDispatcher("/admin/error.jsp").forward(request, response);
		return;
	}

	String fromPath = PageUtils.getPathFromReferer(request);
	
	String userID = PageUtils.getParam(request,"uid");
	UserVO aUser = UserDAO.getInstance().getUserVO(userID);
	
    ArrayList groups = cache.getGroups();

	if (aUser.groupID <= '9')
	{
		String moderators = cache.getModerators();
		if (moderators.indexOf("," + aUser.userID + ",") >= 0)
			aUser.groupID = 'M';
	}
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
		<table width="100%" border="0" cellpadding="0" cellspacing="0" class="info_tb">
		<tr class="header">
          <TD>
            <DIV style="FLOAT: left; MARGIN-LEFT: 0px; PADDING-TOP: 8px"><A 
            onclick="collapse_change('tip','../images')" href="#">技巧提示</A></DIV>
            <DIV style="FLOAT: right; PADDING-BOTTOM: 9px; MARGIN-RIGHT: 4px"><A 
            onclick="collapse_change('tip','../images')" href="#">
			<IMG id=menuimg_tip src="../images/menu_reduce.gif" border=0></A></DIV></TD></TR>
		<tbody id="menu_tip" style="display:"><tr><td>
			<ul><li>对于版主而言，此处只改变用户的管理组角色，但并不实际分配责任版块给用户。</li>
			</ul>
		</td></tr></tbody></table><br/>
      <FORM id=settings name=settings onSubmit="checkfields(this); return false;" action="../perform.jsp" method=post>
	  <INPUT type=hidden name="act" value="users_user_group">
	  <INPUT type=hidden name="userID" value="<%= userID %>">
	  <INPUT type=hidden name="fromPath" value="<%= fromPath %>">
      <TABLE class=info_tb cellSpacing=0 cellPadding=0 width="100%" border=0>
        <TBODY>
        <TR class=header>
          <TD>所属管理组 ( 用户:&nbsp;<%= userID %> )</TD>
          <TD>组类型</TD>
          <TD>查看</TD>
		</TR>
<%
	String checked = null;
	boolean isAdmin = false;
	if (groups != null)
	{
		GroupVO aGroup = null;
		for (int i=0; i<groups.size(); i++)
		{
			aGroup = (GroupVO)groups.get(i);
			if (aGroup.groupID == 'G') continue; // Skip Guest
			if (aGroup.groupType == 'S')
			{
				checked = "";
				if (aGroup.groupID == aUser.groupID)
				{
					checked = "checked";
					isAdmin = true;
				}
%>			
        <TR>
          <TD class=altbg1>
		  	<INPUT class=radio type=radio <%= checked %> name="groupID" value="<%= aGroup.groupID %>"> <%= aGroup.groupName %>
		  </TD>
          <TD class=altbg2>管理组</TD>
          <TD class=altbg1>[&nbsp;<a href="group_info.jsp?id=<%= String.valueOf(aGroup.groupID) %>">详情</a>&nbsp;]</TD>
          </TR>
<%
			}
		}
	}
	if (!isAdmin)
		checked = "checked";
	else
		checked = "";	
%>			
        <TR>
          <TD class=altbg1>
		  	<INPUT class=radio type=radio <%= checked %> name="groupID" value="1"> 普通会员</TD>
          <TD class=altbg2>会员组</TD>
          <TD class=altbg1>&nbsp;</TD>
        </TR>
       </TBODY></TABLE><BR>
      <CENTER><INPUT class=button type=submit value="提 交" name=detailsubmit>
	  		&nbsp;<INPUT class=button type=button value="返回上一页" onclick="javascript:history.go(-1);"></CENTER></FORM>
	  </TD></TR></TBODY></TABLE><BR><BR>
<script language="javascript">
function checkfields(theform) {
	theform.submit();
}
</script>	  
<%= PageUtils.getAdminFooter(request) %>
</BODY></HTML>
