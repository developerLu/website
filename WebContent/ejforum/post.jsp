<%@ page contentType="text/html;charset=gbk" errorPage="error.jsp"%>
<%@ page import="java.net.URLEncoder"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="com.hongshee.ejforum.util.PageUtils"%>
<%@ page import="com.hongshee.ejforum.common.ForumSetting"%>
<%@ page import="com.hongshee.ejforum.common.IConstants"%>
<%@ page import="com.hongshee.ejforum.common.CacheManager"%>
<%@ page import="com.hongshee.ejforum.data.UserDAO.UserInfo"%>
<%@ page import="com.hongshee.ejforum.data.BoardDAO.BoardVO"%>
<%@ page import="com.hongshee.ejforum.data.SectionDAO.SectionVO"%>
<%@ page import="com.hongshee.ejforum.data.GroupDAO.GroupVO"%>
<%@ page import="com.hongshee.ejforum.data.TopicDAO"%>
<%@ page import="com.hongshee.ejforum.data.TopicDAO.TopicVO"%>
<%@ page import="com.hongshee.ejforum.data.ReplyDAO.PostVO"%>
<%@ page import="com.hongshee.ejforum.data.AttachDAO.AttachVO"%>
<%
	UserInfo userinfo = PageUtils.getSessionUser(request);
	if (!request.isRequestedSessionIdFromCookie())
	{
		request.setAttribute("errorMsg", "请打开您的浏览器的 Cookie 支持功能, 否则不能发帖");
		request.getRequestDispatcher("/error.jsp").forward(request, response);
		return;
	}
	if (userinfo == null && !PageUtils.isUserAgent(request))  // Guest & Robot
		return;

	CacheManager cache = CacheManager.getInstance();

	String sectionID = request.getParameter("sid");
	String boardID = request.getParameter("fid");
	
	SectionVO aSection = cache.getSection(sectionID);
	BoardVO aBoard = cache.getBoard(aSection, boardID);
	
    GroupVO aGroup = PageUtils.getGroupVO(userinfo, aSection, aBoard);
	boolean isModerator = false;
	if (aGroup.groupID == 'A' || aGroup.groupID == 'M' || aGroup.groupID == 'S')
		isModerator = true;
	
	String action = request.getParameter("act");
	if (action != null)
	 	action = action.trim();
	if (action == null || action.length() == 0)
		action = "topic";

	if (userinfo == null)  // Guest
	{
		if (aBoard.isGuestPostOK == 'F' 
			|| (action.equals("reply") && !PageUtils.isPermitted(aBoard,aGroup,IConstants.PERMIT_NEW_REPLY))
			|| (action.equals("topic") && !PageUtils.isPermitted(aBoard,aGroup,IConstants.PERMIT_NEW_TOPIC))
			|| (action.equals("reward") && aGroup.rights.indexOf(IConstants.PERMIT_NEW_REWARD) < 0)
			|| (action.equals("reward") && !PageUtils.isPermitted(aBoard,aGroup,IConstants.PERMIT_NEW_TOPIC))
			|| (action.equals("edit")))
		{
			String fromPath = request.getRequestURI();
			String queryStr = request.getQueryString();
			if (queryStr != null)
			{
				String topicTitle = PageUtils.getParam(request, "topic");
				if (topicTitle.length() > 0)
					queryStr = queryStr + "&topic=" + URLEncoder.encode(topicTitle, "GBK");
				fromPath = fromPath + "?" + queryStr;
			}
			request.setAttribute("fromPath", fromPath);
			request.getRequestDispatcher("/login.jsp").forward(request, response);
			return;
		}
	}
	else if (userinfo.state == 'P')
	{
		request.setAttribute("errorMsg", "您已被禁止发帖或编辑帖子");
		request.getRequestDispatcher("/error.jsp").forward(request, response);
		return;
	}

	ForumSetting setting = ForumSetting.getInstance();
	
    Object sessionPosts = (Object)session.getAttribute("posts");
    if (sessionPosts != null && aGroup.groupID != 'A')
	{
		int maxSessionPosts = setting.getInt(ForumSetting.MISC, "maxSessionPosts");
		if (Integer.parseInt(sessionPosts.toString()) >= maxSessionPosts)
		{
			request.setAttribute("errorMsg", "您连续发帖数已经达到上限，不能继续发帖");
			request.getRequestDispatcher("/error.jsp").forward(request, response);
			return;
		}
	}

	String topicID = request.getParameter("tid");
	String replyID = request.getParameter("rid");
	
	TopicVO aTopic = null;
	PostVO aPost = null;
	String strPageNo = null;

	String actTitle = null;
	String actName = null;
	String notice = null;
	if (action.equals("reply"))
	{
		if (!PageUtils.isPermitted(aBoard,aGroup,IConstants.PERMIT_NEW_REPLY))
		{
			request.setAttribute("errorMsg", "您没有发表回复的权限");
			request.getRequestDispatcher("/error.jsp").forward(request, response);
			return;
		}
		notice = request.getParameter("notice");
		actTitle = "发表回复";
		actName = "post_reply";
	}
	else if (action.equals("reward"))
	{
		if (aGroup.rights.indexOf(IConstants.PERMIT_NEW_REWARD) < 0
			|| !PageUtils.isPermitted(aBoard,aGroup,IConstants.PERMIT_NEW_TOPIC))
		{
			request.setAttribute("errorMsg", "您没有发布悬赏的权限");
			request.getRequestDispatcher("/error.jsp").forward(request, response);
			return;
		}
		actTitle = "发布悬赏";
		actName = "post_reward";
	}
	else if (action.equals("edit"))
	{
		aTopic = TopicDAO.getInstance().getPostInfo(request, topicID, replyID);
        if (aTopic != null && aTopic.postList != null && aTopic.postList.size() > 0)
		{
			if (!isModerator)
			{
				if (aTopic.isDigest == 'T')
				{
					request.setAttribute("errorMsg", "此主题已被加为精华，不能再修改");
					request.getRequestDispatcher("/error.jsp").forward(request, response);
					return;
				}
				if (aTopic.state == 'C')
				{
					request.setAttribute("errorMsg", "此主题已经关闭，不能再修改");
					request.getRequestDispatcher("/error.jsp").forward(request, response);
					return;
				}
			}
			aPost = (PostVO)aTopic.postList.get(0);
			strPageNo = request.getParameter("page");
		}
		actTitle = "修改帖子";
		if (replyID != null && !replyID.equals("0")) // reply
			actName = "post_reply";
		else	
			actName = "post_topic";
	}
	else
	{
		if (!PageUtils.isPermitted(aBoard,aGroup,IConstants.PERMIT_NEW_TOPIC))
		{
			request.setAttribute("errorMsg", "您没有发新话题的权限");
			request.getRequestDispatcher("/error.jsp").forward(request, response);
			return;
		}
		actTitle = "发新话题";
		actName = "post_topic";
	}

	String forumName = setting.getForumName();
	String title = PageUtils.getTitle(forumName);
		
	String pageTitle = aBoard.boardName;
	String topicTitle = null;
	String subject = null;
	String content = null;
	if (topicID != null && topicID.length() > 0)
	{
		topicTitle = PageUtils.getParam(request, "topic");
		pageTitle = topicTitle + " - " + pageTitle;
		if (aPost == null)
		{
			subject = PageUtils.getParam(request, "subject");
			content = PageUtils.getParam(request, "content");
		}
		else
		{
			subject = aPost.title;
			content = aPost.content;
			
		}
	}

	String[] menus = PageUtils.getHeaderMenu(request, userinfo);
	int maxAttachSize = setting.getInt(ForumSetting.FUNCTIONS, "maxAttachSize");
	int maxAttachNum = setting.getInt(ForumSetting.FUNCTIONS, "maxAttachNum");
	int maxPostLength = setting.getInt(ForumSetting.FUNCTIONS, "maxPostLength");
	String allowAttachTypes = setting.getString(ForumSetting.FUNCTIONS, "allowAttachTypes");
	int maxTitleLength = 100;

	boolean allowHTML = aGroup.rights.indexOf(IConstants.PERMIT_USE_HTML) >= 0;
	boolean allowUpload = PageUtils.isPermitted(aBoard,aGroup,IConstants.PERMIT_UPLOAD);
	
	StringBuilder sbuf = new StringBuilder();
	sbuf.append("./forum-").append(aSection.sectionID).append("-").append(aBoard.boardID).append("-1.html");
	String forumUrl = sbuf.toString();
	String homeUrl = "./index.jsp";
	String forumStyle = PageUtils.getForumStyle(request, response, aBoard);

	sbuf.setLength(0);
	sbuf.append("perform.jsp?act=post_").append(action).append("&sid=").append(sectionID)
		.append("&fid=").append(boardID);
	if (topicID != null)
		sbuf.append("&tid=").append(topicID);
	if (replyID != null)
		sbuf.append("&rid=").append(replyID);
	if (strPageNo != null)
		sbuf.append("&page=").append(strPageNo);
	if (topicTitle != null && topicTitle.length() > 0)
		sbuf.append("&topic=").append(URLEncoder.encode(topicTitle, "GBK"));
		
	String performUrl = sbuf.toString();

	String topicUrl = null;
	if (topicID != null && topicTitle != null)
	{
		sbuf.setLength(0);
		sbuf.append("<A href=\"./topic-").append(topicID).append("-1.html\">").append(topicTitle).append("</A> &raquo;&nbsp; ");
		topicUrl = sbuf.toString();
	}
	else
	{
		topicUrl = "";
	}
	if (topicTitle == null)
		topicTitle = "";
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<HTML xmlns="http://www.w3.org/1999/xhtml">
<HEAD>
<TITLE><%= pageTitle %> - <%= title %></TITLE>
<LINK href="styles/<%= forumStyle %>/ejforum.css" type=text/css rel=stylesheet>
<LINK href="styles/<%= forumStyle %>/ejf_editor.css" type=text/css rel=stylesheet>
</HEAD>
<BODY onkeydown="if(event.keyCode==27) return false;" onload="loaded()">
<SCRIPT src="js/common.js" type=text/javascript></SCRIPT>
<SCRIPT src="js/member.js" type=text/javascript></SCRIPT>
<DIV class=wrap>
<DIV id=header>
<%= PageUtils.getHeader(request, title) %>
<%= PageUtils.getHeadAdBanner(request, null) %>
</DIV>
<%= menus[0] %>
<DIV id=nav><A href="<%= homeUrl %>"><%= forumName %></A> &raquo;&nbsp; <A 
href="<%= forumUrl %>"><%= aBoard.boardName %></A> &raquo;&nbsp; <%= topicUrl %><%= actTitle %></DIV>
<SCRIPT type=text/javascript>
var maxTitleLength = parseInt('<%= maxTitleLength %>');
var maxPostLength = parseInt('<%= maxPostLength %>')*1000;
msgs['bytes'] = '字节';
msgs['post_curlength'] = '当前长度';
msgs['post_subject_empty'] = '请填写标题栏';
msgs['post_content_empty'] = '请填写内容栏';
msgs['post_subject_toolong'] = '您的标题超过 ' + maxTitleLength + ' 个字符的限制';
msgs['post_content_toolong'] = '您的帖子长度超过 ' + maxPostLength + ' 字节的限制';
msgs['post_reward_zero'] = '悬赏积分值必须大于0';
msgs['post_vcode_empty'] = '请输入验证码';
var verifycode_invalid = '验证码输入错误，请重新填写';
var performUrl = "<%= performUrl %>";
</SCRIPT>
<FORM id=postform name=postform action="perform.jsp" method=post encType="multipart/form-data">
<INPUT type=hidden value="<%= topicTitle.replace("\"", "&quot;") %>" name="topic">
<DIV class="mainbox formbox"><SPAN class=headactions>
<A class=notabs href="./help/credits_rule.jsp" target=_blank>查看积分策略说明</A></SPAN> 
<H1><%= actTitle %></H1>
<TABLE id=post_tb cellSpacing=0 cellPadding=0>
  <TBODY>
  <TR>
    <TH style="width:168px">用户名</TH>
    <TD><%= userinfo == null ? "Guest （游客）" : userinfo.userID %>
	<% if (aPost != null) { %><INPUT name=postuser type=hidden value="<%= aPost.u_userID %>"/>
	<% }else if (notice != null){ %><INPUT name=notice type=hidden value="<%= notice %>"/>
	<% } %></TD></TR></TBODY>
  <TBODY>
