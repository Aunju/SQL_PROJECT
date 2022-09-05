/*
*
* SQL Project:Bank Database Management
* Project By: Aunju Moni
* Batch ID: ESAD_CS/PNTL-M/49/01
* Trainee ID:1267617
*
*/
--Creating Object
USE master
GO
DROP DATABASE IF EXISTS BankDatabase_Management
GO
CREATE DATABASE BankDatabase_Management
ON
(
     NAME=Bank_DB_Data,
     FILENAME='C:\Bank_DB_Data.mdf',
     SIZE=100MB,
     MAXSIZE=500MB,
     FILEGROWTH=5%
)
LOG ON
( 
      NAME=Bank_DB_Log,
      FILENAME='C:\Bank_DB_Log.ldf',
      SIZE=50MB,
      MAXSIZE=200MB,
      FILEGROWTH=1MB
)
GO
USE BankDatabase_Management
GO
CREATE TABLE Department
(
    department_ID INT IDENTITY PRIMARY KEY,
    D_Name VARCHAR(20) NOT NULL
)
GO
CREATE TABLE Branch
(
  B_ID VARCHAR(8) PRIMARY KEY,
  B_Name VARCHAR(30) NOT NULL
)
GO
CREATE TABLE Status_t
(
    statusID INT IDENTITY PRIMARY KEY,
    statusName VARCHAR(10)
)
GO
CREATE TABLE Gender
(
   GenderId INT IDENTITY PRIMARY KEY,
   gender VARCHAR(8) NOT NULL,
)
GO
CREATE TABLE LeaveType
(
      leaveId INT IDENTITY PRIMARY KEY,
      leaveTitle VARCHAR(20)
)
GO
CREATE TABLE DesignationDetails
(
     designation_ID INT IDENTITY (100,1) PRIMARY KEY,
     department_ID INT REFERENCES Department( department_ID),
     designationTitle VARCHAR(20) NOT NULL,
     SalaryAmount MONEY
)
GO
CREATE TABLE Employee
(
    employee_ID INT IDENTITY PRIMARY KEY,
    employee_Name VARCHAR(20) NOT NULL,
    GenderId INT REFERENCES Gender (GenderId),
    designation_ID INT REFERENCES DesignationDetails(designation_ID),
    contactNo VARCHAR(20) NOT NULL,
    DOB DATE NOT NULL,
    email VARCHAR(50) NOT NULL,
    address VARCHAR(100) NOT NULL,
    city VARCHAR(16) NOT NULL ,
    country VARCHAR(20) NOT NULL DEFAULT 'Bangladesh'
)
GO
CREATE TABLE Customer
(
   C_ID VARCHAR(20) PRIMARY KEY,
   F_name VARCHAR(30) NOT NULL,
   L_name VARCHAR(20),
   address VARCHAR(50) NOT NULL,
   City VARCHAR(15) NOT NULL,
   MobileNo CHAR(11) UNIQUE NOT NULL CHECK (MobileNo LIKE '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'),
   Occupation VARCHAR(15),
   DOB DATE NOT NULL,
   Country VARCHAR(20) NOT NULL DEFAULT 'Bangladesh'
)
GO
CREATE TABLE AccountDetails 
(
    Acnumber VARCHAR(30),
    C_ID VARCHAR(20),
    B_ID VARCHAR(8),
    opening_balance VARCHAR(10),
    account_opening_date DATE,
    aType VARCHAR(14),
    statusID INT,
    CONSTRAINT
 AccountDetails_Acnumber_pk PRIMARY KEY( Acnumber),
 CONSTRAINT AccountDetails_C_ID_fk FOREIGN KEY ( C_ID) REFERENCES Customer(C_ID), 
 CONSTRAINT AccountDetails_B_ID_fk FOREIGN KEY(B_ID) REFERENCES Branch (B_ID),
 CONSTRAINT AccountDetails_statusID_fk FOREIGN KEY (statusID) REFERENCES Status_t (statusID)
)
GO
CREATE TABLE Product_Service
(
   ps_ID INT PRIMARY KEY,
   ps_NAME VARCHAR(20) NOT NULL
)
GO
---ALTER Operator use
ALTER TABLE Product_Service
DROP COLUMN ps_NAME
GO
ALTER TABLE Product_Service
ADD ps_name VARCHAR(22) NOT NULL
GO
CREATE TABLE TransactionDetails
(
      tnumber VARCHAR(6),
	  Acnumber VARCHAR(30),
	  [date] DATE ,
	  medium_of_transaction VARCHAR(20),
	  transaction_type VARCHAR(20),
	  transactionamount MONEY,
	  CONSTRAINT TransactionDetails_tnumber_pk PRIMARY KEY(tnumber),
	  CONSTRAINT TransactionDetails_Acnumber_fk FOREIGN KEY(Acnumber) REFERENCES AccountDetails(Acnumber)
)
GO
CREATE TABLE LoanDetails
(
      loanID INT ,
      C_ID VARCHAR(20) ,
      B_ID VARCHAR(8) ,
	  outstanding MONEY,
	  CONSTRAINT LoanDetails_loanID_pk PRIMARY KEY(loanID),
	  CONSTRAINT LoanDetails_C_ID_fk FOREIGN KEY ( C_ID) REFERENCES Customer(C_ID), 
      CONSTRAINT LoanDetails_B_ID_fk FOREIGN KEY(B_ID) REFERENCES Branch (B_ID),      
)
GO
CREATE TABLE Payment
(
    P_ID INT IDENTITY PRIMARY KEY,
    paymentDate DATE,
    loanID INT REFERENCES LoanDetails(loanID),
    amount MONEY
)
GO
CREATE TABLE EmployeeStatus
( 
   statusID INT REFERENCES Status_t(statusID),
   employee_ID INT REFERENCES Employee( employee_ID),
   statusDesc VARCHAR(100),
   PRIMARY KEY(statusID,employee_ID)
)
GO 
CREATE TABLE EmployeeLeaveType
(
   empLeaveID INT IDENTITY PRIMARY KEY,
   employee_ID INT REFERENCES Employee(employee_ID),
   leaveId INT REFERENCES LeaveType ( leaveId),
   leaveReason VARCHAR(60) NOT NULL,
   leaveDays INT NOT NULL,
   fromDate DATE NOT NULL CHECK (fromDate>=GETDATE()),
   toDate DATE NOT NULL,
   leaveissueDate DATE DEFAULT GETDATE(),
   CHECK (toDate>fromDate)
)
GO 
-----END OF THE OBJECT CREATION
/*
* INSERT DATA TO STATUS TABLE
*/
INSERT INTO Status_t VALUES
('Active'),
('Terminated'),
('On-hold'),
('Suspended')
GO
/*
* INSERT DATA TO GENDER TABLE
*/
INSERT INTO Gender VALUES
('Male'), 
('Female')
GO
/*
* INSERT DATA TO BRANCH TABLE
*/
INSERT INTO Branch VALUES 
('B001','Ring Road'),
('B002', 'Uttara'),
('B003','Siddirganj'),
('B004','Nawabpur Road'),
('B005','Kawran Bazar'),
('B006','Paltan'),
('B007','Donia'),
('B008','Sonaimuri'),
('B009','New Elephant Road'),
('B010','Shantinagar')
GO
/*
* INSERT DATA TO Department TABLE
*/
INSERT INTO Department VALUES 
('Management Service'),
('HR'),
('Investment'),
('General Banking'),
('Foreign Exchange')
GO
/*
* INSERT DATA TO Product_service TABLE
*/
INSERT INTO Product_Service VALUES
(1,'Bank Account'),
(2,'Debit Cards'),
(3,'Credit Cards'),
(4,'Deposits'),
(5,'Investments'),
(6,'Loans and Mortgage'),
(7,'Insurance')
GO
/*
* INSERT DATA TO Customer TABLE
*/
INSERT INTO Customer VALUES
('C00001','Rayeba','Bushra','Block-C,Road-5,Rampura','Dhaka','01533395636','Service','1995-09-06','Bangladesh'),    
('C00002','Sharif','Mahmud','Basabo','Dhaka','01912119317','Service','1990-06-06','Bangladesh'),
('C00003','Anwara','Begum','1946 Rosulbag,Donia','Dhaka','01790533333','Housewife','1982-02-06','Bangladesh'),
('C00004','Salim','Reza','Mokillah Hajibari,sonaimuri','Noakhali','01800123546','Business','1979-02-02','Bangladesh'),
('C00005','Rahul','gandhi','Siddhirganj','Narayanganj','01953636201','Student','1997-05-04','Bangladesh'),
('C00006','Bashir','Uddin','Segun Bagicha','Dhaka','01834598700','Business','1990-08-12','Bangladesh'),
('C00007','Feroj','Alam','Kawran Bazar','Dhaka','01762509355','Service','1992-9-6','Bangladesh'),
('C00008','Ayat','Rahman','Sonir Akhra','Dhaka','01589867273','Student','1996-12-12','Bangladesh'),    
('C00009','Parul','Das','Chashara main road','Narayanganj','01625659320','Housewife','1985-03-03','Bangladesh'),
('C00010','Amit','Kumer','Zila Porishod','Dhaka','01623555962','Student','1994-06-09','Bangladesh'),
('C00011','Nisha','moni','Sector 3,Uttara','Dhaka','01836925653','Service','1990-12-11','Bangladesh'),
('C00012','Afsana','Rahman','Puran Dhaka','Dhaka','01621952792','Business','1992-01-01','Bangladesh'),
('C00013','Tumpa','Khan','Elephant Road','Dhaka','01695568543','Student','1995-12-05','Bangladesh'),
('C00014','Foysal','Khan','12 Ring Road','Dhaka','01762548953','Business','1989-04-04','Bangladesh'),
('C00015','Arman','Shikder','206,Paltan','Dhaka','01587895911','Service','1988-05-01','Bangladesh')
GO
/*
* INSERT DATA TO ACCOUNTDETAILS TABLE
*/
 INSERT INTO AccountDetails VALUES
