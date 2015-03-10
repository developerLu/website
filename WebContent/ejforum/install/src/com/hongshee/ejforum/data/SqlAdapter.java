package com.hongshee.ejforum.data;

/**
 * <p>Title: SqlAdapter.java</p>
 * <p>Description: Standard sql stamement wrapper</p>
 * <p>Copyright: Hongshee Software (c) 2007</p>
 * @author jackie du
 * @version 1.0
 */

public abstract class SqlAdapter 
{
    protected SqlAdapter(){}

    /**
     * Do initialization according to different database
     * @param none
     * @return none
     * @throws Exception
     * @since 1.0
     */
    public abstract void init() throws Exception;

    /**
     * Append paging statement to query sql
     * @param
     *      sqlBuf - Original query sql
     *      pageNo - page number
     *      pageRows - each page size
     *      totalCount - total result count
     * @return 
     *      Paging query sql 
     * @throws none
     * @since 1.0
     */
    public abstract String getPageQuerySql(StringBuilder sqlBuf,
                                           int pageNo, int pageRows, int totalCount);

    /**
     * Get paging statement query parameters
     * @param
     *      pageNo - page number
     *      pageRows - each page size
     *      totalCount - total result count
     * @return 
     *      An int[2] result array which has following meaning:
     *      result[0] - 1st page parameter relative to getPageQuerySql function 
     *      result[1] - 2nd page parameter relative to getPageQuerySql function 
     * @throws none
     * @since 1.0
     */
    protected abstract int[] getPageQueryParams(int pageNo, int pageRows, int totalCount);
    
    // Group
    public String Group_Insert = 
        "insert into ejf_group(groupID,groupName,groupType,minCredits," +
        "stars,rights,createTime) values(?,?,?,?,?,?,NOW())";
    
    public String Group_Update = 
        "update ejf_group set groupName=?,minCredits=?,stars=?," +
        "updateTime=NOW() where groupID=?";
    
    public String Group_ModRights = 
        "update ejf_group set rights=?,updateTime=NOW() where groupID=?";
    
    public String Group_Delete = 
        "delete from ejf_group where groupID=?";
    
    public String Group_RemoveMembers = 
        "delete from ejf_group where groupType='M'";
    
    public String Group_SelectAll = 
        "select * from ejf_group order by groupType DESC,minCredits ASC,stars DESC";
    
    // User
    public String User_Insert = 
        "insert into ejf_user(userID,nickname,pwd,email,icq,webpage,gender,birth,city," +
        "remoteIP,brief,isMailPub,groupID,credits,state,lastVisited,createTime) " +
        "values(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,NOW(),NOW())";
    
    public String User_Update = 
        "update ejf_user set nickname=?,email=?,icq=?,webpage=?,gender=?,birth=?," + 
        "city=?,isMailPub=?,updateTime=NOW() where userID=?";
    
    public String User_ModSpecInfo = 
        "update ejf_user set avatar=?,brief=?,updateTime=NOW() " + 
        "where userID=?";
    
    public String User_Login = 
        "select pwd,state,loginCount,updateTime," +
        "nickname,posts,unreadSMs,credits,groupID,lastVisited " +
        "from ejf_user where userID=?";
    
    public String User_QuickLogin = 
        "select loginExpire,nickname,posts,unreadSMs,credits,groupID,lastVisited,state " +
        "from ejf_user where userID=?";
    
    public String User_ModPasswd = 
        "update ejf_user set pwd=?,loginCount=0,updateTime=NOW() where userID=?";
    
    public String User_ModLastVisited = 
        "update ejf_user set visitCount=visitCount+1,lastVisited=NOW() " +
        "where userID=?";
    
    public String User_ModLoginCount = 
        "update ejf_user set loginCount=?,updateTime=NOW() where userID=?";
    
    public String User_ModLoginExpire = 
        "update ejf_user set loginCount=?,loginExpire=?,visitCount=visitCount+1," +
        "lastVisited=NOW(),updateTime=NOW() where userID=?";

    public String User_ClearLoginExpire = 
        "update ejf_user set loginExpire=?,updateTime=NOW() where userID=?";
    
    public String User_ModSetpwdExpire = 
        "update ejf_user set setpwdExpire=? where userID=?";
    
    public String User_IncPosts = 
        "update ejf_user set posts=posts+1 where userID=?";

