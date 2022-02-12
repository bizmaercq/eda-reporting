select * from sitb_contract_master
where substr(contract_ref_no,4,4) ='SIOO';

SELECT * FROM sitb_contract_master 
where si_expiry_date >SYSDATE
and CR_ACcount in ('0501920101301570','0221730101301563','0401730102634752','0411730103070946','0421730103523921','0431920103575355','0301730102199372') 
and event_code ='OPEN';


select * from SITB_CYCLE_DETAIL 
where retry_date between '01/12/2012' and '31/12/2012' 
and substr(contract_ref_no,4,4) ='SIOO'  
and dr_account ='0202820100522289' 
and cr_account ='0221730101291863'
and event_code='REJT'

select * from catm_amount_blocks where account ='0202820100522289'

select * from sitb_contract_master where dr_account ='0202820100522289'


select * from actb_daily_log where instrument_code is not null
