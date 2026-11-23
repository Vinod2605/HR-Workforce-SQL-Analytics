-- ============================================================================
-- FILE 1 OF 2: Schema and sample data (MySQL)
-- Run this file first. It creates the HR database, 5 tables and inserts
-- the sample records (10 employees, 4 departments, 6 jobs).
-- ============================================================================

-- ----------------------------------------------------------------------------
-- 1. SCHEMA & DATABASE SETUP
-- ----------------------------------------------------------------------------
CREATE DATABASE IF NOT EXISTS HR;
USE HR;

DROP TABLE IF EXISTS JOB_HISTORY;
DROP TABLE IF EXISTS EMPLOYEES;
DROP TABLE IF EXISTS JOBS;
DROP TABLE IF EXISTS DEPARTMENTS;
DROP TABLE IF EXISTS LOCATIONS;

CREATE TABLE DEPARTMENTS (
    DEPT_ID_DEP CHAR(9) NOT NULL PRIMARY KEY,
    DEP_NAME VARCHAR(30),
    MANAGER_ID CHAR(9),
    LOC_ID CHAR(9)
);

CREATE TABLE JOBS (
    JOB_IDENT CHAR(9) NOT NULL PRIMARY KEY,
    JOB_TITLE VARCHAR(30),
    MIN_SALARY DECIMAL(10, 2),
    MAX_SALARY DECIMAL(10, 2)
);

CREATE TABLE LOCATIONS (
    LOCT_ID CHAR(9) NOT NULL,
    DEP_ID_LOC CHAR(9) NOT NULL,
    PRIMARY KEY (LOCT_ID, DEP_ID_LOC)
);

CREATE TABLE EMPLOYEES (
    EMP_ID CHAR(9) NOT NULL PRIMARY KEY,
    F_NAME VARCHAR(15) NOT NULL,
    L_NAME VARCHAR(15) NOT NULL,
    SSN CHAR(9),
    B_DATE DATE,
    SEX CHAR(1),
    ADDRESS VARCHAR(30),
    JOB_ID CHAR(9),
    SALARY DECIMAL(10, 2),
    MANAGER_ID CHAR(9),
    DEP_ID CHAR(9) NOT NULL
);

CREATE TABLE JOB_HISTORY (
    EMPL_ID CHAR(9) NOT NULL,
    START_DATE DATE,
    JOBS_ID CHAR(9) NOT NULL,
    DEPT_ID CHAR(9),
    PRIMARY KEY (EMPL_ID, JOBS_ID)
);

-- ----------------------------------------------------------------------------
-- 2. SAMPLE DATA INGESTION (Representative HR Records)
-- ----------------------------------------------------------------------------
INSERT INTO DEPARTMENTS VALUES
('2', 'Architect Group', '30001', 'L0001'),
('5', 'Software Group', '30002', 'L0002'),
('7', 'Design Team', '30003', 'L0003'),
('9', 'Data Analytics', '30004', 'L0004');

INSERT INTO JOBS VALUES
('100', 'Sr. Architect', 60000, 100000),
('200', 'Sr. Software Developer', 60000, 80000),
('300', 'Jr. Software Developer', 40000, 60000),
('400', 'Jr. Designer', 35000, 50000),
('500', 'Sr. Designer', 60000, 90000),
('600', 'Data Analyst', 55000, 85000);

INSERT INTO LOCATIONS VALUES
('L0001', '2'),
('L0002', '5'),
('L0003', '7'),
('L0004', '9');

INSERT INTO EMPLOYEES VALUES
('E1001', 'John', 'Thomas', '123456', '1976-01-09', 'M', '5631 Rice, OakPark,IL', '100', 100000, '30001', '2'),
('E1002', 'Alice', 'James', '123457', '1972-07-31', 'F', '980 Berry ln, Elgin,IL', '200', 80000, '30002', '5'),
('E1003', 'Steve', 'Wells', '123458', '1980-08-10', 'M', '291 Springs, Gary,IL', '300', 50000, '30002', '5'),
('E1004', 'Santosh', 'Kumar', '123459', '1985-07-20', 'M', '511 Aurora Av, Aurora,IL', '400', 60000, '30004', '5'),
('E1005', 'Ahmed', 'Hussain', '123410', '1981-01-04', 'M', '216 Oak Tree, Geneva,IL', '500', 70000, '30001', '2'),
('E1006', 'Nancy', 'Allen', '123411', '1978-02-06', 'F', '111 Green Pl, Elgin,IL', '600', 90000, '30001', '2'),
('E1007', 'Mary', 'Thomas', '123412', '1975-05-05', 'F', '100 Rose Pl, Gary,IL', '600', 65000, '30003', '7'),
('E1008', 'Bharath', 'Gupta', '123413', '1985-05-06', 'M', '145 Berry Ln, Naperville,IL', '600', 65000, '30003', '7'),
('E1009', 'Andrea', 'Jones', '123414', '1990-07-09', 'F', '120 Fall Creek, Gary,IL', '200', 70000, '30003', '7'),
('E1010', 'Ann', 'Jacob', '123415', '1982-11-30', 'F', '111 Britany Springs,Elgin,IL', '200', 70000, '30004', '5');

INSERT INTO JOB_HISTORY VALUES
('E1001', '2000-08-01', '100', '2'),
('E1002', '2001-08-01', '200', '5'),
('E1003', '2001-08-16', '300', '5'),
('E1004', '2000-08-16', '400', '5'),
('E1005', '2000-05-30', '500', '2'),
('E1006', '2001-08-16', '600', '2'),
('E1007', '2002-05-30', '600', '7'),
('E1008', '2010-05-06', '600', '7'),
('E1009', '2016-08-16', '200', '7'),
('E1010', '2016-08-16', '200', '5');
