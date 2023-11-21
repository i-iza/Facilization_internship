create or replace FUNCTION FN_IZABORA_DOES_CONTRACT_EXIST_NO_FCUST(
   p_udf_name  IN VARCHAR2,  -- The character to distinguish columns
   p_udf_value IN VARCHAR2,  
   p_fc_module IN VARCHAR2
)  RETURN      VARCHAR2 IS
   l_result          VARCHAR2(1) := 'N'; -- Default to 'N'
   l_field_num       cstm_product_udf_fields_map.field_num%TYPE; --Store the field number found on the mapping table 
   l_column_prefix   VARCHAR2(20) := 'field_val_';
   l_column          VARCHAR2(21);  --Store the entire column name
   l_sql_statement   VARCHAR2(200); -- To store the dynamic SQL statement
   l_count           NUMBER; 
BEGIN
    -- Find the field number of given field name, in order to query the fields table
    BEGIN
        SELECT FIELD_NUM
        INTO l_field_num
        FROM cstm_product_udf_fields_map
        WHERE FIELD_NAME = p_udf_name;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
             DBMS_OUTPUT.PUT_LINE('There is no field number for that field name.');
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE(SQLERRM);
            DBMS_OUTPUT.PUT_LINE(dbms_utility.format_error_backtrace);
            RAISE; 
        END;
    --Create the name of the column where the contract value needs to be queried
    l_column := l_column_prefix || l_field_num;
    
    --Create a dynamic query to return the number of contracts found (>= 1 if the contract exists, 0 if the contract does not exist)
    l_sql_statement := 'SELECT count(*) FROM cstm_contract_userdef_fields WHERE ' || l_column || ' = :udf_value AND module = :fc_module';
    EXECUTE IMMEDIATE l_sql_statement INTO l_count USING p_udf_value, p_fc_module;  

    --We need to return 'Y' if the contract exists
    IF l_count >= 1 THEN
        l_result := 'Y';
    END IF;
    
    RETURN l_result;
   
EXCEPTION
   WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE(SQLERRM);
    DBMS_OUTPUT.PUT_LINE(dbms_utility.format_error_backtrace);
    RAISE; 
END FN_IZABORA_DOES_CONTRACT_EXIST_NO_FCUST;