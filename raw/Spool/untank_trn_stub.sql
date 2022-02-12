set serveroutput on
spool c:\untank_trn_stub.spl

declare
    err_code varchar2(1000);
    err_param varchar2(1000);
begin
    global.pr_init('040', 'SYSTEM');
    if not fn_untank_parent_txn('040', 
                         'XAF', 
			 '040SUSP06072012', 
			 err_code, 
			 global.application_date,
			 err_param)
    then
        dbms_output.put_line('Untank failed: '||err_code||' sqlerr:'||sqlerrm);
    else
	commit;
	dbms_output.put_line('Untank successful...');
    end if;
exception when others then
    dbms_output.put_line('WOT Untank failed: '||err_code||' sqlerr:'||sqlerrm);
end;
/

spool off