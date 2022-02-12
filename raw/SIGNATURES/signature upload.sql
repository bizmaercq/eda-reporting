=================================================================================================================
Step 1 : 

	Copy the physical image to app server

	IP : 172.20.50.12

	Path : /home/XAFNFC/Signatures

=================================================================================================================
Step 2 :  populate the image master table in cif_cs_ho_cust_imagemast ( Franco Mechine )

truncate table CIF_CS_HO_CUST_IMAGEMAST;

 insert into CIF_CS_HO_CUST_IMAGEMAST
(
CUSTOMER_NO,
IMAGE_TYPE,
SPECIMEN_SEQ_NO,
FILE_TYPE
)
select
fc.CUSTOMER_ID as  CUSTOMER_NO,
1 as IMAGE_TYPE,
row_number() over ( PARTITION BY fc.CUSTOMER_ID ORDER BY '')  as SPECIMEN_SEQ_NO,
fsv.SV_PATH  as FILE_TYPE
from fcc_cif fc join fcc_sv fsv on fc.CUSTOMER_ID = fsv.SV_CUSTOMER_ID;

commit;

=================================================================================================================

Step 3 : connect to readonly schema.

delete from xafnfc.CS_HO_CUST_IMAGEMAST;
commit;

================================================================================================================= 

Step 4 : connect to read only schema thorugh sqlplus.

copy from FLEXCUBE/FCC@DELTA  TO nfcread/nfcread@FCUBS insert xafnfc.CS_HO_CUST_IMAGEMAST using 	select * from CIF_CS_HO_CUST_IMAGEMAST;

=================================================================================================================
Step 4 : 

--connect to Live ( lawrence should open the live schema in plsql window and the below should be executed)

begin AP_UPLOAD_SIG ('041'); end;

=================================================================================================================

Step 5 : connect to read only schema and do execute the below query.

check :1 

          
       
   SELECT count ( distinct new_cust_no)   
      FROM xafnfc.CS_HO_CUST_IMAGEMAST A, xafnfc.STTM_CUSTOMER_MAPPING B 
      where a.customer_no = b.old_cust_no
      and nvl(FLG_MNT_STATUS, 'U') ='Y'

--308

check : 2

           
       select count(distinct cif_id) from xafnfc.SVTM_CIF_SIG_DET where cif_id in (   SELECT b.new_cust_no     
      FROM xafnfc.CS_HO_CUST_IMAGEMAST A, xafnfc.STTM_CUSTOMER_MAPPING B 
      where a.customer_no = b.old_cust_no
      and nvl(FLG_MNT_STATUS, 'U') ='Y' )

--308  count should be equal to check :1 

check :3 

	select count( distinct substr( acc_no , 9,6))  from xafnfc.Svtm_Acc_Sig_Master where acc_no in (   SELECT c.cust_ac_no
        FROM xafnfc.CS_HO_CUST_IMAGEMAST A, xafnfc.STTM_CUSTOMER_MAPPING B , xafnfc.sttm_cust_account c 
        where a.customer_no = b.old_cust_no
        and b.new_cust_no =c.cust_no
        and nvl(FLG_MNT_STATUS, 'U') ='Y' )
       
--303  count should be equal to check :1 

else check the below.

      SELECT    distinct new_cust_no    
      FROM xafnfc.CS_HO_CUST_IMAGEMAST A, xafnfc.STTM_CUSTOMER_MAPPING B 
      where a.customer_no = b.old_cust_no
      and nvl(FLG_MNT_STATUS, 'U') ='Y'
      and new_cust_no not in ( select cust_no from xafnfc.sttm_cust_account)

--count of above two query will equal to the check:1 count 

check :4

	select count( distinct substr( acc_no , 9,6))  from xafnfc.Svtm_Acc_Sig_det where acc_no in (   SELECT c.cust_ac_no
        FROM xafnfc.CS_HO_CUST_IMAGEMAST A, xafnfc.STTM_CUSTOMER_MAPPING B , xafnfc.sttm_cust_account c 
        where a.customer_no = b.old_cust_no
        and b.new_cust_no =c.cust_no
        and nvl(FLG_MNT_STATUS, 'U') ='Y' )


else check the below.

      SELECT    distinct new_cust_no    
      FROM xafnfc.CS_HO_CUST_IMAGEMAST A, xafnfc.STTM_CUSTOMER_MAPPING B 
      where a.customer_no = b.old_cust_no
      and nvl(FLG_MNT_STATUS, 'U') ='Y'
      and new_cust_no not in ( select cust_no from xafnfc.sttm_cust_account)


check 5 : 

 SELECT CIF_ID, CIF_SIG_ID, SPECIMEN_NO, FILE_TYPE, NULL
      FROM xafnfc.svtm_cif_sig_det
     WHERE CIF_ID NOT IN (SELECT CIF_ID FROM xafnfc.FBTB_CIF_SIGNATURE)

no rows.

check 6 : 

SELECT BRANCH,
           ACC_NO,
           CIF_SIG_ID,
           SIG_MSG,
           SIG_TYPE,
           APPROVAL_LIMIT,
           SOLO_SUFFICIENT
      FROM xafnfc.svtm_acc_sig_det
     WHERE ACC_NO IN
           (SELECT ACC_NO
              FROM xafnfc.svtm_acc_sig_det
             WHERE ACC_NO NOT IN (SELECT ACC_NO FROM xafnfc.FBTB_ACC_SIGNATURE) )

no rows.
=================================================================================================================

--execute the below query and send it to business for collecting the signature.

	select a.branch_Code , old_Cust_no Delta_customer_no , new_cust_no FCUBS_customer_no , b.customer_type, customer_category,b.customer_name1 
   	from xafnfc.sttm_customer_mapping a , xafnfc.sttm_customer b  
   	where a.new_cust_no =b.customer_no
   	and customer_no not in     (select cif_id from xafnfc.svtm_cif_sig_master)    
   	and customer_no not like '999%'
--    and branch_code = '051'
    order by a.branch_code;
