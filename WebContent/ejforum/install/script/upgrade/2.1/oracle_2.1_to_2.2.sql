CREATE TABLE ejf_archive_topic AS SELECT * FROM ejf_topic WHERE state='R' and createTime > SYSDATE;
CREATE TABLE ejf_archive_reply AS SELECT * FROM ejf_reply WHERE state='R' and createTime > SYSDATE;

ALTER TABLE ejf_board ADD ruleCode CLOB;