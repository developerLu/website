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
            href="#">后台管理首页</A>&nbsp;&raquo;&nbsp;批量删帖</TD></TR></TBODY></TABLE><BR>
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
              <LI>批量删帖一般用于删除违规的回复帖子，如果要批量删除主题请使用批量主题管理。</LI>
		    </UL></TD></TR></TBODY></TABLE><BR>
      <FORM id="frmsearch" name="frmsearch" onSubmit="checkfields(this); return false;" action="./post_list.jsp" method=post>
      <TABLE class=info_tb cellSpacing=0 cellPadding=0 width="100%" border=0>
        <TBODY>
        <TR class=header>
          <TD colSpan=2>帖子查询</TD></TR>
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
          <TD class=altbg1>发帖用户名:</TD>
          <TD class=altbg2 align=right><INPUT size=40 name="userID"></TD></TR>
        <TR>
          <TD class=altbg1>发帖 IP:</TD>
          <TD class=altbg2 align=right><INPUT size=40 name="remoteIP"></TD></TR>
        <TR>
          <TD class=altbg1>所属主题的标题关键字:</TD>
          <TD class=altbg2 align=right><INPUT size=40 name="subject"></TD></TR>
        <TR>
          <TD class=altbg1>发帖日期早于(yyyy-mm-dd):</TD>
          <TD class=altbg2 align=right><INPUT size=40 name="maxCreateTime"></TD></TR>
        <TR>
          <TD class=altbg1>发帖日期晚于(yyyy-mm-dd):</TD>
          <TD class=altbg2 align=right><INPUT size=40 name="minCreateTime"></TD></TR>
        <TR>
          <TD class=altbg1>是否包含附件:</TD>
          <TD class=altbg2 align=right><INPUT class=radio type=radio CHECKED 
            value=0 name=hasAttach> 无限制&nbsp; <INPUT class=radio type=radio value=1 
            name=hasAttach> 包含且仅包含&nbsp; <INPUT class=radio type=radio value=2 
            name=hasAttach> 不包含</TD></TR>
	  </TBODY></TABLE><BR>
      <CENTER><INPUT class=button type=submit value="提 交" name=searchsubmit></CENTER></FORM></TD></TR></TBODY></TABLE><BR><BR>
<script language="javascript">
function checkfields(theform) {
	theform.submit();
}
</script>	  
<%= PageUtils.getAdminFooter(request) %>
</BODY></HTML>
