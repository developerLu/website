<%@ page contentType="text/html;charset=gbk" errorPage="../error.jsp"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="java.util.HashMap"%>
<%@ page import="com.hongshee.ejforum.util.PageUtils"%>
<%@ page import="com.hongshee.ejforum.util.AppUtils"%>
<%@ page import="com.hongshee.ejforum.data.UserDAO.UserInfo"%>
<%@ page import="com.hongshee.ejforum.data.ActionLogDAO"%>
<%
	UserInfo userinfo = PageUtils.getAdminUser(request, response);
	if (userinfo == null) return;
	
	String resultCount = request.getParameter("resultCount");
	if (resultCount == null || resultCount.trim().length() == 0)
		resultCount = "20";

	String pageno = request.getParameter("page");
    if (pageno == null || pageno.equals(""))
    {
        pageno = "1";
    }
	
	Object[] result = null;
	String reason = request.getParameter("reason");
	if (reason == null)
	{
		result = ActionLogDAO.getInstance().getLogList("censor", reason, pageno, resultCount);
		reason = "*{CHECK}*";
	}
	else
	{
    	reason = PageUtils.getHTMLParam(request, "reason");
		result = ActionLogDAO.getInstance().getLogList("censor", reason, pageno, resultCount);
	}
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
            href="#">后台管理首页</A>&nbsp;&raquo;&nbsp;词语过滤记录</TD></TR></TBODY></TABLE><BR>
	<FORM id="frmsearch" name="frmsearch" onSubmit="checkfields(this); return false;" action="./log_censor.jsp" method=post>
	<input type="hidden" name="page" value="<%= pageno %>">
      <TABLE class=info_tb cellSpacing=0 cellPadding=0 width="100%" border=0>
        <TBODY>
        <TR class=header>
          <TD colSpan=3>词语过滤记录&nbsp;-&nbsp; 过滤条件</TD></TR>
		<TR class="altbg2"><TD width="25%">每页显示记录数量:</TD>
			<TD width="55%"><input type="text" name="resultCount" size="50" maxlength="3" value="20"></TD>
			<TD width="20%"><input class="button" type="submit" value="提 交"></TD></TR>
		<TR class="altbg2"><TD width="25%">原因(可使用通配符 *):</TD>
			<TD width="55%"><input type="text" name="reason" size="50" maxlength="20" value="*{CHECK}*"></TD>
			<TD width="20%"><input class="button" type="submit" value="提 交"></TD></TR>
        </TBODY></TABLE><BR>
	  </FORM>
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
          <TD width="12%">用户名</TD>
          <TD width="15%">时间</TD>
          <TD width="15%">版块</TD>
          <TD width="40%">标题</TD>
          <TD width="18%">原因</TD></TR>
<%
	if (result != null && result[1] != null)
	{
		ArrayList logList = (ArrayList)result[1];
		HashMap record = null;
		String userID = null;
		String topicURL = null;
		String topicTitle = null;
		String replyID = null;
		StringBuilder sbuf = new StringBuilder();
		
		for (int i=0; i<logList.size(); i++)
		{
			record = (HashMap)logList.get(i);
			userID = (String)record.get("USERID");
			replyID = (String)record.get("REPLYID");
			topicTitle = (String)record.get("TOPICTITLE");

			sbuf.setLength(0);
			sbuf.append("../../topic.jsp?fid=").append((String)record.get("BOARDID")).append("&tid=")
			    .append((String)record.get("TOPICID"));
			
			if (replyID != null && !replyID.equals("0"))
			{
				sbuf.append("&rid=").append(replyID).append("#rid").append(replyID);
				topicTitle = topicTitle + " (RID:" + replyID + ")";
			}
			topicURL = sbuf.toString();
%>	  
        <TR align=middle>
          <TD class=altbg1>
		  	<A href="../../uspace.jsp?uid=<%= userID %>" 
			   target=_blank><%= userID.length()==0?"游客":userID %></A></TD>
          <TD class=altbg2><%= AppUtils.formatSQLTimeStr((String)record.get("CREATETIME")) %></TD>
          <TD class=altbg1><A href="../../forum.jsp?fid=<%= (String)record.get("BOARDID") %>" 
                target=_blank><%= (String)record.get("BOARDNAME") %></A></TD>
          <TD class=altbg2>
		  	<A href="<%= topicURL %>" target=_blank><%= topicTitle %></A></TD>
          <TD class=altbg1><%= (String)record.get("REASON") %>&nbsp;</TD>
		</TR>
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
function checkfields(theform) {
    var filter = /^\d+$/;
    if (!filter.test(trim(theform.resultCount.value))) {
    	alert('每页显示记录数量必须为整数');
      	theform.resultCount.focus();
		return;
    }
	theform.submit();
}
frmsearch.resultCount.value = "<%= resultCount %>";
frmsearch.reason.value = "<%= reason %>";
</script>	  
<%= PageUtils.getAdminFooter(request) %>
</BODY></HTML>
