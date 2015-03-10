<%@ page contentType="text/html;charset=gbk" errorPage="error.jsp"%>
<%@ page import="com.hongshee.ejforum.util.PageUtils"%>
<%@ page import="com.hongshee.ejforum.common.CacheManager"%>
<%@ page import="com.hongshee.ejforum.common.ForumSetting"%>
<%@ page import="com.hongshee.ejforum.common.IConstants"%>
<%@ page import="com.hongshee.ejforum.data.UserDAO.UserInfo"%>
<%@ page import="com.hongshee.ejforum.data.GroupDAO.GroupVO"%>
<%
	String ctxPath = request.getContextPath()+"/ejforum";
	String forumName = ForumSetting.getInstance().getForumName();
	String title = PageUtils.getTitle(forumName);
	UserInfo userinfo = PageUtils.getSessionUser(request);
	String[] menus = PageUtils.getHeaderMenu(request, userinfo);
	String homeUrl = ctxPath + "/index.jsp";
	String rootPath = PageUtils.getForumURL(request);
	String forumStyle = PageUtils.getForumStyle(request, response, null);
	String rssSub = ForumSetting.getInstance().getString(ForumSetting.FUNCTIONS, "RssSub", "yes");
	boolean isShowRss = rssSub.equals("yes");

	String sPrivate = "";
    GroupVO aGroup = CacheManager.getInstance().getGroup('G');
    if (aGroup.rights.indexOf(IConstants.PERMIT_VISIT_FORUM) < 0)
		sPrivate = " (&nbsp;私密&nbsp;)";
					
	int cols = 3;
	String colWidth = String.valueOf(100 / cols) + "%";
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<HTML xmlns="http://www.w3.org/1999/xhtml">
<HEAD>
<TITLE>RSS 订阅 - <%= title %></TITLE>
<%= PageUtils.getMetas(title, null) %>
<LINK href="styles/<%= forumStyle %>/ejforum.css" type=text/css rel=stylesheet>
</HEAD>
<BODY onkeydown="if(event.keyCode==27) return false;">
<SCRIPT src="js/common.js" type=text/javascript></SCRIPT>
<DIV class=wrap>
<DIV id=header>
<%= PageUtils.getHeader(request, title) %>
<%= PageUtils.getHeadAdBanner(request, null) %>
</DIV>
<%= menus[0] %>
<DIV id=foruminfo>
<DIV id=nav><A href="<%= homeUrl %>"><%= forumName %></A> &raquo;&nbsp; RSS 订阅</DIV>
</DIV>
<DIV class=box><SPAN class=headactions>
<IMG id=tips_img onclick="toggle_collapse('tips');" src="styles/<%= forumStyle %>/images/collapsed_no.gif"></SPAN> 
<H4>订阅提示</H4>
<TABLE id=tips cellSpacing=0 cellPadding=0 class="forumlinks">
  <TBODY>
  <TR>
    <TH><a href="http://www.wisol.net.cn/wisc.jsp" style="FLOAT: right; padding-top:4px" target="_blank">
		<img src="http://www.wisol.net.cn/images/wisol_120x50.gif" alt="Wisol Reader"/></a>
	<ul style="padding-left:27px;text-align:left">
		<li>RSS 是一种对不同来源的信息进行聚合以及快速浏览的技术，使用简单、方便、快捷。</li>
		<li>本论坛的&nbsp;RSS&nbsp;内容输出方式有标题式和全文式两种，其中全文式特别适合于离线阅读器或浏览器。</li>
		<li>推荐使用&nbsp;Wisol&nbsp;Reader&nbsp;订阅本论坛的频道和频道组(OPML)，从而获得最佳的阅读效果。</li>
	</ul></TH>
  </TR></TBODY></TABLE></DIV>
<DIV class="mainbox forumlist">
	<H3><A href="./index.jsp">论坛全局</A></H3>
<TABLE id="section_all" cellSpacing=0 cellPadding=0>
	<TBODY><TR>
    <TH width="<%= colWidth %>">
      <H2><A href="<%= homeUrl %>" id="g_all_name"><%= forumName %></A></H2>
      <P style="margin-bottom:2px">包含本论坛所有版块的&nbsp;RSS&nbsp;地址列表</P>
      <P class="moderators"><IMG src="images/opml.gif" border="0" align="absmiddle">&nbsp;
	     -&nbsp; <A href="<%= rootPath %>forums-all-0.xml" target=_blank>标题式</A>&nbsp;
         -&nbsp; <A href="<%= rootPath %>forums-all-1.xml" target=_blank id="g_all_url">全文式</A>&nbsp;
		 <% if (isShowRss) { %>-&nbsp; <A href="javascript:subGroup('g_all')">订阅</A><% } %>
	  </P></TH>
    <TH width="<%= colWidth %>">
      <H2><A href="./spec_topics.jsp?spec=new" id="c_new_name"><%= forumName %>_最新发表</A></H2>
      <P style="margin-bottom:2px">包含本论坛若干个最新发表的主题<%= sPrivate %></P>
      <P class="moderators"><IMG src="images/rss.gif" border="0" align="absmiddle">&nbsp;
	     -&nbsp; <A href="<%= rootPath %>topics-new-0.xml" target=_blank>标题式</A>&nbsp;
         -&nbsp; <A href="<%= rootPath %>topics-new-1.xml" target=_blank id="c_new_url">全文式</A>&nbsp;
		 <% if (isShowRss) { %>-&nbsp; <A href="javascript:subChannel('c_new')">订阅</A><% } %>
	  </P></TH>
    <TH width="<%= colWidth %>">
      <H2><A href="./spec_topics.jsp?spec=hot" id="c_hot_name"><%= forumName %>_最新热贴</A></H2>
      <P style="margin-bottom:2px">包含本论坛若干个最新的热门主题<%= sPrivate %></P>
      <P class="moderators"><IMG src="images/rss.gif" border="0" align="absmiddle">&nbsp;
	     -&nbsp; <A href="<%= rootPath %>topics-hot-0.xml" target=_blank>标题式</A>&nbsp;
         -&nbsp; <A href="<%= rootPath %>topics-hot-1.xml" target=_blank id="c_hot_url">全文式</A>&nbsp;
		 <% if (isShowRss) { %>-&nbsp; <A href="javascript:subChannel('c_hot')">订阅</A><% } %>
	  </P></TH>
	</TR></TBODY>
</TABLE></DIV>
<%= PageUtils.getRSSFeeds(rootPath, isShowRss) %>
<DIV class=box><SPAN class=headactions><IMG id=forumlinks_img 
	 onclick="toggle_collapse('forumlinks');" src="styles/<%= forumStyle %>/images/collapsed_no.gif"></SPAN> 
<H4>友情推荐</H4>
<TABLE id=forumlinks cellSpacing=0 cellPadding=0 class="forumlinks">
  <TBODY>
  <TR>
    <TD>					
	<h5><a href="http://www.wisol.net.cn" target="_blank">万维网简</a></h5>
	<p>信息聚合、网络导航、高效快捷的RSS阅读和浏览器、轻松自然的冲浪感觉</p></TD>
  </TR></TBODY></TABLE></DIV>
</DIV>
<%= menus[1]==null?"":menus[1] %>
<%= menus[2]==null?"":menus[2] %>
<%= PageUtils.getFooter(request, forumStyle) %>
</BODY></HTML>
