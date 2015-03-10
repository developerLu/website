<%@ page contentType="text/html;charset=gbk" errorPage="../error.jsp"%>
<%@ page import="com.hongshee.ejforum.util.PageUtils"%>
<%@ page import="com.hongshee.ejforum.data.UserDAO.UserInfo"%>
<%@ page import="com.hongshee.ejforum.common.ForumSetting"%>
<%
	UserInfo userinfo = PageUtils.getAdminUser(request, response);
	if (userinfo == null) return;
	ForumSetting setting = ForumSetting.getInstance();
	String[] mailEvents = setting.getHTMLStr(ForumSetting.FUNCTIONS,"mailEvents").split(",");
	StringBuilder judgeOptions = new StringBuilder();
	judgeOptions.append("垃圾广告\n").append("恶意灌水\n").append("违规内容\n").append("文不对题\n").append("重复发帖\n\n")
				.append("我很赞同\n").append("精品文章\n").append("原创内容");
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
          <TD><A onclick="parent.location='../index.htm'; return false;" 
		  		href="#">后台管理首页</A>&nbsp;&raquo;&nbsp;论坛功能</TD></TR></TBODY></TABLE><BR>
      <FORM id=settings name=settings onSubmit="checkfields(this); return false;" action="../perform.jsp" method=post>
	  <INPUT type=hidden name="act" value="basic_functions">
	  <A name=tb05></A>
      <TABLE class=info_tb cellSpacing=0 cellPadding=0 width="100%" border=0>
        <TBODY>
        <TR class=header>
          <TD colSpan=2>帖子相关设置<A onClick="collapse_change('tb05','../images')" href="#">
			<IMG id=menuimg_tb05 style="MARGIN-TOP: -12px; FLOAT: right; MARGIN-RIGHT: 8px" 
            src="../images/menu_reduce.gif" border=0></A> </TD></TR>
        <TBODY id=menu_tb05>
        <TR>
          <TD class=altbg1 width="45%"><B>帖子最大字数(K 字节):</B><BR><SPAN 
            class=smalltxt>每个帖子的最大字数，超过此限制的帖子将不能提交</SPAN></TD>
          <TD class=altbg2><INPUT size=50 value=10 name="maxPostLength"> </TD></TR>
        <TR>
          <TD class=altbg1 width="45%"><B>帖内最大附件数:</B><BR><SPAN 
            class=smalltxt>在一篇帖子中可以附加的最大附件数，最大可为10</SPAN></TD>
          <TD class=altbg2><INPUT size=50 value=2 name="maxAttachNum"> </TD></TR>
        <TR>
          <TD class=altbg1 width="45%"><B>允许附件类型:</B><BR><SPAN 
            class=smalltxt>设置允许上传的附件扩展名，多个扩展名之间用半角逗号 "," 分割，留空为不限制</SPAN></TD>
          <TD class=altbg2><INPUT size=50 value="chm, pdf, zip, rar, tar, gz, jar, gif, jpg, jpeg, png" 
				            name="allowAttachTypes"></TD></TR>
        <TR>
          <TD class=altbg1 width="45%"><B>最大附件总尺寸(K 字节):</B><BR><SPAN 
            class=smalltxt>设置每次可上传附件总尺寸的最大字节数</SPAN></TD>
          <TD class=altbg2><INPUT size=50 value=100 name="maxAttachSize"></TD></TR>
        <TR>
          <TD class=altbg1 width="45%"><B>允许的最大回帖数:</B><BR><SPAN 
            class=smalltxt>每个主题允许的最大回帖数，超过此限制的主题将会自动关闭</SPAN></TD>
          <TD class=altbg2><INPUT size=50 value=2000 name="maxReplies"> </TD></TR>
	</TBODY></TABLE><BR>			  
	  <A name=tb04></A>
      <TABLE class=info_tb cellSpacing=0 cellPadding=0 width="100%" border=0>
        <TBODY>
        <TR class=header>
          <TD colSpan=2>广告设置<A onClick="collapse_change('tb04','../images')" href="#">
			<IMG id=menuimg_tb04 style="MARGIN-TOP: -12px; FLOAT: right; MARGIN-RIGHT: 8px" 
            src="../images/menu_reduce.gif" border=0></A> </TD></TR>
        <TBODY id=menu_tb04>
        <TR>
          <TD class=altbg1 width="45%" valign="top"><B>页首广告代码:</B><BR><SPAN 
            class=smalltxt>出现在论坛每个页面页首&nbsp;(logo 右侧)&nbsp;的广告&nbsp;HTML&nbsp;
				代码，若为空则页首不显示广告，但在具体版块页面则以版块自身的广告代码设置为准</SPAN></TD>
          <TD class=altbg2>
		    <IMG onmouseover="this.style.cursor='pointer'" onclick="zoomtextarea('headAdCode', 1)" src="../images/zoomin.gif"> 
			<IMG onmouseover="this.style.cursor='pointer'" onclick="zoomtextarea('headAdCode', 0)" src="../images/zoomout.gif">
            <BR><TEXTAREA id="headAdCode" name="headAdCode" rows=6 cols=50 
				 style="width:278px"><%= setting.getString(ForumSetting.FUNCTIONS,"headAdCode") %></TEXTAREA></TD></TR>
        <TR>
          <TD class=altbg1 width="45%" valign="top"><B>页脚广告代码:</B><BR><SPAN 
            class=smalltxt>出现在论坛每个页面页脚的广告&nbsp;HTML&nbsp;代码，若为空则页脚不显示广告，但在具体版块页面则以版块自身的广告代码设置为准</SPAN></TD>
          <TD class=altbg2>
		    <IMG onmouseover="this.style.cursor='pointer'" onclick="zoomtextarea('footAdCode', 1)" src="../images/zoomin.gif"> 
			<IMG onmouseover="this.style.cursor='pointer'" onclick="zoomtextarea('footAdCode', 0)" src="../images/zoomout.gif">
            <BR><TEXTAREA id="footAdCode" name="footAdCode" rows=6 cols=50 
				 style="width:278px"><%= setting.getString(ForumSetting.FUNCTIONS,"footAdCode") %></TEXTAREA> </TD></TR>
        <TR>
          <TD class=altbg1 width="45%" valign="top"><B>左下脚信息代码:</B><BR><SPAN 
            class=smalltxt>出现在论坛每个页面左下脚&nbsp;(EasyJForum&nbsp;版权标识的下面)&nbsp;的附加信息&nbsp;HTML&nbsp;代码，可以用于放置经营、网监标识、统计信息等</SPAN></TD>
          <TD class=altbg2>
		    <IMG onmouseover="this.style.cursor='pointer'" onclick="zoomtextarea('footRemark', 1)" src="../images/zoomin.gif"> 
			<IMG onmouseover="this.style.cursor='pointer'" onclick="zoomtextarea('footRemark', 0)" src="../images/zoomout.gif">
            <BR><TEXTAREA id="footRemark" name="footRemark" rows=6 cols=50 
				 style="width:278px"><%= setting.getString(ForumSetting.FUNCTIONS,"footRemark") %></TEXTAREA> </TD></TR>
	</TBODY></TABLE><BR>			  
	<A name=tb01></A>
      <TABLE class=info_tb cellSpacing=0 cellPadding=0 width="100%" border=0>
        <TBODY>
        <TR class=header>
          <TD colSpan=2>管理相关设置<A onClick="collapse_change('tb01','../images')" href="#">
			<IMG id=menuimg_tb01 style="MARGIN-TOP: -12px; FLOAT: right; MARGIN-RIGHT: 8px" 
            src="../images/menu_reduce.gif" border=0></A> </TD></TR>
        <TBODY id=menu_tb01>
        <TR>
          <TD class=altbg1 vAlign=top width="45%"><B>管理操作理由选项:</B><BR><SPAN 
            class=smalltxt>本设定将在用户执行部分管理操作时显示，每个理由一行，如果空行则显示一行分隔符“--------”，用户可选择本设定中预置的理由选项或自行输入</SPAN></TD>
          <TD class=altbg2>
		  	<IMG onmouseover="this.style.cursor='pointer'" onclick="zoomtextarea('judgeOptions', 1)" src="../images/zoomin.gif"> 
			<IMG onmouseover="this.style.cursor='pointer'" onclick="zoomtextarea('judgeOptions', 0)" src="../images/zoomout.gif">
			<BR><TEXTAREA id="judgeOptions" name="judgeOptions" rows=6 cols=50 style="width:278px"></TEXTAREA></TD></TR>
        <TR>
          <TD class=altbg1 
            width="45%"><B>管理记录保留时间(月):</B><BR><SPAN 
            class=smalltxt>系统中保留论坛管理日志的时间，默认为&nbsp;3&nbsp;个月，0 为永久保留</SPAN></TD>
          <TD class=altbg2><INPUT size=50 value=3 name="logKeepMonths"> </TD></TR>
        <TR>
          <TD class=altbg1 
            width="45%"><B>帖子回收站记录保留时间(月):</B><BR><SPAN 
            class=smalltxt>系统中保留帖子回收站记录的时间，默认为&nbsp;3&nbsp;个月，0 为永久保留</SPAN></TD>
          <TD class=altbg2><INPUT size=50 value=3 name="trashKeepMonths"> </TD></TR>
        <TR>
          <TD class=altbg1 width="45%"><B>是否发送及时邮件通知:</B><BR>
			<SPAN class=smalltxt>当发生下述事件时，系统自动发送邮件通知管理员或相关责任版主</SPAN></TD>
          <TD class=altbg2>		  
			<INPUT class=checkbox type=checkbox value="error" name="[chk]mailEvents" id="mailEvents[error]"> 系统错误 <br/>
			<INPUT class=checkbox type=checkbox value="audit" name="[chk]mailEvents" id="mailEvents[audit]"> 新用户审核申请 <br/>
			<INPUT class=checkbox type=checkbox value="report" name="[chk]mailEvents" id="mailEvents[report]"> 收到举报信息 <br/>
			<INPUT class=checkbox type=checkbox value="version" name="[chk]mailEvents" id="mailEvents[version]"> 本系统的升级信息 
			<INPUT type=hidden value="" name="[chk]mailEvents" id="mailEvents[]">
			</TD></TR>
		</TBODY></TABLE><BR>
		<A name=tb02></A>
      <TABLE class=info_tb cellSpacing=0 cellPadding=0 width="100%" border=0>
        <TBODY>
        <TR class=header>
          <TD colSpan=2>RSS 设置<A onClick="collapse_change('tb02','../images')" href="#">
		    <IMG id=menuimg_tb02 style="MARGIN-TOP: -12px; FLOAT: right; MARGIN-RIGHT: 8px" 
	             src="../images/menu_reduce.gif" border=0></A> </TD></TR>
        <TBODY id=menu_tb02>
        <TR>
          <TD class=altbg1 width="45%"><B>默认的&nbsp;RSS&nbsp;输出样式:</B><BR><SPAN class=smalltxt>
