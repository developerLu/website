DROP SEQUENCE ejf_section_seq;
DROP SEQUENCE ejf_board_seq;
DROP SEQUENCE ejf_topic_seq;
DROP SEQUENCE ejf_reply_seq;
DROP SEQUENCE ejf_attach_seq;

DROP SEQUENCE ejf_short_msg_seq;
DROP SEQUENCE ejf_bookmark_seq;
DROP SEQUENCE ejf_backup_task_seq;

DROP SEQUENCE ejf_moderator_log_seq;
DROP SEQUENCE ejf_report_log_seq;
DROP SEQUENCE ejf_censor_log_seq;
DROP SEQUENCE ejf_credits_log_seq;
DROP SEQUENCE ejf_admin_log_seq;
DROP SEQUENCE ejf_error_log_seq;

CREATE SEQUENCE ejf_section_seq INCREMENT BY 1 START WITH 1;
CREATE SEQUENCE ejf_board_seq INCREMENT BY 1 START WITH 1;
CREATE SEQUENCE ejf_topic_seq INCREMENT BY 1 START WITH 1;
CREATE SEQUENCE ejf_reply_seq INCREMENT BY 1 START WITH 1;
CREATE SEQUENCE ejf_attach_seq INCREMENT BY 1 START WITH 1;

CREATE SEQUENCE ejf_short_msg_seq INCREMENT BY 1 START WITH 1;
CREATE SEQUENCE ejf_bookmark_seq INCREMENT BY 1 START WITH 1;
CREATE SEQUENCE ejf_backup_task_seq INCREMENT BY 1 START WITH 1;

CREATE SEQUENCE ejf_moderator_log_seq INCREMENT BY 1 START WITH 1;
CREATE SEQUENCE ejf_report_log_seq INCREMENT BY 1 START WITH 1;
CREATE SEQUENCE ejf_censor_log_seq INCREMENT BY 1 START WITH 1;
CREATE SEQUENCE ejf_credits_log_seq INCREMENT BY 1 START WITH 1;
CREATE SEQUENCE ejf_admin_log_seq INCREMENT BY 1 START WITH 1;
CREATE SEQUENCE ejf_error_log_seq INCREMENT BY 1 START WITH 1;

DROP TABLE ejf_backup_task;
DROP TABLE ejf_error_log;
DROP TABLE ejf_admin_log;
DROP TABLE ejf_credits_log;
DROP TABLE ejf_censor_log;
DROP TABLE ejf_report_log;
DROP TABLE ejf_moderator_log;

DROP TABLE ejf_visit_stat;
DROP TABLE ejf_friend;
DROP TABLE ejf_bookmark;
DROP TABLE ejf_short_msg;
DROP TABLE ejf_trash_box;

DROP TABLE ejf_attach;
DROP TABLE ejf_reply;
DROP TABLE ejf_topic;
DROP TABLE ejf_board;
DROP TABLE ejf_section;
DROP TABLE ejf_user;
DROP TABLE ejf_group;

DROP TABLE ejf_archive_reply;
DROP TABLE ejf_archive_topic;

-- **********************************************************
-- * ejf_group table
-- * GroupType: M - Member Group, S - System
-- * GroupID: 1-9 - Normal User, M - Moderator, 
-- *            S - Super Moderator, A - Admin, G - Guest
-- **********************************************************

CREATE TABLE ejf_group(
    groupID         CHAR(1)         NOT NULL,
    groupName       VARCHAR2(15)    NOT NULL,
    groupType       CHAR(1)         DEFAULT 'M',
    minCredits      NUMBER(10)      DEFAULT 0,
    stars           NUMBER(10)      DEFAULT 1,
    rights          VARCHAR2(50)    NOT NULL,
    createTime      DATE,
    updateTime      TIMESTAMP,
    PRIMARY KEY(groupID));

-- **********************************************************
-- * ejf_user table
-- * State: N - Normal, P - Seal Posting, S - Sealed,
-- *        A - Auditing
-- * GroupID: Admin group ID
-- **********************************************************