<%
	if (action.equals("reward") || (aTopic != null && aTopic.reward > 0)) {
%>  
  <TR>
    <TH style="BORDER-BOTTOM-WIDTH: 0px"><LABEL for=reward>悬赏积分</LABEL></TH>
    <TD style="BORDER-BOTTOM-WIDTH: 0px"> 
		<INPUT id=reward tabIndex=1 size=15 name=reward id="reward" value="0" onblur="checkInt(this);"> 
	</TD></TR>
<%
	}
%>  
  <TR>
    <TH style="BORDER-BOTTOM-WIDTH: 0px"><LABEL for=subject>标题</LABEL></TH>
    <TD style="BORDER-BOTTOM-WIDTH: 0px"> 
		<INPUT id=subject tabIndex=2 size=50 name=subject value="<%= subject==null?"":subject.replace("\"","&quot;") %>">
		<% if (action.equals("reply")) { %> <em class="tips">&nbsp;(可选)</em> <% } %>
	</TD></TR>
  <TBODY>
  <TR>
    <TH valign=top><LABEL for=htmleditor_content>内容</LABEL>
      <UL>
        <LI> HTML 代码 &nbsp;<EM><%= allowHTML?"可用":"禁用" %></EM> 
        <LI> 插入媒体 &nbsp;<EM><%= aBoard.isMediaOK=='T'?"可用":"禁用" %> [media]</EM></LI>
        <LI> 插入图片 &nbsp;<EM><%= aBoard.isImageOK=='T'?"可用":"禁用" %> [img]</EM></LI>
	  </UL>
      <DIV id=smilieslist>
	  <h4><span>表情符号</span></h4>
	  <jsp:include page="include/smiles.html"/>
	  </DIV>
      <UL>
        <LI><LABEL>
			<INPUT type=checkbox value="yes" name="bbcodeoff">&nbsp; 禁用BBCode代码</LABEL></LI> 
