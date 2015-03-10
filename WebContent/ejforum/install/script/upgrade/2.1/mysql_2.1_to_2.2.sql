CREATE TABLE ejf_archive_topic ENGINE=InnoDB AS SELECT * FROM ejf_topic WHERE state='R' and createTime > NOW();
CREATE TABLE ejf_archive_reply ENGINE=InnoDB AS SELECT * FROM ejf_reply WHERE state='R' and createTime > NOW();

ALTER TABLE ejf_board ADD ruleCode TEXT;