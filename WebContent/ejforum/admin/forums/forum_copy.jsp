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
	
	String sectionID = request.getParameter("sid");
	String boardID = request.getParameter("fid");

	CacheManager cache = CacheManager.getInstance();
    ArrayList sections = cache.getSections();
	BoardVO aBoard = cache.getBoard(sectionID, boardID);
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
            onclick="parent.location='../index.htm';return false;" 
            href="#">后台管理首页</A>&nbsp;&raquo;&nbsp;复制版块设置</TD></TR></TBODY></TABLE><BR>
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
              <LI>版块设置复制可将源版块栏目的&lt;扩展设置&gt;和&lt;板块权限&gt;设置应到其它多个版块，用于快速设置一批版块。
			  </LI>
            </UL></TD></TR></TBODY></TABLE><BR>
      <FORM id=settings name=settings onSubmit="checkfields(this); return false;" action="../perform.jsp" method=post>
	  <INPUT type=hidden name="act" value="forums_forum_copy">
	  <INPUT type=hidden name="sectionID" value="<%= sectionID %>">
	  <INPUT type=hidden name="boardID" value="<%= aBoard.boardID %>">
	  <INPUT type=hidden name="fromPath" value="<%= fromPath %>">
	  <A name=tb01></A>
      <TABLE class=info_tb cellSpacing=0 cellPadding=0 width="100%" border=0>
        <TBODY>
        <TR class=header>
          <TD colSpan=2>复制版块设置 - 源版块 - <%= aBoard.boardName %><A 
            onclick="collapse_change('tb01','../images')" href="#">
			<IMG id=menuimg_tb01 style="MARGIN-TOP: -12px; FLOAT: right; MARGIN-RIGHT: 8px" 
            src="../images/menu_reduce.gif" border=0></A> </TD></TR>
        <TBODY id=menu_tb01>
        <TR>
          <TD class=altbg1 width="45%"><B>目标版块:</B><BR><SPAN 
            class=smalltxt>选择要将源版块设置复制到哪些目标版块，可以按住 CTRL 多选</SPAN></TD>
          <TD class=altbg2>
		  <SELECT style="WIDTH: 80%" multiple size=10 name="targetBoards">
<%
	if (sections != null) 
	{
		SectionVO aSection = null;
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
		  <OPTION value="<%= aSection.sectionID %>_<%= aBoard.boardID %>">&nbsp; &gt; <%= aBoard.boardName %></OPTION>
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
	</TBODY></TABLE><BR><BR>
      <CENTER><INPUT class=button type=submit value="提 交"></CENTER></FORM></TD></TR></TBODY></TABLE><BR><BR>
<script language="javascript">
function checkfields(theform) {
	if (trim(theform.targetBoards.value) == '') {
		alert('请选择至少一个目标版块');
      	theform.targetBoards.focus();
		return;
	}
	theform.submit();
}
</script>	  
<%= PageUtils.getAdminFooter(request) %>
</BODY></HTML>
