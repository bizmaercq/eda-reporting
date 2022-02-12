update new_civil_servants set status = 0 where ncs_matricule  in
(select ncs_matricule from new_civil_servants 
where to_date(to_char(date_create,'DD/MM/YYYY'),'DD/MM/YYYY') >= '01/04/2013'
--or to_date(to_char(date_update,'DD/MM/YYYY'),'DD/MM/YYYY') >= '01/04/2013'
)
select status, count(*) from new_civil_servants group by status;

select * from new_civil_servants where status =0 for update
