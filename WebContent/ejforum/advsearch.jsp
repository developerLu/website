<%@ page contentType="text/html;charset=gbk" errorPage="error.jsp"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="com.hongshee.ejforum.util.PageUtils"%>
<%@ page import="com.hongshee.ejforum.common.ForumSetting"%>
<%@ page import="com.hongshee.ejforum.common.CacheManager"%>
<%@ page import="com.hongshee.ejforum.common.IConstants"%>
<%@ page import="com.hongshee.ejforum.data.UserDAO.UserInfo"%>
<%@ page import="com.hongshee.ejforum.data.BoardDAO.BoardVO"%>
<%@ page import="com.hongshee.ejforum.data.SectionDAO.SectionVO"%>
<%@ page import="com.hongshee.ejforum.data.GroupDAO.GroupVO"%>
<%
	UserInfo userinfo = PageUtils.getSessionUser(request);

	GroupVO userGroup = PageUtils.getGroupVO(userinfo);
	if (userGroup.rights.indexOf(IConstants.PERMIT_VISIT_FORUM) < 0) {
		request.setAttribute("errorMsg", "很抱歉，您缺乏足够的访问权限");
		request.getRequestDispatcher("/error.jsp").forward(request,
				response);
		return;
	}

	boolean isModerator = false;
	if (userGroup.groupID == 'A' || userGroup.groupID == 'M'
			|| userGroup.groupID == 'S')
		isModerator = true;

	String ctxPath = request.getContextPath() + "/ejforum";
	String serverName = request.getServerName();
	if (!ctxPath.equals("/"))
		serverName = serverName + ctxPath;

	String forumName = ForumSetting.getInstance().getForumName();
	String title = PageUtils.getTitle(forumName);
	String[] menus = PageUtils.getHeaderMenu(request, userinfo);
	String homeUrl = "./index.jsp";
	String forumStyle = PageUtils
			.getForumStyle(request, response, null);

	CacheManager cache = CacheManager.getInstance();
	ArrayList sections = cache.getSections();
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<HTML xmlns="http://www.w3.org/1999/xhtml">
<HEAD>
<TITLE>搜索 - <%=title%></TITLE>
<LINK href="styles/<%=forumStyle%>/ejforum.css" type=text/css
	rel=stylesheet>
</HEAD>
<BODY onkeydown="if(event.keyCode==27) return false;"
	onload="clickgoogle()">
	<SCRIPT src="js/common.js" type=text/javascript></SCRIPT>
	<DIV class=wrap>
		<DIV id=header>
			<%=PageUtils.getHeader(request, title)%>
			<%=PageUtils.getHeadAdBanner(request, null)%>
		</DIV>
		<%=menus[0]%>
		<DIV id=nav>
			<A href="<%=homeUrl%>"><%=forumName%></A> &raquo;&nbsp; 论坛搜索
		</DIV>
		<FORM id=frmsearch action="search_result.jsp" method=post
			onsubmit="return validate(this)">
			<DIV class="mainbox formbox">
				<H1>论坛搜索</H1>
				<TABLE cellSpacing=0 cellPadding=0>
					<TBODY>
						<TR>
							<TH width="10%">搜索方式</TH>
							<TD width="40%"><LABEL><INPUT
									onclick="clickgoogle()" type=radio value=title name=searchfield
									id="searchfield_title"> 标题搜索</LABEL> <LABEL><INPUT
									onclick="clickgoogle()" type=radio value=content
									name=searchfield id="searchfield_content"> 全文搜索（主题+回复）</LABEL>
							</TD>
							<TD width="50%">最新的主题可能不会被搜索到</TD>
						</TR>
					</TBODY>
					<TBODY>
						<TR>
							<TH><LABEL for=keys>关键字</LABEL></TH>
							<TD><INPUT id=keys maxLength=50 size=60 name=keys></TD>
							<TD>多个关键字之间请用空格或逗号分隔, 比如&nbsp;"科幻 小说"&nbsp;表示同时包含这两个关键字</TD>
						</TR>
					</TBODY>
					<TBODY id=notgoogle1>
						<TR>
							<TH><LABEL for=uid>用户名</LABEL></TH>
							<TD><INPUT id=uid maxLength=50 size=60 name=uid></TD>
							<TD>用户名或用户昵称</TD>
						</TR>
					</TBODY>
					<TBODY id=notgoogle2>
						<TR>
							<TD vAlign=top><LABEL for=boardid>搜索范围</LABEL></TD>
							<TD><SELECT id=boardid style="width: 335px" name=boardid>
									<OPTION value="" selected>所有版块</OPTION>
									<OPTION value="">&nbsp;</OPTION>
									<%
										if (sections != null) {
											SectionVO tmpSection = null;
											BoardVO tmpBoard = null;
											StringBuilder sb = new StringBuilder();

											for (int i = 0; i < sections.size(); i++) {
												tmpSection = (SectionVO) sections.get(i);
												if (tmpSection.boardList == null)
													continue;
												sb.append("<OPTGROUP label=\"")
														.append(tmpSection.sectionName).append("\">\n");
												for (int j = 0; j < tmpSection.boardList.size(); j++) {
													tmpBoard = (BoardVO) tmpSection.boardList.get(j);
													if (tmpBoard.state == 'I' && !isModerator)
														continue;
													sb.append("<OPTION value=\"").append(tmpBoard.boardID)
															.append("\">&nbsp; &gt; ")
															.append(tmpBoard.boardName)
															.append("</OPTION>\n");
												}
												sb.append("</OPTGROUP>");
											}
											out.write(sb.toString());
										}
									%>
							</SELECT></TD>
							<TD>&nbsp;</TD>
						</TR>
					</TBODY>
					<TBODY>
						<TR class="btns">
							<TH>&nbsp;</TH>
							<TD height="30"><BUTTON class=submit name=searchsubmit
									type=submit>搜索</BUTTON></TD>
							<TD>&nbsp;</TD>
						</TR>
					</TBODY>
				</TABLE>
			</DIV>
		</FORM>
		<SCRIPT type=text/javascript>
function validate(theform) {
	if (trim(theform.keys.value) == '') {
		alert("请输入搜索关键字");
		theform.keys.focus();
		return false;
	}
	if($('searchfield_google').checked) {
		window.open("http://www.google.cn/search?ie=GB2312&oe=GB2312&hl=zh-CN&sitesearch="
       	         	+ "<%=serverName%>
			&q="
									+ trim(theform.keys.value));
					return false;
				}
				return true;
			}
			function clickgoogle() {
				if ($('searchfield_google').checked) {
					$('notgoogle1').style.display = 'none';
					$('notgoogle2').style.display = 'none';
				} else {
					$('notgoogle1').style.display = '';
					$('notgoogle2').style.display = '';
				}
			}
		</SCRIPT>
	</DIV>
</BODY>
</HTML>
