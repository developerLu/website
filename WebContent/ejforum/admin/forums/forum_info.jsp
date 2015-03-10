<%@ page contentType="text/html;charset=gbk" errorPage="../error.jsp"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="com.hongshee.ejforum.util.PageUtils"%>
<%@ page import="com.hongshee.ejforum.common.CacheManager"%>
<%@ page import="com.hongshee.ejforum.data.UserDAO.UserInfo"%>
<%@ page import="com.hongshee.ejforum.data.SectionDAO.SectionVO"%>
<%@ page import="com.hongshee.ejforum.data.BoardDAO.BoardVO"%>
<%@ page import="com.hongshee.ejforum.data.GroupDAO.GroupVO"%>
<%@ page import="com.hongshee.ejforum.data.OptionVO"%>
<%@ page import="com.hongshee.ejforum.common.ForumSetting"%>
<%@ page import="com.hongshee.ejforum.common.IConstants"%>
<%
	UserInfo userinfo = PageUtils.getAdminUser(request, response);
	if (userinfo == null) return;
	String fromPath = request.getContextPath() + "/admin/forums/forum_edit.jsp";
	
	String sectionID = request.getParameter("sid");
	String boardID = request.getParameter("fid");

	CacheManager cache = CacheManager.getInstance();
    ArrayList sections = cache.getSections();
	BoardVO aBoard = cache.getBoard(sectionID, boardID);

    ArrayList groups = cache.getGroups();

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
          <TD><A onclick="parent.location='../index.htm';return false;" 
            href="#">后台管理首页</A>&nbsp;&raquo;&nbsp;版块详细设置</TD></TR></TBODY></TABLE><BR>
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
              <LI>实际访问权限由用户组的权限和此处的版块权限设置共同决定，即某一权限只有在用户组的权限和版块权限均许可的情况下才有效。</LI></UL></TD></TR></TBODY></TABLE><BR>
      <FORM id="settings" name="settings" onSubmit="checkfields(this); return false;" action="../perform.jsp" method=post>
	  <INPUT type=hidden name="act" value="forums_forum_info">
	  <INPUT type=hidden name="boardID" value="<%= boardID %>">
	  <INPUT type=hidden name="fromPath" value="<%= fromPath %>">
      <A name=tb01></A>
      <TABLE class=info_tb cellSpacing=0 cellPadding=0 width="100%" border=0>
        <TBODY>
        <TR class=header>
          <TD colSpan=2>版块基本设置<A onClick="collapse_change('tb01','../images')" href="#">
  		    <IMG id=menuimg_tb01 style="MARGIN-TOP: -12px; FLOAT: right; MARGIN-RIGHT: 4px" 
             src="../images/menu_reduce.gif" border=0></A></TD></TR>
        <TBODY id=menu_tb01>
        <TR>
          <TD class=altbg1 width="45%"><B>版块名称:</B></TD>
          <TD class=altbg2><INPUT size=50 value="" name="boardName"> </TD></TR>
        <TR>
          <TD class=altbg1 width="45%"><B>显示版块:</B><BR><SPAN 
            class=smalltxt>选择“否”将暂时隐藏版块不显示，但管理员和版主仍可见此版块，且用户仍可通过&nbsp;URL&nbsp;
			直接访问到此版块的内容。利用此功能可以将一些主题暂时隐藏</SPAN></TD>
          <TD class=altbg2>
		  	<INPUT class=radio type=radio CHECKED value="N" name="state" id="state[N]"> 是 &nbsp; &nbsp; 
			<INPUT class=radio type=radio value="I" name="state" id="state[I]"> 否 </TD></TR>
        <TR>
          <TD class=altbg1 width="45%"><B>所属分区:</B><BR><SPAN 
            class=smalltxt>本版块所属的分区</SPAN></TD>
          <TD class=altbg2>
		  	<SELECT name="sectionID"> 
<%
	if (sections != null)
	{
		SectionVO aSection = null;
		for (int i=0; i<sections.size(); i++)	
		{
			aSection = (SectionVO)sections.get(i);
%>			
				<OPTION value=<%= aSection.sectionID %>><%= aSection.sectionName %></OPTION> 
<%
		}
	}