    public String User_DecPostsAndCredits = 
        "update ejf_user set posts=posts-1,credits=credits-? where posts>0 and userID=?";

    public String User_IncCredits = 
        "update ejf_user set credits=credits+? where userID=?";

    public String User_DecCredits = 
        "update ejf_user set credits=credits-? where userID=?";
    
    public String User_IncUnreadSMs = 
        "update ejf_user set unreadSMs=unreadSMs+1 where userID=?";
    
    public String User_DecUnreadSMs = 
        "update ejf_user set unreadSMs=unreadSMs-1 where unreadSMs>0 and userID=?";
    
    public String User_StatUnreadSMs = 
        "update ejf_user set unreadSMs=? where userID=?";

    public String User_Delete = 
        "delete from ejf_user where userID=?";

    public String User_CleanExpired = 
        "delete from ejf_user where lastVisited < ? and posts = 0";
    
    public String User_Select = 
        "select * from ejf_user where userID=?";
    
    public String User_IsExistedID = 
        "select COUNT(*) from ejf_user where userID=?";
    
    public String User_IsExistedMail = 
        "select COUNT(*) from ejf_user where email=?";
    
    public String User_GetMailFromID = 
        "select email from ejf_user where userID=?";
    
    public String User_GetIDFromMail = 
        "select userID from ejf_user where email=?";
    
    public String User_GetSetpwdExpire = 
        "select setpwdExpire from ejf_user where userID=?";
    
    public String User_QueryInfo = 
        "select userID,nickname,posts,credits,groupID,state from ejf_user";

    public String User_GetList = 
        "select userID,nickname,gender,credits,posts,groupID,state,lastVisited," +
        "createTime from ejf_user where state<>'A' and state<>'S'";

    public String User_GetAuditHandler = 
        "select userID,email from ejf_user " +
        "where state<>'A' and state<>'S' and groupID in";

    public String User_GetReportHandler = 
        "select userID,email from ejf_user " +
        "where state<>'A' and state<>'S' and (groupID='A'";
    
    public String User_GetCount = 
        "select COUNT(*) from ejf_user where state<>'A' and state<>'S'";
    
    public String User_ModGroupID = 
        "update ejf_user set groupID=?,updateTime=NOW() where userID=?";

    public String User_ModState = 
        "update ejf_user set state=?,updateTime=NOW()";

    public String User_GetAuditing = 
        "select userID,remoteIP,email,createTime from ejf_user where state='A'";
    
    // Section
    public String Section_Insert = 
        "insert into ejf_section(sectionName,seqno,cols,createTime) values(?,?,?,NOW())";
    
    public String Section_Update = 
        "update ejf_section set sectionName=?,cols=?,updateTime=NOW() where sectionID=?";
    
    public String Section_ModSeqno = 
        "update ejf_section set seqno=?,updateTime=NOW() where sectionID=?";
    
    public String Section_ModModerator = 
        "update ejf_section set moderator=?,updateTime=NOW() where sectionID=?";
    
    public String Section_Delete = 
        "delete from ejf_section where sectionID=?";
    
    public String Section_SelectAll = 
        "select sectionID,sectionName,seqno,cols,moderator " + 
        "from ejf_section order by seqno ASC";
    
    public String Section_SelectBoards = 
        "select a.sectionID,a.seqno as s_seqno," + 
        "b.boardID,b.boardName,b.highColor,b.seqno,b.brief,b.keywords,b.moderator," +
        "b.viewStyle,b.sortField,b.isImageOK,b.isMediaOK,b.isGuestPostOK,b.allowGroups," +
        "b.acl,b.ruleCode,b.headAdCode,b.footAdCode,b.state from ejf_section a,ejf_board b " +
        "where b.sectionID = a.sectionID order by s_seqno ASC,b.seqno ASC";

    // Board
    public String Board_Insert = 
        "insert into ejf_board(sectionID,boardName,seqno,createTime) values(?,?,?,NOW())";
    
    public String Board_Update = 
        "update ejf_board set sectionID=?,boardName=?,highColor=?,brief=?,keywords=?," +
        "viewStyle=?,sortField=?,isImageOK=?,isMediaOK=?,isGuestPostOK=?,allowGroups=?," +
        "acl=?,ruleCode=?,headAdCode=?,footAdCode=?,state=?,updateTime=NOW() where boardID=?";

