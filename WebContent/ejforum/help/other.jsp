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
			<A href="./index.jsp">帮助</A> &raquo;&nbsp; 其他相关问题</DIV>
<table cellpadding="0" cellspacing="0" class="helpbox">
<tr><td valign="top" width="30%">
	<h1 id="faq01">我如何切换界面风格？</h1>
	<ul style="margin: 2px auto; padding-bottom:15px"><li style="padding-left:2px">如果论坛设置许可，在论坛页面的底部右边，有一个“界面风格”菜单，访问者可以根据自己的喜好设置论坛的界面风格，此设置会一直保存在浏览器的&nbsp;Cookie&nbsp;中。
	<br/>如果某个版块已经在后台设定具有特定的界面风格，则以此风格为准。
	</li></ul>
	<h1 id="faq02">我如何使用&nbsp;RSS&nbsp;订阅？</h1>
	<ul style="margin: 2px auto; padding-bottom:15px"><li style="padding-left:2px">
	RSS&nbsp;是一种对不同来源的信息进行聚合以及快速浏览的技术。在导航栏上点击“RSS 订阅”打开论坛的&nbsp;RSS&nbsp;频道列表，本论坛提供有两种订阅方式：
	<br/>·标题式 - &nbsp;每条信息只包含论坛主题的标题、作者、发布时间等信息。
	<br/>·全文式 - &nbsp;除上述内容外，每条信息中还包含论坛主题的全文，通过使用合适的离线阅读器，您可以更快速地浏览本论坛主题。
	<br/><br/>此外，如果是使用离线阅读器比如万维网简或IE7，在打开论坛主页和版块时，其工具栏中的频道源按钮会由灰 <img src="../images/rss2.gif" align="absmiddle"> 变亮 <img src="../images/rss1.gif" align="absmiddle"> ，通过此按钮的下拉菜单即可实现&nbsp;RSS&nbsp;订阅。
	</li></ul>
	<h1 id="faq03">我如何使用搜索？</h1>
	<ul style="margin: 2px auto; padding-bottom:15px"><li style="padding-left:2px">	
	一般情况下，您可以通过论坛页面上的&nbsp;Google&nbsp;搜索框对本论坛进行搜索。
	<br/>如果&nbsp;Google&nbsp;搜索不能满足您的要求，您可以点击导航栏上面的“搜索”进入高级搜索页面，输入合适的搜索条件，就可以检索到您有权限访问的相关帖子。
	</li></ul>
	<h1 id="faq04">我的浏览器必须支持&nbsp;Cookie&nbsp;吗？</h1>
	<ul style="margin: 2px auto; padding-bottom:15px"><li style="padding-left:2px">
	是的。如果您的浏览器不支持&nbsp;Cookie&nbsp;，您将只能浏览而不能有效地登录，很多功能也会失效。
	</li></ul>
	<h1 id="faq05">论坛积分策略是怎样的？</h1>
	<ul style="margin: 2px auto; padding-bottom:15px"><li style="padding-left:2px">
	论坛的活跃用户会获得积分鼓励，积分越多的会员用户一般会享有更多的论坛权限，详情请点击这里-><a href="credits_rule.jsp">积分策略说明</a>。
	</li></ul>
	<h1 id="faq06">我还有其它问题怎么办？</h1>
	<ul style="margin: 2px auto; padding-bottom:15px"><li style="padding-left:0px">
	如果您还有任何帮助中不能解答的问题，请使用页脚的联系邮箱与我们联系。也可以通过“统计”菜单下的“管理团队”中的用户资料发送短消息给我们。
	</li></ul>
	</td>
</tr>
</table>
</DIV>
<%= menus[1]==null?"":menus[1] %>
<%= menus[2]==null?"":menus[2] %>
<%= PageUtils.getFooter(request,forumStyle) %>
</BODY></HTML>
