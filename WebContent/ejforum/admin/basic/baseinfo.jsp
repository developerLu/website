<%@ page contentType="text/html;charset=gbk" errorPage="../error.jsp"%>
<%@ page import="com.hongshee.ejforum.util.PageUtils"%>
<%@ page import="com.hongshee.ejforum.data.UserDAO.UserInfo"%>
<%@ page import="com.hongshee.ejforum.common.ForumSetting"%>
<%
	UserInfo userinfo = PageUtils.getAdminUser(request, response);
	if (userinfo == null) return;
	ForumSetting setting = ForumSetting.getInstance();
	String serverName = request.getServerName();
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
          <TD><A onclick="parent.location='../index.htm'; return false;" href="#">后台管理首页</A>&nbsp;&raquo;&nbsp;基本设置
 		  </TD></TR></TBODY></TABLE><BR>
      <FORM id=settings name=settings onSubmit="checkfields(this); return false;" action="../perform.jsp" method=post>
	  <INPUT type=hidden name="act" value="basic_baseinfo">
	  <A name=tb01></A>
      <TABLE class=info_tb cellSpacing=0 cellPadding=0 width="100%" border=0>
        <TBODY>
        <TR class=header>
          <TD colSpan=2>基本设置<A onClick="collapse_change('tb01','../images')" href="#">
		  <IMG id=menuimg_tb01 style="MARGIN-TOP: -12px; FLOAT: right; MARGIN-RIGHT: 8px" 
            src="../images/menu_reduce.gif" border=0></A> </TD></TR>
        <TBODY id=menu_tb01>
        <TR>
          <TD class=altbg1 width="45%"><B>论坛名称:</B><BR><SPAN 
            class=smalltxt>论坛名称，将显示在导航条和标题中</SPAN></TD>
          <TD class=altbg2><INPUT type="text" size=50 id="forumName" name="forumName"> </TD></TR>
		<tr>
			<td width="45%" class="altbg1" valign="top"><b>论坛 logo:</b><br/>
			<span class="smalltxt">论坛 images 子目录下的 logo 文件名称，如使用 Flash 动画，请用逗号隔开 URL，宽度和高度，如“logo.swf,80,40”</span></td>
			<td class="altbg2"><input type="text" size="50" name="forumLogo"></td>
		</tr>			
        <TR>
          <TD class=altbg1 width="45%"><B>网站名称:</B><BR><SPAN 
            class=smalltxt>网站名称，将显示在页面底部的联系方式处</SPAN></TD>
          <TD class=altbg2><INPUT type="text" size=50 name="website"> </TD></TR>
        <TR>
          <TD class=altbg1 width="45%"><B>网站 URL:</B><BR><SPAN 
            class=smalltxt>网站 URL，将作为链接显示在页面底部</SPAN></TD>
          <TD class=altbg2><INPUT type="text" size=50 name="siteUrl"> </TD></TR>
        <TR>
          <TD class=altbg1 width="45%"><B>页脚联系邮箱:</B><BR><SPAN 
            class=smalltxt>留空时联系邮箱为系统管理员的邮箱地址</SPAN></TD>
          <TD class=altbg2><INPUT type="text" size=50 id="footerMailAddr" name="footerMailAddr"></TD></TR>
        <TR>
          <TD class=altbg1 width="45%"><B>网站备案信息代码:</B><BR><SPAN 
            class=smalltxt>页面底部可以显示 ICP 
            备案信息，如果网站已备案，在此输入您的授权码，它将显示在页面底部，如果没有请留空</SPAN></TD>
          <TD class=altbg2><INPUT type="text" size=50 name="certCode"> </TD></TR>
		<tr><td width="45%" class="altbg1">
			<b>论坛日期格式:</b><br/>
			<span class="smalltxt">使用 yyyy 表示年，mm 表示月，dd 表示天</span></td>
			<td class="altbg2">
				<select name="dateFormat">
					<option value="yyyy-mm-dd">yyyy-mm-dd</option>
					<option value="yyyy/mm/dd">yyyy/mm/dd</option>
					<option value="dd-mm-yyyy">dd-mm-yyyy</option>
					<option value="dd/mm/yyyy">dd/mm/yyyy</option>
				</select>
			</td></tr>
        <TR>
          <TD class=altbg1 width="45%"><B>网站时差:</B><BR><SPAN 
            class=smalltxt>网站本地时间与 GMT 标准的时间差</SPAN></TD>
          <TD class=altbg2>
		  		<select name="timezone">
		  			<jsp:include page="../../include/timezone.html"/>
				</select>
		  </TD></TR>
		</TBODY></TABLE><BR>
      <A name=tb03></A>
      <TABLE class=info_tb cellSpacing=0 cellPadding=0 width="100%" border=0>
        <TBODY>
        <TR class=header>
          <TD colSpan=2>系统邮件设置<A onClick="collapse_change('tb03','../images')" href="#"><IMG 
            id=menuimg_tb03 style="MARGIN-TOP: -12px; FLOAT: right; MARGIN-RIGHT: 8px" 
            src="../images/menu_reduce.gif" border=0></A> </TD></TR>
        <TBODY id=menu_tb03>
        <TR>
          <TD class=altbg1 width="45%"><B>管理员邮件地址:</B><BR><SPAN 
            class=smalltxt>本论坛系统管理员的邮件地址</SPAN></TD>
          <TD class=altbg2><INPUT type="text" size=50 id="adminMailAddr" name="adminMailAddr"></TD></TR>
        <TR>
          <TD class=altbg1 width="45%"><B>系统邮件地址:</B><BR><SPAN 
            class=smalltxt>系统向外或向内发送邮件时使用的邮件地址</SPAN></TD>
          <TD class=altbg2><INPUT type="text" size=50 id="sysMailAddr" name="sysMailAddr"></TD></TR>
        <TR>
          <TD class=altbg1 width="45%"><B>系统邮件用户名:</B><BR><SPAN 
            class=smalltxt>系统自动发送邮件时所使用的邮件用户名</SPAN></TD>
          <TD class=altbg2><INPUT type="text" size=50 id="sysMailUser" name="sysMailUser"></TD></TR>
        <TR>
          <TD class=altbg1 width="45%"><B>系统邮件密码:</B><BR><SPAN 
            class=smalltxt>系统自动发送邮件时所使用的邮件密码</SPAN></TD>
          <TD class=altbg2><INPUT type="password" size=50 id="sysMailPasswd" name="sysMailPasswd"></TD></TR>
        <TR>
          <TD class=altbg1 width="45%"><B>系统邮件发送服务器:</B><BR><SPAN 
            class=smalltxt>系统默认的邮件&nbsp;SMTP&nbsp;服务器地址。如果必须使用&nbsp;SSL&nbsp;加密协议发送邮件，请在前面注明"SSL:"，比如：SSL:smtp.gmail.com</SPAN></TD>
          <TD class=altbg2><INPUT type="text" size=50 id="sysSmtpHost" name="sysSmtpHost"></TD></TR>
        </TBODY></TABLE><BR>
      <CENTER><INPUT class=button type=submit value="提 交"></CENTER></FORM></TD></TR></TBODY></TABLE><BR><BR>