    public String Board_CopyInfo = 
        "update ejf_board set viewStyle=?,sortField=?,isImageOK=?,isMediaOK=?,isGuestPostOK=?," +
        "allowGroups=?,acl=?,ruleCode=?,headAdCode=?,footAdCode=?,updateTime=NOW() where boardID=?";
    
    public String Board_ModSeqno = 
        "update ejf_board set seqno=?,updateTime=NOW() where boardID=?";
    
    public String Board_ModModerator = 
        "update ejf_board set moderator=?,updateTime=NOW() where boardID=?";
    
    public String Board_Delete = 
        "delete from ejf_board where boardID=?";

    public String Board_StatTopics = 
        "select boardID,COUNT(topicID) as topics,SUM(replies) as posts," +
        "MAX(topicID) as lastTopicID from ejf_topic " +
        "where state <> 'R' group by boardID";

    public String Board_StatTodayTopics = 
        "select boardID,COUNT(topicID) as topics " +
        "from ejf_topic where createTime > ? and state<>'R' group by boardID";

    public String Board_StatTodayReplies = 
        "select a.boardID,COUNT(b.replyID) as replies from ejf_topic a, ejf_reply b " +
        "where a.topicID = b.topicID and b.createTime > ? " +
        "and a.state<>'R' and b.state<>'R' group by a.boardID";
    
    public String Board_GetLastTopic = 
        "select boardID,topicID,title,lastPostUser,lastNickname,lastPostTime from ejf_topic " +
        "where state<>'R' and topicID in";
    
    public String Board_RemoveTopics = 
        "delete from ejf_topic where boardID=?";
    
    public String Board_RemoveTrashs = 
        "delete from ejf_trash_box where boardID=?";
    
    //public String Board_RemoveBookmarks = 
        //"delete from ejf_bookmark where boardID=?";
    
    public String Board_MoveTopics = 
        "update ejf_topic set sectionID=?,boardID=? where boardID=?";
    
    public String Board_MoveTrashs = 
        "update ejf_trash_box set boardID=? where boardID=?";
    
    // Topic
    public String Topic_Insert = 
        "insert into ejf_topic(sectionID,boardID,userID,nickname,remoteIP,title,content," +
        "reward,isReplyNotice,isHidePost,attaches,attachIcon,lastPostUser,lastNickname,topScope," +
        "lastPostTime,createTime) values(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,NOW(),NOW())";
    
    public String Topic_Update = 
        "update ejf_topic set reward=?,title=?,content=?,isReplyNotice=?,isHidePost=?," +
        "attaches=?,attachIcon=?,topScope=?,updateUser=?,updateTime=NOW() where topicID = ?";
    
    public String Topic_ModRemoteIP = 
        "update ejf_topic set remoteIP=?,nickname=? where topicID = ?";
    
    public String Topic_ModTopScope = 
        "update ejf_topic set topScope=?,topExpireDate=? where topicID = ?";

    public String Topic_ModIsDigest = 
        "update ejf_topic set isDigest=? where topicID = ?";
    
    public String Topic_ModState = 
        "update ejf_topic set state=? where topicID = ?";

    public String Topic_ModSection = 
        "update ejf_topic set sectionID=? where boardID=?";
    
    public String Topic_Delete = 
        "update ejf_topic set state='R' where topicID = ?";

    public String Topic_Remove = 
        "delete from ejf_topic where topicID = ?";

    public String Topic_Archive = 
        "insert into ejf_archive_topic select * from ejf_topic where topicID = ?";
    
    public String Topic_GetList = 
        "select sectionID,boardID,topicID,userID,nickname,title,reward,visits,replies," +
        "isDigest,isHidePost,isSolved,attachIcon,topScope,highColor," +
        "lastPostUser,lastNickname,lastPostTime,createTime,state " + 
        "from ejf_topic where ((boardID = ?) " +
        "or (topScope = '2' and boardID <> ? and sectionID = ?) " +
        "or (topScope = '1' and boardID <> ?)) and state <> 'R'";

    public String Topic_GetCount = 
        "select COUNT(*) from ejf_topic where ((boardID = ?) " +
        "or (topScope = '2' and boardID <> ? and sectionID = ?) " +
        "or (topScope = '1' and boardID <> ?)) and state <> 'R'";

