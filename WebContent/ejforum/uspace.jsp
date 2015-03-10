<%@ page contentType="text/html;charset=gbk" errorPage="error.jsp"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="java.util.HashMap"%>
<%@ page import="com.hongshee.ejforum.util.PageUtils"%>
<%@ page import="com.hongshee.ejforum.util.AppUtils"%>
<%@ page import="com.hongshee.ejforum.common.CacheManager"%>
<%@ page import="com.hongshee.ejforum.common.ForumSetting"%>
<%@ page import="com.hongshee.ejforum.common.IConstants"%>
<%@ page import="com.hongshee.ejforum.data.BoardDAO.BoardVO"%>
<%@ page import="com.hongshee.ejforum.data.SectionDAO.SectionVO"%>
<%@ page import="com.hongshee.ejforum.data.UserDAO.UserInfo"%>
<%@ page import="com.hongshee.ejforum.data.UserDAO.UserVO"%>
<%@ page import="com.hongshee.ejforum.data.GroupDAO.GroupVO"%>
<%@ page import="com.hongshee.ejforum.data.TopicDAO"%>
<%@ page import="com.hongshee.ejforum.data.TopicDAO.TopicInfo"%>
<%@ page import="com.hongshee.ejforum.data.ReplyDAO"%>
<%
	UserInfo userinfo = PageUtils.getSessionUser(request);

    GroupVO userGroup = PageUtils.getGroupVO(userinfo);
	if (userGroup.rights.indexOf(IConstants.PERMIT_VIEW_USERINFO) < 0)
	{
		request.setAttribute("errorMsg", "您没有查看个人信息的权限");
		request.getRequestDispatcher("/error.jsp").forward(request, response);
		return;
	}	

	boolean isModerator = false;
	if (userGroup.groupID == 'A' || userGroup.groupID == 'M' || userGroup.groupID == 'S')
		isModerator = true;

	String ctxPath = request.getContextPath()+"/ejforum";
	ForumSetting setting = ForumSetting.getInstance();
	String forumName = setting.getForumName();
	String title = PageUtils.getTitle(forumName);

	String[] menus = PageUtils.getHeaderMenu(request, userinfo);
	String homeUrl = "./index.jsp";
	String forumStyle = PageUtils.getForumStyle(request, response, null);
	CacheManager cache = CacheManager.getInstance();

	String userID = PageUtils.getParam(request, "uid");
	String act = request.getParameter("act");
	if (act == null || act.length() == 0)
		act = "topic";

	String spaceUrl = "./uspace.jsp?uid=" + userID;
	
	String strPageNo = request.getParameter("page");
	int pageNo = PageUtils.getPageNo(strPageNo);
	int pageRows = 15;

	Object[] result = null;
	
	if (act.equals("topic"))
		result = TopicDAO.getInstance().getUserTopics(userID, true, pageNo, pageRows);
	else		
		result = ReplyDAO.getInstance().getUserReplies(userID, true, pageNo, pageRows);
		
	if (result == null || result[2] == null)
	{		
		request.setAttribute("errorMsg", "此用户名不存在或已经被删除");
		request.getRequestDispatcher("/error.jsp").forward(request, response);
		return;
	}
	UserVO aUser = (UserVO)result[2];
	String nickname = (aUser.nickname==null || aUser.nickname.length()==0) ? aUser.userID : aUser.nickname;
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<HTML xmlns="http://www.w3.org/1999/xhtml">
<HEAD>
<TITLE><%= nickname %>的个人信息页 - <%= title %></TITLE>
<%= PageUtils.getMetas(title, null) %>
<LINK href="styles/<%= forumStyle %>/ejforum.css" type=text/css rel=stylesheet>
</HEAD>
<BODY onkeydown="if(event.keyCode==27) return false;">
<SCRIPT src="js/common.js" type=text/javascript></SCRIPT>
<DIV class=wrap>
<DIV id=header>
<%= PageUtils.getHeader(request, title) %>
<%= PageUtils.getHeadAdBanner(request, null) %></DIV>
<%= menus[0] %>
<DIV id=nav><A href="<%= homeUrl %>"><%= forumName %></A> &raquo; 个人信息页</DIV>
<DIV class=container>
<DIV class=spacectx><DIV class=mainbox>
<H2><a href="<%= spaceUrl %>&act=topic" class="<%= act.equals("topic")?"caton":"catoff" %>">主题</a>&nbsp;&nbsp;
	<a href="<%= spaceUrl %>&act=reply" class="<%= act.equals("reply")?"caton":"catoff" %>">回复</a></H2>
<TABLE cellSpacing=0 cellPadding=0>
  <TBODY>