<% if (aGroup.rights.indexOf(IConstants.PERMIT_HIDE_POST) >= 0) { %>
        <LI><LABEL>
			<INPUT type=checkbox value="T" name="isHidePost" id="isHidePost">&nbsp; 使用匿名发帖</LABEL></LI> 
<% } 
   if (!actName.equals("post_reply")) { %>
        <LI><LABEL>
			<INPUT type=checkbox value="T" name="isReplyNotice" id="isReplyNotice">&nbsp; 接收新回复邮件通知</LABEL></LI> 
<% 	  if (aGroup.rights.indexOf(IConstants.PERMIT_TOP_POST) >= 0) { %>
        <LI><LABEL>
			<INPUT type=checkbox value="T" name="isTopPost" id="isTopPost">&nbsp; 主题置顶</LABEL></LI> 
<% 	  }  } 	  %>
	  </UL></TH>
    <TD valign=top style="padding-top:5px;padding-right:4px;padding-bottom:2px">
      <DIV id="htmleditor">
      <TABLE id=editor_tb cellSpacing=0 cellPadding=0 style="table-layout:fixed">
        <TBODY>
        <TR>
          <TD class=editortoolbar id=htmleditor_controls>
            <TABLE cellSpacing=0 cellPadding=0>
              <TBODY>
              <TR>
                <TD><A id=htmleditor_cmd_bold><IMG title=粗体 alt=B src="images/editor/bb_bold.gif"></A></TD>
                <TD><A id=htmleditor_cmd_italic><IMG title=斜体 alt=I src="images/editor/bb_italic.gif"></A></TD>
                <TD><A id=htmleditor_cmd_underline><IMG title=下划线 alt=U src="images/editor/bb_underline.gif"></A></TD>
                <TD><IMG alt=| src="images/editor/bb_separator.gif"></TD>
                <TD><A id=htmleditor_popup_fontname title=字体><SPAN 
                  class="dropmenu dropbutton" id=htmleditor_font_out style="DISPLAY: block; WIDTH: 110px">字体</SPAN> 
                  </A></TD>
                <TD><A id=htmleditor_popup_fontsize title=大小><SPAN 
                  class="dropmenu dropbutton" id=htmleditor_size_out style="DISPLAY: block; WIDTH: 30px">大小</SPAN> </A></TD>
                <TD><A id=htmleditor_popup_forecolor title=颜色><SPAN 
                  class=dropmenu style="DISPLAY: block; WIDTH: 30px"><IMG 
                  height=16 src="images/editor/bb_color.gif" width=21><BR><IMG id=htmleditor_color_bar 
                  style="BACKGROUND-COLOR: black" height=4 src="images/editor/bb_clear.gif" width=21></SPAN> </A></TD>
                <TD><IMG alt=| src="images/editor/bb_separator.gif"></TD>
                <TD><A id=htmleditor_cmd_justifyleft><IMG title=居左 alt="Align Left" src="images/editor/bb_left.gif"></A></TD>
                <TD><A id=htmleditor_cmd_justifycenter><IMG title=居中 alt="Align Center" 
						src="images/editor/bb_center.gif"></A></TD>
                <TD><A id=htmleditor_cmd_justifyright><IMG title=居右 alt="Align Right" src="images/editor/bb_right.gif"></A></TD>
                <TD><IMG alt=| src="images/editor/bb_separator.gif"></TD>
                <TD><A id=htmleditor_cmd_url><IMG title=插入链接 alt=Url src="images/editor/bb_url.gif"></A></TD>
