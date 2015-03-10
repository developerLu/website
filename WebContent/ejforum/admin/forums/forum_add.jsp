<%@ page contentType="text/html;charset=gbk" errorPage="../error.jsp"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="com.hongshee.ejforum.util.PageUtils"%>
<%@ page import="com.hongshee.ejforum.common.CacheManager"%>
<%@ page import="com.hongshee.ejforum.data.UserDAO.UserInfo"%>
<%@ page import="com.hongshee.ejforum.data.SectionDAO.SectionVO"%>
<%
	UserInfo userinfo = PageUtils.getAdminUser(request, response);
	if (userinfo == null) return;
	String fromPath = request.getContextPath() + "/admin/forums/forum_edit.jsp";
	
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
          <TD><A onclick="parent.location='../index.htm';return false;" href="#">后台管理首页</A>&nbsp;&raquo;&nbsp;添加版块
		  </TD></TR></TBODY></TABLE><BR>
      <FORM id=frmsection name=frmsection onSubmit="checkfields(this); return false;" action="../perform.jsp" method=post>
	  <INPUT type=hidden name="act" value="forums_section_add">
	  <INPUT type=hidden name="fromPath" value="<%= fromPath %>">
      <TABLE class=info_tb cellSpacing=0 cellPadding=0 width="100%" border=0>
        <TBODY>
        <TR class=header>
          <TD colSpan=3>添加新分区</TD></TR>
        <TR align=middle>
          <TD class=altbg1 width="45%"><B>分区名称:</B></TD>
          <TD class=altbg2><INPUT size=50 value="新分区名称" name="sectionName"></TD></TR>
        <TR>
          <TD class=altbg1 width="45%"><B>下级子版块横排:</B><BR><SPAN 
            class=smalltxt>设置下级子版块横排时每行版块数量，如果设置为"0"，则按正常方式排列</SPAN></TD>
          <TD class=altbg2><INPUT size=50 value="0" name="cols"> </TD></TR>
		  </TBODY></TABLE><BR>
      <CENTER><INPUT class=button type=submit value="提 交"></CENTER></FORM>
	  <BR>
      <FORM id=frmboard name=frmboard onSubmit="checkfields2(this); return false;" action="../perform.jsp" method=post>
	  <INPUT type=hidden name="act" value="forums_forum_add">
	  <INPUT type=hidden name="fromPath" value="<%= fromPath %>">
      <TABLE class=info_tb cellSpacing=0 cellPadding=0 width="100%" border=0>
        <TBODY>
        <TR class=header>
          <TD colSpan=2>添加新版块</TD></TR>
        <TR align=middle>
          <TD class=altbg1 width="45%"><B>版块名称:</B></TD>
          <TD class=altbg2><INPUT size=50 value="新版块名称" name="boardName"></TD></TR>
        <TR align=middle>
          <TD class=altbg1 width="45%"><B>上级分区:</B></TD>
          <TD class=altbg2>
		  	<SELECT name="sectionID"> 
<%
	if (sections != null) 
	{
		SectionVO aSection = null;
		for (int i=0; i<sections.size(); i++)	
		{
			aSection = (SectionVO)sections.get(i);
%>			
		  <OPTION value="<%= aSection.sectionID %>"><%= aSection.sectionName %></OPTION>
<%
		}
	}
%>		  
			  </SELECT></TD></TR>
        </TBODY></TABLE>
      <BR>
      <CENTER><INPUT class=button type=submit value="提 交"></CENTER></FORM><BR>
	</TD></TR></TBODY></TABLE><BR><BR>
<script language="javascript">
function checkfields(theform) {
	if (trim(theform.sectionName.value) == '') {
		alert('新分区名称不能为空');
      	theform.sectionName.focus();
		return;
	}
    var filter = /^\d+$/;
    if (!filter.test(trim(theform.cols.value))) {
    	alert('下级子版块横排数必须为整数');
      	theform.cols.focus();
		return;
    }
	theform.submit();
}
function checkfields2(theform) {
	if (trim(theform.boardName.value) == '') {
		alert('新版块名称不能为空');
      	theform.boardName.focus();
		return;
	}
	if (trim(theform.sectionID.value) == '') {
		alert('上级分区不能为空');
      	theform.sectionID.focus();
		return;
	}
	theform.submit();
}
</script>	  
<%= PageUtils.getAdminFooter(request) %>
</BODY></HTML>
