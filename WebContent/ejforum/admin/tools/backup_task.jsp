<%@ page contentType="text/html;charset=gbk" errorPage="../error.jsp"%>
<%@ page import="java.util.HashMap"%>
<%@ page import="java.io.File"%>
<%@ page import="com.hongshee.ejforum.util.PageUtils"%>
<%@ page import="com.hongshee.ejforum.util.AppUtils"%>
<%@ page import="com.hongshee.ejforum.common.AppContext"%>
<%@ page import="com.hongshee.ejforum.data.UserDAO.UserInfo"%>
<%@ page import="com.hongshee.ejforum.data.BackupDAO"%>
<%
	UserInfo userinfo = PageUtils.getAdminUser(request, response);
	if (userinfo == null) return;
	String act = request.getParameter("act");
	String taskID = request.getParameter("tid");
	
	if (act == null || act.length() == 0)
		act = "new";
	
	HashMap aTask = null;
	if (taskID != null && taskID.length() > 0)
		aTask = BackupDAO.getInstance().getTask(taskID);
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
	<FORM id="frmtask" name="frmtask" onSubmit="checkfields(this); return false;" action="../perform.jsp?" method=post>
	<input type="hidden" name="act" value="tools_backup_<%= act %>">
	<input type="hidden" name="taskID" value="<%= taskID==null?"":taskID %>">
	<input type="hidden" name="runStamp" value="0">
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
			  <LI>源文件或目录、目标文件都必须包括完整路径，且不限于本论坛，可以是本服务器上的任何文件或目录。</LI>
			  <LI>当压缩源尺寸较大且选择立即执行备份时，操作可能会比较耗时，请耐心等待。</LI>
			  <LI>备份论坛数据的时候，采用这里的备份文件的方法并不一定适用于所有的数据库类型，此时请自行选择其它的数据库备份方法。</LI></UL></TD></TR>
	  </TBODY></TABLE><BR>
      <TABLE class=info_tb cellSpacing=0 cellPadding=0 width="100%" border=0>
        <TBODY>
        <TR class=header>
          <TD colSpan=2>备份任务</TD></TR>
        <TR>
          <TD width="30%" class=altbg1>要备份的源文件或目录:</TD>
          <TD class=altbg2>
		  	<INPUT value="" name=inputFile size="60" maxlength="255" style="font-family:'Courier New', Courier, mono"></TD></TR>
        <TR>
          <TD width="30%" class=altbg1>是否备份子目录下的文件:</TD>
          <TD class=altbg2>
			  <INPUT value='T' name=isOnlyFile id="isOnlyFile[T]" type="radio" class="radio" 
			  		 checked="checked">&nbsp;不含子目录&nbsp;
			  <INPUT value='F' name=isOnlyFile id="isOnlyFile[F]" type="radio" class="radio">&nbsp;含子目录<br/>
		  </TD></TR>
        <TR>
          <TD width="30%" class=altbg1>备份的目标文件(*.zip):</TD>
          <TD class=altbg2>
		  <INPUT value="" name=outputFile size="60" maxlength="255" style="font-family:'Courier New', Courier, mono"></TD></TR>
        <TR>
          <TD width="30%" class=altbg1>备份方式:</TD>
          <TD class=altbg2>
			  <INPUT value='A' name=runmode id="runmode[A]" type="radio" class="radio" 
			  		 checked="checked">&nbsp;完全备份<br/>
			  <INPUT value='I' name=runmode id="runmode[I]" type="radio" class="radio">&nbsp;增量备份 （只备份上次备份后有改动或新增的文件，第一次则做完全备份）<br/>
		  </TD></TR>
        <TR>
          <TD width="30%" class=altbg1>描述:</TD>
          <TD class=altbg2>
		  <INPUT value="" name=remark size="60" maxlength="50" style="font-family:'Courier New', Courier, mono"></TD></TR>
        <TR>
          <TD width="30%" class=altbg1>调度方式:</TD>
          <TD class=altbg2>
			  <INPUT value='D' name=runat id="runat[D]" type="radio" class="radio" 
			  		 checked="checked">&nbsp;每日备份一次 （一般是凌晨）<br/>
			  <INPUT value='W' name=runat id="runat[W]" type="radio" class="radio">&nbsp;每周备份一次 （一般是周日）<br/>
			  <INPUT value='N' name=runat id="runat[N]" type="radio" class="radio">&nbsp;立即执行备份
		  </TD></TR>
        <TR>
          <TD width="30%" class=altbg1>将目标文件发送到系统管理员邮箱:</TD>
          <TD class=altbg2>
			  <INPUT value='T' name=sendmail id="sendmail[T]" type="radio" class="radio" 
			  		 checked="true">&nbsp;发送 &nbsp;
			  <INPUT value='F' name=sendmail id="sendmail[F]" type="radio" class="radio">&nbsp;不发送
		  </TD></TR>
	  </TBODY></TABLE><BR>
      <CENTER><INPUT class=button type="submit" value="提 交" name=frmsubmit></CENTER></FORM><BR>
	</TD></TR></TBODY></TABLE><BR><BR>
