# Thequeywizards
# SQL Window Functions Exploration

Team Members:
- Mucyo Joel 26606
- Gatashya Hugo Valois 26512

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
- Salary progression within departments
- Unusually large gaps between salaries
- Clustering of similar salaries
## Real-World Application
- Identifying salary compression issues
- Detecting potential equity problems in compensation
- Planning for salary adjustments and promotions
### Query 2:Ranking within Categories (RANK and DENSE_RANK)
#### Business Problem
Rank employees within each department based on their salaries to understand compensation hierarchy.
#### SQL Query
```sql
SELECT 
    emp_id,
    name,
    department,
    salary,
    RANK() OVER (PARTITION BY department ORDER BY salary DESC) as salary_rank,
    DENSE_RANK() OVER (PARTITION BY department ORDER BY salary DESC) as salary_dense_rank
FROM employees
ORDER BY department, salary DESC;
```
## Explanation
This query demonstrates two ranking functions:
- RANK() assigns a unique rank to each distinct value, with gaps in sequence for ties
- DENSE_RANK() assigns a unique rank to each distinct value without gaps
- If two employees have the same salary, RANK() will skip the next rank, while DENSE_RANK() won't
- Example: If two employees both rank 2, the next employee would be rank 4 with RANK() but rank 3 with DENSE_RANK()
  ## Real-World Application
- Compensation analysis and planning
- Performance evaluations
- Identifying top performers across different departments
  
### Query 3:Top Records Identification
#### Business Problem
Identify the top 3 highest-paid employees in each department for bonus distribution.
#### SQL Query
```sql
WITH RankedEmployees AS (
    SELECT 
        emp_id,
        name,
        department,
        salary,
        DENSE_RANK() OVER (PARTITION BY department ORDER BY salary DESC) as salary_rank
    FROM employees
)
SELECT 
    emp_id,
    name,
    department,
    salary,
    salary_rank
FROM RankedEmployees
WHERE salary_rank <= 3
ORDER BY department, salary_rank;
```
## Explanation
This query:
- Uses a Common Table Expression (CTE) to first rank all employees
- DENSE_RANK ensures duplicate salaries get the same rank
- The outer query filters to keep only the top 3 ranks
- This approach handles ties correctly (could have more than 3 employees if there are ties)
  ## Real-World Application
- Bonus distribution planning
- Talent retention strategies
- Succession planning
  
### Query 4:Earliest Records (First Hires)
#### Business Problem
Identify the first 2 employees hired in each department to recognize tenure and experience.
#### SQL Query
```sql

WITH HireRankedEmployees AS (
    SELECT 
        emp_id,
        name,
        department,
        salary,
        hire_date,
        ROW_NUMBER() OVER (PARTITION BY department ORDER BY hire_date) as hire_rank
    FROM employees
)
SELECT 
    emp_id,
    name,
    department,
    hire_date,
    hire_rank
FROM HireRankedEmployees
WHERE hire_rank <= 2
ORDER BY department, hire_rank;
```
## Explanation
This query:

- Uses ROW_NUMBER() to assign a sequential number to each employee based on hire date
- PARTITION BY department ensures numbering restarts for each department
- ORDER BY hire_date means the earliest hired get the lowest numbers
- Filtering WHERE hire_rank <= 2 keeps only the first two employees hired in each department
   ## Real-World Application
- Recognition of long-tenured employees
- Historical knowledge preservation
- Understanding departmental growth patterns 
### Query 5:Aggregation with Window Functions
#### Business Problem
Compare individual salaries against departmental and company-wide benchmarks.
#### SQL Query
```sql
SELECT 
    emp_id,
    name,
    department,
    salary,
    MAX(salary) OVER (PARTITION BY department) as dept_max_salary,
    MAX(salary) OVER () as overall_max_salary
FROM employees
ORDER BY department, salary DESC;
```
## Explanation
This query:
- MAX(salary) OVER (PARTITION BY department) calculates the maximum salary within each department
- MAX(salary) OVER () calculates the maximum salary across all departments
- Each row shows the employee's own salary, their department's maximum, and the overall maximum
- This allows for easy comparison of individual performance against departmental and company-wide metrics
## Real-World Application
Real-World Application
- Compensation equity analysis
- Budget planning across departments
- Identifying departments with competitive/non-competitive salaries
## Conclusion
This project demonstrates the power and flexibility of SQL window functions for data analysis. These functions provide significant advantages:

- Efficiency: Window functions eliminate the need for complex self-joins or subqueries
- Readability: Queries become more concise and easier to understand
- Performance: Window functions are optimized by database engines for better performance
- Flexibility: They can handle a wide range of analytical scenarios

By implementing these queries, we've shown how window functions can solve real business problems in human resources and finance domains.



