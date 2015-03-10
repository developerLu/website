<%@ page contentType="text/html;charset=gbk" errorPage="../error.jsp"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="com.hongshee.ejforum.util.PageUtils"%>
<%@ page import="com.hongshee.ejforum.common.CacheManager"%>
<%@ page import="com.hongshee.ejforum.data.UserDAO.UserInfo"%>
<%@ page import="com.hongshee.ejforum.data.GroupDAO.GroupVO"%>
<%@ page import="com.hongshee.ejforum.data.UserDAO"%>
<%
	UserInfo userinfo = PageUtils.getAdminUser(request, response);
	if (userinfo == null) return;

	CacheManager cache = CacheManager.getInstance();
    ArrayList groups = cache.getGroups();

	int totalCount = -1;
	String state = PageUtils.getParam(request,"state");
	if (state != null && state.trim().length() > 0)
	{
		UserDAO dao = UserDAO.getInstance();
		totalCount = UserDAO.getInstance().searchUser(request);
	}
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
          <TD><A 
            onclick="parent.location='../index.htm'; return false;" 
            href="#">后台管理首页</A>&nbsp;&raquo;&nbsp;论坛通知</TD></TR></TBODY></TABLE><BR>
      <FORM id="frmsearch" name="frmsearch" onSubmit="checkfields(this); return false;" action="./send_notice.jsp" method=post>
	  <INPUT type=hidden name="act" value="tools_send_notice">
      <TABLE class=info_tb cellSpacing=0 cellPadding=0 width="100%" border=0>
        <TBODY>
        <TR class=header>
          <TD colSpan=2>论坛通知&nbsp;-&nbsp; 搜索用户</TD></TR>
        <TR>
          <TD class=altbg1 width="45%">用户名(可使用通配符 *):</TD>
          <TD class=altbg2 align=right><INPUT size=40 name="userID"></TD></TR>
        <TR>
          <TD class=altbg1 width="45%">用户的访问状态:</TD>
          <TD class=altbg2>
		  	<INPUT class=radio type=radio value="N" id="state[N]" name="state" checked> 正常状态<BR>
			<INPUT class=radio type=radio value="P" id="state[P]" name="state"> 禁止发言<BR>
			<INPUT class=radio type=radio value="S" id="state[S]" name="state"> 禁止访问</TD></TR>
        <TR>
          <TD class=altbg1 vAlign=top>设置允许参与搜索的用户组(可以按住 CTRL 多选):</TD>
          <TD class=altbg2 align=right>
		  	<SELECT style="WIDTH:233px;" multiple size=7 name="groupID"> 
			  <OPTION value="">无限制</OPTION> 
<%
	if (groups != null)
	{
		String groupStr = null;
		String[] groupIDs = request.getParameterValues("groupID");
		if (groupIDs != null)
		{
			groupStr = "";
			for (int i=0; i<groupIDs.length; i++)
			{
				groupStr = groupStr + groupIDs[i] + ",";
			}
		}
	
		GroupVO aGroup = null;
		String selected = null;
		String optValue = null;
		for (int i=0; i<groups.size(); i++)
		{
			aGroup = (GroupVO)groups.get(i);
			if (aGroup.groupID == 'G') continue; // Skip Guest

			if (aGroup.groupType == 'S')
				optValue = String.valueOf(aGroup.groupID);
			else
				optValue = aGroup.minCredits + "_" + aGroup.maxCredits;
				
			if (groupStr != null && groupStr.indexOf(optValue + ",") >= 0)
				selected = "selected";
			else
				selected = "";	
%>			
		  <OPTION <%= selected %> value="<%= optValue %>"><%= aGroup.groupName %></OPTION>
<%
		}
	}
