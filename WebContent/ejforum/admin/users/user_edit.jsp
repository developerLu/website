<%@ page contentType="text/html;charset=gbk" errorPage="../error.jsp"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="com.hongshee.ejforum.util.PageUtils"%>
<%@ page import="com.hongshee.ejforum.common.CacheManager"%>
<%@ page import="com.hongshee.ejforum.common.IConstants"%>
<%@ page import="com.hongshee.ejforum.data.UserDAO.UserInfo"%>
<%@ page import="com.hongshee.ejforum.data.GroupDAO.GroupVO"%>
<%
	UserInfo userinfo = PageUtils.getAdminUser(request, response);
	if (userinfo == null) return;
	
	CacheManager cache = CacheManager.getInstance();
    ArrayList groups = cache.getGroups();
    GroupVO userGroup = PageUtils.getGroupVO(userinfo, cache.getModerators());
	
	String action = PageUtils.getParam(request,"act");
	String actTitle = null;
	
	if (action.length() == 0)
		actTitle = "编辑用户";
	else if (action.equals("credits"))
	{
		if (userGroup.rights.indexOf(IConstants.PERMIT_EDIT_CREDITS) < 0)
		{
			request.setAttribute("errorMsg", "您没有积分奖惩的权限");
			request.getRequestDispatcher("/admin/error.jsp").forward(request, response);
			return;
		}
		actTitle = "积分奖惩";
	}	
	else if (action.equals("ban"))
	{
		if (userGroup.rights.indexOf(IConstants.PERMIT_BAN_USER) < 0)
		{
			request.setAttribute("errorMsg", "您没有禁止用户的权限");
			request.getRequestDispatcher("/admin/error.jsp").forward(request, response);
			return;
		}
		actTitle = "禁止用户";
	}
	else
		actTitle = "编辑用户";
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<HTML xmlns="http://www.w3.org/1999/xhtml"><HEAD>
<META http-equiv=Content-Type content="text/html; charset=gbk">
<LINK href="../style/admin.css" type=text/css rel=stylesheet>
<SCRIPT src="../../js/common.js" type=text/javascript></SCRIPT>
<SCRIPT src="../js/admin.js" type=text/javascript></SCRIPT>
</HEAD>
<BODY topMargin=10 onload="showAdvance()">
<TABLE cellSpacing=6 cellPadding=2 width="100%" border=0>
  <TBODY>
  <TR>
    <TD>
      <TABLE class=guide cellSpacing=0 cellPadding=0 width="100%" border=0>
        <TBODY>
        <TR>
          <TD>
		  <A onclick="parent.location='../index.htm'; return false;" href="#">后台管理首页</A>&nbsp;&raquo;&nbsp;<%= actTitle %>
			</TD></TR></TBODY></TABLE><BR>
      <FORM id="frmsearch" name="frmsearch" onSubmit="checkfields(this); return false;" action="./user_list.jsp" method=post>
	  <INPUT type=hidden name="act" value="<%= action %>"/>
      <TABLE class=info_tb cellSpacing=0 cellPadding=0 width="100%" border=0>
        <TBODY>
        <TR class=header>
          <TD colSpan=2><%= actTitle %>&nbsp;-&nbsp; 搜索用户</TD></TR>
        <TR>
          <TD class=altbg1 width="45%">可显示的最多记录数量:</TD>
          <TD class=altbg2 align=right><INPUT size=40 name="resultCount" value="50"></TD></TR>
        <TR>
          <TD class=altbg1 width="45%">用户名(可使用通配符 *):</TD>
          <TD class=altbg2 align=right><INPUT size=40 name="userID"></TD></TR>
        <TR>
          <TD class=altbg1 width="45%">用户的访问状态:</TD>
          <TD class=altbg2>
		  	<INPUT class=radio type=radio value="N" name="state" checked> 正常状态<BR>
			<INPUT class=radio type=radio value="P" name="state"> 禁止发言<BR>
			<INPUT class=radio type=radio value="S" name="state"> 禁止访问</TD></TR>
        <TR>
          <TD class=altbg1 vAlign=top>设置允许参与搜索的用户组(可以按住 CTRL 多选):</TD>
          <TD class=altbg2 align=right>
		  	<SELECT style="WIDTH:233px;" multiple size=7 name="groupID"> 
			  <OPTION value="">无限制</OPTION> 