<%
	if (result != null && result[1] != null)
	{
		SectionVO aSection = null;
		BoardVO aBoard = null;
		String topicUrl = null;
		String forumUrl = null;
		StringBuilder sbuf = new StringBuilder();
		int startSeq = (pageNo - 1) * pageRows;
		
		if (act.equals("topic")) 
		{
			ArrayList topicList = (ArrayList)result[1];
			TopicInfo aTopic = null;
			String lastPostUrl = null;
		
			for (int i=0; i<topicList.size(); i++)
			{
				aTopic = (TopicInfo)topicList.get(i);
				// if (aTopic.state == 'R') continue;

				aSection = cache.getSection(aTopic.sectionID);
				aBoard = cache.getBoard(aSection, aTopic.boardID);

				sbuf.setLength(0);
				sbuf.append("./forum-").append(aTopic.sectionID).append("-").append(aTopic.boardID).append("-1.html");
				forumUrl = sbuf.toString();

				sbuf.setLength(0);
				sbuf.append("./topic-").append(aTopic.topicID);
				topicUrl = sbuf.toString() + "-1.html";
				lastPostUrl = sbuf.toString() + "-999.html";
%>
  <TR>
    <TD><LABEL><A href="<%= forumUrl %>" 
		target="_blank"><%= aBoard.boardName %></A>&nbsp;&nbsp;|&nbsp;&nbsp;<%= aTopic.createTime %>
<%		
				if (isModerator && userGroup.rights.indexOf(IConstants.PERMIT_DELETE_POST) >= 0) {
					out.write("&nbsp;|&nbsp;&nbsp;<a href=\"manage.jsp?sid=");
					out.write(aSection.sectionID);
					out.write("&fid=");
					out.write(aBoard.boardID);
					out.write("&chkTopicID=");
					out.write(aTopic.topicID);
					out.write("&page=1&act=delete\">删除</a>");
				}
%></LABEL>
	  <A href="<%= topicUrl %>" target=_blank class="subject"><%= startSeq + i + 1 %>. <%= aTopic.title %></A>
<%
			if (aTopic.attachIcon != null) {
			 	if (aTopic.attachIcon.indexOf('I') >= 0) {
					out.write("<LABEL class=\"pic\">(&nbsp;图&nbsp;)&nbsp;</LABEL>");
				}
			 	else if (aTopic.attachIcon.indexOf('F') >= 0) {
					out.write("<LABEL class=\"pic\">(&nbsp;媒&nbsp;)&nbsp;</LABEL>");
				}
				if (aTopic.attachIcon.indexOf('A') >= 0) {
					out.write("<LABEL class=\"attach\">&nbsp;</LABEL>");
				}
			}
			if (aTopic.reward > 0) {
				out.write("<LABEL class=\"reward\">&nbsp;[&nbsp;积分&nbsp;" + aTopic.reward + "&nbsp;");
				if (aTopic.isSolved == 'T')
					out.write("&nbsp;已解决&nbsp;");
				out.write("]</LABEL>");
			}
			if (aTopic.isDigest == 'T') {
				out.write("<IMG alt=\"精华\" src=\"images/digest.gif\" align=\"absmiddle\" style=\"padding-bottom:1px\"/>");
			}
%>	  
  		<p>最后发表 <A href="<%= lastPostUrl %>" 
		target="_blank"><%= aTopic.lastPostTime %></A>&nbsp;&nbsp;|&nbsp;&nbsp;回复(<%= aTopic.replies %>)
		&nbsp;|&nbsp;&nbsp;查看(<%= aTopic.visits %>)</p>
	</TD></TR>
<%
			}
		}
		else
		{
			ArrayList replyList = (ArrayList)result[1];
			HashMap record = null;
			String replyID = null;
			
			for (int i=0; i<replyList.size(); i++)
			{
				record = (HashMap)replyList.get(i);
				// if (((String)record.get("STATE")).charAt(0) == 'R') continue;
				replyID = (String)record.get("REPLYID");
				
				aSection = cache.getSection((String)record.get("SECTIONID"));
				aBoard = cache.getBoard(aSection, (String)record.get("BOARDID"));

				sbuf.setLength(0);
				sbuf.append("./forum-").append(aSection.sectionID).append("-").append(aBoard.boardID).append("-1.html");
				forumUrl = sbuf.toString();

				sbuf.setLength(0);
				sbuf.append("./topic-").append((String)record.get("TOPICID")).append("-r").append(replyID)
					.append(".html#rid").append(replyID);
				topicUrl = sbuf.toString();
%>
  <TR>
    <TD><LABEL><A href="<%= forumUrl %>" target="_blank"><%= aBoard.boardName %></A>
		&nbsp;|&nbsp;&nbsp;<%= AppUtils.formatSQLTimeStr((String)record.get("CREATETIME")) %>
<%		
				if (isModerator && userGroup.rights.indexOf(IConstants.PERMIT_DELETE_POST) >= 0) {
					out.write("&nbsp;|&nbsp;&nbsp;<a href=\"manage.jsp?sid=");
					out.write(aSection.sectionID);
					out.write("&fid=");
					out.write(aBoard.boardID);
					out.write("&chkTopicID=");
					out.write((String)record.get("TOPICID"));
					out.write("&page=1&rid=");
					out.write(replyID);
					out.write("&act=delete\">删除</a>");
				}
%></LABEL>
	  <A href="<%= topicUrl %>" target=_blank class="subject"><%= startSeq + i + 1 %>. Re: <%= (String)record.get("TITLE") %> 
	  	(RID:<%= replyID %>)</A>
	</TD></TR>
<%
			}
		}
	}
	else
	{
%>	
  <TR>
    <TD><p>&nbsp;没有记录</p></TD></TR>
<%
	}
