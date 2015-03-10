IF EXISTS(SELECT name FROM sysobjects WHERE name = 'ejf_backup_task' AND type = 'U') DROP TABLE ejf_backup_task;
IF EXISTS(SELECT name FROM sysobjects WHERE name = 'ejf_error_log' AND type = 'U') DROP TABLE ejf_error_log;
IF EXISTS(SELECT name FROM sysobjects WHERE name = 'ejf_admin_log' AND type = 'U') DROP TABLE ejf_admin_log;
IF EXISTS(SELECT name FROM sysobjects WHERE name = 'ejf_credits_log' AND type = 'U') DROP TABLE ejf_credits_log;
IF EXISTS(SELECT name FROM sysobjects WHERE name = 'ejf_censor_log' AND type = 'U') DROP TABLE ejf_censor_log;
IF EXISTS(SELECT name FROM sysobjects WHERE name = 'ejf_report_log' AND type = 'U') DROP TABLE ejf_report_log;
IF EXISTS(SELECT name FROM sysobjects WHERE name = 'ejf_moderator_log' AND type = 'U') DROP TABLE ejf_moderator_log;

IF EXISTS(SELECT name FROM sysobjects WHERE name = 'ejf_visit_stat' AND type = 'U') DROP TABLE ejf_visit_stat;
IF EXISTS(SELECT name FROM sysobjects WHERE name = 'ejf_friend' AND type = 'U') DROP TABLE ejf_friend;
IF EXISTS(SELECT name FROM sysobjects WHERE name = 'ejf_bookmark' AND type = 'U') DROP TABLE ejf_bookmark;
IF EXISTS(SELECT name FROM sysobjects WHERE name = 'ejf_short_msg' AND type = 'U') DROP TABLE ejf_short_msg;
IF EXISTS(SELECT name FROM sysobjects WHERE name = 'ejf_trash_box' AND type = 'U') DROP TABLE ejf_trash_box;

IF EXISTS(SELECT name FROM sysobjects WHERE name = 'ejf_attach' AND type = 'U') DROP TABLE ejf_attach;
IF EXISTS(SELECT name FROM sysobjects WHERE name = 'ejf_reply' AND type = 'U') DROP TABLE ejf_reply;
IF EXISTS(SELECT name FROM sysobjects WHERE name = 'ejf_topic' AND type = 'U') DROP TABLE ejf_topic;
IF EXISTS(SELECT name FROM sysobjects WHERE name = 'ejf_board' AND type = 'U') DROP TABLE ejf_board;
IF EXISTS(SELECT name FROM sysobjects WHERE name = 'ejf_section' AND type = 'U') DROP TABLE ejf_section;
IF EXISTS(SELECT name FROM sysobjects WHERE name = 'ejf_user' AND type = 'U') DROP TABLE ejf_user;
IF EXISTS(SELECT name FROM sysobjects WHERE name = 'ejf_group' AND type = 'U') DROP TABLE ejf_group;

IF EXISTS(SELECT name FROM sysobjects WHERE name = 'ejf_archive_reply' AND type = 'U') DROP TABLE ejf_archive_reply;
IF EXISTS(SELECT name FROM sysobjects WHERE name = 'ejf_archive_topic' AND type = 'U') DROP TABLE ejf_archive_topic;

-- **********************************************************
-- * ejf_group table
-- * GroupType: M - Member Group, S - System
-- * GroupID: 1-9 - Normal User, M - Moderator, 
-- *            S - Super Moderator, A - Admin, G - Guest
-- **********************************************************

CREATE TABLE ejf_group(
    groupID         CHAR(1)         NOT NULL,
    groupName       VARCHAR(15)     NOT NULL,
    groupType       CHAR(1)         DEFAULT 'M',
    minCredits      INT             DEFAULT 0,
    stars           INT             DEFAULT 1,
    rights          VARCHAR(50)     NOT NULL,
    createTime      DATETIME,
    updateTime      DATETIME,
    PRIMARY KEY(groupID));

-- **********************************************************
-- * ejf_user table
-- * State: N - Normal, P - Seal Posting, S - Sealed,
-- *        A - Auditing
-- * GroupID: Admin group ID
-- **********************************************************