<%
	if (groups != null)
	{
		GroupVO aGroup = null;
		for (int i=0; i<groups.size(); i++)
		{
			aGroup = (GroupVO)groups.get(i);
			if (aGroup.groupID == 'G') continue; // Skip Guest
			if (aGroup.groupType == 'S')
			{
%>			
			  <OPTION value="<%= aGroup.groupID %>"><%= aGroup.groupName %></OPTION>
<%
			} else {
%>			
			  <OPTION value="<%= aGroup.minCredits %>_<%= aGroup.maxCredits %>"><%= aGroup.groupName %></OPTION>
<%
			}
		}
	}
%>			
			</SELECT></TD></TR>
        <TR>
          <TD class=altbg1>&nbsp;</TD>
          <TD class=altbg2 style="TEXT-ALIGN: right" align=right>
		  	<INPUT type=hidden name="advanceOptions" value="no"/>
		  	<INPUT class=checkbox type=checkbox id="chkAdvance" onclick="showAdvance();">更多选项 &nbsp; </TD></TR>
        <TBODY id=advanceoption style="DISPLAY: none">
        <TR>
          <TD class=altbg1>Email(可使用通配符 *):</TD>
          <TD class=altbg2 align=right><INPUT size=40 name="email"></TD></TR>
        <TR>
          <TD class=altbg1>积分 低于:</TD>
          <TD class=altbg2 align=right><INPUT size=40 name="maxCredits"></TD></TR>
        <TR>
          <TD class=altbg1>积分 高于:</TD>
          <TD class=altbg2 align=right><INPUT size=40 name="minCredits"></TD></TR>
        <TR>
          <TD class=altbg1>发帖数小于:</TD>
          <TD class=altbg2 align=right><INPUT size=40 name="maxPosts"></TD></TR>
        <TR>
          <TD class=altbg1>发帖数大于:</TD>
          <TD class=altbg2 align=right><INPUT size=40 name="minPosts"></TD></TR>
        <TR>
          <TD class=altbg1>注册 IP 开头 (如 192.168):</TD>
          <TD class=altbg2 align=right><INPUT size=40 name="remoteIP"></TD></TR>
        <TR>
          <TD class=altbg1>注册日期早于(yyyy-mm-dd):</TD>
          <TD class=altbg2 align=right><INPUT size=40 name="maxCreateTime"></TD></TR>
        <TR>
          <TD class=altbg1>注册日期晚于(yyyy-mm-dd):</TD>
          <TD class=altbg2 align=right><INPUT size=40 name="minCreateTime"></TD></TR>
        <TR>
          <TD class=altbg1>最后访问时间早于(yyyy-mm-dd):</TD>
          <TD class=altbg2 align=right><INPUT size=40 name="maxLastVisited"></TD></TR>
        <TR>
          <TD class=altbg1>最后访问时间晚于(yyyy-mm-dd):</TD>
          <TD class=altbg2 align=right><INPUT size=40 name="minLastVisited"></TD></TR>
		</TBODY></TABLE><BR>
      <CENTER><INPUT class=button type=submit value=搜索用户></CENTER></FORM></TD></TR></TBODY></TABLE><BR><BR>
<script language="javascript">
function checkfields(theform) {
    var filter = /^\d+$/;
    if (!filter.test(trim(theform.resultCount.value))) {
    	alert('可显示的最多记录数量必须为整数');
      	theform.resultCount.focus();
		return;
    }
	theform.advanceOptions.value = $('advanceoption').style.display == 'none' ? 'no' : 'yes';
	theform.submit();
}
function showAdvance()
{
	$('advanceoption').style.display = $('chkAdvance').checked ? '' : 'none';
}
</script>	  
<%= PageUtils.getAdminFooter(request) %>
</BODY></HTML>
