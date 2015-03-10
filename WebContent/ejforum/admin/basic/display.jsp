<%@ page contentType="text/html;charset=gbk" errorPage="../error.jsp"%>
<%@ page import="com.hongshee.ejforum.util.PageUtils"%>
<%@ page import="com.hongshee.ejforum.data.UserDAO.UserInfo"%>
<%@ page import="com.hongshee.ejforum.common.ForumSetting"%>
<%@ page import="com.hongshee.ejforum.data.OptionVO"%>
<%
	UserInfo userinfo = PageUtils.getAdminUser(request, response);
	if (userinfo == null) return;
	ForumSetting setting = ForumSetting.getInstance();
	String[] showHotlinks = setting.getHTMLStr(ForumSetting.DISPLAY,"showHotlinks").split(",");
	OptionVO[] styles = setting.getStyles();
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<HTML xmlns="http://www.w3.org/1999/xhtml"><HEAD>
<META http-equiv=Content-Type content="text/html; charset=gbk">
<LINK href="../style/admin.css" type=text/css rel=stylesheet>
<SCRIPT src="../../js/common.js" type=text/javascript></SCRIPT>
<SCRIPT src="../js/admin.js" type=text/javascript></SCRIPT>
</HEAD>
<BODY topMargin=10 onload="clickImageLinks()">
<TABLE cellSpacing=6 cellPadding=2 width="100%" border=0>
  <TBODY>
  <TR>
    <TD>
      <TABLE class=guide cellSpacing=0 cellPadding=0 width="100%" border=0>
        <TBODY>
        <TR>
          <TD><A onclick="parent.location='../index.htm'; return false;" 
		  href="#">后台管理首页</A>&nbsp;&raquo;&nbsp;界面与显示方式</TD></TR></TBODY></TABLE><BR>
      <FORM id=settings name=settings onSubmit="checkfields(this); return false;" action="../perform.jsp" method=post>
	  <INPUT type=hidden name="act" value="basic_display">
      <A name=tb01></A>
      <TABLE class=info_tb cellSpacing=0 cellPadding=0 width="100%" border=0>
        <TBODY>
        <TR class=header>
          <TD colSpan=2>风格设置<A onClick="collapse_change('tb01','../images')" href="#">
		  	<IMG id=menuimg_tb01 style="MARGIN-TOP: -12px; FLOAT: right; MARGIN-RIGHT: 8px" 
            src="../images/menu_reduce.gif" border=0></A> </TD></TR>
        <TBODY id=menu_tb01>
        <TR>
          <TD class=altbg1 width="45%"><B>默认界面风格:</B><BR><SPAN 
            class=smalltxt>论坛默认的界面风格，游客和使用默认风格的会员将以此风格显示</SPAN></TD>
          <TD class=altbg2>
		  	<SELECT name="defaultStyle"> 
<%
	for (int i=0; i<styles.length; i++)
	{
		if (styles[i].name.startsWith("1_"))
		{
%>			
			  <OPTION value="<%= styles[i].name.substring(2) %>"><%= styles[i].value %></OPTION>
<%
		}
	}