%>
			</SELECT><INPUT type=hidden name="oldSectionID"></TD></TR>
        <TR>
          <TD class=altbg1 width="45%"><B>高亮显示色:</B><BR><SPAN 
            class=smalltxt>版块名称高亮显示的颜色值，以六位&nbsp;16&nbsp;进制值表示，空值表示以默认颜色显示版块名称</SPAN></TD>
          <TD class=altbg2><INPUT size=50 value="" name="highColor"> </TD></TR>
        <TR>
          <TD class=altbg1 vAlign=top width="45%"><B>版块简介:</B><BR><SPAN 
            class=smalltxt>将显示于版块列表中版块名称的下面，提供对本版块的简短描述，最多100个字符</SPAN></TD>
          <TD class=altbg2>
		    <TEXTAREA id="brief" name="brief" rows=3 cols=50 style="width:278px"></TEXTAREA></TD></TR>
        <TR>
          <TD class=altbg1 width="45%"><B>本版块关键词:</B><BR><SPAN 
            class=smalltxt>此关键词用于搜索引擎优化，放在 meta 的 keyword 标签中，多个关键字间请用半角逗号 "," 
            隔开</SPAN></TD>
          <TD class=altbg2><INPUT size=50 name="keywords" maxlength="100"></TD></TR>
	  </TBODY></TABLE><BR>
		<A name=tb03></A>
      <TABLE class=info_tb cellSpacing=0 cellPadding=0 width="100%" border=0>
        <TBODY>
        <TR class=header>
          <TD colSpan=2>扩展设置<A onClick="collapse_change('tb03','../images')" href="#">
		    <IMG id=menuimg_tb03 style="MARGIN-TOP: -12px; FLOAT: right; MARGIN-RIGHT: 4px" 
             src="../images/menu_reduce.gif" border=0></A></TD></TR>
        <TBODY id=menu_tb03>
        <TR>
          <TD class=altbg1 width="45%" valign="top"><B>本版块规则:</B><BR><SPAN 
            class=smalltxt>显示于主题列表页的当前版块规则&nbsp;HTML&nbsp;代码，留空为不显示</SPAN></TD>
          <TD class=altbg2>
		    <IMG onmouseover="this.style.cursor='pointer'" onclick="zoomtextarea('ruleCode', 1)" src="../images/zoomin.gif"> 
			<IMG onmouseover="this.style.cursor='pointer'" onclick="zoomtextarea('ruleCode', 0)" src="../images/zoomout.gif">
            <BR><TEXTAREA id="ruleCode" name="ruleCode" rows=6 cols=50 
				 style="width:278px"><%= aBoard.ruleCode==null?"":aBoard.ruleCode %></TEXTAREA></TD></TR>
        <TR>
          <TD class=altbg1 width="45%"><B>界面风格方案:</B><BR><SPAN 
            class=smalltxt>访问者进入本版块所使用的界面风格方案</SPAN></TD>
          <TD class=altbg2>
		   	<SELECT name="viewStyle">
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
          <TD class=altbg1 width="45%" valign="top"><B>主题默认排序方式:</B><BR><SPAN 
            class=smalltxt>设置版块的主题列表默认按哪个字段何种方式排序显示</SPAN></TD>
          <TD class=altbg2>
		  	<INPUT class=radio type=radio CHECKED value="lastPostTime" name="sortField" id="sortField[lastPostTime]"> 
			回复时间&nbsp;-&nbsp;降序 &nbsp; 
			<INPUT class=radio type=radio value="createTime" name="sortField" id="sortField[createTime]"> 
			发布时间&nbsp;-&nbsp;降序<BR>
			<INPUT class=radio type=radio value="A_lastPostTime" name="sortField" id="sortField[A_lastPostTime]"> 
			回复时间&nbsp;-&nbsp;升序 &nbsp; 
			<INPUT class=radio type=radio value="A_createTime" name="sortField" id="sortField[A_createTime]"> 
			发布时间&nbsp;-&nbsp;升序</TD></TR>
        <TR>
          <TD class=altbg1 width="45%"><B>允许使用 [img] 代码:</B><BR><SPAN 
            class=smalltxt>允许 [img] 代码作者将可以在帖子中插入图片并显示</SPAN></TD>
          <TD class=altbg2>
		  	<INPUT class=radio type=radio CHECKED value="T" name="isImageOK" id="isImageOK[T]"> 是 &nbsp; &nbsp; 
			<INPUT class=radio type=radio value="F" name="isImageOK" id="isImageOK[F]"> 否 </TD></TR>
        <TR>
          <TD class=altbg1 width="45%"><B>允许使用 [media] 代码:</B><BR><SPAN 
            class=smalltxt>允许 [media] 代码作者将可以在帖子中插入&nbsp;Flash&nbsp;或多媒体对象</SPAN></TD>
          <TD class=altbg2>
		  	<INPUT class=radio type=radio CHECKED value="T" name="isMediaOK" id="isMediaOK[T]"> 是 &nbsp; &nbsp; 
			<INPUT class=radio type=radio value="F" name="isMediaOK" id="isMediaOK[F]"> 否 </TD></TR>
        <TR>
          <TD class=altbg1 width="45%"><B>允许游客发贴:</B><BR><SPAN 
            class=smalltxt>是否允许游客在本版匿名发表主题和回复，游客的IP地址会被记录下来。</SPAN></TD>
          <TD class=altbg2>
		  	<INPUT class=radio type=radio value="T" name="isGuestPostOK" id="isGuestPostOK[T]"> 是 &nbsp; &nbsp; 
			<INPUT class=radio type=radio CHECKED value="F" name="isGuestPostOK" id="isGuestPostOK[F]"> 否 </TD></TR>
        <TR>
          <TD class=altbg1 width="45%" valign="top"><B>页首广告代码:</B><BR><SPAN 
            class=smalltxt>出现在本版块页面页首&nbsp;(logo 右侧)&nbsp;的广告&nbsp;HTML&nbsp;
				代码，若为空则以论坛全局广告设置为准</SPAN></TD>
          <TD class=altbg2>
		    <IMG onmouseover="this.style.cursor='pointer'" onclick="zoomtextarea('headAdCode', 1)" src="../images/zoomin.gif"> 
			<IMG onmouseover="this.style.cursor='pointer'" onclick="zoomtextarea('headAdCode', 0)" src="../images/zoomout.gif">
            <BR><TEXTAREA id="headAdCode" name="headAdCode" rows=6 cols=50 
				 style="width:278px"><%= aBoard.headAdCode==null?"":aBoard.headAdCode %></TEXTAREA></TD></TR>
        <TR>
          <TD class=altbg1 width="45%" valign="top"><B>页脚广告代码:</B><BR><SPAN 
            class=smalltxt>出现在本版块页面页脚的广告&nbsp;HTML&nbsp;
				代码，若为空则以论坛全局广告设置为准</SPAN></TD>
          <TD class=altbg2>
		    <IMG onmouseover="this.style.cursor='pointer'" onclick="zoomtextarea('footAdCode', 1)" src="../images/zoomin.gif"> 
			<IMG onmouseover="this.style.cursor='pointer'" onclick="zoomtextarea('footAdCode', 0)" src="../images/zoomout.gif">
            <BR><TEXTAREA id="footAdCode" name="footAdCode" rows=6 cols=50 
				 style="width:278px"><%= aBoard.footAdCode==null?"":aBoard.footAdCode  %></TEXTAREA> </TD></TR>
	</TBODY></TABLE><BR>
	<A name=tb04></A>
      <TABLE class=info_tb cellSpacing=0 cellPadding=0 width="100%" border=0>
        <TBODY>
        <TR class=header>
          <TD>版块权限</TD>
          <TD>浏览版块</TD>
          <TD>发新话题</TD>
          <TD>发表回复</TD>
          <TD>下载/查看附件</TD>
          <TD>上传附件</TD></TR>
