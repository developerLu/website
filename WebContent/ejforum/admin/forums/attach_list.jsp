<%@ page contentType="text/html;charset=gbk" errorPage="../error.jsp"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="java.util.HashMap"%>
<%@ page import="com.hongshee.ejforum.util.PageUtils"%>
<%@ page import="com.hongshee.ejforum.util.AppUtils"%>
<%@ page import="com.hongshee.ejforum.data.UserDAO.UserInfo"%>
<%@ page import="com.hongshee.ejforum.data.AttachDAO"%>
<%
	UserInfo userinfo = PageUtils.getAdminUser(request, response);
	if (userinfo == null) return;
	
	String strPageNo = request.getParameter("page");
    int pageNo = PageUtils.getPageNo(strPageNo);
	
	Object[] result = AttachDAO.getInstance().searchAttach(request, pageNo);
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<HTML xmlns="http://www.w3.org/1999/xhtml"><HEAD>
<META http-equiv=Content-Type content="text/html; charset=gbk">
<LINK href="../style/admin.css" type=text/css rel=stylesheet>
<SCRIPT src="../../js/common.js" type=text/javascript></SCRIPT>
<SCRIPT src="../js/admin.js" type=text/javascript></SCRIPT>
</HEAD>
<BODY topMargin=10>
<TABLE cellSpacing=6 cellPadding=2 width="100%" border=0>
  <TBODY>
  <TR>
    <TD>
      <TABLE class=guide cellSpacing=0 cellPadding=0 width="100%" border=0>
        <TBODY>
        <TR>
          <TD><A onclick="parent.location='../index.htm'; return false;" 
            href="#">后台管理首页</A>&nbsp;&raquo;&nbsp;附件查询</TD></TR>
	  </TBODY></TABLE><BR>
	<FORM id="frmsearch" name="frmsearch" action="./attach_list.jsp" method=post>
		<input type="hidden" name="page" value="<%= pageNo %>">
	  <%= PageUtils.getQueryFields(request) %></FORM>
<%
	if (result != null && result[0] != null)
	{
%>	  
	<%= result[0] %>
<%
	}
%>
      <TABLE class=info_tb cellSpacing=0 cellPadding=0 width="100%" border=0>
        <TBODY>
        <TR class=header>
          <TD width="15%">附件名</TD>
          <TD width="25%">文件名</TD>
          <TD width="10%">用户名</TD>
          <TD width="23%">所在主题</TD>
          <TD width="10%">尺寸(字节)</TD>
          <TD width="9%">所需积分</TD>
          <TD width="8%">下载</TD></TR>
<%
	if (result != null && result[1] != null)
	{
		ArrayList logList = (ArrayList)result[1];
		HashMap record = null;
		String userID = null;
		String topicTitle = null;
		String replyID = null;
		String uploadPath = request.getContextPath() + "/upload/";
		
		for (int i=0; i<logList.size(); i++)
		{
			record = (HashMap)logList.get(i);
			userID = (String)record.get("USERID");
			topicTitle = (String)record.get("TOPICTITLE");
			replyID = (String)record.get("REPLYID");
			if (replyID != null && !replyID.equals("0"))
				topicTitle = topicTitle + " (回帖ID:" + replyID + ")";
%>	  
        <TR align=middle>
          <TD class=altbg1><b><%= (String)record.get("FILENAME") %></b><br/><%= (String)record.get("TITLE") %></TD>
          <TD class=altbg2><a href="<%= uploadPath + (String)record.get("LOCALNAME") %>" 
		  		class="smalltxt" target="_blank"><%= (String)record.get("LOCALNAME") %></a></TD>
          <TD class=altbg1><%= userID.length()==0?"游客":userID %></TD>
          <TD class=altbg2>
		  	<A href="../../topic.jsp?fid=<%= (String)record.get("BOARDID") %>&tid=<%= (String)record.get("TOPICID") %>" 
               target=_blank><%= topicTitle %></A></TD>
          <TD class=altbg1><%= (String)record.get("FILESIZE") %></TD>
          <TD class=altbg2><%= (String)record.get("CREDITS") %></TD>
          <TD class=altbg1><%= (String)record.get("DOWNLOADS") %></TD></TR>
<%
		}
	}
%>		  
	</TBODY></TABLE>
<%
	if (result != null && result[0] != null)
	{
%>	  
	<%= result[0] %>
<%
	}
%>
</TD></TR></TBODY></TABLE><BR><BR>
<script language="javascript">
function viewPage(pageno)
{
	frmsearch.page.value = pageno;
	frmsearch.submit();
}
</script>	  
<%= PageUtils.getAdminFooter(request) %>
</BODY></HTML>
