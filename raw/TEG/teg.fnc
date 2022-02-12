create or replace function teg (pcompte varchar2, pfrais number default 0, pemi number, pmodetaux number
) return varchar2 is

-- pmodetaux a les valeurs suivantes : année à 360 jours 1,3,6,12, -- année différente de 360 appliquer les valeurs correspondant au nombre de jour 
--pcompte varchar2(20);
vprincipal number(15,2);    vfrais number(15,2);
vemi_amount number(15,2);   vamount_due number(15,2);   vno_of_installments number;
vamount_due_avg number(15,2);   vamount_due_sum number(15,2);   tamount_due number(15,2);
vfrequency number;
vvalue_date date;           vfirst_ins_date date;
vschedule_due_date date;    vschedule_st_date date;
vsomme number:=0;   vsommemin number:=0;  diff number:=0; diffmin number:=0;
i varchar2(20):='0,0';       iv varchar2(20):='0,0';--0.041593; 
vteg number;    n number:=0;

bornesup varchar2(20):='0.9'; incr number:=0.1;
vduree number;  vbasej number;
vmensualite number:=1; nombre number :=0; 
x number:=0; 

cursor C_schedules is
select schedule_due_date, sum(amount_due) amount_due, sum(emi_amount) emi_amount
from xafnfc.cltb_account_schedules
where account_number = pcompte and component_name in ('PRINCIPAL','MAIN_INT')
--  and schedule_due_date > :date1
group by schedule_due_date
order by schedule_due_date;


begin

select  amount_disbursed, value_date, no_of_installments--, frequency, frequency_unit, first_ins_date, dr_prod_ac
    into vprincipal, vvalue_date, vno_of_installments
from xafnfc.cltb_account_master
where account_number = pcompte;

select sum(amount_due) into vfrais
from xafnfc.cltb_account_schedules 
where (component_name like '%FEE%' or component_name like '%PROC%') and account_number = pcompte;

select sum(amount_due)amount_due_sum, ceil(sum(amount_due)/vno_of_installments) amount_due_avg
    into vamount_due_sum, vamount_due_avg
from xafnfc.cltb_account_schedules
where account_number = pcompte and component_name in ('PRINCIPAL','MAIN_INT');

if nvl(pfrais,0) <>0 then vfrais := pfrais; end if;

vsommemin := nvl(vprincipal,0);
diffmin := nvl(vprincipal,0)-vsomme-vfrais;

Loop
    Exit When length(i) =15;

    vsomme := vsommemin;
    Loop
    --   Exit When nvl(vprincipal,0)-vsomme-pfrais between -0.00001 and 0.00001 or nombre = 20000;
       Exit When nvl(vprincipal,0)-vsomme-vfrais >0 or iv > bornesup or nombre = 10000;
   
       diffmin := nvl(vprincipal,0)-vsomme-vfrais;     vsommemin := vsomme;
       vsomme :=0; n :=1;
-- Commented by Franco
       i:=iv; iv:=to_number(iv)+incr;
/*-- Updated by Franco on 09/01/2015
       i:=to_number(iv,'9G999D9'); 
       iv:=to_char(to_number(iv,'9G999D9')+incr);*/
       
       --cas moyenne des amount_due 
       tamount_due:=0;

       Open C_schedules;

       Loop 
          Fetch C_schedules Into vschedule_due_date, vamount_due, vemi_amount; 

          Exit When C_schedules%NOTFOUND;
          
            vamount_due := least(vamount_due_sum-tamount_due, vamount_due_avg); -- cas utilisation de la moyenne. commenter ces 2 lignes dans le cas contraire 
            tamount_due := tamount_due+vamount_due;
          
          case when pmodetaux <=12 then vduree := round((days360(vvalue_date,vschedule_due_date,'T')/360)*(12/pmodetaux),4);
               else vduree := round((vschedule_due_date-vvalue_date)/pmodetaux,4); end case;
          vsomme := round(vsomme + round(vamount_due/((1+to_number(iv))**vduree),5),5);

       End loop ;
       Close C_schedules ;

       nombre := nombre +1;

    End loop;

    bornesup := i||'9'; i:=i||'0'; incr := incr*0.1; iv:=i;
    
End loop;

    vteg:= i*12/pmodetaux;
   
--    return to_char(i)||';'||vteg||';'||to_char(vprincipal)||';'||to_char(vsomme+vfrais)||';'||to_char(diffmin)||';'||to_char(nombre);

    return i;
end; 
/
