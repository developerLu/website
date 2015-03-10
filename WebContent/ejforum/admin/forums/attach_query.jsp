<%@ page contentType="text/html;charset=gbk" errorPage="../error.jsp"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="com.hongshee.ejforum.util.PageUtils"%>
<%@ page import="com.hongshee.ejforum.util.AppUtils"%>
<%@ page import="com.hongshee.ejforum.common.CacheManager"%>
<%@ page import="com.hongshee.ejforum.data.UserDAO.UserInfo"%>
<%@ page import="com.hongshee.ejforum.data.SectionDAO.SectionVO"%>
<%@ page import="com.hongshee.ejforum.data.BoardDAO.BoardVO"%>
<%
	UserInfo userinfo = PageUtils.getAdminUser(request, response);
	if (userinfo == null) return;

	CacheManager cache = CacheManager.getInstance();
    ArrayList sections = cache.getSections();
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
          <TD><A onclick="parent.location='../index.htm';return false;" 
            href="#">后台管理首页</A>&nbsp;&raquo;&nbsp;附件查询</TD></TR></TBODY></TABLE><BR>
      <FORM id="frmsearch" name="frmsearch" onSubmit="checkfields(this); return false;" action="./attach_list.jsp" method=post>
      <TABLE class=info_tb cellSpacing=0 cellPadding=0 width="100%" border=0>
        <TBODY>
        <TR class=header>
          <TD colSpan=2>附件查询</TD></TR>
        <TR>
          <TD class=altbg1>所在版块:</TD>
          <TD class=altbg2 align=right>
		  <SELECT name="boardID">
		  	 <OPTION value=all selected>&nbsp; &gt; 全部</OPTION> 
			 <OPTION value="">&nbsp;</OPTION>
<%
	if (sections != null) 
	{
		SectionVO aSection = null;
		BoardVO aBoard = null;
		for (int i=0; i<sections.size(); i++)	
		{
			aSection = (SectionVO)sections.get(i);
%>			
		  <OPTGROUP label="<%= aSection.sectionName %>">
<%
			if (aSection.boardList != null && aSection.boardList.size() > 0)
			{
				for (int j=0; j<aSection.boardList.size(); j++)
				{
					aBoard = (BoardVO)aSection.boardList.get(j);
%>		  
		  <OPTION value="<%= aBoard.boardID %>">&nbsp; &gt; <%= aBoard.boardName %></OPTION>
<%
				}
			}
%>		  
		  </OPTGROUP>
<%
		}
	}
%>
		</SELECT></TD></TR>
        <TR>
          <TD class=altbg1>附件尺寸小于(字节):</TD>
          <TD class=altbg2 align=right><INPUT size=40 name="maxFilesize"></TD></TR>
        <TR>
          <TD class=altbg1>附件尺寸大于(字节):</TD>
          <TD class=altbg2 align=right><INPUT size=40 name="minFilesize"></TD></TR>
        <TR>
          <TD class=altbg1>被下载次数小于:</TD>
          <TD class=altbg2 align=right><INPUT size=40 name="maxDownloads"></TD></TR>
        <TR>
          <TD class=altbg1>被下载次数大于:</TD>
          <TD class=altbg2 align=right><INPUT size=40 name="minDownloads"></TD></TR>
        <TR>
          <TD class=altbg1>下载所需积分小于:</TD>
          <TD class=altbg2 align=right><INPUT size=40 name="maxCredits"></TD></TR>
        <TR>
          <TD class=altbg1>下载所需积分大于:</TD>
          <TD class=altbg2 align=right><INPUT size=40 name="minCredits"></TD></TR>
        <TR>
          <TD class=altbg1>发表日期早于(yyyy-mm-dd):</TD>
          <TD class=altbg2 align=right><INPUT size=40 name="maxCreateTime"></TD></TR>
        <TR>
          <TD class=altbg1>发表日期晚于(yyyy-mm-dd):</TD>
          <TD class=altbg2 align=right><INPUT size=40 name="minCreateTime"></TD></TR>
        <TR>
          <TD class=altbg1>附件文件名(可使用通配符 *):</TD>
          <TD class=altbg2 align=right><INPUT size=40 name="filename"></TD></TR>
        <TR>
          <TD class=altbg1>用户名(可使用通配符 *):</TD>
          <TD class=altbg2 align=right><INPUT size=40 name="userID"></TD></TR>
        <TR>
          <TD class=altbg1>描述关键字:</TD>
          <TD class=altbg2 align=right><INPUT size=40 name="title"></TD></TR>
	  </TBODY></TABLE><BR>
      <CENTER><INPUT class=button type=submit value="提 交" name=searchsubmit></CENTER></FORM></TD></TR></TBODY></TABLE><BR><BR>
<script language="javascript">
function checkfields(theform) {
    var filter = /^\d+$/;
	var tmpStr = trim(theform.maxFilesize.value);
    if (tmpStr != '' && !filter.test(tmpStr)) {
    	alert('附件尺寸必须为整数');
      	theform.maxFilesize.focus();
		return;
    }
	tmpStr = trim(theform.minFilesize.value);
    if (tmpStr != '' && !filter.test(tmpStr)) {
    	alert('附件尺寸必须为整数');
      	theform.minFilesize.focus();
		return;
    }
	tmpStr = trim(theform.maxDownloads.value);
    if (tmpStr != '' && !filter.test(tmpStr)) {
    	alert('下载次数必须为整数');
      	theform.maxDownloads.focus();
		return;
    }
	tmpStr = trim(theform.minDownloads.value);
    if (tmpStr != '' && !filter.test(tmpStr)) {
    	alert('下载次数必须为整数');
      	theform.minDownloads.focus();
		return;
    }
	tmpStr = trim(theform.maxCredits.value);
    if (tmpStr != '' && !filter.test(tmpStr)) {
    	alert('所需积分必须为整数');
      	theform.maxCredits.focus();
		return;
    }
	tmpStr = trim(theform.minCredits.value);
    if (tmpStr != '' && !filter.test(tmpStr)) {
    	alert('所需积分必须为整数');
      	theform.minCredits.focus();
		return;
    }
	theform.submit();
}
</script>	  
<%= PageUtils.getAdminFooter(request) %>
</BODY></HTML>
