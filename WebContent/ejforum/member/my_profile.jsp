<%@ page contentType="text/html;charset=gbk" errorPage="../error.jsp"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="com.hongshee.ejforum.util.PageUtils"%>
<%@ page import="com.hongshee.ejforum.common.AppContext"%>
<%@ page import="com.hongshee.ejforum.common.CacheManager"%>
<%@ page import="com.hongshee.ejforum.common.ForumSetting"%>
<%@ page import="com.hongshee.ejforum.data.UserDAO"%>
<%@ page import="com.hongshee.ejforum.data.UserDAO.UserInfo"%>
<%@ page import="com.hongshee.ejforum.data.UserDAO.UserVO"%>
<%
	UserInfo userinfo = PageUtils.getLoginedUser(request, response);
	if (userinfo == null) return;

	String forumName = ForumSetting.getInstance().getForumName();
	String title = PageUtils.getTitle(forumName);
	String[] menus = PageUtils.getHeaderMenu(request, userinfo);
	String homeUrl = "../index.jsp";
	String forumStyle = PageUtils.getForumStyle(request, response, null);
	
	UserVO aUser = UserDAO.getInstance().getUserVO(userinfo.userID);
	if (aUser == null)
	{		
		request.setAttribute("errorMsg", "此用户名不存在或已经被删除");
		request.getRequestDispatcher("/error.jsp").forward(request, response);
		return;
	}
	if (aUser.email==null || aUser.email.length()==0)
	{
	 	if (userinfo.userID.equals(AppContext.getInstance().getAdminUser()))
		{
			aUser.email = ForumSetting.getInstance().getAdminMailAddr();
		}
	}
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<HTML xmlns="http://www.w3.org/1999/xhtml">
<HEAD>
<TITLE>编辑个人资料 - <%= title %></TITLE>
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
<DIV id=nav><A href="<%= homeUrl %>"><%= forumName %></A> &raquo;&nbsp; 编辑个人资料</DIV>
<DIV class=container><DIV class=content>
<SCRIPT type=text/javascript>
function validate(theform) {
	var email = trim(theform.email.value);
	if (email == '')
	{
		alert("请输入您的 Email");
		theform.email.focus();
		return false;
	}
	var illegalemail = !(/^[\-\.\w]+@[\.\-\w]+(\.\w+)+$/.test(email));
	if(illegalemail) 
	{
		alert("请输入有效的 Email 地址");
		theform.email.focus();
		return false;
	}
	return true;
}
</SCRIPT>
<FORM name="settings" onSubmit="return validate(this)" action="../perform.jsp?act=member_profile" method=post>
<DIV class="mainbox formbox">
<H1>编辑个人资料</H1>
<UL class="tabs">
  <LI><A href="my_pwd.jsp">修改密码</A> </LI>
  <LI class=current><A href="my_profile.jsp">基本资料</A> </LI>
  <LI><A href="my_special.jsp">个性化资料</A> </LI>
</UL>
<TABLE cellSpacing=0 cellPadding=0>
  <TBODY>
  <TR>
    <TH><LABEL for=nickname>昵称</LABEL></TH>
    <TD><INPUT id=nickname size=30 name=nickname maxlength="15"></TD></TR>
  <TR>
    <TH>性别</TH>
    <TD><INPUT class=radio type=radio value='M' name=gender id="gender[M]"> 男 &nbsp;
	    <INPUT class=radio type=radio value='F' name=gender id="gender[F]"> 女 &nbsp;
		<INPUT class=radio type=radio CHECKED value='U' name=gender id="gender[U]"> 保密 </TD></TR>
  <TR>
    <TH><LABEL for=birth>生日</LABEL></TH>
    <TD><INPUT id=birth maxlength=10 size=30 value=1970-01-01 name=birth>
		(&nbsp;格式为 yyyy-mm-dd , 年-月-日&nbsp;)
	</TD></TR>
  <TR>
    <TH><LABEL for=city >来自</LABEL></TH>
    <TD><INPUT id=city size=30 name=city maxlength="20"></TD></TR>
  <TR>
    <TH><LABEL for=webpage>个人网站</LABEL></TH>
    <TD><INPUT id=webpage size=30 name=webpage maxlength="60"></TD></TR>
  <TR>
    <TH><LABEL for=icq>QQ/MSN</LABEL></TH>
    <TD><INPUT id=icq size=30 name=icq maxlength="40"></TD></TR>
  <TR>
    <TH><LABEL for=email>Email</LABEL></TH>
    <TD><INPUT id=email size=30 name=email maxlength="40"></TD></TR>
  <TR>
    <TH></TH>
    <TD><INPUT id=isMailPub class=checkbox type=checkbox value='T' name=isMailPub> Email 地址可见 &nbsp;</TD></TR>
  <TR>
    <TH>&nbsp;</TH>
    <TD height="30"><BUTTON class=submit name=editsubmit type=submit>提交</BUTTON>
	  </TD></TR></TBODY></TABLE></DIV></FORM></DIV>
<script language="javascript">
$('nickname').value = "<%= aUser.nickname==null?"":aUser.nickname %>";
$('gender[<%= aUser.gender %>]').checked = true;
$('birth').value = "<%= aUser.birth==null?"1970-01-01":aUser.birth %>";
$('city').value = "<%= aUser.city==null?"":aUser.city %>";
$('webpage').value = "<%= aUser.webpage==null?"":aUser.webpage %>";
$('icq').value = "<%= aUser.icq==null?"":aUser.icq %>";
$('email').value = "<%= aUser.email==null?"":aUser.email %>";
$('isMailPub').checked = <%= aUser.isMailPub=='T'?"true":"false" %>;
</script>
<DIV class=side>
<DIV>
<H2>我的空间</H2>
<UL>
  <LI><H3><A href="../uspace.jsp?uid=<%= userinfo.userID %>" target="_blank">个人信息页</A></H3></LI>
  <LI class="side_on"><H3><A href="my_profile.jsp">编辑个人资料</A></H3></LI>
  <LI><H3><A href="sms_list.jsp">短消息</A></H3></LI>
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