    public String Topic_GetManageInfo = 
        "select isDigest,topScope,topExpireDate,highColor,highExpireDate,state " + 
        "from ejf_topic where topicID = ?";
    
    public String Topic_Index = 
        "select topicID,boardID,userID,nickname,title,content " + 
        "from ejf_topic where state <> 'R'";
    
    public String Topic_Search = 
        "select sectionID,boardID,topicID,userID,nickname,title,reward,visits,replies," +
        "isDigest,isHidePost,isSolved,attachIcon,createTime,state " + 
        "from ejf_topic where state <> 'R' and topicID in";

    public String Topic_GetListBySpec = 
        "select sectionID,boardID,topicID,userID,nickname,title,reward,visits,replies," +
        "topScope,isDigest,isHidePost,isSolved,attachIcon,lastPostTime,createTime,state " + 
        "from ejf_topic where state <> 'R'";

    public String Topic_GetFeedListBySpec = 
        "select sectionID,boardID,topicID,userID,nickname,title,reward,visits,replies," +
        "content,topScope,isDigest,isHidePost,attachIcon,lastPostTime,createTime,state " + 
        "from ejf_topic where state <> 'R'";
    
    public String Topic_GetCountBySpec = 
        "select COUNT(*) from ejf_topic where state <> 'R'";
    
    public String Topic_GetListByUser = 
        "select sectionID,boardID,topicID,userID,nickname,title,reward,visits,replies," +
        "isDigest,isSolved,attachIcon,lastPostUser,lastNickname,lastPostTime,createTime,state " + 
        "from ejf_topic where userID = ?";

    public String Topic_GetCountByUser = 
        "select COUNT(*) from ejf_topic where userID = ?";
    
    public String Topic_Select = 
        "select a.sectionID,a.boardID,a.title,a.content,a.replies,a.reward," +
        "a.isReplyNotice,a.isHidePost,a.isDigest,a.attaches," +
        "a.topScope,a.createTime,a.state,a.updateUser,a.updateTime,a.remoteIP," +
        "a.userID,b.nickname,b.avatar,b.brief,b.posts,b.credits,b.groupID " + 
        "from ejf_topic a LEFT JOIN ejf_user b on a.userID = b.userID " +
        "where a.topicID = ?";

    public String Topic_GetLogInfo = 
        "select topicID,boardID,title,userID,attaches from ejf_topic where topicID in"; // (?)

    public String Topic_MoveTo = 
        "update ejf_topic set sectionID=?,boardID=? where topicID=?";

    public String Topic_Highlight = 
        "update ejf_topic set highColor=?,highExpireDate=? " +
        "where topicID=?";
    
    public String Topic_CheckHighExpireDate = 
        "update ejf_topic set highColor='' where highExpireDate < ?";

    public String Topic_CheckTopExpireDate = 
        "update ejf_topic set topScope='N' where topExpireDate < ?";
    
    public String Topic_CheckReplies = 
        "update ejf_topic set state='C' where state = 'N' and replies >= ?";

    public String Topic_GetTitle = 
        "select sectionID,boardID,title,userID,replies,reward,isReplyNotice," +
        "isDigest,topScope,state from ejf_topic where topicID = ?";
    
    public String Topic_ModLastPost = 
        "update ejf_topic set replies=replies+1,lastPostUser=?,lastNickname=?," +
        "lastPostTime=NOW() where topicID = ?";

    public String Topic_IncVisits = 
        "update ejf_topic set visits=visits+1 where topicID = ?";
    
    public String Topic_StatAllReplies = 
        "update ejf_topic set replies=(select COUNT(*) from ejf_reply " +
        "where ejf_reply.state <> 'R' and ejf_reply.topicID = ejf_topic.topicID)";
    
    public String Topic_StatReplies = 
        "select COUNT(replyID) as replies,MAX(replyID) as lastReplyID " +
        "from ejf_reply where topicID = ? and state <> 'R'";
    
    public String Topic_GetLastPost = 
        "select a.userID,b.nickname,a.createTime from ejf_reply a LEFT JOIN ejf_user b " +
        "on a.userID = b.userID where a.replyID = ?";
    
    public String Topic_ModReplies = 
        "update ejf_topic set replies=?,lastPostUser=?,lastNickname=?,lastPostTime=? " +
        "where topicID = ?";

