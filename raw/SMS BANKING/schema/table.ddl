CREATE TABLE "SMSUSR"."SMS_SERVICE" 
   (	"ID" NUMBER(19,0) NOT NULL ENABLE, 
	"CREATED_ON" TIMESTAMP (6), 
	"MODIFIED_ON" TIMESTAMP (6), 
	"STATUS" VARCHAR2(255 CHAR), 
	"DESCRIPTION" VARCHAR2(255 CHAR), 
	"SERVICE_CODE" VARCHAR2(255 CHAR), 
	"SERVICE_NAME" VARCHAR2(255 CHAR), 
	"CREATED_BY" NUMBER(19,0), 
	"MODIFIED_BY" NUMBER(19,0), 
	 PRIMARY KEY ("ID")
  USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "USERS"  ENABLE, 
	 CONSTRAINT "FKBF18F1C80E5AF" FOREIGN KEY ("CREATED_BY")
	  REFERENCES "SMSUSR"."APPLICATION_USER" ("ID") ENABLE, 
	 CONSTRAINT "FKBF18F6ED2CA2E" FOREIGN KEY ("MODIFIED_BY")
	  REFERENCES "SMSUSR"."APPLICATION_USER" ("ID") ENABLE
   ) SEGMENT CREATION IMMEDIATE 
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "USERS" ;
  CREATE UNIQUE INDEX "SMSUSR"."SYS_C00141094" ON "SMSUSR"."SMS_SERVICE" ("ID") 
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "USERS" ;
  ALTER TABLE "SMSUSR"."SMS_SERVICE" ADD PRIMARY KEY ("ID")
  USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "USERS"  ENABLE;
  ALTER TABLE "SMSUSR"."SMS_SERVICE" MODIFY ("ID" NOT NULL ENABLE);