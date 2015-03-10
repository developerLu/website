<%@ page contentType="text/html;charset=gbk"%>
<%@ page import="com.hongshee.ejforum.util.PageUtils"%>
<%@ page import="com.hongshee.ejforum.common.ForumSetting"%>
<%@ page import="com.hongshee.ejforum.common.IConstants"%>
<%@ page import="com.hongshee.ejforum.common.CacheManager"%>
<%@ page import="com.hongshee.ejforum.data.UserDAO.UserInfo"%>
<%@ page import="com.hongshee.ejforum.data.BoardDAO.BoardVO"%>
<%@ page import="com.hongshee.ejforum.data.SectionDAO.SectionVO"%>
<%@ page import="com.hongshee.ejforum.data.GroupDAO.GroupVO"%>
<%
	PageUtils.checkReferer(request); // Enhance security
	String ctxPath = request.getContextPath()+"/ejforum";
	
	UserInfo userinfo = PageUtils.getSessionUser(request);

	String sectionID = request.getParameter("sid");
	String boardID = request.getParameter("fid");

	String topicID = request.getParameter("tid");
	String replyID = request.getParameter("rid");

	CacheManager cache = CacheManager.getInstance();
	SectionVO aSection = cache.getSection(sectionID);
	BoardVO aBoard = cache.getBoard(aSection, boardID);

	String actTitle = "举报违规帖子";
	
	String forumName = ForumSetting.getInstance().getForumName();
	String title = PageUtils.getTitle(forumName);
	String[] menus = PageUtils.getHeaderMenu(request, userinfo);
	
	StringBuilder sbuf = new StringBuilder();
	sbuf.append("./forum-").append(aSection.sectionID).append("-").append(aBoard.boardID).append("-1.html");
	String forumUrl = sbuf.toString();
	String homeUrl = "./index.jsp";
	String forumStyle = PageUtils.getForumStyle(request, response, aBoard);
	
	String strPageNo = request.getParameter("page");
	int pageNo = PageUtils.getPageNo(strPageNo);
	if (replyID != null && replyID.equals("0"))
		pageNo = 1;
	
	sbuf.setLength(0);
	sbuf.append("perform.jsp?act=report").append("&sid=").append(sectionID).append("&fid=").append(boardID);
	String performUrl = sbuf.toString();

	ForumSetting setting = ForumSetting.getInstance();
	String showSectionLink = setting.getString(ForumSetting.DISPLAY, "showSectionLink");
	String sectionLink = null;
	if (showSectionLink.equalsIgnoreCase("yes"))
	{
		sbuf.setLength(0);
		sbuf.append(" &raquo;&nbsp; <A href=\"./index.jsp?sid=").append(sectionID)
			.append("\">").append(aSection.sectionName).append("</A>");
		sectionLink = sbuf.toString();
	}

	String topicUrl = null;
	if (topicID != null && topicID.length() > 0)
	{
		String topicTitle = PageUtils.getParam(request, "topic");
		sbuf.setLength(0);
		sbuf.append("<A href=\"./topic-").append(topicID);
		if (replyID != null && !replyID.equals("0"))
			sbuf.append("-r").append(replyID).append(".html#rid").append(replyID)
			    .append("\">").append(topicTitle)
			    .append(" (RID:").append(replyID).append(")").append("</A>");
		else
			sbuf.append("-1.html\">").append(topicTitle).append("</A>");
		topicUrl = sbuf.toString();
	}
	else
	{
		topicUrl = "";
	}

	String[] judgeOptions = {"垃圾广告","恶意灌水","违规内容","文不对题","重复发帖"};
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<HTML xmlns="http://www.w3.org/1999/xhtml">
<HEAD>
<TITLE><%= actTitle %> - <%= aBoard.boardName %> - <%= title %></TITLE>
<LINK href="styles/<%= forumStyle %>/ejforum.css" type=text/css rel=stylesheet>
</HEAD>
<BODY onkeydown="if(event.keyCode==27) return false;">
<SCRIPT src="js/common.js" type=text/javascript></SCRIPT>
<DIV class=wrap>
<DIV id=header>
<%= PageUtils.getHeader(request, title) %>
<%= PageUtils.getHeadAdBanner(request, null) %></DIV>
<%= menus[0] %>
<DIV id=nav><A href="<%= homeUrl %>"><%= forumName %></A><%= sectionLink==null?"":sectionLink %> &raquo;&nbsp; 
<A href="<%= forumUrl %>"><%= aBoard.boardName %></A> &raquo;&nbsp; <%= topicUrl %> &raquo;&nbsp; <%= actTitle %></DIV>
<form method="post" action="<%= performUrl %>" id="postform">
	<div class="mainbox formbox">
	<h1><%= actTitle %></h1>
	<table summary="Operating" cellspacing="0" cellpadding="0">
	<thead>
		<tr>
			<th>用户名</th>
			<td><%= userinfo==null?"游客":userinfo.userID %></td>
		</tr>
	</thead>
		<tr>
			<th>标题</th>
			<td><%= topicUrl %></td>
		</tr>		
		<tr>
			<th valign="top">举报原因</th>
			<td>
			<select id="reasons" name="reasons" onchange="this.form.reason.value=this.value" style="width:110px;">
			<option value="">自定义</option>
			<option value="">------------</option>
<%	for (int i=0; i<judgeOptions.length; i++) { %>
			<option value="<%= judgeOptions[i].length()==0?"":judgeOptions[i].replace("\"", "&quot;") %>">
				<%= judgeOptions[i].length()==0?"------------":judgeOptions[i].replace("\"", "&quot;") %></option>
<%	} %>
			</select>&nbsp;
		<input type=text id="reason" name="reason" size="50"/>
			</td>
		</tr>
		<tr class="btns">
			<th>&nbsp;</th>
			<td height="30"><button type="submit" name="modsubmit" id="postsubmit" class=submit>提交</button>
		</tr>
	</table>
		<input type="hidden" name="topicID" value="<%= topicID %>"/>
<% if (replyID != null) { %><input type="hidden" name="replyID" value="<%= replyID %>"/> <% } %>
	</div>
</form>
</DIV>
<%= menus[1]==null?"":menus[1] %>
<%= menus[2]==null?"":menus[2] %>
<%= PageUtils.getFooter(request, forumStyle) %>
</BODY></HTML>