CREATE TABLE ejf_user(
    userID          VARCHAR2(15)    NOT NULL,
    nickname        VARCHAR2(15)    ,
    pwd             VARCHAR2(32)    NOT NULL,
    email           VARCHAR2(40)    NOT NULL,
    icq             VARCHAR2(40)    ,
    webpage         VARCHAR2(60)    ,
    avatar          VARCHAR2(50)    ,
    gender          CHAR(1)         DEFAULT 'U',
    birth           VARCHAR2(10)    ,
    city            VARCHAR2(20)    ,
    remoteIP        VARCHAR2(25)    ,
    brief           VARCHAR2(200)   ,
    isMailPub       CHAR(1)         DEFAULT 'F',
    posts           NUMBER(10)      DEFAULT 0,
    unreadSMs       NUMBER(10)      DEFAULT 0,
    credits         NUMBER(10)      DEFAULT 0,
    groupID         CHAR(1)         DEFAULT '1',
    lastVisited     DATE,
    visitCount		NUMBER(10)		DEFAULT 1,
    loginCount		NUMBER(2)		DEFAULT 0,
    loginExpire	    DATE, 
    setpwdExpire	DATE, 
    state           CHAR(1)         DEFAULT 'N',
    createTime      DATE,
    updateTime      TIMESTAMP,
    PRIMARY KEY(userID),
    UNIQUE(email));

-- ************************************************
-- * ejf_section table
-- * State: N - Normal
-- ************************************************

CREATE TABLE ejf_section(
    sectionID       NUMBER(10)      NOT NULL,
    sectionName     VARCHAR2(20)    NOT NULL,
    seqno           NUMBER(10)      DEFAULT 1,
    cols            NUMBER(10)      DEFAULT 1,
    moderator       VARCHAR2(60)    ,
    state           CHAR(1)         DEFAULT 'N',
    createTime      DATE,
    updateTime      TIMESTAMP,
    PRIMARY KEY(sectionID));

-- ************************************************
-- * ejf_board table
-- * State: N - Normal, I - Invisible
-- ************************************************

CREATE TABLE ejf_board(
    boardID         NUMBER(10)      NOT NULL,
    sectionID       NUMBER(10)      NOT NULL,
    boardName       VARCHAR2(20)    NOT NULL,
    highColor     	VARCHAR2(6)     ,
    seqno           NUMBER(10)      DEFAULT 1,
    brief           VARCHAR2(100)   ,
    keywords        VARCHAR2(100)   ,
    moderator       VARCHAR2(60)    ,
    viewStyle       VARCHAR2(20)    ,
    sortField       VARCHAR2(20)    ,
    isImageOK       CHAR(1)         DEFAULT 'T',
    isMediaOK       CHAR(1)         DEFAULT 'F',
    isGuestPostOK   CHAR(1)         DEFAULT 'F',
    allowGroups     VARCHAR2(20)    ,
    acl			    VARCHAR2(100)   ,
	ruleCode      	CLOB			,
    headAdCode      CLOB		    ,
    footAdCode      CLOB		    ,
    state           CHAR(1)         DEFAULT 'N',
    createTime      DATE,
    updateTime      TIMESTAMP,
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
    topicID         NUMBER(10)      NOT NULL,
    boardID         NUMBER(10)      NOT NULL,
    sectionID       NUMBER(10)      DEFAULT 0,
    userID          VARCHAR2(15)    NOT NULL,
    nickname        VARCHAR2(15)    ,
    remoteIP        VARCHAR2(25)    ,
    title           VARCHAR2(100)   NOT NULL,
    content         CLOB		    ,
    reward          NUMBER(4)       DEFAULT 0,
    visits          NUMBER(10)      DEFAULT 0,
    replies         NUMBER(10)      DEFAULT 0,
    attaches	    NUMBER(2)       DEFAULT 0,
    attachIcon      VARCHAR2(5)     ,
    lastPostUser    VARCHAR2(15)    NOT NULL,
    lastNickname    VARCHAR2(15)    ,
    lastPostTime    DATE	        ,
    isDigest        CHAR(1)         DEFAULT 'F',
    isReplyNotice   CHAR(1)         DEFAULT 'F',
    isHidePost      CHAR(1)         DEFAULT 'F',
    isSolved	    CHAR(1)         DEFAULT 'F',
    topScope        CHAR(1)         DEFAULT 'N',
    topExpireDate   DATE	        ,
    highColor     	VARCHAR2(6)     ,
    highExpireDate 	DATE    	    ,
    state           CHAR(1)         DEFAULT 'N',
    createTime      DATE	 		,
    updateTime      TIMESTAMP 		,
    updateUser      VARCHAR2(15)    ,
    PRIMARY KEY(topicID),
    FOREIGN KEY(boardID)
        REFERENCES ejf_board(boardID));

