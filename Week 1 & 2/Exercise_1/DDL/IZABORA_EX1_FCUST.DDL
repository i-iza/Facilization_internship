CREATE TABLE IZABORA_ex1 (
  EndToEndId      VARCHAR2(20),
  Amt             NUMBER,
  Ccy             VARCHAR2(3),
  IBAN            VARCHAR2(34),
  BIC             VARCHAR2(11),
  CONSTRAINT pk_EndToEndId PRIMARY KEY (EndToEndId)
);