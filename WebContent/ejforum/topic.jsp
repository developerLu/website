<%@ page contentType="text/html;charset=gbk" errorPage="error.jsp"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="java.util.Calendar"%>
<%@ page import="com.hongshee.ejforum.util.PageUtils"%>
<%@ page import="com.hongshee.ejforum.util.AppUtils"%>
<%@ page import="com.hongshee.ejforum.common.ForumSetting"%>
<%@ page import="com.hongshee.ejforum.common.IConstants"%>
<%@ page import="com.hongshee.ejforum.common.CacheManager"%>
<%@ page import="com.hongshee.ejforum.data.UserDAO.UserInfo"%>
<%@ page import="com.hongshee.ejforum.data.BoardDAO.BoardVO"%>
<%@ page import="com.hongshee.ejforum.data.SectionDAO.SectionVO"%>
<%@ page import="com.hongshee.ejforum.data.TopicDAO"%>
<%@ page import="com.hongshee.ejforum.data.ReplyDAO"%>
<%@ page import="com.hongshee.ejforum.data.TopicDAO.TopicVO"%>
<%@ page import="com.hongshee.ejforum.data.ReplyDAO.PostVO"%>
<%@ page import="com.hongshee.ejforum.data.GroupDAO.GroupVO"%>
<%@ page import="com.hongshee.ejforum.data.AttachDAO.AttachVO"%>
<%
	UserInfo userinfo = PageUtils.getSessionUser(request);
	
	ForumSetting setting = ForumSetting.getInstance();
	int pageRows = setting.getInt(ForumSetting.DISPLAY, "postsPerPage");
	int pageNo = 1;

	String topicID = request.getParameter("tid");
	String replyID = request.getParameter("rid");
    if (replyID != null && replyID.length() > 0)
	{
		pageNo = ReplyDAO.getInstance().getPageNo(topicID, replyID, pageRows, userinfo);
	}
	else
	{
		String strPageNo = request.getParameter("page");
		pageNo = PageUtils.getPageNo(strPageNo);
	}
	
	StringBuilder sbuf = new StringBuilder();
	sbuf.append("./topic.jsp?tid=").append(topicID);
	String baseUrl = response.encodeURL(sbuf.toString());
	
	TopicVO aTopic = TopicDAO.getInstance().getTopic(request, topicID, pageNo, pageRows, userinfo, baseUrl);
	if (aTopic == null)
	{		
		request.setAttribute("errorMsg", "此主题不存在或已经被删除");
		request.getRequestDispatcher("/error.jsp").forward(request, response);
		return;
	}

	String sectionID = aTopic.sectionID;
	String boardID = aTopic.boardID;

	CacheManager cache = CacheManager.getInstance();
	SectionVO aSection = cache.getSection(sectionID);
	BoardVO aBoard = cache.getBoard(aSection, boardID);

	GroupVO userGroup = PageUtils.getGroupVO(userinfo, aSection, aBoard);
	if (!PageUtils.isPermitted(aBoard,userGroup,IConstants.PERMIT_VISIT_FORUM) 
		|| aBoard.allowGroups.indexOf(userGroup.groupID) < 0)
	{
		if (userinfo == null)  // Guest
		{
			String fromPath = request.getRequestURI();
			String queryStr = request.getQueryString();
			if (queryStr != null)
				fromPath = fromPath + "?" + queryStr;
			request.setAttribute("fromPath", fromPath);
			request.getRequestDispatcher("/login.jsp").forward(request, response);
			return;
		}
		else
		{
			request.setAttribute("errorMsg", "很抱歉，您缺乏足够的访问权限");
			request.getRequestDispatcher("/error.jsp").forward(request, response);
			return;
		}
	}

	boolean isModerator = false;
	if (userGroup.groupID == 'A' || userGroup.groupID == 'M' || userGroup.groupID == 'S')
		isModerator = true;

	if (aTopic.state=='R' && !isModerator)
	{		
		request.setAttribute("errorMsg", "此主题已经被删除");
		request.getRequestDispatcher("/error.jsp").forward(request, response);
		return;
	}

	String ctxPath = request.getContextPath()+"/ejforum";
	String serverName = request.getServerName();
	if (!ctxPath.equals("/"))
		serverName = serverName + ctxPath;
	String forumStyle = PageUtils.getForumStyle(request, response, aBoard);
	
	String forumName = setting.getForumName();
	String title = PageUtils.getTitle(forumName);
	String[] menus = PageUtils.getHeaderMenu(request, userinfo);
	int maxReplies = setting.getInt(ForumSetting.FUNCTIONS, "maxReplies");

	sbuf.setLength(0);
	sbuf.append("./forum-").append(sectionID).append("-").append(boardID).append("-1.html");
	String forumUrl = response.encodeURL(sbuf.toString());
	String homeUrl = response.encodeURL("./index.jsp");

	sbuf.setLength(0);
	sbuf.append("./post.jsp?sid=").append(sectionID).append("&fid=").append(boardID);
	String postUrl = response.encodeURL(sbuf.toString());

	sbuf.setLength(0);
	sbuf.append("report.jsp?sid=").append(sectionID).append("&fid=").append(boardID)
	    .append("&tid=").append(topicID).append("&page=").append(pageNo);
	String reportUrl = response.encodeURL(sbuf.toString());

    ArrayList sections = cache.getSections();
	
	String showSectionLink = setting.getString(ForumSetting.DISPLAY, "showSectionLink");
	String sectionLink = null;
	if (showSectionLink.equalsIgnoreCase("yes"))
	{
		sbuf.setLength(0);
		sbuf.append(" &raquo;&nbsp; <A href=\"./index.jsp?sid=").append(sectionID)
			.append("\">").append(aSection.sectionName).append("</A>");
		sectionLink = response.encodeURL(sbuf.toString());
	}
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<HTML xmlns="http://www.w3.org/1999/xhtml">
<HEAD>
<TITLE><%= aTopic.title %> - <%= aBoard.boardName %> - <%= title %></TITLE>
<%= PageUtils.getMetas(title, aBoard) %>
<LINK href="styles/<%= forumStyle %>/ejforum.css" type=text/css rel=stylesheet>
</HEAD>
<BODY onkeydown="if(event.keyCode==27) return false;">
<SCRIPT src="js/common.js" type=text/javascript></SCRIPT>
<SCRIPT src="js/topic.js" type=text/javascript></SCRIPT>
<DIV class=wrap>
<DIV id=header>
<%= PageUtils.getHeader(request, title) %>
<%= PageUtils.getHeadAdBanner(request, aBoard) %></DIV>
<%= menus[0] %>
<DIV id=foruminfo>
<DIV id=nav><A href="<%= homeUrl %>"><%= forumName %></A><%= sectionLink==null?"":sectionLink %> &raquo;&nbsp; 
<A href="<%= forumUrl %>"><%= aBoard.boardName %></A> &raquo;&nbsp; <%= aTopic.title %></DIV>
<DIV id=headsearch>
<SCRIPT type=text/javascript>
function doSearch() {
	if(trim($('frmsearch').q.value)=='')
	{
		alert('请输入搜索关键字');
		return false;
	}
	frmsearch.submit();
}
</SCRIPT>
<FORM id="frmsearch" name="frmsearch" 
	  action="http://www.google.cn/search" onsubmit="doSearch(); return false;" method=get target="google_window">
