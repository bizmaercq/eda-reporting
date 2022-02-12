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
 ('022');


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

