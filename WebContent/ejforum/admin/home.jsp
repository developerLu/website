<%@ page contentType="text/html;charset=gbk" errorPage="error.jsp"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="java.text.NumberFormat"%>
<%@ page import="com.hongshee.common.util.DBManager"%>
<%@ page import="com.hongshee.ejforum.util.PageUtils"%>
<%@ page import="com.hongshee.ejforum.common.CacheManager"%>
<%@ page import="com.hongshee.ejforum.common.AppContext"%>
<%@ page import="com.hongshee.ejforum.common.ForumSetting"%>
<%@ page import="com.hongshee.ejforum.data.UserDAO.UserInfo"%>
<%@ page import="com.hongshee.ejforum.data.SectionDAO.SectionVO"%>
<%@ page import="com.hongshee.ejforum.data.BoardDAO.BoardVO"%>
<%
	UserInfo userinfo = PageUtils.getAdminUser(request, response);
	if (userinfo == null) return;
	
	ForumSetting setting = ForumSetting.getInstance();
    DBManager dbManager = DBManager.getInstance();
	
	CacheManager cache = CacheManager.getInstance();
    ArrayList sections = cache.getSections();
	
	ArrayList adminUsers = PageUtils.getSessionAdminUsers();
	if (adminUsers.size() == 0) // Sessions will lost when web server restarted
	{
		adminUsers.add(userinfo);
	}
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<HTML xmlns="http://www.w3.org/1999/xhtml"><HEAD>
<META http-equiv=Content-Type content="text/html; charset=gbk">
<LINK href="style/admin.css" type=text/css rel=stylesheet>
<SCRIPT src="../js/common.js" type=text/javascript></SCRIPT>
<SCRIPT src="js/admin.js" type=text/javascript></SCRIPT>
</HEAD>
<BODY topMargin=10>
<TABLE cellSpacing=6 cellPadding=2 width="100%" border=0>
  <TBODY>
  <TR>
    <TD>
      <TABLE class=guide cellSpacing=0 cellPadding=0 width="100%" border=0>
        <TBODY>
        <TR>
          <TD><A onclick="parent.location='index.htm'; return false;" href="#">后台管理首页</A>&nbsp;&raquo;&nbsp;后台首页
          </TD></TR></TBODY></TABLE><BR>
		<table width="100%" border="0" cellpadding="0" cellspacing="0" class="info_tb">
		<tr class="header">
          <TD>
            <DIV style="FLOAT: left; MARGIN-LEFT: 0px; PADDING-TOP: 8px"><A 
            onclick="collapse_change('tip','./images')" href="#">技巧提示</A></DIV>
            <DIV style="FLOAT: right; PADDING-BOTTOM: 9px; MARGIN-RIGHT: 4px"><A 
            onclick="collapse_change('tip','./images')" href="#">
			<IMG id=menuimg_tip src="./images/menu_reduce.gif" border=0></A></DIV></TD></TR>
		<tbody id="menu_tip"><tr><td>
		<ul><li>后台管理负责论坛的整体设置和权限、日志等的管理，对于论坛主题和帖子的管理请直接在论坛前台页面进行。</li>
			<li>版主只拥有与版块相关的部分管理功能，若有任何问题或需要超出权限的管理需求请与系统管理员联系。</li>
		</ul>
		</td></tr></tbody></table><br/>
      <A name=tb01></A>
	  <table width="100%" border="0" cellpadding="0" cellspacing="0" class="info_tb">
		<tr class="header"><td>后台管理在线用户
			<A onClick="collapse_change('tb01','./images')" href="#">
			<IMG id=menuimg_tb01 style="MARGIN-TOP: -12px; FLOAT: right; MARGIN-RIGHT: 8px" 
            src="images/menu_reduce.gif" border=0></td></tr>
        <TBODY id=menu_tb01>
		<tr><td>
<%
	UserInfo adminUser = null;
	for (int i=0; i<adminUsers.size(); i++)
	{
		adminUser = (UserInfo)adminUsers.get(i);
%>		
		&nbsp;<a href="../uspace.jsp?uid=<%= adminUser.userID %>" target="_blank" 
			title="访问 IP: <%= adminUser.remoteIP %>"><%= adminUser.userID %></a>
<%
	}
%>			
		</td></tr>
	</table><BR>
