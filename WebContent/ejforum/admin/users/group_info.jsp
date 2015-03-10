<%@ page contentType="text/html;charset=gbk" errorPage="../error.jsp"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="com.hongshee.ejforum.util.PageUtils"%>
<%@ page import="com.hongshee.ejforum.common.CacheManager"%>
<%@ page import="com.hongshee.ejforum.data.UserDAO.UserInfo"%>
<%@ page import="com.hongshee.ejforum.data.GroupDAO.GroupVO"%>
<%
	UserInfo userinfo = PageUtils.getAdminUser(request, response);
	if (userinfo == null) return;
	String fromPath = PageUtils.getPathFromReferer(request);
	
	String groupID = request.getParameter("id");
	CacheManager cache = CacheManager.getInstance();
	GroupVO aGroup = cache.getGroup(groupID.charAt(0));
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
            href="#">后台管理首页</A>&nbsp;&raquo;&nbsp;编辑用户组权限</TD></TR></TBODY></TABLE><BR>
      <FORM id="settings" name="settings" onSubmit="checkfields(this); return false;" action="../perform.jsp" method=post>
	  <INPUT type=hidden name="act" value="users_group_info">
	  <INPUT type=hidden name="groupID" value="<%= groupID %>">
	  <INPUT type=hidden name="fromPath" value="<%= fromPath %>">
      <A name=tb01></A>
      <TABLE class=info_tb cellSpacing=0 cellPadding=0 width="100%" border=0>
        <TBODY>
        <TR class=header>
          <TD colSpan=2>基本权限<A onClick="collapse_change('tb01','../images')" href="#">
		  	<IMG id=menuimg_tb01 style="MARGIN-TOP: -12px; FLOAT: right; MARGIN-RIGHT: 8px" 
            src="../images/menu_reduce.gif" border=0></A> </TD></TR>
        <TBODY id=menu_tb01>
        <TR>
          <TD class=altbg1 width="45%"><B>允许访问论坛:</B><BR><SPAN 
            class=smalltxt>选择“否”将彻底禁止用户访问论坛的任何页面</SPAN></TD>
          <TD class=altbg2>
		  	<INPUT class=radio type=radio value="A" name="VISIT_FORUM" id="A[1]"> 是 &nbsp; &nbsp; 
			<INPUT class=radio type=radio CHECKED value="" name="VISIT_FORUM" id="A[0]"> 否 </TD></TR>
        <TR>
          <TD class=altbg1 width="45%"><B>允许查看会员列表:</B><BR><SPAN 
            class=smalltxt>设置是否允许查看论坛的会员列表</SPAN></TD>
          <TD class=altbg2>
		  	<INPUT class=radio type=radio value="B" name="VIEW_MEMBERS" id="B[1]"> 是 &nbsp; &nbsp; 
			<INPUT class=radio type=radio CHECKED value="" name="VIEW_MEMBERS" id="B[0]"> 否 </TD></TR>
        <TR>
          <TD class=altbg1 width="45%"><B>允许查看用户信息:</B><BR><SPAN 
            class=smalltxt>设置是否允许查看其它会员用户的信息页</SPAN></TD>
          <TD class=altbg2>
		  	<INPUT class=radio type=radio value="C" name="VIEW_USERINFO" id="C[1]"> 是 &nbsp; &nbsp; 
			<INPUT class=radio type=radio CHECKED value="" name="VIEW_USERINFO" id="C[0]"> 否 </TD></TR>
        <TR>
          <TD class=altbg1 width="45%"><B>允许查看统计数据:</B><BR><SPAN 
            class=smalltxt>设置是否允许用户查看论坛统计数据</SPAN></TD>
          <TD class=altbg2>
		  	<INPUT class=radio type=radio value="D" name="VIEW_STAT" id="D[1]"> 是 &nbsp; &nbsp; 
			<INPUT class=radio type=radio CHECKED value="" name="VIEW_STAT" id="D[0]"> 否 </TD></TR>
        <TR>
          <TD class=altbg1 width="45%"><B>允许上传头像:</B><BR>
            <SPAN 
            class=smalltxt>设置是否允许上传头像文件</SPAN></TD>
          <TD class=altbg2>
		  	<INPUT class=radio type=radio value="E" name="UPLOAD_AVATAR" id="E[1]"> 是 &nbsp; &nbsp; 
			<INPUT class=radio type=radio CHECKED value="" name="UPLOAD_AVATAR" id="E[0]"> 否 </TD></TR>
		</TBODY></TABLE>
      <BR><A name=tb02></A>
      <TABLE class=info_tb cellSpacing=0 cellPadding=0 width="100%" border=0>
        <TBODY>
        <TR class=header>
          <TD colSpan=2>帖子相关<A onClick="collapse_change('tb02','../images')" href="#">
		  	<IMG id=menuimg_tb02 style="MARGIN-TOP: -12px; FLOAT: right; MARGIN-RIGHT: 8px" 
            src="../images/menu_reduce.gif" border=0></A> </TD></TR>
        <TBODY id=menu_tb02>
        <TR>
          <TD class=altbg1 width="45%"><B>允许发新话题:</B><BR>
          <SPAN 
            class=smalltxt>设置是否允许发布新话题</SPAN></TD>
          <TD class=altbg2>
		  	<INPUT class=radio type=radio value="F" name="NEW_TOPIC" id="F[1]"> 是 &nbsp; &nbsp; 
			<INPUT class=radio type=radio CHECKED value="" name="NEW_TOPIC" id="F[0]"> 否 </TD></TR>
        <TR>
          <TD class=altbg1 width="45%"><B>允许发布悬赏主题:</B><BR><SPAN 
            class=smalltxt>设置是否允许发布悬赏主题，被评为最佳回复者将获得悬赏的积分</SPAN></TD>
          <TD class=altbg2>
		  	<INPUT class=radio type=radio value="W" name="NEW_REWARD" id="W[1]"> 是 &nbsp; &nbsp; 
			<INPUT class=radio type=radio CHECKED value="" name="NEW_REWARD" id="W[0]"> 否 </TD></TR>
        <TR>
          <TD class=altbg1 width="45%"><B>允许发匿名贴:</B><BR><SPAN 
            class=smalltxt>是否允许用户匿名发表主题和回复。匿名发帖不同于游客发帖，用户需要登录后才可使用，版主和管理员可以查看真实作者</SPAN></TD>
          <TD class=altbg2>
		  	<INPUT class=radio type=radio value="H" name="HIDE_POST" id="H[1]"> 是 &nbsp; &nbsp; 
			<INPUT class=radio type=radio CHECKED value="" name="HIDE_POST" id="H[0]"> 否 </TD></TR>
        <TR>
          <TD class=altbg1 width="45%"><B>允许发表回复:</B><BR>
            <SPAN 
            class=smalltxt>设置是否允许发表回复</SPAN></TD>
          <TD class=altbg2>
		  	<INPUT class=radio type=radio value="G" name="NEW_REPLY" id="G[1]"> 是 &nbsp; &nbsp; 
			<INPUT class=radio type=radio CHECKED value="" name="NEW_REPLY" id="G[0]"> 否 </TD></TR>
        <TR>
          <TD class=altbg1 width="45%"><B>允许使用&nbsp;HTML&nbsp;代码:</B><BR><SPAN 
            class=smalltxt>选择“是”则该用户组的作者可以在帖子中直接使用任何&nbsp;HTML&nbsp;代码。开放&nbsp;HTML&nbsp;
			功能将产生安全隐患，请慎用。建议只在十分必要的情况下使用，并限制只开放给最核心的管理人员
			</SPAN></TD>
          <TD class=altbg2>
		  	<INPUT class=radio type=radio value="I" name="USE_HTML" id="I[1]"> 是 &nbsp; &nbsp; 
			<INPUT class=radio type=radio CHECKED value="" name="USE_HTML" id="I[0]"> 否 </TD></TR>
        <TR>
          <TD class=altbg1 width="45%"><B>允许发置顶帖子:</B><BR><SPAN 
            class=smalltxt>设置是否允许直接发布在当前板块置顶的主题。</SPAN></TD>
          <TD class=altbg2>
		  	<INPUT class=radio type=radio value="T" name="TOP_POST" id="T[1]"> 是 &nbsp; &nbsp;
		  	<INPUT class=radio type=radio CHECKED value="" name="TOP_POST" id="T[0]"> 否 </TD></TR>
        </TBODY></TABLE>
      <BR><A name=tb03></A>
      <TABLE class=info_tb cellSpacing=0 cellPadding=0 width="100%" border=0>
        <TBODY>
        <TR class=header>
          <TD colSpan=2>附件相关<A onClick="collapse_change('tb03','../images')" href="#">
		  	<IMG id=menuimg_tb03 style="MARGIN-TOP: -12px; FLOAT: right; MARGIN-RIGHT: 8px" 
            src="../images/menu_reduce.gif" border=0></A> </TD></TR>
        <TBODY id=menu_tb03>
        <TR>
          <TD class=altbg1 width="45%"><B>允许下载/查看附件:</B><BR><SPAN 
            class=smalltxt>设置是否允许在论坛中下载或查看附件</SPAN></TD>
          <TD class=altbg2>
		  	<INPUT class=radio type=radio value="J" name="DOWNLOAD" id="J[1]"> 是 &nbsp; &nbsp; 
			<INPUT class=radio type=radio CHECKED value="" name="DOWNLOAD" id="J[0]"> 否 </TD></TR>
        <TR>
          <TD class=altbg1 width="45%"><B>允许发布附件:</B><BR><SPAN 
            class=smalltxt>设置是否允许上传附件到论坛中。</SPAN></TD>
          <TD class=altbg2>
		  	<INPUT class=radio type=radio value="K" name="UPLOAD" id="K[1]"> 是 &nbsp; &nbsp; 
			<INPUT class=radio type=radio CHECKED value="" name="UPLOAD" id="K[0]"> 否 </TD></TR>
        </TBODY></TABLE><BR>