指定默认的&nbsp;RSS&nbsp;输出样式。“标题式”输出仅包含每个主题的标题信息，而“全文式”输出则包含每个主题的标题和内容信息，
通过使用合适的&nbsp;RSS&nbsp;客户端软件，“全文式”输出可以减少网络访问次数，提高阅读效率，从而可能减轻服务器负载</SPAN></TD>
          <TD class=altbg2>		  
			<INPUT class=radio type=radio value="A" name="RssStyle" id="RssStyle[A]" checked> 全文式 <br/>
			<INPUT class=radio type=radio value="B" name="RssStyle" id="RssStyle[B]"> 标题式 
			</TD></TR>
        <TR>
          <TD class=altbg1 width="45%"><B>RSS 输出主题数:</B><BR><SPAN 
            class=smalltxt>每个&nbsp;RSS&nbsp;频道输出的主题数目，最大可为100</SPAN></TD>
          <TD class=altbg2><INPUT size=50 value=15 name="topicsPerChannel"> </TD></TR>
        <TR>
          <TD class=altbg1 width="45%"><B>显示&nbsp;RSS&nbsp;订阅按钮</B><BR><SPAN class=smalltxt>
指定在&nbsp;RSS&nbsp;订阅页面是否显示“订阅”按钮&nbsp;(使用&nbsp;Wisol&nbsp;Reader&nbsp;进行订阅)</SPAN></TD>
          <TD class=altbg2>		  
			<INPUT class=radio type=radio value="yes" name="RssSub" id="RssSub[yes]" checked> 是 &nbsp;
			<INPUT class=radio type=radio value="no" name="RssSub" id="RssSub[no]"> 否 
			</TD></TR>
		</TBODY></TABLE><BR>
      <CENTER><INPUT class=button type=submit value="提 交"></CENTER></FORM>
	  </TD></TR></TBODY></TABLE><BR><BR>
