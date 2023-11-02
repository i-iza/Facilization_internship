create or replace PROCEDURE PR_IZABORA_EX_1_FCUST AS 
BEGIN
  --Insert the data inside xml tags in the xml file stored in a column of izabora_xml_table
    INSERT INTO izabora_ex1 (EndToEndId, Amt, ccy, iban, bic)
    SELECT
    x.EndToEndId,
    x.amt,
    x.ccy,
    x.iban,
    x.bic
    FROM
    izabora_xml_table t,
    XMLTable(
        '/Msg/Docs/Doc/Cctinit/Document/CstmrCdtTrfInitn/PmtInf/CdtTrfTxInf'
        PASSING t.xml_data --The source of data
        COLUMNS
            EndToEndId VARCHAR2(20) PATH 'PmtId/EndToEndId',
            amt NUMBER PATH 'Amt/InstdAmt',
            ccy VARCHAR2(3) PATH 'Amt/InstdAmt/@Ccy',
            iban VARCHAR2(34) PATH 'CdtrAcct/Id/IBAN',
            bic VARCHAR2(11) PATH 'CdtrAgt/FinInstnId/BIC'
    ) x;
EXCEPTION
    WHEN OTHERS THEN 
    DBMS_OUTPUT.PUT_LINE(SQLERRM);
    DBMS_OUTPUT.PUT_LINE(dbms_utility.format_error_backtrace);
    RAISE;
END PR_IZABORA_EX_1_FCUST;