<%@ page contentType="text/html;charset=gbk" errorPage="./error.jsp"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="java.util.HashMap"%>
<%@ page import="com.hongshee.ejforum.util.PageUtils"%>
<%@ page import="com.hongshee.ejforum.util.AppUtils"%>
<%@ page import="com.hongshee.ejforum.common.ForumSetting"%>
<%@ page import="com.hongshee.ejforum.common.CacheManager"%>
<%@ page import="com.hongshee.ejforum.common.IConstants"%>
<%@ page import="com.hongshee.ejforum.data.GroupDAO.GroupVO"%>
<%@ page import="com.hongshee.ejforum.data.UserDAO.UserInfo"%>
<%@ page import="com.hongshee.ejforum.data.UserDAO"%>
<%
	UserInfo userinfo = PageUtils.getSessionUser(request);
    GroupVO aGroup = PageUtils.getGroupVO(userinfo);
	if (aGroup.rights.indexOf(IConstants.PERMIT_VIEW_MEMBERS) < 0)
	{
		request.setAttribute("errorMsg", "您没有查看会员列表的权限");
		request.getRequestDispatcher("/error.jsp").forward(request, response);
		return;
	}	
	String forumName = ForumSetting.getInstance().getForumName();
	String title = PageUtils.getTitle(forumName);
	String[] menus = PageUtils.getHeaderMenu(request, userinfo);
	String homeUrl = "./index.jsp";
	String forumStyle = PageUtils.getForumStyle(request, response, null);
	
	String strPageNo = request.getParameter("page");
	int pageNo = PageUtils.getPageNo(strPageNo);
	int pageRows = 15;

	String key = PageUtils.getParam(request, "key");
	String sortField = PageUtils.getParam(request, "sortfield");
    if (sortField == null || sortField.length() == 0)
        sortField = "userID";
	
	Object[] result = UserDAO.getInstance().getUserList(sortField, key, pageNo, pageRows);
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<HTML xmlns="http://www.w3.org/1999/xhtml">
<HEAD>
<TITLE>会员列表 - <%= title %></TITLE>
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
<DIV id=nav><A href="<%= homeUrl %>"><%= forumName %></A> &raquo;&nbsp; 会员列表</DIV>
<DIV class=container style="padding-bottom:0px">
<DIV class=mainbox>
<H1>会员列表</H1>
<TABLE cellSpacing=0 cellPadding=0>
  <THEAD>
  <TR>
    <TD width="12%">用户名</TD>
    <TD width="12%">昵称</TD>
    <TD width="10%">性别</TD>
    <TD width="12%">用户组</TD>
    <TD width="20%">上次访问</TD>
    <TD width="10%">积分</TD>
    <TD width="10%">帖子数</TD>
    <TD width="14%">注册日期</TD>
  </TR></THEAD>
  <TBODY>
<%
	if (result != null && result[1] != null)
	{
		ArrayList userList = (ArrayList)result[1];

		HashMap record = null;
		String nickname = null;
		String userID = null;
		char gender = 'U';
		String credits = null;
		CacheManager cache = CacheManager.getInstance();
		
		for (int i=0; i<userList.size(); i++)
		{
			record = (HashMap)userList.get(i);
			userID = (String)record.get("USERID");
			nickname = (String)record.get("NICKNAME");
			if (nickname == null)
				nickname = "";
			gender = ((String)record.get("GENDER")).charAt(0);
			credits = (String)record.get("CREDITS");
			aGroup = cache.getGroup(Integer.parseInt(credits));
%>  
  <TR>
    <TD><A href="uspace.jsp?uid=<%= userID %>" target="_blank"><%= userID %></A></TD>
    <TD><%= nickname %></TD>
    <TD><%= gender=='U'?"保密":(gender=='M'?"男":"女")  %></TD>
    <TD><%= aGroup.groupName %></TD>
    <TD><%= AppUtils.formatSQLTimeStr((String)record.get("LASTVISITED")) %></TD>
    <TD><%= credits %></TD>
    <TD><%= (String)record.get("POSTS") %></TD>
    <TD><%= AppUtils.formatDateStr((String)record.get("CREATETIME")) %></TD>
  </TR>
<%
		}
	}	
%>  
</TBODY></TABLE></DIV>
<%
	if (result != null && result[0] != null)
	{
%>	  
<DIV class=pages_btns>
	<%= result[0] %>
<SCRIPT type=text/javascript>
var myUrl = "./userlist.jsp?sortfield=<%= sortField %>";
function viewPage(pageno)
{
	window.location = myUrl + "&page=" + pageno;
}
</SCRIPT>
</DIV>
<%
	}
%>
</DIV>
<DIV id="footfilter" class=legend style="margin-top:0px">
<form id="frmsearch" name="frmsearch" action="./userlist.jsp" method="post" style="float:right; padding:1px">
	用户名: <input type="text" size="15" name="key"/>&nbsp;<button type="submit">搜索</button>
</form>
<DIV style="padding-left:2px">排序方式: 
    <a href="userlist.jsp?sortfield=userid">用户名</a> -
    <a href="userlist.jsp?sortfield=groupid">用户组</a> - 
	<a href="userlist.jsp?sortfield=credits">积分</a> - 
	<a href="userlist.jsp?sortfield=posts">帖子数</a> - 
	<a href="userlist.jsp?sortfield=createtime">注册日期</a></DIV>
</DIV></DIV>
<%= menus[1]==null?"":menus[1] %>
<%= menus[2]==null?"":menus[2] %>
<%= PageUtils.getFooter(request, forumStyle) %>
</BODY></HTML>
