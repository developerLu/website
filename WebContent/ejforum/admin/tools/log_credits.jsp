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
    String reason = PageUtils.getHTMLParam(request, "reason");
	Object[] result = ActionLogDAO.getInstance().getLogList("credits", reason, pageno, resultCount);
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
            href="#">后台管理首页</A>&nbsp;&raquo;&nbsp;积分交易记录</TD></TR></TBODY></TABLE><BR>
	<FORM id="frmsearch" name="frmsearch" onSubmit="checkfields(this); return false;" action="./log_credits.jsp" method=post>
	<input type="hidden" name="page" value="<%= pageno %>">
      <TABLE class=info_tb cellSpacing=0 cellPadding=0 width="100%" border=0>
        <TBODY>
        <TR class=header>
          <TD colSpan=3>积分交易记录&nbsp;-&nbsp; 过滤条件</TD></TR>
		<TR class="altbg2"><TD width="25%">每页显示记录数量:</TD>
			<TD width="55%"><input type="text" name="resultCount" size="50" maxlength="3" value="20"></TD>
			<TD width="20%"><input class="button" type="submit" value="提 交"></TD></TR>
		<TR class="altbg2"><TD width="25%">动作(可使用通配符 *):</TD>
			<TD width="55%"><input type="text" name="reason" size="50" maxlength="10"></TD>
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
          <TD width="20%">用户名</TD>
          <TD width="20%">来自</TD>
          <TD width="20%">时间</TD>
          <TD width="20%">积分收入</TD>
          <TD width="20%">动作</TD></TR>
<%
	if (result != null && result[1] != null)
	{
		ArrayList logList = (ArrayList)result[1];
		HashMap record = null;
		for (int i=0; i<logList.size(); i++)
		{
			record = (HashMap)logList.get(i);
%>	  
        <TR align=middle>
          <TD class=altbg1>
		  	<A href="../../uspace.jsp?uid=<%= (String)record.get("USERID") %>" 
			   target=_blank><%= (String)record.get("USERID") %></A></TD>
          <TD class=altbg2>
		  	<A href="../../uspace.jsp?uid=<%= (String)record.get("FROMUSER") %>" 
			   target=_blank><%= (String)record.get("FROMUSER") %></A></TD>
          <TD class=altbg1><%= AppUtils.formatSQLTimeStr((String)record.get("CREATETIME")) %></TD>
          <TD class=altbg2><%= (String)record.get("CREDITS") %></TD>
          <TD class=altbg1><%= (String)record.get("ACTION") %></TD></TR>
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
frmsearch.reason.value = "<%= reason==null?"":reason %>";
</script>	  
<%= PageUtils.getAdminFooter(request) %>
</BODY></HTML>
