create or replace FUNCTION FN_IZABORA_EXCHANGE_FCUST (
                    p_ccy_from IN VARCHAR2,
                    p_ccy_to IN VARCHAR2,
                    p_amount IN NUMBER,
                    p_maintenance_c IN VARCHAR2,
                    p_branch_code IN VARCHAR2
)RETURN NUMBER AS
    l_result_amount     NUMBER(22,3);
    l_mid_rate          NUMBER(24,12);
    l_digits_after      NUMBER(20);
    l_last_change       DATE;
BEGIN
    --First we find the mid rate between the specified currencies using the function we created recently
    l_mid_rate := fn_IZABORA_MID_RATE_FCUST(p_ccy_from, p_ccy_to, p_branch_code);
    --To calculate the amount in a different currency, we multiply the amount with the mid rate
    l_result_amount := p_amount * l_mid_rate;
    
    --Search for the last updated version of the entered maintenance contry
    BEGIN
        SELECT MAX(maker_dt_stamp) INTO l_last_change
        FROM CYTM_CCY_DEFN_MASTER
        WHERE ccy_code = p_ccy_to
        AND maintenance_country = p_maintenance_c;
    END;
    --Get the number of digits after the decimal point
    BEGIN
        SELECT ccy_decimals INTO l_digits_after
        FROM CYTM_CCY_DEFN_MASTER
        WHERE ccy_code = p_ccy_to
        AND maker_dt_stamp = l_last_change
        AND maintenance_country = p_maintenance_c;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
          DBMS_OUTPUT.PUT_LINE('Cannot find currency description and digits after the decimal point.');  
    END;
    
    --Check if the currency has the number of decimal digits specified
    --If yes, we round up the amount
    --If not, we just return the calculated amount
    IF l_digits_after IS NOT NULL THEN
      l_result_amount := ROUND(l_result_amount, l_digits_after);
      RETURN l_result_amount;
    END IF;
    RETURN l_result_amount;
    
EXCEPTION
    WHEN OTHERS THEN 
        DBMS_OUTPUT.PUT_LINE(SQLERRM);
        DBMS_OUTPUT.PUT_LINE(dbms_utility.format_error_backtrace);
        RAISE;
END FN_IZABORA_EXCHANGE_FCUST;