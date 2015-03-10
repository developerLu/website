<%@ page contentType="text/html;charset=gbk" errorPage="../error.jsp"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="java.util.HashMap"%>
<%@ page import="com.hongshee.ejforum.util.PageUtils"%>
<%@ page import="com.hongshee.ejforum.util.AppUtils"%>
<%@ page import="com.hongshee.ejforum.data.UserDAO.UserInfo"%>
<%@ page import="com.hongshee.ejforum.data.BackupDAO"%>
<%
	UserInfo userinfo = PageUtils.getAdminUser(request, response);
	if (userinfo == null) return;
	
	String act = request.getParameter("act");
	if (act != null && act.equals("del"))
	{
		String taskID = request.getParameter("tid");
		BackupDAO.getInstance().deleteTask(taskID);
	}	
	
	ArrayList taskList = BackupDAO.getInstance().getAllTasks();
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
            href="#">后台管理首页</A>&nbsp;&raquo;&nbsp;数据备份</TD></TR></TBODY></TABLE><BR>
	<FORM id="frmtask" name="frmtask" action="./backup_task.jsp?" method=post>
	<input type="hidden" name="act">
	<input type="hidden" name="tid">
      <TABLE class=info_tb cellSpacing=0 cellPadding=0 width="100%" border=0>
        <TBODY>
        <TR class=header>
          <TD>
            <DIV style="FLOAT: left; MARGIN-LEFT: 0px; PADDING-TOP: 8px"><A 
            onclick="collapse_change('tip','../images')" href="#">技巧提示</A></DIV>
            <DIV style="FLOAT: right; PADDING-BOTTOM: 9px; MARGIN-RIGHT: 4px"><A 
            onclick="collapse_change('tip','../images')" href="#">
			<IMG id=menuimg_tip src="../images/menu_reduce.gif" border=0></A></DIV></TD></TR>
        <TBODY id=menu_tip>
        <TR>
          <TD>
            <UL>
              <LI>数据备份任务会将指定的文件或目录压缩成&nbsp;ZIP&nbsp;文件，然后通过&nbsp;Email&nbsp;发送到系统管理员邮箱。</LI>
              <LI>建议将数据库数据文件或目录采用这里的方法定期进行备份，如果是使用&nbsp;Hsqldb&nbsp;数据库，则应备份&nbsp;context&nbsp;下的&nbsp;WEB-INF/data&nbsp;目录。</LI>
		    </UL></TD></TR>
	  </TBODY></TABLE><BR>
      <TABLE class=info_tb cellSpacing=0 cellPadding=0 width="100%" border=0>
        <TBODY>
        <TR class=header>
          <TD width="7%" style="padding-right:0px">序号</TD>
          <TD width="20%">源文件或目录</TD>
          <TD width="20%">目标文件</TD>
          <TD width="9%">调度</TD>
          <TD width="9%">邮件</TD>
          <TD width="11%">创建时间</TD>
          <TD width="11%">描述</TD>
		  <TD width="13%">操作</TD></TR>
<%
	if (taskList != null)
	{
		HashMap record = null;
		String runat = null;
		String sendmail = null;
		for (int i=0; i<taskList.size(); i++)
		{
			record = (HashMap)taskList.get(i);
			runat = (String)record.get("RUNAT");
			runat = runat.equals("D")?"每日一次":(runat.equals("W")?"每周一次":"立即执行");
			sendmail = (String)record.get("SENDMAIL");
			sendmail = sendmail.equals("T")?"发送":"不发送";
%>		  
        <TR>
          <TD class=altbg1 style="text-align:center"><%= i+1 %></TD>
          <TD class=altbg2 style="font-family:'Courier New', Courier, mono">
		  	<script language="javascript">
				toBreakWord("<%= ((String)record.get("INPUTFILE")).replace("\\","\\\\") %>","25");</script></TD>
          <TD class=altbg1 style="font-family:'Courier New', Courier, mono">
  			<script language="javascript">
				toBreakWord("<%= ((String)record.get("OUTPUTFILE")).replace("\\","\\\\") %>","25");</script></TD>
          <TD class=altbg2><%= runat %></TD>
          <TD class=altbg1><%= sendmail %></TD>
          <TD class=altbg2><%= AppUtils.formatSQLTimeStr((String)record.get("CREATETIME")) %></TD>
          <TD class=altbg1><%= (String)record.get("REMARK") %></TD>
          <TD class=altbg2>
		  	[&nbsp;<A href="javascript:doAction('mod','<%= (String)record.get("TASKID") %>')">修改</A>&nbsp;]
	 	    [&nbsp;<A href="javascript:doAction('del','<%= (String)record.get("TASKID") %>')">删除</A>&nbsp;]</TD></TR>
<%
		}
	}
%>		  
	  </TBODY></TABLE><BR>
      <CENTER><INPUT class=button type=button value="新建备份任务" name=newtask onclick="doAction('new','')">&nbsp;
	  <INPUT class=button type=button value="备份论坛设置" name=configtask onclick="doAction('setting','')">&nbsp;
	  <INPUT class=button type=button value="备份论坛数据" name=configtask onclick="doAction('data','')"></CENTER></FORM>
<script language="javascript">
function doAction(action, taskID) 
{
	if (action == 'del')
	{
		if (confirm('请确定要删除指定的备份任务吗？'))
			location = 'backup_data.jsp?tid=' + taskID + "&act=del";
	}
	else
	{
		$('frmtask').act.value = action;
		$('frmtask').tid.value = taskID;
		$('frmtask').submit();
	}
}
</script>
	</TD></TR></TBODY></TABLE><BR><BR>
<%= PageUtils.getAdminFooter(request) %>
</BODY></HTML>
