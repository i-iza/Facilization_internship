CREATE TABLE STTM_BORA4_DETAIL (
    subject             VARCHAR2(50),
    descript            VARCHAR2(50), 
    my_user             VARCHAR2(50),
    current_date        DATE,
    refer               VARCHAR2(20),
    CONSTRAINT PK_STTM_BORA4_DETAIL PRIMARY KEY (refer, my_user)
);