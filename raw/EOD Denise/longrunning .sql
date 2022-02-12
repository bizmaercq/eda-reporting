set line 1000
set pagesize 10000
set trimspool on
set numformat 99999999999999999999.99
spool c:\longrunning.spl

SELECT a.inst_id "INST",b.object_name "OBJ_NAME",a.os_user_name "OS_USER",A.oracle_username "ORACLE_USER",
       c.terminal "TERMINAL",c.program "PROGRAM",NVL(lockwait,'ACTIVE') "LOCKWAIT",
       INITCAP(DECODE(a.locked_mode,2,'ROW SHARE',3,'ROW EXCLUSIVE',4,'SHARE',5,'SHARE ROW EXCLUSIVE',6,'EXCLUSIVE','UNKNOWN')) "LOCKMODE",
       b.object_type "OBJECT_TYPE",D.SPID "SERVER_PID",A.SESSION_ID "SESSION_ID",C.SERIAL# "SERIAL_NO",C.Status "Status",Sysdate
FROM   SYS.GV_$LOCKED_OBJECT A,   SYS.ALL_OBJECTS B,   SYS.GV_$SESSION c ,SYS.GV_$PROCESS D
WHERE   A.OBJECT_ID = B.OBJECT_ID
AND     C.SID = A.SESSION_ID
AND     C.INST_ID = A.INST_ID
AND     C.PADDR = D.ADDR
AND     C.INST_ID = D.INST_ID
ORDER BY 2
/
select A.inst_id "Instance",A.sid "Sid",A.serial# "Serial No.",A.machine "Machine",A.terminal "Terminal",
       A.program "Program",B.sql_text "Query",B.users_executing "Users" ,C.opname "Operation",C.target "Target",
       C.sofar "Till Now",C.totalwork "Total Work",C.Time_Remaining "Remaining Time",C.elapsed_seconds "Time Taken",C.Message "Message",
       A.username "User",A.status "Status" , sysdate "Time"
from   gv$session A,gv$sql B,gv$session_longops C
where  A.sql_address = B.address
and    B.users_executing > 0
and    C.inst_id(+) = A.inst_id
and    C.sid(+) = A.sid
and    C.serial#(+) = A.serial#
and    C.sql_address(+) = A.sql_address
/
spool off