<% if (aBoard.isImageOK=='T') { %>
                <TD><A id=htmleditor_cmd_img><IMG title=插入图片 alt=Image src="images/editor/bb_image.gif"></A></TD>
<% } 
   if (aBoard.isMediaOK=='T') { %>
                <TD><A id=htmleditor_cmd_media><IMG title=插入媒体 alt=Media src="images/editor/bb_media.gif"></A></TD>
<% } %>
                <TD><IMG alt=| src="images/editor/bb_separator.gif"></TD>
                <TD><A id=htmleditor_cmd_quote><IMG title=插入引用 alt=Quote src="images/editor/bb_quote.gif"></A></TD>
                <TD><A id=htmleditor_cmd_code><IMG title=插入代码 alt=Quote src="images/editor/bb_code.gif"></A></TD>
                </TR></TBODY></TABLE>
            <DIV class=editor_switcher_bar id=htmleditor_switcher>
			<BUTTON id=htmlmode type="button" class="editor_switcher" style="width:130px">HTML&nbsp;代码模式</BUTTON>
			<BUTTON id=wysiwygmode type="button" style="width:130px">可视化编辑模式</BUTTON></DIV></TD></TR>
        <TR>
          <TD class=editortoolbar>
			<jsp:include page="include/fonts.html"/>
			<jsp:include page="include/colors.html"/>
		 </TD></TR></TBODY></TABLE>
      <TABLE class=editor_text_tb id=editor_panel cellSpacing=0 cellPadding=0 style="table-layout:fixed">
        <TBODY>
        <TR>
          <TD style="padding-right:5px"><TEXTAREA class=forumeditor id=htmleditor_content tabIndex=5 
		  				style="WIDTH: 100%; HEIGHT: 250px;" name="content" rows=10 cols=60>
			  <%= content==null?"":content.replace("&","&amp;") %>
			 </TEXTAREA> 
          </TD></TR></TBODY></TABLE>
      <TABLE class=editor_button_tb cellSpacing=0 cellPadding=0 style="table-layout:fixed">
        <TBODY>
        <TR>
          <TD style="BORDER-TOP-STYLE: none">
            <DIV>
			<IMG id=htmleditor_contract title=收缩编辑框 alt=收缩编辑框 
				src="images/editor/bb_contract.gif"><IMG id=htmleditor_expand title=扩展编辑框 alt=扩展编辑框 
				src="images/editor/bb_expand.gif"> 
			</DIV></TD>
          <TD style="BORDER-TOP-STYLE: none" align=right> <BUTTON id=clearctx type="button">清空内容</BUTTON> </TD>
		  </TR></TBODY></TABLE>