%>
</TBODY></TABLE></DIV>
<DIV class=pages_btns>
<%
	if (result != null && result[0] != null)
	{
%>	  
	<%= result[0] %>
<SCRIPT type=text/javascript>
var spaceUrl = "<%= spaceUrl %>&act=<%= act %>";
function viewPage(pageno)
{
	window.location = spaceUrl + "&page=" + pageno;
}
</SCRIPT>
<%
	}
%>
</DIV></DIV>
<%
	String avatarPath = ctxPath + "/upload/avatar/";
	String avatar = aUser.avatar;
	if (avatar == null || avatar.length() == 0)
		avatar = "sample/unknown.gif";
	String email = (aUser.isMailPub=='T' || isModerator)?aUser.email:"保密";
	String mypage = aUser.webpage;

	if (mypage == null)
		mypage = "#";
	else if (!mypage.toLowerCase().startsWith("http://"))
		mypage = "http://" + mypage;
	
	if (!isModerator && aUser.remoteIP != null)
		aUser.remoteIP = aUser.remoteIP.substring(0, aUser.remoteIP.lastIndexOf('.')+1) + "*";
	
	GroupVO	aGroup = PageUtils.getGroupVO(aUser.userID, aUser.groupID, aUser.credits, cache.getModerators());
	int count1 = -1;
	int count2 = aGroup.stars;
	if (aGroup.stars > 5)
	{
		count1 = aGroup.stars / 5;
		count2 = aGroup.stars % 5;
	}
	int maxAvatarSize = setting.getInt(ForumSetting.MISC, "maxAvatarPixels");
%>
<DIV class=side style="width:24%">
<DIV>
<H2>个人信息</H2>
<UL style="padding-bottom:12px">
  <LI class="side_info" style="padding-top:2px">
  	<H3><IMG src="<%= avatarPath %><%= avatar %>" border=0 onload="resizeImage(this, <%= maxAvatarSize %>);"></H3></LI>
  <LI class="side_info"><H3><%= nickname %></H3></LI>
  <LI class="side_info">
  	<H3><IMG src="images/user_add.gif" align="absmiddle" border="0">&nbsp; 
		<A href="./member/my_addfriend.jsp?uid=<%= aUser.userID %>" target=_blank>加为好友</A>&nbsp;&nbsp;
		<IMG src="images/sendsms.gif" align="absmiddle" border="0">&nbsp; 
		<A href="./member/sms_compose.jsp?uid=<%= aUser.userID %>" target=_blank>发短消息</A>
    </H3></LI>
</UL>
<% 
	if (aUser.brief != null && aUser.brief.length() > 0) {
%>
	<P style="padding-left:10px; padding-right:10px;"><%= aUser.brief %></P>
<%
	}
%>	
</DIV>
<DIV style="padding-bottom:5px;">
<H2>详细信息</H2>
<table class="info" border="0" cellspacing="0" cellpadding="0" width="100%">
	<tr><th>UID</th><td><%= aUser.userID %></td></tr>
	<tr><th>昵称</th><td><%= nickname %></td></tr>
	<tr><th>用户组</th><td><%= aGroup.groupName %></td></tr>
	<tr><th>级别</th><td>
		<%	for (int j=0; j<count1; j++) { %><IMG alt="Rank: <%= aGroup.stars %>" 
		src="images/star_5.gif" align="absmiddle" border="0"><% } for (int j=0; j<count2; j++) { %><IMG 
		alt="Rank: <%= aGroup.stars %>" src="images/star_1.gif" align="absmiddle" border="0"><% } %>
	</td></tr>
	<tr><th>帖子</th><td><%= aUser.posts %></td></tr>
	<tr><th>积分</th><td><%= aUser.credits %></td></tr>
	<tr><th>注册日期</th><td><%= aUser.createTime %></td></tr>
	<tr><th>上次访问</th><td><%= aUser.lastVisited %></td></tr>
	<tr><th>性别</th><td><%= aUser.gender=='M'?"男":(aUser.gender=='F'?"女":"保密") %></td></tr>
	<tr><th>生日</th><td><%= aUser.birth==null?"0000-00-00":aUser.birth %></td></tr>
	<tr><th>来自</th><td><%= aUser.city==null?"未知":aUser.city %> <%= aUser.remoteIP==null?"":aUser.remoteIP %></td></tr>
	<tr><th>个人主页</th><td>
		<a href="<%= mypage %>" target="_blank"><%= aUser.webpage==null?"无":aUser.webpage %></a></td></tr>
	<tr><th>QQ/MSN</th><td><%= aUser.icq==null?"无":aUser.icq %></td></tr>
	<tr><th>Email</th><td><p title="<%= email %>"><%= email %></p></td></tr>
</table>
</DIV></DIV></DIV></DIV>
<%= menus[1]==null?"":menus[1] %>
<%= menus[2]==null?"":menus[2] %>
<%= PageUtils.getFooter(request, forumStyle) %>
</BODY></HTML>