    public String Topic_ResetReplies = 
        "update ejf_topic set replies=0,lastPostUser=userID,lastNickname=nickname,lastPostTime=createTime " +
        "where topicID = ?";
    
    public String Topic_SetIsSolved = 
        "update ejf_topic set isSolved=? where topicID = ?";
    
    public String Topic_RemoveByUser = 
        "update ejf_topic set state='R' where userID = ?";
    
    public String Topic_Query = 
        "select sectionID,boardID,topicID,title,userID,replies,visits,attaches," +
        "topScope,isDigest,highColor,state,createTime from ejf_topic";

    public String Topic_Replace = 
        "update ejf_topic set content=REPLACE(content,?,?)";

    public String Reply_Replace = 
        "update ejf_reply set content=REPLACE(content,?,?)";

    // Reply
    public String Reply_Insert = 
        "insert into ejf_reply(topicID,userID,remoteIP,title,content,isHidePost," +
        "attaches,createTime) values(?,?,?,?,?,?,?,NOW())";

    public String Reply_Update = 
        "update ejf_reply set title=?,content=?,isHidePost=?,attaches=?," +
        "updateTime=NOW() where replyID = ?";
    
//    public String Reply_GetCount = 
//        "select COUNT(*) from ejf_reply where topicID = ? and state <> 'R'";

    public String Reply_GetList = 
        "select a.replyID,a.title,a.content,a.isHidePost,a.attaches,a.isBest,a.state," +
        "a.createTime,a.remoteIP,a.userID,b.nickname,b.avatar,b.brief,b.posts,b.credits,b.groupID " + 
        "from ejf_reply a LEFT JOIN ejf_user b on a.userID = b.userID " +
        "where a.topicID = ? and a.state <> 'R' order by a.isBest DESC, a.replyID ASC";

    public String Reply_GetAllCount = 
        "select COUNT(*) from ejf_reply where topicID = ?";

    public String Reply_GetAllList = 
        "select a.replyID,a.title,a.content,a.isHidePost,a.attaches,a.isBest,a.state," +
        "a.createTime,a.remoteIP,a.userID,b.nickname,b.avatar,b.brief,b.posts,b.credits,b.groupID " + 
        "from ejf_reply a LEFT JOIN ejf_user b on a.userID = b.userID " +
        "where a.topicID = ? order by a.isBest DESC, a.replyID ASC";
    
    public String Reply_GetSeqno = 
        "select COUNT(*) ct from ejf_reply where topicID = ? and state <> 'R' " +
        "and (replyID < ? or isBest='T') union " + 
        "select COUNT(*) ct from ejf_reply where topicID = ? and state <> 'R' " +
        "and (replyID = ? and isBest='T') order by ct DESC";

    public String Reply_GetAllSeqno = 
        "select COUNT(*) ct from ejf_reply where topicID = ? " +
        "and (replyID < ? or isBest='T') union " +
        "select COUNT(*) ct from ejf_reply where topicID = ? " +
        "and (replyID = ? and isBest='T') order by ct DESC";
    
    public String Reply_Index = 
        "select a.topicID,a.boardID,b.replyID,b.userID,b.title,b.content " + 
        "from ejf_topic a, ejf_reply b " +
        "where a.topicID = b.topicID and a.state <> 'R' and b.state <> 'R'";
    
    public String Reply_GetListByUser = 
        "select a.sectionID,a.boardID,a.topicID,a.title,b.replyID,b.userID," + 
        "b.state,b.createTime from ejf_topic a, ejf_reply b " +
        "where a.topicID = b.topicID and a.state <> 'R' and b.userID = ?";

    public String Reply_GetCountByUser = 
        "select COUNT(*) from ejf_topic a, ejf_reply b " + 
        "where a.topicID = b.topicID and a.state <> 'R' and b.userID = ?";
    
    public String Reply_Select = 
        "select * from ejf_reply where replyID = ?";

    public String Reply_GetLogInfo = 
        "select a.topicID,a.boardID,a.title,a.reward,b.attaches,b.userID,b.isBest " + 
        "from ejf_topic a, ejf_reply b where a.topicID = b.topicID and b.replyID = ?";

    public String Reply_Delete = 
        "update ejf_reply set state='R' where replyID = ?";

