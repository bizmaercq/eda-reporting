
    create table ADDRESS (
        ID number(19,0) not null,
        CREATED_ON timestamp,
        MODIFIED_ON timestamp,
        STATUS varchar2(255 char),
        CITY varchar2(255 char),
        COUNTRY varchar2(255 char),
        LINE1 varchar2(255 char),
        LINE2 varchar2(255 char),
        STATE varchar2(255 char),
        ZIP_CODE varchar2(255 char),
        CREATED_BY number(19,0),
        MODIFIED_BY number(19,0),
        primary key (ID)
    );

    create table APPLICATION_USER (
        USER_TYPE varchar2(255 char) not null,
        ID number(19,0) not null,
        CREATED_ON timestamp,
        MODIFIED_ON timestamp,
        STATUS varchar2(255 char),
        EMAIL varchar2(255 char),
        FIRST_NAME varchar2(255 char),
        LAST_FAILED_LOGIN timestamp,
        LAST_LOGIN_TIME timestamp,
        LAST_LOGOUT_TIME timestamp,
        LAST_NAME varchar2(255 char),
        LOGIN_ATTEMPTS number(10,0),
        MOBILE_NUMBER varchar2(255 char),
        PASSWORD varchar2(255 char),
        RESET_PASSWORD number(1,0),
        UUID varchar2(255 char),
        USER_STATUS varchar2(20 char) not null,
        userType varchar2(255 char),
        USERNAME varchar2(255 char),
        CREATED_BY number(19,0),
        MODIFIED_BY number(19,0),
        ADDRESS_ID number(19,0),
        PREFERENCE_ID number(19,0),
        primary key (ID)
    );

    create table LANGUAGE (
        ID number(19,0) not null,
        CREATED_ON timestamp,
        MODIFIED_ON timestamp,
        STATUS varchar2(255 char),
        BASE varchar2(255 char),
        CODE varchar2(255 char),
        NAME varchar2(255 char),
        ORIENTATION varchar2(255 char),
        CREATED_BY number(19,0),
        MODIFIED_BY number(19,0),
        primary key (ID)
    );

    create table MSG_TEMPLATE (
        ID number(19,0) not null,
        CREATED_ON timestamp,
        MODIFIED_ON timestamp,
        STATUS varchar2(255 char),
        CODE varchar2(255 char),
        NAME varchar2(255 char),
        CREATED_BY number(19,0),
        MODIFIED_BY number(19,0),
        primary key (ID)
    );

    create table MSG_TEMPLATE_TEXT (
        ID number(19,0) not null,
        CREATED_ON timestamp,
        MODIFIED_ON timestamp,
        STATUS varchar2(255 char),
        DATA varchar2(255 char),
        CREATED_BY number(19,0),
        MODIFIED_BY number(19,0),
        LANGUAGE_ID number(19,0),
        MSG_TEMPLATE_ID number(19,0),
        primary key (ID)
    );

    create table PREFERENCE (
        ID number(19,0) not null,
        CREATED_ON timestamp,
        MODIFIED_ON timestamp,
        STATUS varchar2(255 char),
        CREATED_BY number(19,0),
        MODIFIED_BY number(19,0),
        LANG_ID number(19,0),
        primary key (ID)
    );

    create table SMSUSR_TRLOG (
        ID number(19,0) not null,
        CREATED_ON timestamp,
        MODIFIED_ON timestamp,
        STATUS varchar2(255 char),
        MSISDN varchar2(255 char),
        REF_NO varchar2(255 char),
        STATUS_CODE varchar2(255 char),
        STATUS_MSG varchar2(255 char),
        CREATED_BY number(19,0),
        MODIFIED_BY number(19,0),
        primary key (ID)
    );

    create table SMS_PARAM_CONFIG (
        ID number(19,0) not null,
        CREATED_ON timestamp,
        MODIFIED_ON timestamp,
        STATUS varchar2(255 char),
        SMS_CODE varchar2(255 char),
        SMS_IP_ADDRESS varchar2(255 char),
        SMS_PASSWORD varchar2(255 char),
        SMS_PORT varchar2(255 char),
        SMS_SOA varchar2(255 char),
        SMS_URL varchar2(255 char),
        SMS_USERNAME varchar2(255 char),
        CREATED_BY number(19,0),
        MODIFIED_BY number(19,0),
        primary key (ID)
    );

    create table SMS_SERVICE (
        ID number(19,0) not null,
        CREATED_ON timestamp,
        MODIFIED_ON timestamp,
        STATUS varchar2(255 char),
        DESCRIPTION varchar2(255 char),
        SERVICE_CODE varchar2(255 char),
        SERVICE_NAME varchar2(255 char),
        CREATED_BY number(19,0),
        MODIFIED_BY number(19,0),
        primary key (ID)
    );

    alter table ADDRESS 
        add constraint FKE66327D41C80E5AF 
        foreign key (CREATED_BY) 
        references APPLICATION_USER;

    alter table ADDRESS 
        add constraint FKE66327D46ED2CA2E 
        foreign key (MODIFIED_BY) 
        references APPLICATION_USER;

    alter table APPLICATION_USER 
        add constraint FK122B417A1C80E5AF 
        foreign key (CREATED_BY) 
        references APPLICATION_USER;

    alter table APPLICATION_USER 
        add constraint FK122B417A280B42A0 
        foreign key (ADDRESS_ID) 
        references ADDRESS;

    alter table APPLICATION_USER 
        add constraint FK122B417A6ED2CA2E 
        foreign key (MODIFIED_BY) 
        references APPLICATION_USER;

    alter table APPLICATION_USER 
        add constraint FK122B417ACA31445D 
        foreign key (PREFERENCE_ID) 
        references PREFERENCE;

    alter table LANGUAGE 
        add constraint FKCE7883581C80E5AF 
        foreign key (CREATED_BY) 
        references APPLICATION_USER;

    alter table LANGUAGE 
        add constraint FKCE7883586ED2CA2E 
        foreign key (MODIFIED_BY) 
        references APPLICATION_USER;

    alter table MSG_TEMPLATE 
        add constraint FK3C38FF981C80E5AF 
        foreign key (CREATED_BY) 
        references APPLICATION_USER;

    alter table MSG_TEMPLATE 
        add constraint FK3C38FF986ED2CA2E 
        foreign key (MODIFIED_BY) 
        references APPLICATION_USER;

    alter table MSG_TEMPLATE_TEXT 
        add constraint FKD350F5741C80E5AF 
        foreign key (CREATED_BY) 
        references APPLICATION_USER;

    alter table MSG_TEMPLATE_TEXT 
        add constraint FKD350F5746ED2CA2E 
        foreign key (MODIFIED_BY) 
        references APPLICATION_USER;

    alter table MSG_TEMPLATE_TEXT 
        add constraint FKD350F574EA3FA049 
        foreign key (MSG_TEMPLATE_ID) 
        references MSG_TEMPLATE;

    alter table MSG_TEMPLATE_TEXT 
        add constraint FKD350F574CDD07A14 
        foreign key (LANGUAGE_ID) 
        references LANGUAGE;

    alter table PREFERENCE 
        add constraint FKC5E6A8DB1C80E5AF 
        foreign key (CREATED_BY) 
        references APPLICATION_USER;

    alter table PREFERENCE 
        add constraint FKC5E6A8DB6ED2CA2E 
        foreign key (MODIFIED_BY) 
        references APPLICATION_USER;

    alter table PREFERENCE 
        add constraint FKC5E6A8DB10CBEBBE 
        foreign key (LANG_ID) 
        references LANGUAGE;

    alter table SMSUSR_TRLOG 
        add constraint FKFC8DF8421C80E5AF 
        foreign key (CREATED_BY) 
        references APPLICATION_USER;

    alter table SMSUSR_TRLOG 
        add constraint FKFC8DF8426ED2CA2E 
        foreign key (MODIFIED_BY) 
        references APPLICATION_USER;

    alter table SMS_PARAM_CONFIG 
        add constraint FK584A1C9A1C80E5AF 
        foreign key (CREATED_BY) 
        references APPLICATION_USER;

    alter table SMS_PARAM_CONFIG 
        add constraint FK584A1C9A6ED2CA2E 
        foreign key (MODIFIED_BY) 
        references APPLICATION_USER;

    alter table SMS_SERVICE 
        add constraint FKBF18F1C80E5AF 
        foreign key (CREATED_BY) 
        references APPLICATION_USER;

    alter table SMS_SERVICE 
        add constraint FKBF18F6ED2CA2E 
        foreign key (MODIFIED_BY) 
        references APPLICATION_USER;

    create sequence ADDRESS_SEQ;

    create sequence APPLICATION_USER_SEQ;

    create sequence LANGUAGE_SEQ;

    create sequence MSG_TEMPLATE_SEQ;

    create sequence MSG_TEMPLATE_TEXT_SEQ;

    create sequence PREFERENCE_SEQ;

    create sequence SMSUSR_TRLOG_SEQ;

    create sequence SMS_PARAM_CONFIG_SEQ;

    create sequence SMS_SERVICE_SEQ;
