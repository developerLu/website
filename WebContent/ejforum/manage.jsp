<%@ page contentType="text/html;charset=gbk"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="java.util.HashMap"%>
<%@ page import="com.hongshee.ejforum.util.PageUtils"%>
<%@ page import="com.hongshee.ejforum.util.AppUtils"%>
<%@ page import="com.hongshee.ejforum.common.ForumSetting"%>
<%@ page import="com.hongshee.ejforum.common.IConstants"%>
<%@ page import="com.hongshee.ejforum.common.CacheManager"%>
<%@ page import="com.hongshee.ejforum.data.UserDAO.UserInfo"%>
<%@ page import="com.hongshee.ejforum.data.BoardDAO.BoardVO"%>
<%@ page import="com.hongshee.ejforum.data.SectionDAO.SectionVO"%>
<%@ page import="com.hongshee.ejforum.data.GroupDAO.GroupVO"%>
<%@ page import="com.hongshee.ejforum.data.TopicDAO"%>
<%
	PageUtils.checkReferer(request); // Enhance security
	String ctxPath = request.getContextPath()+"/ejforum";
	
	UserInfo userinfo = PageUtils.getSessionUser(request);
    PageUtils.checkAdminIP(request);
    if (userinfo == null)
    {
		String fromPath = ctxPath + "/forum.jsp?" + request.getQueryString();
        request.setAttribute("fromPath", fromPath);
        request.getRequestDispatcher("/login.jsp").forward(request, response);
		return;
    }

	String sectionID = request.getParameter("sid");
	String boardID = request.getParameter("fid");

	String[] topicIDs = request.getParameterValues("chkTopicID");
    int totalCount = 0;
	if (topicIDs != null && topicIDs.length > 0)
	{
		totalCount = topicIDs.length;
	}
	else
	{
		request.setAttribute("errorMsg", "没有选中待操作的主题");
		request.getRequestDispatcher("/error.jsp").forward(request, response);
		return;
	}
	
	HashMap topicInfo = null;
	if (totalCount == 1)
	{
		topicInfo = TopicDAO.getInstance().getManageInfo(topicIDs[0]);
	}

	String replyID = request.getParameter("rid");

	CacheManager cache = CacheManager.getInstance();
	SectionVO aSection = cache.getSection(sectionID);
	BoardVO aBoard = cache.getBoard(aSection, boardID);

	GroupVO userGroup = PageUtils.getGroupVO(userinfo, aSection, aBoard);
	boolean isModerator = false;
	if (userGroup.groupID == 'A' || userGroup.groupID == 'M' || userGroup.groupID == 'S')
		isModerator = true;

	String action = request.getParameter("act");
	String actTitle = null;
	
	if (action.equals("highlight"))
		actTitle = "高亮显示";
	else if (action.equals("top"))
		actTitle = "置顶/解除置顶";
	else if (action.equals("digest"))
		actTitle = "加入/解除精华";
	else if (action.equals("close"))
		actTitle = "关闭/打开主题";
	else if (action.equals("delete"))
	{
		if (replyID != null && !replyID.equals("0"))
			actTitle = "删除回复";
		else	
			actTitle = "删除主题";
	}
	else if (action.equals("move"))
	{
		actTitle = "移动主题";
		if (!isModerator)
		{
			char isDigest = 'F';
			if (topicInfo != null)
				isDigest = ((String)topicInfo.get("ISDIGEST")).charAt(0);
			if (isDigest == 'T')
			{
				request.setAttribute("errorMsg", "此主题已被加为精华，不能再移动");
				request.getRequestDispatcher("/error.jsp").forward(request, response);
				return;
			}
			char state = 'N';
			if (topicInfo != null)
				state = ((String)topicInfo.get("STATE")).charAt(0);
			if (state == 'C')
			{
				request.setAttribute("errorMsg", "此主题已经关闭，不能再移动");
				request.getRequestDispatcher("/error.jsp").forward(request, response);
				return;
			}
		}
	}
	else if (action.equals("setbest"))
	{
		actTitle = "设定/取消最佳回复";
		if (!isModerator)
		{
			char state = 'N';
			if (topicInfo != null)
				state = ((String)topicInfo.get("STATE")).charAt(0);
			if (state == 'C')
			{
				request.setAttribute("errorMsg", "此主题已经关闭，不能再设置最佳回复");
				request.getRequestDispatcher("/error.jsp").forward(request, response);
				return;
			}
		}
	}
	
	String forumName = ForumSetting.getInstance().getForumName();
	String title = PageUtils.getTitle(forumName);
	String[] menus = PageUtils.getHeaderMenu(request, userinfo);
	
    ArrayList sections = cache.getSections();
	
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
	sbuf.append("perform.jsp?act=moderate_").append(action).append("&sid=").append(sectionID)
		.append("&fid=").append(boardID).append("&page=").append(String.valueOf(pageNo));
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
	if (replyID != null && replyID.length() > 0 && topicIDs[0] != null)
	{
		String topicTitle = PageUtils.getParam(request, "topic");
		sbuf.setLength(0);
		sbuf.append("<A href=\"./topic-").append(topicIDs[0]).append("-1.html\">").append(topicTitle).append("</A> &raquo;&nbsp; ");
		topicUrl = sbuf.toString();
	}
	else
	{
		topicUrl = "";
	}

	StringBuilder defaultValue = new StringBuilder();
	defaultValue.append("垃圾广告\n").append("恶意灌水\n").append("违规内容\n").append("文不对题\n").append("重复发帖\n\n")
				.append("我很赞同\n").append("精品文章\n").append("原创内容");

	String[] judgeOptions = setting.getHTMLStr(ForumSetting.FUNCTIONS,"judgeOptions",defaultValue.toString())
								   .replace("\\n", "\n").split("\n");
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<HTML xmlns="http://www.w3.org/1999/xhtml">
<HEAD>
<TITLE><%= actTitle %> - <%= aBoard.boardName %> - <%= title %></TITLE>
<LINK href="styles/<%= forumStyle %>/ejforum.css" type=text/css rel=stylesheet>
</HEAD>
<BODY onkeydown="if(event.keyCode==27) return false;">
<SCRIPT src="js/common.js" type=text/javascript></SCRIPT>
<SCRIPT type=text/javascript>
function validate(theform) {
	if (typeof(theform.expiredate) != 'undefined' && !isLegalDate(theform.expiredate.value))
	{
		alert('有效期格式不正确或日期值无效');
		theform.expiredate.focus();
		return false;
	}
	return true;
}
</SCRIPT>
<DIV class=wrap>
<DIV id=header>
<%= PageUtils.getHeader(request, title) %>
</DIV>
<%= menus[0] %>
<DIV id=nav><A href="<%= homeUrl %>"><%= forumName %></A><%= sectionLink==null?"":sectionLink %> &raquo;&nbsp; 
<A href="<%= forumUrl %>"><%= aBoard.boardName %></A> &raquo;&nbsp; <%= topicUrl %><%= actTitle %></DIV>
<form method="post" action="<%= performUrl %>" id="postform" name="postform" onSubmit="return validate(this)">
	<div class="mainbox formbox">
	<h1><%= actTitle %> -&nbsp; 选中的帖子数: <%= totalCount %></h1>
	<table summary="Operating" cellspacing="0" cellpadding="0">
	<thead>
		<tr>
			<th>用户名</th>
			<td><%= userinfo.userID %></td>
		</tr>
	</thead>