    public String Reply_Remove = 
        "delete from ejf_reply where replyID = ?";

    public String Reply_Archive = 
        "insert into ejf_archive_reply select * from ejf_reply where replyID = ?";
    
    public String Reply_RemoveByUser = 
        "update ejf_reply set state='R' where userID = ?";
    
    public String Reply_SetIsBest = 
        "update ejf_reply set isBest=? where replyID = ?";

    public String Reply_ModState = 
        "update ejf_reply set state=? where replyID = ?";
    
    public String Reply_ModRemoteIP = 
        "update ejf_reply set remoteIP=? where replyID = ?";
    
    public String Reply_Query = 
        "select b.sectionID,b.boardID,b.topicID,b.title,b.createTime," +
        "a.replyID,a.userID,a.attaches,a.createTime as replyTime " +
        "from ejf_reply a, ejf_topic b";
    
    // Attachment
    public String Attach_Insert = 
        "insert into ejf_attach(topicID,replyID,userID,localname,localID,filename," +
        "filesize,credits,title,state,createTime) values(?,?,?,?,?,?,?,?,?,?,NOW())";

    public String Attach_Update = 
        "update ejf_attach set credits=?,title=?,state=?,updateTime=NOW() " +
        "where attachID = ?";
    
    public String Attach_RemoveByPost = 
        "update ejf_attach set state = 'R' where topicID = ? and replyID = ?";

    public String Attach_RemoveByUser = 
        "update ejf_attach set state = 'R' where userID = ?";
    
    public String Attach_IncDownloads = 
        "update ejf_attach set downloads = downloads + 1 where attachID = ?";

    public String Attach_GetList = 
        "select * from ejf_attach where topicID = ? and state = 'N'";

    public String Attach_GetRecycledList = 
        "select attachID,localname from ejf_attach where state = 'R' and createTime < ?";

    public String Attach_GetAvatarList = 
        "select avatar from ejf_user";

    public String Attach_Get2MonthList = 
        "select localname from ejf_attach where createTime >= ?";
    
    public String Attach_delete = 
        "delete from ejf_attach where state = 'R' and attachID=?";
    
    public String Attach_GetPostList = 
        "select * from ejf_attach where topicID = ? and replyID = ? and state <> 'R'";
    
    public String Attach_Select = 
        "select * from ejf_attach where attachID = ?";

    public String Attach_Query = 
        "select a.*, b.title as topicTitle, b.boardID from ejf_attach a, ejf_topic b";

    // Trash box
    public String TrashBox_Insert = 
        "insert into ejf_trash_box(topicID,replyID,boardID,boardName,topicTitle," +
        "userID,deleteUser,createTime) values(?,?,?,?,?,?,?,NOW())";

    public String TrashBox_Delete = 
        "delete from ejf_trash_box where topicID=? and replyID=?";

    public String TrashBox_CleanExpired = 
        "delete from ejf_trash_box where createTime < ?";
    
    public String TrashBox_RemoveTopic = 
        "delete from ejf_topic where state = 'R' and (not exists " +
        "(select * from ejf_trash_box where ejf_trash_box.topicID=ejf_topic.topicID))";

    public String TrashBox_RemoveReply = 
        "delete from ejf_reply where state = 'R' and (not exists " +
        "(select * from ejf_trash_box where ejf_trash_box.topicID=ejf_reply.topicID " +
        "and ejf_trash_box.replyID=ejf_reply.replyID))";
    
    // Short message
    public String ShortMsg_Insert = 
        "insert into ejf_short_msg(title,message,userID,fromUser,createTime)" + 
        " values(?,?,?,?,NOW())";
    
    public String ShortMsg_SetReadState = 
        "update ejf_short_msg set state='R',updateTime=NOW() where msgID=?";
    
    public String ShortMsg_RemoveFromInbox = 
        "update ejf_short_msg set state='D' where msgID=?";

    public String ShortMsg_RemoveFromOutbox = 
        "update ejf_short_msg set outflag='D' where msgID=?";

    public String ShortMsg_Delete = 
        "delete from ejf_short_msg where state='D' and outflag='D'";
    
    public String ShortMsg_GetMessage = 
        "select message,state from ejf_short_msg where msgID=?";

    public String ShortMsg_Select = 
        "select * from ejf_short_msg where msgID=?";
    