('A000001','C00001','B010',1000,'12/12/2018','Saving',1),
('A000002','C00002','B010',2000,'11/12/2019','Saving',1),
('A000003','C00003','B007',2000,'09/01/2020','Saving',1),
('A000004','C00004','B008',1200,'05/04/2017','Current',1),
('A000005','C00005','B003',1000,'06/09/2021','Saving',1),
('A000006','C00006','B006',1000,'10/10/2016','Current',4),
('A000007','C00007','B005',1000,'02/12/2017','Saving',1),
('A000008','C00008','B007',500,'11/09/2018','Saving',2),
('A000009','C00009','B003',1000,'08/12/2019','Saving',1),
('A000010','C00010','B003',1000,'06/06/2015','Saving',1),
('A000011','C00011','B002',1000,'03/07/2020','Saving',1),
('A000012','C00012','B004',3000,'12/05/2021','Saving',1),
('A000013','C00013','B009',1000,'04/04/2014','Saving',1),
('A000014','C00014','B001',1000,'05/01/2021','Current',1),
('A000015','C00015','B006',1000,'12/11/2020','Saving',1)
GO
/*
* INSERT DATA TO TransactionDetails TABLE
*/
INSERT INTO TransactionDetails VALUES
('T00001','A000001','11-01-2021','Cheque','Deposit',2000),
('T00002','A000001','11-02-2021','Cash','Withdrawal',1000),
('T00003','A000002','11-05-2021','Cash','Deposit',2000),
('T00004','A000002','11-12-2021','Cash','Deposit',3000),
('T00005','A000007','11-12-2021','Cash','Deposit',7000),
('T00006','A000007','11-13-2021','Cash','Deposit',9000),
('T00007','A000001','11-15-2021','Cash','Deposit',4000),
('T00008','A000006','11-15-2021','Cheque','Deposit',3000),
('T00009','A000001','11-20-2021','Cash','Withdrawal',9000),
('T00010','A000001','11-21-2021','Cash','Withdrawal',5000),
('T00011','A000006','11-22-2021','Cash','Deposit',7000),
('T00012','A000007','11-25-2021','Cash','Deposit',2000)
GO
/*
* INSERT DATA TO LoanDetails TABLE
*/
INSERT INTO LoanDetails VALUES
(1,'C00002','B010',400000),
(2,'C00006','B006',300000),
(3,'C00011','B002',100000),
(4,'C00015','B006',500000),
(5,'C00001','B010',200000)
GO
/*
*CREATE Stored procedure for INSERTING data into  DesignationDetails TABLE
*/
CREATE PROC sp_insertDesignationDetails
                          @designation_ID INT,
                          @designationTitle VARCHAR(20),
                          @salaryamount MONEY
