SELECT distinct a.codentge Branch, e.matriemp matricle,e.nomemplo Name,e.numecomp account, 10000 amount
FROM employe e , affectation a
WHERE e.matriemp = a.matriemp
and e.matriemp in (
SELECT matriemp FROM salaire_mensuel sm WHERE sm.numemois =3 and sm.exercice =2017)
and a.date_fin is null
order by a.codentge;

--- Upload file
SELECT distinct null SEQ_NO, '0'||a.codentge Branch,0000 batch_no,e.numecomp account,10000 Amount ,1000 lcy_amount,'XAF' ccy,1 rate,'C' DR_CR,null TRN_CODE, null INSTR_NO,20170419 Value_dt,'NFC FABRIC SEWING ALLOWANCE' addl_text,e.numecomp EXT_REF_NO,'UPLOAD' Source_ref_no
FROM employe e , affectation a
WHERE e.matriemp = a.matriemp
and e.matriemp in (
SELECT matriemp FROM salaire_mensuel sm WHERE sm.numemois =3 and sm.exercice =2017)
and a.date_fin is null
order by '0'||a.codentge;

1,9999,041,0412820103307620,225075,225075,XAF,,C,SAL,,20170329,SALAIRE CNPS 03-2017,0412820103307620,UPLOAD_
2,9999,023,0231630103999511,225075,225075,XAF,,D,SAL,,20170329,COUNTERPARTY CNPS SALARIES,0231630103999511,UPLOAD

SELECT * FROM affectation WHERE date_fin is null
