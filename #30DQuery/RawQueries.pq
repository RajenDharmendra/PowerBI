/*
* Parameters
*/
// SQLServer
"localhost" meta [IsParameterQuery=true, Type="Any", IsParameterQueryRequired=true]
// AW2017
"AdventureWorksDW2017" meta [IsParameterQuery=true, Type="Any", IsParameterQueryRequired=true]
// WWI
"WideWorldImportersDW" meta [IsParameterQuery=true, Type="Any", IsParameterQueryRequired=true]

/*
* Day 1
*/
let
    Source = Sql.Databases("localhost"),
    AdventureWorksDW2017 = Source{[Name="AdventureWorksDW2017"]}[Data],
    dbo_DimEmployee = AdventureWorksDW2017{[Schema="dbo",Item="DimEmployee"]}[Data],
    #"Merged Columns" = Table.CombineColumns(dbo_DimEmployee,{"FirstName", "MiddleName"},Combiner.CombineTextByDelimiter(" ", QuoteStyle.None),"Merged"),
    #"Merged Columns1" = Table.CombineColumns(#"Merged Columns",{"Merged", "LastName"},Combiner.CombineTextByDelimiter(" ", QuoteStyle.None),"FullName"),
    #"Replaced Value" = Table.ReplaceValue(#"Merged Columns1","  "," ",Replacer.ReplaceText,{"FullName"}),
    #"Removed Other Columns" = Table.SelectColumns(#"Replaced Value",{"EmployeeKey", "FullName", "BirthDate", "Gender"}),
    #"Duplicated Column" = Table.DuplicateColumn(#"Removed Other Columns", "BirthDate", "BirthDate - Copy"),
    #"Split Column by Delimiter" = Table.SplitColumn(Table.TransformColumnTypes(#"Duplicated Column", {{"BirthDate - Copy", type text}}, "en-US"), "BirthDate - Copy", Splitter.SplitTextByEachDelimiter({"/"}, QuoteStyle.Csv, true), {"BirthDate - Copy.1", "BirthDate - Copy.2"}),
    #"Filtered Rows" = Table.SelectRows(#"Split Column by Delimiter", each ([#"BirthDate - Copy.2"] = "1974")),
    #"Removed Columns" = Table.RemoveColumns(#"Filtered Rows",{"BirthDate - Copy.1", "BirthDate - Copy.2"})
in
    #"Removed Columns"

/*
* Day 2
*/
let
  Source = Sql.Database(SQLServer, AW2017),
  AdventureWorksDW2017 = Source{[Name = "AdventureWorksDW2017"]}[Data],
  dbo_DimReseller = AdventureWorksDW2017{[Schema = "dbo", Item = "DimReseller"]}[Data],
  #"Reseller contains Bike or Bicycle" = Table.SelectRows(dbo_DimReseller, each Text.Contains([ResellerName], "Bike") or Text.Contains([ResellerName], "Bicycle")),
  #"Removed Other Columns" = Table.SelectColumns(#"Reseller contains Bike or Bicycle", {"ResellerKey", "BusinessType", "ResellerName", "NumberEmployees", "ProductLine", "AnnualRevenue", "DimGeography"}),
  #"Expanded DimGeography" = Table.ExpandRecordColumn(#"Removed Other Columns", "DimGeography", {"CountryRegionCode"}, {"CountryRegionCode"}),
  #"Filtered Rows <> DE || GB" = Table.SelectRows(#"Expanded DimGeography", each ([CountryRegionCode] <> "DE" and [CountryRegionCode] <> "GB"))
in
  #"Filtered Rows <> DE || GB"

/*
* Day 3 - FactResellerSales
*/
let
    Source = Sql.Database(SQLServer, AW2017),
    dbo_FactResellerSales = Source{[Schema="dbo",Item="FactResellerSales"]}[Data],
    #"Added Custom" = Table.AddColumn(dbo_FactResellerSales, "TotalUnitPrice", each [OrderQuantity]*[UnitPrice]),
    #"Expanded DimProduct" = Table.ExpandRecordColumn(#"Added Custom", "DimProduct", {"EnglishProductName"}, {"EnglishProductName"}),
    #"Grouped Rows" = Table.Group(#"Expanded DimProduct", {"ProductKey", "EnglishProductName"}, {{"Total Revenue", each List.Sum([TotalProductCost]), type number}}),
    #"Filtered Rows" = Table.SelectRows(#"Grouped Rows", each [Total Revenue] > 1000000)
in
    #"Filtered Rows"

/*
* Day 4
*/
// Fact Order
let
    Source = Sql.Database(SQLServer, WWI),
    Fact_Order = Source{[Schema="Fact",Item="Order"]}[Data],
    #"Inserted Text Length" = Table.AddColumn(Fact_Order, "Length", each Text.Length([Description]), Int64.Type),
    #"Calculated Modulo" = Table.TransformColumns(#"Inserted Text Length", {{"Length", each Number.Mod(_, 10), type number}}),
    #"Filtered Rows" = Table.SelectRows(#"Calculated Modulo", each ([Length] = 1)),
    #"Removed Other Columns" = Table.SelectColumns(#"Filtered Rows",{"Order Key", "Description"})
in
    #"Removed Other Columns"

/*
* Day 5
*/
// Dimension Employee
let
    Source = Sql.Database(SQLServer, WWI),
    Dimension_Employee = Source{[Schema="Dimension",Item="Employee"]}[Data]
in
    Dimension_Employee