<INPUT type=hidden value="GB2312" name=ie> 
<INPUT type=hidden value="GB2312" name=oe> 
<INPUT type=hidden value=zh-CN name=hl> 
<INPUT type=hidden value="<%= serverName %>" name=sitesearch> 
<div onclick="javascript:window.open('http://www.google.cn/')" 
 style="cursor:pointer;float:left;width:70px;height:23px;background: url(images/google.png)! important;background: none; filter: 
 progid:DXImageTransform.Microsoft.AlphaImageLoader(src='images/google.png',sizingMethod='scale')"></div>&nbsp;
<INPUT maxLength=255 size=12 name=q class="search">&nbsp; 
<a href="#" onclick="doSearch(); return false;" style="vertical-align:middle">
<img src="styles/<%= forumStyle %>/images/search.gif" border="0" alt="站内搜索" align="absbottom"/></a>
</FORM></DIV></DIV>
<DIV id=ad_text></DIV>
<DIV class=pages_btns>
<div class="pages"><a href="<%= forumUrl %>" class="next"> &lsaquo;&lsaquo; 返回主题列表</a></div>
<%
	if (aTopic.pageHTML != null)
	{
%>	  
	<%= aTopic.pageHTML %>
<%
	}
%>
<SPAN class=postbtn id="newtopic" onmouseover="$('newtopic').id = 'newtopictmp';this.id = 'newtopic';showMenu(this.id);">
<A href="<%= postUrl %>"><IMG src="styles/<%= forumStyle %>/images/newtopic.gif" border=0></A></SPAN>
<SPAN class=replybtn><A href="javascript:replyTopic();">
<IMG alt="发表回复" src="styles/<%= forumStyle %>/images/reply.gif" border=0></A></SPAN></DIV>
<UL class="popmenu_popup newtopicmenu" id="newtopic_menu" style="display: none">
<LI><a href="<%= postUrl %>">发新话题</a></LI>		
<LI class="reward"><a href="<%= postUrl %>&act=reward">发布悬赏</a></LI>
</UL>
<%
	PostVO aPost = null;
	String userID = null;
	String nickname = null;
	String avatar = null;
	String avatarPath = ctxPath + "/upload/avatar/";
	GroupVO aGroup = null;
	boolean isManager = false;
	boolean isAuthor = false;
        String moderators = PageUtils.getModerators(aSection, aBoard);
	String showAvatar = setting.getString(ForumSetting.DISPLAY, "showAvatar");
	String showBrief = setting.getString(ForumSetting.DISPLAY, "showBrief");
	String spaceURL = response.encodeURL("uspace.jsp?uid=");
	StringBuilder userPostIDs = null;
	int seqno = 0;
	int startSeq = (aTopic.pageNo - 1) * pageRows;
	if (aTopic.pageNo > 1) startSeq++;

	Calendar cal = Calendar.getInstance();
	cal.add(Calendar.DATE, -3);

	boolean isTopicAuthor = false;
	if (userinfo != null && userinfo.userID.equalsIgnoreCase(aTopic.userID))
	{
		isTopicAuthor = true;
		session.setAttribute("userTopicID", String.valueOf(topicID));
	}

	for (int i=0; i<aTopic.postList.size(); i++)
	{
		aPost = (PostVO)aTopic.postList.get(i);
		if (aPost.isHidePost == 'T')
		{
			userID = "";
			nickname = "匿名";
		}
		else
		{
			userID = aPost.u_userID;
			nickname = (aPost.u_nickname==null || aPost.u_nickname.length()==0) ? userID : aPost.u_nickname;
		}

		aGroup = PageUtils.getGroupVO(userID, aPost.u_groupID, aPost.u_credits, moderators);
		avatar = aPost.u_avatar;
		if (avatar == null || avatar.length() == 0)
			avatar = "sample/unknown.gif";
		else if (aGroup.rights.indexOf(IConstants.PERMIT_UPLOAD_AVATAR) < 0 && !avatar.startsWith("sample/"))
			avatar = "sample/unknown.gif";

		int count1 = -1;
		int count2 = aGroup.stars;
		if (aGroup.stars > 5)
		{
			count1 = aGroup.stars / 5;
			count2 = aGroup.stars % 5;
		}
		seqno = startSeq + i;
%>
<DIV class="mainbox viewtopic">
<%
		if (i == 0) {
%>
<SPAN class=headactions>
<A class=notabs href="./member/my_addfavor.jsp?tid=<%= topicID %>&fid=<%= boardID %>">收藏</A> </SPAN>
<H1><%= aTopic.title %>&nbsp;<% if (aTopic.isDigest=='T') out.write("&nbsp;~ 精华"); %></H1>
<%
		}
%>
<TABLE id="rid<%= aPost.replyID %>" cellSpacing=0 cellPadding=0>
  <TBODY>
  <TR>
    <TD class=postauthor rowspan="3">
  	  <CITE><A href="<%= spaceURL %><%= userID %>" target=_blank><%= nickname.length()==0?"游客":nickname %></A></CITE> 
<%
	if (showAvatar.equals("yes")) {
		int maxAvatarSize = setting.getInt(ForumSetting.MISC, "maxAvatarPixels");
%>
      <DIV class=avatar>
	  <A href="<%= spaceURL %><%= userID %>" target=_blank 
		title="<%= nickname.length()==0?"游客":nickname%>"><IMG src="<%= avatarPath %><%= avatar %>" 
                border=0 onload="resizeImage(this, <%= maxAvatarSize %>);"></A></DIV>
<%
	}
%>	  
      <P><EM><%= aGroup.groupName %></EM>&nbsp;
		<%	for (int j=0; j<count1; j++) { %><IMG alt="Rank: <%= aGroup.stars %>" 
		src="images/star_5.gif" align="absmiddle" border="0"><% } for (int j=0; j<count2; j++) { %><IMG 
		alt="Rank: <%= aGroup.stars %>" src="images/star_1.gif" align="absmiddle" border="0"><% } %>
	  </P>
	  <DL class="profile">
	  	<DT>帖子&nbsp;</DT><DD><%= aPost.u_posts %>&nbsp;</DD>
	  	<DT>积分&nbsp;</DT><DD><%= aPost.u_credits %>&nbsp;</DD>
	  </DL>				      
	  <UL>
	  	<LI class=friend><A href="./member/my_addfriend.jsp?uid=<%= userID %>" target=_blank>加为好友</A></LI>
        <LI class=sms><A href="./member/sms_compose.jsp?uid=<%= userID %>" target=_blank>发短消息</A></LI>
	  </UL></TD>
    <TD class=postdetail>
      <DIV class=postinfo><STRONG title="ID:<%= aPost.replyID %>"><%= seqno %><SUP>#</SUP></STRONG> 
	  发表于 <%= aPost.createTime %>&nbsp;
<% 		
		if(isModerator && aPost.remoteIP != null){ 
			out.write("IP: "); out.write(aPost.remoteIP); out.write("&nbsp;"); 
		}
		if (seqno == 0 && aTopic.updateUser != null && aTopic.updateUser.length() > 0) {
			out.write(" &nbsp;更新于 "); out.write(aTopic.updateTime); 
			out.write(" &nbsp;by&nbsp; "); out.write(aTopic.updateUser); out.write("&nbsp; ");
		}
		if (replyID != null && replyID.length() > 0 && replyID.equals(aPost.replyID)) { 
			out.write("<font color='red'>(&nbsp;回帖ID: " + replyID  + "&nbsp;)</font>");
		}
		if (aPost.state == 'R') { 
			out.write("<font color='red'>&nbsp;(&nbsp;已删除&nbsp;)</font>");
		}
%>		
	  </DIV>
      <DIV class="postcontent">
<%		
		if (seqno == 0 && aTopic.reward > 0) 
		{
			out.write("<p style='PADDING-BOTTOM: 15px; float: right'><span class='notice'><img src='styles/");
			out.write(forumStyle); out.write("/images/reward.gif' border='0' align='absmiddle'/> &nbsp;积分&nbsp;");
			out.write(aTopic.reward + "</span></p>\n");
		}			  
		if (aPost.isBest == 'T') 
			out.write("<p style='PADDING-BOTTOM: 15px; float: right'><span class='notice'>"
					  + "<img src='images/answer.gif' border='0' align='absmiddle'/> &nbsp;最佳回复</span></p>\n");
		if (aPost.title != null && aPost.title.length() > 0) {
%>	  
      <H2><%= aPost.title %></H2>
<%
		}
		StringBuilder attaches = null;
		if (aPost.attaches > 0 && aTopic.attachList != null) 
		{
			AttachVO aAttach = null;
			String attachTitle = null;
			int attachCount = 0;
			String attachURL = response.encodeURL("attach?aid=");
			
			for (int j=0; j<aTopic.attachList.size(); j++)
			{
				aAttach = (AttachVO)aTopic.attachList.get(j);
				if (!aAttach.replyID.equals(aPost.replyID)) continue;
				attachCount++;
				if (attachCount == 1) 
				{
					attaches = new StringBuilder("<DIV class='box attachlist'><BR/>\n");
					attaches.append("<P class='attach'>附件</P>\n");
					if (!PageUtils.isPermitted(aBoard,userGroup,IConstants.PERMIT_DOWNLOAD))
					{
						attaches.append("<EM style='padding-left:6px'>您所在的用户组无法下载或查看附件</EM>\n");
						break;
					}
				}
				if (aAttach.title == null || aAttach.title.length() == 0)
					attachTitle = "";
				else
					attachTitle = "<p>" + aAttach.title + "</p>";

				attaches.append("<dl class='p_attachlist'><dt>\n")
						.append("<img src='styles/").append(forumStyle)
						.append("/images/i_attach.gif' border='0' class='absmiddle'/>&nbsp;&nbsp;\n")
						.append("<a href='").append(attachURL).append(aAttach.attachID).append("' class='bold'>")
						.append(aAttach.filename).append("</a>&nbsp;&nbsp;<em class='num'>(")
						.append(aAttach.filesize*1.0/1000).append(" KB)</em></dt>\n");
				attaches.append("<dd><p>").append(aAttach.createTime).append(", 下载次数: <em class='num'>")
						.append(aAttach.downloads).append("</em>, 下载所需积分: <em class='num'>")
						.append(aAttach.credits).append("</em></p>").append(attachTitle).append("</dd></dl>\n");
			} // end for
			if (attaches != null && attachCount > 0) 
			{
				attaches.append("</DIV>");
			}
		}
%>		
      <DIV id="content_<%= seqno %>" class=contentmsg><%= aPost.content %></DIV>
<% 	    if (attaches != null) { %>
	  <%= attaches.toString() %>
<% 		} 	   %>
  </DIV></TD></TR>
  <TR>
    <TD class=postsign>
<%
		if (showBrief.equals("yes") && aPost.u_brief != null && aPost.u_brief.trim().length() > 0) {
	  		out.write("<DIV class='signature'>"); out.write(aPost.u_brief); out.write("</DIV>");
		}
%>
	</TD>
  </TR>
  <TR>
    <TD class=postfooter>
      <DIV class=postactions><P>
<%  
	    if (userinfo != null && userinfo.userID.equalsIgnoreCase(aPost.u_userID)
			&& !AppUtils.isBeforeDate(aPost.createTime,cal.getTime()))
			isAuthor = true;
		else
			isAuthor = false;

		if (isAuthor)
		{
			if (userPostIDs == null)
				userPostIDs = new StringBuilder();
			if (seqno == 0)
				userPostIDs.append('t').append(topicID).append(',');
			else
				userPostIDs.append('r').append(aPost.replyID).append(',');
		}
		
		if (seqno == 0 && (isAuthor || userGroup.rights.indexOf(IConstants.PERMIT_MOVE_POST) >= 0)) {
		  isManager = true;
%>
	     	<a href="javascript:doManage('move', '0');">移动主题</a>&nbsp;&nbsp;
<%	  	}
		if (isAuthor || userGroup.rights.indexOf(IConstants.PERMIT_EDIT_POST) >= 0) {  
		  isManager = true;	
%>
	     <a href="javascript:doEdit('<%= aPost.replyID %>');">修改</a>&nbsp;&nbsp;
<%
		}
		if (userGroup.rights.indexOf(IConstants.PERMIT_DELETE_POST) >= 0 && aPost.state != 'R') {  
		  isManager = true;	
%>
 	     <a href="javascript:doManage('delete', '<%= aPost.replyID %>');">删除</a>&nbsp;&nbsp;
<% 		}
		if (aTopic.state != 'C') {
%>
	     <a href="javascript:doReply('<%= seqno %>','<%= nickname %>');">回复</a>&nbsp;&nbsp;
<%		} 		%>
	  	 <a href="javascript:doQuote('<%= seqno %>','<%= nickname %>','<%= aPost.createTime %>');">引用</a>&nbsp;&nbsp;
		 <a href="javascript:doReport('<%= aPost.replyID %>');">举报</a>&nbsp;&nbsp;
<% 		if (seqno > 0 && isTopicAuthor) {
	  		isManager = true; 
%>
	     <a href="javascript:doManage('setbest', '<%= aPost.replyID %>');">最佳回复</a>&nbsp;&nbsp;
<% 		}      %>		 
	     <SPAN title="顶部" class="scrolltop" onclick="scroll(0,0)">TOP</SPAN> </P></DIV></TD></TR></TBODY></TABLE></DIV>
<%
	}
	if (userPostIDs != null)
		session.setAttribute("userPostIDs", userPostIDs.toString());
