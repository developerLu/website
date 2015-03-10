<%@ page contentType="text/html;charset=gbk" errorPage="../error.jsp"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="java.util.HashMap"%>
<%@ page import="com.hongshee.ejforum.util.PageUtils"%>
<%@ page import="com.hongshee.ejforum.util.AppUtils"%>
<%@ page import="com.hongshee.ejforum.common.CacheManager"%>
<%@ page import="com.hongshee.ejforum.data.UserDAO.UserInfo"%>
<%@ page import="com.hongshee.ejforum.data.ReplyDAO"%>
<%@ page import="com.hongshee.ejforum.data.BoardDAO.BoardVO"%>
<%
	UserInfo userinfo = PageUtils.getAdminUser(request, response);
	if (userinfo == null) return;

	String strPageNo = request.getParameter("page");
    int pageNo = PageUtils.getPageNo(strPageNo);
	
	Object[] result = ReplyDAO.getInstance().queryReply(request, pageNo);
	int totalCount = 0;

	CacheManager cache = CacheManager.getInstance();
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
            href="#">后台管理首页</A>&nbsp;&raquo;&nbsp;批量删帖</TD></TR></TBODY></TABLE><BR>
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
              <LI>批量删帖一般用于删除违规的回复帖子，如果要批量删除主题请使用批量主题管理。</LI>
              <LI>记录数量较多时可能会比较耗时，可以分次处理。</LI>
		    </UL></TD></TR></TBODY></TABLE><BR>
      <FORM id="settings" name="settings" action="../perform.jsp" method=post>
	  <input type="hidden" name="page" value="<%= pageNo %>">
	  <%= PageUtils.getQueryFields(request) %>
<%
	if (result != null && result[0] != null)
	{
		totalCount = ((Integer)result[2]).intValue();
%>	  
	<%= result[0] %>
<%
	}
	if (result != null && result[1] != null)
	{
		ArrayList replyList = (ArrayList)result[1];
		HashMap record = null;
		String userID = null;
		String sectionID = null;
		String boardID = null;
		String topicID = null;
		String replyID = null;
		String topicURL = null;
		String topicTitle = null;
		String tmpStr = null;
		BoardVO aBoard = null;
		StringBuilder sbuf = new StringBuilder();

		if (totalCount > 0) {
%>
      <TABLE class=info_tb cellSpacing=0 cellPadding=0 width="100%" border=0>
        <TBODY>
        <TR class=header>
          <TD width="14%">版块</TD>
          <TD width="40%">标题</TD>
          <TD width="14%">用户名</TD>
          <TD width="16%">主题发表时间</TD>
          <TD width="16%">发帖时间</TD>
		</TR>
<%
		}
		for (int i=0; i<replyList.size(); i++)
		{
			record = (HashMap)replyList.get(i);
			userID = (String)record.get("USERID");
			sectionID = (String)record.get("SECTIONID");
			boardID = (String)record.get("BOARDID");
			topicID = (String)record.get("TOPICID");
			topicTitle = (String)record.get("TITLE");
			replyID = (String)record.get("REPLYID");

			sbuf.setLength(0);
			sbuf.append("../../topic.jsp?fid=").append(boardID).append("&tid=").append(topicID);
			if (replyID != null && !replyID.equals("0"))
			{
				sbuf.append("&rid=").append(replyID).append("#rid").append(replyID);
				topicTitle = topicTitle + " (RID:" + replyID + ")";
			}
			topicURL = sbuf.toString();
			
			aBoard = cache.getBoard(sectionID, boardID);
%>	  
        <TR align=middle>
          <TD class=altbg1><A href="../../forum.jsp?fid=<%= boardID %>" 
                target=_blank><%= aBoard.boardName %></A></TD>
          <TD class=altbg2>
		  	<A href="<%= topicURL %>" target=_blank><%= topicTitle %></A></TD>
          <TD class=altbg1>
		  	<A href="../../uspace.jsp?uid=<%= userID %>" target=_blank><%= userID.length()==0?"游客":userID %></A></TD>
          <TD class=altbg2><%= AppUtils.formatSQLTimeStr((String)record.get("CREATETIME")) %></TD>
          <TD class=altbg1><%= AppUtils.formatSQLTimeStr((String)record.get("REPLYTIME")) %></TD>
		</TR>
<%
		}
		if (totalCount > 0) {
%>
	</TBODY></TABLE>
<%
		}
	}
	if (result != null && result[0] != null)
	{
%>	  
	<%= result[0] %>
<%
	}
	if (totalCount > 0) { out.write("<BR>"); }
%>	  
    <TABLE class=info_tb cellSpacing=0 cellPadding=0 width="100%" border=0>
        <TBODY>
		<tr class="header">
			<td colspan="2">符合条件的帖子数: <%= totalCount %></td>
		</tr>
		<tr>
			<td class="altbg1"><input class="radio" type="radio" name="exe_operation" value="delete" checked> 批量删除</td>
			<td class="altbg2">
				删帖但不减用户发帖数和积分</td>
		</tr>
	</TBODY></TABLE><br/>
		<p align="center">
			<input class="button" type="button" value="提 交" onclick="doAction();">&nbsp;&nbsp;
			<input class="button" type="button" value="刷 新" onclick="window.location.reload(true);">
		</p>
	</FORM>
	</TD></TR></TBODY></TABLE><BR><BR>
<script language="javascript">
function viewPage(pageno)
{
	$('settings').action = 'post_list.jsp';
	$('settings').page.value = pageno;
	$('settings').submit();
}
function doAction() {
	var totalCount = <%= totalCount %>;
 	if (totalCount <= 0) 
	{
		alert('没有符合条件的记录');
		return;
	}
	if (!confirm('您确定要执行批量删除吗?  '))
		return;
	$('settings').action = '../perform.jsp?act=forums_post_batch';
	$('settings').submit();
}
</script>	  
<%= PageUtils.getAdminFooter(request) %>
</BODY></HTML>