// NotSalesperson
let
    Source = #"Dimension Employee",
    #"Removed Columns" = Table.RemoveColumns(Source,{"Fact.Order(Employee Key)", "Fact.Order(Employee Key) 2", "Fact.Sale"}),
    #"Inserted Year" = Table.AddColumn(#"Removed Columns", "Year", each Date.Year([Valid To]), Int64.Type),
    #"Filtered Rows" = Table.SelectRows(#"Inserted Year", each ([Year] = 9999) and ([Is Salesperson] = false))
in
    #"Filtered Rows"
    
// IsSalesperson
let
    Source = #"Dimension Employee",
    #"Removed Columns" = Table.RemoveColumns(Source,{"Fact.Order(Employee Key)", "Fact.Order(Employee Key) 2", "Fact.Sale"}),
    #"Inserted Year" = Table.AddColumn(#"Removed Columns", "Year", each Date.Year([Valid To]), Int64.Type),
    #"Inserted Year1" = Table.AddColumn(#"Inserted Year", "Year.1", each Date.Year([Valid From]), Int64.Type),
    #"Renamed Columns" = Table.RenameColumns(#"Inserted Year1",{{"Year", "To Year"}, {"Year.1", "From Year"}}),
    #"Added Custom" = Table.AddColumn(#"Renamed Columns", "Total Days", each [Valid To]-[Valid From]),
    #"Inserted Total Days" = Table.AddColumn(#"Added Custom", "Total Days.1", each Duration.TotalDays([Total Days]), type number),
    #"Filtered Rows1" = Table.SelectRows(#"Inserted Total Days", each [Total Days.1] > 365),
    #"Filtered Rows" = Table.SelectRows(#"Filtered Rows1", each ([Is Salesperson] = true)),
    #"Appended Query" = Table.Combine({#"Filtered Rows", NotSalesperson}),
    #"Grouped Rows" = Table.Group(#"Appended Query", {"Employee Key"}, {{"EmployeeDetails", each _, type table [Employee Key=number, WWI Employee ID=number, Employee=text, Preferred Name=text, Is Salesperson=logical, Photo=binary, Valid From=datetime, Valid To=datetime, Lineage Key=number, To Year=number, From Year=number, Total Days=duration, Total Days.1=number, Year=number]}}),
    #"Merged Queries" = Table.NestedJoin(#"Grouped Rows", {"Employee Key"}, #"Dimension Employee", {"Employee Key"}, "Dimension Employee", JoinKind.LeftOuter),
    #"Expanded Dimension Employee" = Table.ExpandTableColumn(#"Merged Queries", "Dimension Employee", {"Employee", "Is Salesperson", "Valid From", "Valid To"}, {"Employee", "Is Salesperson", "Valid From", "Valid To"}),
    #"Removed Columns1" = Table.RemoveColumns(#"Expanded Dimension Employee",{"EmployeeDetails"})
in
    #"Removed Columns1"

/*
* Day 6
*/
let
    Source = Sql.Database(Server, WorldWideImporters),
    #"Dimension_Stock Item" = Source{[Schema="Dimension",Item="Stock Item"]}[Data],
    #"Filtered Rows" = Table.SelectRows(#"Dimension_Stock Item", each ([Color] <> "N/A")),
    #"Added Custom" = Table.AddColumn(#"Filtered Rows", "DivisibleBy2", each [Stock Item Key]/2),
    #"Changed Type" = Table.TransformColumnTypes(#"Added Custom",{{"DivisibleBy2", type text}}),
    #"Filtered Rows2" = Table.SelectRows(#"Changed Type", each not Text.Contains([DivisibleBy2], ".5")),
    #"Removed Other Columns" = Table.SelectColumns(#"Filtered Rows2",{"Stock Item Key", "Stock Item", "Color"})
in
    #"Removed Other Columns"

/*
* Day 7
* - Solution by @itsnotaboutthecell
*/
let
    Source = Sql.Database(Server, Database),
    dbo_DimEmployee = Source{[Schema="dbo",Item="DimEmployee"]}[Data],
    #"Non-Key Columns" = List.Select(Table.ColumnNames(dbo_DimEmployee), each  not Text.Contains(_, "Key", Comparer.Ordinal)),
    #"Removed Other Columns" = Table.SelectColumns(dbo_DimEmployee, #"Non-Key Columns")
in
    #"Removed Other Columns"

/*
* Day 8
* - Fold breaks at #"Calculated Days in Month"
*/
let
    Source = Sql.Database("localhost", "WideWorldImportersDW"),
    Fact_Sale = Source{[Schema="Fact",Item="Sale"]}[Data],
    #"Expanded Dimension.Date(Invoice Date Key)" = Table.ExpandRecordColumn(Fact_Sale, "Dimension.Date(Invoice Date Key)", {"Day Number"}, {"Day Number"}),
    #"Duplicated Column" = Table.DuplicateColumn(#"Expanded Dimension.Date(Invoice Date Key)", "Invoice Date Key", "Invoice Date Key - Copy"),
    #"Calculated Days in Month" = Table.TransformColumns(#"Duplicated Column",{{"Invoice Date Key - Copy", Date.DaysInMonth, Int64.Type}}),
    #"Added Conditional Column" = Table.AddColumn(#"Calculated Days in Month", "Custom", each if [#"Invoice Date Key - Copy"] = [Day Number] then true else false),
    #"Filtered Rows" = Table.SelectRows(#"Added Conditional Column", each ([Custom] = true)),
    #"Removed Other Columns" = Table.SelectColumns(#"Filtered Rows",{"Sale Key", "Customer Key", "Invoice Date Key", "Total Excluding Tax", "Tax Amount", "Profit"})
in
    #"Removed Other Columns"
