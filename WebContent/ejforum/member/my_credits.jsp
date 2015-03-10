<%@ page contentType="text/html;charset=gbk" errorPage="../error.jsp"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="java.util.HashMap"%>
<%@ page import="com.hongshee.ejforum.util.PageUtils"%>
<%@ page import="com.hongshee.ejforum.util.AppUtils"%>
<%@ page import="com.hongshee.ejforum.common.ForumSetting"%>
<%@ page import="com.hongshee.ejforum.data.UserDAO.UserInfo"%>
<%@ page import="com.hongshee.ejforum.data.ActionLogDAO"%>
<%
	UserInfo userinfo = PageUtils.getLoginedUser(request, response);
	if (userinfo == null) return;

	String forumName = ForumSetting.getInstance().getForumName();
	String title = PageUtils.getTitle(forumName);
	String[] menus = PageUtils.getHeaderMenu(request, userinfo);
	String homeUrl = "../index.jsp";
	String forumStyle = PageUtils.getForumStyle(request, response, null);
	
	String act = request.getParameter("act");
	if (act == null || act.length() == 0)
		act = "inc";

	String strPageNo = request.getParameter("page");
	int pageNo = PageUtils.getPageNo(strPageNo);
	int pageRows = 15;

	Object[] result = ActionLogDAO.getInstance().getCreditsLogs(userinfo.userID, act, pageNo, pageRows);
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<HTML xmlns="http://www.w3.org/1999/xhtml">
<HEAD>
<TITLE>积分交易记录 - <%= title %></TITLE>
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
<DIV id=nav><A href="<%= homeUrl %>"><%= forumName %></A> &raquo;&nbsp; 积分交易记录 </DIV>
<DIV class=container><DIV class=content>
<DIV class="mainbox">
<H1>积分交易记录</H1>
<UL class="tabs headertabs">
  <LI<%= act.equals("inc")?" class=current":"" %>><A href="./my_credits.jsp?act=inc">积分收入记录</A> </LI>
  <LI<%= act.equals("dec")?" class=current":"" %>><A href="./my_credits.jsp?act=dec">积分支出记录</A> </LI></UL>
<TABLE cellSpacing=0 cellPadding=0 align=center>
  <THEAD>
  <TR>
    <TD width="20%">交易用户</TD>
    <TD width="25%">时间</TD>
    <TD width="15%">类型</TD>
    <TD width="15%">积分值</TD>
    <TD width="25%">动作</TD></TR></THEAD>
  <TBODY>
<%  
	if (result != null && result[1] != null)
	{
		String logType = null;
		if (act.equals("inc")) 
			logType = "收入";
		else
			logType = "支出";
							
		ArrayList logList = (ArrayList)result[1];
		HashMap record = null;
		String userID = null;
			
		for (int i=0; i<logList.size(); i++)
		{
			record = (HashMap)logList.get(i);

			if (act.equals("inc")) 
				userID = (String)record.get("FROMUSER");
			else
				userID = (String)record.get("USERID");
%>  
  <TR>
    <TD><A href="../uspace.jsp?uid=<%= userID %>"><%= userID %></A></TD>
    <TD><%= AppUtils.formatSQLTimeStr((String)record.get("CREATETIME")) %></TD>
    <TD><%= logType %></TD>
    <TD><%= (String)record.get("CREDITS") %></TD>
    <TD><%= (String)record.get("ACTION") %></TD>
	</TR>
<%
		}
	}
	else
	{
%>	
  <TR>
    <TD colspan="5">没有记录</TD></TR>
<%
	}
%>
</TBODY></TABLE>
</DIV></DIV>
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
  <LI><H3><A href="my_rights.jsp">我的权限</A></H3></LI>
  <LI class="side_on"><H3><A href="my_credits.jsp">积分交易记录</A></H3></LI>
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
