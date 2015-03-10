<%@ page contentType="text/html;charset=gbk" errorPage="../error.jsp"%>
<%@ page import="com.hongshee.ejforum.util.PageUtils"%>
<%@ page import="com.hongshee.ejforum.data.UserDAO.UserInfo"%>
<%@ page import="com.hongshee.common.util.DBManager"%>
<%@ page import="com.hongshee.ejforum.common.ForumSetting"%>
<%@ page import="com.hongshee.ejforum.common.AppContext"%>
<%
	UserInfo userinfo = PageUtils.getAdminUser(request, response);
	if (userinfo == null) return;
	ForumSetting setting = ForumSetting.getInstance();
    DBManager dbManager = DBManager.getInstance();
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<HTML xmlns="http://www.w3.org/1999/xhtml"><HEAD>
<META http-equiv=Content-Type content="text/html; charset=gbk">
<LINK href="../style/admin.css" type=text/css rel=stylesheet>
<SCRIPT src="../../js/common.js" type=text/javascript></SCRIPT>
<SCRIPT src="../js/admin.js" type=text/javascript></SCRIPT>
</HEAD>
<BODY topMargin=10>
<TABLE cellSpacing=6 cellPadding=2 width="100%" border=0>
  <TBODY>
  <TR>
    <TD>
      <TABLE class=guide cellSpacing=0 cellPadding=0 width="100%" border=0>
        <TBODY>
        <TR>
          <TD><A onclick="parent.location='../index.htm'; return false;" href="#">后台管理首页</A>&nbsp;&raquo;&nbsp;运行参数
		  </TD></TR></TBODY></TABLE><BR>
	  <TABLE class=info_tb cellSpacing=0 cellPadding=0 width="100%" border=0>
        <TBODY>
        <TR class=header>
          <TD>
            <DIV style="FLOAT: left; MARGIN-LEFT: 0px; PADDING-TOP: 8px"><A 
            onclick="collapse_change('tip','../images')" href="#">技巧提示</A></DIV>
            <DIV style="FLOAT: right; PADDING-BOTTOM: 9px; MARGIN-RIGHT: 4px"><A 
            onclick="collapse_change('tip','../images')" href="#">
			<IMG id=menuimg_tip src="../images/menu_reduce.gif" border=0></A></DIV></TD></TR>
        <TBODY id=menu_tip>
        <TR>
          <TD>
            <UL><LI>此处列出的参数一般不需要修改，如果必要，请手动修改配置文件&nbsp;config.xml&nbsp;并重新启动论坛。</LI></UL>
			  </TD></TR></TBODY></TABLE><BR>
	   <A name=tb01></A>
      <TABLE class=info_tb cellSpacing=0 cellPadding=0 width="100%" border=0>
        <TBODY>
        <TR class=header>
          <TD colSpan=2>缺省配置参数<A onClick="collapse_change('tb01','../images')" 
            href="#"><IMG id=menuimg_tb01 style="MARGIN-TOP: -12px; FLOAT: right; MARGIN-RIGHT: 8px" 
            src="../images/menu_reduce.gif" border=0></A> </TD></TR>
        <TBODY id=menu_tb01>
        <TR>
          <TD class=altbg1 width="45%"><B>系统管理员名:</B><BR><SPAN 
            class=smalltxt>本论坛系统管理员的用户名</SPAN></TD>
          <TD class=altbg2><%= AppContext.getInstance().getAdminUser() %></TD></TR>
        <TR>
          <TD class=altbg1 width="45%"><B>会员列表最大页数:</B><BR><SPAN 
            class=smalltxt>会员列表中可以翻阅到的最大页数，0 为不限制</SPAN></TD>
          <TD class=altbg2><%= setting.getInt(ForumSetting.MISC,"maxMemberPages") %></TD></TR>
        <TR>
          <TD class=altbg1 width="45%"><B>会员每次登录发帖数限制:</B><BR><SPAN 
            class=smalltxt>会员每次登录后最多允许的发帖数量</SPAN></TD>
          <TD class=altbg2><%= setting.getInt(ForumSetting.MISC,"maxSessionPosts") %></TD></TR>
        <TR>
          <TD class=altbg1 width="45%"><B>收藏夹容量:</B><BR><SPAN 
            class=smalltxt>允许收藏的最大链接数，超过此容量时早期的链接将会被删除</SPAN></TD>
          <TD class=altbg2><%= setting.getInt(ForumSetting.MISC,"maxFavorites") %></TD></TR>
        <TR>
          <TD class=altbg1 width="45%"><B>短消息容量:</B><BR><SPAN 
            class=smalltxt>短消息收件箱的最大容量，超过此容量时早期的消息将会被删除</SPAN></TD>
          <TD class=altbg2><%= setting.getInt(ForumSetting.MISC,"maxShortMsgs") %></TD></TR>
        <TR>
          <TD class=altbg1 width="45%"><B>头像最大尺寸(像素):</B><BR><SPAN 
            class=smalltxt>用户头像将被缩小到此大小范围之内</SPAN></TD>
          <TD class=altbg2><%= setting.getInt(ForumSetting.MISC,"maxAvatarPixels") %></TD></TR>
		</TBODY></TABLE>
      <BR><A name=tb02></A>
      <TABLE class=info_tb cellSpacing=0 cellPadding=0 width="100%" border=0>
        <TBODY>
        <TR class=header>
          <TD colSpan=2>数据库配置<A onClick="collapse_change('tb02','../images')" href="#"><IMG 
            id=menuimg_tb02 style="MARGIN-TOP: -12px; FLOAT: right; MARGIN-RIGHT: 8px" 
            src="../images/menu_reduce.gif" border=0></A> </TD></TR>
        <TBODY id=menu_tb02>
        <TR>
          <TD class=altbg1 width="45%"><B>最大活动连接数:</B><BR><SPAN 
            class=smalltxt>当前数据库连接池允许的最大活动连接数</SPAN></TD>
          <TD class=altbg2><%= dbManager.getConnectionsMaxActive() %></TD></TR>
        <TR>
          <TD class=altbg1 width="45%"><B>最大空闲连接数:</B><BR><SPAN 
            class=smalltxt>当前数据库连接池允许的最大空闲连接数</SPAN></TD>
          <TD class=altbg2><%= dbManager.getConnectionsMaxIdle() %></TD></TR>
        <TR>
          <TD class=altbg1 width="45%"><B>最小空闲连接数:</B><BR><SPAN 
            class=smalltxt>当前数据库连接池允许的最小空闲连接数</SPAN></TD>
          <TD class=altbg2><%= dbManager.getConnectionsMinIdle() %></TD></TR>
        <TR>
          <TD class=altbg1 width="45%"><B>等待数据库连接的最大时间(毫秒):</B><BR><SPAN 
            class=smalltxt>从连接池获取连接时允许的最大等待时间</SPAN></TD>
          <TD class=altbg2><%= dbManager.getConnectionsMaxWait() %></TD></TR>
        </TBODY></TABLE>
      <BR>
	  </TD></TR></TBODY></TABLE><BR><BR>
<%= PageUtils.getAdminFooter(request) %>
</BODY></HTML>
