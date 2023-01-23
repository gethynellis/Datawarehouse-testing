/*How to use fake tables in SQL unit testing1*/

--Fake table demo

/*FakeTable Lab*/

/*Create a database*/

CREATE DATABASE FakeTableLab;
GO


/*CREATE SAMPLE TABLES*/

USE FakeTableLab;
GO

DROP TABLE IF EXISTS OrderLine
DROP TABLE IF EXISTS OrderHeader
CREATE TABLE OrderHeader (OrderId INT PRIMARY KEY , OrderName VARCHAR(50))
CREATE TABLE OrderLine (OrderLineId INT PRIMARY KEY , 
OrderId INT FOREIGN  KEY REFERENCES  OrderHeader(OrderId)
,OrderAmnt INT,OrderNet AS (OrderAmnt*2) PERSISTED,OrderDate DATE DEFAULT GETDATE())
GO

/*Create a stored Procedure*/
CREATE  PROC GetOrderAmntYear 
AS
select YEAR(OrderDate) As OrderYear,SUM(OrderAmnt) As Amnt  
from OrderLine GROUP BY 
YEAR(OrderDate)


/**Test the foreign key contraint*/

INSERT INTO OrderLine (OrderAmnt ,OrderDate) VALUES(20,'20190101')

--This should fail

--Install TSQL Rim the tSQLtClass.sql file 


/*Use Faketable*/

EXEC tSQLt.NewTestClass 'MockTableTest'
GO
DROP PROCEDURE MockTableTest.[Test_GetOrderAmntYearStoredProcedure_PerYears]
AS
DROP TABLE IF EXISTS actual
DROP TABLE IF EXISTS expected
CREATE TABLE actual (OrderYear INT,Amnt INT)
CREATE TABLE expected (OrderYear INT,Amnt INT)
 
 
EXEC tSQLt.FakeTable 'OrderLine'
INSERT INTO OrderLine (OrderAmnt ,OrderDate) VALUES(20,'20190101')
INSERT INTO OrderLine (OrderAmnt ,OrderDate) VALUES(8,'20190101')
INSERT INTO OrderLine (OrderAmnt ,OrderDate) VALUES(12,'20170101')
INSERT INTO OrderLine (OrderAmnt ,OrderDate) VALUES(3,'20160101')
 
 
INSERT INTO actual
EXEC GetOrderAmntYear
 
 
INSERT INTO expected (OrderYear,Amnt)
VALUES(2019,28),(2017,12),(2016,3)
 
EXEC tSQLt.AssertEqualsTable  'expected', 'actual';
 
GO
 
EXEC tSQLt.Run 'MockTableTest.[Test_GetOrderAmntYearStoredProcedure_PerYears]'




