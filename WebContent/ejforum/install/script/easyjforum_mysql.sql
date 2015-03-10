-- MySQL Administrator dump 1.4
--
-- ------------------------------------------------------
-- Server version	5.0.24a-community-nt


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;

/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;


--
-- Definition of table `ejf_admin_log`
--

DROP TABLE IF EXISTS `ejf_admin_log`;
CREATE TABLE `ejf_admin_log` (
  `logID` int(11) NOT NULL auto_increment,
  `userID` varchar(15) NOT NULL,
  `groupName` varchar(15) NOT NULL,
  `remoteIP` varchar(25) default NULL,
  `action` varchar(10) NOT NULL,
  `remark` varchar(40) default NULL,
  `createTime` datetime default NULL,
  PRIMARY KEY  (`logID`)
) ENGINE=InnoDB DEFAULT CHARSET=gbk;

--
-- Dumping data for table `ejf_admin_log`
--

/*!40000 ALTER TABLE `ejf_admin_log` DISABLE KEYS */;
/*!40000 ALTER TABLE `ejf_admin_log` ENABLE KEYS */;


--
-- Definition of table `ejf_archive_reply`
--

DROP TABLE IF EXISTS `ejf_archive_reply`;
CREATE TABLE `ejf_archive_reply` (
  `replyID` int(11) NOT NULL default '0',
  `topicID` int(11) NOT NULL,
  `userID` varchar(15) NOT NULL,
  `remoteIP` varchar(25) default NULL,
  `title` varchar(100) default NULL,
  `content` mediumtext NOT NULL,
  `attaches` tinyint(4) default '0',
  `isHidePost` char(1) default 'F',
  `isBest` char(1) default 'F',
  `state` char(1) default 'N',
  `createTime` datetime default NULL,
  `updateTime` timestamp NOT NULL default '0000-00-00 00:00:00'
) ENGINE=MyISAM DEFAULT CHARSET=gbk;

--
-- Dumping data for table `ejf_archive_reply`
--

/*!40000 ALTER TABLE `ejf_archive_reply` DISABLE KEYS */;
/*!40000 ALTER TABLE `ejf_archive_reply` ENABLE KEYS */;


--
-- Definition of table `ejf_archive_topic`
--

DROP TABLE IF EXISTS `ejf_archive_topic`;
CREATE TABLE `ejf_archive_topic` (
  `topicID` int(11) NOT NULL default '0',
  `boardID` int(11) NOT NULL,
  `sectionID` int(11) default '0',
  `userID` varchar(15) NOT NULL,
  `nickname` varchar(15) default NULL,
  `remoteIP` varchar(25) default NULL,
  `title` varchar(100) NOT NULL,
  `content` mediumtext,
  `reward` smallint(6) default '0',
  `visits` int(11) default '0',
  `replies` int(11) default '0',
  `attaches` tinyint(4) default '0',
  `attachIcon` varchar(5) default NULL,
  `lastPostUser` varchar(15) NOT NULL,
  `lastNickname` varchar(15) default NULL,
  `lastPostTime` datetime default NULL,
  `isDigest` char(1) default 'F',
  `isReplyNotice` char(1) default 'F',
  `isHidePost` char(1) default 'F',
  `isSolved` char(1) default 'F',
  `topScope` char(1) default 'N',
  `topExpireDate` datetime default NULL,
  `highColor` varchar(6) default NULL,
  `highExpireDate` datetime default NULL,
  `state` char(1) default 'N',
  `createTime` datetime default NULL,
  `updateTime` timestamp NOT NULL default '0000-00-00 00:00:00',
  `updateUser` varchar(15) default NULL
) ENGINE=MyISAM DEFAULT CHARSET=gbk;

--
-- Dumping data for table `ejf_archive_topic`
--

/*!40000 ALTER TABLE `ejf_archive_topic` DISABLE KEYS */;
/*!40000 ALTER TABLE `ejf_archive_topic` ENABLE KEYS */;