CREATE TABLE ejf_user(
    userID          VARCHAR(15)     NOT NULL,
    nickname        VARCHAR(15)     ,
    pwd             VARCHAR(32)     NOT NULL,
    email           VARCHAR(40)     NOT NULL,
    icq             VARCHAR(40)     ,
    webpage         VARCHAR(60)     ,
    avatar          VARCHAR(50)     ,
    gender          CHAR(1)         DEFAULT 'U',
    birth           VARCHAR(10)     ,
    city            VARCHAR(20)     ,
    remoteIP        VARCHAR(25)     ,
    brief           VARCHAR(200)    ,
    isMailPub       CHAR(1)         DEFAULT 'F',
    posts           INT             DEFAULT 0,
    unreadSMs       INT             DEFAULT 0,
    credits         INT             DEFAULT 0,
    groupID         CHAR(1)         DEFAULT '1',
    lastVisited     DATETIME,
    visitCount		INT				DEFAULT 1,
    loginCount		TINYINT			DEFAULT 0,
    loginExpire	    DATETIME, 
    setpwdExpire	DATETIME, 
    state           CHAR(1)         DEFAULT 'N',
    createTime      DATETIME,
    updateTime      DATETIME,
    PRIMARY KEY(userID),
    UNIQUE(email));

-- ************************************************
-- * ejf_section table
-- * State: N - Normal
-- ************************************************

CREATE TABLE ejf_section(
    sectionID       INT             NOT NULL IDENTITY,
    sectionName     VARCHAR(20)     NOT NULL,
    seqno           INT             DEFAULT 1,
    cols            INT             DEFAULT 1,
    moderator       VARCHAR(60)     ,
    state           CHAR(1)         DEFAULT 'N',
    createTime      DATETIME,
    updateTime      DATETIME,
    PRIMARY KEY(sectionID));

-- ************************************************
-- * ejf_board table
-- * State: N - Normal, I - Invisible
-- ************************************************

CREATE TABLE ejf_board(
    boardID         INT             NOT NULL IDENTITY,
    sectionID       INT             NOT NULL,
    boardName       VARCHAR(20)     NOT NULL,
    highColor     	VARCHAR(6)      ,
    seqno           INT             DEFAULT 1,
    brief           VARCHAR(100)    ,
    keywords        VARCHAR(100)    ,
    moderator       VARCHAR(60)     ,
    viewStyle       VARCHAR(20)     ,
    sortField       VARCHAR(20)     ,
    isImageOK       CHAR(1)         DEFAULT 'T',
    isMediaOK       CHAR(1)         DEFAULT 'F',
    isGuestPostOK   CHAR(1)         DEFAULT 'F',
    allowGroups     VARCHAR(20)     ,
    acl			    VARCHAR(100)    ,
	ruleCode      	TEXT			,
    headAdCode      TEXT			,
    footAdCode      TEXT			,
    state           CHAR(1)         DEFAULT 'N',
    createTime      DATETIME,
    updateTime      DATETIME,
    PRIMARY KEY(boardID),
    FOREIGN KEY(sectionID)
        REFERENCES ejf_section(sectionID));

-- *********************************************************
-- * ejf_topic table
-- * State: N - Normal, C - Closed, R - Recycled
-- * TopScope: 1 - Global, 2 - Section, 3 - Board, N - None
-- * AttachIcon: I - Image, F - Flash, A - Attach
-- *********************************************************

CREATE TABLE ejf_topic(
    topicID         INT             NOT NULL IDENTITY,
    boardID         INT             NOT NULL,
    sectionID       INT             DEFAULT 0,
    userID          VARCHAR(15)     NOT NULL,
    nickname        VARCHAR(15)     ,
    remoteIP        VARCHAR(25)     ,
    title           VARCHAR(100)    NOT NULL,
    content         TEXT      		,
    reward          SMALLINT        DEFAULT 0,
    visits          INT             DEFAULT 0,
    replies         INT             DEFAULT 0,
    attaches	    TINYINT         DEFAULT 0,
    attachIcon      VARCHAR(5)      ,
    lastPostUser    VARCHAR(15)     NOT NULL,
    lastNickname    VARCHAR(15)     ,
    lastPostTime    DATETIME        ,
    isDigest        CHAR(1)         DEFAULT 'F',
    isReplyNotice   CHAR(1)         DEFAULT 'F',
    isHidePost      CHAR(1)         DEFAULT 'F',
    isSolved	    CHAR(1)         DEFAULT 'F',
    topScope        CHAR(1)         DEFAULT 'N',
    topExpireDate   DATETIME        ,
    highColor     	VARCHAR(6)      ,
    highExpireDate 	DATETIME        ,
    state           CHAR(1)         DEFAULT 'N',
    createTime      DATETIME 		,
    updateTime      DATETIME 		,
    updateUser      VARCHAR(15)     ,
    PRIMARY KEY(topicID),
    FOREIGN KEY(boardID)
        REFERENCES ejf_board(boardID));

