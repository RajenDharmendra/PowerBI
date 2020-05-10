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
  Source                       = Sql.Databases("localhost"),
  AdventureWorksDW2017         = Source{[Name = "AdventureWorksDW2017"]}[Data],
  dbo_DimEmployee              = AdventureWorksDW2017{[Schema = "dbo", Item = "DimEmployee"]}[Data],
// Use merge columns to concatenate names
  #"Merged Columns"            = Table.CombineColumns(
    dbo_DimEmployee, 
    {"FirstName", "MiddleName"}, 
    Combiner.CombineTextByDelimiter(" ", QuoteStyle.None), 
    "Merged"
  ),
  #"Merged Columns1"           = Table.CombineColumns(
    #"Merged Columns", 
    {"Merged", "LastName"}, 
    Combiner.CombineTextByDelimiter(" ", QuoteStyle.None), 
    "FullName"
  ),
// Replace double spaces resulting from no middle names
  #"Replaced Value"            = Table.ReplaceValue(
    #"Merged Columns1", 
    "  ", 
    " ", 
    Replacer.ReplaceText, 
    {"FullName"}
  ),
// Select only the necessary columns
  #"Removed Other Columns"     = Table.SelectColumns(
    #"Replaced Value", 
    {"EmployeeKey", "FullName", "BirthDate", "Gender"}
  ),
// Duplicate BirthDate so we can split by '/'
  #"Duplicated Column"         = Table.DuplicateColumn(
    #"Removed Other Columns", 
    "BirthDate", 
    "BirthDate - Copy"
  ),

  #"Split Column by Delimiter" = Table.SplitColumn(
    Table.TransformColumnTypes(#"Duplicated Column", {{"BirthDate - Copy", type text}}, "en-US"), 
    "BirthDate - Copy", 
    Splitter.SplitTextByEachDelimiter({"/"}, QuoteStyle.Csv, true), 
    {"BirthDate - Copy.1", "BirthDate - Copy.2"}
  ),
// Select only the people born in 1974
  #"Filtered Rows"             = Table.SelectRows(
    #"Split Column by Delimiter", 
    each ([#"BirthDate - Copy.2"] = "1974")
  ),
// Remove helper columns
  #"Removed Columns"           = Table.RemoveColumns(
    #"Filtered Rows", 
    {"BirthDate - Copy.1", "BirthDate - Copy.2"}
  )
in
  #"Removed Columns"

/*
* Day 2
*/
let
  Source                               = Sql.Databases("localhost"),
  AdventureWorksDW2017                 = Source{[Name = "AdventureWorksDW2017"]}[Data],
  dbo_DimReseller                      = AdventureWorksDW2017{[Schema = "dbo", Item = "DimReseller"]}[Data],

  #"Reseller contains Bike or Bicycle" = Table.SelectRows(
    dbo_DimReseller, 
    each Text.Contains([ResellerName], "Bike") or Text.Contains([ResellerName], "Bicycle")
  ),
// Remove columns we're not interested in
  #"Removed Other Columns"             = Table.SelectColumns(
    #"Reseller contains Bike or Bicycle", 
    {
      "ResellerKey", 
      "BusinessType", 
      "ResellerName", 
      "NumberEmployees", 
      "ProductLine", 
      "AnnualRevenue", 
      "DimGeography"
    }
  ),
// Use the nested table
  #"Expanded DimGeography"             = Table.ExpandRecordColumn(
    #"Removed Other Columns", 
    "DimGeography", 
    {"CountryRegionCode"}, 
    {"CountryRegionCode"}
  ),
// Exclude DE and GB from our selection
  #"Filtered Rows <> DE || GB"         = Table.SelectRows(
    #"Expanded DimGeography", 
    each ([CountryRegionCode] <> "DE" and [CountryRegionCode] <> "GB")
  )
in
  #"Filtered Rows <> DE || GB"

/*
* Day 3
*/
let
  Source                   = Sql.Database(SQLServer, AW2017),
  dbo_FactResellerSales    = Source{[Schema = "dbo", Item = "FactResellerSales"]}[Data],
// Calculate TotalUnitPrice
  #"Added Custom"          = Table.AddColumn(
    dbo_FactResellerSales, 
    "TotalUnitPrice", 
    each [OrderQuantity] * [UnitPrice]
  ),
  #"Changed Type"          = Table.TransformColumnTypes(
    #"Added Custom", 
    {{"TotalUnitPrice", Currency.Type}}
  ),
// LeftOuter join - FactResekkerSales as left table
  #"Merged Queries"        = Table.NestedJoin(
    #"Changed Type", 
    {"ProductKey"}, 
    DimProduct, 
    {"ProductKey"}, 
    "DimProduct.1", 
    JoinKind.LeftOuter
  ),
// Expand only the EnglishProductName column
  #"Expanded DimProduct.1" = Table.ExpandTableColumn(
    #"Merged Queries", 
    "DimProduct.1", 
    {"EnglishProductName"}, 
    {"EnglishProductName"}
  ),
// Group by ProductKey & EnglishProductName, Sum of TotalProductCost
  #"Grouped Rows"          = Table.Group(
    #"Expanded DimProduct.1", 
    {"ProductKey", "EnglishProductName"}, 
    {{"Total Revenue", each List.Sum([TotalProductCost]), type number}}
  ),
// We're only interested in products with over a million in revenue
  #"Filtered Rows"         = Table.SelectRows(#"Grouped Rows", each [Total Revenue] > 1000000),
  #"Changed Type1"         = Table.TransformColumnTypes(
    #"Filtered Rows", 
    {{"Total Revenue", Currency.Type}}
  )
in
  #"Changed Type1"

/*
* Day 4
*/
let
  Source                   = Sql.Database(SQLServer, WWI),
  Fact_Order               = Source{[Schema = "Fact", Item = "Order"]}[Data],
// Calculate the length of the description
  #"Inserted Text Length"  = Table.AddColumn(
    Fact_Order, 
    "Length", 
    each Text.Length([Description]), 
    Int64.Type
  ),
// Calculate Modulo of each description length
  #"Calculated Modulo"     = Table.TransformColumns(
    #"Inserted Text Length", 
    {{"Length", each Number.Mod(_, 10), type number}}
  ),
// Select only the ones = 1
  #"Filtered Rows"         = Table.SelectRows(#"Calculated Modulo", each ([Length] = 1)),
// Keep only the columns we're interested in
  #"Removed Other Columns" = Table.SelectColumns(#"Filtered Rows", {"Order Key", "Description"})
in
  #"Removed Other Columns"