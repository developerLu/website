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
			<A href="./index.jsp">帮助</A> &raquo;&nbsp; 帖子相关操作</DIV>
<table cellpadding="0" cellspacing="0" class="helpbox">
<tr><td valign="top" width="30%">
	<h1 id="faq01">我如何发表新主题？</h1>
	<ul style="margin: 2px auto; padding-bottom:15px"><li style="padding-left:2px">在版块主题列表或主题页，点“新帖”按钮，或其下拉菜单中的“发新话题”或“发布悬赏”，如果有权限，即可进入发帖编辑页面。如果是游客一般需要先登录。
	</li></ul>
	<h1 id="faq02">我如何发表回复？</h1>
	<ul style="margin: 2px auto; padding-bottom:15px"><li style="padding-left:2px">
在版块主题页，点“回复”按钮可以对主题进行回复，或点击帖子右下角的“回复”或“引用”对回帖进行回复，如果有权限，即可进入发帖编辑页面。<br/>如果是游客一般需要先登录。
	</li></ul>
	<h1 id="faq03">编辑时我可以使用&nbsp;BBCode&nbsp;代码吗？</h1>
	<ul style="margin: 2px auto; padding-bottom:15px"><li style="padding-left:2px">
	BBCode&nbsp;代码是一种专用于论坛的&nbsp;HTML&nbsp;的特别语法，使用 [ and ] 而不使用 < and > 标签以方便编辑和保证论坛的安全。由于&nbsp;BBCode&nbsp;最终都会转化为&nbsp;HTML&nbsp;代码，本论坛仅在权限许可的情况下支持如下&nbsp;BBCode&nbsp;: [img], [media], 其它情况下均直接采用&nbsp;HTML&nbsp;代码。<br>
	[img] 语法: &nbsp;[img="url"]图片描述文字[/img]<br>
	[media] 语法: &nbsp;[media="url"]宽,高[/media]
	</li></ul>
	<h1 id="faq04">编辑时我可以使用&nbsp;HTML&nbsp;代码吗？</h1>
	<ul style="margin: 2px auto; padding-bottom:15px"><li style="padding-left:2px">
		一般情况下您应使用可视化编辑器编辑帖子，系统会自动产生相应的&nbsp;HTML&nbsp;代码。您可以手动编辑&nbsp;HTML&nbsp;代码，比如换行、删除字符等，但不能插入英文字符，不能使用诸如&lt;script&gt;, &lt;object&gt;等复杂的标记，除非您拥有使用&nbsp;HTML&nbsp;的特权。HTML&nbsp;代码模式仅是辅助性的编辑模式，在此模式下工具栏按钮和插入附件等操作均无效。
	</li></ul>
	<h1 id="faq05">如何在帖子中插入图片或媒体？</h1>
	<ul style="margin: 2px auto; padding-bottom:15px"><li style="padding-left:2px">
		可以在帖子中插入两种形式的图片或&nbsp;Flash&nbsp;等多媒体对象（可以由&nbsp;Flash Player&nbsp;或&nbsp;Windows Media Player&nbsp;播放）:
	<br/>1. 其它网站上的图片或多媒体文件链接 - &nbsp;在编辑工具栏中点击插入图片或多媒体的按钮，然后输入网址等参数即可。
	<br/>2. 用户本地的图片或多媒体文件 - &nbsp;首先需要在上传附件列表中选择本地的图片或媒体文件，然后点击随文件名称出现的“插入帖内”链接，则文件上传后会同时插入帖子中。
	</li></ul>
	<h1 id="faq06">发帖时左下角的选项都是什么含义？</h1>
	<ul style="margin: 2px auto; padding-bottom:15px"><li style="padding-left:0px">
		·禁用BBCode代码 - &nbsp;禁止解析帖子中的&nbsp;BBCode&nbsp;代码。
	<br/>·使用匿名发帖 - &nbsp;在帖子列表中不显示作者名称，但在作者个人空间和后台均可以查看到此帖（需要权限许可）。
	<br/>·接收新回复邮件通知 - &nbsp;如果有人回复您发表的主题，系统会自动向您发送一封邮件通知。
	<br/>·主题置顶 - &nbsp;直接将所要发表的主题在所在的版块置顶（需要权限许可）。
	</li></ul>
	<h1 id="faq07">页面跳转时编辑的内容丢失了怎么办？</h1>
	<ul style="margin: 2px auto; padding-bottom:15px"><li style="padding-left:2px">
帖子编辑页面在跳转到其它页面时系统会自动保存正在编辑的内容在缓存中，只要浏览器没有关闭，回到编辑页面后，点击右下角的“恢复上次自动保存的数据”，就可以从缓存中找回您刚才的编辑内容。
	</li></ul>
	<h1 id="faq08">我可以修改已经发布的帖子吗？</h1>
	<ul style="margin: 2px auto; padding-bottom:15px"><li style="padding-left:2px">可以，注册用户在发布帖子后的三天时间内可以维护自己发布的帖子，包括修改、移动到其它版块等操作，但已经加为精华的主题不能再修改和移动，已经关闭的主题下的帖子均不能再修改。
	</li></ul>
	</td>
</tr>
</table>
</DIV>
<%= menus[1]==null?"":menus[1] %>
<%= menus[2]==null?"":menus[2] %>
<%= PageUtils.getFooter(request,forumStyle) %>
</BODY></HTML>
