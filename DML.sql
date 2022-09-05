/*
*
* SQL Project:Bank Database Management
* Project By: Aunju Moni
* Batch ID: ESAD_CS/PNTL-M/49/01
* Trainee ID:1267617
*
*/
USE BankDatabase_Management
GO
----VIEW FROM DEPARTMENT WISE SALARY
CREATE VIEW vw_DeptWiseSalaryAmount
AS
  SELECT dep.D_Name[Dept Name],SUM(D.SalaryAmount)[Basic Salary] FROM Employee e
  JOIN DesignationDetails D ON D.designation_ID=e.designation_ID
  JOIN Department dep ON dep.department_ID=D.department_ID
  LEFT JOIN EmployeeLeaveType el ON el.employee_ID=e.employee_ID
  GROUP BY dep.D_Name WITH ROLLUP
 GO
 ---TEST
 SELECT * FROM vw_DeptWiseSalaryAmount
 GO
/* 
 *CREATE NONCLUSTERED INDEX 
 */

 CREATE NONCLUSTERED INDEX NCI_CustomerID
 ON Customer(C_ID)
 GO
 ----TEST
 EXEC sp_helpindex Customer
 ---JOINQUERY
 SELECT C.C_ID,C.F_name,C.L_name,AD.Acnumber,LD.loanID,SUM(P.amount)'Amount' FROM Customer C
 JOIN AccountDetails AD ON C.C_ID=AD.C_ID
 JOIN LoanDetails LD ON AD.C_ID=LD.C_ID
 JOIN Payment P ON LD.loanID=P.loanID
 GROUP BY C.C_ID,C.F_name,C.L_name,P.P_ID,AD.Acnumber,LD.loanID
 HAVING SUM(P.amount)>=15000 
 GO
 ----SUBQUERY(DISTINCT)
 SELECT C.C_ID,
 (
   select DISTINCT COUNT(td.transactionamount) from AccountDetails ac
   INNER JOIN TransactionDetails td ON ac.Acnumber=td.Acnumber
   WHERE C.C_ID=ac.C_ID
 ) AS 'Total Tranamount'
 FROM Customer C
 GO
 ----CTE(USE GROUP BY,HAVING)
 SELECT C.C_ID,C.F_name,C.L_name,AD.Acnumber,LD.loanID,SUM(P.amount)'Amount' FROM Customer C
 JOIN AccountDetails AD ON C.C_ID=AD.C_ID
 JOIN LoanDetails LD ON AD.C_ID=LD.C_ID
 JOIN Payment P ON LD.loanID=P.loanID
  GROUP BY C.C_ID,C.F_name,C.L_name,P.P_ID,AD.Acnumber,LD.loanID
 HAVING SUM(P.amount)>=15000 
 GO

 WITH Customerloandetailsinfo
 AS
 (
  SELECT C.C_ID,C.F_name,C.L_name,AD.Acnumber,LD.loanID,SUM(P.amount)'Amount' FROM Customer C
 JOIN AccountDetails AD ON C.C_ID=AD.C_ID
 JOIN LoanDetails LD ON AD.C_ID=LD.C_ID
 JOIN Payment P ON LD.loanID=P.loanID
  GROUP BY C.C_ID,C.F_name,C.L_name,P.P_ID,AD.Acnumber,LD.loanID
 HAVING SUM(P.amount)>=15000 
 )
 SELECT * FROM  Customerloandetailsinfo
 ORDER BY  C_ID,F_name,loanID
 GO
 -----------TESTING INSERT DATA VALUE
 SELECT * FROM Status_t
 SELECT * FROM Gender 
 SELECT * FROM Branch
 SELECT * FROM Department
 SELECT * FROM Product_Service
 SELECT * FROM Customer
