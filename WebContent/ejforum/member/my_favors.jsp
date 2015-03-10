<%@ page contentType="text/html;charset=gbk" errorPage="../error.jsp"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="com.hongshee.ejforum.util.PageUtils"%>
<%@ page import="com.hongshee.ejforum.common.CacheManager"%>
<%@ page import="com.hongshee.ejforum.common.ForumSetting"%>
<%@ page import="com.hongshee.ejforum.data.UserDAO.UserInfo"%>
<%@ page import="com.hongshee.ejforum.data.BookmarkDAO"%>
<%@ page import="com.hongshee.ejforum.data.BookmarkDAO.BookmarkVO"%>
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
		BookmarkDAO.getInstance().deleteBookmarks(request);
	}
	
	String strPageNo = request.getParameter("page");
	int pageNo = PageUtils.getPageNo(strPageNo);
	int pageRows = 10;

	Object[] result = BookmarkDAO.getInstance().getBookmarks(userinfo.userID, pageNo, pageRows);
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<HTML xmlns="http://www.w3.org/1999/xhtml">
<HEAD>
<TITLE>我的收藏 - <%= title %></TITLE>
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
<DIV id=nav><A href="<%= homeUrl %>"><%= forumName %></A> &raquo;&nbsp; 我的收藏</DIV>
<DIV class=container><DIV class=content>
<FORM name="myform" onSubmit="return validate(this)" action="./my_favors.jsp?mod=del" method=post>
<DIV class=mainbox style="padding-bottom:5px">
<H1>我的收藏</H1>
<UL class="tabs headertabs">
  <LI class="additem"><A href="my_addfavor.jsp">添加收藏</A> </LI>
  <LI class="current"><A href="my_favors.jsp">我的收藏夹</A> </LI></UL>
<TABLE cellSpacing=0 cellPadding=0 width="100%">
  <THEAD>
  <TR>
    <TD class=selector>&nbsp;</TD>
    <TD>标题</TD>
    <TD width="120">所属版块&nbsp;/&nbsp;网站</TD>
    <TD class=time>创建时间</TD></TR></THEAD>
  <TBODY>
<%
	if (result != null && result[1] != null)
	{
		ArrayList markList = (ArrayList)result[1];
		BookmarkVO aMark = null;
	
		for (int i=0; i<markList.size(); i++)
		{
			aMark = (BookmarkVO)markList.get(i);
%>  
  <TR>
    <TD><INPUT class=checkbox type=checkbox value="<%= aMark.markID %>" name=markID></TD>
    <TD><A href="<%= aMark.url %>" target=_blank><%= aMark.title %></A></TD>
    <TD><%= aMark.boardName %></TD>
    <TD><%= aMark.createTime %></TD>
	</TR>
<%
		}
	}
	else
	{
%>	
  <TR>
    <TD colspan="4">没有记录</TD></TR>
<%
	}
%>
</TBODY></TABLE>
<DIV class="management"><LABEL><INPUT class=checkbox id=chkall onclick=checkall(this.form) 
	type=checkbox name=chkall> 全选</LABEL><BUTTON name=delfavors type=submit>删除</BUTTON></DIV>
</DIV></FORM>
<DIV class=pages_btns>
<%
	if (result != null && result[0] != null)
	{
%>	  
	<%= result[0] %>
<SCRIPT type=text/javascript>
var myUrl = "./my_favors.jsp?act=view";
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
		if (typeof(theform.markID) != "undefined")
		{
			if (typeof(theform.markID.length) != "undefined")
			{
				for (i=0; i<theform.markID.length; i++){
					if (theform.markID[i].checked){
						hasCheckedID = true;
						break;
					}
				}
			}
			else if (theform.markID.checked)
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
  <LI class="side_on"><H3><A href="my_favors.jsp">我的收藏</A></H3></LI>
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
