select table_name from user_tables

alter table NEW_CIVIL_SERVANTS add (user_create varchar2(10),date_create date, user_update varchar2(10), date_update date);
alter table NEW_FONCTIONNAIRES add (user_create varchar2(10),date_create date, user_update varchar2(10), date_update date);
alter table NEW_FONCTIONNAIRES_CNPS add (user_create varchar2(10),date_create date, user_update varchar2(10), date_update date);
alter table PAIE add (user_create varchar2(10),date_create date, user_update varchar2(10), date_update date);
alter table PAIE_CNPS add (user_create varchar2(10),date_create date, user_update varchar2(10), date_update date);
alter table SAL_CENADI add (user_create varchar2(10),date_create date, user_update varchar2(10), date_update date);
alter table SAL_CNPS add (user_create varchar2(10),date_create date, user_update varchar2(10), date_update date);
alter table TEMP_SALAIRE add (user_create varchar2(10),date_create date, user_update varchar2(10), date_update date);
alter table TEMP_NEW_ACCOUNTS add (user_create varchar2(10),date_create date, user_update varchar2(10), date_update date);

create or replace trigger NCS_before_update  before update on new_civil_servants for each row
begin
  :new.user_update := user;
  :new.date_update := sysdate;
end;
