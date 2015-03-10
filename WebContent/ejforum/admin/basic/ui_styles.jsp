<%@ page contentType="text/html;charset=gbk" errorPage="../error.jsp"%>
<%@ page import="com.hongshee.ejforum.util.PageUtils"%>
<%@ page import="com.hongshee.ejforum.data.UserDAO.UserInfo"%>
<%@ page import="com.hongshee.ejforum.data.OptionVO"%>
<%@ page import="com.hongshee.ejforum.common.ForumSetting"%>
<%
	UserInfo userinfo = PageUtils.getAdminUser(request, response);
	if (userinfo == null) return;
	ForumSetting setting = ForumSetting.getInstance();
	OptionVO[] styles = setting.getStyles();
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
          <TD><A onclick="parent.location='../index.htm'; return false;" href="#">后台管理首页</A>&nbsp;&raquo;&nbsp;界面风格
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
              <LI>界面风格模板的&nbsp;"Style ID"&nbsp;来源于论坛 styles
			  	  子目录下的子目录名称，与模板对应的&nbsp;CSS&nbsp;文件和&nbsp;image&nbsp;文件都存放在此子目录下。</LI>
              <LI>通过对&nbsp;styles&nbsp;目录下的文件的修改和维护，可以实现对界面风格的定制。</LI>
              <LI>备份论坛设置时不包含界面风格设置，如果编辑了界面风格, 请单独备份&nbsp;styles&nbsp;目录。</LI>
            </UL></TD></TR></TBODY></TABLE><BR>
      <FORM id=settings name=settings onSubmit="checkfields(this); return false;" action="../perform.jsp" method=post>
	  <INPUT type=hidden name="act" value="basic_styles">
      <TABLE class=info_tb cellSpacing=0 cellPadding=0 width="100%" border=0>
        <TBODY>
        <TR class=header>
          <TD width="30">可用</TD>
          <TD>Style ID</TD>
          <TD>模板名称</TD>
          <TD>模板文件路径</TD>
          <TD>图片文件路径</TD>
          <TD>主要样式</TD>
		</TR>
<%
	String styleID = null;
	String checked = null;
	String checkType = null;
	for (int i=0; i<styles.length; i++)
	{
		styleID = styles[i].name;
		if (styleID.startsWith("1_") || styleID.startsWith("0_"))
		{
			if (styleID.charAt(0) == '1')
				checked = "checked";
			else
				checked = "";
			styleID = styleID.substring(2);
		}
		else
			checked = "checked";

		if (styleID.equalsIgnoreCase("default"))
		{
			checkType = "hidden";
			checked = "checked";
		}
		else
			checkType = "checkbox";
%>		
        <TR align=middle>
          <TD class=altbg2>
		  	<INPUT class=checkbox type="<%= checkType %>" value="<%= styleID %>" name="used" <%= checked %>>
			<INPUT class=checkbox type="hidden" value="<%= styleID %>" name="styleID"></TD>
          <TD class=altbg1><%= styleID %></TD>
          <TD class=altbg2><INPUT size=18 value="<%= styles[i].value.replace("\"", "&quot;") %>" name="styleName"></TD>
          <TD class=altbg1>${AppPath}/styles/<%= styleID %></TD>
          <TD class=altbg2>${AppPath}/styles/<%= styleID %>/images</TD>
          <TD class=altbg1>[&nbsp;<A href="style_info.jsp?style=<%= styleID %>">编辑</A>&nbsp;]</TD>
		</TR>
<%
	}
%>		
	</TBODY></TABLE><BR>
      <CENTER><INPUT class=button type=submit value="提 交"></CENTER></FORM><BR></TD></TR>
	  </TBODY></TABLE><BR><BR>
<script language="javascript">
function checkfields(theform) {
	theform.submit();
}
</script>	  
<%= PageUtils.getAdminFooter(request) %>
</BODY></HTML>