SELECT * INTO ejf_archive_topic FROM ejf_topic;

-- ************************************************
-- * ejf_reply table
-- * State: N - Normal, R - Recycled
-- ************************************************

CREATE TABLE ejf_reply(
    replyID         INT             NOT NULL IDENTITY,
    topicID         INT             NOT NULL,
    userID          VARCHAR(15)     NOT NULL,
    remoteIP        VARCHAR(25)     ,
    title           VARCHAR(100)    ,
    content         TEXT		    NOT NULL,
    attaches	    TINYINT         DEFAULT 0,
    isHidePost      CHAR(1)         DEFAULT 'F',
    isBest		    CHAR(1)         DEFAULT 'F',
    state           CHAR(1)         DEFAULT 'N',
    createTime      DATETIME,
    updateTime      DATETIME,
    PRIMARY KEY(replyID),
    FOREIGN KEY(topicID)
        REFERENCES ejf_topic(topicID) ON DELETE CASCADE);

SELECT * INTO ejf_archive_reply FROM ejf_reply;

-- *******************************************************
-- * ejf_attach table
-- * State: N - Normal, I - Image, F - Flash, R - Recycled
-- *******************************************************

CREATE TABLE ejf_attach(
    attachID        INT             NOT NULL IDENTITY,
    topicID         INT             NOT NULL,
    replyID         INT             DEFAULT 0,
    userID          VARCHAR(15)     NOT NULL,
    localname	    VARCHAR(50)    	NOT NULL,
    localID        	SMALLINT    	DEFAULT 0,
    filename        VARCHAR(50)    	NOT NULL,
    filesize        INT             DEFAULT 0,
    credits         INT             DEFAULT 0,
    title        	VARCHAR(50)     ,
    downloads       INT             DEFAULT 0,
    state           CHAR(1)         DEFAULT 'N',
    createTime      DATETIME,
    updateTime      DATETIME,
    PRIMARY KEY(attachID),
    FOREIGN KEY(topicID)
        REFERENCES ejf_topic(topicID) ON DELETE CASCADE);

-- ************************************************
-- * ejf_trash_box table
-- ************************************************

CREATE TABLE ejf_trash_box(
    topicID         INT             NOT NULL,
    replyID         INT             DEFAULT 0,
    boardID         INT             NOT NULL,
    boardName       VARCHAR(20)     NOT NULL,
    topicTitle      VARCHAR(100)    NOT NULL,
    userID          VARCHAR(15)     NOT NULL,
    deleteUser      VARCHAR(15)     NOT NULL,
    createTime      DATETIME,
    PRIMARY KEY(topicID,replyID));

-- ************************************************
-- * ejf_short_msg table
-- * Outflag: N - Normal, D - Deleted
-- * State: N - New, R - Read
-- ************************************************

CREATE TABLE ejf_short_msg(
    msgID           INT             NOT NULL IDENTITY,
    title	        VARCHAR(100)    NOT NULL,
    message         VARCHAR(200)    ,
    userID          VARCHAR(15)     NOT NULL,
    fromUser        VARCHAR(15)     NOT NULL,
	outflag		    CHAR(1)         DEFAULT 'N',
    state           CHAR(1)         DEFAULT 'N',
    createTime      DATETIME,
    updateTime      DATETIME,
    PRIMARY KEY(msgID),
    FOREIGN KEY(userID)
        REFERENCES ejf_user(userID) ON DELETE CASCADE);

-- ************************************************
-- * ejf_bookmark table
-- ************************************************

CREATE TABLE ejf_bookmark(
    markID          INT             NOT NULL IDENTITY,
    userID          VARCHAR(15)     NOT NULL,
    url         	VARCHAR(100)    NOT NULL,
    title         	VARCHAR(100)    NOT NULL,
    boardName      	VARCHAR(20)     ,
    createTime      DATETIME,
    PRIMARY KEY(markID),
    FOREIGN KEY(userID)
        REFERENCES ejf_user(userID) ON DELETE CASCADE);