<script language="javascript">
function checkfields(theform) 
{
    if (trim(theform.inputFile.value) == '') {
    	alert('源目录或文件名不能为空');
      	theform.inputFile.focus();
		return;
    }
    if (trim(theform.outputFile.value) == '') {
    	alert('目标文件名不能为空');
      	theform.outputFile.focus();
		return;
    }
	theform.frmsubmit.disabled = true;
	document.body.style.cursor = 'wait';
	theform.submit();
}
<%
	if (aTask != null) {
%>
	$('frmtask').inputFile.value = "<%= ((String)aTask.get("INPUTFILE")).replace("\\","\\\\") %>";
	$('frmtask').outputFile.value = "<%= ((String)aTask.get("OUTPUTFILE")).replace("\\","\\\\") %>";
	$('frmtask').remark.value = "<%= (String)aTask.get("REMARK") %>";
	$('frmtask').runStamp.value = "<%= (String)aTask.get("RUNSTAMP") %>";
	$('runat[<%= (String)aTask.get("RUNAT") %>]').checked = "true";
	$('runmode[<%= (String)aTask.get("RUNMODE") %>]').checked = "true";
	$('isOnlyFile[<%= (String)aTask.get("ISONLYFILE") %>]').checked = "true";
	$('sendmail[<%= (String)aTask.get("SENDMAIL") %>]').checked = "true";
<%
	} else if (act.equals("setting")) {
		String appPath = AppContext.getInstance().getRealPath().replace("\\","\\\\");
		String filename = appPath;
		if (File.separatorChar == '\\')
			filename = filename + "WEB-INF\\\\conf";
		else
			filename = filename + "WEB-INF/conf";
%>
	$('frmtask').inputFile.value = "<%= filename %>";
	$('frmtask').outputFile.value = "<%= filename %>.zip";
	$('frmtask').remark.value = "论坛设置";
<%
	} else if (act.equals("data")) {
		String appPath = AppContext.getInstance().getRealPath().replace("\\","\\\\");
		String filename = appPath;
		if (File.separatorChar == '\\')
			filename = filename + "WEB-INF\\\\data";
		else
			filename = filename + "WEB-INF/data";

		String inputFile = filename;
		String adapterName = AppContext.getInstance().getSqlAdapter().getClass().getName();
		if (adapterName.indexOf("HsqldbAdapter") < 0)
			inputFile = "--请在这里输入所用数据库数据文件的目录--";
%>
	$('frmtask').inputFile.value = "<%= inputFile %>";
	$('frmtask').outputFile.value = "<%= filename %>.zip";
	$('frmtask').remark.value = "论坛数据";
<%
	}
%>
</script>	
<%= PageUtils.getAdminFooter(request) %>
</BODY></HTML>
