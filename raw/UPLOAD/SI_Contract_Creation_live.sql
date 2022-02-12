select * from sitb_upload_master ;
select * from sitb_upload_instruction; 
select * from cstb_ext_contract_stat;

-- Truncating Tables containing upload information ;
-- backup of all concerned tables 
create  table sitb_upload_master_14_11_2013 as select * from sitb_upload_master;
create  table sitb_upload_instr_14_11_2013 as select * from sitb_upload_instruction;
create table cstb_ext_cont_stat14112013 as select * from  cstb_ext_contract_stat;

-- Truncate tables concerned
truncate table sitb_upload_master ;
truncate table sitb_upload_instruction;
truncate table cstb_ext_contract_stat;

-- Copying information from Upload tables generated

copy from flexcube/fcc@delta to xafnfc/aq1sw2de3@fcubs insert sitb_upload_master using select * from si_sitb_upload_master;
copy from flexcube/fcc@delta to xafnfc/aq1sw2de3@fcubs insert sitb_upload_instruction using select * from si_sitb_upload_instruction;

-- Execution of the stub to create the contracts
declare
result boolean;
p_Upload_Id VARCHAR2(30);
p_error_code VARCHAR2(30);
p_error_parameter VARCHAR2(100);
CURSOR CUR_ACC
IS
SELECT *
FROM sttm_branch
                Where branch_code  in
 ('020');


begin
  -- Call the function
FOR C1 IN CUR_ACC LOOP

GLOBAL.pr_init(C1.BRANCH_CODE,'SYSTEM');  

UPDATE Cstb_Ext_Contract_Stat SET ACTION_CODE = 'NEW' WHERE FUNCTION_ID = 'SIDCONON' AND BRANCH_CODE = C1.BRANCH_CODE;

UPDATE Sitb_Upload_Master SET ACTION_CODE = 'NEW' WHERE  BRANCH_CODE = C1.BRANCH_CODE;

update Sitb_Upload_Instruction set FIRST_VALUE_DATE = FIRST_EXEC_DATE where BRANCH_CODE = C1.BRANCH_CODE;



  IF NOT Gwpks_Uploadsicontract.Fn_Upload('NFCSOURCE',
                                            'SIDCONON',
           'NEW',
                                            p_Upload_Id ,
                                            p_error_code,
   p_error_parameter) 
  THEN

  DBMS_OUTPUT.PUT_LINE ('SQL ERROR IS '||SQLERRM);

ELSE

DBMS_OUTPUT.PUT_LINE ('DONE');

END IF;
COMMIT;

end loop;


end;

-- Checking Contracts created

select * from sitb_contract_master where si_expiry_date = '25/04/2016' and dr_acc_br ='020'
select * from sitb_upload_master where branch_code = '020'

select * from sitb_upload_master where branch_code ='020' and counterparty not in 
(select  counterparty from sitb_contract_master where si_expiry_date = '25/04/2016' and dr_acc_br ='020' )

