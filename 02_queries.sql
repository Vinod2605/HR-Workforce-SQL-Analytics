-- ============================================================================
-- FILE 2 OF 2: Analysis queries (MySQL)
-- Run 01_schema_and_data.sql first, then run these queries one by one.
-- Skills: INNER/LEFT/RIGHT/FULL OUTER JOINs, subqueries, GROUP BY, CASE
-- ============================================================================
USE HR;

-- ----------------------------------------------------------------------------
-- 3. CORE MULTI-TABLE JOIN QUERIES
-- ----------------------------------------------------------------------------

-- Q1: Employee Onboarding & Tenure Tracking (Department 5)
-- Uses INNER JOIN to retrieve employee names and start dates for Department 5.
SELECT 
    E.EMP_ID,
    CONCAT(E.F_NAME, ' ', E.L_NAME) AS FULL_NAME,
    JH.START_DATE
FROM EMPLOYEES AS E
INNER JOIN JOB_HISTORY AS JH 
    ON E.EMP_ID = JH.EMPL_ID
WHERE E.DEP_ID = '5';

-- Q2: Role & Tenure Mapping Across 3 Tables
-- Chains INNER JOINs across EMPLOYEES, JOB_HISTORY, and JOBS.
SELECT 
    E.EMP_ID,
    E.F_NAME,
    E.L_NAME,
    JH.START_DATE,
    J.JOB_TITLE
FROM EMPLOYEES AS E
INNER JOIN JOB_HISTORY AS JH 
    ON E.EMP_ID = JH.EMPL_ID
INNER JOIN JOBS AS J 
    ON E.JOB_ID = J.JOB_IDENT
WHERE E.DEP_ID = '5';

-- Q3: Complete Roster & Department Allocation Audit
-- Uses LEFT OUTER JOIN to retain all employees even if unassigned to a department.
SELECT 
    E.EMP_ID,
    E.L_NAME,
    E.DEP_ID,
    D.DEP_NAME
FROM EMPLOYEES AS E
LEFT OUTER JOIN DEPARTMENTS AS D 
    ON E.DEP_ID = D.DEPT_ID_DEP;

-- Q4: Senior Workforce Cohort Analysis (Born Before 1980)
-- Filters join condition in the ON clause to preserve all employees while surfacing
-- department names only for employees born before 1980.
SELECT 
    E.EMP_ID,
    E.L_NAME,
    E.B_DATE,
    E.DEP_ID,
    D.DEP_NAME
FROM EMPLOYEES AS E
LEFT OUTER JOIN DEPARTMENTS AS D 
    ON E.DEP_ID = D.DEPT_ID_DEP
    AND YEAR(E.B_DATE) < 1980;

-- Q5: Enterprise-Wide Employee & Department Coverage (FULL OUTER JOIN in MySQL)
-- Combines LEFT and RIGHT OUTER JOINs via UNION to identify both unassigned
-- employees and vacant departments (e.g., Department 9 - Data Analytics).
SELECT 
    E.F_NAME,
    E.L_NAME,
    D.DEP_NAME
FROM EMPLOYEES AS E
LEFT OUTER JOIN DEPARTMENTS AS D 
    ON E.DEP_ID = D.DEPT_ID_DEP

UNION

SELECT 
    E.F_NAME,
    E.L_NAME,
    D.DEP_NAME
FROM EMPLOYEES AS E
RIGHT OUTER JOIN DEPARTMENTS AS D 
    ON E.DEP_ID = D.DEPT_ID_DEP;

-- Q6: Gender-Segmented Department Mapping (Full Outer Join with Conditional ON)
SELECT 
    E.F_NAME,
    E.L_NAME,
    D.DEPT_ID_DEP,
    D.DEP_NAME
FROM EMPLOYEES AS E
LEFT OUTER JOIN DEPARTMENTS AS D 
    ON E.DEP_ID = D.DEPT_ID_DEP 
    AND E.SEX = 'M'

UNION

SELECT 
    E.F_NAME,
    E.L_NAME,
    D.DEPT_ID_DEP,
    D.DEP_NAME
FROM EMPLOYEES AS E
RIGHT OUTER JOIN DEPARTMENTS AS D 
    ON E.DEP_ID = D.DEPT_ID_DEP 
    AND E.SEX = 'M';

-- ----------------------------------------------------------------------------
-- 4. EXTENDED ANALYTICAL QUERIES (Aggregations, Subqueries & Salary Benchmarking)
-- ----------------------------------------------------------------------------

-- Q7: Departmental Headcount & Compensation Summary
SELECT 
    D.DEPT_ID_DEP,
    D.DEP_NAME,
    COUNT(E.EMP_ID) AS HEADCOUNT,
    ROUND(AVG(E.SALARY), 2) AS AVG_SALARY,
    MAX(E.SALARY) AS MAX_SALARY
FROM DEPARTMENTS AS D
LEFT JOIN EMPLOYEES AS E 
    ON D.DEPT_ID_DEP = E.DEP_ID
GROUP BY D.DEPT_ID_DEP, D.DEP_NAME
ORDER BY AVG_SALARY DESC;

-- Q8: Above-Average Earners Benchmarking (Subquery + JOIN)
SELECT 
    E.EMP_ID,
    CONCAT(E.F_NAME, ' ', E.L_NAME) AS EMPLOYEE_NAME,
    D.DEP_NAME,
    J.JOB_TITLE,
    E.SALARY
FROM EMPLOYEES AS E
INNER JOIN DEPARTMENTS AS D 
    ON E.DEP_ID = D.DEPT_ID_DEP
INNER JOIN JOBS AS J 
    ON E.JOB_ID = J.JOB_IDENT
WHERE E.SALARY > (SELECT AVG(SALARY) FROM EMPLOYEES)
ORDER BY E.SALARY DESC;

-- Q9: Salary Band Audit (find employees paid outside their job's salary range)
-- Compares each salary with MIN_SALARY and MAX_SALARY of the employee's job.
SELECT
    E.EMP_ID,
    CONCAT(E.F_NAME, ' ', E.L_NAME) AS EMPLOYEE_NAME,
    J.JOB_TITLE,
    E.SALARY,
    J.MIN_SALARY,
    J.MAX_SALARY,
    CASE
        WHEN E.SALARY > J.MAX_SALARY THEN 'Above maximum'
        WHEN E.SALARY < J.MIN_SALARY THEN 'Below minimum'
    END AS BAND_STATUS
FROM EMPLOYEES AS E
INNER JOIN JOBS AS J
    ON E.JOB_ID = J.JOB_IDENT
WHERE E.SALARY > J.MAX_SALARY
   OR E.SALARY < J.MIN_SALARY
ORDER BY E.SALARY DESC;
