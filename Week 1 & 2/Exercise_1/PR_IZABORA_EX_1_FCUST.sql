create or replace PROCEDURE PR_IZABORA_EX_1_FCUST (
    p_filename IN VARCHAR2
)   AS 
BEGIN
  --Insert the data inside xml tags in the xml file stored in a column of izabora_xml_table
    BEGIN
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
        ) x
        WHERE t.filename = p_filename;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.PUT_LINE('The file you are trying to read is not of the same format as the procedure expects.');
        WHEN OTHERS THEN 
        RAISE;
    END;
EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN
        DBMS_OUTPUT.PUT_LINE('The data already exists in the table!');
        RAISE;
    WHEN OTHERS THEN 
        DBMS_OUTPUT.PUT_LINE(SQLERRM);
        DBMS_OUTPUT.PUT_LINE(dbms_utility.format_error_backtrace);
    RAISE;
END PR_IZABORA_EX_1_FCUST;