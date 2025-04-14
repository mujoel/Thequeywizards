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
  ### Table Creation and Data Insertion
Below is the SQL script used to create our employees table and populate it with sample data:

```sql
CREATE TABLE employees (
    emp_id INT PRIMARY KEY,
    name VARCHAR(100),
    department VARCHAR(50),
    salary DECIMAL(10,2),
    hire_date DATE
);
INSERT INTO employees VALUES (1, 'John Kwizera', 'IT', 75000, TO_DATE('2020-01-15', 'YYYY-MM-DD'));
INSERT INTO employees VALUES (2, 'Jane Mwiza', 'IT', 85000, TO_DATE('2019-05-20', 'YYYY-MM-DD'));
INSERT INTO employees VALUES (3, 'Robert Mugabe', 'IT', 65000, TO_DATE('2021-03-10', 'YYYY-MM-DD'));
INSERT INTO employees VALUES (4, 'Emily Kwitonda', 'HR', 72000, TO_DATE('2018-11-05', 'YYYY-MM-DD'));
INSERT INTO employees VALUES (5, 'Michael Manzi', 'HR', 69000, TO_DATE('2019-08-12', 'YYYY-MM-DD'));
INSERT INTO employees VALUES (6, 'Sarah Ikirezi', 'HR', 78000, TO_DATE('2017-06-23', 'YYYY-MM-DD'));
INSERT INTO employees VALUES (7, 'David Gusenga', 'Finance', 92000, TO_DATE('2019-02-15', 'YYYY-MM-DD'));
INSERT INTO employees VALUES (8, 'Lisa Gahigi', 'Finance', 88000, TO_DATE('2020-07-08', 'YYYY-MM-DD'));
INSERT INTO employees VALUES (9, 'Thomas Ishimwe', 'Finance', 91000, TO_DATE('2018-09-30', 'YYYY-MM-DD'));
INSERT INTO employees VALUES (10, 'Jennifer Iradukunda', 'Marketing', 67000, TO_DATE('2021-01-18', 'YYYY-MM-DD'));
INSERT INTO employees VALUES (11, 'Christopher Imena', 'Marketing', 71000, TO_DATE('2020-04-22', 'YYYY-MM-DD'));
INSERT INTO employees VALUES (12, 'Jessica Keza', 'Marketing', 67000, TO_DATE('2019-10-14', 'YYYY-MM-DD'));

```

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
```
## Explanation
This query uses LAG() and LEAD() functions to compare each employee's salary with the previous and next highest salary in their department. 
It helps identify:
-Salary progression within departments
-Unusually large gaps between salaries
-Clustering of similar salaries