<%
	if (groups != null)
	{
		GroupVO aGroup = null;
		String checked1 = null;
		String checked2 = null;
		String checked3 = null;
		String checked4 = null;
		String checked5 = null;
		String empty = "";
		String checked = null;
			
		for (int i=0; i<groups.size(); i++)	
		{
			aGroup = (GroupVO)groups.get(i);
			if (aBoard.allowGroups == null 
				|| aBoard.allowGroups.indexOf(String.valueOf(aGroup.groupID)) >= 0)
				checked = "checked";
			else
				checked = "";

			if (PageUtils.isPermitted(aBoard, aGroup, IConstants.PERMIT_VISIT_FORUM)) checked1 = "checked"; else checked1 = "";
			if (PageUtils.isPermitted(aBoard, aGroup, IConstants.PERMIT_NEW_TOPIC)) checked2 = "checked"; else checked2 = "";
			if (PageUtils.isPermitted(aBoard, aGroup, IConstants.PERMIT_NEW_REPLY)) checked3 = "checked"; else checked3 = "";
			if (PageUtils.isPermitted(aBoard, aGroup, IConstants.PERMIT_DOWNLOAD)) checked4 = "checked"; else checked4 = "";
			if (PageUtils.isPermitted(aBoard, aGroup, IConstants.PERMIT_UPLOAD)) checked5 = "checked"; else checked5 = "";
%>			
        <TR>
          <TD class=altbg1>
		  	<INPUT class=checkbox title=选中 type=checkbox <%= checked %>
				name="allowGroups" id="allowGroups[<%= aGroup.groupID %>]" 
				value="<%= aGroup.groupID %>" onclick="changeGroups('<%= aGroup.groupID %>')"/> <%= aGroup.groupName %></TD>
          <TD class=altbg2>&nbsp;&nbsp;&nbsp;<INPUT class=checkbox title=选中 type=checkbox <%= checked1 %>
				name="visitGroups" id="visitGroups[<%= aGroup.groupID %>]" 
				value="<%= aGroup.groupID %>" onclick="toggleGroups('<%= aGroup.groupID %>')"/></TD>
          <TD class=altbg1>&nbsp;&nbsp;&nbsp;<INPUT class=checkbox title=选中 type=checkbox <%= checked2 %>
				name="topicGroups" id="topicGroups[<%= aGroup.groupID %>]" 
				value="<%= aGroup.groupID %>" onclick="toggleGroups('<%= aGroup.groupID %>')"/></TD>
          <TD class=altbg2>&nbsp;&nbsp;&nbsp;<INPUT class=checkbox title=选中 type=checkbox <%= checked3 %>
				name="replyGroups" id="replyGroups[<%= aGroup.groupID %>]" 
				value="<%= aGroup.groupID %>" onclick="toggleGroups('<%= aGroup.groupID %>')"/></TD>
          <TD class=altbg1>&nbsp;&nbsp;&nbsp;<INPUT class=checkbox title=选中 type=checkbox <%= checked4 %>
				name="downloadGroups" id="downloadGroups[<%= aGroup.groupID %>]" 
				value="<%= aGroup.groupID %>" onclick="toggleGroups('<%= aGroup.groupID %>')"/></TD>
          <TD class=altbg2>&nbsp;&nbsp;&nbsp;<INPUT class=checkbox title=选中 type=checkbox <%= checked5 %>
				name="uploadGroups" id="uploadGroups[<%= aGroup.groupID %>]" 
				value="<%= aGroup.groupID %>" onclick="toggleGroups('<%= aGroup.groupID %>')"/></TD></TR>
<%
		}
	}
