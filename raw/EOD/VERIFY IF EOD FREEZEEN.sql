---- 1 --- Verifier l'execution en backend pendant le eod 

select 
      sql_text,
sesion.sid,sesion.serial#,sesion.username,sesion.osuser,
sesion.terminal,sesion.module,sesion.logon_time,sesion.last_call_et,
      optimizer_mode,
      hash_value,
      address
 from v$sqlarea sqlarea, v$session sesion
where sesion.sql_hash_value = sqlarea.hash_value
  and sesion.sql_address    = sqlarea.address
  and sesion.username is not null
and sqlarea.USERS_EXECUTING>0;



----2--- verifier l'execution de batch pendant le eod 

SELECT ENT_DT FROM ICTBS_ENTRIES_HISTORY WHERE BRN = :B4 AND ACC = :B3 AND PROD = :B2 AND LIQN = 'Y' AND ENT_DT < :B1 ORDER BY ENT_DT DESC



