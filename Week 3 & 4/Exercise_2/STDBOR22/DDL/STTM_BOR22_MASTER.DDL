CREATE TABLE STTM_BOR22_MASTER(
    relationship        VARCHAR2(50),
    descript            VARCHAR2(50),
    cat                 VARCHAR2(50),
    product_restriction VARCHAR2(10),
    AUTH_STAT           CHAR(1),
    RECORD_STAT         CHAR(1),
    MOD_NO              NUMBER,
    CHECKER_ID          VARCHAR2(12),
    ONCE_AUTH           VARCHAR2(1),
    MAKER_ID            VARCHAR2(12),
    MAKER_DT_STAMP      TIMESTAMP (6),
    CHECKER_DT_STAMP    TIMESTAMP (6),
    CONSTRAINT PK_STTM_BOR22_MASTER PRIMARY KEY (relationship, cat)
);
CREATE SYNONYM STTMS_BOR22_MASTER FOR STTM_BOR22_MASTER;