CREATE TABLE ejf_archive_topic AS SELECT * FROM ejf_topic;

-- ************************************************
-- * ejf_reply table
-- * State: N - Normal, R - Recycled
-- ************************************************

CREATE TABLE ejf_reply(
    replyID         NUMBER(10)      NOT NULL,
    topicID         NUMBER(10)      NOT NULL,
    userID          VARCHAR2(15)    NOT NULL,
    remoteIP        VARCHAR2(25)    ,
    title           VARCHAR2(100)   ,
    content         CLOB	        NOT NULL,
    attaches	    NUMBER(2)       DEFAULT 0,
    isHidePost      CHAR(1)         DEFAULT 'F',
    isBest		    CHAR(1)         DEFAULT 'F',
    state           CHAR(1)         DEFAULT 'N',
    createTime      DATE,
    updateTime      TIMESTAMP,
    PRIMARY KEY(replyID),
    FOREIGN KEY(topicID)
        REFERENCES ejf_topic(topicID) ON DELETE CASCADE);

CREATE TABLE ejf_archive_reply AS SELECT * FROM ejf_reply;

-- *******************************************************
-- * ejf_attach table
-- * State: N - Normal, I - Image, F - Flash, R - Recycled
-- *******************************************************

CREATE TABLE ejf_attach(
    attachID        NUMBER(10)      NOT NULL,
    topicID         NUMBER(10)      NOT NULL,
    replyID         NUMBER(10)      DEFAULT 0,
    userID          VARCHAR2(15)    NOT NULL,
    localname	    VARCHAR2(50)    NOT NULL,
    localID        	NUMBER(4)    	DEFAULT 0,
    filename        VARCHAR2(50)    NOT NULL,
    filesize        NUMBER(10)      DEFAULT 0,
    credits         NUMBER(10)      DEFAULT 0,
    title        	VARCHAR2(50)    ,
    downloads       NUMBER(10)      DEFAULT 0,
    state           CHAR(1)         DEFAULT 'N',
    createTime      DATE,
    updateTime      TIMESTAMP,
    PRIMARY KEY(attachID),
    FOREIGN KEY(topicID)
        REFERENCES ejf_topic(topicID) ON DELETE CASCADE);

-- ************************************************
-- * ejf_trash_box table
-- ************************************************

CREATE TABLE ejf_trash_box(
    topicID         NUMBER(10)      NOT NULL,
    replyID         NUMBER(10)      DEFAULT 0,
    boardID         NUMBER(10)      NOT NULL,
    boardName       VARCHAR2(20)    NOT NULL,
    topicTitle      VARCHAR2(100)   NOT NULL,
    userID          VARCHAR2(15)    NOT NULL,
    deleteUser      VARCHAR2(15)    NOT NULL,
    createTime      DATE,
    PRIMARY KEY(topicID,replyID));

-- ************************************************
-- * ejf_short_msg table
-- * Outflag: N - Normal, D - Deleted
-- * State: N - New, R - Read
-- ************************************************

CREATE TABLE ejf_short_msg(
    msgID           NUMBER(10)      NOT NULL,
    title	        VARCHAR2(100)   NOT NULL,
    message         VARCHAR2(200)   ,
    userID          VARCHAR2(15)    NOT NULL,
    fromUser        VARCHAR2(15)    NOT NULL,
	outflag		    CHAR(1)         DEFAULT 'N',
    state           CHAR(1)         DEFAULT 'N',
    createTime      DATE,
    updateTime      TIMESTAMP,
    PRIMARY KEY(msgID),
    FOREIGN KEY(userID)
        REFERENCES ejf_user(userID) ON DELETE CASCADE);

-- ************************************************
-- * ejf_bookmark table
-- ************************************************

CREATE TABLE ejf_bookmark(
    markID          NUMBER(10)      NOT NULL,
    userID          VARCHAR2(15)    NOT NULL,
    url         	VARCHAR2(100)   NOT NULL,
    title         	VARCHAR2(100)   NOT NULL,
    boardName      	VARCHAR2(20)    ,
    createTime      DATE,
    PRIMARY KEY(markID),
    FOREIGN KEY(userID)
        REFERENCES ejf_user(userID) ON DELETE CASCADE);

-- ************************************************
-- * ejf_friend table
-- ************************************************

