<%@ page contentType="text/html;charset=gbk" errorPage="error.jsp"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="com.hongshee.ejforum.util.PageUtils"%>
<%@ page import="com.hongshee.ejforum.common.CacheManager"%>
<%@ page import="com.hongshee.ejforum.common.ForumSetting"%>
<%@ page import="com.hongshee.ejforum.data.UserDAO.UserInfo"%>
<%@ page import="com.hongshee.ejforum.data.GroupDAO.GroupVO"%>
<%
	ForumSetting setting = ForumSetting.getInstance();
	String forumName = setting.getForumName();
	String title = PageUtils.getTitle(forumName);
	UserInfo userinfo = PageUtils.getSessionUser(request);
	String[] menus = PageUtils.getHeaderMenu(request, userinfo);
	String homeUrl = "../index.jsp";
	String forumStyle = PageUtils.getForumStyle(request, response, null);
	
	CacheManager cache = CacheManager.getInstance();
    ArrayList groups = cache.getGroups();
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<HTML xmlns="http://www.w3.org/1999/xhtml">
<HEAD>
<TITLE>积分策略说明 - <%= title %></TITLE>
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
<DIV id=nav><A href="<%= homeUrl %>"><%= forumName %></A> &raquo;&nbsp; 积分策略说明</DIV>
<DIV class="mainbox">
<H1>积分策略说明</H1>
<TABLE cellSpacing=0 cellPadding=0>
  <THEAD>
  <TR>
    <TH width="45%">行为</TH>
    <TD>积分</TD>
  </TR></THEAD>
  <TBODY>
  <TR><TH>注册初始积分</TH><TD><%= setting.getInt(ForumSetting.CREDITS,"userInitValue") %></TD></TR>
  <TR><TH>发新主题</TH><TD>+<%= setting.getInt(ForumSetting.CREDITS,"newTopic") %></TD></TR>
  <TR><TH>发表回复</TH><TD>+<%= setting.getInt(ForumSetting.CREDITS,"newReply") %></TD></TR>
  <TR><TH>设为最佳回复</TH><TD>+<%= setting.getInt(ForumSetting.CREDITS,"bestReply") %></TD></TR>
  <TR><TH>加入精华</TH><TD>+<%= setting.getInt(ForumSetting.CREDITS,"digestTopic") %></TD></TR>
  <TR><TH>上传附件</TH><TD>+<%= setting.getInt(ForumSetting.CREDITS,"upload") %></TD></TR>
  <TR><TH>下载附件</TH><TD><%= setting.getInt(ForumSetting.CREDITS,"download") %></TD></TR>
  <TR><TH>积分奖惩</TH><TD>由管理员设定</TD></TR>
  <TR><TH>积分交易</TH><TD>由具体交易而定</TD></TR>
  </TBODY>
</TABLE></DIV>
<DIV class="mainbox">
<H1>会员用户组</H1>
<TABLE cellSpacing=0 cellPadding=0>
  <THEAD>
  <TR>
    <TH width="45%">组名称</TH>
    <TD>积分范围</TD>
  </TR></THEAD>
  <TBODY>
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
  <TR><TH><%= aGroup.groupName %></TH><TD><%= aGroup.minCredits %>&nbsp;~&nbsp;<%= aGroup.maxCredits %></TD></TR>
<%
			}
		}
	}
%>			
  </TBODY>
</TABLE>
</DIV></DIV>
<%= menus[1]==null?"":menus[1] %>
<%= menus[2]==null?"":menus[2] %>
<%= PageUtils.getFooter(request,forumStyle) %>
</BODY></HTML>
