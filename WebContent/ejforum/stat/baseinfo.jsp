<%@ page contentType="text/html;charset=gbk" errorPage="../error.jsp"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="java.util.HashMap"%>
<%@ page import="com.hongshee.ejforum.util.PageUtils"%>
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

	HashMap statInfo = StatDAO.getInstance().getBaseStatInfo();
	int topics = Integer.parseInt((String)statInfo.get("topics"));
	int replies = Integer.parseInt((String)statInfo.get("replies"));
	int visits = Integer.parseInt((String)statInfo.get("visits"));
	int users = Integer.parseInt((String)statInfo.get("users"));
	int userLogins = Integer.parseInt((String)statInfo.get("userLogins"));

	if (topics < 1) topics = 1;
	if (users < 1) users = 1;
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<HTML xmlns="http://www.w3.org/1999/xhtml">
<HEAD>
<TITLE>基本概况 - <%= title %></TITLE>
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
<A href="./baseinfo.jsp">论坛统计</A> &raquo;&nbsp; 基本概况</DIV>
<DIV class=container>
<DIV class=side>
<DIV>
<H2>统计选项</H2>
<UL>
  <LI class=side_on><H3><A href="baseinfo.jsp">基本概况</A> </H3></LI>
  <LI><H3><A href="flux.jsp">访问量记录</A> </H3></LI>
  <LI><H3><A href="top_boards.jsp">版块排行</A> </H3></LI>
  <LI><H3><A href="top_topics.jsp">主题排行</A> </H3></LI>
  <LI><H3><A href="top_credits_users.jsp">积分排行</A> </H3></LI>
  <LI><H3><A href="admins.jsp">管理团队</A> </H3></LI>
</UL></DIV></DIV>
<DIV class=content>
<DIV class=mainbox>
<H3>论坛统计</H3>
<TABLE cellSpacing=0 cellPadding=0>
  <TBODY>
  <TR>
    <TH width="22%">版块数</TH>
    <TD width="11%"><%= (String)statInfo.get("boards") %></TD>
    <TH width="22%">主题数</TH>
    <TD width="11%"><%= topics %></TD>
    <TH width="22%">精华数</TH>
    <TD width="11%"><%= (String)statInfo.get("digests") %></TD>
  </TR>
  <TR>
    <TH>悬赏主题数</TH>
    <TD><%= (String)statInfo.get("rewards") %></TD>
    <TH>回复数</TH>
    <TD><%= replies %></TD>
    <TH>附件数</TH>
    <TD><%= (String)statInfo.get("attaches") %></TD>
  </TR>
  <TR>
    <TH>平均每个主题被回复次数</TH>
    <TD><%= replies/topics %></TD>
    <TH>平均每个主题被访问次数</TH>
    <TD><%= visits/topics %></TD>
    <TH></TH>
    <TD></TD>
  </TR>
  </TBODY></TABLE></DIV>
<DIV class=mainbox>
<H3>会员统计</H3>
<TABLE cellSpacing=0 cellPadding=0>
  <TBODY>
  <TR>
    <TH width="22%">注册会员数</TH>
    <TD width="11%"><%= users %></TD>
    <TH width="22%">发帖会员数</TH>
    <TD width="11%"><%= (String)statInfo.get("postUsers") %></TD>
    <TH width="22%">管理成员数</TH>
    <TD width="11%"><%= (String)statInfo.get("adminUsers") %></TD>
  </TR>
  <TR>
    <TH>平均每人登录次数</TH>
    <TD><%= userLogins/users %></TD>
    <TH>平均每人发帖数</TH>
    <TD><%= (topics + replies)/users %></TD>
    <TH></TH>
    <TD></TD>
  </TR>
  </TBODY></TABLE></DIV>
<DIV class=remark><img src="../images/notice.gif" border="0" align="absmiddle"/>&nbsp;
统计数据每天更新一次，最新统计时间是 <%= (String)statInfo.get("statTime") %></DIV>  
</DIV></DIV></DIV>
<%= menus[1]==null?"":menus[1] %>
<%= menus[2]==null?"":menus[2] %>
<%= PageUtils.getFooter(request,forumStyle) %>
</BODY></HTML>
