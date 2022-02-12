SELECT sc.customer_no,sc.customer_name1,sd.director_name, sd.mobile_number
from sttm_customer sc, sttm_corp_directors sd
WHERE sc.customer_no=sd.customer_no
and sc.customer_no  
in(SELECT cu.customer_no
FROM sttm_corp_directors cd, sttm_customer cu
WHERE cu.customer_no = cd.customer_no
group by cu.customer_no,cu.customer_name1
having count(*)>1)
order by sc.customer_name1
