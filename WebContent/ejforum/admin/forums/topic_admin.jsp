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
            href="#">后台管理首页</A>&nbsp;&raquo;&nbsp;批量主题管理</TD></TR></TBODY></TABLE><BR>
      <FORM id="frmsearch" name="frmsearch" onSubmit="checkfields(this); return false;" action="./topic_list.jsp" method=post>
      <TABLE class=info_tb cellSpacing=0 cellPadding=0 width="100%" border=0>
        <TBODY>
        <TR class=header>
          <TD colSpan=2>主题查询</TD></TR>
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
          <TD class=altbg1>主题作者:</TD>
          <TD class=altbg2 align=right><INPUT size=40 name="userID"></TD></TR>
        <TR>
          <TD class=altbg1>发帖 IP:</TD>
          <TD class=altbg2 align=right><INPUT size=40 name="remoteIP"></TD></TR>
        <TR>
          <TD class=altbg1>标题关键字:</TD>
          <TD class=altbg2 align=right><INPUT size=40 name="subject"></TD></TR>
        <TR>
          <TD class=altbg1>被浏览次数小于:</TD>
          <TD class=altbg2 align=right><INPUT size=40 name="maxVisits"></TD></TR>
        <TR>
          <TD class=altbg1>被浏览次数大于:</TD>
          <TD class=altbg2 align=right><INPUT size=40 name="minVisits"></TD></TR>
        <TR>
          <TD class=altbg1>被回复次数小于:</TD>
          <TD class=altbg2 align=right><INPUT size=40 name="maxReplies"></TD></TR>
        <TR>
          <TD class=altbg1>被回复次数大于:</TD>
          <TD class=altbg2 align=right><INPUT size=40 name="minReplies"></TD></TR>
        <TR>
          <TD class=altbg1>发表日期早于(yyyy-mm-dd):</TD>
          <TD class=altbg2 align=right><INPUT size=40 name="maxCreateTime"></TD></TR>
        <TR>
          <TD class=altbg1>发表日期晚于(yyyy-mm-dd):</TD>
          <TD class=altbg2 align=right><INPUT size=40 name="minCreateTime"></TD></TR>
        <TR>
          <TD class=altbg1>是否包含精华主题:</TD>
          <TD class=altbg2 align=right><INPUT class=radio type=radio CHECKED 
            value=0 name=isDigest> 无限制&nbsp; <INPUT class=radio type=radio value=1 
            name=isDigest> 包含且仅包含&nbsp; <INPUT class=radio type=radio value=2 
            name=isDigest> 不包含</TD></TR>
        <TR>
          <TD class=altbg1>是否包含置顶主题:</TD>
          <TD class=altbg2 align=right><INPUT class=radio type=radio CHECKED 
            value=0 name=isTop> 无限制&nbsp; <INPUT class=radio type=radio value=1 
            name=isTop> 包含且仅包含&nbsp; <INPUT class=radio type=radio value=2 
            name=isTop> 不包含</TD></TR>
        <TR>
          <TD class=altbg1>是否包含高亮主题:</TD>
          <TD class=altbg2 align=right><INPUT class=radio type=radio CHECKED 
            value=0 name=isHigh> 无限制&nbsp; <INPUT class=radio type=radio value=1 
            name=isHigh> 包含且仅包含&nbsp; <INPUT class=radio type=radio value=2 
            name=isHigh> 不包含</TD></TR>
        <TR>
          <TD class=altbg1>是否包含附件:</TD>
          <TD class=altbg2 align=right><INPUT class=radio type=radio CHECKED 
            value=0 name=hasAttach> 无限制&nbsp; <INPUT class=radio type=radio value=1 
            name=hasAttach> 包含且仅包含&nbsp; <INPUT class=radio type=radio value=2 
            name=hasAttach> 不包含</TD></TR>
        <TR>
          <TD class=altbg1>主题状态:</TD>
          <TD class=altbg2 align=right><INPUT class=radio type=radio CHECKED 
            value=0 name=state> 无限制&nbsp; <INPUT class=radio type=radio value=1 
            name=state> 正常&nbsp; <INPUT class=radio type=radio value=2 
            name=state> 已关闭</TD></TR>
	  </TBODY></TABLE><BR>
      <CENTER><INPUT class=button type=submit value="提 交" name=searchsubmit></CENTER></FORM></TD></TR></TBODY></TABLE><BR><BR>
<script language="javascript">
function checkfields(theform) {
    var filter = /^\d+$/;
	var tmpStr = trim(theform.maxVisits.value);
    if (tmpStr != '' && !filter.test(tmpStr)) {
    	alert('被浏览次数必须为整数');
      	theform.maxVisits.focus();
		return;
    }
	tmpStr = trim(theform.minVisits.value);
    if (tmpStr != '' && !filter.test(tmpStr)) {
    	alert('被浏览次数必须为整数');
      	theform.minVisits.focus();
		return;
    }
	tmpStr = trim(theform.maxReplies.value);
    if (tmpStr != '' && !filter.test(tmpStr)) {
    	alert('被回复次数必须为整数');
      	theform.maxReplies.focus();
		return;
    }
	tmpStr = trim(theform.minReplies.value);
    if (tmpStr != '' && !filter.test(tmpStr)) {
    	alert('被回复次数必须为整数');
      	theform.minReplies.focus();
		return;
    }
	theform.submit();
}
</script>	  
<%= PageUtils.getAdminFooter(request) %>
</BODY></HTML>
