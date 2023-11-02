CREATE OR REPLACE PROCEDURE PR_IZABORA_EX_2_FCUST AS 
    l_file UTL_FILE.FILE_TYPE; --file handle
    l_line VARCHAR2(200);      --where the lines of the CSV will be read
    l_counter NUMBER;
BEGIN
  -- Open the file for reading 
    l_file := UTL_FILE.FOPEN('IZABORA_CSV_EX', 'ex2.csv', 'R');
   -- Read and process each line from the file
    LOOP
        UTL_FILE.GET_LINE(l_file, l_line); --reads the next line from the file pointed to by v_file and stores it in the v_line variable.
        --check if the currency rate for a certain day is already entered
        SELECT COUNT(*) 
        INTO l_counter
        FROM IZABORA_CURRENCY_EXCHANGE_RATE
        WHERE SUBSTR(l_line, 1, 3) = currency_name
            AND TO_DATE(SUBSTR(l_line, INSTR(l_line, ',', 1, 2) + 1, LENGTH(l_line)), 'DD-MM-YYYY') = date_of_rate; 
            -- Parse the line into columns 
            IF l_counter = 0 THEN
                INSERT INTO IZABORA_CURRENCY_EXCHANGE_RATE (currency_name, exchange_rate, date_of_rate)
                VALUES (
                        SUBSTR(l_line, 1, 3), --currency 
                        TO_NUMBER(SUBSTR(l_line, INSTR(l_line, ',', 1, 1) + 1, INSTR(l_line, ',', 1, 2) - INSTR(l_line, ',', 1, 1) - 1)),--ex_rate
                        TO_DATE(SUBSTR(l_line, INSTR(l_line, ',', 1, 2) + 1, LENGTH(l_line)), 'DD-MM-YYYY')--date
                        );
                IF INSTR(l_line, '=') > 0 THEN --when the to_currency shouldn't be EUR by default, because it is specified differently
                    UPDATE izabora_currency_exchange_rate
                    SET to_currency = SUBSTR(l_line, 9, 3)
                    WHERE currency_name = SUBSTR(l_line, 1, 3);
                END IF;
            ELSE
                DBMS_OUTPUT.PUT_LINE('Exchange rate for the same currency and date already exists!');
            END IF;
    END LOOP;  
EXCEPTION
   WHEN NO_DATA_FOUND THEN
       DBMS_OUTPUT.PUT_LINE('Data entered!'); -- No more data in the file
       UTL_FILE.FCLOSE(l_file);
   WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE(SQLERRM);
        DBMS_OUTPUT.PUT_LINE(dbms_utility.format_error_backtrace);
        RAISE;
END PR_IZABORA_EX_2_FCUST;