-- ************************************************
-- * ejf_friend table
-- ************************************************

CREATE TABLE ejf_friend(
    userID          VARCHAR(15)     NOT NULL,
    friendID        VARCHAR(15)     NOT NULL,
    remark          VARCHAR(50)     ,
    createTime      DATETIME,
    PRIMARY KEY(userID,friendID),
    FOREIGN KEY(userID)
        REFERENCES ejf_user(userID) ON DELETE CASCADE);

-- ************************************************
-- * ejf_visit_stat table
-- ************************************************

CREATE TABLE ejf_visit_stat (
    statDate      	VARCHAR(10)		NOT NULL,
    topics          INT             DEFAULT 0,
    replies         INT             DEFAULT 0,
    users          	INT             DEFAULT 0,
    visits          INT             DEFAULT 0,
    PRIMARY KEY(statDate));

-- ************************************************
-- * ejf_moderator_log table
-- ************************************************

CREATE TABLE ejf_moderator_log (
    logID           INT             NOT NULL IDENTITY,
    userID          VARCHAR(15)     NOT NULL,
    groupName       VARCHAR(15)     NOT NULL,
    remoteIP        VARCHAR(25)     ,
    boardID         INT             NOT NULL,
    boardName       VARCHAR(20)     NOT NULL,
    topicID         INT             NOT NULL,
    topicTitle      VARCHAR(100)    NOT NULL,
    replyID         INT             DEFAULT 0,
    action          VARCHAR(10)     NOT NULL,
    reason          VARCHAR(40)     NOT NULL,
    createTime      DATETIME,
    PRIMARY KEY(logID));

-- ************************************************
-- * ejf_report_log table
-- ************************************************

CREATE TABLE ejf_report_log (
    logID           INT             NOT NULL IDENTITY,
    userID          VARCHAR(15)     ,
    reportedUser    VARCHAR(15)     ,
    boardID         INT             NOT NULL,
    boardName       VARCHAR(20)     NOT NULL,
    topicID        	INT             NOT NULL,
    topicTitle     	VARCHAR(100)    NOT NULL,
    replyID         INT             DEFAULT 0,
    reason          VARCHAR(40)     NOT NULL,
    createTime      DATETIME,
    PRIMARY KEY(logID));

-- ************************************************
-- * ejf_censor_log table
-- ************************************************

CREATE TABLE ejf_censor_log (
    logID           INT             NOT NULL IDENTITY,
    userID          VARCHAR(15)     ,
    boardID         INT             NOT NULL,
    boardName       VARCHAR(20)     NOT NULL,
    topicID        	INT             NOT NULL,
    topicTitle     	VARCHAR(100)    NOT NULL,
    replyID         INT             DEFAULT 0,
    reason          VARCHAR(40)     NOT NULL,
    createTime      DATETIME,
    PRIMARY KEY(logID));

-- ************************************************
-- * ejf_credits_log table
-- ************************************************

CREATE TABLE ejf_credits_log (
    logID           INT             NOT NULL IDENTITY,
    userID          VARCHAR(15)     NOT NULL,
    fromUser        VARCHAR(15)     ,
    credits         SMALLINT        DEFAULT 0,
    action          VARCHAR(10)     NOT NULL,
    createTime      DATETIME,
    PRIMARY KEY(logID));

-- ************************************************
-- * ejf_admin_log table
-- ************************************************

CREATE TABLE ejf_admin_log (
    logID           INT             NOT NULL IDENTITY,
    userID          VARCHAR(15)     NOT NULL,
    groupName       VARCHAR(15)     NOT NULL,
    remoteIP        VARCHAR(25)     ,
    action          VARCHAR(10)     NOT NULL,
    remark          VARCHAR(40)     ,
    createTime      DATETIME,
    PRIMARY KEY(logID));

-- ************************************************
-- * ejf_error_log table
-- ************************************************

CREATE TABLE ejf_error_log (
    logID           INT             NOT NULL IDENTITY,
    userID          VARCHAR(15)     NOT NULL,
    remoteIP        VARCHAR(25)     ,
    action          VARCHAR(10)     NOT NULL,
    errorInfo       VARCHAR(100)    ,
    createTime      DATETIME,
    PRIMARY KEY(logID));

