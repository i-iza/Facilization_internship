DELETE CSTB_FID_DATA_BLOCKS A  WHERE A.FUNCTION_ID = 'STDBORA4' ;
INSERT INTO CSTB_FID_DATA_BLOCKS(FUNCTION_ID,BLOCK_NAME,BLOCK_NO,BLOCK_TYPE,BLOCK_PARENT,RELATION_TYPE,MULTI_RECORD,BLOCK_TITLE,XSD_NODE,DSN_LIST,DSN_LIST_1,DSN_LIST_2,FLD_TAG_FIELDS,FLD_TAG_FIELDS_1,FLD_TAG_FIELDS_2,FLD_TAG_XSD_TAGS,FLD_TAG_XSD_TAGS_1,FLD_TAG_XSD_TAGS_2) VALUES(
'STDBORA4',
'BLK_MAIN',
1,
'NORMAL',
NULL,
'1',
'N',
NULL,
'Main',
'STTM_BORA4_MASTER~STTM_BORA4_MASTER~STTM_BORA4_MASTER~STTM_BORA4_MASTER~STTM_BORA4_MASTER~STTM_BORA4_MASTER~STTM_BORA4_MASTER~STTM_BORA4_MASTER~STTM_BORA4_MASTER~STTM_BORA4_MASTER~STTM_BORA4_MASTER~STTM_BORA4_MASTER~STTM_BORA4_MASTER~STTM_BORA4_MASTER~STTM_BORA4_MASTER~STTM_BORA4_MASTER~STTM_BORA4_MASTER~STTM_BORA4_MASTER~STTM_BORA4_MASTER~',
NULL,
NULL,
'ACCOUNT~AMMOUNT~CCY~CUSTOMER_NAME~DESCRIPT~EMAIL~PHONE_NUMBER~PRIORITY~REFER~CURRENT_DATE~CUSTOMER_NUMBER~MAKER~MAKERSTAMP~CHECKER~CHECKERSTAMP~MODNO~TXNSTAT~AUTHSTAT~ONCEAUTH~',
NULL,
NULL,
'ACCOUNT~AMMOUNT~CCY~CUSTOMER_NAME~DESCRIPT~EMAIL~PHONE_NUMBER~PRIORITY~REFER~CURRENT_DATE~CUSTOMER_NUMBER~MAKER~MAKERSTAMP~CHECKER~CHECKERSTAMP~MODNO~TXNSTAT~AUTHSTAT~ONCEAUTH~',
NULL,
NULL);
INSERT INTO CSTB_FID_DATA_BLOCKS(FUNCTION_ID,BLOCK_NAME,BLOCK_NO,BLOCK_TYPE,BLOCK_PARENT,RELATION_TYPE,MULTI_RECORD,BLOCK_TITLE,XSD_NODE,DSN_LIST,DSN_LIST_1,DSN_LIST_2,FLD_TAG_FIELDS,FLD_TAG_FIELDS_1,FLD_TAG_FIELDS_2,FLD_TAG_XSD_TAGS,FLD_TAG_XSD_TAGS_1,FLD_TAG_XSD_TAGS_2) VALUES(
'STDBORA4',
'BLK_DETAIL',
2,
'NORMAL',
'BLK_MAIN',
'N',
'Y',
NULL,
'Detail',
'STTM_BORA4_DETAIL~STTM_BORA4_DETAIL~STTM_BORA4_DETAIL~STTM_BORA4_DETAIL~STTM_BORA4_DETAIL~',
NULL,
NULL,
'DESCRIPT~MY_USER~REFER~SUBJECT~CURRENT_DATE~',
NULL,
NULL,
'DESCRIPT~MY_USER~REFER~SUBJECT~CURRENT_DATE~',
NULL,
NULL);
COMMIT;