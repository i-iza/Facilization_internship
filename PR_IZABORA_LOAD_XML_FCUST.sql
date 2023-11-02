CREATE OR REPLACE PROCEDURE PR_IZABORA_LOAD_XML_FCUST (p_dir  IN  VARCHAR2,
                                      p_filename  IN  VARCHAR2) AS
  --Reads xml file into a clob then inserts that data into a table
  l_bfile  BFILE := BFILENAME(p_dir, p_filename);
  l_clob   CLOB;
  l_dest_offset   INTEGER := 1; --It will be used as an offset when loading data into the CLOB.
  l_src_offset    INTEGER := 1; --It will be used as an offset when loading data from the BFILE.
  l_bfile_csid    NUMBER  := 0; --related to the character set of the BFILE
  l_lang_context  INTEGER := 0; --related to the language context for loading data
  l_warning       INTEGER := 0; --used to capture any warning messages during the data loading process
BEGIN
  DBMS_LOB.createtemporary (l_clob, TRUE); --the CLOB should be initialized.

  DBMS_LOB.fileopen(l_bfile, DBMS_LOB.file_readonly);
  -- DBMS_LOB.loadfromfile(l_clob, l_bfile, DBMS_LOB.getlength(l_bfile));
  DBMS_LOB.loadclobfromfile (
    dest_lob      => l_clob,
    src_bfile     => l_bfile,
    amount        => DBMS_LOB.lobmaxsize,
    dest_offset   => l_dest_offset,
    src_offset    => l_src_offset,
    bfile_csid    => l_bfile_csid ,
    lang_context  => l_lang_context,
    warning       => l_warning);
  DBMS_LOB.fileclose(l_bfile);

  INSERT INTO IZABORA_xml_table (
    id_table,
    filename,
    xml_data
  )
  VALUES (
   IZABORA_xml_tab_seq.NEXTVAL, --generate a new unique sequence value from the sequence, used also as a primary key
    p_filename,
    XMLTYPE.createXML(l_clob) --used to convert the CLOB data into an XMLType instance
  );
  COMMIT;

EXCEPTION
    WHEN OTHERS THEN 
    DBMS_OUTPUT.PUT_LINE(SQLERRM);
    DBMS_OUTPUT.PUT_LINE(dbms_utility.format_error_backtrace);
    RAISE;
END PR_IZABORA_LOAD_XML_FCUST;