%>			
			</SELECT></TD></TR>
        <TR>
          <TD class=altbg1 width="45%"><B>显示风格下拉菜单:</B><BR><SPAN 
            class=smalltxt>设置是否在论坛底部显示可用的论坛风格下拉菜单，用户可以通过此菜单切换不同的论坛风格</SPAN></TD>
          <TD class=altbg2>
		  	<INPUT class=radio type=radio checked value="yes" name="showStyleList" id="showStyleList[yes]"> 是 &nbsp; &nbsp; 
			<INPUT class=radio type=radio value="no" name="showStyleList" id="showStyleList[no]"> 否 </TD></TR>
        <TR>
          <TD class=altbg1 width="45%"><B>显示分区路径:</B><BR><SPAN 
            class=smalltxt>设置是否在论坛导航条中显示分区路径</SPAN></TD>
          <TD class=altbg2>
		  	<INPUT class=radio type=radio checked value="yes" name="showSectionLink" id="showSectionLink[yes]"> 是 &nbsp; &nbsp; 
			<INPUT class=radio type=radio value="no" name="showSectionLink" id="showSectionLink[no]"> 否 </TD></TR>
		 <TR>
		 	<TD width="45%" class="altbg1" ><b>是否开启简繁转换</b><BR><SPAN 
            class=smalltxt>设置是否开启前台简繁体转换功能</SPAN></TD>
			<TD class="altbg2">
			<input class="radio" type="radio" name="tsExchange" id="tsExchange[none]" value="none" checked> 关闭<br/>
			<input class="radio" type="radio" name="tsExchange" id="tsExchange[chs]" value="chs"> 开启&nbsp;-&nbsp;默认简体<br/>
			<input class="radio" type="radio" name="tsExchange" id="tsExchange[cht]" value="cht"> 开启&nbsp;-&nbsp;默认繁体<br/>
			</TD></TR>			
       </TBODY></TABLE><BR>
	   <A name=tb02></A>
      <TABLE class=info_tb cellSpacing=0 cellPadding=0 width="100%" border=0>
        <TBODY>
        <TR class=header>
          <TD colSpan=2>首页设置<A onClick="collapse_change('tb02','../images')" href="#">
		  	<IMG id=menuimg_tb02 style="MARGIN-TOP: -12px; FLOAT: right; MARGIN-RIGHT: 8px" 
            src="../images/menu_reduce.gif" border=0></A> </TD></TR>
        <TBODY id=menu_tb02>
		<TR>
			<TD width="45%" class="altbg1" ><b>显示论坛联盟:</b><br/>
				<span class="smalltxt">论坛首页是否显示论坛联盟</span></TD>
			<TD class="altbg2">
			<input class="radio" type="radio" name="showUnion" id="showUnion[yes]" value="yes" checked> 是 &nbsp; &nbsp; 
			<input class="radio" type="radio" name="showUnion" id="showUnion[no]" value="no"> 否</TD></TR>
        <TR>
          <TD class=altbg1 width="45%"><B>显示在线用户数:</B><BR><SPAN 
            class=smalltxt>在首页显示在线会员数及最大在线会员数</SPAN></TD>
          <TD class=altbg2>
	  	<INPUT class=radio type=radio value="yes" name="showOnlineUsers" id="showOnlineUsers[yes]" checked> 是 &nbsp; &nbsp; 
		<INPUT class=radio type=radio value="no" name="showOnlineUsers" id="showOnlineUsers[no]"> 否 </TD></TR>
		 <TR>
		 	<TD width="45%" class="altbg1" ><b>显示主题推介区</b><br/>
				<span class="smalltxt">当论坛主题数达到一定数量时，可以选择开启主题推介区，若开启则应至少选择其中三项。热门主题和人气主题的定义见下表</span></TD>
			<TD class="altbg2">
		<input class="checkbox" type="checkbox" name="[chk]showHotlinks" value="image" id="showHotlinks[image]" 
			   onclick="clickImageLinks()"> 最新图片
		<input class="checkbox" type="checkbox" name="[chk]showHotlinks" value="hot" id="showHotlinks[hot]"> 最新热门主题 
		<input class="checkbox" type="checkbox" name="[chk]showHotlinks" value="rank" id="showHotlinks[rank]"> 最新人气主题 <br/>
		<input class="checkbox" type="checkbox" name="[chk]showHotlinks" value="recent" id="showHotlinks[recent]"> 最新发表
		<input class="checkbox" type="checkbox" name="[chk]showHotlinks" value="digest" id="showHotlinks[digest]"> 最新精华 
		<input type="hidden" name="[chk]showHotlinks" value="" id="showHotlinks[]">
			</TD></TR>
        <TBODY id=advanceoption style="DISPLAY: none">
		<TR>
			<TD width="45%" class="altbg1" ><b>最新图片:</b><br/>
				<span class="smalltxt">当上一个选项选中“最新图片”时所要推介的图片，可填写相对或绝对地址，
					如使用&nbsp;Flash&nbsp;动画，请用逗号隔开URL，宽度和高度，如“forum.swf,80,40”</span></TD>
			<TD class="altbg2"><input type="text" size="50" name="imageFile" value="" ></TD></TR>
		<TR>
			<TD width="45%" class="altbg1" ><b>最新图片的目标链接:</b><br/>
				<span class="smalltxt">点击此最新图片时要打开的链接地址，可填写相对或绝对地址</span></TD>
			<TD class="altbg2"><input type="text" size="50" name="imageLink" value="" ></TD></TR>
		<TR>
			<TD width="45%" class="altbg1" ><b>最新图片的文字说明:</b><br/>
				<span class="smalltxt">最新图片的文字说明，便于搜索引擎收录</span></TD>
			<TD class="altbg2"><input type="text" size="50" name="imageTitle" value="" ></TD></TR>
		</TBODY></TABLE><BR>
		<A name=tb03></A>
      <TABLE class=info_tb cellSpacing=0 cellPadding=0 width="100%" border=0>
        <TBODY>
        <TR class=header>
          <TD colSpan=2>主题列表<A 
            onclick="collapse_change('tb03','../images')" href="#">
			<IMG id=menuimg_tb03 style="MARGIN-TOP: -12px; FLOAT: right; MARGIN-RIGHT: 8px" 
            src="../images/menu_reduce.gif" border=0></A> </TD></TR>
        <TBODY id=menu_tb03>
        <TR>
          <TD class=altbg1 width="45%"><B>每页显示主题数:</B><BR><SPAN 
            class=smalltxt>主题列表中每页显示主题数目，最大可为50</SPAN></TD>
          <TD class=altbg2><INPUT size=50 value=30 name="topicsPerPage"> </TD></TR>
        <TR>
          <TD class=altbg1 width="45%"><B>主题列表最大页数:</B><BR><SPAN 
            class=smalltxt>主题列表中用户可以翻阅到的最大页数，默认值为50，0 为不限制</SPAN></TD>
          <TD class=altbg2><INPUT size=50 value=50 name="maxTopicPages"> </TD></TR>
        <TR>
          <TD class=altbg1 width="45%"><B>热门主题回复数:</B><BR><SPAN 
            class=smalltxt>超过该回复数的主题将会成为热门主题，并使用特殊的图标显示</SPAN></TD>
          <TD class=altbg2><INPUT size=50 value=10 name="hotTopicPosts"> 
          </TD></TR>
        <TR>
          <TD class=altbg1 width="45%"><B>人气主题查看数:</B><BR><SPAN 
            class=smalltxt>超过该查看数的主题将会成为人气主题，并使用特殊的图标显示</SPAN></TD>
          <TD class=altbg2><INPUT size=50 value=100 name="hotTopicVisits"> 
          </TD></TR>
		</TBODY></TABLE><BR>
		<A name=tb04></A>
      <TABLE class=info_tb cellSpacing=0 cellPadding=0 width="100%" border=0>
        <TBODY>
        <TR class=header>
          <TD colSpan=2>帖子内容<A onclick="collapse_change('tb04','../images')" href="#">
		  	<IMG id=menuimg_tb04 style="MARGIN-TOP: -12px; FLOAT: right; MARGIN-RIGHT: 8px" 
            src="../images/menu_reduce.gif" border=0></A> </TD></TR>
        <TBODY id=menu_tb04>
        <TR>
          <TD class=altbg1 width="45%"><B>每页显示贴数:</B><BR><SPAN 
            class=smalltxt>帖子列表中每页显示帖子数目，最大可为50</SPAN></TD>
          <TD class=altbg2><INPUT size=50 value=30 name="postsPerPage"> </TD></TR>
        <TR>
          <TD class=altbg1 width="45%"><B>是否显示作者头像:</B><BR><SPAN 
            class=smalltxt>是否在帖子的用户信息栏显示作者头像</SPAN></TD>
          <TD class=altbg2>
		  <INPUT class=radio type=radio value=yes name="showAvatar" id="showAvatar[yes]" checked> 是 &nbsp; &nbsp; 
		  <INPUT class=radio type=radio value=no name="showAvatar" id="showAvatar[no]"> 否 </TD></TR>
        <TR>
          <TD class=altbg1 width="45%"><B>是否显示个性签名:</B><BR><SPAN 
            class=smalltxt>是否在帖子的后面显示作者个性签名信息</SPAN></TD>
          <TD class=altbg2>
		  <INPUT class=radio type=radio value=yes name="showBrief" id="showBrief[yes]"> 是 &nbsp; &nbsp; 
		  <INPUT class=radio type=radio value=no name="showBrief" id="showBrief[no]" checked> 否 </TD></TR>
		</TBODY></TABLE><BR>
      <CENTER><INPUT class=button type=submit value="提 交"></CENTER></FORM>
	  </TD></TR></TBODY></TABLE><BR><BR>