AS
BEGIN
     INSERT INTO DesignationDetails VALUES(@designation_ID,@designationTitle,@salaryamount)
END
GO
----INSERT DATA
EXEC sp_insertDesignationDetails   1,'Manager',120000   
EXEC sp_insertDesignationDetails   2,'Second Officer',100000   
EXEC sp_insertDesignationDetails   3,'Executive Officer',85000    
EXEC sp_insertDesignationDetails   5,'Officer',78000
EXEC sp_insertDesignationDetails   5,'Junior Officer',60000
EXEC sp_insertDesignationDetails   4,'Assistant Officer',45000
EXEC sp_insertDesignationDetails   4,'Trainee Assistant Officer',30000
GO
/*
* CREATE Stored procedure for DELETING data from DesignationDetails TABLE
*/
CREATE PROC sp_deleteDesignationDetails 
                 @id INT
AS
BEGIN
     DELETE  FROM DesignationDetails 
     WHERE designation_ID=@id
END
GO
/*
*CREATE Stored procedure for INSERTING data into  LeaveType TABLE
*/
CREATE PROC sp_insertLeaveType
              @leaveTitle VARCHAR(20)
AS
BEGIN
       INSERT INTO LeaveType VALUES (@leaveTitle)
END
GO
----INSERT DATA
EXEC sp_insertLeaveType 'Annual leave'
EXEC sp_insertLeaveType 'Casual leave'
EXEC sp_insertLeaveType 'Sick leave'
EXEC sp_insertLeaveType 'Maternity leave'
GO
/*
* CREATE Stored procedure for INSERTING data into Employee TABLE
*/
CREATE PROC sp_insertEmployee
            @emp_name VARCHAR(20),
            @genderID INT,
            @designationID INT,
            @contactNo VARCHAR(20),
            @dob DATE,
            @email VARCHAR(50),
            @address VARCHAR(100),
            @city VARCHAR(16),
            @country VARCHAR(20)
