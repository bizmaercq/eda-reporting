create table FIBANE03_hist as select * from FIBANE03; --- creation de la nouvelle table 

insert into  FIBANE03_hist select * from FIBANE03;--insertion de la table existante

truncate table FIBANE03;-- purge de la table
