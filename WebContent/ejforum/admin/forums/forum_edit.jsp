<%@ page contentType="text/html;charset=gbk" errorPage="../error.jsp"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="com.hongshee.ejforum.util.PageUtils"%>
<%@ page import="com.hongshee.ejforum.common.CacheManager"%>
<%@ page import="com.hongshee.ejforum.data.UserDAO.UserInfo"%>
<%@ page import="com.hongshee.ejforum.data.SectionDAO.SectionVO"%>
<%@ page import="com.hongshee.ejforum.data.BoardDAO.BoardVO"%>
<%
	UserInfo userinfo = PageUtils.getAdminUser(request, response);
	if (userinfo == null) return;
	String adminPath = request.getContextPath() + "/admin";
	String fromPath = adminPath + "/forums/forum_edit.jsp";

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
          <TD>
		    <A onclick="parent.location='../index.htm'; return false;" href="#">后台管理首页</A>&nbsp;&raquo;&nbsp;编辑版块
		  </TD></TR></TBODY></TABLE><BR>
      <TABLE class=info_tb cellSpacing=0 cellPadding=0 width="100%" border=0>
        <TBODY>
        <TR class=header>
          <TD>编辑版块</TD></TR>
        <TR>
          <TD class=altbg1><BR>
      <FORM id=settings name=settings onSubmit="checkfields(this); return false;" action="../perform.jsp" method=post>
	  <INPUT type=hidden name="act" value="forums_forum_edit">
	  <INPUT type=hidden name="fromPath" value="<%= fromPath %>">
<%
	if (sections != null) 
	{
		SectionVO aSection = null;
		BoardVO aBoard = null;
		StringBuilder sbuf = null;
		String forumUrl = null;
		StringBuilder moderator = null;
		String[] users = null;
		
		for (int i=0; i<sections.size(); i++)	
		{
			aSection = (SectionVO)sections.get(i);
			if (aSection.moderator != null && aSection.moderator.trim().length()>0)
			{
	            users = aSection.moderator.split(",");
				moderator = new StringBuilder(": ");
	            for (int k=0; k<users.length; k++)
       			{
	                if (users[k].trim().length() > 0)
       			    {
						if (k>0) moderator.append(", ");
						moderator.append("<a href='../../uspace.jsp?uid=").append(users[k])
						         .append("' target='_blank'>").append(users[k]).append("</a>");
					}
				}
			}			
			else
				moderator = new StringBuilder();
%>
            <UL>
              <LI><A href="../../index.jsp?sid=<%= aSection.sectionID %>" 
			  	target=_blank><B><%= aSection.sectionName %></B></A> - 显示顺序: 
			  <INPUT size=1 value="<%= String.valueOf(aSection.seqno) %>" name="seqno"> - 
			  <INPUT type=hidden value="s<%= aSection.sectionID %>" name="id">
              [&nbsp;<A title="编辑本版块设置" href="section_edit.jsp?sid=<%= aSection.sectionID %>">编辑</A>&nbsp;]
              [&nbsp;<A title="删除本版块及其中所有帖子" 
			  	href='javascript:deleteSection("<%= aSection.sectionID %>", "<%= aSection.sectionName %>")'>删除</A>&nbsp;]
                - [&nbsp;<A title="编辑本版块版主" 
					href="forum_moderator.jsp?sid=<%= aSection.sectionID %>">分区版主</A><%= moderator.toString() %>&nbsp;]
				<BR>
<%
			if (aSection.boardList != null && aSection.boardList.size() > 0)
			{
				for (int j=0; j<aSection.boardList.size(); j++)
				{
					aBoard = (BoardVO)aSection.boardList.get(j);
					sbuf = new StringBuilder();
					sbuf.append("../../forum-").append(aSection.sectionID)
					    .append('-').append(aBoard.boardID).append("-1.html");
					forumUrl = sbuf.toString();

					if (aBoard.moderator != null && aBoard.moderator.trim().length()>0)
					{
			            users = aBoard.moderator.split(",");
						moderator = new StringBuilder(": ");
			            for (int k=0; k<users.length; k++)
            			{
			                if (users[k].trim().length() > 0)
            			    {
								if (k>0) moderator.append(", ");
								moderator.append("<a href='../../uspace.jsp?uid=").append(users[k])
								         .append("' target='_blank'>").append(users[k]).append("</a>");
							}
						}
					}
					else
						moderator = new StringBuilder();
%>
              <UL>
                <LI><A href="<%= forumUrl %>" target=_blank><B><%= aBoard.boardName %></B></A> - 显示顺序: 
				<INPUT size=1 value="<%= String.valueOf(aBoard.seqno) %>" name="seqno"> - 
				<INPUT type=hidden value="f<%= aBoard.boardID %>" name="id">
                [&nbsp;<A title="编辑本版块设置" 
					href="forum_info.jsp?sid=<%= aSection.sectionID %>&fid=<%= aBoard.boardID %>">编辑</A>&nbsp;]
                [&nbsp;<A title="将本版块的设置复制到其它版块" 
				    href="forum_copy.jsp?sid=<%= aSection.sectionID %>&fid=<%= aBoard.boardID %>">复制板块设置</A>&nbsp;]
                [&nbsp;<A title="删除本版块及其中所有帖子" href='javascript:deleteBoard("<%= aSection.sectionID %>",
						"<%= aBoard.boardID %>","<%= aBoard.boardName %>")'>删除</A>&nbsp;]
	               - [&nbsp;<A title=编辑本版块版主 
href="forum_moderator.jsp?sid=<%= aSection.sectionID %>&fid=<%= aBoard.boardID %>">本版版主</A><%= moderator.toString() %>&nbsp;]
			   <BR></LI></UL>
<%
				}
			}
%>				   
			</LI></UL><BR>
<%
		}
	}
%>			
            <CENTER><INPUT class=button type=submit value="提 交"></CENTER><BR></FORM>
			</TD></TR></TBODY></TABLE></TD></TR></TBODY></TABLE><BR><BR>
<script language="javascript">
function checkfields(theform) {
    var filter = /^\d+$/;
	for (i=0; i<theform.seqno.length; i++)
	{
	    if (!filter.test(trim(theform.seqno[i].value))) {
    		alert('显示顺序必须为整数');
      		theform.seqno[i].focus();
			return;
		}
    }
	theform.submit();
}
function deleteSection(id,name)
{
	if (confirm('您确实要删除分区"' + name + '"吗?'))
		window.location = "<%= adminPath %>" + "/perform.jsp?act=forums_section_delete&sid=" + id;
}
function deleteBoard(sid,fid,name)
{
	if (confirm('您确实要删除板块"' + name + '"，同时清除其中的帖子和附件吗?\n注意：删除板块不会更新用户发帖数和积分。'))
		if (confirm('本操作不可恢复，确实要继续吗？'))
			window.location = "<%= adminPath %>" + "/perform.jsp?act=forums_board_delete&fid=" + fid + "&sid=" + sid;
}
</script>		
<%= PageUtils.getAdminFooter(request) %>
</BODY></HTML>