--
-- Definition of table `ejf_attach`
--

DROP TABLE IF EXISTS `ejf_attach`;
CREATE TABLE `ejf_attach` (
  `attachID` int(11) NOT NULL auto_increment,
  `topicID` int(11) NOT NULL,
  `replyID` int(11) default '0',
  `userID` varchar(15) NOT NULL,
  `localname` varchar(50) NOT NULL,
  `localID` smallint(6) default '0',
  `filename` varchar(50) NOT NULL,
  `filesize` int(11) default '0',
  `credits` int(11) default '0',
  `title` varchar(50) default NULL,
  `downloads` int(11) default '0',
  `state` char(1) default 'N',
  `createTime` datetime default NULL,
  `updateTime` timestamp NOT NULL default CURRENT_TIMESTAMP on update CURRENT_TIMESTAMP,
  PRIMARY KEY  (`attachID`),
  KEY `topicID` (`topicID`),
  CONSTRAINT `ejf_attach_ibfk_1` FOREIGN KEY (`topicID`) REFERENCES `ejf_topic` (`topicID`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=gbk;

--
-- Dumping data for table `ejf_attach`
--

/*!40000 ALTER TABLE `ejf_attach` DISABLE KEYS */;
/*!40000 ALTER TABLE `ejf_attach` ENABLE KEYS */;


--
-- Definition of table `ejf_backup_task`
--

DROP TABLE IF EXISTS `ejf_backup_task`;
CREATE TABLE `ejf_backup_task` (
  `taskID` int(11) NOT NULL auto_increment,
  `inputFile` varchar(255) NOT NULL,
  `outputFile` varchar(255) NOT NULL,
  `runAt` char(1) default 'N',
  `sendmail` char(1) default 'T',
  `runMode` char(1) default 'A',
  `isOnlyFile` char(1) default 'T',
  `runStamp` varchar(20) default NULL,
  `remark` varchar(50) default NULL,
  `createTime` datetime default NULL,
  PRIMARY KEY  (`taskID`)
) ENGINE=InnoDB DEFAULT CHARSET=gbk;

--
-- Dumping data for table `ejf_backup_task`
--

/*!40000 ALTER TABLE `ejf_backup_task` DISABLE KEYS */;
/*!40000 ALTER TABLE `ejf_backup_task` ENABLE KEYS */;


--
-- Definition of table `ejf_board`
--

DROP TABLE IF EXISTS `ejf_board`;
CREATE TABLE `ejf_board` (
  `boardID` int(11) NOT NULL auto_increment,
  `sectionID` int(11) NOT NULL,
  `boardName` varchar(20) NOT NULL,
  `highColor` varchar(6) default NULL,
  `seqno` int(11) default '1',
  `brief` varchar(100) default NULL,
  `keywords` varchar(100) default NULL,
  `moderator` varchar(60) default NULL,
  `viewStyle` varchar(20) default NULL,
  `sortField` varchar(20) default NULL,
  `isImageOK` char(1) default 'T',
  `isMediaOK` char(1) default 'F',
  `isGuestPostOK` char(1) default 'F',
  `allowGroups` varchar(20) default NULL,
  `acl` varchar(100) default NULL,
  `ruleCode` text,
  `headAdCode` text,
  `footAdCode` text,
  `state` char(1) default 'N',
  `createTime` datetime default NULL,
  `updateTime` timestamp NOT NULL default CURRENT_TIMESTAMP on update CURRENT_TIMESTAMP,
  PRIMARY KEY  (`boardID`),
  KEY `sectionID` (`sectionID`),
  CONSTRAINT `ejf_board_ibfk_1` FOREIGN KEY (`sectionID`) REFERENCES `ejf_section` (`sectionID`)
) ENGINE=InnoDB DEFAULT CHARSET=gbk;

--
-- Dumping data for table `ejf_board`
--

/*!40000 ALTER TABLE `ejf_board` DISABLE KEYS */;
INSERT INTO `ejf_board` (`boardID`,`sectionID`,`boardName`,`highColor`,`seqno`,`brief`,`keywords`,`moderator`,`viewStyle`,`sortField`,`isImageOK`,`isMediaOK`,`isGuestPostOK`,`allowGroups`,`acl`,`ruleCode`,`headAdCode`,`footAdCode`,`state`,`createTime`,`updateTime`) VALUES 
 (1,1,'默认版块',NULL,1,'',NULL,NULL,NULL,NULL,'T','F','F','AMSG1234567','',NULL,NULL,NULL,'N','2008-08-19 17:12:54','2008-08-19 17:12:54'),
 (2,2,'论坛公告',NULL,1,'论坛公告发布，版主任免，管理与奖惩决定公布等',NULL,NULL,NULL,NULL,'T','F','F','AMSG1234567','F_AMS',NULL,NULL,NULL,'N','2008-08-19 17:12:54','2008-08-19 17:12:54'),
 (3,2,'站务管理',NULL,2,'意见、建议发表，系统BUG报告等',NULL,NULL,NULL,NULL,'T','F','F','AMSG1234567','',NULL,NULL,NULL,'N','2008-08-19 17:12:54','2008-08-19 17:12:54');
/*!40000 ALTER TABLE `ejf_board` ENABLE KEYS */;


--
-- Definition of table `ejf_bookmark`
--

DROP TABLE IF EXISTS `ejf_bookmark`;
CREATE TABLE `ejf_bookmark` (
  `markID` int(11) NOT NULL auto_increment,
  `userID` varchar(15) NOT NULL,
  `url` varchar(100) NOT NULL,
  `title` varchar(100) NOT NULL,
  `boardName` varchar(20) default NULL,
  `createTime` datetime default NULL,
  PRIMARY KEY  (`markID`),
  KEY `userID` (`userID`),
  CONSTRAINT `ejf_bookmark_ibfk_1` FOREIGN KEY (`userID`) REFERENCES `ejf_user` (`userID`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=gbk;

--
-- Dumping data for table `ejf_bookmark`
--

/*!40000 ALTER TABLE `ejf_bookmark` DISABLE KEYS */;
/*!40000 ALTER TABLE `ejf_bookmark` ENABLE KEYS */;


--
-- Definition of table `ejf_censor_log`
--

DROP TABLE IF EXISTS `ejf_censor_log`;
CREATE TABLE `ejf_censor_log` (
  `logID` int(11) NOT NULL auto_increment,
  `userID` varchar(15) default NULL,
  `boardID` int(11) NOT NULL,
  `boardName` varchar(20) NOT NULL,
  `topicID` int(11) NOT NULL,
  `topicTitle` varchar(100) NOT NULL,
  `replyID` int(11) default '0',
  `reason` varchar(40) NOT NULL,
  `createTime` datetime default NULL,
  PRIMARY KEY  (`logID`)
) ENGINE=InnoDB DEFAULT CHARSET=gbk;

--
-- Dumping data for table `ejf_censor_log`
--

/*!40000 ALTER TABLE `ejf_censor_log` DISABLE KEYS */;
/*!40000 ALTER TABLE `ejf_censor_log` ENABLE KEYS */;


--
-- Definition of table `ejf_credits_log`
--

DROP TABLE IF EXISTS `ejf_credits_log`;
CREATE TABLE `ejf_credits_log` (
  `logID` int(11) NOT NULL auto_increment,
  `userID` varchar(15) NOT NULL,
  `fromUser` varchar(15) default NULL,
  `credits` smallint(6) default '0',
  `action` varchar(10) NOT NULL,
  `createTime` datetime default NULL,
  PRIMARY KEY  (`logID`)
) ENGINE=InnoDB DEFAULT CHARSET=gbk;

--
-- Dumping data for table `ejf_credits_log`
--

/*!40000 ALTER TABLE `ejf_credits_log` DISABLE KEYS */;
/*!40000 ALTER TABLE `ejf_credits_log` ENABLE KEYS */;


--
-- Definition of table `ejf_error_log`
--

DROP TABLE IF EXISTS `ejf_error_log`;
CREATE TABLE `ejf_error_log` (
  `logID` int(11) NOT NULL auto_increment,
  `userID` varchar(15) NOT NULL,
  `remoteIP` varchar(25) default NULL,
  `action` varchar(10) NOT NULL,
  `errorInfo` varchar(100) default NULL,
  `createTime` datetime default NULL,
  PRIMARY KEY  (`logID`)
) ENGINE=InnoDB DEFAULT CHARSET=gbk;

--
-- Dumping data for table `ejf_error_log`
--

/*!40000 ALTER TABLE `ejf_error_log` DISABLE KEYS */;
/*!40000 ALTER TABLE `ejf_error_log` ENABLE KEYS */;


--
-- Definition of table `ejf_friend`
--

DROP TABLE IF EXISTS `ejf_friend`;
CREATE TABLE `ejf_friend` (
  `userID` varchar(15) NOT NULL,
  `friendID` varchar(15) NOT NULL,
  `remark` varchar(50) default NULL,
  `createTime` datetime default NULL,
  PRIMARY KEY  (`userID`,`friendID`),
  KEY `userID` (`userID`),
  CONSTRAINT `ejf_friend_ibfk_1` FOREIGN KEY (`userID`) REFERENCES `ejf_user` (`userID`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=gbk;

--
-- Dumping data for table `ejf_friend`
--

/*!40000 ALTER TABLE `ejf_friend` DISABLE KEYS */;
/*!40000 ALTER TABLE `ejf_friend` ENABLE KEYS */;


--
-- Definition of table `ejf_group`
--

DROP TABLE IF EXISTS `ejf_group`;
CREATE TABLE `ejf_group` (
  `groupID` char(1) NOT NULL,
  `groupName` varchar(15) NOT NULL,
  `groupType` char(1) default 'M',
  `minCredits` int(11) default '0',
  `stars` int(11) default '1',
  `rights` varchar(50) NOT NULL,
  `createTime` datetime default NULL,
  `updateTime` timestamp NOT NULL default CURRENT_TIMESTAMP on update CURRENT_TIMESTAMP,
  PRIMARY KEY  (`groupID`)
) ENGINE=InnoDB DEFAULT CHARSET=gbk;

--
-- Dumping data for table `ejf_group`
--

/*!40000 ALTER TABLE `ejf_group` DISABLE KEYS */;
INSERT INTO `ejf_group` (`groupID`,`groupName`,`groupType`,`minCredits`,`stars`,`rights`,`createTime`,`updateTime`) VALUES 
 ('1','乞丐','M',-999999,0,'ACG','2008-08-19 17:12:54','2008-08-19 17:12:54'),
 ('2','贫民','M',-50,1,'ACFG','2008-08-19 17:12:54','2008-08-19 17:12:54'),
 ('3','新手上路','M',0,1,'ABCEFGJK','2008-08-19 17:12:54','2008-08-19 17:12:54'),
 ('4','初级会员','M',50,2,'ABCEFGWJK','2008-08-19 17:12:54','2008-08-19 17:12:54'),
 ('5','中级会员','M',500,3,'ABCEFGWHJK','2008-08-19 17:12:54','2008-08-19 17:12:54'),
 ('6','高级会员','M',1500,4,'ABCDEFGWHJK','2008-08-19 17:12:54','2008-08-19 17:12:54'),
 ('7','论坛元老','M',3000,5,'ABCDEFGWHJKT','2008-08-19 17:12:54','2008-08-19 17:12:54'),
 ('A','管理员','S',0,9,'ABCDEFGWHIJKLMNOPQRSTUV','2008-08-19 17:12:54','2008-08-19 17:12:54'),
 ('G','游客','S',0,0,'ABCJ','2008-08-19 17:12:54','2008-08-19 17:12:54'),
 ('M','版主','S',0,7,'ABCDEFGWHJKLMNOQRST','2008-08-19 17:12:54','2008-08-19 17:12:54'),
 ('S','超级版主','S',0,8,'ABCDEFGWHIJKLMNOQRST','2008-08-19 17:12:54','2008-08-19 17:12:54');
/*!40000 ALTER TABLE `ejf_group` ENABLE KEYS */;


--
-- Definition of table `ejf_moderator_log`
--

DROP TABLE IF EXISTS `ejf_moderator_log`;
CREATE TABLE `ejf_moderator_log` (
  `logID` int(11) NOT NULL auto_increment,
  `userID` varchar(15) NOT NULL,
  `groupName` varchar(15) NOT NULL,
  `remoteIP` varchar(25) default NULL,
  `boardID` int(11) NOT NULL,
  `boardName` varchar(20) NOT NULL,
  `topicID` int(11) NOT NULL,
  `topicTitle` varchar(100) NOT NULL,
  `replyID` int(11) default '0',
  `action` varchar(10) NOT NULL,
  `reason` varchar(40) NOT NULL,
  `createTime` datetime default NULL,
  PRIMARY KEY  (`logID`)
) ENGINE=InnoDB DEFAULT CHARSET=gbk;

--
-- Dumping data for table `ejf_moderator_log`
--

/*!40000 ALTER TABLE `ejf_moderator_log` DISABLE KEYS */;
/*!40000 ALTER TABLE `ejf_moderator_log` ENABLE KEYS */;


--
-- Definition of table `ejf_reply`
--

DROP TABLE IF EXISTS `ejf_reply`;
CREATE TABLE `ejf_reply` (
  `replyID` int(11) NOT NULL auto_increment,
  `topicID` int(11) NOT NULL,
  `userID` varchar(15) NOT NULL,
  `remoteIP` varchar(25) default NULL,
  `title` varchar(100) default NULL,
  `content` mediumtext NOT NULL,
  `attaches` tinyint(4) default '0',
  `isHidePost` char(1) default 'F',
  `isBest` char(1) default 'F',
  `state` char(1) default 'N',
  `createTime` datetime default NULL,
  `updateTime` timestamp NOT NULL default CURRENT_TIMESTAMP on update CURRENT_TIMESTAMP,
  PRIMARY KEY  (`replyID`),
  KEY `topicID` (`topicID`),
  CONSTRAINT `ejf_reply_ibfk_1` FOREIGN KEY (`topicID`) REFERENCES `ejf_topic` (`topicID`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=gbk;

--
-- Dumping data for table `ejf_reply`
--

/*!40000 ALTER TABLE `ejf_reply` DISABLE KEYS */;
/*!40000 ALTER TABLE `ejf_reply` ENABLE KEYS */;


--
-- Definition of table `ejf_report_log`
--

DROP TABLE IF EXISTS `ejf_report_log`;
CREATE TABLE `ejf_report_log` (
  `logID` int(11) NOT NULL auto_increment,
  `userID` varchar(15) default NULL,
  `reportedUser` varchar(15) default NULL,
  `boardID` int(11) NOT NULL,
  `boardName` varchar(20) NOT NULL,
  `topicID` int(11) NOT NULL,
  `topicTitle` varchar(100) NOT NULL,
  `replyID` int(11) default '0',
  `reason` varchar(40) NOT NULL,
  `createTime` datetime default NULL,
  PRIMARY KEY  (`logID`)
) ENGINE=InnoDB DEFAULT CHARSET=gbk;

--
-- Dumping data for table `ejf_report_log`
--

/*!40000 ALTER TABLE `ejf_report_log` DISABLE KEYS */;
/*!40000 ALTER TABLE `ejf_report_log` ENABLE KEYS */;


--
-- Definition of table `ejf_section`
--

DROP TABLE IF EXISTS `ejf_section`;
CREATE TABLE `ejf_section` (
  `sectionID` int(11) NOT NULL auto_increment,
  `sectionName` varchar(20) NOT NULL,
  `seqno` int(11) default '1',
  `cols` int(11) default '1',
  `moderator` varchar(60) default NULL,
  `state` char(1) default 'N',
  `createTime` datetime default NULL,
  `updateTime` timestamp NOT NULL default CURRENT_TIMESTAMP on update CURRENT_TIMESTAMP,
  PRIMARY KEY  (`sectionID`)
) ENGINE=InnoDB DEFAULT CHARSET=gbk;

--
-- Dumping data for table `ejf_section`
--

/*!40000 ALTER TABLE `ejf_section` DISABLE KEYS */;
INSERT INTO `ejf_section` (`sectionID`,`sectionName`,`seqno`,`cols`,`moderator`,`state`,`createTime`,`updateTime`) VALUES 
 (1,'默认分区',1,1,NULL,'N','2008-08-19 17:12:54','2008-08-19 17:12:54'),
 (2,'站务管理',2,1,NULL,'N','2008-08-19 17:12:54','2008-08-19 17:12:54');
/*!40000 ALTER TABLE `ejf_section` ENABLE KEYS */;


--
-- Definition of table `ejf_short_msg`
--

DROP TABLE IF EXISTS `ejf_short_msg`;
CREATE TABLE `ejf_short_msg` (
  `msgID` int(11) NOT NULL auto_increment,
  `title` varchar(100) NOT NULL,
  `message` varchar(200) default NULL,
  `userID` varchar(15) NOT NULL,
  `fromUser` varchar(15) NOT NULL,
  `outflag` char(1) default 'N',
  `state` char(1) default 'N',
  `createTime` datetime default NULL,
  `updateTime` timestamp NOT NULL default CURRENT_TIMESTAMP on update CURRENT_TIMESTAMP,
  PRIMARY KEY  (`msgID`),
  KEY `userID` (`userID`),
  CONSTRAINT `ejf_short_msg_ibfk_1` FOREIGN KEY (`userID`) REFERENCES `ejf_user` (`userID`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=gbk;

--
-- Dumping data for table `ejf_short_msg`
--

/*!40000 ALTER TABLE `ejf_short_msg` DISABLE KEYS */;
/*!40000 ALTER TABLE `ejf_short_msg` ENABLE KEYS */;


--
-- Definition of table `ejf_topic`
--

DROP TABLE IF EXISTS `ejf_topic`;
CREATE TABLE `ejf_topic` (
  `topicID` int(11) NOT NULL auto_increment,
  `boardID` int(11) NOT NULL,
  `sectionID` int(11) default '0',
  `userID` varchar(15) NOT NULL,
  `nickname` varchar(15) default NULL,
  `remoteIP` varchar(25) default NULL,
  `title` varchar(100) NOT NULL,
  `content` mediumtext,
  `reward` smallint(6) default '0',
  `visits` int(11) default '0',
  `replies` int(11) default '0',
  `attaches` tinyint(4) default '0',
  `attachIcon` varchar(5) default NULL,
  `lastPostUser` varchar(15) NOT NULL,
  `lastNickname` varchar(15) default NULL,
  `lastPostTime` datetime default NULL,
  `isDigest` char(1) default 'F',
  `isReplyNotice` char(1) default 'F',
  `isHidePost` char(1) default 'F',
  `isSolved` char(1) default 'F',
  `topScope` char(1) default 'N',
  `topExpireDate` datetime default NULL,
  `highColor` varchar(6) default NULL,
  `highExpireDate` datetime default NULL,
  `state` char(1) default 'N',
  `createTime` datetime default NULL,
  `updateTime` timestamp NOT NULL default CURRENT_TIMESTAMP on update CURRENT_TIMESTAMP,
  `updateUser` varchar(15) default NULL,
  PRIMARY KEY  (`topicID`),
  KEY `boardID` (`boardID`),
  CONSTRAINT `ejf_topic_ibfk_1` FOREIGN KEY (`boardID`) REFERENCES `ejf_board` (`boardID`)
) ENGINE=InnoDB DEFAULT CHARSET=gbk;

--
-- Dumping data for table `ejf_topic`
--

/*!40000 ALTER TABLE `ejf_topic` DISABLE KEYS */;
/*!40000 ALTER TABLE `ejf_topic` ENABLE KEYS */;


--
-- Definition of table `ejf_trash_box`
--

DROP TABLE IF EXISTS `ejf_trash_box`;
CREATE TABLE `ejf_trash_box` (
  `topicID` int(11) NOT NULL,
  `replyID` int(11) NOT NULL default '0',
  `boardID` int(11) NOT NULL,
  `boardName` varchar(20) NOT NULL,
  `topicTitle` varchar(100) NOT NULL,
  `userID` varchar(15) NOT NULL,
  `deleteUser` varchar(15) NOT NULL,
  `createTime` datetime default NULL,
  PRIMARY KEY  (`topicID`,`replyID`)
) ENGINE=InnoDB DEFAULT CHARSET=gbk;

--
-- Dumping data for table `ejf_trash_box`
--

/*!40000 ALTER TABLE `ejf_trash_box` DISABLE KEYS */;
/*!40000 ALTER TABLE `ejf_trash_box` ENABLE KEYS */;


--
-- Definition of table `ejf_user`
--

DROP TABLE IF EXISTS `ejf_user`;
CREATE TABLE `ejf_user` (
  `userID` varchar(15) NOT NULL,
  `nickname` varchar(15) default NULL,
  `pwd` varchar(32) NOT NULL,
  `email` varchar(40) NOT NULL,
  `icq` varchar(40) default NULL,
  `webpage` varchar(60) default NULL,
  `avatar` varchar(50) default NULL,
  `gender` char(1) default 'U',
  `birth` varchar(10) default NULL,
  `city` varchar(20) default NULL,
  `remoteIP` varchar(25) default NULL,
  `brief` varchar(200) default NULL,
  `isMailPub` char(1) default 'F',
  `posts` int(11) default '0',
  `unreadSMs` int(11) default '0',
  `credits` int(11) default '0',
  `groupID` char(1) default '1',
  `lastVisited` datetime default NULL,
  `visitCount` int(11) default '1',
  `loginCount` tinyint(4) default '0',
  `loginExpire` datetime default NULL,
  `setpwdExpire` datetime default NULL,
  `state` char(1) default 'N',
  `createTime` datetime default NULL,
  `updateTime` timestamp NOT NULL default CURRENT_TIMESTAMP on update CURRENT_TIMESTAMP,
  PRIMARY KEY  (`userID`),
  UNIQUE KEY `email` (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=gbk;

--
-- Dumping data for table `ejf_user`
--

/*!40000 ALTER TABLE `ejf_user` DISABLE KEYS */;
/*!40000 ALTER TABLE `ejf_user` ENABLE KEYS */;


--
-- Definition of table `ejf_visit_stat`
--

DROP TABLE IF EXISTS `ejf_visit_stat`;
CREATE TABLE `ejf_visit_stat` (
  `statDate` varchar(10) NOT NULL,
  `topics` int(11) default '0',
  `replies` int(11) default '0',
  `users` int(11) default '0',
  `visits` int(11) default '0',
  PRIMARY KEY  (`statDate`)
) ENGINE=InnoDB DEFAULT CHARSET=gbk;

--
-- Dumping data for table `ejf_visit_stat`
--

/*!40000 ALTER TABLE `ejf_visit_stat` DISABLE KEYS */;
/*!40000 ALTER TABLE `ejf_visit_stat` ENABLE KEYS */;




/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
