<%

String ctxPath1 = request.getContextPath() + "/ejforum";
%>

<DIV id=header>
	<H2><A href="<%=ctxPath1%>"><IMG alt="unnamed" src="<%=ctxPath1%>/images/logo.gif" border=0></A></H2>
</DIV>
<DIV id=headermenu>
	<UL>
		<!-- <LI><CITE><A href="<%=ctxPath1 %>/uspace.jsp?uid=admin">admin</A></CITE></LI>
		<LI><A href="<%=ctxPath1 %>/member/sms_list.jsp">短消息</A></LI>
		<LI><A href="<%=ctxPath1 %>/feeds.jsp">订阅</A></LI>
		<LI><A href="<%=ctxPath1 %>/userlist.jsp">会员列表</A></LI> -->
		<LI><A href="<%=ctxPath1 %>/perform.jsp?act=lgt&sid=<%=(String)request.getAttribute("token")%>">退出</A></LI>
		<LI><A href="<%=ctxPath1 %>/advsearch.jsp">搜索</A></LI>
		<LI><A href="<%=ctxPath1 %>/member/my_topics.jsp">我的话题</A></LI>
		<LI><A href="<%=ctxPath1 %>/member/my_favors.jsp">我的收藏</A></LI>
		<!-- <LI class=dropmenu id=myspace onmouseover='showMenu(this.id)' style='BACKGROUND-POSITION:94%'><A href="<%=ctxPath1 %>/member/my_topics.jsp">我的空间</A></LI> -->
		<!-- <LI class=dropmenu id=stats onmouseover='showMenu(this.id)' style='BACKGROUND-POSITION:94%'><A href="<%=ctxPath1 %>/stat/baseinfo.jsp">统计</A></LI> -->
		<!-- <LI><A href="<%=ctxPath1 %>/admin/login.jsp" target="_blank">后台管理</A></LI> --> 
		<!-- <LI><A href="<%=ctxPath1 %>/help/index.jsp">帮助</A></LI> -->
	</UL>
</DIV> 
<UL class="popmenu_popup headermenu_popup" id=myspace_menu style="DISPLAY: none;">
	<LI><A href="uspace.jsp?uid=admin">个人信息页</A></LI>
	<LI><A href="member/my_profile.jsp">编辑个人资料</A></LI>
	<LI><A href="member/sms_list.jsp">短消息</A></LI>
	<LI><A href="member/my_topics.jsp">我的话题</A></LI>
	<LI><A href="member/my_favors.jsp">我的收藏</A></LI>
	<LI><A href="member/my_friends.jsp">我的好友</A></LI><LI><A href="//member/my_rights.jsp">我的权限</A></LI>
	<LI><A href="member/my_credits.jsp">积分交易记录</A></LI>
</UL>
<UL class="popmenu_popup headermenu_popup" id=stats_menu style="DISPLAY: none;">
	<LI><A href="<%=ctxPath1 %>/stat/baseinfo.jsp">基本概况</A> </LI>
	<LI><A href="<%=ctxPath1 %>/stat/flux.jsp">访问量记录</A> </LI>
	<LI><A href="<%=ctxPath1 %>/stat/top_boards.jsp">版块排行</A> </LI>
	<LI><A href="<%=ctxPath1 %>/stat/top_topics.jsp">主题排行</A> </LI>
	<LI><A href="<%=ctxPath1 %>/stat/top_credits_users.jsp">积分排行</A> </LI>
	<LI><A href="<%=ctxPath1 %>/stat/admins.jsp">管理团队</A> </LI>
</UL>