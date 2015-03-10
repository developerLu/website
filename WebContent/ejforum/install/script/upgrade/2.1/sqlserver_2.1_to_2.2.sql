SELECT * INTO ejf_archive_topic FROM ejf_topic WHERE state='R' and createTime > GETDATE();
SELECT * INTO ejf_archive_reply FROM ejf_reply WHERE state='R' and createTime > GETDATE();

ALTER TABLE ejf_board ADD ruleCode TEXT;
