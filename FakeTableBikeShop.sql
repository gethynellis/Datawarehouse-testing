/*Create environemt*/

USE master;
GO
 
IF DB_ID('BikeShop') IS NOT NULL
DROP DATABASE BikeShop;
GO
 
CREATE DATABASE BikeShop;
GO
 
USE BikeShop;
GO
 
CREATE TABLE dbo.Bike
(
  BikeID INT PRIMARY KEY,
  ListPrice MONEY NOT NULL,
  ReorderPoint SMALLINT NOT NULL 
);
GO 
 
ALTER TABLE Bike ADD CONSTRAINT ck_ReorderPoint_min
    CHECK (ReorderPoint > 10);
GO
 
INSERT INTO Bike VALUES (101, 695.95, 35);
INSERT INTO Bike VALUES (102, 735.95, 25);
GO 
/****Enable CLR*****/

USE BikeShop;
GO
EXEC sp_configure 'clr enabled', 1;
RECONFIGURE;


/*Set trustworth on*/


ALTER DATABASE BikeShop SET TRUSTWORTHY ON; 

////*Run the tSQLt.Class.SQL cript from the tSQLt folder**/


/*Create a Test class (Schema) with extended properties that says where the test is located*/

EXEC tSQLt.NewTestClass 'TestBikeShop';
GO


/*Add a function to the BikeShop databases*/

IF OBJECT_ID('AddSalesTax', 'FN') IS NOT NULL
DROP FUNCTION AddSalesTax;
GO
 
CREATE FUNCTION AddSalesTax(@amt MONEY)
RETURNS MONEY
AS BEGIN
RETURN (@amt * .095) + @amt
END;
GO


/*The following T-SQL script creates a test case named TestAddSalesTax in the TestBikeShop test class:*/

IF OBJECT_ID('TestBikeShop.TestAddSalesTax', 'P') IS NOT NULL
DROP PROCEDURE TestBikeShop.TestAddSalesTax;
GO
 
CREATE PROCEDURE TestBikeShop.TestAddSalesTax
AS
BEGIN
  DECLARE @total MONEY
  SELECT @total = dbo.AddSalesTax(10);
 
  EXEC tSQLt.AssertEquals 10.95, @total;
END;
GO
 
EXEC tSQLt.Run 'TestBikeShop.TestAddSalesTax';



/****If we expect different results*****/

IF OBJECT_ID('TestBikeShop.TestAddSalesTax', 'P') IS NOT NULL
DROP PROCEDURE TestBikeShop.TestAddSalesTax;
GO
 
CREATE PROCEDURE TestBikeShop.TestAddSalesTax
AS
BEGIN
  DECLARE @total MONEY
  SELECT @total = dbo.AddSalesTax(10);
 
  EXEC tSQLt.AssertEquals 10.85, @total;
END;
GO
 
EXEC tSQLt.Run 'TestBikeShop.TestAddSalesTax';

/*The only different between this example and the preceding 
one is the expected amount passed into the AssertEquals stored procedure. 
However, the original AddSalesTax function remains unchanged. Consequently, 
when we call the Run procedure, 
the test now fails, as shown in the following results:*/



/*Testing the UpdateListPrice Stored Procedure*/

IF OBJECT_ID('UpdateListPrice', 'P') IS NOT NULL
DROP PROCEDURE UpdateListPrice;
GO
 
CREATE PROCEDURE UpdateListPrice
  @BikeID INT,
  @ListPrice MONEY = 0
AS
BEGIN
  UPDATE Bike
  SET ListPrice = @ListPrice
  WHERE BikeID = @BikeID;
END;
GO 


/*The following CREATE PROCEDURE statement creates a test case (TestUpdateListPrice) that uses the FakeTable stored procedure to create a temporary version of the Bike table:*/

IF OBJECT_ID('TestBikeShop.TestUpdateListPrice', 'P') IS NOT NULL
DROP PROCEDURE TestBikeShop.TestUpdateListPrice;
GO
 
CREATE PROCEDURE TestBikeShop.TestUpdateListPrice
AS
BEGIN
  EXEC tSQLt.FakeTable 'dbo.Bike';
 
  INSERT INTO dbo.Bike (BikeID, ListPrice) VALUES (101, 495.95);
 
  EXEC dbo.UpdateListPrice 101, 595.95
 
  DECLARE @NewPrice MONEY
  SELECT @NewPrice = ListPrice FROM dbo.Bike WHERE BikeID = 101;
 
  EXEC tSQLt.AssertEquals 595.95, @NewPrice;
