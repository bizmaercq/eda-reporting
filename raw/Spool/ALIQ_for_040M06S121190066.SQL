set array 1
set head on
set feedback on
set line 1000
set pagesize 10000
set echo on
set trimspool on
set numformat 99999999999999999999.99
set colsep ","
set server output ON
set long 100000

spool c:\XAFNFCFCC0039_ALIQ.spl

declare
			p_account varchar2(35) := '040M06S121190066';
			p_branch   varchar2(3) := '040';            
			p_error_code   ertbs_msgs.err_code%type;
			p_error_param  ertbs_msgs.message%type;
			l_account_obj clpkss_object.ty_rec_account;
begin
            global.pr_init ('040','SYSTEM');
            clpkss_batch.g_commit_freq := 1000;
            
            debug.pr_debug('CL','Going to insert one ALIQ entry');
            
            
						IF NOT clpkss_object.fn_create_acct_object(p_account,
																											 p_branch,
																											 l_account_obj,
																											 p_error_code,
																											 p_error_param)
						THEN
								DBMS_OUTPUT.PUT_LINE('Failed wit clpkss_object.fn_create_acct_object with :-(' || p_error_code || p_error_param);
								RETURN;
						END IF;            
						
						debug.pr_debug('CL','Going to call fn_aliq_for_an_account');
						IF NOT clpkss_liqd.fn_aliq_for_an_account(p_account,
															p_branch,
															global.application_date,
															p_error_code,
															p_error_param)
						THEN
							 DBMS_OUTPUT.PUT_LINE('clpkss_liqd.fn_aliq_for_a_day failed with :-( ' || p_error_code || p_error_param);
							else
								dbms_output.put_line('ALIQ successful');
						END IF;  

					   IF NOT clpkss_accounting.fn_accounting_for_loanac(p_branch,
																				p_account,
																			   global.application_date,
																			   p_error_code,
																			   p_error_param)
						THEN
								ROLLBACK;
									dbms_output.put_line('clpkss_accounting.fn_accounting_for_branch failed with :-(' || p_error_code || p_error_param);

						ELSE
								dbms_output.put_line('Completed successfully');
						END IF;
						
exception
when others then
	dbms_output.put_line('aliq failed with '||sqlerrm);
end;
/
--commit;
rollback;
spool off
/
