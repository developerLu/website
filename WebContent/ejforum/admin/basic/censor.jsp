<%@ page contentType="text/html;charset=gbk" errorPage="../error.jsp"%>
<%@ page import="com.hongshee.ejforum.util.PageUtils"%>
<%@ page import="com.hongshee.ejforum.data.UserDAO.UserInfo"%>
<%@ page import="com.hongshee.ejforum.data.OptionVO"%>
<%@ page import="com.hongshee.ejforum.common.ForumSetting"%>
<%
	UserInfo userinfo = PageUtils.getAdminUser(request, response);
	if (userinfo == null) return;
	ForumSetting setting = ForumSetting.getInstance();
	StringBuilder badwords = new StringBuilder();
	OptionVO[] censorWords = setting.getCensorWords();
	if (censorWords != null)
	{
		for (int i=0; i<censorWords.length; i++)	
		{
			badwords.append(censorWords[i].name);
			if (censorWords[i].value != null)
				badwords.append('=').append(censorWords[i].value);
			badwords.append("\\n");
		}
	}
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
          <TD><A onclick="parent.location='../index.htm'; return false;" href="#">后台管理首页</A>&nbsp;&raquo;&nbsp;词语过滤
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
              <LI>如需在用户发布包含某个词语的文字后再进行审核，而不是直接替换过滤，请将其对应的替换内容设置为&nbsp;{CHECK}&nbsp;即可。</LI></UL>
            <UL>
              <LI>为不影响程序效率，请不要设置过多不需要的过滤内容。</LI></UL>
		</TD></TR></TBODY></TABLE><BR>
      <FORM id=settings name=settings onSubmit="checkfields(this); return false;" action="../perform.jsp" method=post>
	  <INPUT type=hidden name="act" value="basic_censor">
      <TABLE class=info_tb cellSpacing=0 cellPadding=0 width="100%" border=0>
        <TBODY>
        <TR class=header>
          <TD colSpan=2>不良词语列表</TD></TR>
        <TR>
          <TD class=altbg1 width="45%" valign="top"><B>添加格式：</B>
            <LI>每行一组过滤词语。
            <LI>不良词语和替换词语之间使用“=”进行分割。
            <LI>如果只是想将某个词语直接替换成 
            **，则只输入词语即可。<BR><BR><B>例如：</B><BR>
			toobad<BR>badword=goodword<BR>dirtyword={CHECK}</LI></TD>
          <TD class=altbg2 style="padding-bottom:10px">
			<IMG onmouseover="this.style.cursor='pointer'" onclick="zoomtextarea('badwords', 1)" src="../images/zoomin.gif"> 
			<IMG onmouseover="this.style.cursor='pointer'" onclick="zoomtextarea('badwords', 0)" src="../images/zoomout.gif">
            <BR><TEXTAREA style="WIDTH:90%" id="badwords" name="badwords" rows=10 cols=70></TEXTAREA>
		  </TD></TR></TBODY></TABLE><BR>
      <CENTER><INPUT class=button type=submit value="提 交"></CENTER></FORM>
	  </TD></TR></TBODY></TABLE><BR><BR>
<script language="javascript">
function checkfields(theform) {
	theform.submit();
}
$('settings').badwords.value = "<%= badwords.toString().replace("\"", "&quot;") %>";
</script>	  
<%= PageUtils.getAdminFooter(request) %>
</BODY></HTML>