%>			
			</SELECT></TD></TR>
        <TR>
          <TD class=altbg1>&nbsp;</TD>
          <TD class=altbg2 style="TEXT-ALIGN: right" align=right>
		  	<INPUT type=hidden name="advanceOptions" value="no"/>
		  	<INPUT class=checkbox type=checkbox id="chkAdvance" onclick="showAdvance()">更多选项 &nbsp; </TD></TR>
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
      <CENTER><INPUT class=button type=submit value=搜索用户 onclick="frmsearch.action='./send_notice.jsp';"></CENTER><BR>
<%
	if (totalCount >= 0)
	{
%>	  
	<table width="100%" border="0" cellpadding="0" cellspacing="0" class="info_tb">
	<tr class="header"><td colspan=2>发送论坛通知 -&nbsp; 符合条件的会员数: <%= totalCount %></td></tr>
	<tbody id="messagebody">
		<tr>
			<td class="altbg1">标题:</td>
			<td class="altbg2"><input type="text" name="subject" size="80" value=""></td>
		</tr>
		<tr>
			<td class="altbg1" valign="top">内容:</td><td class="altbg2">
			<textarea cols="82" rows="10" name="message" style="width:429px"></textarea></td></tr>
		<tr>
			<td class="altbg1">发送方式:</td>
			<td class="altbg2">
			<input class="radio" type="radio" value="email" name="sendby"> Email
			<input class="radio" type="radio" value="sms" checked name="sendby"> 短消息</td></tr>
	</tbody></table><br/>
	<center><input class="button" type="submit" value="发送通知" onclick="$('frmsearch').action='../perform.jsp';"></center>
<%
	}
%>	
	</FORM></TD></TR></TBODY></TABLE><BR><BR>
<script language="javascript">
function showAdvance()
{
	$('advanceoption').style.display = $('chkAdvance').checked ? '' : 'none';
}
function checkfields(theform) {
	if (theform.action.indexOf('/perform.jsp') >= 0)
	{
		if (trim(theform.subject.value) == '') {
			alert('通知标题不可以为空');
      		theform.subject.focus();
			return;
		}
		if (trim(theform.message.value) == '') {
			alert('通知内容不可以为空');
      		theform.message.focus();
			return;
		}
	}
	theform.advanceOptions.value = $('advanceoption').style.display == 'none' ? 'no' : 'yes';
	theform.submit();
}
<%
	if (totalCount >= 0)
	{
%>
$('frmsearch').userID.value = "<%= PageUtils.getHTMLParam(request,"userID") %>";
$('state[<%= PageUtils.getParam(request,"state") %>]').checked = "true";
$('frmsearch').email.value = "<%= PageUtils.getHTMLParam(request,"email") %>";
$('frmsearch').maxCredits.value = "<%= PageUtils.getHTMLParam(request,"maxCredits") %>";
$('frmsearch').minCredits.value = "<%= PageUtils.getHTMLParam(request,"minCredits") %>";
$('frmsearch').maxPosts.value = "<%= PageUtils.getHTMLParam(request,"maxPosts") %>";
$('frmsearch').minPosts.value = "<%= PageUtils.getHTMLParam(request,"minPosts") %>";
$('frmsearch').remoteIP.value = "<%= PageUtils.getHTMLParam(request,"remoteIP") %>";
$('frmsearch').maxCreateTime.value = "<%= PageUtils.getHTMLParam(request,"maxCreateTime") %>";
$('frmsearch').minCreateTime.value = "<%= PageUtils.getHTMLParam(request,"minCreateTime") %>";
$('frmsearch').maxLastVisited.value = "<%= PageUtils.getHTMLParam(request,"maxLastVisited") %>";
$('frmsearch').minLastVisited.value = "<%= PageUtils.getHTMLParam(request,"minLastVisited") %>";
$('chkAdvance').checked = <%= PageUtils.getHTMLParam(request,"advanceOptions").equals("yes") %>;
<%
	}
%>	  
</script>	  
<%= PageUtils.getAdminFooter(request) %>
</BODY></HTML>