<script language="javascript">
function checkfields(theform) 
{
    var filter = /^\d+$/;
    if (!filter.test(trim(theform.topicsPerPage.value))) {
    	alert('每页显示主题数必须为整数');
      	theform.topicsPerPage.focus();
		return;
    }
    if (!filter.test(trim(theform.maxTopicPages.value))) {
    	alert('主题列表最大页数必须为整数');
      	theform.maxTopicPages.focus();
		return;
    }
    if (!filter.test(trim(theform.hotTopicPosts.value))) {
    	alert('热门主题回复数必须为整数');
      	theform.hotTopicPosts.focus();
		return;
    }
    if (!filter.test(trim(theform.hotTopicVisits.value))) {
    	alert('人气主题查看数必须为整数');
      	theform.hotTopicVisits.focus();
		return;
    }
    if (!filter.test(trim(theform.postsPerPage.value))) {
    	alert('每页显示贴数必须为整数');
      	theform.postsPerPage.focus();
		return;
	}
	theform.submit();
}
function clickImageLinks() 
{
	$('advanceoption').style.display = $('showHotlinks[image]').checked ? '' : 'none';
}

$('settings').defaultStyle.value = "<%= setting.getHTMLStr(ForumSetting.DISPLAY,"defaultStyle") %>";
$('showStyleList[<%= setting.getHTMLStr(ForumSetting.DISPLAY,"showStyleList") %>]').checked = "true";
$('showSectionLink[<%= setting.getHTMLStr(ForumSetting.DISPLAY,"showSectionLink") %>]').checked = "true";
$('tsExchange[<%= setting.getHTMLStr(ForumSetting.DISPLAY,"tsExchange") %>]').checked = "true";
$('showUnion[<%= setting.getHTMLStr(ForumSetting.DISPLAY,"showUnion") %>]').checked = "true";
$('showOnlineUsers[<%= setting.getHTMLStr(ForumSetting.DISPLAY,"showOnlineUsers") %>]').checked = "true";
<%
	for (int i=0; i<showHotlinks.length; i++)
	{
		if (showHotlinks[i] != null && showHotlinks[i].trim().length() > 0)
		{
%>
$('showHotlinks[<%= showHotlinks[i] %>]').checked = "true";
<%
		}
	}
