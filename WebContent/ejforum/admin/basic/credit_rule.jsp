<%@ page contentType="text/html;charset=gbk" errorPage="../error.jsp"%>
<%@ page import="com.hongshee.ejforum.util.PageUtils"%>
<%@ page import="com.hongshee.ejforum.data.UserDAO.UserInfo"%>
<%@ page import="com.hongshee.ejforum.common.ForumSetting"%>
<%
	UserInfo userinfo = PageUtils.getAdminUser(request, response);
	if (userinfo == null) return;
	ForumSetting setting = ForumSetting.getInstance();
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
		  		href="#">后台管理首页</A>&nbsp;&raquo;&nbsp;积分策略</TD></TR></TBODY></TABLE><BR>
      <FORM id=settings name=settings onSubmit="checkfields(this); return false;" action="../perform.jsp" method=post>
	  <INPUT type=hidden name="act" value="basic_credits">
        <A name=tb01></A>
      <TABLE class=info_tb cellSpacing=0 cellPadding=0 width="100%" border=0>
        <TBODY>
        <TR class=header>
          <TD colSpan=2>积分增减策略<A onclick="collapse_change('tb01','../images')" href="#">
			<IMG id=tb01 style="MARGIN-TOP: -12px; FLOAT: right; MARGIN-RIGHT: 8px" 
            src="../images/menu_reduce.gif" border=0></A> </TD></TR>
        <TBODY id=menu_tb01>
		<TR>
          <TD class=altbg1 width="45%"><B>注册初始积分:</B><BR><SPAN 
            class=smalltxt>新用户注册后拥有的初始积分的数值</SPAN></TD>
          <TD class=altbg2><INPUT size=50 value=0 name="userInitValue"></TD></TR>        
		<TR>
          <TD class=altbg1 width="45%"><B>发主题(+)</B><BR><SPAN 
            class=smalltxt>作者发新主题增加的积分数，如果该主题被删除，作者积分也会按此标准相应减少</SPAN></TD>
          <TD class=altbg2><INPUT size=50 value=10 name="newTopic"> </TD></TR>
        <TR>
          <TD class=altbg1 width="45%"><B>回复(+)</B><BR><SPAN 
            class=smalltxt>作者发新回复增加的积分数，如果该回复被删除，作者积分也会按此标准相应减少</SPAN></TD>
          <TD class=altbg2><INPUT size=50 value=5 name="newReply"> </TD></TR>
        <TR>
          <TD class=altbg1 width="45%"><B>最佳回复(+)</B><BR><SPAN 
            class=smalltxt>作者所发回复被列为最佳回复时增加的积分数，如果该主题是悬赏主题，则以所悬赏的积分为准，
			若取消该最佳回复，作者积分也会按此标准相应减少</SPAN></TD>
          <TD class=altbg2><INPUT size=50 value=10 name="bestReply"> </TD></TR>
        <TR>
          <TD class=altbg1 width="45%"><B>加精华(+)</B><BR><SPAN 
            class=smalltxt>主题被加入精华时单位级别作者增加的积分数，如果该主题被移除精华，作者积分也会按此标准相应减少</SPAN>
		  </TD>
          <TD class=altbg2><INPUT size=50 value=20 name="digestTopic"> </TD></TR>
        <TR>
          <TD class=altbg1 width="45%"><B>上传附件(+)</B><BR><SPAN 
            class=smalltxt>用户每上传一个附件增加的积分数，如果该附件被删除，发布者积分也会按此标准相应减少</SPAN></TD>
          <TD class=altbg2><INPUT size=50 value=10 name="upload"> </TD></TR>
        <TR>
          <TD class=altbg1 width="45%"><B>下载附件(-)</B><BR><SPAN 
            class=smalltxt>用户下载一个附件时减少的积分数，如果上传用户设定了附件下载需要的具体积分，则由用户设定为准</SPAN></TD>
          <TD class=altbg2><INPUT size=50 value=-0 name="download"> </TD></TR>
        <TR>
          <TD class=altbg1 
            colSpan=2>以上标明(+)的表示增加积分数，标明(-)的表示减少积分数(其值必须为负数)，各项积分增减允许的范围为 
            -99～+99</TD>
        </TR></TBODY></TABLE>
      <BR>
      <CENTER><INPUT class=button type=submit value="提 交"></CENTER></FORM>
	  </TD></TR></TBODY></TABLE><BR><BR>
<script language="javascript">
var filter = /^[-+]?[\d]{1,2}$/;
function isvalidfield(field) {
    if (!filter.test(trim(field.value))) {
    	alert('增减积分值必须为-99至+99之间的整数');
      	field.focus();
		return false;
	}
	else
		return true;
}
function checkfields(theform) {
    if (!isvalidfield(theform.userInitValue)) return;
    if (!isvalidfield(theform.newTopic)) return;
    if (!isvalidfield(theform.newReply)) return;
    if (!isvalidfield(theform.bestReply)) return;
    if (!isvalidfield(theform.digestTopic)) return;
    if (!isvalidfield(theform.upload)) return;
    if (!isvalidfield(theform.download)) return;
	theform.submit();
}
$('settings').userInitValue.value = "<%= setting.getInt(ForumSetting.CREDITS,"userInitValue") %>";
$('settings').newTopic.value = "+<%= setting.getInt(ForumSetting.CREDITS,"newTopic") %>";
$('settings').newReply.value = "+<%= setting.getInt(ForumSetting.CREDITS,"newReply") %>";
$('settings').bestReply.value = "+<%= setting.getInt(ForumSetting.CREDITS,"bestReply") %>";
$('settings').digestTopic.value = "+<%= setting.getInt(ForumSetting.CREDITS,"digestTopic") %>";
$('settings').upload.value = "+<%= setting.getInt(ForumSetting.CREDITS,"upload") %>";
$('settings').download.value = "<%= setting.getInt(ForumSetting.CREDITS,"download") %>";
</script>	  
<%= PageUtils.getAdminFooter(request) %>
</BODY></HTML>
