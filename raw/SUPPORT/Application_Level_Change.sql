EXEC dbms_java.grant_permission( 'NFCSUP', 'SYS:java.net.SocketPermission', '172.20.50.4:7001', 'connect,resolve' );
update CSTB_PARAM set PARAM_VAL='http://172.20.50.4:7001/FCJNeoWeb-ELGatewayClient/IntegrationController' where PARAM_NAME='ELCM_POSS_URL';
update CSTB_PARAM set PARAM_VAL='http://172.20.50.4:7001/FCJNeoWeb-ELGatewayClient/IntegrationController' where PARAM_NAME='ELCM_URL';
update CSTB_PARAM set param_val='NFCBANK.SA SUPPORT' where param_name ='RELEASE';
update sttm_branch set HOST_NAME ='NFCSUP';
commit;