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
		  		href="#">后台管理首页</A>&nbsp;&raquo;&nbsp;搜索引擎优化</TD></TR></TBODY></TABLE><BR>
      <FORM id=settings name=settings onSubmit="checkfields(this); return false;" action="../perform.jsp" method=post>
	  <INPUT type=hidden name="act" value="basic_seo">
      <A name=tb01></A>
      <TABLE class=info_tb cellSpacing=0 cellPadding=0 width="100%" border=0>
        <TBODY>
        <TR class=header>
          <TD colSpan=2>搜索引擎优化<A onClick="collapse_change('tb01','../images')" href="#"><IMG 
            id=menuimg_tb01 style="MARGIN-TOP: -12px; FLOAT: right; MARGIN-RIGHT: 8px" 
            src="../images/menu_reduce.gif" border=0></A> </TD></TR>
        <TBODY id=menu_tb01>
        <TR>
          <TD class=altbg1 width="45%"><B>标题附加字:</B><BR><SPAN 
            class=smalltxt>网页标题通常是搜索引擎关注的重点，本附加字设置将出现在标题中论坛名称的后面，如果有多个关键字，建议用 
            "|"、","(不含引号) 等符号分隔</SPAN></TD>
          <TD class=altbg2><INPUT size=50 name="appendTitle"> </TD></TR>
        <TR>
          <TD class=altbg1 width="45%"><B>Meta Keywords:</B><BR><SPAN 
            class=smalltxt>Keywords 项出现在页面头部的 Meta 标签中，用于记录本论坛的关键字，多个关键字间请用半角逗号 
            "," 隔开</SPAN></TD>
          <TD class=altbg2><INPUT size=50 name="keywords"> 
		</TD></TR>
        <TR>
          <TD class=altbg1 width="45%"><B>Meta Description:</B><BR><SPAN 
            class=smalltxt>Description 出现在页面头部的 Meta 标签中，用于记录本论坛的概要描述</SPAN></TD>
          <TD class=altbg2><INPUT size=50 name="description"> 
        </TD></TR>
		</TBODY></TABLE><BR>
      <CENTER><INPUT class=button type=submit value="提 交"></CENTER></FORM>
	  </TD></TR></TBODY></TABLE><BR><BR>
<script language="javascript">
function checkfields(theform) {
	theform.submit();
}
$('settings').appendTitle.value = "<%= setting.getHTMLStr(ForumSetting.SEO,"appendTitle") %>";
$('settings').keywords.value = "<%= setting.getHTMLStr(ForumSetting.SEO,"keywords") %>";
$('settings').description.value = "<%= setting.getHTMLStr(ForumSetting.SEO,"description") %>";
</script>	  
<%= PageUtils.getAdminFooter(request) %>
</BODY></HTML>
