/********************************************
*      Lab 7                                *
*      Exceptions                           *
*                                           *
*      Author: Ana Joselyn Alarcon          *
*      Date: October 27th, 2023              *
********************************************/

SET SERVEROUTPUT ON

-- •	Rule 1 (5 marks): If an employee’s salary is higher than the president’s salary, 
--the employee’s salary should either be reduced by 50% or
-- be reduced to 25% less than the president’s salary,
-- whichever is less. 
--For example, if the president’s salary is $5,000,
--25% less than that is $3,750. If the employee’s salary is $6,000, 
--a reduction of 50% would bring their salary down to $3,000. The employee’s new salary should be $3,000 because it is the lower of the two values.

DECLARE
employee_salary     emp.sal%TYPE;
c_president_job CONSTANT emp.job%TYPE := 'PRESIDENT';
v_president_salary  NUMBER;
employee_salary_reduced50 NUMBER;
employee_salary_reduced25 NUMBER;
v_avg_salary NUMBER;
min_employee_salary        NUMBER:= 100;
v_increased_sal_10 NUMBER;
commission_threshold CONSTANT NUMBER(5,2) := 0.22;
v_lowest_comm NUMBER;




-- Cursor to loop through employees
    CURSOR cursor_emp IS 
        SELECT *
        FROM emp;

    record_emp emp%ROWTYPE;


BEGIN

-- Get the president's salary
    SELECT sal
    INTO v_president_salary
    FROM emp
    WHERE job = c_president_job;


    -- Get the average salary
    SELECT ROUND(AVG(sal), 2)
    INTO v_avg_salary
    FROM emp;

    -- Print the average salary
    DBMS_OUTPUT.PUT_LINE('Average salary is $' || v_avg_salary);

--Loop through employees
     FOR record_emp IN cursor_emp LOOP
     employee_salary := record_emp.sal;

     -- Get the lowest commission for the current department
        SELECT MIN(comm)
        INTO v_lowest_comm
        FROM emp
        WHERE deptno = record_emp.deptno
        AND comm > 0;
        
        -- Print the lowest commission for the current department
        DBMS_OUTPUT.PUT_LINE('Lowest commission for department ' || record_emp.deptno || ' is ' || v_lowest_comm);



        IF(employee_salary > v_president_salary) THEN
            --DECREASE SALARY 50%
            employee_salary_reduced50 := (employee_salary * 0.5);

            --DECREASE SALARY WITH THE 25% OF THE PRESIDENTS SALARY
            employee_salary_reduced25 := employee_salary - (v_president_salary * 0.25);

            IF(employee_salary_reduced25 > employee_salary_reduced50) THEN
            employee_salary := employee_salary_reduced50;
            ELSE
                employee_salary := employee_salary_reduced25;
            --testing
            
            DBMS_OUTPUT.PUT_LINE('employee_salary ' || employee_salary);
            END IF;
            
            UPDATE EMP
            SET SAL = employee_salary
            WHERE ENAME = record_emp.ENAME;

        END IF;

    --EMPLOYEE SALARY INCREASED 10%
    v_increased_sal_10 := employee_salary + (employee_salary * 0.10);
                -- Rule 2: Increase employee's salary if needed
        -- If an employee makes less than $100, their salary should be increased by 10%,
        -- but only if the original average salary for the entire company
        -- (including the president’s) is still more than their new raised salary
        IF(employee_salary < min_employee_salary) AND (v_avg_salary > v_increased_sal_10) THEN
            employee_salary := v_increased_sal_10;
            END IF;
            DBMS_OUTPUT.PUT_LINE('v_increased_sal_10 ' || employee_salary);

         -- Rule 3: Adjust commission
        IF record_emp.comm > (record_emp.sal * commission_threshold)THEN
                IF v_lowest_comm IS NOT NULL THEN
                    -- Update the commission for the current employee in the database
                    UPDATE emp SET comm = v_lowest_comm WHERE empno = record_emp.empno;
                END IF;
            END IF;



    END LOOP;

COMMIT;



END;
/
