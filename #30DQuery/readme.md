# #30DQuery Challenge

[Youtube Playlist](https://www.youtube.com/playlist?list=PLKW7XPyNDgRCorKNS1bfZoAO3YSIAVz3N) by [@AlexPowers](https://twitter.com/notaboutthecell).

Daily challenges are in this readme and my attempts to solve them are in [challenges.pq](https://github.com/prp1277/PowerBI/blob/master/%2330DQuery/challenges.pq). New challenges are posted each day at 11am.

## Day 1

- Database: AdventureWorksDW2017
- Entity: DimEmployee
- Instructions:

Select `EmployeeKey`, `Gender`, `BirthDate` and a new merged `FullName` column which is a concatenation of `FirstName`, `MiddleName` and `LastName` with a space separator for all employees with a `BirthDate` in the year 1974.

## Day 2

- Database: AdventureWorksDW2017
- Entity: DimReseller, DimGeography
- Instructions:

Select the `ResellerKey`, `BusinessType`, `ResellerName`, `NumberEmployees`, `ProductLine`, `AnnualRevenue` and `EnglishCountryRegionName` columns where the `ResellerName` contains Bike or Bicycle and the `CountryRegionCode` is not in DE or GB.

## Day 3

- Database: AdventureWorksDW2017
- Entity: DimProduct , FactResellerSales
- Instructions:

Select the `ProductKey`, `EnglishProductName` and an aggregated `TotalRevenue` column which is the sum of a new computed column `TotalUnitPrice` made up of `OrderQuantity` multiplied by `UnitPrice` where the `TotalRevenue` is above one million.

## Day 4

- Database: WideWorldImportersDW
- Entity: Fact.Order
- Instructions:

Select `OrderKey` and `Description` where the modulo of the `Description` length divided by 10 is equal to 1.

## Day 5

- Database: WideWorldImportersDW
- Entity: Dimension.Employee
- Instructions:

Select the `Employee Key`, `Employee`, `Is Salesperson`, `Valid From` and `Valid To` where the following two conditions are met —

- `Is Salesperson` is True, the `Valid To` year is not 9999 and the total days between `Valid From` and `Valid To` is greater than 365
- `Is Salesperson` is False and the `Valid To` year is 9999

## Day 6

- Database: WideWorldlmportersDW
- Entity: Dimension.Stock Item
- Instructions:

Select `Stock Item Key`, `Stock Item` and `Color` where the `Stock Item Key` is an even number and the `Color` is not N/A

## Day 7

- Database: AdventureWorksDW2017
- Entity: DimEmployee
- Instructions:

Dynamically select all the columns that do not contain the text `Key`.

## Day 8

- Database: WideWorldlmportersDW
- Entity: Fact.Sale
- Instructions:

Select `Sale Key`, `Customer Key`, `Invoice Date Key`, `Total Excluding Tax`, `Tax Amount` and `Profit` where the `Invoice Date Key` is equal to the last date of each month.

## Day 9

- Database: AdventureWorksDW2017
- Entity: DimCustomer , FactInternetSales
- Instructions:

Select `Gender`, `EnglishEducation` and pivot the sum of `OrderQuantity` for `CommuteDistance`. Sort the `EnglishEducation` from the lowest education level to the highest and the `Gender` column in ascending order. Re-order the `CommuteDistance` columns from the shortest to longest distance.

## Day 10

- Database: WideWorldImportersDW
- Entity: Dimension.Employee

Instructions:
Select `Employee` and a computed column `TeamMate` which references the name values from the `Employee` column.

- Teams of two.
- No one should be on more than one team.
- Everyone should know their teammates name.
- Unfortunately, one person will be left out :(

## Day 11

- Database: AdventureWorksDW2017
- Entity: DimGeography , DimCustomer , FactInternetSales

Instructions:
Select `City`, `CountryRegionCode` and `EnglishCountryRegionName` where no `SalesAmount` occurred. Sort `CountryRegion` and `City` in Ascending Order.

## Day 12

- Database: WideWorldImportersDW
- Entity: Dimension.Employee , Dimension.Customer

Instructions:
Union select a `Full Name` column for each unique name in ascending order.
The `Full Name` field is an alias for the `Employee` and `Primary Contact` fields.

## Day 13

- Database: AdventureWorksDW2017
- Entity: DimEmployee

Instructions:
Select `EmailAddress`, `Gender`, `BirthDate` for all employees with a `BirthDate` between 19900101 and 19901231.

## Day 14

- Database: AdventureWorksDW2017
- Entity: DimCustomer

Instructions:
Select `CustomerKey`, `EmailAddress`, `EnglishOccupation` and `YearlyIncome` for the customers whose `BirthDate` was not on a weekend (Saturday, Sunday).

## Day 15

- Database: WideWorldImportersDW
- Entity: Dimension.City, Fact.Order, Fact.Sale

Instructions:
Select the ten longest delivery days average for `City Key`, `City` and the computed column `Average Delivery Days` which is the days between `Order Date Key` and `Delivery Date Key` for all completed deliveries.

- Include ties if applicable.

## Day 16

- Database: WideWorldImportersDW
- Entity: Fact.Sale

Instructions:
Select a computed column `YYYYMM` which is the year and month representation of `Invoice Date Key`, an aggregated `TotalProfit` column which is the sum of `Profit` and a computed column `Change Percentage` which is the month-over-month change of `TotalProfit`.

## Day 17

- Database: AdventureWorksDW2017
- Entity: FactCallCenter

Instructions:
Select the top 10 and bottom 10 `DateKey`, `Shift`, `Calls`, `AverageTimePerIssue` and a computed column `TotalTime` which is the multiplication of `Calls` and `AverageTimePerIssue` for the ‘PM’ `Shift`’s based on `TotalTime` in ascending order.

## Day 18

- Database: WideWorldImportersDW
- Entity: Dimension.City

Instructions:
Select `City Key`, `City`, `State Province` and `Sales Territory` where the `City` contains ‘A’, ‘d’ and ‘C’.

- Case sensitive

## Day 19

- Database: AdventureWorksDW2017
- Entity: FactResellerSales

Instructions:
Select `SalesOrderNumber`, `OrderDate`, `ResellerKey`, `EmployeeKey` and a computed column `UnixTimestamp` which is the `OrderDate` converted to its epoch unix time stamp equivalent.

## Day 20

- Database: WideWorldImportersDW
- Entity: Dimension.Stock Item

Instructions:
Dynamically select all of the text columns.

## Day 21

- Database: WideWorldlmportersDW
- Entity: Fact.Order

Instructions:
Select `Order Key`, `Description`, `Quantity` and a computed column `Category` which evaluates the `Quantity` column based on the following criteria:
• Less than 100
• Between 100 and 250
• More than 250

## Day 22

- Database: AdventureworksDW2017
- Entity: FactResellerSales

Instructions:
Select `ProductKey`, `SalesOrderNumber`, the date part only for `ShipDate` and `SalesAmount` for all `ShipDate`'s within the previous 7 years.

## Day 23

- Database: WideWorldImportersDW
- Entity: Fact.Sale , Dimension.Customer

Instructions:
Select `Sale Key` , `Salesperson Key`, `Description` and `Bill To Customer` sorted by the `Bill To Customer` in ascending order with all 'N/A values sorted last.

## Day 24

- Database: WideWorldlmportersDW
- Entity: Dimension.Transaction Type

Instructions:
Select `Transaction Type Key` and `Transaction Type` where the second letter in `Transaction Type) is a lower-cased vowel 'a', e', 'i', 'd', 'u', 'y' or 'W'.

## Day 25

- Database: WideWorldlmportersDW
- Entity: Dimension.Supplier, Fact.Transaction

Instructions:
Select a computed column `Supplier Key Reference` which is a combination of `Supplier Key` , " and `Supplier Reference` , `Supplier`, `Category`, `Primary Contact` where `Is Finalized` is false and `Supplier` is not 'Unknown'

## Day 26

- Database: AdventureWorksDW2017
- Entity: DimEmployee

Instructions:
Select `EmployeeKey`, `FirstName`, `MiddleName`, `LastName` where the `LastName` does not start with the letters 'A' , 'B' , 'C , 'D' or 'E'

## Day 27

- Database: AdventureWorksDW2017
- Entity: DimCurrency

Instructions:
Select `CurrencyKey`, `CurrencyAlternateKey` and `CurrencyName` where the `CurrencyName` contains two of the letter e'

- Case sensitive
- Does not need to be in a row

## Day 28

- Database: AdventureWorksDW2017
- Entity: DimProduct

Instructions:
Select `ProductKey`, `ProductAlternateKey`, `EnglishProductName`, `DealerPrice` and a computed column `OverallPercentage` which is the `DealerPrice` divided by the sum of all `DealerPrice`'s where the `DealerPrice` is not null

## Day 29

- Database: WideWorldlmportersDW
- Entity: Fact.Sale

Instructions:
Partition the table based on the year of the `Invoice Date Key`

## Day 30

- Database: AdventureWorksDW2017
- Entity: Dimpromotion

Instructions:
Dynamically rename all the column names inserting a space wherever a lowercase letter transitions into an uppercase letter.
