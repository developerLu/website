<%@ page contentType="text/html;charset=gbk"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="com.hongshee.ejforum.util.PageUtils"%>
<%@ page import="com.hongshee.ejforum.common.CacheManager"%>
<%@ page import="com.hongshee.ejforum.common.ForumSetting"%>
<%@ page import="com.hongshee.ejforum.common.IConstants"%>
<%@ page import="com.hongshee.ejforum.data.UserDAO.UserInfo"%>
<%@ page import="com.hongshee.ejforum.data.SectionDAO"%>
<%@ page import="com.hongshee.ejforum.data.SectionDAO.SectionVO"%>
<%@ page import="com.hongshee.ejforum.data.BoardDAO"%>
<%@ page import="com.hongshee.ejforum.data.BoardDAO.BoardVO"%>
<%@ page import="com.hongshee.ejforum.data.TopicDAO"%>
<%@ page import="com.hongshee.ejforum.data.ReplyDAO"%>
<%@ page import="com.hongshee.ejforum.data.GroupDAO"%>
<%@ page import="com.hongshee.ejforum.data.GroupDAO.GroupVO"%>
<%@ page import="com.hongshee.ejforum.data.UserDAO"%>
<%@ page import="com.hongshee.ejforum.data.TrashBoxDAO"%>
<%@ page import="com.hongshee.ejforum.data.ActionLogDAO"%>
<%@ page import="com.hongshee.ejforum.data.StatDAO"%>
<%@ page import="com.hongshee.ejforum.data.BookmarkDAO"%>
<%@ page import="com.hongshee.ejforum.data.ShortMsgDAO"%>
<%@ page import="com.hongshee.ejforum.data.TopicISO"%>
<%@ page import="com.hongshee.ejforum.data.AttachDAO"%>
<%@ page import="com.hongshee.ejforum.data.BackupDAO"%>
<%
	String adminPath = request.getContextPath() + "/admin";
	String fromPath = (String)request.getParameter("fromPath");
	if (fromPath == null)
		fromPath = PageUtils.getPathFromReferer(request);

	String msg = "Invalid parameter";
   	String act = request.getParameter("act");
	
	boolean redirect = true;
	try
	{
		PageUtils.checkReferer(request); // Enhance security
	    CacheManager cache = CacheManager.getInstance();

		if (act == null)
		{
			UserInfo userinfo = PageUtils.getAdminUser(request, response);
			if (userinfo == null) return;
			request.setAttribute("errorMsg", "请求参数错误");
			request.getRequestDispatcher("/admin/error.jsp").forward(request, response);
			return;
		}
		else if (act.equals("lgt"))
		{
			UserInfo userinfo = PageUtils.getLoginedUser(request, response);
			if (userinfo == null) return;
			userinfo.isAdminOn = false;
			response.sendRedirect(adminPath + "/login.jsp");
			return;
		}
		else if (act.startsWith("forums_"))
		{
			UserInfo userinfo = PageUtils.getAdminUser(request, response);
			if (userinfo == null) return;
			
			act = act.substring(7);
			
			if (userinfo.groupID != 'A')
			{
				if (!act.equals("trash_restore") && !act.equals("trash_restore_all"))
				{
					request.setAttribute("errorMsg", "管理权限不足");
					request.getRequestDispatcher("/admin/error.jsp").forward(request, response);
					return;
				}
			}
			
			if (act.equals("forum_edit"))
			{
				SectionDAO.getInstance().modifySeqno(request);
    	        cache.loadSections();
				msg = "修改显示顺序成功。";
			}
			else if (act.equals("forum_info"))
			{
				BoardDAO.getInstance().updateBoard(request);
				msg = "修改板块成功。";
			}
			else if (act.equals("forum_add"))
			{
				BoardDAO.getInstance().addBoard(request);
    	        cache.loadSections();
				msg = "添加板块成功。";
			}
			else if (act.equals("section_add"))
			{
				SectionDAO.getInstance().addSection(request);
    	        cache.loadSections();
				msg = "添加分区成功。";
			}
			else if (act.equals("forum_merge"))
			{
				String sourceID = request.getParameter("sourceBoard");
				String targetID = request.getParameter("targetBoard");
				BoardDAO.getInstance().mergeBoards(sourceID, targetID);
    	        cache.loadSections();
				msg = "合并板块成功。";
			}
			else if (act.equals("section_edit"))
			{
				SectionDAO.getInstance().updateSection(request);
				msg = "修改分区成功。";
			}
			else if (act.equals("forum_copy"))
			{
				BoardDAO.getInstance().copyBoardInfo(request);
    	        cache.loadSections();
				msg = "复制板块设置成功。";
			}
			else if (act.equals("forum_moderator"))
			{
				String sectionID = request.getParameter("sid");
				String boardID = request.getParameter("fid");
	            String moderator = PageUtils.getParam(request,"moderator").replace(" ","").toLowerCase();
				if (boardID == null || boardID.trim().length() == 0)
                    msg = SectionDAO.getInstance().modifyModerator(sectionID, moderator);
				else
        	        msg = BoardDAO.getInstance().modifyModerator(sectionID, boardID, moderator);

				if (msg.equals("OK"))
					msg = "更新版主成功。";
				else
					redirect = false;
			}
			else if (act.equals("section_delete"))
			{
				String sectionID = request.getParameter("sid");
				SectionVO aSection = cache.getSection(sectionID);
				if (aSection != null && aSection.boardList != null && aSection.boardList.size() > 0)
				{
					request.setAttribute("errorMsg", "下级版块不为空，请先返回删除本分区的下级版块。");
					request.getRequestDispatcher("/admin/error.jsp").forward(request, response);
					return;
				}
                SectionDAO.getInstance().deleteSection(sectionID);
				fromPath = adminPath + "/forums/forum_edit.jsp";
				msg = "删除分区成功。";
			}
			else if (act.equals("board_delete"))
			{
				String sectionID = request.getParameter("sid");
				String boardID = request.getParameter("fid");
				BoardDAO.getInstance().deleteBoard(sectionID, boardID);
				fromPath = adminPath + "/forums/forum_edit.jsp";
				msg = "删除板块成功。";
			}
			else if (act.equals("topic_batch"))
			{
				TopicDAO.getInstance().modifyTopics(request);
				msg = "批量主题管理操作成功。";
				redirect = false;
				fromPath = "javascript:history.go(-1);";
			}
			else if (act.equals("post_batch"))
			{
				ReplyDAO.getInstance().deleteReplies(request);
				msg = "批量删除帖子成功。";
				redirect = false;
				fromPath = "javascript:history.go(-1);";
			}
			else if (act.equals("trash_delete"))
			{
				TrashBoxDAO.getInstance().deleteTrash(request);
				msg = "删除回收站帖子成功。";
				redirect = false;
				fromPath = "javascript:history.go(-1);";
			}
			else if (act.equals("trash_archive"))
			{
				TrashBoxDAO.getInstance().archiveTrash(request);
				msg = "归档回收站帖子成功。";
				redirect = false;
				fromPath = "javascript:history.go(-1);";
			}
			else if (act.equals("trash_restore"))
			{
				TrashBoxDAO.getInstance().restoreTrash(request);
				msg = "还原回收站帖子成功。";
				redirect = false;
				fromPath = "javascript:history.go(-1);";
			}
			else if (act.equals("trash_delete_all"))
			{
				TrashBoxDAO.getInstance().deleteTrashes(request);
				msg = "删除回收站帖子成功。";
				redirect = false;
				fromPath = "javascript:history.go(-1);";
			}
			else if (act.equals("trash_archive_all"))
			{
				TrashBoxDAO.getInstance().archiveTrashes(request);
				msg = "归档回收站帖子成功。";
				redirect = false;
				fromPath = "javascript:history.go(-1);";
			}
			else if (act.equals("trash_restore_all"))
			{
				TrashBoxDAO.getInstance().restoreTrashes(request);
				msg = "还原回收站帖子成功。";
				redirect = false;
				fromPath = "javascript:history.go(-1);";
			}
		}
		else if (act.startsWith("users_"))
		{
			UserInfo userinfo = PageUtils.getAdminUser(request, response);
			if (userinfo == null) return;

			act = act.substring(6);
			
			if (act.startsWith("group_") && userinfo.groupID != 'A')
			{
				request.setAttribute("errorMsg", "管理权限不足");
				request.getRequestDispatcher("/admin/error.jsp").forward(request, response);
				return;
			}
			
    	    GroupVO aGroup = PageUtils.getGroupVO(userinfo, cache.getModerators());
			
			if (act.equals("user_group"))
			{
				if (aGroup.rights.indexOf(IConstants.PERMIT_EDIT_USER) < 0)
				{
					request.setAttribute("errorMsg", "管理权限不足");
					request.getRequestDispatcher("/admin/error.jsp").forward(request, response);
					return;
				}
				msg = UserDAO.getInstance().modifyGroup(request);
				if (msg.equals("OK"))
					msg = "修改用户管理组属性成功。";
				redirect = false;
				fromPath = "javascript:history.go(-2);";
			}
			else if (act.equals("user_credits"))
			{
				if (aGroup.rights.indexOf(IConstants.PERMIT_EDIT_CREDITS) < 0)
				{
					request.setAttribute("errorMsg", "管理权限不足");
					request.getRequestDispatcher("/admin/error.jsp").forward(request, response);
					return;
				}
				UserDAO.getInstance().modifyCredits(request);
				msg = "积分奖惩执行成功。";
				redirect = false;
				fromPath = "javascript:history.go(-2);";
			}
			else if (act.equals("user_ban"))
			{
				if (aGroup.rights.indexOf(IConstants.PERMIT_BAN_USER) < 0)
				{
					request.setAttribute("errorMsg", "管理权限不足");
					request.getRequestDispatcher("/admin/error.jsp").forward(request, response);
					return;
				}
				UserDAO.getInstance().modifyStates(request);
				msg = "用户状态变更执行成功。";
				redirect = false;
				fromPath = "javascript:history.go(-2);";
			}
			else if (act.equals("user_delete"))
			{
				if (aGroup.rights.indexOf(IConstants.PERMIT_DELETE_USER) < 0)
				{
					request.setAttribute("errorMsg", "管理权限不足");
					request.getRequestDispatcher("/admin/error.jsp").forward(request, response);
					return;
				}
				UserDAO.getInstance().deleteUsers(request);
				msg = "删除用户执行成功。";
				redirect = false;
				fromPath = "javascript:history.go(-2);";
			}
			else if (act.equals("user_noavatar"))
			{
				if (aGroup.rights.indexOf(IConstants.PERMIT_EDIT_USER) < 0)
				{
					request.setAttribute("errorMsg", "管理权限不足");
					request.getRequestDispatcher("/admin/error.jsp").forward(request, response);
					return;
				}
				UserDAO.getInstance().deleteAvatars(request);
				msg = "删除用户头像执行成功。";
				redirect = false;
				fromPath = "javascript:history.go(-2);";
			}
			else if (act.equals("user_audit"))
			{
				if (aGroup.rights.indexOf(IConstants.PERMIT_AUDIT_USER) < 0)
				{
					request.setAttribute("errorMsg", "管理权限不足");
					request.getRequestDispatcher("/admin/error.jsp").forward(request, response);
					return;
				}
				UserDAO.getInstance().auditUsers(request);
				msg = "审核新用户成功。";
			}
			else if (act.equals("group_info"))
			{
				GroupDAO.getInstance().modifyRights(request);
				msg = "修改用户组权限成功。";
			}
			else if (act.equals("group_member"))
			{
				msg = GroupDAO.getInstance().updateMemberGroups(request);
				if (msg.equals("OK"))
				{
    		        cache.loadGroups();
					msg = "修改会员用户组成功。";
				}
				else
					redirect = false;
			}
			else if (act.equals("group_delete"))
			{
				String groupID = request.getParameter("id");
				GroupDAO.getInstance().deleteGroup(groupID);
				fromPath = adminPath + "/users/group_member.jsp";
				msg = "删除会员组成功。";
			}
		}
		else if (act.startsWith("tools_"))
		{
			UserInfo userinfo = PageUtils.getAdminUser(request, response);
			if (userinfo == null) return;

			if (userinfo.groupID != 'A')
			{
				request.setAttribute("errorMsg", "管理权限不足");
				request.getRequestDispatcher("/admin/error.jsp").forward(request, response);
				return;
			}
			
			act = act.substring(6);
			if (act.equals("send_notice"))
			{
				UserDAO.getInstance().sendNotice(request);
				msg = "发送论坛通知成功。";
				redirect = false;
				fromPath = "javascript:history.go(-1);";
			}
			else if (act.equals("manage_data"))
			{
				TopicDAO.getInstance().replaceContent(request);
				msg = "内容替换执行完毕。";
				redirect = false;
				fromPath = "javascript:history.go(-1);";
			}
			else if (act.equals("backup_new") || act.equals("backup_setting") || act.equals("backup_data"))
			{
				BackupDAO.getInstance().addTask(request);
				fromPath = adminPath + "/tools/backup_data.jsp";
				msg = "新建备份任务执行成功。";
			}
			else if (act.equals("backup_mod"))
			{
				BackupDAO.getInstance().updateTask(request);
				fromPath = adminPath + "/tools/backup_data.jsp";
				msg = "修改备份任务执行成功。";
			}
			else if (act.equals("check_expired"))
			{
				TopicDAO.getInstance().checkExpireDate();
				msg = "检查主题过期属性执行完毕。";
				redirect = false;
				fromPath = "javascript:history.go(-1);";
			}
			else if (act.equals("stat_forum_visits"))
			{
				StatDAO.getInstance().statVisits();
				msg = "统计论坛的访问量执行完毕。";
				redirect = false;
				fromPath = "javascript:history.go(-1);";
			}
			else if (act.equals("load_hot_links"))
			{
			        cache.loadSpecTopics("recent");
    	        		cache.loadSpecTopics("hot");
				cache.loadSpecTopics("rank");
            			cache.loadSpecTopics("digest");
				msg = "刷新主题推介区的主题列表执行完毕。";
				redirect = false;
				fromPath = "javascript:history.go(-1);";
			}
			else if (act.equals("clean_sms"))
			{
				ShortMsgDAO.getInstance().cleanOverflowMsgs();
				msg = "清理短消息执行完毕。";
				redirect = false;
				fromPath = "javascript:history.go(-1);";
			}
			else if (act.equals("clean_favors"))
			{
				BookmarkDAO.getInstance().cleanOverflowMarks();
				msg = "清理收藏夹记录执行完毕。";
				redirect = false;
				fromPath = "javascript:history.go(-1);";
			}
			else if (act.equals("index_topics"))
			{
				TopicISO.getInstance().buildTopicsIndex();
				msg = "重建全文索引的任务已经启动，此任务需要一段时间才会执行完毕。";
				redirect = false;
				fromPath = "javascript:history.go(-1);";
			}
			else if (act.equals("clean_trashbox"))
			{
				TrashBoxDAO.getInstance().cleanExpiredTrashes();
				msg = "清理过期的垃圾箱记录执行完毕。";
				redirect = false;
				fromPath = "javascript:history.go(-1);";
			}
			else if (act.equals("clean_logs"))
			{
				ActionLogDAO.getInstance().cleanExpiredLogs();
				msg = "清理过期的日志记录执行完毕。";
				redirect = false;
				fromPath = "javascript:history.go(-1);";
			}
			else if (act.equals("stat_board_posts"))
			{
				BoardDAO.getInstance().statBoardInfo();
				msg = "重新统计版块数据执行完毕。";
				redirect = false;
				fromPath = "javascript:history.go(-1);";
			}
			else if (act.equals("clean_attaches"))
			{
				AttachDAO.getInstance().cleanRecycledAttaches();
				msg = "清理附件记录与文件执行完毕。";
				redirect = false;
				fromPath = "javascript:history.go(-1);";
			}
			else if (act.equals("daily_backup"))
			{
				BackupDAO.getInstance().execBackupTasks("D");
				msg = "数据备份任务执行完毕。";
				redirect = false;
				fromPath = "javascript:history.go(-1);";
			}
			else if (act.equals("weekly_backup"))
			{
				BackupDAO.getInstance().execBackupTasks("W");
				msg = "数据备份任务执行完毕。";
				redirect = false;
				fromPath = "javascript:history.go(-1);";
			}
		}
		else if (act.startsWith("basic_"))
		{
			UserInfo userinfo = PageUtils.getAdminUser(request, response);
			if (userinfo == null) return;

			if (userinfo.groupID != 'A')
			{
				request.setAttribute("errorMsg", "管理权限不足");
				request.getRequestDispatcher("/admin/error.jsp").forward(request, response);
				return;
			}

			act = act.substring(6);
			if (act.equals("censor"))
			{
				ForumSetting setting = ForumSetting.getInstance();
				setting.setOptions(ForumSetting.CENSOR, PageUtils.getParam(request,"badwords"));
				msg = "论坛选项更新成功。";
			}
			else if (act.equals("styles"))
			{
				ForumSetting setting = ForumSetting.getInstance();
				String[] used = request.getParameterValues("used");
				String[] styleIDs = request.getParameterValues("styleID");
				String[] styleNames = request.getParameterValues("styleName");
				StringBuilder styles = new StringBuilder();
				char isSelected = '1';
				for (int i=0; i<styleIDs.length; i++)
				{
					isSelected = '0';
					for (int j=0; j<used.length; j++)
					{
						if (used[j].equals(styleIDs[i]))
						{
							isSelected = '1';
							break;
						}
					}
					styles.append(isSelected).append('_').append(PageUtils.decodeParam(styleIDs[i], request));
					styles.append('=').append(PageUtils.decodeParam(styleNames[i], request)).append('\n');
				}
				setting.setOptions(ForumSetting.STYLES, styles.toString().trim());
				msg = "论坛选项更新成功。";
			}
			else if (act.equals("style_info"))
			{
				ForumSetting setting = ForumSetting.getInstance();
				setting.setStyleValues(request);
				msg = "界面风格更新成功。";
			}			
			else
			{
				ForumSetting setting = ForumSetting.getInstance();
				setting.setValues(act, request);
				msg = "论坛选项更新成功。";
			}
		}
	}
	catch(Throwable t)
	{
		String errorMsg = "服务端出现异常 - &nbsp;" + t.getMessage();
		PageUtils.log(request, "admin: " + act, errorMsg, t);
		request.setAttribute("errorMsg", errorMsg);
		request.getRequestDispatcher("/admin/error.jsp").forward(request, response);
		return;
	}
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<HTML xmlns="http://www.w3.org/1999/xhtml">
<HEAD><META http-equiv=Content-Type content="text/html; charset=gbk">
<LINK href="<%= adminPath %>/style/admin.css" type=text/css rel=stylesheet>
<script src="<%= adminPath %>/js/admin.js" type="text/javascript"></script>
</HEAD>
<BODY leftmargin="10" topmargin="10">
<table width="100%" border="0" cellpadding="2" cellspacing="6">
<tr><td>
	<table width="100%" border="0" cellpadding="0" cellspacing="0" class="guide">
	<tr><td><a href="#" 
		onClick="parent.location='<%= adminPath %>/index.htm'; return false;">后台首页</a>&nbsp;&raquo;&nbsp;提示信息
	</td></tr>
	</table><br /><br /><br /><br /><br /><br /><br />
	<table width="500" border="0" cellpadding="0" cellspacing="0" align="center" class="info_tb">
	<tr class="header"><td>提示信息</td></tr>
	<tr><td class="altbg2">
		<div align="center">
		<br /><br /><br /><%= msg %><br /><br /><br />
<% if (redirect) { %>
		<a href="<%= fromPath %>" class="mediumtxt">[&nbsp;如果您的浏览器没有自动跳转，请点击这里&nbsp;]</a>
		<script>setTimeout("redirect('<%= fromPath %>');", 1500);</script>
<% } else { %>
		<a href="<%= fromPath %>" class="mediumtxt">[&nbsp;点击这里返回上一页&nbsp;]</a>
<% } %>
		<br/><br/></div>
		<br /><br />
	</td></tr></table>
	<br /><br /><br />
</td></tr></table>
<br/><br/>
<%= PageUtils.getAdminFooter(request) %>
</BODY></HTML>