SELECT * FROM AccountDetails
SELECT * FROM TransactionDetails
SELECT * FROM LoanDetails
GO
------STORED PROCEDURE TESTING
SELECT * FROM DesignationDetails
SELECT * FROM LeaveType
SELECT * FROM EmployeeStatus
SELECT * FROM Employee
SELECT * FROM EmployeeLeaveType
GO
-----TESTING FUNCTION
fn_calcEmployeesalarywith10PercentBonus
-->CREATE FUNCTION FOR Employee salary Calculation and Add 10% Bonus with salary if no leave over the month
SELECT * FROM fn_calcEmployeesalarywith10PercentBonus
GO
fn_transactiondetailsdateCount
-->CREATE FUNCTION  FOR transactiondetails date count (Scalar Function)
SELECT * FROM fn_transactiondetailsdateCount
GO
 fn_empremainingleavedays
 -->CREATE FUNTION for find out remaining leave days for employee
SELECT * FROM  fn_empremainingleavedays
GO
-----TOP CLAUSE
SELECT TOP 5
C.C_ID,C.F_name
FROM Customer C
JOIN AccountDetails AD ON C.C_ID=AD.C_ID
GO
-----USE SELECT INTO 
SELECT C_ID,F_name INTO Customercopy FROM Customer
GO
/* TEST*/
SELECT * FROM Customercopy
GO
-----UPDATE
UPDATE Customercopy SET F_name='MONI' WHERE C_ID='C00001'
GO
SELECT * FROM Customercopy
GO
----DELETE 
DELETE FROM Customercopy WHERE C_ID='C00001'
GO
SELECT * FROM Customercopy
GO
 ---===SELECT STATEMENT(1)
  SELECT CAST('01-June-2019 10:00AM'AS DATE)'Date'
  GO
 ----CONVERT
  SELECT CONVERT(TIME,'01-June-2019 10:00 AM')'Time'
  GO
  ----OVER
SELECT C_ID, TOTALC_ID=COUNT(*) 
OVER() FROM Customer
GO
----10
-----a---
-----ALL
SELECT F_name FROM Customer
WHERE C_ID=ALL(SELECT F_name FROM AccountDetails WHERE C_ID ='C00001')
GO

----QUESTION QUERY
--Q1: SHOW CUSTOMER WHO LIVES IN DHAKA ALONG WITH CUSTOMERID,F_NAME,L_NAME,OCCUPATION AND ALSO SORT THE RESULT SET BY CUSTOMER F_NAME IN DESCENDING
SELECT C_ID,F_name,L_name,Occupation
FROM Customer
WHERE City = 'Dhaka'
ORDER BY F_name DESC
GO
--Q2:SHOW CUSTOMER INFORMATION FROM CUSTOMER TABLE ONLY FOR THOSE CUSTOMERS WHOSE F_NAME START WITH LETTER 'A' AND 'R'
SELECT * FROM Customer
WHERE F_name LIKE '[A,R]%'
GO
--Q3 SHOW DATE INFORMATION FROM TRANSACTIONDETAILS  TABLE FOR TRANSACTION DEPOSIT  BETWEEN DATE NOVEMBER 05,2021 AND NOVEMBER 20,2021
SELECT tnumber,[date],Acnumber,transaction_type,transactionamount
FROM TransactionDetails
WHERE [date] BETWEEN '11-05-2021' AND '11-20-2021'
GO

-----CUBE
SELECT dep.D_Name[Dept Name],SUM(D.SalaryAmount)[Basic Salary] FROM Employee e
  JOIN DesignationDetails D ON D.designation_ID=e.designation_ID
  JOIN Department dep ON dep.department_ID=D.department_ID
  LEFT JOIN EmployeeLeaveType el ON el.employee_ID=e.employee_ID
  GROUP BY dep.D_Name WITH CUBE
  GO
-----TABLE DETAILS
EXEC sp_help Employee
GO
-----CONSTRAINT DETAILS
EXEC sp_helpconstraint Employee 
GO
-----DATABASE INFORMATION
EXEC sp_helpdb BankDatabase_Management
GO