<%
	if (aGroup.groupType == 'S' && aGroup.groupID != 'G')
	{
%>		
	  <A name=tb04></A>
      <TABLE class=info_tb cellSpacing=0 cellPadding=0 width="100%" border=0>
        <TBODY>
        <TR class=header>
          <TD colSpan=2>管理权限<A onclick="collapse_change('tb04','../images')" href="#">
			<IMG id=menuimg_tb04 style="MARGIN-TOP: -12px; FLOAT: right; MARGIN-RIGHT: 8px" 
            src="../images/menu_reduce.gif" border=0></A> </TD></TR>
        <TBODY id=menu_tb04>
        <TR>
          <TD class=altbg1 width="45%"><B>允许全局置顶主题:</B><BR><SPAN 
            class=smalltxt>设置是否允许在论坛全局置顶主题。如果设置为不允许，版主/超级版主的可置顶范围由其所负责的范围决定</SPAN></TD>
          <TD class=altbg2>
		  	<INPUT class=radio type=radio value="V" name="TOP_GLOBAL" id="V[1]"> 是 &nbsp; &nbsp;
		  	<INPUT class=radio type=radio CHECKED value="" name="TOP_GLOBAL" id="V[0]"> 否 </TD></TR>
        <TR>
          <TD class=altbg1 width="45%"><B>允许编辑帖子:</B><BR><SPAN 
            class=smalltxt>设置是否允许编辑管理范围内的帖子</SPAN></TD>
          <TD class=altbg2>
		  	<INPUT class=radio type=radio value="L" name="EDIT_POST" id="L[1]"> 是 &nbsp; &nbsp; 
			<INPUT class=radio type=radio CHECKED value="" name="EDIT_POST" id="L[0]"> 否 </TD></TR>
        <TR>
          <TD class=altbg1 width="45%"><B>允许删除帖子:</B><BR><SPAN 
            class=smalltxt>设置是否允许删除管理范围内的帖子</SPAN></TD>
          <TD class=altbg2>
		  	<INPUT class=radio type=radio value="M" name="DELETE_POST" id="M[1]"> 是 &nbsp; &nbsp; 
			<INPUT class=radio type=radio CHECKED value="" name="DELETE_POST" id="M[0]"> 否 </TD></TR>
        <TR>
          <TD class=altbg1 width="45%"><B>允许关闭主题:</B><BR>
            <SPAN class=smalltxt>设置是否允许关闭管理范围内的主题</SPAN></TD>
          <TD class=altbg2>
		  	<INPUT class=radio type=radio value="N" name="CLOSE_POST" id="N[1]"> 是 &nbsp; &nbsp; 
			<INPUT class=radio type=radio CHECKED value="" name="CLOSE_POST" id="N[0]"> 否 </TD></TR>
        <TR>
          <TD class=altbg1 width="45%"><B>允许移动主题:</B><BR>
            <SPAN class=smalltxt>设置是否允许移动管理范围内的主题</SPAN></TD>
          <TD class=altbg2>
		  	<INPUT class=radio type=radio value="O" name="MOVE_POST" id="O[1]"> 是 &nbsp; &nbsp; 
			<INPUT class=radio type=radio CHECKED value="" name="MOVE_POST" id="O[0]"> 否 </TD></TR>
        <TR>
          <TD class=altbg1 width="45%"><B>允许编辑用户:</B><BR><SPAN 
            class=smalltxt>设置是否允许编辑用户权限等资料</SPAN></TD>
          <TD class=altbg2>
		  	<INPUT class=radio type=radio value="P" name="EDIT_USER" id="P[1]"> 是 &nbsp; &nbsp; 
			<INPUT class=radio type=radio CHECKED value="" name="EDIT_USER" id="P[0]"> 否 </TD></TR>
        <TR>
          <TD class=altbg1 width="45%"><B>允许执行积分奖惩:</B><BR><SPAN 
            class=smalltxt>设置是否允许执行积分奖惩</SPAN></TD>
          <TD class=altbg2>
		  	<INPUT class=radio type=radio value="Q" name="EDIT_CREDITS" id="Q[1]"> 是 &nbsp; &nbsp; 
			<INPUT class=radio type=radio CHECKED value="" name="EDIT_CREDITS" id="Q[0]"> 否 </TD></TR>
        <TR>
          <TD class=altbg1 width="45%"><B>允许禁止用户:</B><BR><SPAN 
            class=smalltxt>设置是否允许禁止用户发帖或访问</SPAN></TD>
          <TD class=altbg2>
		  	<INPUT class=radio type=radio value="R" name="BAN_USER" id="R[1]"> 是 &nbsp; &nbsp; 
			<INPUT class=radio type=radio CHECKED value="" name="BAN_USER" id="R[0]"> 否 </TD></TR>
        <TR>
          <TD class=altbg1 width="45%"><B>允许审核用户:</B><BR><SPAN 
            class=smalltxt>设置是否允许审核新注册用户，只在论坛设置需要人工审核新用户时有效</SPAN></TD>
          <TD class=altbg2>
		  	<INPUT class=radio type=radio value="S" name="AUDIT_USER" id="S[1]"> 是 &nbsp; &nbsp; 
			<INPUT class=radio type=radio CHECKED value="" name="AUDIT_USER" id="S[0]"> 否 </TD></TR>
        <TR>
          <TD class=altbg1 width="45%"><B>允许删除用户:</B><BR><SPAN 
            class=smalltxt>设置是否允许删除用户及其帖子和附件</SPAN></TD>
          <TD class=altbg2>
		  	<INPUT class=radio type=radio value="U" name="DELETE_USER" id="U[1]"> 是 &nbsp; &nbsp; 
			<INPUT class=radio type=radio CHECKED value="" name="DELETE_USER" id="U[0]"> 否 </TD></TR>
        </TBODY></TABLE><BR>
<%
	}
%>		
      <CENTER><INPUT class=button type=submit value="提 交"></CENTER></FORM></TD></TR></TBODY></TABLE><BR><BR>
<script language="javascript">
function checkfields(theform) {
	theform.submit();
}
<%
	char right = ' ';
	String elemID = "";
	for (int i=0; i<aGroup.rights.length(); i++)
	{
		right = aGroup.rights.charAt(i);
		elemID = String.valueOf(right) + "[1]";
%>
$('<%= elemID %>').checked = "true";
<%
	}
%>
</script>	  
<%= PageUtils.getAdminFooter(request) %>
</BODY></HTML>