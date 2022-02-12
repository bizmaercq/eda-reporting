Use this approach to rebuild the standby database from scratch, this process will drop and recreate standby database by taking active backup from Primary Database.
1.	There is no need to change database parameter file in both database.
2.	Shutdown the Standby database (reporting) .
login to server 172.20.50.14 as oracle user
sqlplus “/ as sysdba”
sql> Shutdown immediate

3.	Start Standby database in nomount stage
Login to server 172.20.50.14 as Oracle user
Sqlplus “/ as sysdba”
SQL> Startup nomount

4.	Connect RMAN console
login to server 172.20.50.14 as oracle user
$ rman TARGET sys/<password>@FCUBS AUXILIARY sys/<password>@FCRPUBS

rman> run {
allocate channel prmy1 type disk;
allocate channel prmy2 type disk;
allocate auxiliary channel stby1 type disk;
allocate auxiliary channel stby2 type disk;
duplicate target database for standby from active database dorecover nofilenamecheck;
}

5.	Start Manage Recovery Process
login to server 172.20.50.14 as oracle user
sqlplus “/ as sysdba”
SQL> shutdown immediate
SQL> startup nomount
SQL> ALTER DATABASE MOUNT STANDBY DATABASE;
SQL> ALTER DATABASE RECOVER MANAGED STANDBY DATABASE   DISCONNECT FROM SESSION;
SQL>






6.	Check Recovery Process.
On the primary server, check the latest archived redo log and force a log switch.
login to server 172.20.50.11 as oracle user
$ sqlplus “/ as sysdba”

SQL> ALTER SESSION SET nls_date_format='DD-MON-YYYY HH24:MI:SS';

SQL> SELECT sequence#, first_time, next_time FROM  v$archived_log ORDER BY sequence#;

SQL> ALTER SYSTEM SWITCH LOGFILE;

SQL> exit;
Check the new archived redo log has arrived at the standby server and been applied.
login to server 172.20.50.14 as oracle user
$ sqlplus “/ as sysdba”

SQL> ALTER SESSION SET nls_date_format='DD-MON-YYYY HH24:MI:SS';

SQL> SELECT sequence#, first_time, next_time FROM  v$archived_log ORDER BY sequence#;

SQL> exit;

7.	Stop Recovery Process, and open database in READ-ONLY mode.
login to server 172.20.50.14 as oracle user
$ sqlplus “/ as sysdba”
$ SQL> ALTER DATABASE RECOVER MANAGED STANDBY DATABASE CANCEL;
$ SQL> ALTER DATABASE OPEN READ ONLY;

8.	Start Manage Recovery Process
login to server 172.20.50.14 as oracle user
$ sqlplus “/ as sysdba”
$ SQL> shutdown immediate
$ SQL> startup nomount
$ SQL> ALTER DATABASE MOUNT STANDBY DATABASE;
$ SQL> ALTER DATABASE RECOVER MANAGED STANDBY DATABASE   DISCONNECT FROM SESSION;
SQL>

