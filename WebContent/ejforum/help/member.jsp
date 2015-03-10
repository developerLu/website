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
<DIV id=nav><A href="<%= homeUrl %>"><%= forumName %></A> &raquo;&nbsp; 
			<A href="./index.jsp">帮助</A> &raquo;&nbsp; 用户须知</DIV>
<table cellpadding="0" cellspacing="0" class="helpbox">
<tr><td valign="top" width="30%">
	<h1 id="faq01">我必须要注册吗？</h1>
	<ul style="margin: 2px auto; padding-bottom:15px"><li style="padding-left:2px">如果您只是浏览论坛，一般不需要注册，这取决于管理员如何设置论坛的用户组权限，有些私有版块可能必须在注册成正式用户后后才能浏览。
	<br/>如果您要发新帖和回复已有帖子，一般需要注册，如果您要对自己发的帖子进行管理，则必须注册成为会员。
	<br/>强烈建议您注册，这样会得到很多以游客身份无法实现的功能。
	</li></ul>
	<h1 id="faq02">注册后我有什么特权？</h1>
	<ul style="margin: 2px auto; padding-bottom:15px"><li style="padding-left:2px">
		注册后的会员除了享有由管理员设定的发帖等权限外，还享有帖子管理、发送站内短消息、在线收藏夹、获得积分等功能。
	<br/>此外，随着积分的增长，您的会员组等级会相应增长，从而获得更多的操作权限。具体权限请查看“我的空间”下的“我的权限”列表。
	</li></ul>
	<h1 id="faq03">登录有效期是什么含义？</h1>
	<ul style="margin: 2px auto; padding-bottom:15px"><li style="padding-left:2px">	用户登录时可以选择不同的登录有效期，其中“浏览器进程”是指在浏览器保持打开的情况下，如果空闲时间不超过约30分钟，登录状态会一直有效，若浏览器关闭，则下次必须重新登录。此外，其它的选项均指在同一台电脑上，不管浏览器打开与否，在指定的时间内用户不必再次输入用户名密码就可以直接登录。<br/>如果您是在网吧等公共场所上网，建议您选择登录有效期为“浏览器进程”，否则可以选择其它选项。
	</li></ul>
	<h1 id="faq04">我如何使用个性化头像？</h1>
	<ul style="margin: 2px auto; padding-bottom:15px"><li style="padding-left:2px">	在登录后导航栏上“我的空间”下的“编辑个人资料”-“个性化资料”，有一个“头像”的选项，可以使用论坛自带的头像或者自定义的头像（需要权限许可）。
	</li></ul>
	<h1 id="faq05">我如何使用短消息功能？</h1>
	<ul style="margin: 2px auto; padding-bottom:15px"><li style="padding-left:2px">
		短消息是论坛上的注册用户之间及管理员和会员之间进行通信的一种方式。登录点击导航栏上的短消息按钮，即可进入短消息管理。
	<br/>类似于电子邮件，短消息有收件箱和发件箱，以及回复和转发等功能。发送短消息时请使用用户名而不是昵称。
	<br/>短消息收件箱有一定的容量限制，超过容量限制时系统将会自动删除较早的记录。
	</li></ul>
	<h1 id="faq06">我如何使用收藏夹功能？</h1>
	<ul style="margin: 2px auto; padding-bottom:15px"><li style="padding-left:2px">
		在登录后导航栏上“我的空间”下的“我的收藏”，是一个在线收藏夹，此收藏夹不仅可以收藏本论坛下的主题链接，也可以收藏任何 Internet 网址。
	<br/>在论坛每一个主题页的右上角有一个“收藏”按钮，点击此按钮可以直接将此主题添加到在线收藏夹中。
	</li></ul>
	<h1 id="faq07">我如何设置论坛好友？</h1>
	<ul style="margin: 2px auto; padding-bottom:15px"><li style="padding-left:2px">
		在登录后导航栏上“我的空间”下的“我的好友”，是一个好友名单列表，用于记录您的好友信息。
	<br/>在论坛每一个帖子左边的作者信息栏，点击“加为好友”可以直接将此作者添加到您的好友列表中。
	</li></ul>
	</td>
</tr>
</table>
</DIV>
<%= menus[1]==null?"":menus[1] %>
<%= menus[2]==null?"":menus[2] %>
<%= PageUtils.getFooter(request,forumStyle) %>
</BODY></HTML>
