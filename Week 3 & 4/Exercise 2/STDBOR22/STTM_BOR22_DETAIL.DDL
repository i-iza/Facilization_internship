CREATE TABLE STTM_BOR22_DETAIL(
    product_code        VARCHAR2(10),
    relationship        VARCHAR2(50),
    cat                 VARCHAR2(50),
    CONSTRAINT PK_STTM_BOR22_DETAIL PRIMARY KEY (relationship, cat, product_code)
);
