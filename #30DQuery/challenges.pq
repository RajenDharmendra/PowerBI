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