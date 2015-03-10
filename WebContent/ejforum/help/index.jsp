<%@ page contentType="text/html;charset=gbk" errorPage="error.jsp"%>
<%@ page import="com.hongshee.ejforum.util.PageUtils"%>
<%@ page import="com.hongshee.ejforum.common.ForumSetting"%>
<%@ page import="com.hongshee.ejforum.data.UserDAO.UserInfo"%>
<%
	ForumSetting setting = ForumSetting.getInstance();
	String forumName = setting.getForumName();
	String title = PageUtils.getTitle(forumName);
	UserInfo userinfo = PageUtils.getSessionUser(request);
	String[] menus = PageUtils.getHeaderMenu(request, userinfo);
	String homeUrl = "../index.jsp";
	String forumStyle = PageUtils.getForumStyle(request, response, null);
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<HTML xmlns="http://www.w3.org/1999/xhtml">
<HEAD>
<TITLE>帮助 - <%= title %></TITLE>
<%= PageUtils.getMetas(title, null) %>
<LINK href="../styles/<%= forumStyle %>/ejforum.css" type=text/css rel=stylesheet>
</HEAD>
<BODY onkeydown="if(event.keyCode==27) return false;">
<SCRIPT src="../js/common.js" type=text/javascript></SCRIPT>
<DIV class=wrap style="padding-bottom:5px">
<DIV id=header>
<%= PageUtils.getHeader(request, title) %>
<%= PageUtils.getHeadAdBanner(request, null) %></DIV>
<%= menus[0] %>
<DIV id=nav><A href="<%= homeUrl %>"><%= forumName %></A> &raquo;&nbsp; 帮助</DIV>
<table cellpadding="0" cellspacing="0" class="helpbox">
<tr><td valign="top" width="30%" style="border-right:none">
	<h3>用户须知</h3>
	<ul style="margin: 2px auto;">
		<li><a href="member.jsp#faq01">我必须要注册吗</a></li>
		<li><a href="member.jsp#faq02">注册后我有什么特权</a></li>
		<li><a href="member.jsp#faq03">登录有效期是什么含义</a></li>
		<li><a href="member.jsp#faq04">我如何使用个性化头像</a></li>
		<li><a href="member.jsp#faq05">我如何使用短消息功能</a></li>
		<li><a href="member.jsp#faq06">我如何使用收藏夹功能</a></li>
		<li><a href="member.jsp#faq07">我如何设置论坛好友</a></li>
	</ul>
	</td>
	<td valign="top" width="37%" style="border-right:none">
	<h3>帖子相关操作</h3>
	<ul style="margin: 2px auto;">				
		<li><a href="post.jsp#faq01">我如何发表新主题</a></li>
		<li><a href="post.jsp#faq02">我如何发表回复</a></li>
		<li><a href="post.jsp#faq03">编辑时我可以使用&nbsp;BBCode&nbsp;代码吗</a></li>
		<li><a href="post.jsp#faq04">编辑时我可以使用&nbsp;HTML&nbsp;代码吗</a></li>
		<li><a href="post.jsp#faq05">如何在帖子中插入图片或媒体</a></li>
		<li><a href="post.jsp#faq06">发帖时左下角的选项都是什么含义</a></li>
		<li><a href="post.jsp#faq07">页面跳转时编辑的内容丢失了怎么办</a></li>
		<li><a href="post.jsp#faq08">我可以修改已经发布的帖子吗</a></li>
	</ul>
	</td>
	<td valign="top" width="33%">
	<h3>其他相关问题</h3>
	<ul style="margin: 2px auto;">			
		<li><a href="other.jsp#faq01">我如何切换界面风格</a></li>
		<li><a href="other.jsp#faq02">我如何使用&nbsp;RSS&nbsp;订阅</a></li>
		<li><a href="other.jsp#faq03">我如何使用搜索</a></li>
		<li><a href="other.jsp#faq04">我的浏览器必须支持&nbsp;Cookie&nbsp;吗</a></li>
		<li><a href="credits_rule.jsp">论坛积分策略是怎样的</a></li>
		<li><a href="protocol.jsp">论坛用户守则是怎样的</a></li>
		<li><a href="other.jsp#faq06">我还有其它问题怎么办</a></li>
	</ul>
	</td>
</tr>
</table>
</DIV>
<%= menus[1]==null?"":menus[1] %>
<%= menus[2]==null?"":menus[2] %>
<%= PageUtils.getFooter(request,forumStyle) %>
</BODY></HTML>
