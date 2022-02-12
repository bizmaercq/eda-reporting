UPDATE TRIAL_BALANCE SET GLCODE2 = '&New_Gl_Code' , GLCODE1 = SUBSTR('&New_Gl_Code',1,5) WHERE GLCODE2 = '&Old_Gl_Code'
commit;
