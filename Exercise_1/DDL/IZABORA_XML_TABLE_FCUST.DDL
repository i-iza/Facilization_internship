CREATE TABLE IZABORA_xml_table (
  id_table        NUMBER(10),
  filename        VARCHAR2(100),
  xml_data        XMLTYPE,
  CONSTRAINT xml_table_pk PRIMARY KEY (id_table)
);