<script language="javascript">
function checkfields(theform) {
	if (trim($('forumName').value) == '') {
		alert('论坛名称不可以为空');
		$('forumName').focus();
	} else if(!isLegalEmail(trim($('adminMailAddr').value))) {
		alert('请输入有效的管理员邮件地址');
		$('adminMailAddr').focus();
	} else if(!isLegalEmail(trim($('sysMailAddr').value))) {
		alert('请输入有效的系统邮件地址');
		$('sysMailAddr').focus();
	} else if(trim($('sysMailUser').value) == '') {
		alert('请输入系统邮件用户名');
		$('sysMailUser').focus();
	} else if(trim($('sysSmtpHost').value) == '') {
		alert('请输入系统邮件发送服务器');
		$('sysSmtpHost').focus();
	} else {
		theform.submit();
	}
}
$('settings').forumName.value = "<%= setting.getHTMLStr(ForumSetting.BASEINFO,"forumName") %>";
$('settings').forumLogo.value = "<%= setting.getHTMLStr(ForumSetting.BASEINFO,"forumLogo") %>";
$('settings').website.value = "<%= setting.getHTMLStr(ForumSetting.BASEINFO,"website",serverName) %>";
$('settings').siteUrl.value = "<%= setting.getHTMLStr(ForumSetting.BASEINFO,"siteUrl","http://" + serverName) %>";
$('settings').footerMailAddr.value = 
	"<%= setting.getHTMLStr(ForumSetting.BASEINFO,"footerMailAddr",setting.getAdminMailAddr()) %>";
$('settings').certCode.value = "<%= setting.getHTMLStr(ForumSetting.BASEINFO,"certCode") %>";
$('settings').dateFormat.value = "<%= setting.getHTMLStr(ForumSetting.BASEINFO,"dateFormat") %>";
$('settings').timezone.value = "<%= setting.getHTMLStr(ForumSetting.BASEINFO,"timezone") %>";
$('settings').adminMailAddr.value = "<%= setting.getAdminMailAddr() %>";
$('settings').sysMailAddr.value = "<%= setting.getHTMLStr(ForumSetting.BASEINFO,"sysMailAddr") %>";
$('settings').sysMailUser.value = "<%= setting.getHTMLStr(ForumSetting.BASEINFO,"sysMailUser") %>";
$('settings').sysMailPasswd.value = 
	"<%= setting.getString(ForumSetting.BASEINFO,"sysMailPasswd").trim().length()==0?"":"      " %>";
$('settings').sysSmtpHost.value = "<%= setting.getHTMLStr(ForumSetting.BASEINFO,"sysSmtpHost") %>";
</script>	  
<%= PageUtils.getAdminFooter(request) %>
</BODY></HTML>