%>			
       </TBODY></TABLE><BR>
      <CENTER><INPUT class=button type=submit value="提 交"></CENTER></FORM>
	  </TD></TR></TBODY></TABLE><BR><BR>
<script language="javascript">
function checkfields(theform) {
	if (trim(theform.boardName.value) == '') {
		alert('板块名称不可以为空');
      	theform.sectionName.focus();
		return;
	}
	if ((trim(theform.brief.value)).length > 100) {
		alert('版块简介不能超过100个字符');
      	theform.brief.focus();
		return;
	}
	theform.submit();
}
function toggleGroups(id) {
	if ($('visitGroups['+id+']').checked || $('topicGroups['+id+']').checked
		|| $('replyGroups['+id+']').checked || $('downloadGroups['+id+']').checked || $('uploadGroups['+id+']').checked)
	{
		$('allowGroups['+id+']').checked = true;
	}
	else
	{
		$('allowGroups['+id+']').checked = false;
	}
}
function changeGroups(id) {
	if ($('allowGroups['+id+']').checked)
	{
		$('visitGroups['+id+']').checked = true;
		$('topicGroups['+id+']').checked = true;
		$('replyGroups['+id+']').checked = true;
		$('downloadGroups['+id+']').checked = true;
		$('uploadGroups['+id+']').checked = true;
	}
	else
	{
		$('visitGroups['+id+']').checked = false;
		$('topicGroups['+id+']').checked = false;
		$('replyGroups['+id+']').checked = false;
		$('downloadGroups['+id+']').checked = false;
		$('uploadGroups['+id+']').checked = false;
	}
}
$('settings').sectionID.value = "<%= sectionID %>";
$('settings').oldSectionID.value = "<%= sectionID %>";
$('settings').boardID.value = "<%= aBoard.boardID %>";
$('settings').boardName.value = "<%= aBoard.boardName %>";
$('settings').highColor.value = "<%= aBoard.highColor==null?"":aBoard.highColor %>";
$('state[<%= aBoard.state %>]').checked = "true";
$('settings').brief.value = "<%= aBoard.brief==null?"":aBoard.brief %>";
$('settings').keywords.value = "<%= aBoard.keywords==null?"":aBoard.keywords %>";
$('settings').viewStyle.value = "<%= aBoard.viewStyle==null?"default":aBoard.viewStyle %>";
$('sortField[<%= aBoard.sortField==null?"lastPostTime":aBoard.sortField %>]').checked = "true";
$('isImageOK[<%= aBoard.isImageOK %>]').checked = "true";
$('isMediaOK[<%= aBoard.isMediaOK %>]').checked = "true";
$('isGuestPostOK[<%= aBoard.isGuestPostOK %>]').checked = "true";
</script>	  
<%= PageUtils.getAdminFooter(request) %>
</BODY></HTML>
