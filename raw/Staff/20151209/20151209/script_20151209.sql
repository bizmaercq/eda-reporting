spool script_20151209.log

CREATE OR REPLACE TRIGGER T_AVANCE_SALAIRE_DETAIL
BEFORE DELETE OR UPDATE OR INSERT ON AVANCE_SALAIRE_DETAIL  FOR EACH ROW
declare
    numero AVANCE_SALAIRE_DETAIL.NUMESEQU%TYPE ;
  nombre number;
    utilisateur varchar2(30);
begin --transaction
    if :new.datedebu is not null then 
        :new.exercice := to_char(:new.datedebu,'yyyy');
        :new.numemois := to_char(:new.datedebu,'mm');
    end if;

if inserting then
    :new.cree_par := user; :new.cree__le := sysdate;

    numero := 0;
    select count(*) into nombre
            from AVANCE_SALAIRE_DETAIL
          where matriemp = :new.MATRIEMP
              and NUMEAVCE = :new.NUMEAVCE;

    if (nombre <>0) then
        select max(nvl(numesequ,0)) into numero
        from AVANCE_SALAIRE_DETAIL
        where matriemp = :new.MATRIEMP
          and NUMEAVCE = :new.NUMEAVCE;
    end if;

    numero := numero +1 ;


        :new.numesequ := numero;


end if;
/*
  if deleting and  (:old.vali_par is not null or :old.vali__le is not null) then
     raise_application_error (-20001,'Suppression non autorisée ... : paramétrage déjà diffusé');
  end if;
*/


/*
  if inserting then
     :new.nume_lot := null;
  end if;
  if deleting and  :old.nume_lot is not null then
     raise_application_error (-20001,'Suppression non autorisée ... : paramétrage déjà diffusé');
  end if;
  if updating and  nvl(:old.nume_lot,-1) = nvl(:new.nume_lot,-1) and :old.nume_lot is not null

then
    :new.nume_lot := 0;
  end if;
*/
  
end;
/

CREATE OR REPLACE TRIGGER T_AVANCE_SALAIRE
BEFORE DELETE OR UPDATE OR INSERT ON AVANCE_SALAIRE  FOR EACH ROW
declare
    numero AVANCE_SALAIRE.NUMEAVCE%TYPE ;
  nombre number;
    utilisateur varchar2(30);
begin --transaction

if inserting then
    :new.cree_par := user; :new.cree__le := sysdate;

    numero := 0;
    select count(*) into nombre
            from AVANCE_SALAIRE
          where matriemp = :new.MATRIEMP;

    if (nombre <>0) then
        select max(nvl(numeavce,0)) into numero
        from AVANCE_SALAIRE
        where matriemp = :new.MATRIEMP;
    end if;

    numero := numero +1 ;


        :new.numeavce := numero;


end if;
  
end;
/


create or replace procedure migrer_13m_avcesal(
pexercice arrete_comptable.exercice%Type,
pnumemois mois.numemois%Type
)
is
      CURSOR C_13m
      IS
       select matriemp, restenet
       from salaire_mensuel
       where exercice = pexercice and numemois = pnumemois and (vali_par is not null or vali__le is not null);
       
       vMATRIEMP employe.matriemp%type; 
       vRESTENET salaire_mensuel.restenet%type; 
       nombre number;
       numero AVANCE_SALAIRE.NUMEAVCE%TYPE ;

begin

   Open C_13m ;
   Loop 
      Fetch C_13m Into vMATRIEMP, vRESTENET; 

      Exit When C_13m%NOTFOUND ;

      insert into AVANCE_SALAIRE (MATRIEMP, NUMEAVCE, DATEEMIS, MONTAVCE, NOMBECHE, CODERETE, DATEPREC, CREE_PAR, CREE__LE, COMMENTA)
      values (vMATRIEMP,0,trunc(sysdate),vRESTENET,1,'AVAN',to_date('01/'||to_char(sysdate,'mm/yyyy'),'dd/mm/yyyy'),user,sysdate,pnumemois||'M_'||pexercice);

      
      select max(numeavce) into numero from AVANCE_SALAIRE where matriemp = vMATRIEMP;
      
      insert into AVANCE_SALAIRE_DETAIL (NUMEAVCE,NUMESEQU,DATEDEBU,MONTQUOT,DATEREMB,MATRIEMP)
      values (numero,0,to_date('01/'||to_char(sysdate,'mm/yyyy'),'dd/mm/yyyy'),vRESTENET,trunc(last_day(sysdate)),vMATRIEMP);
   
   End loop ;
   Close C_13m ; 
   
   commit;
end;
/


spool off