AS
BEGIN
     INSERT INTO Employee VALUES (@emp_name, @genderID,@designationID, @contactNo,@dob,@email,@address,@city,@country)
END
GO
---INSERT DATA
EXEC sp_insertEmployee 'Mahfuzur Rahman',1,100,'01676282602','12-12-1978','mr2@gmail.com','Panthopath,green road','Dhaka','Bangladesh'
EXEC sp_insertEmployee 'Rajon Khan',1,102,'01626252603','01-03-1980','rk@gmail.com','Mohammodpur','Dhaka','Bangladesh'
EXEC sp_insertEmployee 'Shornaly',2,101,'01881570287','01-12-1979','s22@gmail.com','Boddo mondir Basabo','Dhaka','Bangladesh'
EXEC sp_insertEmployee 'Mim',2,103,'01979008341','04-05-1981','m2@gmail.com','Agargaon','Dhaka','Bangladesh'
EXEC sp_insertEmployee 'Awaleen',1,105,'-01823273472','02-06-1982','aw2@gmail.com','Mirpur 10','Dhaka','Bangladesh'
EXEC sp_insertEmployee 'Robiual Hasan',1,104,'01777772426','01-05-1988','rh@gmail.com','Kathal Bagan','Dhaka','Bangladesh'
EXEC sp_insertEmployee 'Sarfaraj Ahammed',1,105,'01835444651','11-11-1990','sa@gmail.com','Panthopath,green road','Dhaka','Bangladesh'
EXEC sp_insertEmployee 'Sharmin',2,102,'01991077665','08-05-1985','s33@gmail.com','Kazipara,Mirpur','Dhaka','Bangladesh'
EXEC sp_insertEmployee 'Shekh Sadi',1,106,'01911307422','02-06-1987','ss@gmail.com','Kolabagan','Dhaka','Bangladesh'
EXEC sp_insertEmployee 'Jannatul Ferdaus',2,106,'0192896907','11-12-1991','jf@gmail.com','Mohammodpur','Dhaka','Bangladesh'
GO
/*
* CREATE Stored procedure for DELETING data from Employee TABLE
*/
CREATE PROC sp_deleteEmployee
                  @employee_ID INT
