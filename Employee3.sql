
SELECT 
    emp_id,
    name,
    department,
    salary,
    LAG(salary) OVER (PARTITION BY department ORDER BY salary) as prev_salary,
    LEAD(salary) OVER (PARTITION BY department ORDER BY salary) as next_salary,
    CASE 
        WHEN LAG(salary) OVER (PARTITION BY department ORDER BY salary) IS NULL THEN 'FIRST RECORD'
        WHEN salary > LAG(salary) OVER (PARTITION BY department ORDER BY salary) THEN 'HIGHER'
        WHEN salary < LAG(salary) OVER (PARTITION BY department ORDER BY salary) THEN 'LOWER'
        ELSE 'EQUAL'
    END as comparison_with_prev
FROM employees
ORDER BY department, salary;