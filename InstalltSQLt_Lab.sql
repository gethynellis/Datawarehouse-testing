/*Install tSQLt onto the lab computer
This will need be done for the remainder of the exercies to complete*/

/*Install clr*/

EXEC sp_configure 'clr enabled', 1;
RECONFIGURE;
GO
EXEC sp_configure 'clr enabled'

/*set database as trustworth on*/
USE WideWorldImporters 
GO
ALTER DATABASE WideWorldImporters SET TRUSTWORTHY ON;

/*Run the install script from the folder*/
USE WideWorldImporters;
/*
Run the prepareserver.sql file
Run the tSQLtclass.sql file
*/

--Check that the objects have been installed

SELECT @@VERSION,name
 FROM sys.objects sysobj where schema_id = (
select sch.schema_id from sys.schemas sch where name='tSQLt' )
order by sysobj.name


/*Our first SQL unit test through tSQLt*/

/*Create a test class*/

USE WideWorldImporters
GO
EXEC tSQLt.NewTestClass 'DemoUnitTestClass';

/*Check that the test class has been created*/

select SCHEMA_NAME,objtype,name,value from INFORMATION_SCHEMA.SCHEMATA SC
CROSS APPLY fn_listextendedproperty (NULL, 'schema', NULL, NULL, NULL, NULL, NULL) OL
WHERE OL.objname=sc.SCHEMA_NAME COLLATE Latin1_General_CI_AI
and SCHEMA_NAME = 'DemoUnitTestClass'

/*This can be checked in Management Studio too
Open the Security->Schemas node under the database folders.
Right click into DemoUnitTestClass and navigate to Properties
Select the Extended Properties page.

*/

/*Dropping the Test Class*/

EXEC tSQLt.DropClass  'DemoUnitTestClass'


/*Unit test*/

CREATE  FUNCTION CalculateTaxAmount(@amt MONEY)
RETURNS MONEY
AS BEGIN
RETURN (@amt /100)*18 
END;
GO
 
select dbo.CalculateTaxAmount(120) AS TaxAmount

/*Write a test case to check this users function behaviour*/
EXEC tSQLt.NewTestClass 'DemoUnitTestClass';
GO
 
 
CREATE  PROC DemoUnitTestClass.[test tax amount]
AS
BEGIN
DECLARE @TestedAmount as money = 100
DECLARE @expected as money  = 18
DECLARE @actual AS money 
SET @actual = dbo.CalculateTaxAmount(100)
 
EXEC tSQLt.AssertEquals @expected , @actual
 
END


/*Run the test case*/

tSQLt.Run 'DemoUnitTestClass.[test tax amount]'

tSQLt.Run 'DemoUnitTestClass'


/*Make the test fail*/
ALTER PROC DemoUnitTestClass.[test tax amount]
AS
BEGIN
DECLARE @TestedAmount as money = 100
DECLARE @expected as money  = 20
DECLARE @actual AS money 
SET @actual = dbo.CalculateTaxAmount(100)
 
EXEC tSQLt.AssertEquals @expected , @actual
 
END
GO
 
EXEC tSQLt.Run 'DemoUnitTestClass.[test tax amount]'


/*Add more meaningful failure message to the test*/

ALTER PROC DemoUnitTestClass.[test tax amount]
AS
BEGIN
DECLARE @TestedAmount as money = 100
DECLARE @expected as money  = 20
DECLARE @actual AS money 
DECLARE @Message AS VARCHAR(500)='Wrong tax amount'
SET @actual = dbo.CalculateTaxAmount(100)
 
EXEC tSQLt.AssertEquals @expected , @actual ,@Message
 
END
GO
/*run the test*/ 
exec tSQLt.Run 'DemoUnitTestClass.[test tax amount]'


/*Arrange/Act/Assert*/


ALTER PROC DemoUnitTestClass.[test tax amount]
AS
BEGIN
----------------------Arrange-----------------------------
DECLARE @TestedAmount as money = 100                   ---
DECLARE @expected as money  = 20                       --- 
DECLARE @actual AS money          --- 
DECLARE @Message AS VARCHAR(500)='Wrong tax amount'    ---
----------------------------------------------------------
----------------------Act---------------------------------
SET @actual = dbo.CalculateTaxAmount(100)              ---
----------------------------------------------------------
----------------------Assert------------------------------
EXEC tSQLt.AssertEquals @expected , @actual ,@Message  ---
----------------------------------------------------------
END