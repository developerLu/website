ALTER TABLE ejf_board ADD acl VARCHAR2(100);

ALTER TABLE ejf_backup_task ADD runMode CHAR(1)	DEFAULT 'A';
ALTER TABLE ejf_backup_task ADD isOnlyFile CHAR(1) DEFAULT 'T';
ALTER TABLE ejf_backup_task ADD runStamp VARCHAR2(20);