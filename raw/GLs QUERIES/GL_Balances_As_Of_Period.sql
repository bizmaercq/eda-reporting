SELECT distinct gl.branch_code,gl.gl_code,gm.gl_desc,gl.ccy_code ,gl.dr_bal_lcy,gl.cr_bal_lcy 
FROM gltb_gl_bal gl,gltm_glmaster gm
WHERE gl.gl_code = gm.gl_code
and gl.fin_year='&Financial_Year'
and gl.period_code ='&Period_Code'
and gl.gl_code like '57%'--('571011000','571110000','571191000','571333333')
order by gl.branch_code;

SELECT distinct gl.branch_code,gl.gl_code,gm.gl_desc,gl.ccy_code ,gl.dr_bal_lcy,gl.cr_bal_lcy 
FROM gltb_gl_bal gl,gltm_glmaster gm
WHERE gl.gl_code = gm.gl_code
and gl.fin_year='&Financial_Year'
and gl.period_code ='&Period_Code'
and gl.gl_code like '56%'--('571011000','571110000','571191000','571333333')
order by gl.branch_code;

SELECT distinct gl.branch_code,gl.gl_code,gm.gl_desc,gl.ccy_code ,gl.dr_bal_lcy,gl.cr_bal_lcy 
FROM gltb_gl_bal gl,gltm_glmaster gm
WHERE gl.gl_code = gm.gl_code
and gl.fin_year='&Financial_Year'
and gl.period_code ='&Period_Code'
and gl.gl_code like '54%'--('571011000','571110000','571191000','571333333')
order by gl.branch_code;


SELECT distinct gl.branch_code,gl.gl_code,gm.gl_desc,gl.ccy_code ,gl.dr_bal_lcy,gl.cr_bal_lcy 
FROM gltb_gl_bal gl,gltm_glmaster gm
WHERE gl.gl_code = gm.gl_code
and gl.fin_year='&Financial_Year'
and gl.period_code ='&Period_Code'
and gl.gl_code like '45%'--('571011000','571110000','571191000','571333333')
order by gl.branch_code;
