DELETE GWTB_AMEND_NODES A  WHERE A.RAD_FUNCTION_ID = 'STDBORA4' ;
INSERT INTO GWTB_AMEND_NODES(NODE_NAME,NEW_ALLOWED,DELETE_ALLOWED,ALL_RECORDS,SERVICE_NAME,OPERATION_CODE,RAD_FUNCTION_ID) VALUES(
'STTM_BORA4_MASTER',
'Y',
'Y',
'Y',
'STDBORA4',
'STDBORA4_EXECUTEQUERY',
'STDBORA4');
INSERT INTO GWTB_AMEND_NODES(NODE_NAME,NEW_ALLOWED,DELETE_ALLOWED,ALL_RECORDS,SERVICE_NAME,OPERATION_CODE,RAD_FUNCTION_ID) VALUES(
'STTM_BORA4_DETAIL',
'Y',
'Y',
'Y',
'STDBORA4',
'STDBORA4_EXECUTEQUERY',
'STDBORA4');
INSERT INTO GWTB_AMEND_NODES(NODE_NAME,NEW_ALLOWED,DELETE_ALLOWED,ALL_RECORDS,SERVICE_NAME,OPERATION_CODE,RAD_FUNCTION_ID) VALUES(
'STTM_BORA4_MASTER',
'Y',
'Y',
'Y',
'STDBORA4',
'STDBORA4_NEW',
'STDBORA4');
INSERT INTO GWTB_AMEND_NODES(NODE_NAME,NEW_ALLOWED,DELETE_ALLOWED,ALL_RECORDS,SERVICE_NAME,OPERATION_CODE,RAD_FUNCTION_ID) VALUES(
'STTM_BORA4_DETAIL',
'Y',
'Y',
'Y',
'STDBORA4',
'STDBORA4_NEW',
'STDBORA4');
INSERT INTO GWTB_AMEND_NODES(NODE_NAME,NEW_ALLOWED,DELETE_ALLOWED,ALL_RECORDS,SERVICE_NAME,OPERATION_CODE,RAD_FUNCTION_ID) VALUES(
'STTM_BORA4_MASTER',
'Y',
'Y',
'Y',
'STDBORA4',
'STDBORA4_MODIFY',
'STDBORA4');
INSERT INTO GWTB_AMEND_NODES(NODE_NAME,NEW_ALLOWED,DELETE_ALLOWED,ALL_RECORDS,SERVICE_NAME,OPERATION_CODE,RAD_FUNCTION_ID) VALUES(
'STTM_BORA4_DETAIL',
'Y',
'Y',
'Y',
'STDBORA4',
'STDBORA4_MODIFY',
'STDBORA4');
COMMIT;