AS
BEGIN
     DELETE FROM Employee
     WHERE employee_ID= @employee_ID
END
GO
/*
*CREATE Stored procedure for INSERTING data into  EmployeeStatus TABLE
*/
 CREATE PROC sp_insertEmployeeStatus
                       @statusID INT,
                       @employeeID INT,
                       @description VARCHAR(100)
AS
BEGIN
      INSERT INTO EmployeeStatus VALUES( @statusID,@employeeID,@description)
END
GO
--INSERT DATA
EXEC sp_insertEmployeeStatus 1,1,'no comment'
EXEC sp_insertEmployeeStatus 1,2,'no comment'
EXEC sp_insertEmployeeStatus 1,3,'no comment'
EXEC sp_insertEmployeeStatus 1,4,'no comment'
EXEC sp_insertEmployeeStatus 1,5,'no comment'
EXEC sp_insertEmployeeStatus 1,6,'no comment'
EXEC sp_insertEmployeeStatus 1,7,'no comment'
EXEC sp_insertEmployeeStatus 1,8,'no comment'
EXEC sp_insertEmployeeStatus 3,9,'no comment'
EXEC sp_insertEmployeeStatus 1,10,'no comment'
GO
/*
*CREATE Stored procedure for DELETING data into  EmployeeStatus TABLE
*/
 CREATE PROC sp_deleteEmployeeStatus
                      @employeeID INT                       
AS
BEGIN
      DELETE FROM EmployeeStatus 
      WHERE employee_ID= @employeeID
END
GO
/*
*CREATE Stored procedure for INSERTING data into  EmployeeLeaveType TABLE
*/
CREATE PROC sp_insertEmployeeLeaveType
              @employee_ID INT ,
			  @leaveId INT,
			  @leaveReason VARCHAR(68),
			  @leaveDay INT ,
			  @fromDate DATE,
			  @toDate DATE ,
			  @leaveissueDate DATE
AS
BEGIN
       INSERT INTO EmployeeLeaveType VALUES (@employee_ID,@leaveId,@leaveReason,@leaveDay,@fromDate,@toDate,@leaveissueDate)
END
GO
--INSERT DATA
EXEC sp_insertEmployeeLeaveType 4,4,'Baby perpose',20,'12/15/2021','01/03/2022','11/28/2021'
EXEC sp_insertEmployeeLeaveType 6,2,'Marriage leave',7,'12/11/2021','12/17/2021','11/29/2021'
GO
/*
*CREATE FUNCTION FOR Employee salary Calculation and Add 10% Bonus with salary if no leave over the month
*(Table Function)
*/
CREATE FUNCTION  fn_calcEmployeesalarywith10PercentBonus
(

                      @empId INT,
					  @bonus INT
)
RETURNS TABLE
AS
RETURN
(
   SELECT employee_Name,SalaryAmount,'Basic Salary','leaveDays',
   CASE
      WHEN leaveDays>0 THEN 0
      ELSE (SalaryAmount*(100+@bonus)/100)
    END Extra,
    CASE
       WHEN leaveDays>0 THEN SalaryAmount                                                                                                                                         
       ELSE (SalaryAmount*110/100)
    END Totalsalary
    FROM(SELECT e.employee_Name,D.salaryamount,el.leaveDays
	FROM Employee e
	JOIN DesignationDetails D ON D.designation_ID=e.designation_ID
	LEFT JOIN EmployeeLeaveType el ON el.employee_ID=e.employee_ID
	WHERE e.employee_ID= @empId ) vtable
)
GO
/*
*CREATE FUNCTION  FOR transactiondetails date count (Scalar Function)
*/

