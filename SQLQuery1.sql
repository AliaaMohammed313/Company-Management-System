-- =====================================================
-- CREATE DATABASE
-- =====================================================

CREATE DATABASE EmployeeManagementSDB;

USE EmployeeManagementSDB;

-- =====================================================
-- Department Table
-- =====================================================

CREATE TABLE Department (
    Dep_id INT PRIMARY KEY,
    Dep_name VARCHAR(100) NOT NULL,
    Location VARCHAR(100)
);

INSERT INTO Department VALUES
(1, 'HR', 'Cairo'),
(2, 'IT', 'Giza'),
(3, 'Finance', 'Alex');

-- =====================================================
-- Employee Table
-- =====================================================

CREATE TABLE Employee (
    Emp_id INT PRIMARY KEY,
    First_n VARCHAR(50) NOT NULL,
    Second_n VARCHAR(50) NOT NULL,
    Email VARCHAR(100) UNIQUE NOT NULL,
    Gender VARCHAR(10)
    CHECK (Gender IN ('Male', 'Female')),
    Hire_date DATE,
    Dep_id INT,

    FOREIGN KEY (Dep_id)
    REFERENCES Department(Dep_id)
);

INSERT INTO Employee VALUES
(101, 'Mai', 'Salah', 'mai@gmail.com',
'Female', '2026-01-10', 2),

(102, 'Ahmed', 'Ali', 'ahmed@gmail.com',
'Male', '2025-11-15', 1),

(103, 'Nour', 'Samy', 'nour@gmail.com',
'Female', '2026-02-01', 3);

-- =====================================================
-- Employee Phone Table
-- =====================================================

CREATE TABLE Emp_phone (
    Emp_id INT,
    Phone_num VARCHAR(20),

    PRIMARY KEY (Emp_id, Phone_num),

    FOREIGN KEY (Emp_id)
    REFERENCES Employee(Emp_id)
);

INSERT INTO Emp_phone VALUES
(101, '01011111111'),
(101, '01122222222'),
(102, '01233333333');

-- =====================================================
-- Attendance Table
-- =====================================================

CREATE TABLE Attendance (
    Attend_id INT PRIMARY KEY,
    Check_in TIME,
    Check_out TIME,
    ATT_date DATE,
    Emp_id INT,

    FOREIGN KEY (Emp_id)
    REFERENCES Employee(Emp_id)
);

INSERT INTO Attendance VALUES
(1, '08:00:00', '16:00:00',
'2026-05-10', 101),

(2, '09:00:00', '17:00:00',
'2026-05-10', 102);

-- =====================================================
-- Training Table
-- =====================================================

CREATE TABLE Training (
    Tran_id INT PRIMARY KEY,
    Tran_name VARCHAR(100),
    Start_date DATE,
    End_date DATE,
    Cost DECIMAL(10,2)
);

INSERT INTO Training VALUES
(1, 'Python', '2026-03-01',
'2026-03-15', 3000),

(2, 'Networking', '2026-04-01',
'2026-04-20', 4500);

-- =====================================================
-- Employee Training Table
-- =====================================================

CREATE TABLE Emp_Tran (
    Emp_id INT,
    Tran_id INT,

    PRIMARY KEY (Emp_id, Tran_id),

    FOREIGN KEY (Emp_id)
    REFERENCES Employee(Emp_id),

    FOREIGN KEY (Tran_id)
    REFERENCES Training(Tran_id)
);

INSERT INTO Emp_Tran VALUES
(101, 1),
(102, 2);

-- =====================================================
-- Contract Table
-- =====================================================

CREATE TABLE Contract (
    Contract_id INT PRIMARY KEY,
    Contract_type VARCHAR(50),
    Start_date DATE,
    End_date DATE,
    Salary DECIMAL(10,2),
    Status VARCHAR(50),
    Emp_id INT,

    FOREIGN KEY (Emp_id)
    REFERENCES Employee(Emp_id)
);

INSERT INTO Contract VALUES
(1, 'Full Time', '2026-01-01',
'2027-01-01', 12000,
'Active', 101),

(2, 'Part Time', '2025-11-01',
'2026-11-01', 7000,
'Active', 102);

-- =====================================================
-- Payroll Table
-- =====================================================

CREATE TABLE Payroll (
    Payroll_id INT PRIMARY KEY,
    Payment_date DATE,
    Deduction DECIMAL(10,2),
    Bonus DECIMAL(10,2),
    Emp_id INT,

    FOREIGN KEY (Emp_id)
    REFERENCES Employee(Emp_id)
);

INSERT INTO Payroll VALUES
(1, '2026-05-01', 500, 1000, 101),

(2, '2026-05-01', 200, 500, 102);

