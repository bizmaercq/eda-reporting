---  verify if debug is on for any user/Verifier si le debug est ON pour un utilisateur --- ---
SELECT * FROM CSTB_DEBUG_USERS WHERE DEBUG ='Y';
SELECT * FROM CSTB_PARAM WHERE PARAM_NAME='REAL_DEBUG';
SELECT * FROM CSTB_DEBUG WHERE DEBUG ='Y';
update cstb_debug set debug='Y'
--- --- Verify if debug is defined for the  user/Verifier si le debug est definir pour un utilisateur --- ---
SELECT * FROM CSTB_DEBUG_USERS WHERE USER_ID ='&User_ID';

--- ---  If this query returns no records then run the following script --- ---
INSERT INTO CSTB_DEBUG_USERS (SELECT MODULE_ID,'Y','&User_ID' FROM SMTB_MODULES );
COMMIT;


--- --- SWITCH ON DEBUG --- ---
UPDATE CSTB_PARAM SET PARAM_VAL='Y' WHERE PARAM_NAME='REAL_DEBUG';
UPDATE CSTB_DEBUG_USERS SET DEBUG='Y' WHERE USER_ID='&User_ID';
COMMIT;




--- --- After the user has finished executing the transaction --- --- 
--- --- SWITCH OFF DEBUG --- ---

UPDATE CSTB_DEBUG_USERS SET DEBUG='N' WHERE USER_ID='&User_ID';
UPDATE CSTB_PARAM SET PARAM_VAL='N' WHERE PARAM_NAME='REAL_DEBUG';
COMMIT;