    public String ShortMsg_GetList = 
        "select a.msgID,a.title,a.fromUser,b.nickname,a.state,a.createTime " +
        "from ejf_short_msg a LEFT JOIN ejf_user b on a.fromUser=b.userID " +
        "where a.userID=? and a.state<>'D' order by a.createTime DESC"; 

    public String ShortMsg_GetCount = 
        "select COUNT(*) from ejf_short_msg where userID=? and state<>'D'"; 

    public String ShortMsg_GetOutList = 
        "select a.msgID,a.title,a.userID,b.nickname,a.state,a.createTime " +
        "from ejf_short_msg a LEFT JOIN ejf_user b on a.userID=b.userID " +
        "where a.fromUser=? and a.outflag<>'D' order by a.createTime DESC"; 

    public String ShortMsg_GetOutCount = 
        "select COUNT(*) from ejf_short_msg where fromUser=? and outflag<>'D'"; 
    
    public String ShortMsg_GetUnreadCount = 
        "select COUNT(*) from ejf_short_msg where state='N' and userID=?";
    
    public String ShortMsg_StatUserCount = 
        "select COUNT(*) ct,userID from ejf_short_msg where state<>'D' group by userID";    

    public String ShortMsg_getOverflow = 
        "select createTime from ejf_short_msg " +
        "where userID = ? order by createTime DESC";

    public String ShortMsg_cleanOverflow = 
        "delete from ejf_short_msg where userID = ? and createTime < ?";
    
    // Friend
    public String Friend_Insert = 
        "insert into ejf_friend(userID,friendID,remark,createTime) values(?,?,?,NOW())";
    
    public String Friend_Delete = 
        "delete from ejf_friend where userID=? and friendID=?";

    public String Friend_GetList = 
        "select a.*,b.nickname from ejf_friend a LEFT JOIN ejf_user b " +
        "on a.friendID=b.userID where a.userID=? order by a.createTime DESC";

    public String Friend_GetCount = 
        "select COUNT(*) from ejf_friend where userID=?";
    
    public String Friend_IsExistedFriend = 
        "select COUNT(*) from ejf_friend where userID=? and friendID=?";
    
    //Bookmark
    public String Bookmark_Insert = 
        "insert into ejf_bookmark(userID,url,title,boardName,createTime)"
        + " values(?,?,?,?,NOW())";
    
    public String Bookmark_Delete = 
        "delete from ejf_bookmark where markID=?";

    public String Bookmark_GetList = 
        "select * from ejf_bookmark where userID=? order by createTime DESC";

    public String Bookmark_GetCount = 
        "select COUNT(*) from ejf_bookmark where userID=?";
    
    public String Bookmark_StatUserCount = 
        "select COUNT(*) ct,userID from ejf_bookmark group by userID";    

    public String Bookmark_getOverflow = 
        "select createTime from ejf_bookmark " +
        "where userID = ? order by createTime DESC";

    public String Bookmark_cleanOverflow = 
        "delete from ejf_bookmark where userID = ? and createTime < ?";
    
    // Action Logs
    public String AdminLog_Insert = 
        "insert into ejf_admin_log(userID,groupName,remoteIP,action,remark,createTime) " +
        "values(?,?,?,?,?,NOW())";
    
    public String AdminLog_Delete = 
        "delete from ejf_admin_log where createTime < ?";

    public String ModerateLog_Insert = 
        "insert into ejf_moderator_log(userID,groupName,remoteIP,boardID,boardName," +
        "topicID,topicTitle,replyID,action,reason,createTime) " +
        "values(?,?,?,?,?,?,?,?,?,?,NOW())";
    
    public String ModerateLog_Delete = 
        "delete from ejf_moderator_log where createTime < ?";
    
    public String ErrorLog_Insert = 
        "insert into ejf_error_log(userID,remoteIP,action,errorInfo,createTime) " +
        "values(?,?,?,?,NOW())";
    
    public String ErrorLog_Delete = 
        "delete from ejf_error_log where createTime < ?";
    
    public String ReportLog_Insert = 
        "insert into ejf_report_log(userID,reportedUser,boardID,boardName," +
        "topicID,topicTitle,replyID,reason,createTime) values(?,?,?,?,?,?,?,?,NOW())";

