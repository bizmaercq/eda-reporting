select * from v$session where username ='NFCEOD'

select 'ALTER SYSTEM KILL SESSION '''||sid||','||serial#||''' immediate' from v$session where username ='NFCEOD' ;


ALTER SYSTEM KILL SESSION '48,12507' immediate;
ALTER SYSTEM KILL SESSION '1660,31055' immediate;
ALTER SYSTEM KILL SESSION '2190,19575' immediate;
ALTER SYSTEM KILL SESSION '2721,14959' immediate;


ALTER SYSTEM KILL SESSION '1117,203' immediate;
ALTER SYSTEM KILL SESSION '2186,217' immediate;
