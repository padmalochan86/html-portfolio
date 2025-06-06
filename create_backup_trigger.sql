-- SQL script to create backup table and trigger for AWS_DBA.AURORA_ALL_DATABASE

CREATE TABLE aws_dba.aurora_all_database_bkp AS
  SELECT * FROM aws_dba.aurora_all_database WHERE 1=0;

ALTER TABLE aws_dba.aurora_all_database_bkp ADD (
  backup_timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
/

CREATE OR REPLACE TRIGGER aws_dba.trg_backup_aurora_all_database
AFTER DELETE OR UPDATE ON aws_dba.aurora_all_database
FOR EACH ROW
BEGIN
  INSERT INTO aws_dba.aurora_all_database_bkp (
    db_type,
    writer_host,
    reader_host,
    port,
    database_name,
    username,
    password,
    active,
    monitor,
    backup_timestamp
  ) VALUES (
    :OLD.db_type,
    :OLD.writer_host,
    :OLD.reader_host,
    :OLD.port,
    :OLD.database_name,
    :OLD.username,
    :OLD.password,
    :OLD.active,
    :OLD.monitor,
    SYSTIMESTAMP
  );
END;
/
