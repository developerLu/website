<%@ page contentType="text/html;charset=gbk" errorPage="../error.jsp"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="com.hongshee.ejforum.util.PageUtils"%>
<%@ page import="com.hongshee.ejforum.common.CacheManager"%>
<%@ page import="com.hongshee.ejforum.common.ForumSetting"%>
<%@ page import="com.hongshee.ejforum.common.IConstants"%>
<%@ page import="com.hongshee.ejforum.data.UserDAO.UserInfo"%>
<%@ page import="com.hongshee.ejforum.data.GroupDAO.GroupVO"%>
<%@ page import="com.hongshee.ejforum.data.BoardDAO.BoardVO"%>
<%@ page import="com.hongshee.ejforum.data.SectionDAO.SectionVO"%>
<%
	UserInfo userinfo = PageUtils.getLoginedUser(request, response);
	if (userinfo == null) return;

	String forumName = ForumSetting.getInstance().getForumName();
	String title = PageUtils.getTitle(forumName);
	String[] menus = PageUtils.getHeaderMenu(request, userinfo);
	String homeUrl = "../index.jsp";
	String forumStyle = PageUtils.getForumStyle(request, response, null);

	CacheManager cache = CacheManager.getInstance();
    ArrayList groups = cache.getGroups();
	
	String act = request.getParameter("act");
	if (act == null || act.length() == 0)
		act = "my";
		
	String groupID = request.getParameter("gid");
	GroupVO currentGroup = null;
	if (groupID == null || groupID.length() == 0)
	{
		currentGroup = PageUtils.getGroupVO(userinfo);
	}
	else
		currentGroup = cache.getGroup(groupID.charAt(0));
		
	String rights = currentGroup.rights;
	String adminRight = "无";
	if (currentGroup.groupID == 'A')
		adminRight = "全论坛";
	else if (currentGroup.groupID == 'M' || currentGroup.groupID == 'S')
		adminRight = "其所负责的版块";
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<HTML xmlns="http://www.w3.org/1999/xhtml">
<HEAD>
<TITLE>我的权限 - <%= title %></TITLE>
<%= PageUtils.getMetas(title, null) %>
<LINK href="../styles/<%= forumStyle %>/ejforum.css" type=text/css rel=stylesheet>
</HEAD>
<BODY onkeydown="if(event.keyCode==27) return false;">
<SCRIPT src="../js/common.js" type=text/javascript></SCRIPT>
<DIV class=wrap>
<DIV id=header>
<%= PageUtils.getHeader(request, title) %>
<%= PageUtils.getHeadAdBanner(request, null) %></DIV>
<%= menus[0] %>
<DIV id=nav><A href="<%= homeUrl %>"><%= forumName %></A> &raquo;&nbsp; 我的权限</DIV>
<DIV class=container><DIV class=content>
<DIV class=mainbox>
<H1>我的权限</H1>
<UL class="tabs headertabs">
  <LI<%= act.equals("my")?" class=current":"" %>><A href="./my_rights.jsp">我的权限</A> </LI>
  <LI class="<%= act.equals("member")?"current ":"" %>dropmenu" style='BACKGROUND-POSITION:95%'><A id=membergroup 
  		onmouseover=showMenu(this.id) href="###">会员用户组</A> </LI>
  <LI class="<%= act.equals("system")?"current ":"" %>dropmenu" style='BACKGROUND-POSITION:95%'><A id=systemgroup 
  		onmouseover=showMenu(this.id) href="###">系统用户组</A> 
</LI></UL>
<UL class="popmenu_popup headermenu_popup" id=membergroup_menu style="DISPLAY: none">
<%
	if (groups != null)
	{
		GroupVO aGroup = null;
		for (int i=0; i<groups.size(); i++)
		{
			aGroup = (GroupVO)groups.get(i);
			if (aGroup.groupType == 'M')
			{
%>			
  <LI><A href="./my_rights.jsp?act=member&gid=<%= aGroup.groupID %>"><%= aGroup.groupName %></A></LI>
<%
			}
		}
	}		
