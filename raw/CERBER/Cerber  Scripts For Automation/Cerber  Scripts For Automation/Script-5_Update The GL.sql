-- Original Script by Robot of OFSS
UPDATE TRIAL_BALANCE SET GLCODE2 = '&NewGLCode' , GLCODE1 = S UBSTR('&NewGLCode',1,5) WHERE GLCODE2 = '&OldGLCode';

commit;
