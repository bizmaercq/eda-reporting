-- Default tablespace

CREATE TABLESPACE FCCDFLT DATAFILE 
  '/u01/app/oracle/oradata/NFCSUP/FCCDFLT.DBF' SIZE 12288M AUTOEXTEND ON NEXT 5M MAXSIZE UNLIMITED
LOGGING
ONLINE
PERMANENT
EXTENT MANAGEMENT LOCAL UNIFORM SIZE 1M
BLOCKSIZE 8K
SEGMENT SPACE MANAGEMENT AUTO
FLASHBACK ON;


CREATE TABLESPACE FCUBS DATAFILE 
  '/u01/app/oracle/oradata/NFCSUP/FCUBS.DBF' SIZE 12288M AUTOEXTEND OFF
LOGGING
ONLINE
PERMANENT
EXTENT MANAGEMENT LOCAL UNIFORM SIZE 1M
BLOCKSIZE 8K
SEGMENT SPACE MANAGEMENT AUTO
FLASHBACK ON;


-- Tablespace for small size tables
CREATE TABLESPACE FCCDATASML DATAFILE 
  '/u01/app/oracle/oradata/NFCSUP/FCCDATASML.DBF' SIZE 2048M AUTOEXTEND ON NEXT 5M MAXSIZE UNLIMITED
LOGGING
ONLINE
PERMANENT
EXTENT MANAGEMENT LOCAL UNIFORM SIZE 1M
BLOCKSIZE 8K
SEGMENT SPACE MANAGEMENT AUTO
FLASHBACK ON;
-- Tablespace for medium size tables
CREATE TABLESPACE FCCDATAMED DATAFILE 
  '/u01/app/oracle/oradata/NFCSUP/FCCDATAMED.DBF' SIZE 2048M AUTOEXTEND OFF
LOGGING
ONLINE
PERMANENT
EXTENT MANAGEMENT LOCAL UNIFORM SIZE 1M
BLOCKSIZE 8K
SEGMENT SPACE MANAGEMENT AUTO
FLASHBACK ON;
-- Tablespace for large size tables
CREATE TABLESPACE FCCDATALAR DATAFILE 
  '/u01/app/oracle/oradata/NFCSUP/FCCDATALAR.DBF' SIZE 2048M AUTOEXTEND OFF
LOGGING
ONLINE
PERMANENT
EXTENT MANAGEMENT LOCAL UNIFORM SIZE 1M
BLOCKSIZE 8K
SEGMENT SPACE MANAGEMENT AUTO
FLASHBACK ON;

-- Tablespace for extra large size tables
CREATE TABLESPACE FCCDATAXL DATAFILE 
  '/u01/app/oracle/oradata/NFCSUP/FCCDATAXL.DBF' SIZE 2048M AUTOEXTEND OFF
LOGGING
ONLINE
PERMANENT
EXTENT MANAGEMENT LOCAL UNIFORM SIZE 1M
BLOCKSIZE 8K
SEGMENT SPACE MANAGEMENT AUTO
FLASHBACK ON;

-- Tablespace for small size tables indexes

CREATE TABLESPACE FCCINDXSML DATAFILE 
  '/u01/app/oracle/oradata/NFCSUP/FCCINDXSML.DBF' SIZE 2048M AUTOEXTEND OFF
LOGGING
ONLINE
PERMANENT
EXTENT MANAGEMENT LOCAL UNIFORM SIZE 1M
BLOCKSIZE 8K
SEGMENT SPACE MANAGEMENT AUTO
FLASHBACK ON;

-- Tablespace for medium size tables indexes

CREATE TABLESPACE FCCINDXMED DATAFILE 
  '/u01/app/oracle/oradata/NFCSUP/FCCINDXMED.DBF' SIZE 2048M AUTOEXTEND OFF
LOGGING
ONLINE
PERMANENT
EXTENT MANAGEMENT LOCAL UNIFORM SIZE 1M
BLOCKSIZE 8K
SEGMENT SPACE MANAGEMENT AUTO
FLASHBACK ON;

-- Tablespace for large size tables indexes

CREATE TABLESPACE FCCINDXLAR DATAFILE 
  '/u01/app/oracle/oradata/NFCSUP/FCCINDXLAR.DBF' SIZE 2048M AUTOEXTEND OFF
LOGGING
ONLINE
PERMANENT
EXTENT MANAGEMENT LOCAL UNIFORM SIZE 1M
BLOCKSIZE 8K
SEGMENT SPACE MANAGEMENT AUTO
FLASHBACK ON;

-- Tablespace for extra large size tables indexes

CREATE TABLESPACE FCCINDXXL DATAFILE 
  '/u01/app/oracle/oradata/NFCSUP/FCCINDXXL.DBF' SIZE 2048M AUTOEXTEND OFF
LOGGING
ONLINE
PERMANENT
EXTENT MANAGEMENT LOCAL UNIFORM SIZE 1M
BLOCKSIZE 8K
SEGMENT SPACE MANAGEMENT AUTO
FLASHBACK ON;



