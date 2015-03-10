<%@ page contentType="text/html;charset=gbk" errorPage="../error.jsp"%>
<%@ page import="com.hongshee.ejforum.util.PageUtils"%>
<%@ page import="com.hongshee.ejforum.common.CacheManager"%>
<%@ page import="com.hongshee.ejforum.data.UserDAO.UserInfo"%>
<%@ page import="com.hongshee.ejforum.data.SectionDAO.SectionVO"%>
<%
	UserInfo userinfo = PageUtils.getAdminUser(request, response);
	if (userinfo == null) return;
	String fromPath = request.getContextPath() + "/admin/forums/forum_edit.jsp";
	
	String sectionID = request.getParameter("sid");
	CacheManager cache = CacheManager.getInstance();
	SectionVO aSection = cache.getSection(sectionID);
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
          <TD>
		    <A onclick="parent.location='../index.htm';return false;" href="#">后台管理首页</A>&nbsp;&raquo;&nbsp;编辑版块
		  </TD></TR></TBODY></TABLE><BR>
      <FORM id=settings name=settings onSubmit="checkfields(this); return false;" action="../perform.jsp" method=post>
	  <INPUT type=hidden name="act" value="forums_section_edit">
	  <INPUT type=hidden name="sectionID" value="<%= aSection.sectionID %>">
	  <INPUT type=hidden name="fromPath" value="<%= fromPath %>">
	  <A name=tb01></A>
      <TABLE class=info_tb cellSpacing=0 cellPadding=0 width="100%" border=0>
        <TBODY>
        <TR class=header>
          <TD colSpan=2>分区详细设置&nbsp;-&nbsp;<%= aSection.sectionName %>
		  	<A onclick="collapse_change('tb01','../images')" href="#">
 		    <IMG id=menuimg_tb01 style="MARGIN-TOP: -12px; FLOAT: right; MARGIN-RIGHT: 8px" 
             src="../images/menu_reduce.gif" border=0></A> </TD></TR>
        <TBODY id=menu_tb01>
        <TR>
          <TD class=altbg1 width="45%"><B>分区名称:</B></TD>
          <TD class=altbg2><INPUT size=50 value="<%= aSection.sectionName %>" name="sectionName"> </TD></TR>
        <TR>
          <TD class=altbg1 width="45%"><B>下级子版块横排:</B><BR><SPAN 
            class=smalltxt>设置下级子版块横排时每行版块数量，如果设置为"0"，则按正常方式排列</SPAN></TD>
          <TD class=altbg2><INPUT size=50 value="<%= String.valueOf(aSection.cols) %>" name="cols"> </TD></TR>
        </TBODY></TABLE><BR>
      <CENTER><INPUT class=button type=submit value="提 交"></CENTER></FORM>
	  </TD></TR></TBODY></TABLE><BR><BR>
<script language="javascript">
function checkfields(theform) {
	if (trim(theform.sectionName.value) == '') {
		alert('分区名称不可以为空');
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
</script>	  
<%= PageUtils.getAdminFooter(request) %>
</BODY></HTML>