%>
<DIV class=pages_btns>
<div class="pages"><a href="<%= forumUrl %>" class="next"> &lsaquo;&lsaquo; 返回主题列表</a></div>
<%
	if (aTopic.pageHTML != null)
	{
%>	  
	<%= aTopic.pageHTML %>
<%
	}
%>
<SPAN class=postbtn id="newtopictmp" onmouseover="$('newtopic').id = 'newtopictmp';this.id = 'newtopic';showMenu(this.id);">
<A href="<%= postUrl %>"><IMG src="styles/<%= forumStyle %>/images/newtopic.gif" border=0></A></SPAN>
<SPAN class=replybtn><A href="javascript:replyTopic();">
<IMG alt="发表回复" src="styles/<%= forumStyle %>/images/reply.gif" border=0></A></SPAN></DIV>
<SCRIPT type=text/javascript>
var replyUrl = "<%= postUrl %>" + "&tid=<%= topicID %>";
var reportUrl = "<%= reportUrl %>";
var isClosed = <%= aTopic.state=='C'?"true":(aTopic.replies>=maxReplies?"true":"false") %>;
var isDigest = <%= aTopic.isDigest=='T'?"true":"false" %>;
<% 
	if (isManager) {
		sbuf.setLength(0);
		sbuf.append("manage.jsp?sid=").append(sectionID).append("&fid=").append(boardID)
	    	.append("&chkTopicID=").append(topicID).append("&page=").append(pageNo);
%>
var manageUrl = "<%= response.encodeURL(sbuf.toString()) %>";
function doEdit(replyId) 
{
<%	if (!isModerator) {   %>
	if (isDigest && replyId == '0')
	{
		alert('此主题已被加为精华，不能再修改  ');
		return;
	}	
	if (isClosed)
	{
		alert('此主题已经关闭，不能再修改  ');
		return;
	}	
<%	}  %>
	$('frmpost').action = replyUrl + "&rid=" + replyId + "&act=edit&page=<%= pageNo %>";
	$('frmpost').subject.value = "";
	$('frmpost').content.value = "";
	$('frmpost').submit();
}
function doManage(action, replyId)
{
<%	if (!isModerator) {   %>
	if (action == 'move')
	{
		if (isDigest)
		{
			alert('此主题已被加为精华，不能再移动  ');
			return;
		}
		if (isClosed)
		{
			alert('此主题已经关闭，不能再移动  ');
			return;
		}	
	}
	if (action == 'setbest' && isClosed)
	{
		alert('此主题已经关闭，不能再设置最佳回复  ');
		return;
	}
	
<%	}  %>
	$('frmpost').action = manageUrl + "&rid=" + replyId + "&act=" + action;
	$('frmpost').subject.value = "";
	$('frmpost').content.value = "";
	$('frmpost').submit();
}
<% 
	} 