-- =====================================================
-- Client Table
-- =====================================================

CREATE TABLE Client (
    Client_id INT PRIMARY KEY,
    Client_name VARCHAR(100),
    Email VARCHAR(100),
    Address VARCHAR(200)
);

INSERT INTO Client VALUES
(1, 'ABC Company',
'abc@gmail.com', 'Nasr City'),

(2, 'Tech Corp',
'tech@gmail.com', 'Dokki');

-- =====================================================
-- Client Phone Table
-- =====================================================

CREATE TABLE Client_phone (
    Client_id INT,
    Phone_num VARCHAR(20),

    PRIMARY KEY (Client_id, Phone_num),

    FOREIGN KEY (Client_id)
    REFERENCES Client(Client_id)
);

INSERT INTO Client_phone VALUES
(1, '01555555555'),
(2, '01666666666');

-- =====================================================
-- Project Table
-- =====================================================

CREATE TABLE Project (
    Pro_id INT PRIMARY KEY,
    Pro_name VARCHAR(100),
    Budget DECIMAL(12,2),
    Start_date DATE,
    End_date DATE,
    Client_id INT,

    FOREIGN KEY (Client_id)
    REFERENCES Client(Client_id)
);

INSERT INTO Project VALUES
(1, 'System Project', 50000,
'2026-01-01', '2026-06-01', 1),

(2, 'Network Project', 75000,
'2026-02-01', '2026-07-01', 2);

-- =====================================================
-- Employee Project Table
-- =====================================================

CREATE TABLE Emp_Pro (
    Emp_id INT,
    Pro_id INT,

    PRIMARY KEY (Emp_id, Pro_id),

    FOREIGN KEY (Emp_id)
    REFERENCES Employee(Emp_id),

    FOREIGN KEY (Pro_id)
    REFERENCES Project(Pro_id)
);

INSERT INTO Emp_Pro VALUES
(101, 1),
(102, 2);

-- =====================================================
-- CREATE VIEWS
-- =====================================================
GO
CREATE VIEW Employee_View AS
SELECT * FROM Employee;
GO
CREATE VIEW Department_View AS
SELECT * FROM Department;
GO
CREATE VIEW Payroll_View AS
SELECT * FROM Payroll;
GO
CREATE VIEW Project_View AS
SELECT * FROM Project;
GO
-- =====================================================
-- Net Salary View
-- =====================================================
GO
CREATE VIEW NetSalary_View AS

SELECT
    Employee.Emp_id,
    Employee.First_n,
    Contract.Salary,
    Payroll.Bonus,
    Payroll.Deduction,

    (Contract.Salary +
     Payroll.Bonus -
     Payroll.Deduction)

     AS Net_Salary

FROM Employee

JOIN Contract
ON Employee.Emp_id = Contract.Emp_id

JOIN Payroll
ON Employee.Emp_id = Payroll.Emp_id;

-- =====================================================
-- Employee Department View
-- =====================================================
GO
CREATE VIEW Employee_Department_View AS

SELECT
    Employee.Emp_id,
    Employee.First_n,
    Employee.Second_n,
    Department.Dep_name

FROM Employee

JOIN Department
ON Employee.Dep_id = Department.Dep_id;

-- =====================================================
-- Project Client View
-- =====================================================
GO
CREATE VIEW Project_Client_View AS

SELECT
    Project.Pro_name,
    Project.Budget,
    Client.Client_name

FROM Project

JOIN Client
ON Project.Client_id = Client.Client_id;
GO
-- =====================================================
-- UPDATE EXAMPLES
-- =====================================================

UPDATE Contract
SET Salary = 15000
WHERE Emp_id = 101;

UPDATE Payroll
SET Bonus = 2000
WHERE Emp_id = 101;

-- =====================================================
-- DELETE EXAMPLE
-- =====================================================

DELETE FROM Emp_Pro
WHERE Emp_id = 101
AND Pro_id = 1;

-- =====================================================
-- AGGREGATE FUNCTIONS
-- =====================================================

SELECT AVG(Salary) AS Average_Salary
FROM Contract;

SELECT COUNT(*) AS Number_Of_Employees
FROM Employee;

SELECT MAX(Salary) AS Highest_Salary
FROM Contract;

SELECT MIN(Salary) AS Lowest_Salary
FROM Contract;

SELECT SUM(Budget) AS Total_Budget
FROM Project;

-- =====================================================
-- ORDER BY
-- =====================================================

SELECT *
FROM Employee
ORDER BY First_n ASC;

-- =====================================================
-- GROUP BY
-- =====================================================

SELECT
    Dep_id,
    COUNT(Emp_id) AS Employee_Count

FROM Employee

GROUP BY Dep_id;