CREATE TABLE ejf_friend(
    userID          VARCHAR2(15)     NOT NULL,
    friendID        VARCHAR2(15)     NOT NULL,
    remark          VARCHAR2(50)     ,
    createTime      DATE,
    PRIMARY KEY(userID,friendID),
    FOREIGN KEY(userID)
        REFERENCES ejf_user(userID) ON DELETE CASCADE);

-- ************************************************
-- * ejf_visit_stat table
-- ************************************************

CREATE TABLE ejf_visit_stat (
    statDate      	VARCHAR2(10)	NOT NULL,
    topics          NUMBER(10)      DEFAULT 0,
    replies         NUMBER(10)      DEFAULT 0,
    users          	NUMBER(10)      DEFAULT 0,
    visits          NUMBER(10)      DEFAULT 0,
    PRIMARY KEY(statDate));

-- ************************************************
-- * ejf_moderator_log table
-- ************************************************

CREATE TABLE ejf_moderator_log (
    logID 	        NUMBER(10)      NOT NULL,
    userID          VARCHAR2(15)    NOT NULL,
    groupName       VARCHAR2(15)    NOT NULL,
    remoteIP        VARCHAR2(25)    ,
    boardID         NUMBER(10)      NOT NULL,
    boardName       VARCHAR2(20)    NOT NULL,
    topicID         NUMBER(10)      NOT NULL,
    topicTitle      VARCHAR2(100)   NOT NULL,
    replyID         NUMBER(10)      DEFAULT 0,
    action          VARCHAR2(10)    NOT NULL,
    reason          VARCHAR2(40)    NOT NULL,
    createTime      DATE,
    PRIMARY KEY(logID));

-- ************************************************
-- * ejf_report_log table
-- ************************************************

CREATE TABLE ejf_report_log (
    logID           NUMBER(10)      NOT NULL,
    userID          VARCHAR2(15)    ,
    reportedUser    VARCHAR2(15)    ,
    boardID         NUMBER(10)      NOT NULL,
    boardName       VARCHAR2(20)    NOT NULL,
    topicID        	NUMBER(10)      NOT NULL,
    topicTitle     	VARCHAR2(100)   NOT NULL,
    replyID         NUMBER(10)      DEFAULT 0,
    reason          VARCHAR2(40)    NOT NULL,
    createTime      DATE,
    PRIMARY KEY(logID));

-- ************************************************
-- * ejf_censor_log table
-- ************************************************

CREATE TABLE ejf_censor_log (
    logID           NUMBER(10)      NOT NULL,
    userID          VARCHAR2(15)    ,
    boardID         NUMBER(10)      NOT NULL,
    boardName       VARCHAR2(20)    NOT NULL,
    topicID        	NUMBER(10)      NOT NULL,
    topicTitle     	VARCHAR2(100)   NOT NULL,
    replyID         NUMBER(10)      DEFAULT 0,
    reason          VARCHAR2(40)    NOT NULL,
    createTime      DATE,
    PRIMARY KEY(logID));

-- ************************************************
-- * ejf_credits_log table
-- ************************************************

CREATE TABLE ejf_credits_log (
    logID           NUMBER(10)      NOT NULL,
    userID          VARCHAR2(15)    NOT NULL,
    fromUser        VARCHAR2(15)    ,
    credits         NUMBER(4)       DEFAULT 0,
    action          VARCHAR2(10)    NOT NULL,
    createTime      DATE,
    PRIMARY KEY(logID));

-- ************************************************
-- * ejf_admin_log table
-- ************************************************

CREATE TABLE ejf_admin_log (
    logID           NUMBER(10)      NOT NULL,
    userID          VARCHAR2(15)    NOT NULL,
    groupName       VARCHAR2(15)    NOT NULL,
    remoteIP        VARCHAR2(25)    ,
    action          VARCHAR2(10)    NOT NULL,
    remark          VARCHAR2(40)    ,
    createTime      DATE,
    PRIMARY KEY(logID));

-- ************************************************
-- * ejf_error_log table
-- ************************************************

CREATE TABLE ejf_error_log (
    logID           NUMBER(10)      NOT NULL,
    userID          VARCHAR2(15)    NOT NULL,
    remoteIP        VARCHAR2(25)    ,
    action          VARCHAR2(10)    NOT NULL,
    errorInfo       VARCHAR2(100)   ,
    createTime      DATE,
    PRIMARY KEY(logID));

-- ************************************************
-- * ejf_backup_task table 
-- * runAt: N - Now, D - Daily, W - Weekly
-- * runMode: A - All, I - Increasely
-- ************************************************

