set serveroutput on

spool C:\Single_GL_Rebuild_M03_2.spl

DECLARE     

begin

---- Rebuild for Branch 042
  global.pr_init('042', 'SYSTEM');

  DEBUG.pr_debug('GL', 'Calling fn_check_int_gls ');

  FOR b in (select gl_code from gltm_glmaster where gl_code in('328001000','341306000','345110000','434003000','712001000','713001000','713004100','985100000','997100000'))  
  LOOP   
         
  -- branch,per,cycle,branch lcy, gl, gl's ccy
  if not fn_check_int_gls('042', 'M03', 'FY2013', 'XAF', b.GL_CODE, 'XAF') then
    DEBUG.pr_debug('GL', 'FAILED.... fn_check_int_gls');
  else
    DEBUG.pr_debug('GL', 'DONE.... fn_check_int_gls');
    dbms_output.put_line('DONE....');
    commit;
  end if;

  DEBUG.pr_debug('GL', 'Calling fn_check_int_gls ');
  if not fn_build_int_gls('042', 'M03', 'FY2013', 'XAF') then
    DEBUG.pr_debug('GL', 'FAILED.... fn_build_int_gls');
    rollback;
  else
    DEBUG.pr_debug('GL', 'DONE.... fn_build_int_gls');
    commit;
  end if;

  DEBUG.pr_debug('GL', 'B4 END');
  END LOOP;  

---- Rebuild for Branch 043

  global.pr_init('043', 'SYSTEM');

  FOR b in (select gl_code from gltm_glmaster where gl_code in('378001000','549002000','612001000','714001000'))
  LOOP   
         
  -- branch,per,cycle,branch lcy, gl, gl's ccy
  if not fn_check_int_gls('043', 'M03', 'FY2013', 'XAF', b.GL_CODE, 'XAF') then
    DEBUG.pr_debug('GL', 'FAILED.... fn_check_int_gls');
  else
    DEBUG.pr_debug('GL', 'DONE.... fn_check_int_gls');
    dbms_output.put_line('DONE....');
    commit;
  end if;

  DEBUG.pr_debug('GL', 'Calling fn_check_int_gls ');
  if not fn_build_int_gls('043', 'M03', 'FY2013', 'XAF') then
    DEBUG.pr_debug('GL', 'FAILED.... fn_build_int_gls');
    rollback;
  else
    DEBUG.pr_debug('GL', 'DONE.... fn_build_int_gls');
    commit;
  end if;

  DEBUG.pr_debug('GL', 'B4 END');
  
  END LOOP;


---- Rebuild for Branch 051

  global.pr_init('051', 'SYSTEM');

  FOR b in (select gl_code from gltm_glmaster where gl_code in('712001000','713001000','713004100'))  
  LOOP   
         
  -- branch,per,cycle,branch lcy, gl, gl's ccy
  if not fn_check_int_gls('051', 'M03', 'FY2013', 'XAF', b.GL_CODE, 'XAF') then
    DEBUG.pr_debug('GL', 'FAILED.... fn_check_int_gls');
  else
    DEBUG.pr_debug('GL', 'DONE.... fn_check_int_gls');
    dbms_output.put_line('DONE....');
    commit;
  end if;

  DEBUG.pr_debug('GL', 'Calling fn_check_int_gls ');
  if not fn_build_int_gls('051', 'M03', 'FY2013', 'XAF') then
    DEBUG.pr_debug('GL', 'FAILED.... fn_build_int_gls');
    rollback;
  else
    DEBUG.pr_debug('GL', 'DONE.... fn_build_int_gls');
    commit;
  end if;

  DEBUG.pr_debug('GL', 'B4 END');
  
  END LOOP;


end;
/

SELECT * FROM gltbs_mismatch
/

SELECT * FROM gltbs_mismatch_mov
/

SPOOL OFF;