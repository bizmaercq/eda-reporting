SELECT DISTINCT GG.* FROM (

 SELECT SUBSTR(TRN_REF_NO,1,3)"BRANCH",PRODUCT,EXTERNAL_REF_NO,AC_NO,DRCR_IND,LCY_AMOUNT,USER_ID

  FROM xafnfc.ACTB_DAILY_LOG

 WHERE AC_BRANCH = AC_BRANCH

 AND CUST_GL='A'

 AND AUTH_STAT='A'

 AND NVL(DELETE_STAT,'Y')<>'D'

   AND EXTERNAL_REF_NO IN

       (select XREFID

          from xafnfc.fbtb_txnlog_master

         where txnstatus = 'COM'

           and to_date(to_char(wfinitdate,'DD-MON-YYYY'))=to_date(TO_char(sysdate,'DD-MON-YYYY'))) ) GG,

 (

 SELECT SUBSTR(TRN_REF_NO,1,3)"BRANCH",PRODUCT,EXTERNAL_REF_NO,AC_NO,DRCR_IND,LCY_AMOUNT,USER_ID

  FROM xafnfc.ACTB_DAILY_LOG

 WHERE AC_BRANCH = AC_BRANCH

 AND CUST_GL='A'

 AND AUTH_STAT='A'

 AND NVL(DELETE_STAT,'Y')<>'D'

   AND EXTERNAL_REF_NO IN

       (select XREFID

          from xafnfc.fbtb_txnlog_master

         where txnstatus = 'COM'

                 and to_date(to_char(wfinitdate,'DD-MON-YYYY'))=to_date(TO_char(sysdate,'DD-MON-YYYY'))) )HH

 WHERE GG.BRANCH=HH.BRANCH

 AND GG.PRODUCT=HH.PRODUCT

 AND GG.AC_NO=HH.AC_NO

 AND GG.DRCR_IND=HH.DRCR_IND

 AND GG.LCY_AMOUNT =HH.LCY_AMOUNT  

 AND GG.EXTERNAL_REF_NO<>HH.EXTERNAL_REF_NO 
 --AND GG.BRANCH ='050'

 order by gg.lcy_amount  