CREATE TABLE ejf_backup_task (
    taskID	        NUMBER(10)      NOT NULL,
    inputFile       VARCHAR2(255)   NOT NULL,
    outputFile      VARCHAR2(255)   NOT NULL,
    runAt	        CHAR(1)     	DEFAULT 'N',
    sendmail        CHAR(1)     	DEFAULT 'T',
    runMode	        CHAR(1)     	DEFAULT 'A',
    isOnlyFile      CHAR(1)     	DEFAULT 'T',
    runStamp		VARCHAR2(20)	,
    remark		    VARCHAR2(50)    ,
    createTime      DATE,
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
               VALUES('A', '管理员', 'S', 0, 9, 'ABCDEFGWHIJKLMNOPQRSTUV', SYSDATE);
INSERT INTO ejf_group(groupID,groupName,groupType,minCredits,stars,rights,createTime)  
               VALUES('S', '超级版主', 'S', 0, 8, 'ABCDEFGWHIJKLMNOQRST', SYSDATE);
INSERT INTO ejf_group(groupID,groupName,groupType,minCredits,stars,rights,createTime) 
               VALUES('M', '版主', 'S', 0, 7, 'ABCDEFGWHJKLMNOQRST', SYSDATE);
INSERT INTO ejf_group(groupID,groupName,groupType,minCredits,stars,rights,createTime) 
               VALUES('G', '游客', 'S', 0, 0, 'ABCJ', SYSDATE);
INSERT INTO ejf_group(groupID,groupName,groupType,minCredits,stars,rights,createTime) 
               VALUES('1', '乞丐', 'M', -999999, 0, 'ACG', SYSDATE);
INSERT INTO ejf_group(groupID,groupName,groupType,minCredits,stars,rights,createTime) 
               VALUES('2', '贫民', 'M', -50, 1, 'ACFG', SYSDATE);
INSERT INTO ejf_group(groupID,groupName,groupType,minCredits,stars,rights,createTime) 
               VALUES('3', '新手上路', 'M', 0, 1, 'ABCEFGJK', SYSDATE);
INSERT INTO ejf_group(groupID,groupName,groupType,minCredits,stars,rights,createTime) 
               VALUES('4', '初级会员', 'M', 50, 2, 'ABCEFGWJK', SYSDATE);
INSERT INTO ejf_group(groupID,groupName,groupType,minCredits,stars,rights,createTime) 
               VALUES('5', '中级会员', 'M', 500, 3, 'ABCEFGWHJK', SYSDATE);
INSERT INTO ejf_group(groupID,groupName,groupType,minCredits,stars,rights,createTime) 
               VALUES('6', '高级会员', 'M', 1500, 4, 'ABCDEFGWHJK', SYSDATE);
INSERT INTO ejf_group(groupID,groupName,groupType,minCredits,stars,rights,createTime) 
               VALUES('7', '论坛元老', 'M', 3000, 5, 'ABCDEFGWHJKT', SYSDATE);

--
-- Sections & Boards
--
INSERT INTO ejf_section(sectionID,sectionName,seqno,createTime) VALUES (ejf_section_seq.NEXTVAL, '默认分区', 1, SYSDATE);
INSERT INTO ejf_board(boardID,sectionID,boardName,seqno,brief,allowGroups,acl,createTime) VALUES(ejf_board_seq.NEXTVAL, ejf_section_seq.CURRVAL, '默认版块', 1, '', 'AMSG1234567', '', SYSDATE);
INSERT INTO ejf_section(sectionID,sectionName,seqno,createTime) VALUES (ejf_section_seq.NEXTVAL, '站务管理', 2, SYSDATE);
INSERT INTO ejf_board(boardID,sectionID,boardName,seqno,brief,allowGroups,acl,createTime) VALUES(ejf_board_seq.NEXTVAL, ejf_section_seq.CURRVAL, '论坛公告', 1, '论坛公告发布，版主任免，管理与奖惩决定公布等', 'AMSG1234567', 'F_AMS', SYSDATE);
INSERT INTO ejf_board(boardID,sectionID,boardName,seqno,brief,allowGroups,acl,createTime) VALUES(ejf_board_seq.NEXTVAL, ejf_section_seq.CURRVAL, '站务管理', 2, '意见、建议发表，系统BUG报告等', 'AMSG1234567', '', SYSDATE);