    public String ReportLog_Delete = 
        "delete from ejf_report_log where createTime < ?";

    public String CensorLog_Insert = 
        "insert into ejf_censor_log(userID,boardID,boardName," +
        "topicID,topicTitle,replyID,reason,createTime) values(?,?,?,?,?,?,?,NOW())";

    public String CensorLog_Delete = 
        "delete from ejf_censor_log where createTime < ?";
    
    public String CreditsLog_Insert = 
        "insert into ejf_credits_log(userID,fromUser,credits,action,createTime) " +
        "values(?,?,?,?,NOW())";

    public String CreditsLog_Delete = 
        "delete from ejf_credits_log where createTime < ?";
    
    // Visits stat
    public String VisitStat_GetTopicVisits = 
        "select SUM(visits) from ejf_topic";

    public String VisitStat_GetTopics = 
        "select COUNT(*) from ejf_topic";

    public String VisitStat_GetDigestTopics = 
        "select COUNT(*) from ejf_topic where isDigest='T'";

    public String VisitStat_GetRewardTopics = 
        "select COUNT(*) from ejf_topic where reward > 0";

    public String VisitStat_GetReplies = 
        "select SUM(replies) from ejf_topic";

    public String VisitStat_GetUsers = 
        "select COUNT(*) from ejf_user";

    public String VisitStat_GetPostUsers = 
        "select COUNT(*) from ejf_user where posts > 0";

    public String VisitStat_GetUserLogins = 
        "select SUM(visitCount) from ejf_user where groupID <> 'A'";
    
    public String VisitStat_GetAttaches = 
        "select COUNT(*) from ejf_attach";
    
    public String VisitStat_Insert = 
        "insert into ejf_visit_stat(statDate,topics,replies,users,visits) " +
        "values(?,?,?,?,?)";

    public String VisitStat_Delete = 
        "delete from ejf_visit_stat where statDate=?";
    
    public String VisitStat_GetList = 
        "select ym, MAX(topics) tc, MAX(replies) rc, MAX(users) uc, MAX(visits) vc from " +
        "(select LEFT(statDate,7) ym,topics,replies,users,visits from ejf_visit_stat) a " +
        "group by ym order by ym ASC";

    public String VisitStat_GetMonths = 
        "select ym from (select LEFT(statDate,7) ym from ejf_visit_stat) a group by ym";

    public String VisitStat_30DaysTopBoards = 
        "select boardID, COUNT(*) ct from ejf_topic where createTime >= ? and state <> 'R' " +
        "group by boardID order by ct DESC";

    public String VisitStat_TopVisitsTopics = 
        "select sectionID,boardID,topicID,title,visits " +
        "from ejf_topic where createTime >= ? order by visits DESC";

    public String VisitStat_TopRepliesTopics = 
        "select sectionID,boardID,topicID,title,replies " +
        "from ejf_topic where createTime >= ? order by replies DESC";

    public String VisitStat_TopCreditsUsers = 
        "select userID,nickname,credits from ejf_user order by credits DESC";

    public String VisitStat_TopPostsUsers = 
        "select userID,nickname,posts from ejf_user order by posts DESC";

    public String VisitStat_AdminUsers = 
        "select userID,nickname,credits,posts,groupID,lastVisited,visitCount," +
        "createTime from ejf_user where groupID='A' or groupID='S' or userID in";
    
    // Backup Task
    public String BackupTask_Insert = 
        "insert into ejf_backup_task(inputFile,outputFile,runAt,sendmail," +
        "runMode,isOnlyFile,remark,runStamp,createTime) values(?,?,?,?,?,?,?,?,NOW())";
    
    public String BackupTask_Update = 
        "update ejf_backup_task set inputFile=?,outputFile=?,runAt=?,sendmail=?," +
        "runMode=?,isOnlyFile=?,remark=?,runStamp=? where taskID=?";

    public String BackupTask_ModStamp = 
        "update ejf_backup_task set runStamp=? where taskID=?";
    
    public String BackupTask_Delete = 
        "delete from ejf_backup_task where taskID=?";

    public String BackupTask_Select = 
        "select * from ejf_backup_task where taskID=?";
    
    public String BackupTask_GetAllList = 
        "select * from ejf_backup_task";

    public String BackupTask_GetListByRunAt = 
        "select * from ejf_backup_task where runAt=?";
}