<%
	if (action.equals("digest")) {
		char isDigest = 'F';
		if (topicInfo != null)
			isDigest = ((String)topicInfo.get("ISDIGEST")).charAt(0);
%>				
		<tr>
			<th>操作</th>
			<td><label><input class="radio" type="radio" name="isDigest" value="T" 
						<%= isDigest=='F'?"checked":"" %>/> 加入精华</label> &nbsp;
				<label><input class="radio" type="radio" name="isDigest" value="F"
						<%= isDigest=='T'?"checked":"" %>/> 解除精华</label>
			</td>
		</tr>
<%
	} else if (action.equals("top")) {
		String moderators = PageUtils.getModerators(aSection, null);
		char topScope = '3';
		if (topicInfo != null)
		{
			topScope = ((String)topicInfo.get("TOPSCOPE")).charAt(0);
			if (topScope == 'N')
				topScope = '3';
		}
%>				
		<tr>
			<th>置顶级别</th>
			<td><label><input class="radio" type="radio" name="topScope"
						value="N"/> 解除置顶 </label>&nbsp;
				<label><input class="radio" type="radio" name="topScope" <%= topScope=='3'?"checked":"" %> 
						value="3"/> <img src="images/top_3.gif" alt="本版置顶"/> 本版置顶</label>
		<% if (userGroup.rights.indexOf(IConstants.PERMIT_TOP_GLOBAL) >= 0 
				|| moderators.indexOf("," + userinfo.userID.toLowerCase() + ",") >= 0) { %>
				<label><input class="radio" type="radio" name="topScope" <%= topScope=='2'?"checked":"" %> 
						value="2"/> <img src="images/top_2.gif" alt="分区置顶"/> 分区置顶</label>
		<% 	 if (userGroup.rights.indexOf(IConstants.PERMIT_TOP_GLOBAL) >= 0) { %>
				<label><input class="radio" type="radio" name="topScope" <%= topScope=='1'?"checked":"" %> 
						value="1"/> <img src="images/top_1.gif" alt="全局置顶"/> 全局置顶</label>
		<%
		 	 }
		   }
		%>
			</td>
		</tr>
<%
	} else if (action.equals("highlight")) {
		String highColor = null;
		if (topicInfo != null)
			highColor = (String)topicInfo.get("HIGHCOLOR");
		if (highColor == null || highColor.length() == 0)
			highColor = "black";
%>				
		<tr>
			<th>字体颜色</th>
			<td><label class="highlight" style="width:62px"><input class="radio" type="radio" name="lightcolor" 
				value=""/><em style="width:40px">不高亮</em></label>
			<label class="highlight"><input class="radio" type="radio" name="lightcolor" 
				value="black" <%= highColor.equals("black")?"checked":"" %>/> <em style="background: black;"></em></label>
			<label class="highlight"><input class="radio" type="radio" name="lightcolor" 
				value="red" <%= highColor.equals("red")?"checked":"" %>/><em style="background: red;"></em></label>
			<label class="highlight"><input class="radio" type="radio" name="lightcolor" 
				value="orange" <%= highColor.equals("orange")?"checked":"" %>/><em style="background: orange;"></em></label>
			<label class="highlight"><input class="radio" type="radio" name="lightcolor" 
				value="yellow" <%= highColor.equals("yellow")?"checked":"" %>/><em style="background: yellow;"></em></label>
			<label class="highlight"><input class="radio" type="radio" name="lightcolor" 
				value="green" <%= highColor.equals("green")?"checked":"" %>/><em style="background: green;"></em></label>
			<label class="highlight"><input class="radio" type="radio" name="lightcolor" 
				value="cyan" <%= highColor.equals("cyan")?"checked":"" %>/><em style="background: cyan;"></em></label>
			<label class="highlight"><input class="radio" type="radio" name="lightcolor" 
				value="blue" <%= highColor.equals("blue")?"checked":"" %>/><em style="background: blue;"></em></label>
			<label class="highlight"><input class="radio" type="radio" name="lightcolor" 
				value="purple" <%= highColor.equals("purple")?"checked":"" %>/><em style="background: purple;"></em></label>
			</td>
		</tr>
<% 	} else if (action.equals("move")) { %>
		<tr>
			<th>移动的目标版块</th>
			<td>
				<select id="moveto" name="moveto">
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
					sb.append("<OPTION value=\"").append(tmpSection.sectionID).append("_").append(tmpBoard.boardID)
					  .append("\">&nbsp; &gt; ").append(tmpBoard.boardName).append("</OPTION>\n");
				}
				sb.append("</OPTGROUP>");
			}
			out.write(sb.toString());
		}
