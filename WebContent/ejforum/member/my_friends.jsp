<%@ page contentType="text/html;charset=gbk" errorPage="../error.jsp"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="com.hongshee.ejforum.util.PageUtils"%>
<%@ page import="com.hongshee.ejforum.common.CacheManager"%>
<%@ page import="com.hongshee.ejforum.common.ForumSetting"%>
<%@ page import="com.hongshee.ejforum.data.UserDAO.UserInfo"%>
<%@ page import="com.hongshee.ejforum.data.FriendDAO"%>
<%@ page import="com.hongshee.ejforum.data.FriendDAO.FriendVO"%>
<%
	UserInfo userinfo = PageUtils.getLoginedUser(request, response);
	if (userinfo == null) return;

	String forumName = ForumSetting.getInstance().getForumName();
	String title = PageUtils.getTitle(forumName);
	String[] menus = PageUtils.getHeaderMenu(request, userinfo);
	String homeUrl = "../index.jsp";
	String forumStyle = PageUtils.getForumStyle(request, response, null);
	
	String mod = request.getParameter("mod");
	if (mod != null && mod.equals("del"))
	{
		FriendDAO.getInstance().deleteFriends(request, userinfo);
	}
	
	String strPageNo = request.getParameter("page");
	int pageNo = PageUtils.getPageNo(strPageNo);
	int pageRows = 10;

	Object[] result = FriendDAO.getInstance().getFriends(userinfo.userID, pageNo, pageRows);
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<HTML xmlns="http://www.w3.org/1999/xhtml">
<HEAD>
<TITLE>我的好友 - <%= title %></TITLE>
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
<DIV id=nav><A href="<%= homeUrl %>"><%= forumName %></A> &raquo;&nbsp; 我的好友</DIV>
<DIV class=container><DIV class=content>
<FORM name="myform" onSubmit="return validate(this)" action="./my_friends.jsp?mod=del" method=post>
<DIV class=mainbox style="padding-bottom:5px">
<H1>我的好友</H1>
<UL class="tabs headertabs">
  <LI class="additem"><A href="my_addfriend.jsp">添加好友</A> </LI>
  <LI class="current"><A href="my_friends.jsp">我的好友</A> </LI></UL>
<TABLE cellSpacing=0 cellPadding=0 width="100%">
  <THEAD>
  <TR>
    <TD class=selector>&nbsp;</TD>
    <TD>用户名</TD>
    <TD width="120">昵称</TD>
    <TD width="120">备注</TD>
    <TD class=time>加入时间</TD></TR></THEAD>
  <TBODY>
<%
	if (result != null && result[1] != null)
	{
		ArrayList friendList = (ArrayList)result[1];
		FriendVO aFriend = null;
	
		for (int i=0; i<friendList.size(); i++)
		{
			aFriend = (FriendVO)friendList.get(i);
%>  
  <TR>
    <TD><INPUT class=checkbox type=checkbox value="<%= aFriend.friendID %>" name=friendID></TD>
    <TD><A href="../uspace.jsp?uid=<%= aFriend.friendID %>" target=_blank><%= aFriend.friendID %></A></TD>
    <TD><%= aFriend.nickname %></TD>
    <TD><%= aFriend.remark %></TD>
    <TD><%= aFriend.createTime %></TD>
	</TR>
<%
		}
	}
	else
	{
%>	
  <TR>
    <TD colspan="5">没有记录</TD></TR>
<%
	}
%>
</TBODY></TABLE>
<DIV class="management"><LABEL><INPUT class=checkbox id=chkall onclick=checkall(this.form) 
	type=checkbox name=chkall> 全选</LABEL><BUTTON name=delfriends type=submit>删除</BUTTON></DIV>
</DIV></FORM>
<DIV class=pages_btns>
<%
	if (result != null && result[0] != null)
	{
%>	  
	<%= result[0] %>
<SCRIPT type=text/javascript>
var myUrl = "./my_friends.jsp?act=view";
function viewPage(pageno)
{
	window.location = myUrl + "&page=" + pageno;
}
</SCRIPT>
<%
	}
%>
</DIV>
<SCRIPT type=text/javascript>
	function validate(theform) 
	{
		var hasCheckedID = false;
		if (typeof(theform.friendID) != "undefined")
		{
			if (typeof(theform.friendID.length) != "undefined")
			{
				for (i=0; i<theform.friendID.length; i++){
					if (theform.friendID[i].checked){
						hasCheckedID = true;
						break;
					}
				}
			}
			else if (theform.friendID.checked)
				hasCheckedID = true;
		}
		if (!hasCheckedID){
			alert("请至少选中一条记录");
			return false;
		}
		theform.submit();
	}
</SCRIPT>
</DIV>
<DIV class=side>
<DIV>
<H2>我的空间</H2>
<UL>
  <LI><H3><A href="../uspace.jsp?uid=<%= userinfo.userID %>" target="_blank">个人信息页</A></H3></LI>
  <LI><H3><A href="my_profile.jsp">编辑个人资料</A></H3></LI>
  <LI><H3><A href="sms_list.jsp">短消息</A></H3></LI>
  <LI><H3><A href="my_topics.jsp">我的话题</A></H3></LI>
  <LI><H3><A href="my_favors.jsp">我的收藏</A></H3></LI>
  <LI class="side_on"><H3><A href="my_friends.jsp">我的好友</A></H3></LI>
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
