SELECT * INTO CACHED ejf_archive_topic FROM ejf_topic WHERE state='R' and createTime > NOW();
SELECT * INTO CACHED ejf_archive_reply FROM ejf_reply WHERE state='R' and createTime > NOW();

ALTER TABLE ejf_board ADD ruleCode LONGVARCHAR;