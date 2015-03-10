<%@ page contentType="text/html;charset=gbk" errorPage="../error.jsp"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="com.hongshee.ejforum.util.PageUtils"%>
<%@ page import="com.hongshee.ejforum.data.UserDAO.UserInfo"%>
<%@ page import="com.hongshee.ejforum.common.CacheManager"%>
<%@ page import="com.hongshee.ejforum.common.AppContext"%>
<%@ page import="com.hongshee.ejforum.data.UserDAO"%>
<%@ page import="com.hongshee.ejforum.data.SectionDAO.SectionVO"%>
<%@ page import="com.hongshee.ejforum.data.BoardDAO.BoardVO"%>
<%@ page import="com.hongshee.ejforum.data.GroupDAO.GroupVO"%>
<%@ page import="com.hongshee.ejforum.common.IConstants"%>
<%
	UserInfo userinfo = PageUtils.getAdminUser(request, response);
	if (userinfo == null) return;
	
	String userID = PageUtils.getParam(request,"uid");
	UserInfo aUser = UserDAO.getInstance().getUserInfo(userID);
	
	CacheManager cache = CacheManager.getInstance();
    ArrayList sections = cache.getSections();
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
		<ul><li>用户可访问的板块仅由其所属的管理组和会员组决定，可在板块编辑处修改其访问权限，此处仅供查看。</li>
			<li>系统管理员具有所有板块的全部权限。</li>
		</ul>
		</td></tr></tbody></table><br/>
      <TABLE class=info_tb cellSpacing=0 cellPadding=0 width="100%" border=0>
        <TBODY>
        <TR class=header>
          <TD>板块权限 ( 用户:&nbsp;<%= userID %> )</TD>
          <TD>浏览版块</TD>
          <TD>发新话题</TD>
          <TD>发表回复</TD>
          <TD>下载/查看附件</TD>
          <TD>上传附件</TD></TR>
<%
	if (sections != null) 
	{
		SectionVO aSection = null;
		BoardVO aBoard = null;
		GroupVO aGroup = null;
		String checkimg1 = null;
		String checkimg2 = null;
		String checkimg3 = null;
		String checkimg4 = null;
		String checkimg5 = null;
		String empty = "";
		String checkimg = "<img src='../images/check_right.gif' border=0>";
		String checked = null;
		boolean isModerator = false;
		
		for (int i=0; i<sections.size(); i++)	
		{
			aSection = (SectionVO)sections.get(i);
			if (aSection.boardList != null && aSection.boardList.size() > 0)
			{
				for (int j=0; j<aSection.boardList.size(); j++)
				{
					aBoard = (BoardVO)aSection.boardList.get(j);
				    aGroup = PageUtils.getGroupVO(aUser, aSection, aBoard);

					if (aBoard.allowGroups != null 
						&& aBoard.allowGroups.indexOf(String.valueOf(aGroup.groupID)) >= 0)
						checked = "checked";
					else
						checked = "";

					if (aGroup.groupID == 'S' || aGroup.groupID == 'M')
						isModerator = true;
					else	
						isModerator = false;
						
					if (PageUtils.isPermitted(aBoard, aGroup, IConstants.PERMIT_VISIT_FORUM)) checkimg1 = checkimg;
						else checkimg1 = empty;
					if (PageUtils.isPermitted(aBoard, aGroup, IConstants.PERMIT_NEW_TOPIC)) checkimg2 = checkimg;
						else checkimg2 = empty;
					if (PageUtils.isPermitted(aBoard, aGroup, IConstants.PERMIT_NEW_REPLY)) checkimg3 = checkimg;
						else checkimg3 = empty;
					if (PageUtils.isPermitted(aBoard, aGroup, IConstants.PERMIT_DOWNLOAD)) checkimg4 = checkimg;
						else checkimg4 = empty;
					if (PageUtils.isPermitted(aBoard, aGroup, IConstants.PERMIT_UPLOAD)) checkimg5 = checkimg;
						else checkimg5 = empty;
%>
        <TR>
          <TD class=altbg1>
		  	<INPUT class=checkbox <%= checked %> type=checkbox name="boardID"> <%= aBoard.boardName %>
				<%= isModerator?"(&nbsp;版主&nbsp;)":"" %></TD>
          <TD class=altbg2>&nbsp;&nbsp;&nbsp;<%= checkimg1 %></TD>
          <TD class=altbg1>&nbsp;&nbsp;&nbsp;<%= checkimg2 %></TD>
          <TD class=altbg2>&nbsp;&nbsp;&nbsp;<%= checkimg3 %></TD>
          <TD class=altbg1>&nbsp;&nbsp;&nbsp;<%= checkimg4 %></TD>
          <TD class=altbg2>&nbsp;&nbsp;&nbsp;<%= checkimg5 %></TD></TR>
<%
				}
			}
		}
	}
%>		  
       </TBODY></TABLE>
      <BR>
      <CENTER><INPUT class=button type=button value="返回上一页" onclick="javascript:history.go(-1);"></CENTER>
	  </TD></TR></TBODY></TABLE><BR><BR>
<%= PageUtils.getAdminFooter(request) %>
</BODY></HTML>