END;
GO
 
EXEC tSQLt.Run 'TestBikeShop.TestUpdateListPrice';


/*Testing the SetReorderPoint Stored Procedure*/

IF OBJECT_ID('SetReorderPoint', 'P') IS NOT NULL
DROP PROCEDURE SetReorderPoint;
GO
 
CREATE PROCEDURE SetReorderPoint
  @percent SMALLINT
AS
BEGIN
  UPDATE Bike
  SET ReorderPoint = ReorderPoint * (@percent * .01);
END;
GO


/*In the following CREATE PROCEDURE statement, we again use the tSQLt FakeTable stored procedure to create a temporary table for testing:*/

IF OBJECT_ID('TestBikeShop.TestSetReorderPoint', 'P') IS NOT NULL
DROP PROCEDURE TestBikeShop.TestSetReorderPoint;
GO
 
CREATE PROCEDURE TestBikeShop.TestSetReorderPoint
AS
BEGIN
  EXEC tSQLt.FakeTable 'dbo.Bike';
 
  INSERT INTO dbo.Bike (ReorderPoint) VALUES (20);
  INSERT INTO dbo.Bike (ReorderPoint) VALUES (30);
  INSERT INTO dbo.Bike (ReorderPoint) VALUES (40);
  INSERT INTO dbo.Bike (ReorderPoint) VALUES (50);
  INSERT INTO dbo.Bike (ReorderPoint) VALUES (60);
 
  EXEC dbo.SetReorderPoint 200;
 
  SELECT ReorderPoint INTO #ActualValues FROM dbo.Bike;
 
  CREATE TABLE #ExpectedValues (ReorderPoint SMALLINT);
 
  INSERT INTO #ExpectedValues (ReorderPoint) VALUES (40);
  INSERT INTO #ExpectedValues (ReorderPoint) VALUES (60);
  INSERT INTO #ExpectedValues (ReorderPoint) VALUES (80);
  INSERT INTO #ExpectedValues (ReorderPoint) VALUES (100);
  INSERT INTO #ExpectedValues (ReorderPoint) VALUES (120);
 
  EXEC tSQLt.AssertEqualsTable #ActualValues, #ExpectedValues;
END;
GO
 
EXEC tSQLt.Run 'TestBikeShop.TestSetReorderPoint';


/*In this case, our actual values matched the projected values, so our test succeeded. However, suppose we populate the #ExpectedValues table with different values because we expect the SetReorderPoint stored procedure to add the 200, rather than multiplying the values by 200%. The following test case definition would look as follows:*/

IF OBJECT_ID('TestBikeShop.TestSetReorderPoint', 'P') IS NOT NULL
DROP PROCEDURE TestBikeShop.TestSetReorderPoint;
GO
 
CREATE PROCEDURE TestBikeShop.TestSetReorderPoint
AS
BEGIN
  EXEC tSQLt.FakeTable 'dbo.Bike';
 
  INSERT INTO dbo.Bike (ReorderPoint) VALUES (20);
  INSERT INTO dbo.Bike (ReorderPoint) VALUES (30);
  INSERT INTO dbo.Bike (ReorderPoint) VALUES (40);
  INSERT INTO dbo.Bike (ReorderPoint) VALUES (50);
  INSERT INTO dbo.Bike (ReorderPoint) VALUES (60);
 
  EXEC dbo.SetReorderPoint 200;
 
  SELECT ReorderPoint INTO #ActualValues FROM dbo.Bike;
 
  CREATE TABLE #ExpectedValues (ReorderPoint SMALLINT);
 
  INSERT INTO #ExpectedValues (ReorderPoint) VALUES (220);
  INSERT INTO #ExpectedValues (ReorderPoint) VALUES (230);
  INSERT INTO #ExpectedValues (ReorderPoint) VALUES (240);
  INSERT INTO #ExpectedValues (ReorderPoint) VALUES (250);
  INSERT INTO #ExpectedValues (ReorderPoint) VALUES (260);
 
  EXEC tSQLt.AssertEqualsTable #ActualValues, #ExpectedValues;
END;
GO
 
EXEC tSQLt.Run 'TestBikeShop.TestSetReorderPoint';


