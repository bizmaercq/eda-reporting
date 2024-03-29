set head on
set array 1
set linesize 10000
set pagesize 50000
set long 10000
set echo on
set trimspool on
set colsep ';'
set numformat 9999999999999999.99

SPOOL C:\NFC153_Details.SPL

PROMPT
SHOW USER;

PROMPT
PROMPT SMTB_MENU
PROMPT
SELECT * FROM SMTB_MENU WHERE FUNCTION_ID = 'SMRCONTL';

PROMPT
PROMPT SMTB_FUNCTION_DESCRIPTION
PROMPT
SELECT * FROM SMTB_FUNCTION_DESCRIPTION WHERE FUNCTION_ID = 'SMRCONTL';

PROMPT
PROMPT SMTB_FUNCTION_DESCRIPTION - NAVIGATION_PATHS
PROMPT
SELECT FUNCTION_ID, DESCRIPTION,
       MAIN_MENU || ' => ' || SUB_MENU_1 || ' => ' || SUB_MENU_2 MENU_PATH
  FROM SMTB_FUNCTION_DESCRIPTION
 WHERE FUNCTION_ID = 'SMRCONTL';

PROMPT
PROMPT SMTB_FCC_FCJ_MAPPING 1
PROMPT
SELECT * FROM SMTB_FCC_FCJ_MAPPING WHERE FCC_FUNCTION_ID = 'SMRCONTL';

PROMPT
PROMPT SMTB_FCC_FCJ_MAPPING 2
PROMPT
SELECT * FROM SMTB_FCC_FCJ_MAPPING WHERE FCJ_FUNCTION_ID = 'SMRCONTL';

PROMPT 
PROMPT SMTB_FCC_FCJ_MAPPING ALL
PROMPT 
SELECT *
  FROM SMTB_FCC_FCJ_MAPPING
 WHERE (FCJ_FUNCTION_ID = 'SMRCONTL' OR FCC_FUNCTION_ID = 'SMRCONTL');

PROMPT
PROMPT SMTB_ROLE_DETAIL
PROMPT
SELECT *
  FROM SMTB_ROLE_DETAIL
 WHERE ROLE_FUNCTION = 'SMRCONTL'
 ORDER BY ROLE_ID;

PROMPT
PROMPT SMTB_ROLE_MASTER
PROMPT 
SELECT *
  FROM SMTB_ROLE_MASTER
 WHERE ROLE_ID IN
       (SELECT DISTINCT ROLE_ID
          FROM SMTB_ROLE_DETAIL
         WHERE ROLE_FUNCTION = 'SMRCONTL')
 ORDER BY 1, 2;
 
PROMPT 
PROMPT SMTB_USER_ROLE
PROMPT 
SELECT *
  FROM SMTB_USER_ROLE
 WHERE ROLE_ID IN (SELECT DISTINCT ROLE_ID
                     FROM SMTB_ROLE_DETAIL
                    WHERE ROLE_FUNCTION = 'SMRCONTL')
 ORDER BY 2, 1, 4;
 
PROMPT
PROMPT SMTB_FUNCTION_LOV
PROMPT 
SELECT * FROM SMTB_FUNCTION_LOV WHERE CONTAINERID = 'SMRCONTL' ORDER BY 1;

PROMPT
PROMPT SMTB_BROWSER_FUNCTIONS
PROMPT 
SELECT * FROM SMTB_BROWSER_FUNCTIONS WHERE FUNCTION_ID = 'SMRCONTL' ORDER BY 1;

PROMPT
PROMPT SMTB_USER_FUNC_DISALLOW
PROMPT 
SELECT * FROM SMTB_USER_FUNC_DISALLOW WHERE FUNCTION_ID = 'SMRCONTL' ORDER BY 1;

PROMPT
PROMPT SMTB_USER_STAGE_FUNCTIONS
PROMPT 
SELECT * FROM SMTB_USER_STAGE_FUNCTIONS WHERE FUNCTION_ID = 'SMRCONTL' ORDER BY 4, 3, 2;

PROMPT
PROMPT SMTB_USERS_FUNCTIONS
PROMPT 
SELECT * FROM SMTB_USERS_FUNCTIONS WHERE FUNCTION_ID = 'SMRCONTL' ORDER BY 3, 2;

PROMPT
SET ECHO OFF;
SPOOL OFF;
