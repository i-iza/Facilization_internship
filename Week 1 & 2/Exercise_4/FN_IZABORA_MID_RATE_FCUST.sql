CREATE OR REPLACE FUNCTION FN_IZABORA_MID_RATE_FCUST(
    p_ccy_from  IN VARCHAR2,
    p_ccy_to    IN VARCHAR2,
    p_branch    IN CYTM_RATES.branch_code%TYPE
) RETURN NUMBER IS
    l_mid_rate          NUMBER(24,12);
    l_mid_rate_2        NUMBER(24,12);
    l_other_currency    VARCHAR2(3); 
BEGIN
    --First check if the currencies are the same
    IF p_ccy_from = p_ccy_to THEN
        DBMS_OUTPUT.PUT_LINE('The currencies are the same');
        RETURN 1;
    END IF;
    --Check if the given pair exists in the same order in the table
    --Case 1
    BEGIN
        SELECT mid_rate 
        INTO l_mid_rate
        FROM CYTM_RATES
        WHERE ccy1 = p_ccy_from
            AND ccy2 = p_ccy_to
            AND rate_type = 'STANDARD'
            AND p_branch = branch_code;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
        NULL;
    END;
    IF l_mid_rate IS NOT NULL THEN --If they are in the correct order, then the mid rate is returned to the user
        RETURN l_mid_rate;
    END IF;
     
    --Check if the currencies are in reverse order
    --Case 2
    BEGIN
        SELECT mid_rate 
        INTO l_mid_rate
        FROM CYTM_RATES
        WHERE ccy2 = p_ccy_from
            AND ccy1 = p_ccy_to
            AND rate_type = 'STANDARD'
            AND p_branch = branch_code;
    EXCEPTION
         WHEN NO_DATA_FOUND THEN
            NULL;
    END;
    IF l_mid_rate IS NOT NULL THEN 
        RETURN 1/l_mid_rate;
    END IF;
    
    --SUBCASE 3.1: the first currency in the table is the currency from (first record) and the second currency in the table is the 
	             --currency to (second record)
    --SUBCASE 3.3: the first currency in the table is the currency from (first record) and the first currency in the table is the  
	             --currency to (second record)
    --Case 3.1  and   Case 3.3 
    BEGIN
        SELECT ccy2, mid_rate    --Select the second currency to if the first currency exists
        INTO l_other_currency, l_mid_rate
        FROM CYTM_RATES
        WHERE ccy1 = p_ccy_from
        AND rate_type = 'STANDARD'
        AND p_branch = branch_code;
    EXCEPTION
         WHEN NO_DATA_FOUND THEN
            NULL;
    END; 
    BEGIN
        IF l_other_currency IS NOT NULL THEN    --If the first currency is found 
            SELECT mid_rate
            INTO l_mid_rate_2
            FROM CYTM_RATES
            WHERE ccy2 = p_ccy_to
            AND l_other_currency = ccy1
            AND rate_type = 'STANDARD'
            AND p_branch = branch_code;
        END IF;
    EXCEPTION
         WHEN NO_DATA_FOUND THEN
            NULL;
    END;
    
    IF l_mid_rate_2 IS NOT NULL THEN --If the second currency is found in the correct order
        l_mid_rate := l_mid_rate * l_mid_rate_2;
        RETURN l_mid_rate;
    END IF;  
    BEGIN                           --If the second currency is found in the reverse order
        SELECT mid_rate
        INTO l_mid_rate_2
        FROM CYTM_RATES
        WHERE ccy1 = p_ccy_to
        AND l_other_currency = ccy1
        AND rate_type = 'STANDARD'
        AND p_branch = branch_code;
    EXCEPTION
         WHEN NO_DATA_FOUND THEN
            NULL;
    END;
    IF l_mid_rate_2 IS NOT NULL THEN  
        l_mid_rate := l_mid_rate * 1/l_mid_rate_2;
        RETURN l_mid_rate;
    END IF;
    
    --SUBCASE 3.2: the second currency in the table is the currency from (first record) and the second currency in the table is the
		     --currency to (second record)
    --SUBCASE 3.4: the second currency in the table is the currency from (first record) and the first currency in the table is the currency
		     --to (second record)    
    --Case 3.2   and    Case 3.4    
    BEGIN
        SELECT ccy1, mid_rate    --Select the first currency from if the second currency exists
        INTO l_other_currency, l_mid_rate
        FROM CYTM_RATES
        WHERE ccy2 = p_ccy_from
        AND rate_type = 'STANDARD'
        AND p_branch = branch_code;
     EXCEPTION
         WHEN NO_DATA_FOUND THEN
            NULL;
    END;
    
    BEGIN 
        IF l_other_currency IS NOT NULL THEN    --If the first currency exists
            SELECT mid_rate
            INTO l_mid_rate_2
            FROM CYTM_RATES
            WHERE ccy2 = p_ccy_to
            AND l_other_currency = ccy1
            AND rate_type = 'STANDARD'
            AND p_branch = branch_code;
        END IF;
     EXCEPTION
         WHEN NO_DATA_FOUND THEN
            NULL;
    END;
    
    IF l_mid_rate_2 IS NOT NULL THEN     --If the second currency is found in the correct order
        l_mid_rate := 1/l_mid_rate * l_mid_rate_2;
        RETURN l_mid_rate; 
    END IF;
    BEGIN                                
        SELECT mid_rate
        INTO l_mid_rate_2
        FROM CYTM_RATES
        WHERE ccy1 = p_ccy_to
        AND l_other_currency = ccy2
        AND rate_type = 'STANDARD'
        AND p_branch = branch_code;
    EXCEPTION
         WHEN NO_DATA_FOUND THEN
            NULL;
    END;
    
    IF l_mid_rate_2 IS NOT NULL THEN     --If the second currency is found in the reverse order
        l_mid_rate := 1/l_mid_rate * 1/l_mid_rate_2;
        RETURN l_mid_rate;
    ELSE
        DBMS_OUTPUT.PUT_LINE('Exchange rate not found.');
    END IF;
    RETURN l_mid_rate;
EXCEPTION
    WHEN OTHERS THEN 
        DBMS_OUTPUT.PUT_LINE(SQLERRM);
        DBMS_OUTPUT.PUT_LINE(dbms_utility.format_error_backtrace);
        RAISE;
END FN_IZABORA_MID_RATE_FCUST;