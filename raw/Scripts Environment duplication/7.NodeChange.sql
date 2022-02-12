
Alter table ACTB_DAILY_LOG Disable all triggers;

Alter table BKTB_SCHEMA_DEFAULTS Disable all triggers;

Alter table CSTB_NODE_PARAMS Disable all triggers;

Alter table DSTB_MAINT Disable all triggers;

Alter table ICTB_ACC_ACTION Disable all triggers;

Alter table ICTB_ACTION_LOG Disable all triggers;

Alter table ICTB_RESOLUTION_ERROR Disable all triggers;

Alter table LMTB_OFFLINE_NODES Disable all triggers;

Alter table LMTB_OFFLINE_UTILS Disable all triggers;

Alter table MSTB_CURRENT_MSG_IND_OUT Disable all triggers;

Alter table MSTB_DLY_MSG_IN Disable all triggers;

Alter table MSTB_DLY_MSG_OUT Disable all triggers;

Alter table MSTM_MCS Disable all triggers;

Alter table MSTM_UNDO Disable all triggers;

Alter table STTM_BRANCH Disable all triggers;

Alter table STTM_CUSTOMER Disable all triggers;
UPDATE ACTB_DAILY_LOG SET NODE = 'NEWNODE';
UPDATE BKTB_SCHEMA_DEFAULTS SET NODE = 'NEWNODE';
UPDATE DSTB_MAINT SET NODE = 'NEWNODE';
UPDATE ICTB_ACC_ACTION SET NODE = 'NEWNODE';
UPDATE ICTB_ACTION_LOG SET NODE = 'NEWNODE';
UPDATE ICTB_RESOLUTION_ERROR SET NODE = 'NEWNODE';
UPDATE LMTB_OFFLINE_NODES SET NODE_NAME = 'NEWNODE';
UPDATE LMTB_OFFLINE_UTILS SET NODE_NAME = 'NEWNODE';
UPDATE MSTB_CURRENT_MSG_IND_OUT SET NODE = 'NEWNODE';
UPDATE MSTB_DLY_MSG_IN SET NODE = 'NEWNODE';
UPDATE MSTB_DLY_MSG_OUT SET NODE = 'NEWNODE';
UPDATE MSTM_MCS SET NODE = 'NEWNODE';
UPDATE MSTM_UNDO SET NODE = 'NEWNODE';
UPDATE STTM_BRANCH_NODE SET NODE = 'NEWNODE';
UPDATE STTM_BRANCH SET NODE = 'NEWNODE';
UPDATE STTM_CUSTOMER SET LIAB_NODE = 'NEWNODE';
UPDATE STTM_HOST SET HOST_NAME = 'NEWNODE';

Alter table ACTB_DAILY_LOG Enable all triggers;

Alter table BKTB_SCHEMA_DEFAULTS Enable all triggers;

Alter table CSTB_NODE_PARAMS Enable all triggers;

Alter table DSTB_MAINT Enable all triggers;

Alter table ICTB_ACC_ACTION Enable all triggers;

Alter table ICTB_ACTION_LOG Enable all triggers;

Alter table ICTB_RESOLUTION_ERROR Enable all triggers;

Alter table LMTB_OFFLINE_NODES Enable all triggers;

Alter table LMTB_OFFLINE_UTILS Enable all triggers;

Alter table MSTB_CURRENT_MSG_IND_OUT Enable all triggers;

Alter table MSTB_DLY_MSG_IN Enable all triggers;

Alter table MSTB_DLY_MSG_OUT Enable all triggers;

Alter table MSTM_MCS Enable all triggers;

Alter table MSTM_UNDO Enable all triggers;

Alter table STTM_BRANCH Enable all triggers;

Alter table STTM_CUSTOMER Enable all triggers;