%>
$('settings').imageFile.value = "<%= setting.getHTMLStr(ForumSetting.DISPLAY,"imageFile") %>";
$('settings').imageLink.value = "<%= setting.getHTMLStr(ForumSetting.DISPLAY,"imageLink") %>";
$('settings').imageTitle.value = "<%= setting.getHTMLStr(ForumSetting.DISPLAY,"imageTitle") %>";
$('settings').topicsPerPage.value = "<%= setting.getInt(ForumSetting.DISPLAY,"topicsPerPage") %>";
$('settings').maxTopicPages.value = "<%= setting.getInt(ForumSetting.DISPLAY,"maxTopicPages") %>";
$('settings').hotTopicPosts.value = "<%= setting.getInt(ForumSetting.DISPLAY,"hotTopicPosts") %>";
$('settings').hotTopicVisits.value = "<%= setting.getPInt(ForumSetting.DISPLAY,"hotTopicVisits",100) %>";
$('settings').postsPerPage.value = "<%= setting.getInt(ForumSetting.DISPLAY,"postsPerPage") %>";
$('showAvatar[<%= setting.getHTMLStr(ForumSetting.DISPLAY,"showAvatar") %>]').checked = "true";
$('showBrief[<%= setting.getHTMLStr(ForumSetting.DISPLAY,"showBrief") %>]').checked = "true";

if ($('showHotlinks[image]').checked)
	$('advanceoption').style.display = "";		
else
	$('advanceoption').style.display = "none";
</script>	  
<%= PageUtils.getAdminFooter(request) %>
</BODY></HTML>
