# What is the AdventureWorks Database

AdventureWorks Database is a Microsoft product sample for an online transaction processing (OLTP) database. The AdventureWorks Database supports a fictitious, multinational manufacturing company called Adventure Works Cycles.

## Analyse the AdventureWorks database

Analyse the AdventureWorks database and suggest any missing dimensions in the following star schema.

You can use the following code to look at the relationships in the adventureworks database. Run this is SQL Server Managament Studio against the version of Adventrure works installed on your lab

[You can download the SQL File here](https://github.com/gethynellis/Datawarehouse-testing/blob/main/QueryAdventureWorksSchema.sql)

```
USE AdventureWorks2019
GO

SELECT 'sqlserver' dbms
	,t.TABLE_CATALOG
	,t.TABLE_SCHEMA
	,t.TABLE_NAME
	,c.COLUMN_NAME
	,c.ORDINAL_POSITION
	,c.DATA_TYPE
	,c.CHARACTER_MAXIMUM_LENGTH
	,n.CONSTRAINT_TYPE
	,k2.TABLE_SCHEMA
	,k2.TABLE_NAME
	,k2.COLUMN_NAME
FROM INFORMATION_SCHEMA.TABLES t
LEFT JOIN INFORMATION_SCHEMA.COLUMNS c ON t.TABLE_CATALOG = c.TABLE_CATALOG
	AND t.TABLE_SCHEMA = c.TABLE_SCHEMA
	AND t.TABLE_NAME = c.TABLE_NAME
LEFT JOIN (
	INFORMATION_SCHEMA.KEY_COLUMN_USAGE k JOIN INFORMATION_SCHEMA.TABLE_CONSTRAINTS n ON k.CONSTRAINT_CATALOG = n.CONSTRAINT_CATALOG
		AND k.CONSTRAINT_SCHEMA = n.CONSTRAINT_SCHEMA
		AND k.CONSTRAINT_NAME = n.CONSTRAINT_NAME
	LEFT JOIN INFORMATION_SCHEMA.REFERENTIAL_CONSTRAINTS r ON k.CONSTRAINT_CATALOG = r.CONSTRAINT_CATALOG
		AND k.CONSTRAINT_SCHEMA = r.CONSTRAINT_SCHEMA
		AND k.CONSTRAINT_NAME = r.CONSTRAINT_NAME
	) ON c.TABLE_CATALOG = k.TABLE_CATALOG
	AND c.TABLE_SCHEMA = k.TABLE_SCHEMA
	AND c.TABLE_NAME = k.TABLE_NAME
	AND c.COLUMN_NAME = k.COLUMN_NAME
LEFT JOIN INFORMATION_SCHEMA.KEY_COLUMN_USAGE k2 ON k.ORDINAL_POSITION = k2.ORDINAL_POSITION
	AND r.UNIQUE_CONSTRAINT_CATALOG = k2.CONSTRAINT_CATALOG
	AND r.UNIQUE_CONSTRAINT_SCHEMA = k2.CONSTRAINT_SCHEMA
	AND r.UNIQUE_CONSTRAINT_NAME = k2.CONSTRAINT_NAME
WHERE t.TABLE_TYPE = 'BASE TABLE'
ORDER BY t.TABLE_SCHEMA
	,t.TABLE_NAME

```

## The Entity Relationship  Digram

The following is sample of the some the tables and the relationships that exist in the Adventure Works database

![AdevntureWorks ER Diagram](https://github.com/gethynellis/Datawarehouse-testing/blob/main/Images/AdventureWorks%20Sample.jpeg "AdventureWorks OLTP Database ER Diagram")



## Dimensional Modelling and the Star Schema

The adventure Works Database Can be turned into a Start Schema - We will call this the AdventureWorksDW database. You will find it on your Lab machines

## What diemnsions are missing

Using your uderstanding of the Adventure works database and what other possible dimensions could be added to the AdventureWorksDW that would allow the data to be slcied and diced further

Work in your groups and come up with the dimensions that are potentially missing from each model

## Resell Sales
What dimesnions are missing from the model

![Reseller Sales Star Schema](https://github.com/gethynellis/Datawarehouse-testing/blob/main/Images/AdventureWorksDW%20-%20Reseller.jpeg "Reseller Sales Start Schema")


## Internet Sales
What dimesnions are missing from the Internet Sales model

![Internet Sales Star Schema](https://github.com/gethynellis/Datawarehouse-testing/blob/main/Images/AdventureWorksDW%20-%20Internet%20Sales.jpeg "Internet  Sales Start Schema")


## Finance
What dimesnions are missing from the finance model

![Fianace Star Schema](https://github.com/gethynellis/Datawarehouse-testing/blob/main/Images/AdventureWorksDW%20-%20Finance.jpeg "Internet  Sales Start Schema")


**We will discuss your findings as a class**