<script language="javascript">
function checkfields(theform) {
    var filter = /^\d+$/;
    if (!filter.test(trim(theform.logKeepMonths.value))) {
    	alert('管理记录保留时间必须为整数');
      	theform.logKeepMonths.focus();
		return;
    }
    if (!filter.test(trim(theform.trashKeepMonths.value))) {
    	alert('回收站记录保留时间必须为整数');
      	theform.trashKeepMonths.focus();
		return;
    }
    if (!filter.test(trim(theform.maxPostLength.value))) {
    	alert('帖子最大字数必须为整数');
      	theform.maxPostLength.focus();
		return;
    }
    if (!filter.test(trim(theform.maxReplies.value))) {
    	alert('允许的最大回帖数必须为整数');
      	theform.maxReplies.focus();
		return;
    }
    if (!filter.test(trim(theform.maxAttachNum.value))) {
    	alert('帖内最大附件数必须为整数');
      	theform.maxAttachNum.focus();
		return;
    }
    if (!filter.test(trim(theform.maxAttachSize.value))) {
    	alert('最大附件尺寸必须为整数');
      	theform.maxAttachSize.focus();
		return;
    }
	theform.submit();
}
$('settings').maxPostLength.value = "<%= setting.getInt(ForumSetting.FUNCTIONS,"maxPostLength") %>";
$('settings').maxAttachNum.value = "<%= setting.getInt(ForumSetting.FUNCTIONS,"maxAttachNum") %>";
$('settings').allowAttachTypes.value = 
	"<%= setting.getHTMLStr(ForumSetting.FUNCTIONS,"allowAttachTypes") %>";
