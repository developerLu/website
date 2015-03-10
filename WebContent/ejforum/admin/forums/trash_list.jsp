<%@ page contentType="text/html;charset=gbk" errorPage="../error.jsp"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="java.util.HashMap"%>
<%@ page import="com.hongshee.ejforum.util.PageUtils"%>
<%@ page import="com.hongshee.ejforum.util.AppUtils"%>
<%@ page import="com.hongshee.ejforum.data.UserDAO.UserInfo"%>
<%@ page import="com.hongshee.ejforum.data.TrashBoxDAO"%>
<%
	UserInfo userinfo = PageUtils.getAdminUser(request, response);
	if (userinfo == null) return;

	String strPageNo = request.getParameter("page");
    int pageNo = PageUtils.getPageNo(strPageNo);
	
	Object[] result = TrashBoxDAO.getInstance().searchTrashBox(request, pageNo);
	int totalCount = 0;
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
          <TD><A onclick="parent.location='../index.htm';return false;" 
            href="#">后台管理首页</A>&nbsp;&raquo;&nbsp;帖子回收站</TD></TR></TBODY></TABLE><BR>
      <FORM id="settings" name="settings" action="../perform.jsp" method=post>
	  <input type="hidden" name="page" value="<%= pageNo %>">
	  <%= PageUtils.getQueryFields(request) %>
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
              <LI>从回收站还原帖子时，不会还原用户的发帖数和积分，请删除帖子时谨慎操作。</LI>
              <LI>此处的"删除"是指将帖子从回收站彻底清除，"归档"是指将帖子移动到备份表中，同时从回收站彻底清除。</LI>
              <LI>已归档的帖子不能再还原，只能手动查询备份表，请谨慎操作。</LI>
			  <LI>版主只能执行还原操作，只有管理员才能执行删除和归档操作。</LI></UL>
		  </TD></TR></TBODY></TABLE><BR>
<%
	if (result != null && result[0] != null)
	{
%>	  
	<%= result[0] %>
<%
	}
%>	  
      <TABLE class=info_tb cellSpacing=0 cellPadding=0 width="100%" border=0>
        <TBODY>
        <TR class=header>
          <TD width="10%">版块</TD>
          <TD width="35%">标题</TD>
          <TD width="10%">用户名</TD>
          <TD width="10%">删帖用户</TD>
          <TD width="15%">删帖时间</TD>
          <TD width="20%">操作</TD></TR>
<%
	if (result != null && result[1] != null)
	{
		ArrayList trashList = (ArrayList)result[1];
		HashMap record = null;
		String userID = null;
		String boardID = null;
		String topicID = null;
		String replyID = null;
		String topicURL = null;
		String topicTitle = null;
		StringBuilder sbuf = new StringBuilder();

		totalCount = trashList.size();
		
		for (int i=0; i<totalCount; i++)
		{
			record = (HashMap)trashList.get(i);
			userID = (String)record.get("USERID");
			boardID = (String)record.get("BOARDID");
			topicID = (String)record.get("TOPICID");
			topicTitle = (String)record.get("TOPICTITLE");
			replyID = (String)record.get("REPLYID");

			sbuf.setLength(0);
			sbuf.append("../../topic.jsp?fid=").append(boardID).append("&tid=").append(topicID);
			if (replyID != null && !replyID.equals("0"))
			{
				sbuf.append("&rid=").append(replyID).append("#rid").append(replyID);
				topicTitle = topicTitle + " (RID:" + replyID + ")";
			}
			topicURL = sbuf.toString();
%>	  
        <TR align=middle>
          <TD class=altbg1><A href="../../forum.jsp?fid=<%= boardID %>" 
                target=_blank><%= (String)record.get("BOARDNAME") %></A></TD>
          <TD class=altbg2>
		  	<A href="<%= topicURL %>" target=_blank><%= topicTitle %></A></TD>
          <TD class=altbg1><%= userID.length()==0?"游客":userID %></TD>
          <TD class=altbg2><%= (String)record.get("DELETEUSER") %></TD>
          <TD class=altbg1><%= AppUtils.formatSQLTimeStr((String)record.get("CREATETIME")) %></TD>
          <TD class=altbg2>
				[&nbsp;<a href="#" 
					onclick="doAction('forums_trash_delete','<%= topicID %>','<%= replyID %>','<%= boardID %>');">删除</a>&nbsp;]
				[&nbsp;<a href="#" 
					onclick="doAction('forums_trash_archive','<%= topicID %>','<%= replyID %>','<%= boardID %>');">归档</a>&nbsp;]
				[&nbsp;<a href="#" 
					onclick="doAction('forums_trash_restore','<%= topicID %>','<%= replyID %>','<%= boardID %>');">还原</a>&nbsp;]
		  </TD>
		</TR>
<%
		}
	}
%>		  
	</TBODY></TABLE>
<%
	if (result != null && result[0] != null)
	{
%>	  
	<%= result[0] %>
<%
	}
%>	  
		<p align="center">
			<input class="button" type="button" value="全部删除" onclick="doAction('forums_trash_delete_all',0,0,0);">&nbsp;
			<input class="button" type="button" value="全部归档" onclick="doAction('forums_trash_archive_all',0,0,0);">&nbsp;
			<input class="button" type="button" value="全部还原" onclick="doAction('forums_trash_restore_all',0,0,0);">&nbsp;
			<input class="button" type="button" value="刷 新" onclick="window.location.reload(true);">
		</p>
	</FORM>
	</TD></TR></TBODY></TABLE><BR><BR>
<script language="javascript">
function viewPage(pageno)
{
	$('settings').action = 'trash_list.jsp';
	$('settings').page.value = pageno;
	$('settings').submit();
}
function doAction(act, topicID, replyID, boardID) {
	if (act == 'forums_trash_delete' || act == 'forums_trash_restore' || act == 'forums_trash_archive')
	{
		if (act == 'forums_trash_delete' && !confirm('您确定要删除所选的记录吗?'))
			return;
		if (act == 'forums_trash_archive' && !confirm('您确定要将所选的记录归档吗?'))
			return;
		$('settings').action = '../perform.jsp?tid=' + topicID + '&rid=' + replyID + '&fid=' + boardID + '&act=' + act;
	}
	else
	{
		var totalCount = <%= totalCount %>;
	 	if (totalCount <= 0) 
		{
			alert('没有符合条件的记录');
			return;
		}
		if (act == 'forums_trash_delete_all' && !confirm('您确定要删除当前列表的全部记录吗?'))
			return;
		if (act == 'forums_trash_archive_all' && !confirm('您确定要将当前列表的记录全部归档吗?'))
			return;
		if (act == 'forums_trash_restore_all' && !confirm('您确定要将当前列表的记录全部还原吗?'))
			return;
		$('settings').action = '../perform.jsp?act=' + act;
	}
	$('settings').submit();
}
</script>	  
<%= PageUtils.getAdminFooter(request) %>
</BODY></HTML>
