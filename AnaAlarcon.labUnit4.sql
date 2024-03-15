/********************************************
*      Lab 7                                *
*      Exceptions                           *
*                                           *
*      Author: Ana Joselyn Alarcon          *
*      Date: October 27th, 2023              *
********************************************/


-- -- Lab: Write a Valid Code Solution with Different Data Types

/*Rule 1: If an employee’s salary is higher than the president’s,
that employee’s salary should be reduced to 25% less than the president’s salary. 
For example, if the president’s salary is $5,000 and the employee’s salary is $6,000, 
the employee’s new salary will be $3,750.  */

SET SERVEROUTPUT ON 

DECLARE
  -- Declaration section
    sal_employee_decrease NUMBER(1,2):= 0.25;
    president               emp.job%TYPE := 'PRESIDENT';    
    employee_sal            emp.sal%TYPE;
    president_sal           emp.sal%TYPE;
    
BEGIN
  -- Executable section
UPDATE EMP
    SET sal = sal - (president_sal * sal_employee_decrease)
    WHERE employee_sal > president_sal;

DBMS_OUTPUT.PUT_LINE('Employee new salary is: ' || employee_sal);

COMMIT;

END;
/


-- •	Rule 2: If an employee’s salary is less than $100, 
--their salary should be increased by 10%, 
--but only if the average salary for the entire company (including the president)
-- is still more than their newly raised salary. (5 marks)
-- Note:	When calculating the company’s average salary, do this after the salary changes are made from Rule 1.


DECLARE
    -- Declaration section
        sal_employee_adjustment NUMBER(1,2):= 0.10;   
        employee_sal            emp.sal%TYPE;
        president_sal           emp.sal%TYPE;
        avg_sal                 NUMBER;
        increased_sal           NUMBER:= sal + (employee_sal * sal_employee_adjustment);


BEGIN
--GET THE AVERAGE SALARY
SELECT AVG(sal)
    INTO avg_sal
    FROM emp;


UPDATE EMP
    SET sal = increased_sal
    WHERE (employee_sal < 100) AND (avg_sal > increased_sal);

DBMS_OUTPUT.PUT_LINE('Employee new salary is: ' || employee_sal);

COMMIT;

END;
/

