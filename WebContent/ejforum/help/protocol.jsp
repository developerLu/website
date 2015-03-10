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
			<A href="./index.jsp">帮助</A> &raquo;&nbsp; 论坛用户守则</DIV>
<table cellpadding="0" cellspacing="0" class="helpbox">
<tr><td valign="top" width="30%">
	<h1 id="faq01">论坛用户守则</h1>
	<ul style="margin: 2px auto; padding-bottom:15px">
	<li style="padding-left:2px">一、论坛基本守则</li>
	<li style="padding-left:12px">
		1. 不得发表、传播违反中华人民共和国宪法和法律的言论。<br/>
		2. 不得发表、传播造谣、诽谤、侮辱他人的言论。<br/>
		3. 不得发表、传播暴力、色情、迷信的言论。<br/>
		4. 不得泄露国家机密。<br/>
		5. 不得发表恶意灌水文章或张贴垃圾信息。<br/>
		6. 不得发表与版区主题无关的文章或垃圾广告信息。<br/>
		7. 用户发表的作品仅代表其个人观点，概与本站无关。<br/><br/></li>
	<li style="padding-left:2px">二、论坛处罚办法</li>
	<li style="padding-left:12px">
		1. 对于违反以上规定的文章，在不需要解释的情况下，版主和工作人员有权转贴或删除当前文章。<br/>
		2. 本论坛有权对部分特殊文字进行过滤处理。<br/>
	    3. 违反规定情节严重者，工作人员有权屏蔽用户在论坛的发言权；情节特别严重者，本站保留屏蔽其IP的权利。<br/> 
        4. 如有违反国家法律、法规的行为，将配合公安等司法机关追究其法律责任。<br/><br/></li>
	<li style="padding-left:2px">三、法律责任</li>
	<li style="padding-left:12px">
	    1. 未经本站授权许可，任何人不得以任何形式对本站内容复制、转载、传播、摘编、出版、发行、建立镜像等。<br/>
        2. 用户在论坛发表其依法享有著作权的作品，均表示其授权委托本站对外声明：未经本站或作者许可，任何第三方不得对该作品进行转载、传播、摘编、出版、复制发行等。<br/>
        3. 用户对其发表、传播的作品的合法性等负责，用户因其作品引起的侵害他人版权等任何纠纷，概与本站无关。<br/> 
        4. 本站有权在必要时修改论坛的服务内容，同时保留修改或中断服务而不需事先通知用户的权利。<br/>
        5. 本守则的最终解释权归本站所有。<br/></li>
	</ul>
	</td>
</tr>
</table>
</DIV>
<%= menus[1]==null?"":menus[1] %>
<%= menus[2]==null?"":menus[2] %>
<%= PageUtils.getFooter(request,forumStyle) %>
</BODY></HTML>
