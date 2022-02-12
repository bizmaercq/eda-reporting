select 'User: '||s1.username || '@' || s1.machine || '(SID=' || s1.sid ||' ) running SQL_ID:'||s1.sql_id||' is blocking
User: '|| s2.username || '@' || s2.machine || '(SID=' || s2.sid || ') running SQL_ID:'||s2.sql_id||' For '||s2.SECONDS_IN_WAIT||' sec
---------------------------------------------------------------------
Warn user '||s1.username||' Or use this statement to kill his session:
---------------------------------------------------------------------
ALTER SYSTEM KILL SESSION '''||s1.sid||','||s1.serial#||''' immediate;' AS blocking_status 
from gv$LOCK l1, gv$SESSION s1, gv$LOCK l2, gv$SESSION s2
where s1.sid=l1.sid and s2.sid=l2.sid
and l1.BLOCK=1 and l2.request > 0
and l1.id1 = l2.id1
and l2.id2 = l2.id2
order by s2.SECONDS_IN_WAIT desc;

SELECT * FROM fbtb_till_;