%>
</SCRIPT>
<DIV class=legend id=footfilter><DIV class=jump_sort><form id="frmsort" name="frmsort" action="<%= forumUrl %>" method="post">
<SELECT onchange="if(this.options[this.selectedIndex].value != ''){window.location = this.options[this.selectedIndex].value;}">
<OPTION value="" selected>版块跳转 ...</OPTION> 
<%
	if (sections != null)
	{
		SectionVO tmpSection = null;
		BoardVO tmpBoard = null;
		String tmpUrl = null;
		StringBuilder sb = new StringBuilder();
		
		for (int i=0; i<sections.size(); i++)	
		{
			tmpSection = (SectionVO)sections.get(i);
			if (tmpSection.boardList == null) continue;

			sb.append("<OPTGROUP label=\"").append(tmpSection.sectionName).append("\">\n");
			
			for (int j=0; j<tmpSection.boardList.size(); j++)
			{
				tmpBoard = (BoardVO)tmpSection.boardList.get(j);
				if (tmpBoard.state == 'I' && !isModerator) continue;
				sbuf.setLength(0);
				sbuf.append("./forum-").append(tmpSection.sectionID).append("-").append(tmpBoard.boardID).append("-1.html");
				tmpUrl = response.encodeURL(sbuf.toString());
				sb.append("<OPTION value=\"").append(tmpUrl).append("\">&nbsp; &gt; ")
				  .append(tmpBoard.boardName).append("</OPTION>\n");
			}
			sb.append("</OPTGROUP>");
		}
		out.write(sb.toString());
	}
%>
</SELECT></form>
<form id="frmpost" name="frmpost" action="<%= postUrl %>" method="post">
<INPUT type=hidden value="<%= aTopic.title.replace("\"", "&quot;") %>" name="topic">
<INPUT type=hidden value="" name="subject">
<INPUT type=hidden value="" name="content">
<INPUT type=hidden value="<%= aTopic.isReplyNotice %>" name="notice">
</form>
</DIV></DIV></DIV>
<%= menus[1]==null?"":menus[1] %>
<%= menus[2]==null?"":menus[2] %>
<%= PageUtils.getFootAdBanner(request, aBoard) %>
<%= PageUtils.getFooter(request, forumStyle) %>
</BODY></HTML>
