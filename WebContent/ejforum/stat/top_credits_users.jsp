<%@ page contentType="text/html;charset=gbk" errorPage="../error.jsp"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="java.util.HashMap"%>
<%@ page import="com.hongshee.ejforum.util.PageUtils"%>
<%@ page import="com.hongshee.ejforum.util.AppUtils"%>
<%@ page import="com.hongshee.ejforum.common.ForumSetting"%>
<%@ page import="com.hongshee.ejforum.common.IConstants"%>
<%@ page import="com.hongshee.ejforum.data.GroupDAO.GroupVO"%>
<%@ page import="com.hongshee.ejforum.data.UserDAO.UserInfo"%>
<%@ page import="com.hongshee.ejforum.data.StatDAO"%>
<%
	UserInfo userinfo = PageUtils.getSessionUser(request);
    GroupVO aGroup = PageUtils.getGroupVO(userinfo);
	if (aGroup.rights.indexOf(IConstants.PERMIT_VIEW_STAT) < 0)
	{
		request.setAttribute("errorMsg", "您没有查看统计数据的权限");
		request.getRequestDispatcher("/error.jsp").forward(request, response);
		return;
	}	
	String forumName = ForumSetting.getInstance().getForumName();
	String title = PageUtils.getTitle(forumName);
	String[] menus = PageUtils.getHeaderMenu(request, userinfo);
	String homeUrl = "../index.jsp";
	String forumStyle = PageUtils.getForumStyle(request, response, null);
	
	Object[] result = StatDAO.getInstance().getTopUsersInfo();
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<HTML xmlns="http://www.w3.org/1999/xhtml">
<HEAD>
<TITLE>积分排行 - <%= title %></TITLE>
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
<DIV id=nav><A href="<%= homeUrl %>"><%= forumName %></A> &raquo;&nbsp; 
<A href="./baseinfo.jsp">论坛统计</A> &raquo;&nbsp; 积分排行 </DIV>
<DIV class=container>
<DIV class=side>
<DIV>
<H2>统计选项</H2>
<UL>
  <LI><H3><A href="baseinfo.jsp">基本概况</A> </H3></LI>
  <LI><H3><A href="flux.jsp">访问量记录</A> </H3></LI>
  <LI><H3><A href="top_boards.jsp">版块排行</A> </H3></LI>
  <LI><H3><A href="top_topics.jsp">主题排行</A> </H3></LI>
  <LI class=side_on><H3><A href="top_credits_users.jsp">积分排行</A> </H3></LI>
  <LI><H3><A href="admins.jsp">管理团队</A> </H3></LI>
</UL></DIV></DIV>
<DIV class=content>
<DIV class=mainbox>
<H1>会员积分排行</H1>
<TABLE cellSpacing=0 cellPadding=0 summary=积分排行>
  <THEAD>
  <TR>
    <TD width="40%">积分排行榜</TD>
    <TD width="10%"></TD>
    <TD width="40%">发贴排行榜</TD>
    <TD width="10%"></TD>
  </TR></THEAD>
  <TBODY>
<%
	if (result != null && result[0] != null)
	{
		ArrayList topCreditsUsers = (ArrayList)result[0];
		ArrayList topPostsUsers = (ArrayList)result[1];
		HashMap record = null;
		String nickname = null;
	
		for (int i=0; i<topCreditsUsers.size(); i++)
		{
			record = (HashMap)topCreditsUsers.get(i);
			nickname = (String)record.get("NICKNAME");
			if (nickname == null || nickname.length() == 0)
				nickname = (String)record.get("USERID");
%>  
  <TR>
    <TD><A href="../uspace.jsp?uid=<%= (String)record.get("USERID") %>" target=_blank><%= nickname %></A>&nbsp;</TD>
    <TD><%= (String)record.get("CREDITS") %></TD>
<%
			record = (HashMap)topPostsUsers.get(i);
			nickname = (String)record.get("NICKNAME");
			if (nickname == null || nickname.length() == 0)
				nickname = (String)record.get("USERID");
%>	
    <TD><A href="../uspace.jsp?uid=<%= (String)record.get("USERID") %>" target=_blank><%= nickname %></A>&nbsp;</TD>
    <TD><%= (String)record.get("POSTS") %></TD></TR>
<%
		}
	}
%>	
</TBODY></TABLE></DIV>
</DIV></DIV></DIV>
<%= menus[1]==null?"":menus[1] %>
<%= menus[2]==null?"":menus[2] %>
<%= PageUtils.getFooter(request,forumStyle) %>
</BODY></HTML>
