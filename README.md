# Thequeywizards
# SQL Window Functions Exploration

Team Members:
- Mucyo Joel 26606
- Gatashya Hugo Valois 

## Project Overview
This project explores SQL Window Functions through practical examples. Window functions allow for complex analytical queries that would otherwise require multiple self-joins or subqueries. These functions perform calculations across a set of rows related to the current row, providing powerful analytical capabilities.

## Dataset Description
We're using an Employee dataset with the following structure:
- `emp_id`: Employee ID (Primary Key)
- `name`: Employee name
- `department`: Department (IT, HR, Finance, Marketing)
- `salary`: Annual salary
- `hire_date`: Date of hire

## Query Implementations

### Query 1: Comparison with Previous and Next Records (LAG and LEAD)
#### Business Problem
Compare each employee's salary with others in their department to identify salary progression and anomalies.

#### SQL Query
```sql
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
