select c.branch, c.account ,a.ac_desc Description,c.first_check_no, c.check_leaves, c.order_date, c.issue_date,c.maker_id, c.checker_id, c.request_status  
from catm_check_book c, sttm_cust_account a 
where a.cust_ac_no = c.account
and c.issue_date between '01/01/2014' and '31/01/2014'
order by c.branch