$('settings').maxAttachSize.value = "<%= setting.getInt(ForumSetting.FUNCTIONS,"maxAttachSize") %>";
$('settings').maxReplies.value = "<%= setting.getInt(ForumSetting.FUNCTIONS,"maxReplies") %>";
$('settings').logKeepMonths.value = "<%= setting.getInt(ForumSetting.FUNCTIONS,"logKeepMonths") %>";
$('settings').trashKeepMonths.value = "<%= setting.getInt(ForumSetting.FUNCTIONS,"trashKeepMonths") %>";
$('settings').judgeOptions.value = "<%= setting.getHTMLStr(ForumSetting.FUNCTIONS,"judgeOptions",judgeOptions.toString()) %>";
<%
	for (int i=0; i<mailEvents.length; i++)
	{
		if (mailEvents[i] != null && mailEvents[i].trim().length() > 0)
		{
%>
$('mailEvents[<%= mailEvents[i] %>]').checked = "true";
<%
		}
	}
%>
$('RssStyle[<%= setting.getHTMLStr(ForumSetting.FUNCTIONS,"RssStyle") %>]').checked = "true";
$('settings').topicsPerChannel.value = "<%= setting.getInt(ForumSetting.FUNCTIONS,"topicsPerChannel") %>";
$('RssSub[<%= setting.getHTMLStr(ForumSetting.FUNCTIONS,"RssSub","yes") %>]').checked = "true";
</script>	  
<%= PageUtils.getAdminFooter(request) %>
</BODY></HTML>
