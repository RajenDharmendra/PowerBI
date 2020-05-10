# #30DQuery Challenge

## Day 1

Instructions:
Select [EmployeeKey], [Gender], [BirthDate] and a new merged [FullName] column which is a concatenation of [FirstName], [MiddleName] and [LastName] with a space separator for all employees with a [BirthDate] in the year 1974.

## Day 2

Database: AdventureWorksDW2017
Entity: DimReseller, DimGeography
Instructions:
Select the [ResellerKey], [BusinessType], [ResellerName], [NumberEmployees], [ProductLine], [AnnualRevenue] and [EnglishCountryRegionName] columns where the [ResellerName] contains Bike or Bicycle and the [CountryRegionCode] is not in DE or GB.

## Day 3

Database: AdventureWorksDW2017
Entity: DimProduct , FactResellerSales
Instructions:
Select the [ProductKey], [EnglishProductName] and an aggregated [TotalRevenue] column which is the sum of a new computed column [TotalUnitPrice] made up of [OrderQuantity] multiplied by [UnitPrice] where the [TotalRevenue] is above one million.

## Day 4

Database: WideWorldImportersDW
Entity: Fact.Order
Instructions:
Select [OrderKey] and [Description] where the modulo of the [Description] length divided by 10 is equal to 1.

## Day 5

Database: WideWorldImportersDW
Entity: Dimension.Employee
Instructions:
Select the [Employee Key], [Employee], [Is Salesperson], [Valid From] and [Valid To] where the following two conditions are met —

- [Is Salesperson] is True, the (Valid To] year is not 9999 and the total days between (Valid From] and [Valid To] is greater than 365
- [Is Salesperson] is False and the [Valid Tol year is 9999

## Day 6

Database: WideWorldlmportersDW
Entity: Dimension.Stock Item
Instructions:
Select (Stock Item Key), (Stock Item] and [Color] where the (Stock Item Keyl is an even number and the [Color] is not N/A

## Day 7

Database: AdventureWorksDW2017
Entity: DimEmployee
Instructions:
Dynamically select all the columns that do not contain the text 'Key'.

## Day 8

Database: WideWorldlmportersDW
Entity: Fact.Sale
Instructions:
Select [Sale Key], [Customer Key], [Invoice Date Key], [Total Excluding Tax], [Tax Amount] and [Profit] where the [Invoice Date Key] is equal to the last date of each month.

## Day 9

## Day 10

## Day 11

## Day 12

## Day 13

## Day 14

## Day 15

## Day 16

## Day 17

## Day 18

## Day 19

## Day 20

## Day 21

## Day 22

## Day 23

## Day 24

## Day 25

## Day 26

## Day 27

## Day 28

## Day 29

## Day 30
