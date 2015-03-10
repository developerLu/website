<%@ page contentType="text/html;charset=gbk" errorPage="../error.jsp"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="com.hongshee.ejforum.util.PageUtils"%>
<%@ page import="com.hongshee.ejforum.common.ForumSetting"%>
<%@ page import="com.hongshee.ejforum.data.UserDAO.UserInfo"%>
<%@ page import="com.hongshee.ejforum.data.ShortMsgDAO"%>
<%@ page import="com.hongshee.ejforum.data.ShortMsgDAO.ShortMsgVO"%>
<%
	UserInfo userinfo = PageUtils.getLoginedUser(request, response);
	if (userinfo == null) return;

	String forumName = ForumSetting.getInstance().getForumName();
	String title = PageUtils.getTitle(forumName);
	String[] menus = PageUtils.getHeaderMenu(request, userinfo);
	String homeUrl = "../index.jsp";
	String forumStyle = PageUtils.getForumStyle(request, response, null);
	
	String subject = null;
	String message = null;
	String toUser = null;
	
	String act = request.getParameter("act");
	if (act != null)
	{
		String msgID = PageUtils.getParam(request,"mid");
		if (msgID.length() > 0)
		{
			ShortMsgVO msgVO = ShortMsgDAO.getInstance().getShortMsg(msgID);
			if (msgVO != null)
			{
				if (act.equals("reply"))
				{
					toUser = msgVO.fromUser;
					subject = "Re: " + msgVO.title;
					subject = subject.replace("\"","&quot;");
				}
				else if (act.equals("forward"))
				{
					subject = "Fw: " + msgVO.title;
					subject = subject.replace("\"","&quot;");

					StringBuilder sbuf = new StringBuilder();
					sbuf.append(msgVO.createTime).append("&nbsp;").append(msgVO.fromUser).append("&nbsp;给&nbsp;")
					    .append(msgVO.userID).append(" 发送短消息如下：\n").append(msgVO.message);
					message = sbuf.toString();
				}
			}
		}
	}
	if (toUser == null)
	{
		toUser = PageUtils.getParam(request, "uid");
	}
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<HTML xmlns="http://www.w3.org/1999/xhtml">
<HEAD>
<TITLE>短消息 - <%= title %></TITLE>
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
<SCRIPT src="../js/viewthread.js" type=text/javascript></SCRIPT>
<SCRIPT type=text/javascript>zoomstatus = parseInt(1);</SCRIPT>
<DIV id=nav><A href="<%= homeUrl %>"><%= forumName %></A> &raquo;&nbsp; 短消息</DIV>
<DIV class=container><DIV class=content>
<FORM name="smsform" onSubmit="return validate(this)" action="../perform.jsp?act=member_sms_compose" method=post>
<DIV class="mainbox formbox">
<H1>发送短消息</H1>
<UL class=tabs>
  <LI class="current additem"><A href="sms_compose.jsp">发送短消息</A> </LI>
  <LI><A href="sms_list.jsp?act=inbox">收件箱[<SPAN id=pm_unread><%= userinfo.unreadSMs %></SPAN>]</A> </LI>
  <LI><A href="sms_list.jsp?act=outbox">已发送</A> </LI>
</UL>
<TABLE cellSpacing=0 cellPadding=0>
  <TBODY>
  <TR>
    <TH><LABEL for=users>发送到</LABEL></TH>
    <TD><INPUT id=users tabIndex=2 size=65 name=users maxlength="100" value="<%= toUser==null?"":toUser %>">
		&nbsp;(多个用户名之间以逗号","分隔)</TD></TR>
  <TR>
    <TH><LABEL for=subject>标题</LABEL></TH>
    <TD><INPUT id=subject tabIndex=4 size=65 name=subject maxlength="100" value="<%= subject==null?"":subject %>"></TD></TR>
  <TR>
    <TH vAlign=top><LABEL for=message>内容</LABEL><BR/>(200 个字以内)</TH>
    <TD>
		<TEXTAREA id=message style="WIDTH: 85%" tabIndex=5 name=message rows=8><%= message==null?"":message %></TEXTAREA> 
    </TD></TR>
  <TR>
    <TH></TH>
    <TD><input type="checkbox" name="sendmail" value="yes" tabindex="6"/> 同时发送到 Email 邮箱</TD></TR>
  <TR>
    <TH><LABEL for=verifycode>验证码</LABEL></TH>
    <TD>
      <DIV id=verifycodeimage style="margin-bottom:3px"></DIV>
	  <INPUT id=verifycode name=verifycode tabIndex=8 maxLength=4 size=15>
	  <SPAN id=checkverifycode></SPAN></TD>
  </TR>
  <TR class=btns>
    <TH>&nbsp;</TH>
    <TD height="30"><BUTTON class=submit id=postsubmit tabIndex=7 name=smssubmit type=submit>提交</BUTTON> 
  </TD></TR></TBODY></TABLE></DIV></FORM>
<SCRIPT src="../js/member.js" type=text/javascript></SCRIPT>
<SCRIPT type=text/javascript>
msgs['post_vcode_empty'] = '请输入验证码';
var verifycode_invalid = '验证码输入错误，请重新填写';
$('verifycodeimage').innerHTML = '<img width="112" height="42" src="../vcode" class="absmiddle"/>';
function validate(theform) {
	if (trim(theform.users.value) == '') {
		alert("请输入发送消息的目的用户名。");
		theform.users.focus();
		return false;
	}
	if (trim(theform.subject.value) == '' || trim(theform.message.value) == '') {
		alert("请输入标题和内容。");
		theform.subject.focus();
		return false;
	}
	if (theform.subject.value.length > 100) {
		alert("您的标题超过 100 个字符的限制。");
		theform.subject.focus();
		return false;
	}
	if (theform.message.value.length > 200) {
		alert("您的消息内容超过 200 个字符的限制。");
		theform.message.focus();
		return false;
	}
	if (trim($('verifycode').value) == '')
	{
		warning($('checkverifycode'), msgs['post_vcode_empty']);
		theform.verifycode.focus();
		return false;
	}
	if (!checkverifycode())
	{
		theform.verifycode.focus();
		return false;
	}
	return true;
}
</SCRIPT>
</DIV>
<DIV class=side>
<DIV>
<H2>我的空间</H2>
<UL>
  <LI><H3><A href="../uspace.jsp?uid=<%= userinfo.userID %>" target="_blank">个人信息页</A></H3></LI>
  <LI><H3><A href="my_profile.jsp">编辑个人资料</A></H3></LI>
  <LI class="side_on"><H3><A href="sms_list.jsp">短消息</A></H3></LI>
  <LI><H3><A href="my_topics.jsp">我的话题</A></H3></LI>
  <LI><H3><A href="my_favors.jsp">我的收藏</A></H3></LI>
  <LI><H3><A href="my_friends.jsp">我的好友</A></H3></LI>
  <LI><H3><A href="my_rights.jsp">我的权限</A></H3></LI>
  <LI><H3><A href="my_credits.jsp">积分交易记录</A></H3></LI>
</UL>
</DIV>
<DIV>
<H2>积分概况</H2>
<UL class="credits">
  <LI>积分: <%= userinfo.credits %></LI>
  <LI>帖子: <%= userinfo.posts %></LI>
</UL></DIV></DIV></DIV></DIV>
<%= menus[1]==null?"":menus[1] %>
<%= menus[2]==null?"":menus[2] %>
<%= PageUtils.getFooter(request,forumStyle) %>
</BODY></HTML>
