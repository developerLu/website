<%@ page contentType="text/html;charset=gbk" errorPage="../error.jsp"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="java.util.Properties"%>
<%@ page import="com.hongshee.ejforum.util.PageUtils"%>
<%@ page import="com.hongshee.ejforum.data.UserDAO.UserInfo"%>
<%@ page import="com.hongshee.ejforum.data.OptionVO"%>
<%@ page import="com.hongshee.ejforum.common.ForumSetting"%>
<%@ page import="com.hongshee.ejforum.common.IConstants"%>
<%
	UserInfo userinfo = PageUtils.getAdminUser(request, response);
	if (userinfo == null) return;
	String styleID = PageUtils.getParam(request,"style");
	ForumSetting setting = ForumSetting.getInstance();

	OptionVO[] styles = setting.getStyles();
	if (styleID == null || styleID.length() == 0)
		styleID = "default";
		
	String styleName = null;
    for (int i=0; i<styles.length; i++)
    {
		if (styleID.equals(styles[i].name.substring(2)))
		{
			styleName = styles[i].value;
			break;
		}
	}
	String[] keys = {"PageBg","PageCoBg","MenuBg","PopmenuBg",
					 "TableOutHeaderBg","TableInHeaderBg","InfoBoxBg","InputBgColor",
					 "NormalFontColor","MenuFontColor","HeaderFontColor","InfoFontColor",
					 "LinkFontColor","LightLinkColor","NoticeFontColor","MemoFontColor",
					 "TableBorderColor","BoxBorderColor","DashBorderColor"};
	String[] names = {"页面背景颜色","页面背景配色","主菜单背景颜色","下拉菜单背景颜色",
					  "版块表头背景颜色","内表头背景颜色","信息框背景颜色","输入框背景颜色",
					  "正常文字颜色","菜单文字颜色","表头文字颜色","说明信息文字颜色",
					  "正常超链接文字颜色","加亮超链接文字颜色","提示信息文字颜色","脚注文字颜色",
					  "版块表格边线颜色","单元格边线颜色","信息框虚边线颜色"};
	Properties props = setting.getStyleValues(styleID, keys);
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<HTML xmlns="http://www.w3.org/1999/xhtml"><HEAD>
<META http-equiv=Content-Type content="text/html; charset=gbk">
<LINK href="../style/admin.css" type=text/css rel=stylesheet>
<SCRIPT src="../../js/common.js" type=text/javascript></SCRIPT>
<SCRIPT src="../js/admin.js" type=text/javascript></SCRIPT>
<script type="text/JavaScript">
var imagePath = "../../styles/<%= styleID %>/";
function doPreview(obj) {
	var code = $(obj + '_v').value.toLowerCase();
	var p = code.indexOf('url(');
	if(p >= 0) {
		var tmpStr = code.substr(0, p);
		code = trim(code.substr(p+4));
		if (code.indexOf("http://")==0 || code.indexOf("https://")==0 || code.indexOf("/")==0)
			code = "url(" + code;
		else
			code = "url(" + imagePath + code;
		code = tmpStr + code;
	}
	$(obj).style.background = code;
}
</script>
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
            href="#">后台管理首页</A>&nbsp;&raquo;&nbsp;编辑界面风格</TD></TR></TBODY></TABLE><BR>
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
              <LI>此处仅包含主要风格的编辑，您也可以直接修改 styles 子目录下的&nbsp;CSS&nbsp;和&nbsp;images&nbsp;文件。</LI>
              <LI>如果背景是图片文件，则字段值必须以"url(file)"的形式表示，比如：url(images/menu_bg.gif) 。</LI>
              <LI>若将某一字段清空，则表示保持原值不作改变。</LI>
            </UL></TD></TR></TBODY></TABLE><BR>
      <FORM id="settings" name="settings" onSubmit="checkfields(this); return false;" action="../perform.jsp" method=post>
	  <INPUT type=hidden name="act" value="basic_style_info">
	  <INPUT type=hidden name="styleID" value="<%= styleID %>">
      <A name=tb01></A>
      <TABLE class=info_tb cellSpacing=0 cellPadding=0 width="100%" border=0>
        <TBODY>
        <TR class=header>
          <TD colSpan=2>编辑界面风格&nbsp;-&nbsp;<%= styleName %><A onClick="collapse_change('tb01','../images')" href="#">
  		    <IMG id=menuimg_tb01 style="MARGIN-TOP: -12px; FLOAT: right; MARGIN-RIGHT: 4px" 
             src="../images/menu_reduce.gif" border=0></A></TD></TR>
        <TBODY id=menu_tb01>
<%
	String aValue = null;
	String tmpStr = null;
	String imagePath = "../../styles/" + styleID + "/";
	int p = -1;
	for (int i=0; i<keys.length; i++) {
		aValue = props.getProperty(keys[i]).toLowerCase();
		p = aValue.indexOf("url(");
		if (p >= 0)
		{
			tmpStr = aValue.substring(0, p);
			aValue = aValue.substring(p+4);
			if (!aValue.startsWith("http://") && !aValue.startsWith("https://") && !aValue.startsWith("/"))
				aValue = "url(" + imagePath + aValue;
			else
				aValue = "url(" + aValue;
			aValue = tmpStr	+ aValue;
		}
%>		
        <TR>
          <TD class=altbg1 width="35%"><B><%= names[i] %>:</B><br/>
		  	<span class="smalltxt">输入&nbsp;16&nbsp;进制颜色<% if (i==2||i==3||i==4||i==5) out.write("或图片链接"); %></span>
		  </TD>
          <TD class=altbg2 nowrap><INPUT size=50 name="<%= keys[i] %>" id="c<%= i %>_v" 
		   	value='<%= props.getProperty(keys[i]) %>' onchange="doPreview('c<%= i %>')">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
		    <input id="c<%= i %>" onclick="c<%= i %>_frame.location='showcolor.htm?c<%= i %>';showMenu('c<%= i %>')" 
		    class="colorpad" style='background: <%= aValue %>' type="button">
			<span id="c<%= i %>_menu" style="display: none">
			<iframe name="c<%= i %>_frame" scrolling="no" width="166" frameborder="0" height="166"></iframe></span>
		  </TD></TR>
<%
	}
%>		  
	  </TBODY></TABLE><BR>
      <CENTER><INPUT class=button type=submit value="提 交"></CENTER></FORM>
	  </TD></TR></TBODY></TABLE><BR><BR>
<script language="javascript">
function checkfields(theform) {
	theform.submit();
}
</script>	  
<%= PageUtils.getAdminFooter(request) %>
</BODY></HTML>