%>
				</select>
			</td>
		</tr>
<%
	} else if (action.equals("close")) {
		char state = 'N';
		if (topicInfo != null)
			state = ((String)topicInfo.get("STATE")).charAt(0);
%>				
		<tr>
			<th>操作</th>
			<td><label><input class="radio" type="radio" name="state" value="open" 
							  <%= state=='C'?"checked":"" %>/> 打开主题</label> &nbsp;
				<label><input class="radio" type="radio" name="state" value="close"
							  <%= state=='N'?"checked":"" %>/> 关闭主题</label>
			</td>
		</tr>
<%
	} else if (action.equals("setbest")) {
%>				
		<tr>
			<th>操作</th>
			<td><label><input class="radio" type="radio" name="isBest" value="T" checked="checked"/> 设为最佳回复</label> &nbsp;
				<label><input class="radio" type="radio" name="isBest" value="F"/> 不是最佳回复</label>
			</td>
		</tr>
<%
	}
	if (action.equals("highlight") || action.equals("top")) {
		String expireDate = null;
		if (topicInfo != null)
		{
			if (action.equals("highlight"))
				expireDate = AppUtils.formatDateStr((String)topicInfo.get("HIGHEXPIREDATE"));
			else	
				expireDate = AppUtils.formatDateStr((String)topicInfo.get("TOPEXPIREDATE"));
		}
		if (expireDate == null || expireDate.length() == 0)
			expireDate = "";
%>
		<tr>
			<th><label for="expiredate">有效期</label></th>
			<td><input type="text" name="expiredate" id="expiredate" size="15" value="<%= expireDate %>"/> 
				&nbsp;(&nbsp;本操作的有效期限，格式为 yyyy-mm-dd，留空为不限制&nbsp;)
			</td>
		</tr>		
<%
	}
	if (!action.equals("setbest")) {
%>				
		<tr>
			<th valign="top">操作原因</th>
			<td>
			<select id="reasons" name="reasons" onchange="this.form.reason.value=this.value" style="width:110px;">
			<option value="">自定义</option>
			<option value="">------------</option>
<%		for (int i=0; i<judgeOptions.length; i++) { %>
			<option value="<%= judgeOptions[i].length()==0?"":judgeOptions[i].replace("\"", "&quot;") %>">
				<%= judgeOptions[i].length()==0?"------------":judgeOptions[i].replace("\"", "&quot;") %></option>
<%		} 	  %>
			</select>&nbsp;
		<input type=text id="reason" name="reason" size="50" maxlength="40"/>
			</td>
		</tr>
<%	}  %>
		<tr>
			<th>&nbsp;</th>
			<td>
				<input type="checkbox" name="sendsms" value="yes" 
							  style="vertical-align:text-bottom"/> 发短消息通知作者 
<%	if (action.equals("delete")) {
		if (isModerator) {
%>
				<input type="checkbox" name="moduserinfo" value="no" 
							  style="vertical-align:text-bottom"/> 删帖但不减用户发帖数和积分
<%	} }  %>				
			</td>
		</tr>
		<tr class="btns">
			<th>&nbsp;</th>
			<td height="35"><button type="submit" name="modsubmit" id="postsubmit" class=submit>提交</button></td>
		</tr>
	</table>
<% for (int i=0; i<topicIDs.length; i++) { %><input type="hidden" name="topicID" value="<%= topicIDs[i] %>"/> <% } %>
<% if (replyID != null) { %><input type="hidden" name="replyID" value="<%= replyID %>"/> <% } %>
	</div>
</form>
</DIV>
<%= menus[1]==null?"":menus[1] %>
<%= menus[2]==null?"":menus[2] %>
<%= PageUtils.getFooter(request, forumStyle) %>
</BODY></HTML>
