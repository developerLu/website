<%@ page contentType="text/html;charset=gbk" errorPage="../error.jsp"%>
<%@ page import="com.hongshee.ejforum.util.PageUtils"%>
<%@ page import="com.hongshee.ejforum.util.AppUtils"%>
<%@ page import="com.hongshee.ejforum.data.UserDAO.UserInfo"%>
<%
	UserInfo userinfo = PageUtils.getAdminUser(request, response);
	if (userinfo == null) return;
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
            href="#">后台管理首页</A>&nbsp;&raquo;&nbsp;计划任务</TD></TR></TBODY></TABLE><BR>
	<FORM id="frmtask" name="frmtask" action="../perform.jsp?" method=post>
	<input type="hidden" name="act" value="">
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
              <LI>以下任务由系统自动调度执行(一般会在凌晨执行)，正常情况下不需要手动执行。</LI></UL></TD></TR>
	  </TBODY></TABLE><BR>
      <TABLE class=info_tb cellSpacing=0 cellPadding=0 width="100%" border=0>
        <TBODY>
        <TR class=header>
          <TD colSpan=2>每日执行一次</TD></TR>
		<TR class="altbg2"><TD width="80%">检查主题（高亮、置顶等）是否过期:</TD>
			<TD width="20%"><input class="button" type="button" value="手动执行" onclick="doTask('check_expired')"></TD></TR>
		<TR class="altbg2"><TD width="80%">统计论坛的访问量及基本概况:</TD>
			<TD width="20%"><input class="button" type="button" value="手动执行" onclick="doTask('stat_forum_visits')"></TD></TR>
		<TR class="altbg2"><TD width="80%">刷新首页主题推介区的主题列表:</TD>
			<TD width="20%"><input class="button" type="button" value="手动执行" onclick="doTask('load_hot_links')"></TD></TR>
		<TR class="altbg2"><TD width="80%">清理超出限制数的短消息:</TD>
			<TD width="20%"><input class="button" type="button" value="手动执行" onclick="doTask('clean_sms')"></TD></TR>
		<TR class="altbg2"><TD width="80%">清理超出限制数的收藏夹记录:</TD>
			<TD width="20%"><input class="button" type="button" value="手动执行" onclick="doTask('clean_favors')"></TD></TR>
		<TR class="altbg2"><TD width="80%">重新统计版块主题与帖子数:</TD>
			<TD width="20%"><input class="button" type="button" value="手动执行" onclick="doTask('stat_board_posts')"></TD></TR>
		<TR class="altbg2"><TD width="80%">重建主题与帖子全文索引:</TD>
			<TD width="20%"><input class="button" type="button" value="手动执行" onclick="doTask('index_topics')"></TD></TR>
		<TR class="altbg2"><TD width="80%">执行每日数据备份任务:</TD>
			<TD width="20%"><input class="button" type="button" value="手动执行" onclick="doTask('daily_backup')"></TD></TR>
        </TBODY></TABLE><BR>
      <TABLE class=info_tb cellSpacing=0 cellPadding=0 width="100%" border=0>
        <TBODY>
        <TR class=header>
          <TD colSpan=2>每周执行一次</TD></TR>
		<TR class="altbg2"><TD width="80%">清理过期的垃圾箱记录:</TD>
			<TD width="20%"><input class="button" type="button" value="手动执行" onclick="doTask('clean_trashbox')"></TD></TR>
		<TR class="altbg2"><TD width="80%">清理过期的日志记录:</TD>
			<TD width="20%"><input class="button" type="button" value="手动执行" onclick="doTask('clean_logs')"></TD></TR>
		<TR class="altbg2"><TD width="80%">清理无效的附件与头像文件:</TD>
			<TD width="20%"><input class="button" type="button" value="手动执行" onclick="doTask('clean_attaches')"></TD></TR>
		<TR class="altbg2"><TD width="80%">执行每周数据备份任务:</TD>
			<TD width="20%"><input class="button" type="button" value="手动执行" onclick="doTask('weekly_backup')"></TD></TR>
        </TBODY></TABLE>
	  </FORM>
<script language="javascript">
function doTask(task) {
	$('frmtask').act.value = "tools_" + task;
	$('frmtask').submit();
}
</script>
</TD></TR></TBODY></TABLE><BR><BR>
<%= PageUtils.getAdminFooter(request) %>
</BODY></HTML>