spool genprovind.log

CREATE OR REPLACE procedure STAFF_V1.geneprovind (
pexercice arrete_comptable.exercice%Type,
pnumemois mois.numemois%Type
,sortie out varchar 
) 
is

      CURSOR C_salaire  
      IS
       select  c.MATRIEMP, NOMEMPLO, greatest(c.SALABASE,g.SALABASE)+salabrut(c.matriemp, c.numesequ, 'ANCI', pEXERCICE, decode(pNUMEMOIS,13,12,pNUMEMOIS))+
       nvl((select sum(salabrut(c.matriemp,NUMESEQU,CODEAVAN,pEXERCICE,decode(pNUMEMOIS,13,12,pNUMEMOIS))) from avantage_accorde where matriemp = c.matriemp and numesequ = c.numesequ),0) salabrut
       , anciennete(c.matriemp, pEXERCICE, decode(pNUMEMOIS,13,12,pNUMEMOIS))/12 ancienne
       from contrat c, type_avenant t,employe e, grille g, groupe p       
       where c.numetave = t.numetave
--        and (flagoper = 'O' or flagoper = 'S')
/*        and c.numesequ = (select max(numesequ) from contrat
                           where matriemp = c.matriemp
                              and dateeffe < last_day(to_date('28/'||to_char(decode(:pNUMEMOIS,13,12,:pNUMEMOIS))||'/'||to_char(:pEXERCICE),'dd/mm/yyyy')))
*/        and to_date('28/'||to_char(decode(pNUMEMOIS,13,12,pNUMEMOIS))||'/'||to_char(pEXERCICE), 'dd/mm/yyyy')  
            between trunc(c.dateeffe) and nvl(c.dateeche,last_day(to_date('01/'||to_char(decode(pNUMEMOIS,13,12,pNUMEMOIS))||'/'||to_char(pEXERCICE), 'dd/mm/yyyy')))
        and e.matriemp = c.matriemp
        and nvl(c.codecate,0) = nvl(g.codecate,0) and nvl(c.codechel,'A') = nvl(g.codechel,'A')
        and g.numegrou = p.numegrou
     order by e.matriemp-- nomemplo, prnemplo    
     ;

     CURSOR C_baseretraite IS
     Select ANNEEMIN, ANNEEMAX, TAUXIRET
     From tab_iretraite
     order by numetair
     ; 

  ligne number:=1; tranche number:=0;
  vMATRIEMP contrat.MATRIEMP%Type ;
  vNOMEMPLO employe.nomemplo%type;  
  vSALABRUT contrat.SALABASE%Type ; 
  
  vANNEEMIN tab_iretraite.ANNEEMIN%Type ;
  vANNEEMAX tab_iretraite.ANNEEMAX%Type ;
  vTAUXIRET tab_iretraite.TAUXIRET%Type ;
  
  vRETRAITE provision_indemnite.RETRAITE%Type :=0 ;  
  vRETRAIT1 provision_indemnite.RETRAIT1%Type :=0 ;  vRETRAIT2 provision_indemnite.RETRAIT2%Type :=0 ;  vRETRAIT3 provision_indemnite.RETRAIT3%Type :=0 ;  
  vRETRAIT4 provision_indemnite.RETRAIT4%Type :=0 ;  vRETRAIT5 provision_indemnite.RETRAIT5%Type :=0 ;  vRETRAIT6 provision_indemnite.RETRAIT6%Type :=0 ;  
  vRETRAIT7 provision_indemnite.RETRAIT7%Type :=0 ;  vRETRAIT8 provision_indemnite.RETRAIT8%Type :=0 ;  vRETRAIT9 provision_indemnite.RETRAIT9%Type :=0 ;

  vANCIENNE number :=0 ;
  nombre number :=0;

begin

    select count(*) into nombre from arrete_comptable where exercice = pEXERCICE;

    if nombre = 0 then 
        insert into arrete_comptable (EXERCICE, DATEARRE, NUMEARRE, CLOTEXER, FLAGSAIS)
        values (pEXERCICE, to_date('01/01/'||pEXERCICE, 'dd/mm/yyyy'), 0, 'N', 'O');
        commit;
    end if;

    select count(*) into nombre from arrete_mois
    where exercice = pEXERCICE and numemois = pNUMEMOIS;
          
    if nombre = 0 then 
        insert into arrete_mois (EXERCICE, NUMEMOIS, CREE__LE, CREE_PAR)
        values (pEXERCICE, pNUMEMOIS, sysdate, user);
        commit;
    end if;


    select count(*) into nombre from arrete_mois
    where exercice = pEXERCICE and numemois = pNUMEMOIS and (vali_par is not null or vali__le is not null);
    
        
    select count(*) into nombre from PROVISION_INDEMNITE
    where exercice = pEXERCICE and numemois = pNUMEMOIS;
        
     if nombre <> 0 then 
        
        delete PROVISION_INDEMNITE 
        where exercice = pEXERCICE and numemois = pNUMEMOIS;

        commit;
        
     end if;
    
   Open C_salaire;
   Loop 
      Fetch C_salaire Into vMATRIEMP, vNOMEMPLO, vSALABRUT, vANCIENNE; 

      Exit When C_salaire%NOTFOUND ;

         sortie := 'Traitement Employé : '||vNOMEMPLO;

--raise_application_error(-20001, 'point1');

       vRETRAITE :=0; 
       ligne := 1;
       
       Open C_baseretraite ;
       Loop 
          Fetch C_baseretraite Into vANNEEMIN, vANNEEMAX, vTAUXIRET; 

                Exit When C_baseretraite%NOTFOUND;

                  tranche := round(least(greatest(vANCIENNE-vANNEEMIN+1,0),vANNEEMAX-vANNEEMIN+1)*vSALABRUT*vTAUXIRET/100);
                  vRETRAITE:=  vRETRAITE + tranche;
                  
                  case ligne 
                    when 1 then vRETRAIT1 := tranche;  when 2 then vRETRAIT2 := tranche;  when 3 then vRETRAIT3 := tranche;
                    when 4 then vRETRAIT4 := tranche;  when 5 then vRETRAIT5 := tranche;  when 6 then vRETRAIT6 := tranche;
                    when 7 then vRETRAIT7 := tranche;  when 8 then vRETRAIT8 := tranche;  when 9 then vRETRAIT9 := tranche;
                    else null;
                  end case;
                  ligne := ligne+1;

                Exit When C_baseretraite%NOTFOUND;
       End loop ;
        Close C_baseretraite ; 
--raise_application_error(-20001, 'point1');

         insert into PROVISION_INDEMNITE (MATRIEMP, EXERCICE, NUMEMOIS, DATEGENE, SALABRUT, RETRAITE, RETRAIT1, RETRAIT2, RETRAIT3, RETRAIT4, RETRAIT5
                                          , RETRAIT6, RETRAIT7, RETRAIT8, RETRAIT9) 
         values (vMATRIEMP, pEXERCICE, pNUMEMOIS, sysdate, vSALABRUT, vRETRAITE, vRETRAIT1, vRETRAIT2, vRETRAIT3, vRETRAIT4, vRETRAIT5
                                          , vRETRAIT6, vRETRAIT7, vRETRAIT8, vRETRAIT9);
         commit;
--raise_application_error(-20001, 'point1');

   End loop ;
   Close C_salaire ; 

end;
/
spool off