%>  
</UL>
<UL class="popmenu_popup headermenu_popup" id=systemgroup_menu style="DISPLAY: none">
<%
	if (groups != null)
	{
		GroupVO aGroup = null;
		for (int i=0; i<groups.size(); i++)
		{
			aGroup = (GroupVO)groups.get(i);
			if (aGroup.groupType == 'S')
			{
%>			
  <LI><A href="./my_rights.jsp?act=system&gid=<%= aGroup.groupID %>"><%= aGroup.groupName %></A></LI>
<%
			}
		}
	}
	
	int count1 = -1;
	int count2 = currentGroup.stars;
	if (currentGroup.stars > 5)
	{
		count1 = currentGroup.stars / 5;
		count2 = currentGroup.stars % 5;
	}
	
	String boards = null;
	if (act.equals("my"))
	{
		String user_id = "," + userinfo.userID + ",";
		if (cache.getModerators().indexOf(user_id) >= 0)
		{
			SectionVO aSection = null;
			BoardVO aBoard = null;
			ArrayList sections = cache.getSections();
			String moderators = null;
			StringBuilder sbuf = new StringBuilder();
						
			for (int i=0; i<sections.size(); i++)
			{
				aSection = (SectionVO)sections.get(i);
				for (int j=0; j<aSection.boardList.size(); j++)
				{
					aBoard = (BoardVO)aSection.boardList.get(j);
					moderators = PageUtils.getModerators(aSection, aBoard);
					if (moderators.indexOf(user_id) >= 0)
					{
						if (sbuf.length() > 0)
							sbuf.append(", ");
						sbuf.append(aBoard.boardName);
					}
				}
			}
			if (sbuf.length() > 0)
			{
				GroupVO aGroup = null;
	        	if (userinfo.groupID <= '9')
                	aGroup = cache.getGroup('M');
                else
                    aGroup = cache.getGroup(userinfo.groupID);
				boards = aGroup.groupName + " （" + sbuf.toString() + "）";
			}
		}
	}		
%>  
</UL>
<TABLE cellSpacing=0 cellPadding=0 width="100%">
  <THEAD>
  <TR>
    <TD colSpan=2>用户组</TD></TR></THEAD>
  <TBODY>
  <TR>
    <TH width="25%">用户组名:</TH>
    <TD width="75%"><%= currentGroup.groupName %></TD></TR>
  <TR>
    <TH>用户组级别:</TH>
    <TD>
		<%	for (int j=0; j<count1; j++) { %><IMG alt="Rank: <%= currentGroup.stars %>" 
		src="../images/star_5.gif" align="absmiddle" border="0"><% } for (int j=0; j<count2; j++) { %><IMG 
		alt="Rank: <%= currentGroup.stars %>" src="../images/star_1.gif" align="absmiddle" border="0"><% } %>
	</TD></TR>
<%
	if (boards != null) {
%>		
  <TR>
    <TH>版块权限:</TH>
    <TD><%= boards %></TD></TR>
<%	} %>
  <THEAD>
  <TR>
    <TD colSpan=2>基本权限</TD></TR></THEAD>
  <TBODY>
  <TR>
    <TH>允许访问论坛:</TH>
    <TD><IMG src="../images/check_<%= rights.indexOf(IConstants.PERMIT_VISIT_FORUM)>=0?"right":"error" %>.gif"></TD></TR>
  <TR>
    <TH>允许查看会员列表:</TH>
    <TD><IMG src="../images/check_<%= rights.indexOf(IConstants.PERMIT_VIEW_MEMBERS)>=0?"right":"error" %>.gif"></TD></TR>
  <TR>
    <TH>允许查看用户信息:</TH>
    <TD><IMG src="../images/check_<%= rights.indexOf(IConstants.PERMIT_VIEW_USERINFO)>=0?"right":"error" %>.gif"></TD></TR>
  <TR>
    <TH>允许查看统计数据:</TH>
    <TD><IMG src="../images/check_<%= rights.indexOf(IConstants.PERMIT_VIEW_STAT)>=0?"right":"error" %>.gif"></TD></TR>
  <TR>
    <TH>允许上传头像:</TH>
    <TD><IMG src="../images/check_<%= rights.indexOf(IConstants.PERMIT_UPLOAD_AVATAR)>=0?"right":"error" %>.gif"></TD></TR>
  <THEAD>
  <TR>
    <TD colSpan=2>帖子相关</TD></TR></THEAD>
  <TBODY>
  <TR>
    <TH>允许发新话题:</TH>
    <TD><IMG src="../images/check_<%= rights.indexOf(IConstants.PERMIT_NEW_TOPIC)>=0?"right":"error" %>.gif"></TD></TR>
  <TR>
    <TH>允许发布悬赏主题:</TH>
    <TD><IMG src="../images/check_<%= rights.indexOf(IConstants.PERMIT_NEW_REWARD)>=0?"right":"error" %>.gif"></TD></TR>
  <TR>
    <TH>允许发匿名贴:</TH>
    <TD><IMG src="../images/check_<%= rights.indexOf(IConstants.PERMIT_HIDE_POST)>=0?"right":"error" %>.gif"></TD></TR>
  <TR>
    <TH>允许发表回复:</TH>
    <TD><IMG src="../images/check_<%= rights.indexOf(IConstants.PERMIT_NEW_REPLY)>=0?"right":"error" %>.gif"></TD></TR>
  <TR>
    <TH>允许使用&nbsp;HTML&nbsp;代码:</TH>
    <TD><IMG src="../images/check_<%= rights.indexOf(IConstants.PERMIT_USE_HTML)>=0?"right":"error" %>.gif"></TD></TR>
  <TR>
    <TH>允许发置顶帖子:</TH>
    <TD><IMG src="../images/check_<%= rights.indexOf(IConstants.PERMIT_TOP_POST)>=0?"right":"error" %>.gif"></TD></TR>
  <THEAD>
  <TR>
    <TD colSpan=2>附件相关</TD></TR></THEAD>
  <TBODY>
  <TR>
    <TH>允许下载/查看附件:</TH>
    <TD><IMG src="../images/check_<%= rights.indexOf(IConstants.PERMIT_DOWNLOAD)>=0?"right":"error" %>.gif"></TD></TR>
  <TR>
    <TH>允许发布附件:</TH>
    <TD><IMG src="../images/check_<%= rights.indexOf(IConstants.PERMIT_UPLOAD)>=0?"right":"error" %>.gif"></TD></TR>
  <THEAD>
  <TR>
    <TD colSpan=2>管理权限</TD></TR></THEAD>
  <TBODY>
  <TR>
    <TH>管理范围:</TH>
    <TD><%= adminRight %></TD></TR>