<%
	if (allowUpload) {
%>		  
      <TABLE class=box cellSpacing=0 cellPadding=0 style="table-layout:fixed">
        <THEAD>
        <TR>
          <TH style="width:310px;">上传附件或图片 ( 文件总尺寸应小于 <STRONG><%= maxAttachSize %> KB</STRONG> )</TH>
		  <TD style="width:90px;">下载所需积分</TD>
          <TD>&nbsp;描述</TD>
	  	</TR></THEAD>
        <TBODY id="attachitem" style="DISPLAY: none"><TR><TH style="width:310px;"><INPUT 
			type=file name="attachfile" size="40"><SPAN id=localfile></SPAN>
			<% if (aTopic != null) { %><INPUT type=hidden name="attachid"><INPUT type=hidden name="serverfile"><% } %></TH>
			<TD class="nums"><INPUT size=10 name="attachcredits" value="0" onblur="checkInt(this);"></TD>
			<TD>&nbsp;<INPUT size=30 name="attachtitle" maxlength="50"></TD></TR></TBODY>
        <TBODY id="attachbody"></TBODY>
        </TABLE>
<%
	}
%>		  
      </DIV></TD></TR>
  <TBODY>
  <TR>
    <TH><LABEL for=verifycode>验证码</LABEL></TH>
    <TD>
      <DIV id=verifycodeimage style="margin-bottom:3px"></DIV>
	  <INPUT id=verifycode tabIndex=8 maxLength=4 size=15>
	  <SPAN id=checkverifycode></SPAN></TD>
  </TR>
  <TR class=btns>
    <TH>&nbsp;</TH>
    <TD height="50">
	<table cellSpacing=0 cellPadding=0 border=0><tr>
	<td style="padding-left:0px;">
	<BUTTON id="postbtn" tabIndex=9 name="<%= actName %>" type=submit style="width:110px"><%= actTitle %></BUTTON>
		<SPAN id=postmsg style="color:#009900;vertical-align:bottom"></SPAN></td>
	<td align="right"><em>当您离开本页面时，表格的数据会被自动保存在缓存中</em>&nbsp;&nbsp;
	 	<a href="###" 
		   onclick="if (confirm('此操作将覆盖当前帖子内容，确定要恢复数据吗？')) loadData();">恢复上次自动保存的数据</a> </td>
	</tr></table>
    </TD></TR></TBODY></TABLE></DIV><BR></FORM>
