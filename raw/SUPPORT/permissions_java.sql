EXEC DBMS_JAVA.grant_permission('NFCSUP', 'java.io.FilePermission', '*', 'read , execute');
EXEC DBMS_JAVA.grant_permission('NFCSUP', 'SYS:java.lang.RuntimePermission', 'writeFileDescriptor', '*');
EXEC DBMS_JAVA.grant_permission('NFCSUP', 'SYS:java.lang.RuntimePermission', 'readFileDescriptor', '*');
GRANT JAVAUSERPRIV TO NFCSUP;