/**Now let’s look at one other tSQLt feature. As you’ll recall, when we created the BikeShop database, we added a constraint to the table that restricted the values that can be inserted into the ReorderPoint column. However, the temporary tables you create with the FakeTable stored procedure, by default, don’t include the original constraints. One reason this can be useful is because changes to constraints on the table won’t impact your test cases.

However, we can override this behavior by using the ApplyConstraint stored procedure, which lets us apply individual constraints to our temporary table. The following example uses the ApplyConstraint procedure to enforce the ck_ReorderPoint_min check constraint defined on the Bike table:**/


IF OBJECT_ID('TestBikeShop.TestSetReorderPoint', 'P') IS NOT NULL
DROP PROCEDURE TestBikeShop.TestSetReorderPoint;
GO
 
CREATE PROCEDURE TestBikeShop.TestSetReorderPoint
AS
BEGIN
  EXEC tSQLt.FakeTable 'dbo.Bike';
  EXEC tSQLt.ApplyConstraint 'dbo.Bike', 'ck_ReorderPoint_min' 
 
  INSERT INTO dbo.Bike (ReorderPoint) VALUES (20);
  INSERT INTO dbo.Bike (ReorderPoint) VALUES (30);
  INSERT INTO dbo.Bike (ReorderPoint) VALUES (40);
  INSERT INTO dbo.Bike (ReorderPoint) VALUES (50);
  INSERT INTO dbo.Bike (ReorderPoint) VALUES (60);
 
  EXEC dbo.SetReorderPoint 200;
 
  SELECT ReorderPoint INTO #ActualValues FROM dbo.Bike;
 
  CREATE TABLE #ExpectedValues (ReorderPoint SMALLINT);
 
  INSERT INTO #ExpectedValues (ReorderPoint) VALUES (40);
  INSERT INTO #ExpectedValues (ReorderPoint) VALUES (60);
  INSERT INTO #ExpectedValues (ReorderPoint) VALUES (80);
  INSERT INTO #ExpectedValues (ReorderPoint) VALUES (100);
  INSERT INTO #ExpectedValues (ReorderPoint) VALUES (120);
 
  EXEC tSQLt.AssertEqualsTable #ActualValues, #ExpectedValues;
END;
GO
 
EXEC tSQLt.Run 'TestBikeShop.TestSetReorderPoint';


/*Notice that when we specify the ApplyConstraint stored procedure, we pass in two arguments: the table and the constraint names. Yet even though we’ve included this procedure, our test will still succeed because we’re multiplying our ReorderPoint values by 200%, far above the check constraint’s minimum.

Now suppose we instead pass in a value of 10 when we call the SetReorderPoint stored procedure, as shown in the following example:*/

IF OBJECT_ID('TestBikeShop.TestSetReorderPoint', 'P') IS NOT NULL
DROP PROCEDURE TestBikeShop.TestSetReorderPoint;
GO
 
CREATE PROCEDURE TestBikeShop.TestSetReorderPoint
AS
BEGIN
  EXEC tSQLt.FakeTable 'dbo.Bike';
  EXEC tSQLt.ApplyConstraint 'dbo.Bike', 'ck_ReorderPoint_min' 
 
  INSERT INTO dbo.Bike (ReorderPoint) VALUES (20);
  INSERT INTO dbo.Bike (ReorderPoint) VALUES (30);
  INSERT INTO dbo.Bike (ReorderPoint) VALUES (40);
  INSERT INTO dbo.Bike (ReorderPoint) VALUES (50);
  INSERT INTO dbo.Bike (ReorderPoint) VALUES (60);
 
  EXEC dbo.SetReorderPoint 10;
 
  SELECT ReorderPoint INTO #ActualValues FROM dbo.Bike;
 
  CREATE TABLE #ExpectedValues (ReorderPoint SMALLINT);
 
  INSERT INTO #ExpectedValues (ReorderPoint) VALUES (2);
  INSERT INTO #ExpectedValues (ReorderPoint) VALUES (3);
  INSERT INTO #ExpectedValues (ReorderPoint) VALUES (4);
  INSERT INTO #ExpectedValues (ReorderPoint) VALUES (5);
  INSERT INTO #ExpectedValues (ReorderPoint) VALUES (6);
 
  EXEC tSQLt.AssertEqualsTable #ActualValues, #ExpectedValues;
END;
GO
 
EXEC tSQLt.Run 'TestBikeShop.TestSetReorderPoint';


/*Not only have we changed the SetReorderPoint argument, but also the expected values we insert into the #ExpectedValues temporary table. Now when we run the test case, we receive neither a success or failure message; rather, we receive an error message, as shown in the following results:

*/