<%
	if (!adminRight.equals("无")) {
%>	
  <TR>
    <TH>允许全局置顶主题:</TH>
    <TD><IMG src="../images/check_<%= rights.indexOf(IConstants.PERMIT_TOP_GLOBAL)>=0?"right":"error" %>.gif"></TD></TR>
  <TR>
    <TH>允许编辑帖子:</TH>
    <TD><IMG src="../images/check_<%= rights.indexOf(IConstants.PERMIT_EDIT_POST)>=0?"right":"error" %>.gif"></TD></TR>
  <TR>
    <TH>允许删除帖子:</TH>
    <TD><IMG src="../images/check_<%= rights.indexOf(IConstants.PERMIT_DELETE_POST)>=0?"right":"error" %>.gif"></TD></TR>
  <TR>
    <TH>允许关闭帖子:</TH>
    <TD><IMG src="../images/check_<%= rights.indexOf(IConstants.PERMIT_CLOSE_POST)>=0?"right":"error" %>.gif"></TD></TR>
  <TR>
    <TH>允许移动主题:</TH>
    <TD><IMG src="../images/check_<%= rights.indexOf(IConstants.PERMIT_MOVE_POST)>=0?"right":"error" %>.gif"></TD></TR>
  <TR>
    <TH>允许编辑用户:</TH>
    <TD><IMG src="../images/check_<%= rights.indexOf(IConstants.PERMIT_EDIT_USER)>=0?"right":"error" %>.gif"></TD></TR>
  <TR>
    <TH>允许执行积分奖惩:</TH>
    <TD><IMG src="../images/check_<%= rights.indexOf(IConstants.PERMIT_EDIT_CREDITS)>=0?"right":"error" %>.gif"></TD></TR>
  <TR>
    <TH>允许禁止用户:</TH>
    <TD><IMG src="../images/check_<%= rights.indexOf(IConstants.PERMIT_BAN_USER)>=0?"right":"error" %>.gif"></TD></TR>
  <TR>
    <TH>允许审核用户:</TH>
    <TD><IMG src="../images/check_<%= rights.indexOf(IConstants.PERMIT_AUDIT_USER)>=0?"right":"error" %>.gif"></TD></TR>
  <TR>
    <TH>允许删除用户:</TH>
    <TD><IMG src="../images/check_<%= rights.indexOf(IConstants.PERMIT_DELETE_USER)>=0?"right":"error" %>.gif"></TD></TR>
<%
	}
%>	
</TBODY></TABLE></DIV></DIV>
<DIV class=side>
<DIV>
<H2>我的空间</H2>
<UL>
  <LI><H3><A href="../uspace.jsp?uid=<%= userinfo.userID %>" target="_blank">个人信息页</A></H3></LI>
  <LI><H3><A href="my_profile.jsp">编辑个人资料</A></H3></LI>
  <LI><H3><A href="sms_list.jsp">短消息</A></H3></LI>
  <LI><H3><A href="my_topics.jsp">我的话题</A></H3></LI>
  <LI><H3><A href="my_favors.jsp">我的收藏</A></H3></LI>
  <LI><H3><A href="my_friends.jsp">我的好友</A></H3></LI>
  <LI class="side_on"><H3><A href="my_rights.jsp">我的权限</A></H3></LI>
  <LI><H3><A href="my_credits.jsp">积分交易记录</A></H3></LI>
</UL>
</DIV>
<DIV>
<H2>积分概况</H2>
<UL class="credits">
  <LI>积分: <%= userinfo.credits %></LI>
  <LI>帖子: <%= userinfo.posts %></LI>
</UL></DIV></DIV></DIV></DIV>
<%= menus[1]==null?"":menus[1] %>
<%= menus[2]==null?"":menus[2] %>
<%= PageUtils.getFooter(request,forumStyle) %>
</BODY></HTML>
