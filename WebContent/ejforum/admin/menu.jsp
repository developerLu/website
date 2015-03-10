<%@ page contentType="text/html;charset=gbk" errorPage="../error.jsp"%>
<%@ page import="com.hongshee.ejforum.util.PageUtils"%>
<%@ page import="com.hongshee.ejforum.data.UserDAO.UserInfo"%>
<%
	UserInfo userinfo = PageUtils.getAdminUser(request, response);
	if (userinfo == null) return;
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<HTML xmlns="http://www.w3.org/1999/xhtml"><HEAD>
<TITLE>EasyJForum 后台管理</TITLE>
<META http-equiv=Content-Type content="text/html; charset=gbk">
<LINK id=css href="style/admin.css" type=text/css rel=stylesheet>
<SCRIPT src="../js/common.js" type=text/javascript></SCRIPT>
<SCRIPT src="js/admin.js" type=text/javascript></SCRIPT>
</HEAD>
<BODY style="MARGIN: 5px">
<TABLE class=leftmenu_tb style="MARGIN-BOTTOM: 5px" cellSpacing=0 cellPadding=0 width=146 align=center border=0>
  <TBODY>
  <TR class=leftmenu_box>
    <TD>
      <DIV align=center><A href="../index.jsp" target=_blank>论坛首页</A>&nbsp;&nbsp;<A 
      onclick="parent.location='./index.htm'; return false;" href="#">后台首页</A></DIV></TD></TR></TBODY></TABLE>
<% if (userinfo.groupID == 'A') { %>
<DIV id=basic style="DISPLAY: none">
<TABLE class=leftmenu_tb style="MARGIN-BOTTOM: 5px" cellSpacing=0 cellPadding=0 width=146 align=center border=0>
  <TBODY>
  <TR class=leftmenu_box>
    <TD>&nbsp;&nbsp;论坛选项</TD></TR>
  <TBODY id=menu_1>
  <TR>
    <TD>
      <TABLE class=leftmenu_items cellSpacing=0 cellPadding=0 border=0>
        <TBODY>
        <TR>
          <TD><A href="basic/baseinfo.jsp" target=main>基本设置</A></TD></TR>
        <TR>
          <TD><A href="basic/access.jsp" target=main>注册与访问控制</A></TD></TR>
        <TR>
          <TD><A 
            href="basic/display.jsp" 
            target=main>界面与显示方式</A></TD></TR>
        <TR>
          <TD><A 
            href="basic/seo.jsp" 
            target=main>搜索引擎优化</A></TD></TR>
        <TR>
          <TD><A 
            href="basic/functions.jsp" 
            target=main>论坛功能</A></TD></TR>
        <TR>
          <TD><A 
            href="basic/credit_rule.jsp" 
            target=main>积分策略</A></TD></TR>
        <TR>
          <TD><A 
            href="basic/censor.jsp" 
            target=main>词语过滤</A></TD></TR>
		</TBODY></TABLE></TD></TR></TBODY></TABLE>
<TABLE class=leftmenu_tb style="MARGIN-BOTTOM: 5px" cellSpacing=0 cellPadding=0 width=146 align=center border=0>
  <TBODY>
  <TR class=leftmenu_box>
    <TD>&nbsp;&nbsp;论坛配置</TD></TR>
  <TBODY id=menu_2>
  <TR>
    <TD>
      <TABLE class=leftmenu_items cellSpacing=0 cellPadding=0 border=0>
        <TBODY>
        <TR>
          <TD><A href="basic/ui_styles.jsp" target=main>界面风格</A></TD></TR>
        <TR>
          <TD><A href="basic/config.jsp" target=main>运行参数</A></TD></TR>
	</TBODY></TABLE></TD></TR></TBODY></TABLE>			
</DIV>
<% } %>
<DIV id=forums>
<% if (userinfo.groupID == 'A') { %>
<TABLE class=leftmenu_tb style="MARGIN-BOTTOM: 5px" cellSpacing=0 cellPadding=0 width=146 align=center border=0>
  <TBODY>
  <TR class=leftmenu_box>
    <TD>&nbsp;&nbsp;版块设置</TD></TR>
  <TBODY id=menu_3>
  <TR>
    <TD>
      <TABLE class=leftmenu_items cellSpacing=0 cellPadding=0 border=0>
        <TBODY>
        <TR>
          <TD><A href="forums/forum_edit.jsp" 
            target=main>编辑版块</A></TD></TR>
        <TR>
          <TD><A href="forums/forum_add.jsp" 
            target=main>添加版块</A></TD></TR>
        <TR>
          <TD><A href="forums/forum_merge.jsp" 
            target=main>合并版块</A></TD></TR>
		</TBODY></TABLE></TD></TR></TBODY></TABLE>
<% } %>		
<TABLE class=leftmenu_tb style="MARGIN-BOTTOM: 5px" cellSpacing=0 cellPadding=0 width=146 align=center border=0>
  <TBODY>
  <TR class=leftmenu_box>
    <TD>&nbsp;&nbsp;论坛维护</TD></TR>
  <TBODY id=menu_4>
  <TR>
    <TD>
      <TABLE class=leftmenu_items cellSpacing=0 cellPadding=0 border=0>
        <TBODY>
        <TR>
          <TD><A href="forums/log_report.jsp" 
            target=main>用户举报记录</A></TD></TR>
        <TR>
          <TD><A href="forums/log_censor.jsp" 
            target=main>词语过滤记录</A></TD></TR>
