<%@ page contentType="text/html;charset=gbk" errorPage="../error.jsp"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="com.hongshee.ejforum.util.PageUtils"%>
<%@ page import="com.hongshee.ejforum.common.CacheManager"%>
<%@ page import="com.hongshee.ejforum.data.UserDAO.UserInfo"%>
<%@ page import="com.hongshee.ejforum.data.SectionDAO.SectionVO"%>
<%@ page import="com.hongshee.ejforum.data.BoardDAO.BoardVO"%>
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
          <TD><A onclick="parent.location='../index.htm';return false;" href="#">后台管理首页</A>&nbsp;&raquo;&nbsp;合并版块
		  </TD></TR></TBODY></TABLE><BR>
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
              <LI>合并版块可将源版块的帖子全部转入目标版块，同时删除源版块。</LI>
            </UL>
            <UL>
              <LI>合并版块一旦提交立即生效，并无法恢复，请仔细选择目标版块和源版块。</LI></UL></TD></TR></TBODY></TABLE><BR>
      <FORM id="frmmerge" name="frmmerge" onSubmit="checkfields(this); return false;" action="../perform.jsp" method=post>
	  <INPUT type=hidden name="act" value="forums_forum_merge">
	  <INPUT type=hidden name="fromPath" value="<%= fromPath %>">
      <TABLE class=info_tb cellSpacing=0 cellPadding=0 width="100%" border=0>
        <TBODY>
        <TR class=header>
          <TD colSpan=3>合并版块</TD></TR>
        <TR align=middle>
          <TD class=altbg1 width="45%">源版块:</TD>
          <TD class=altbg2><SELECT name="sourceBoard"> 
		  <OPTION value="" selected>&nbsp;&nbsp;&gt; 请选择</OPTION><OPTION value="">&nbsp;</OPTION>
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
        <TR align=middle>
          <TD class=altbg1 width="45%">目标版块:</TD>
          <TD class=altbg2><SELECT name="targetBoard"> 
		  <OPTION value="" selected>&nbsp;&nbsp;&gt; 请选择</OPTION><OPTION value="">&nbsp;</OPTION>
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
	  </SELECT></TD></TR></TBODY></TABLE><BR>
      <CENTER><INPUT class=button type=submit value="提 交"></CENTER></FORM></TD></TR></TBODY></TABLE><BR><BR>
<script language="javascript">
function checkfields(theform) {
	if (trim(theform.sourceBoard.value) == '') {
		alert('请选择源版块');
      	theform.sourceBoard.focus();
		return;
	}
	if (trim(theform.targetBoard.value) == '') {
		alert('请选择目标版块');
      	theform.targetBoard.focus();
		return;
	}
	if (theform.sourceBoard.value == theform.targetBoard.value) {
		alert('源版块和目标版块不能相同');
      	theform.targetBoard.focus();
		return;
	}
	theform.submit();
}
</script>	  
<%= PageUtils.getAdminFooter(request) %>
</BODY></HTML>
