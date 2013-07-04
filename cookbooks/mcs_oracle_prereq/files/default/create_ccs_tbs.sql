CREATE TABLESPACE CSERVICES_DATA_AUTO_01 datafile '/u01/app/oracle/oradata/MCS11G/eservices_data_auto_01_0001.dbf' SIZE 1000m
EXTENT MANAGEMENT LOCAL AUTOALLOCATE SEGMENT SPACE MANAGEMENT AUTO;
CREATE TABLESPACE CSERVICES_INDEX_AUTO_01 datafile '/u01/app/oracle/oradata/MCS11G/eservices_index_auto_01_0001.dbf' SIZE 1000m
EXTENT MANAGEMENT LOCAL AUTOALLOCATE SEGMENT SPACE MANAGEMENT AUTO;
CREATE TABLESPACE CSERVICES_LOB_AUTO_01 datafile '/u01/app/oracle/oradata/MCS11G/eservices_lob_auto_01_0001.dbf' SIZE 5000m
EXTENT MANAGEMENT LOCAL AUTOALLOCATE SEGMENT SPACE MANAGEMENT AUTO;
CREATE TABLESPACE CCRM_DATA_AUTO_01 datafile '/u01/app/oracle/oradata/MCS11G/ccrm_data_auto_01_0001.dbf' SIZE 500m
EXTENT MANAGEMENT LOCAL AUTOALLOCATE SEGMENT SPACE MANAGEMENT AUTO;
CREATE TABLESPACE CCRM_INDEX_AUTO_01 datafile '/u01/app/oracle/oradata/MCS11G/ccrm_index_auto_01_0001.dbf' SIZE 500m
EXTENT MANAGEMENT LOCAL AUTOALLOCATE SEGMENT SPACE MANAGEMENT AUTO;
create tablespace CKOUT datafile '/u01/app/oracle/oradata/MCS11G/ckout01.dbf' size 200M autoextend on next 100M maxsize 2G;
create tablespace CKOUT_LOB datafile '/u01/app/oracle/oradata/MCS11G/ckout_lob01.dbf' size 200M autoextend on next 100M maxsize 2G;
create tablespace FLEX datafile '/u01/app/oracle/oradata/MCS11G/flex01.dbf' size 200M autoextend on next 100M maxsize 2G;
QUIT