<SCRIPT type=text/javascript>
function loaded() {
<% if (request.getParameter("reload") != null) { %>
	loadData();
<% } else { %>
	if (trim($('verifycode').value) != '')
		loadData();
<% } %>
}

var wysiwyg = 1;
var allowimg = <%= aBoard.isImageOK=='T'?1:0 %>;
var allowmedia = <%= aBoard.isMediaOK=='T'?1:0 %>;
var allowhtml = <%= allowHTML?1:0 %>;
var maxAttachNum = parseInt('<%= maxAttachNum %>');
var extensions = '<%= allowAttachTypes %>';
var encoding = 'GBK';
var forumcss = 'styles/<%= forumStyle %>/ejforum.css';
var editorcss = 'styles/<%= forumStyle %>/ejf_editor.css';
var textobj = $('htmleditor_content');

msgs['attach_ext_invalid']	= '对不起，不支持上传此类扩展名的附件。';
msgs['attach_deletelink']	= '删除';
msgs['attach_insert']	= '插入帖内';
msgs['too_many_attach']	= '您最多只能上传 <%= maxAttachNum %> 个附件。';
msgs['enter_quote_title'] 	= '请输入要插入的引用文字:';
msgs['enter_code_title'] 	= '请输入要插入的代码:';
msgs['enter_url_link']		= "请输入链接的地址:";
msgs['enter_url_title']		= "请输入链接的文字(可选):";
msgs['enter_img_link']		= "请输入图片链接地址(本地图片请上传):";
msgs['enter_img_title']		= "请输入图片描述文字(可选):";
msgs['enter_media_link']	= "请输入多媒体源文件地址(swf,mp3,wma,wmv 等):";
msgs['enter_media_title']	= "请输入多媒体显示尺寸(可选,宽,高, 比如: 80,40):";
msgs['quote']				= "引用";
msgs['submit']				= "提交";
msgs['cancel']				= "取消";
msgs['posting']				= "正在提交数据，请稍候...";
</SCRIPT>
<SCRIPT src="js/post.js" type=text/javascript></SCRIPT>
<SCRIPT src="js/editor.js" type=text/javascript></SCRIPT>
<SCRIPT type=text/javascript>
createEditor(wysiwyg);
$('htmleditor_contract').onclick = function() {resizeEditor(-100)};
$('htmleditor_expand').onclick = function() {resizeEditor(100)};
$('clearctx').onclick = function() {clearContent()};
$('postform').onsubmit = function() {checkPost(this); return false;};
window.onbeforeunload = function () { try{saveData();}catch(e){} };
<%
	if (aPost != null && aPost.isHidePost == 'T')
		out.write("$('isHidePost').checked = true;\n");
	if (aTopic != null)
	{	
		if (aTopic.isReplyNotice == 'T')
			out.write("$('isReplyNotice').checked = true;\n");
//		if (aTopic.topScope == 'B')
//			out.write("$('isTopPost').checked = true;\n");
		if (aTopic.reward > 0)
			out.write("$('reward').value = '" + aTopic.reward + "';\n");
	}
	if (allowUpload)
	{
		if (aTopic != null && aPost != null && aTopic.attachList != null)
		{
			AttachVO aAttach = null;
			String attachTitle = null;
			
			for (int j=0; j<aTopic.attachList.size(); j++)
			{
				aAttach = (AttachVO)aTopic.attachList.get(j);
				if (!aAttach.replyID.equals(aPost.replyID)) continue;
				if (aAttach.title == null) aAttach.title = "";
				sbuf.setLength(0);
				sbuf.append("showAttach(").append(aAttach.localID).append(",'").append(aAttach.attachID)
				    .append("',\"").append(aAttach.localname).append("\",\"")
					.append(aAttach.filename.replace("\"","&quot;")).append("\",\"")
					.append(aAttach.credits).append("\",\"").append(aAttach.title.replace("\"","&quot;")).append("\");\n");
				out.write(sbuf.toString());
			}
			session.setAttribute("attachCount", String.valueOf(aTopic.attachList.size()));
		}
		out.write("addAttach();\n");
	}
%>		  
refreshVerifyCode(112,42);
$('subject').focus();
</SCRIPT>
</DIV>
<%= menus[1]==null?"":menus[1] %>
<%= menus[2]==null?"":menus[2] %>
<%= PageUtils.getFooter(request, forumStyle) %>
</BODY></HTML>