<%
	if (userinfo.groupID != 'A') {
%>		
      <A name=tb02></A>
	  <table width="100%" border="0" cellpadding="0" cellspacing="0" class="info_tb">
		<tr class="header"><td>责任版块
			<A onClick="collapse_change('tb02','./images')" href="#">
			<IMG id=menuimg_tb02 style="MARGIN-TOP: -12px; FLOAT: right; MARGIN-RIGHT: 8px" 
            src="images/menu_reduce.gif" border=0></td></tr>
        <TBODY id=menu_tb02>
		<tr><td>
<%
		if (sections != null) 
		{
			SectionVO aSection = null;
			BoardVO aBoard = null;
			String moderators = null;
			
			for (int i=0; i<sections.size(); i++)	
			{
				aSection = (SectionVO)sections.get(i);
				if (aSection.boardList != null && aSection.boardList.size() > 0)
				{
					for (int j=0; j<aSection.boardList.size(); j++)
					{
						aBoard = (BoardVO)aSection.boardList.get(j);
						if (userinfo.groupID != 'A') 
						{
							moderators = PageUtils.getModerators(aSection, aBoard);
							if (moderators.indexOf("," + userinfo.userID.toLowerCase() + ",") < 0)
								continue;
						}
%>		  
		&nbsp;<a href="../forum.jsp?sid=<%= aSection.sectionID %>&fid=<%= aBoard.boardID %>" 
				  	target="_blank"><%= aBoard.boardName %></a>
<%
					}
				}
			}
		}
%>			
		</td></tr>
	</table><BR>
<%
	}
%>			
      <A name=tb03></A>
      <TABLE class=info_tb cellSpacing=0 cellPadding=0 width="100%" border=0>
        <TBODY>
        <TR class=header>
          <TD colSpan=2>运行状况<A onClick="collapse_change('tb03','./images')" href="#"><IMG 
            id=menuimg_tb03 style="MARGIN-TOP: -12px; FLOAT: right; MARGIN-RIGHT: 8px" 
            src="images/menu_reduce.gif" border=0></A> </TD></TR>
        <TBODY id=menu_tb03>
        <TR>
          <TD class=altbg1 width="45%"><B>论坛名称:</B><BR><SPAN 
            class=smalltxt>论坛名称，将显示在导航条和标题中</SPAN></TD>
          <TD class=altbg2><%= setting.getHTMLStr(ForumSetting.BASEINFO,"forumName") %></TD></TR>
<%
	if (userinfo.groupID == 'A') {
%>		
        <TR>
          <TD class=altbg1 width="45%"><B>Java VM 最大可用内存(K字节):</B><BR><SPAN 
            class=smalltxt>Java 虚拟机最大可用的内存</SPAN></TD>
          <TD class=altbg2><%= NumberFormat.getInstance().format(Runtime.getRuntime().maxMemory()/1000) %></TD></TR>
        <TR>
          <TD class=altbg1 width="45%"><B>Java VM 总共已用内存(K字节):</B><BR><SPAN 
            class=smalltxt>Java 虚拟机当前占用的内存</SPAN></TD>
          <TD class=altbg2><%= NumberFormat.getInstance().format(Runtime.getRuntime().totalMemory()/1000) %></TD></TR>
        <TR>
          <TD class=altbg1 width="45%"><B>最大数据库连接数:</B><BR><SPAN 
            class=smalltxt>当前数据库连接池允许的最大活动连接数</SPAN></TD>
          <TD class=altbg2><%= dbManager.getConnectionsMaxActive() %></TD></TR>
        <TR>
          <TD class=altbg1 width="45%"><B>当前活动的数据库连接数( <font color="#339900">~</font> ):</B><BR><SPAN 
            class=smalltxt>当前正在使用的数据库连接数</SPAN></TD>
          <TD class=altbg2><%= dbManager.getConnectionsUsed() %></TD></TR>
        <TR>
          <TD class=altbg1 width="45%"><B>当前空闲的数据库连接数:</B><BR><SPAN 
            class=smalltxt>当前处于状态空闲的数据库连接数</SPAN></TD>
          <TD class=altbg2><%= dbManager.getConnectionsIdle() %></TD></TR>
<%
	}
%>		
        <TR>
          <TD class=altbg1 width="45%"><B>系统管理员名:</B><BR><SPAN 
            class=smalltxt>本论坛系统管理员的用户名</SPAN></TD>
          <TD class=altbg2><%= AppContext.getInstance().getAdminUser() %></TD></TR>
        <TR>
          <TD class=altbg1 width="45%"><B>管理员邮件地址:</B><BR><SPAN 
            class=smalltxt>本论坛系统管理员的邮件地址</SPAN></TD>
          <TD class=altbg2><%= setting.getAdminMailAddr() %></TD></TR>
        </TBODY></TABLE>
      </TD></TR></TBODY></TABLE><BR><BR>
<%= PageUtils.getAdminFooter(request) %>
</BODY></HTML>
