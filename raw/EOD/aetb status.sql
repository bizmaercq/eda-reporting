select * from aetb_eoc_branches;
SELECT * FROM STTM_BRANCH where branch_code in ('020');

select * from aetb_eoc_runchart;
select * from aetb_eoc_runchart_history where branch_code in ('023') and eod_date='21-MAY-2018';

select * from aetb_eoc_programs;
select * from eitb_pending_programs;
select * from aetb_eoc_runchart where eoc_stage_status in ('W','A');
select * from eitb_pending_programs where RUN_STAT = 'E';
select * from aetb_eoc_programs where BRANCH_CODE in ('040','030','020','021','043');

select * from CSTB_PARAM WHERE PARAM_NAME in ('DEBUG','REAL_DEBUG');
select * from CSTB_DEBUG_USERS where user_id='SYSTEM';

select * from gv$session where sid in ('911','1420','277','17','12');

select * from eitb_pending_programs where RUN_STAT = 'W';

-- Database restarted ?
yes
ok

we need mark these batches as aborted;;;then resubmit ;;;;
can u please share aetb.xls to MOS.

done
ok

have u resubmitted any branch/

yes branch 020 but still eoc status N

can u please kill the all inactive sessions
i²ll prepare the script to mark it abort 

sharewith u in few mins;;;;;don²t resubmit till then
due to db restart ;;;there si alot of inactive sessions
Please kill the inactive sessions
ok


Please execute attached 3-17544332851.sql and share the spool generated.
ok

now submit eod for branch 020 only
ok
done


now enable the debug fpr EOD user id and SYSTEM user
and submit 030 in debug mode;
ok should i share the debug with MOS

yes;;;
ok
done

rename the file  FDONG010.TXT and upload again
?


i should rename it what ?

attach this file
done

we are checking the latest debugs
ok

when u have done DB restart/
  6 hour ago
  during EOD/?when branches aborted i restarded
  yes during eod
  ok
  shoe me the debug aera
  
  Hi
  hello
  can you please arrange the application server restart;;;
  ???
  no i can't
  whenever you submit EOd from frontend, connectivity get lost and session becomes inactive
  so eod gets stuck
  let me call the system engineer 
  Yes;;;Please update on MOS once application server is restarted;
  I just had word on this with my senior team member and he suggested to application server restart;
  ok
