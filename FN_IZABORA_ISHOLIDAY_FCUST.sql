create or replace FUNCTION FN_IZABORA_ISHOLIDAY_FCUST(
    p_dateParam IN DATE,
    p_nParam IN NUMBER,
    p_HorW OUT VARCHAR2,
    p_error_message OUT VARCHAR2
)RETURN BOOLEAN IS
    l_myDate DATE;
    l_holidayList STTM_LCL_HOLIDAY.holiday_list%TYPE;
    l_month_number NUMBER;
    l_year_number NUMBER;
    l_day_number NUMBER;
    l_holiday_status VARCHAR2(1); 
BEGIN
  -- Initialize the date based on whether n is negative or positive
   IF p_nParam < 0 THEN
      l_myDate := p_dateParam - ABS(p_nParam);
      p_HorW := 'before';
   ELSE
      l_myDate := p_dateParam + p_nParam;
      p_HorW := 'from';
   END IF;
   
   --The three lines of code below store the day, month and year of the date to be queried
   --such that we are able to search for it in the table
    l_month_number := EXTRACT(MONTH FROM l_myDate);
    l_year_number := EXTRACT(YEAR FROM l_myDate);
    l_day_number := EXTRACT(DAY FROM l_myDate);
 
    --Query the table to store the list of characters (h and w), in order to check later if 
    --the l_day_number-th character is h
    BEGIN
        SELECT holiday_list
        INTO l_holidayList
        FROM STTM_LCL_HOLIDAY
        WHERE year = l_year_number AND month = l_month_number;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN --If the date is not at all in the table, 
                           --eg. if the year entered is earlier or later than the ones in the table
        p_error_message := 'Date not found in the holiday table.';
        RETURN FALSE;
    END;
    
    l_holiday_status := SUBSTR(l_holidayList, l_day_number , 1);
    
    IF l_holiday_status = 'H' THEN
        -- Check if the date is a holiday (day off)(assuming holidays on weekends)
        IF TO_CHAR(l_myDate, 'D') = '1' OR TO_CHAR(l_myDate, 'D') = '7' THEN -- extract the day of the week as a number
                p_error_message := 'Date is a weekend holiday.';
                RETURN TRUE;
        END IF;
        p_error_message := 'Date is a holiday.';
         RETURN TRUE;
    ELSIF l_holiday_status = 'W' THEN
        p_error_message := 'Date is not a holiday.';
        RETURN FALSE;
    END IF;
    
EXCEPTION
   WHEN OTHERS THEN
      p_error_message := SQLERRM;
      DBMS_OUTPUT.PUT_LINE(SQLERRM);
      DBMS_OUTPUT.PUT_LINE(dbms_utility.format_error_backtrace);
      RAISE;
END FN_IZABORA_ISHOLIDAY_FCUST;