<% if (userinfo.groupID == 'A') { %>
        <TR>
          <TD><A href="forums/topic_admin.jsp" 
            target=main>批量主题管理</A></TD></TR>
        <TR>
          <TD><A href="forums/post_delete.jsp" 
            target=main>批量删帖</A></TD></TR>
<% } %>		
        <TR>
          <TD><A href="forums/attach_query.jsp" 
            target=main>附件查询</A></TD></TR>
        <TR>
          <TD><A href="forums/trash_admin.jsp" 
            target=main>帖子回收站</A></TD></TR>
        </TBODY></TABLE></TD></TR></TBODY></TABLE></DIV>		
<DIV id=users style="DISPLAY: none">
<TABLE class=leftmenu_tb style="MARGIN-BOTTOM: 5px" cellSpacing=0 cellPadding=0 width=146 align=center border=0>
  <TBODY>
  <TR class=leftmenu_box>
    <TD>&nbsp;&nbsp;用户管理</TD></TR>
  <TBODY id=menu_5>
  <TR>
    <TD>
      <TABLE class=leftmenu_items cellSpacing=0 cellPadding=0 border=0>
        <TBODY>
        <TR>
          <TD><A href="users/user_edit.jsp" 
            target=main>编辑用户</A></TD></TR>
        <TR>
          <TD><A href="users/user_edit.jsp?act=ban" 
            target=main>禁止用户</A></TD></TR>
        <TR>
          <TD><A href="users/user_edit.jsp?act=credits" 
            target=main>积分奖惩</A></TD></TR>
        <TR>
          <TD><A href="users/user_audit.jsp" 
            target=main>审核新用户</A></TD></TR>
		</TBODY></TABLE></TD></TR></TBODY></TABLE>
<% if (userinfo.groupID == 'A') { %>
<TABLE class=leftmenu_tb style="MARGIN-BOTTOM: 5px" cellSpacing=0 cellPadding=0 width=146 align=center border=0>
  <TBODY>
  <TR class=leftmenu_box>
    <TD>&nbsp;&nbsp;用户组管理</TD></TR>
  <TBODY id=menu_6>
  <TR>
    <TD>
      <TABLE class=leftmenu_items cellSpacing=0 cellPadding=0 border=0>
        <TBODY>
        <TR>
          <TD><A href="users/group_system.jsp" 
            target=main>系统用户组</A></TD></TR>
        <TR>
          <TD><A href="users/group_member.jsp" 
            target=main>会员用户组</A></TD></TR>
		</TBODY></TABLE></TD></TR></TBODY></TABLE>
<% } %></DIV>
<% if (userinfo.groupID == 'A') { %>
<DIV id=tools style="DISPLAY: none">
<TABLE class=leftmenu_tb style="MARGIN-BOTTOM: 5px" cellSpacing=0 cellPadding=0 width=146 align=center border=0>
  <TBODY>
  <TR class=leftmenu_box>
    <TD>&nbsp;&nbsp;系统工具</TD></TR>
  <TBODY id=menu_7>
  <TR>
    <TD>
      <TABLE class=leftmenu_items cellSpacing=0 cellPadding=0 border=0>
        <TBODY>
        <TR>
          <TD><A href="tools/send_notice.jsp" 
            target=main>论坛通知</A></TD></TR>
        <TR>
          <TD><A href="tools/manage_data.jsp" 
            target=main>数据维护</A></TD></TR>
        <TR>
          <TD><A href="tools/timer_task.jsp" 
            target=main>计划任务</A></TD></TR>
        <TR>
          <TD><A href="tools/backup_data.jsp" 
            target=main>数据备份</A></TD></TR>
		</TBODY></TABLE></TD></TR></TBODY></TABLE>
<TABLE class=leftmenu_tb style="MARGIN-BOTTOM: 5px" cellSpacing=0 cellPadding=0 width=146 align=center border=0>
  <TBODY>
  <TR class=leftmenu_box>
    <TD>&nbsp;&nbsp;运行记录</TD></TR>
  <TBODY id=menu_8>
  <TR>
    <TD>
      <TABLE class=leftmenu_items cellSpacing=0 cellPadding=0 border=0>
        <TBODY>
        <TR>
          <TD><A href="tools/log_moderator.jsp" 
            target=main>版主管理记录</A></TD></TR>
        <TR>
          <TD><A href="tools/log_credits.jsp" 
            target=main>积分交易记录</A></TD></TR>
        <TR>
          <TD><A href="tools/log_admin_action.jsp" 
            target=main>后台管理记录</A></TD></TR>
        <TR>
          <TD><A href="tools/log_sys_error.jsp" 
            target=main>系统错误记录</A></TD></TR>
		</TBODY></TABLE></TD></TR></TBODY></TABLE></DIV>
<% } %>
<TABLE class=leftmenu_tb cellSpacing=0 cellPadding=0 width=146 align=center border=0>
  <TBODY>
  <TR class=leftmenu_box>
    <TD>
      <DIV style="MARGIN-LEFT: 48px"><A href="perform.jsp?act=lgt" target=_top>退出</A></DIV></TD></TR>
  </TBODY></TABLE>
</BODY></HTML>
