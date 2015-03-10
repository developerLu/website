<%@ page contentType="text/html;charset=gbk" errorPage="../error.jsp"%>
<%@ page import="com.hongshee.ejforum.util.PageUtils"%>
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
          <TD><A 
            onclick="parent.location='../index.htm'; return false;" 
            href="#">后台管理首页</A>&nbsp;&raquo;&nbsp;数据维护</TD></TR></TBODY></TABLE><BR>
      <FORM id="frmsearch" name="frmsearch" onSubmit="checkfields(this); return false;" action="../perform.jsp" method=post>
	  <INPUT type=hidden name="act" value="tools_manage_data">
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
              <LI>数据维护功能用于特殊情况下对论坛数据进行强制修改等操作，正常情况下不需要执行。</LI>
              <LI>内容替换功能用于强制将所有帖子内容中的某一字符串替换为另一字符串，比如：如果您的网站域名发生了改变，您可以将帖子内容中的旧的网址串修改为新的网址。</LI>
			  </UL></TD></TR>
	  </TBODY></TABLE><BR>
	  <table width="100%" border="0" cellpadding="0" cellspacing="0" class="info_tb">
	<tr class="header"><td colspan=2>内容替换 -&nbsp; 在所有帖子内容中执行字符串替换</td></tr>
	<tbody>
		<tr>
			<td class="altbg1" width="45%">待替换的旧字符串:</td><td class="altbg2" width="55%">
			<input type="text" name="fromStr" size="50" value=""></td></tr>
		<tr>
			<td class="altbg1" width="45%">新的字符串:</td><td class="altbg2" width="55%">
			<input type="text" name="toStr" size="50" value=""></td></tr>
	</tbody></table><br/>
	<center><input class="button" type="submit" value="执行替换"></center>
	</FORM></TD></TR></TBODY></TABLE><BR><BR>
<script language="javascript">
function checkfields(theform) {
	if (theform.action.indexOf('/perform.jsp') >= 0)
	{
		if (trim(theform.fromStr.value) == '') {
			alert('待替换的旧字符串不可以为空');
      		theform.fromStr.focus();
			return;
		}
	}
	theform.submit();
}
</script>	  
<%= PageUtils.getAdminFooter(request) %>
</BODY></HTML>
