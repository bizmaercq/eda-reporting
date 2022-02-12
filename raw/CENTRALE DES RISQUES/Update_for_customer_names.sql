-- update of customer main information
select * from sttm_customer c where c.customer_name1 like ' %';

update sttm_customer c set  
customer_name1 = ltrim(customer_name1),
c.short_name = ltrim(c.short_name), 
c.short_name2 = ltrim(c.short_name2), 
c.full_name = ltrim(c.full_name) 
where c.customer_name1 like ' %';

-- update of the personal details 
select * from sttm_cust_personal where ((first_name like ' %') or (middle_name like ' %') or (last_name like ' %') );

update sttm_cust_personal p
set p.first_name = ltrim(p.first_name), 
p.middle_name = ltrim(p.middle_name), 
p.last_name = ltrim(p.last_name) 
where ((first_name like ' %') or (middle_name like ' %') or (last_name like ' %') );

-- Update of corporate id
select * from sttm_cust_corporate pr where pr.corporate_name like ' %';

update sttm_cust_corporate pr set pr.corporate_name = ltrim(pr.corporate_name) where pr.corporate_name like ' %'