-- ************************************************
-- * ejf_backup_task table 
-- * runAt: N - Now, D - Daily, W - Weekly
-- * runMode: A - All, I - Increasely
-- ************************************************

CREATE TABLE ejf_backup_task (
    taskID	        INT             NOT NULL IDENTITY,
    inputFile       VARCHAR(255)    NOT NULL,
    outputFile      VARCHAR(255)    NOT NULL,
    runAt	        CHAR(1)     	DEFAULT 'N',
    sendmail        CHAR(1)     	DEFAULT 'T',
    runMode	        CHAR(1)     	DEFAULT 'A',
    isOnlyFile      CHAR(1)     	DEFAULT 'T',
    runStamp		VARCHAR(20)		,
    remark		    VARCHAR(50)     ,
    createTime      DATETIME,
    PRIMARY KEY(taskID));

-- ************************************************
-- *  
-- * Insert init data into tables
-- *  
-- ************************************************

--
-- Groups
--
INSERT INTO ejf_group(groupID,groupName,groupType,minCredits,stars,rights,createTime)
               VALUES('A', '管理员', 'S', 0, 9, 'ABCDEFGWHIJKLMNOPQRSTUV', GETDATE());
INSERT INTO ejf_group(groupID,groupName,groupType,minCredits,stars,rights,createTime)  
               VALUES('S', '超级版主', 'S', 0, 8, 'ABCDEFGWHIJKLMNOQRST', GETDATE());
INSERT INTO ejf_group(groupID,groupName,groupType,minCredits,stars,rights,createTime) 
               VALUES('M', '版主', 'S', 0, 7, 'ABCDEFGWHJKLMNOQRST', GETDATE());
INSERT INTO ejf_group(groupID,groupName,groupType,minCredits,stars,rights,createTime) 
               VALUES('G', '游客', 'S', 0, 0, 'ABCJ', GETDATE());
INSERT INTO ejf_group(groupID,groupName,groupType,minCredits,stars,rights,createTime) 
               VALUES('1', '乞丐', 'M', -999999, 0, 'ACG', GETDATE());
INSERT INTO ejf_group(groupID,groupName,groupType,minCredits,stars,rights,createTime) 
               VALUES('2', '贫民', 'M', -50, 1, 'ACFG', GETDATE());
INSERT INTO ejf_group(groupID,groupName,groupType,minCredits,stars,rights,createTime) 
               VALUES('3', '新手上路', 'M', 0, 1, 'ABCEFGJK', GETDATE());
INSERT INTO ejf_group(groupID,groupName,groupType,minCredits,stars,rights,createTime) 
               VALUES('4', '初级会员', 'M', 50, 2, 'ABCEFGWJK', GETDATE());
INSERT INTO ejf_group(groupID,groupName,groupType,minCredits,stars,rights,createTime) 
               VALUES('5', '中级会员', 'M', 500, 3, 'ABCEFGWHJK', GETDATE());
INSERT INTO ejf_group(groupID,groupName,groupType,minCredits,stars,rights,createTime) 
               VALUES('6', '高级会员', 'M', 1500, 4, 'ABCDEFGWHJK', GETDATE());
INSERT INTO ejf_group(groupID,groupName,groupType,minCredits,stars,rights,createTime) 
               VALUES('7', '论坛元老', 'M', 3000, 5, 'ABCDEFGWHJKT', GETDATE());

--
-- Sections & Boards
--
INSERT INTO ejf_section(sectionName,seqno,createTime) VALUES ('默认分区', 1, GETDATE());
INSERT INTO ejf_board(sectionID,boardName,seqno,brief,allowGroups,acl,createTime) VALUES(@@IDENTITY, '默认版块', 1, '', 'AMSG1234567', '', GETDATE());
INSERT INTO ejf_section(sectionName,seqno,createTime) VALUES ('站务管理', 2, GETDATE());
INSERT INTO ejf_board(sectionID,boardName,seqno,brief,allowGroups,acl,createTime) VALUES(@@IDENTITY, '论坛公告', 1, '论坛公告发布，版主任免，管理与奖惩决定公布等', 'AMSG1234567', 'F_AMS', GETDATE());
INSERT INTO ejf_board(sectionID,boardName,seqno,brief,allowGroups,acl,createTime) VALUES(@@IDENTITY, '站务管理', 2, '意见、建议发表，系统BUG报告等', 'AMSG1234567', '', GETDATE());