CREATE FUNCTION fn_transactiondetailsdateCount
(
                      @date1 DATE,
					  @date2 DATE
)
RETURNS INT
AS
BEGIN
         DECLARE @datecount INT
		 SELECT @datecount=SUM(@@ROWCOUNT) FROM TransactionDetails
		 WHERE [date] BETWEEN @date1 AND @date2
         RETURN @datecount
END
GO
/*
*CREATE FUNTION for find out remaining leave days for employee
*/
CREATE FUNCTION  fn_empremainingleavedays
(

                      @empId INT,
					  @bonus INT
)
RETURNS  @empremainingleavedays TABLE
 (
   empID INT,
   employee_Name VARCHAR(20),
   remainingDays INT
  )
AS
BEGIN
    INSERT @empremainingleavedays                                                                                                                                      
     SELECT e.employee_Name,D.salaryamount,el.leaveDays
	FROM Employee e
	JOIN DesignationDetails D ON D.designation_ID=e.designation_ID
	LEFT JOIN EmployeeLeaveType el ON el.employee_ID=e.employee_ID
	WHERE e.employee_ID= @empId 
	RETURN
	END
GO
------TRIGGER
/*
* CREATE TRIGGER for preventing Status from modification
*/
CREATE TRIGGER trStatusTable_lock
ON Status_t
FOR INSERT,UPDATE,DELETE
AS
   PRINT 'YOU CAN NOT MODIFY OR DELETE STATUS TABLE'
   ROLLBACK TRANSACTION
GO 

/*
* CREATE TRIGGER for preventing Gender from modification
*/
CREATE TRIGGER trgenderTable_lock
ON Gender
FOR INSERT,UPDATE,DELETE
AS
   PRINT 'YOU CAN NOT MODIFY OR DELETE GENDER TABLE'
   ROLLBACK TRANSACTION
GO

/*
* CREATE TRIGGER for preventing data DELETE or UPDATE from EmployeeLeaveType 
*/
CREATE TRIGGER trEmployeeLeaveType_lock
ON Gender
FOR UPDATE,DELETE
AS
   PRINT 'YOU CAN NOT UPDATE OR DELETE EmployeeLeaveType TABLE'
   ROLLBACK TRANSACTION
GO
/*
*SET EmployeeStatus TO 'on-hold' IF EMPLOYEE INFORMATION UPDATE FROM Employee(Automatic Update)
*/
CREATE TRIGGER tr_updateEmployeeStatusOnEmployeeModification
ON Employee
AFTER UPDATE
AS
BEGIN
     --Update Employee
	 DECLARE @empId INT
	 SELECT @empId = employee_ID FROM inserted

	 UPDATE EmployeeStatus
	 SET statusID=3
	 WHERE employee_ID =@empId
END
GO
/*
*CREATE TRIGGER for Preventing data INSERT from Payment TABLE
*/
CREATE TRIGGER trPaymentinsert
ON Payment
FOR Insert
AS
BEGIN
    DECLARE @lid INT,
	        @amt MONEY
	SELECT @lid=loanID,@amt=amount FROM inserted

	UPDATE LoanDetails
	SET outstanding=outstanding-@amt
	WHERE loanID=@lid
END
GO
---INSERT DATA
INSERT INTO Payment VALUES 
(GETDATE(),1,50000),
(GETDATE(),2,15000),
(GETDATE(),3,18000),
(GETDATE(),4,5000),
(GETDATE(),5,12000)
GO
/*
*CREATE TRIGGER for Preventing data INSERT from Payment TABLE(Use RAISERROR)
*/
CREATE TRIGGER trCheckPayment_insert
ON Payment
INSTEAD OF  Insert
AS
BEGIN
    DECLARE @lid INT,
	        @amt MONEY
	SELECT @lid=loanID,@amt=amount FROM inserted

	UPDATE LoanDetails
	SET outstanding=outstanding-@amt
	WHERE loanID=@lid
	IF @lid>@amt
	BEGIN
	     INSERT INTO Payment(paymentDate,loanID,amount)
		 SELECT paymentDate,loanID,amount FROM inserted
	END
  ELSE
      BEGIN
	       RAISERROR('LOAN PAID',10,1)
		   ROLLBACK TRANSACTION
	  END
END
GO
