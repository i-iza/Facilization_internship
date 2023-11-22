CREATE TABLE STTM_BORA4_CUSTOMER_INFO (
    customer_number     VARCHAR2(20),
    customer_name       VARCHAR2(50),
    phone_number        VARCHAR2(20),
    email               VARCHAR2(50),
    account             VARCHAR2(50),
    ccy                 VARCHAR2(3),
    CONSTRAINT PK_STTM_BORA4_CUSTOMER_INFO PRIMARY KEY (account)
);