set head on
set feedback on
set line 1000
set pagesize 10000
set echo on
set trimspool on
set numformat 99999999999999999999.99
set colsep ";"
set long 100000
set serveroutput on;

spool /home/oracle/spool/Amount_block.spl

select acy_blocked_amount, a.*
  from sttm_cust_account a
 where cust_ac_no in (select distinct cm.dr_account                                      
                        from SITB_CONTRACT_MASTER cm,
                             STTM_CUSTOMER        cu,
                             STTM_CUST_ACCOUNT    ca,
                             sitb_instruction     ci
                       where cu.customer_no = substr(cm.dr_account, 9, 6)
                         and cm.dr_account = ca.cust_ac_no
                         and substr(cm.contract_ref_no, 8, 9) =
                             substr(ci.instruction_no, 8, 9)
                         and substr(cm.contract_ref_no, 4, 4) = 'SIOO'
                         and cm.si_expiry_date >= to_date('15/12/2012','DD/MM/YYYY')
                         --and ci.next_exec_date >= to_date('13/12/2012','DD/MM/YYYY')
                         and cm.max_retry_count = 10);

declare
CURSOR c1 is
select distinct cm.dr_acc_br,
                cm.contract_ref_no,
                cm.dr_account,
                cm.dr_acc_ccy,
                cm.si_amt,
                ci.next_exec_date,
                cu.customer_name1
  from SITB_CONTRACT_MASTER cm,
       STTM_CUSTOMER        cu,
       STTM_CUST_ACCOUNT    ca,
       sitb_instruction     ci
 where cu.customer_no = substr(cm.dr_account, 9, 6)
   and cm.dr_account = ca.cust_ac_no
   and substr(cm.contract_ref_no, 8, 9) = substr(ci.instruction_no, 8, 9)
   and substr(cm.contract_ref_no, 4, 4) = 'SIOO'
   and cm.si_expiry_date >=  to_date('15/12/2012','DD/MM/YYYY')
   --and ci.next_exec_date >= to_date('13/12/2012','DD/MM/YYYY')
   and cm.max_retry_count = 10;
 
BEGIN  
--EXECUTE IMMEDIATE 'create sequence sq
--INCREMENT BY 1
--START WITH 152799
--MINVALUE 1 MAXVALUE 999999 NOCYCLE NOCACHE ORDER';

FOR each_row in c1 LOOP
insert into catm_amount_blocks
  (branch,
   account,
   amount_block_no,
   amount,
   effective_date,
   expiry_date,
   maker_id,
   maker_dt_stamp,
   checker_id,
   checker_dt_stamp,
   auth_stat,
   record_stat,
   once_auth,
   mod_no,
   remarks,
   amount_block_type) --,'reference_no','hold_code','related_ref_no','event_seq_no')
values
  (each_row.dr_acc_br,
   each_row.dr_account,
   CASQ_AMOUNT_BLOCK.nextval,
   each_row.si_amt,
   to_date('13-12-2012', 'dd-mm-yyyy'),
   each_row.next_exec_date,
   'SYSTEM',
   to_date('17-12-2012', 'dd-mm-yyyy'),
   'SYSTEM',
   to_date('17-12-2012', 'dd-mm-yyyy'),
   'A',
   'O',
   'Y',
   '1',
   'SI_EXECUTION_IN_DEC',
   'F');

update sttm_cust_account
   set acy_blocked_amount = each_row.si_amt
 where cust_ac_no = each_row.dr_account
   and branch_code = each_row.dr_acc_br;

commit;
END LOOP;

--commit;
--drop sequence sq;
EXCEPTION
            WHEN OTHERS THEN
                        DBMS_OUTPUT.PUT_LINE('ERROR ' || SUBSTR(SQLERRM, 1, 255));
END;
/

select acy_blocked_amount, acy_avl_bal, a.*
  from sttm_cust_account a
 where cust_ac_no in (select cm.dr_account
                        from SITB_CONTRACT_MASTER cm,
                             STTM_CUSTOMER        cu,
                             STTM_CUST_ACCOUNT    ca,
                             sitb_instruction     ci
                       where cu.customer_no = substr(cm.dr_account, 9, 6)
                         and cm.dr_account = ca.cust_ac_no
                         and substr(cm.contract_ref_no, 8, 9) =
                             substr(ci.instruction_no, 8, 9)
                         and substr(cm.contract_ref_no, 4, 4) = 'SIOO'
                         and cm.si_expiry_date >= to_date('15/12/2012','DD/MM/YYYY')
                         --and ci.next_exec_date >= to_date('13/12/2012','DD/MM/YYYY')
                         and cm.max_retry_count = 10);
 
select *
  from catm_amount_blocks
 where account in (select cm.dr_account
                     from SITB_CONTRACT_MASTER cm,
                          STTM_CUSTOMER        cu,
                          STTM_CUST_ACCOUNT    ca,
                          sitb_instruction     ci
                    where cu.customer_no = substr(cm.dr_account, 9, 6)
                      and cm.dr_account = ca.cust_ac_no
                      and substr(cm.contract_ref_no, 8, 9) =
                          substr(ci.instruction_no, 8, 9)
                      and substr(cm.contract_ref_no, 4, 4) = 'SIOO'
                      and cm.si_expiry_date >= to_date('15/12/2012','DD/MM/YYYY')
                     -- and ci.next_exec_date >= to_date('13/12/2012','DD/MM/YYYY')
                      and cm.max_retry_count = 10);
   
select count(*) from catm_amount_blocks where substr(amount_block_no,3,7)>=131469;


spool off;
