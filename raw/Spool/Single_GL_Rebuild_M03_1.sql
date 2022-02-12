set serveroutput on

spool C:\Single_GL_Rebuild_M10_1.spl

DECLARE     

begin

---- Rebuild for Branch 020
  global.pr_init('020', 'SYSTEM');

  DEBUG.pr_debug('GL', 'Calling fn_check_int_gls ');

  FOR b in (select gl_code from gltm_glmaster where gl_code in('711001000','712001000','713001000','713004100','985100000','997100000'))
  LOOP   
         
  -- branch,per,cycle,branch lcy, gl, gl's ccy
  if not fn_check_int_gls('020', 'M03', 'FY2013', 'XAF', b.GL_CODE, 'XAF') then
    DEBUG.pr_debug('GL', 'FAILED.... fn_check_int_gls');
  else
    DEBUG.pr_debug('GL', 'DONE.... fn_check_int_gls');
    dbms_output.put_line('DONE....');
    commit;
  end if;

  DEBUG.pr_debug('GL', 'Calling fn_check_int_gls ');
  if not fn_build_int_gls('020', 'M03', 'FY2013', 'XAF') then
    DEBUG.pr_debug('GL', 'FAILED.... fn_build_int_gls');
    rollback;
  else
    DEBUG.pr_debug('GL', 'DONE.... fn_build_int_gls');
    commit;
  end if;

  DEBUG.pr_debug('GL', 'B4 END');
  END LOOP;  

---- Rebuild for Branch 021
  global.pr_init('021', 'SYSTEM');

  FOR b in (select gl_code from gltm_glmaster where gl_code in('378001000','714001000'))
  LOOP   
         
  -- branch,per,cycle,branch lcy, gl, gl's ccy
  if not fn_check_int_gls('021', 'M03', 'FY2013', 'XAF', b.GL_CODE, 'XAF') then
    DEBUG.pr_debug('GL', 'FAILED.... fn_check_int_gls');
  else
    DEBUG.pr_debug('GL', 'DONE.... fn_check_int_gls');
    dbms_output.put_line('DONE....');
    commit;
  end if;

  DEBUG.pr_debug('GL', 'Calling fn_check_int_gls ');
  if not fn_build_int_gls('021', 'M03', 'FY2013', 'XAF') then
    DEBUG.pr_debug('GL', 'FAILED.... fn_build_int_gls');
    rollback;
  else
    DEBUG.pr_debug('GL', 'DONE.... fn_build_int_gls');
    commit;
  end if;

  DEBUG.pr_debug('GL', 'B4 END');
  
  END LOOP;


---- Rebuild for Branch 041

  global.pr_init('041', 'SYSTEM');

FOR b in (select gl_code from gltm_glmaster where gl_code in('434003000','714001000','719006000')) 
  LOOP   
         
  -- branch,per,cycle,branch lcy, gl, gl's ccy
  if not fn_check_int_gls('041', 'M03', 'FY2013', 'XAF', b.GL_CODE, 'XAF') then
    DEBUG.pr_debug('GL', 'FAILED.... fn_check_int_gls');
  else
    DEBUG.pr_debug('GL', 'DONE.... fn_check_int_gls');
    dbms_output.put_line('DONE....');
    commit;
  end if;

  DEBUG.pr_debug('GL', 'Calling fn_check_int_gls ');
  if not fn_build_int_gls('041', 'M03', 'FY2013', 'XAF') then
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