-- Day 1
select [_].[EmployeeKey] as [EmployeeKey],
    convert(nvarchar(max), [_].[FullName]) as [FullName],
    [_].[BirthDate] as [BirthDate],
    [_].[Gender] as [Gender]
from 
(
    select [_].[EmployeeKey] as [EmployeeKey],
        [_].[FirstName] as [FirstName],
        [_].[LastName] as [LastName],
        [_].[MiddleName] as [MiddleName],
        [_].[BirthDate] as [BirthDate],
        [_].[Gender] as [Gender],
        [_].[t0_0] as [t0_0],
        ((([_].[FirstName] + (case
            when [_].[t0_0] <> '' or [_].[t0_0] is null
            then ' '
            else ''
        end)) + [_].[t0_0]) + ' ') + [_].[LastName] as [FullName]
    from 
    (
        select [_].[EmployeeKey] as [EmployeeKey],
            [_].[FirstName] as [FirstName],
            [_].[LastName] as [LastName],
            [_].[MiddleName] as [MiddleName],
            [_].[BirthDate] as [BirthDate],
            [_].[Gender] as [Gender],
            case
                when [_].[MiddleName] is null
                then ''
                else [_].[MiddleName]
            end as [t0_0]
        from 
        (
            select [_].[EmployeeKey],
                [_].[FirstName],
                [_].[LastName],
                [_].[MiddleName],
                [_].[BirthDate],
                [_].[Gender]
            from 
            (
                select [_].[EmployeeKey] as [EmployeeKey],
                    [_].[ParentEmployeeKey] as [ParentEmployeeKey],
                    [_].[EmployeeNationalIDAlternateKey] as [EmployeeNationalIDAlternateKey],
                    [_].[ParentEmployeeNationalIDAlternateKey] as [ParentEmployeeNationalIDAlternateKey],
                    [_].[SalesTerritoryKey] as [SalesTerritoryKey],
                    [_].[FirstName] as [FirstName],
                    [_].[LastName] as [LastName],
                    [_].[MiddleName] as [MiddleName],
                    [_].[NameStyle] as [NameStyle],
                    [_].[Title] as [Title],
                    [_].[HireDate] as [HireDate],
                    [_].[BirthDate] as [BirthDate],
                    [_].[LoginID] as [LoginID],
                    [_].[EmailAddress] as [EmailAddress],
                    [_].[Phone] as [Phone],
                    [_].[MaritalStatus] as [MaritalStatus],
                    [_].[EmergencyContactName] as [EmergencyContactName],
                    [_].[EmergencyContactPhone] as [EmergencyContactPhone],
                    [_].[SalariedFlag] as [SalariedFlag],
                    [_].[Gender] as [Gender],
                    [_].[PayFrequency] as [PayFrequency],
                    [_].[BaseRate] as [BaseRate],
                    [_].[VacationHours] as [VacationHours],
                    [_].[SickLeaveHours] as [SickLeaveHours],
                    [_].[CurrentFlag] as [CurrentFlag],
                    [_].[SalesPersonFlag] as [SalesPersonFlag],
                    [_].[DepartmentName] as [DepartmentName],
                    [_].[StartDate] as [StartDate],
                    [_].[EndDate] as [EndDate],
                    [_].[Status] as [Status],
                    datepart("yyyy", [_].[BirthDate]) as [Year]
                from 
                (
                    select [EmployeeKey],
                        [ParentEmployeeKey],
                        [EmployeeNationalIDAlternateKey],
                        [ParentEmployeeNationalIDAlternateKey],
                        [SalesTerritoryKey],
                        [FirstName],
                        [LastName],
                        [MiddleName],
                        [NameStyle],
                        [Title],
                        [HireDate],
                        [BirthDate],
                        [LoginID],
                        [EmailAddress],
                        [Phone],
                        [MaritalStatus],
                        [EmergencyContactName],
                        [EmergencyContactPhone],
                        [SalariedFlag],
                        [Gender],
                        [PayFrequency],
                        [BaseRate],
                        [VacationHours],
                        [SickLeaveHours],
                        [CurrentFlag],
                        [SalesPersonFlag],
                        [DepartmentName],
                        [StartDate],
                        [EndDate],
                        [Status]
                    from [dbo].[DimEmployee] as [$Table]
                ) as [_]
            ) as [_]
            where [_].[Year] = 1974 and [_].[Year] is not null
        ) as [_]
    ) as [_]
) as [_];

-- Day 2 - Resellers
select [_].[ResellerKey],
    [_].[BusinessType],
    [_].[ResellerName],
    [_].[NumberEmployees],
    [_].[ProductLine],
    [_].[AnnualRevenue],
    [_].[CountryRegionCode]
from 
(
    select [$Outer].[ResellerKey],
        [$Outer].[GeographyKey2],
        [$Outer].[BusinessType],
        [$Outer].[ResellerName],
        [$Outer].[NumberEmployees],
        [$Outer].[ProductLine],
        [$Outer].[AnnualRevenue],
        [$Inner].[CountryRegionCode]
    from 
    (
        select [_].[ResellerKey] as [ResellerKey],
            [_].[GeographyKey] as [GeographyKey2],
            [_].[BusinessType] as [BusinessType],
            [_].[ResellerName] as [ResellerName],
            [_].[NumberEmployees] as [NumberEmployees],
            [_].[ProductLine] as [ProductLine],
            [_].[AnnualRevenue] as [AnnualRevenue]
        from [dbo].[DimReseller] as [_]
        where ([_].[ResellerName] like '%Bike%') or ([_].[ResellerName] like '%Bicycle%')
    ) as [$Outer]
    left outer join [dbo].[DimGeography] as [$Inner] on ([$Outer].[GeographyKey2] = [$Inner].[GeographyKey])
) as [_]
where ([_].[CountryRegionCode] <> 'DE' or [_].[CountryRegionCode] is null) and ([_].[CountryRegionCode] <> 'GB' or [_].[CountryRegionCode] is null);

-- Day 3
select [_].[ProductKey2] as [ProductKey],
    [_].[EnglishProductName] as [EnglishProductName],
    [_].[Total Revenue] as [Total Revenue]
from 
(
    select [rows].[ProductKey2] as [ProductKey2],
        [rows].[EnglishProductName] as [EnglishProductName],
        sum([rows].[TotalProductCost]) as [Total Revenue]
    from 
    (
        select [$Outer].[ProductKey2],
            [$Outer].[OrderDateKey],
            [$Outer].[DueDateKey],
            [$Outer].[ShipDateKey],
            [$Outer].[ResellerKey],
            [$Outer].[EmployeeKey],
            [$Outer].[PromotionKey],
            [$Outer].[CurrencyKey],
            [$Outer].[SalesTerritoryKey],
            [$Outer].[SalesOrderNumber],
            [$Outer].[SalesOrderLineNumber],
            [$Outer].[RevisionNumber],
            [$Outer].[OrderQuantity],
            [$Outer].[UnitPrice],
            [$Outer].[ExtendedAmount],
            [$Outer].[UnitPriceDiscountPct],
            [$Outer].[DiscountAmount],
            [$Outer].[ProductStandardCost],
            [$Outer].[TotalProductCost],
            [$Outer].[SalesAmount],
            [$Outer].[TaxAmt],
            [$Outer].[Freight],
            [$Outer].[CarrierTrackingNumber],
            [$Outer].[CustomerPONumber],
            [$Outer].[OrderDate],
            [$Outer].[DueDate],
            [$Outer].[ShipDate],
            [$Outer].[TotalUnitPrice],
            [$Inner].[EnglishProductName]
        from 
        (
            select [_].[ProductKey] as [ProductKey2],
                [_].[OrderDateKey] as [OrderDateKey],
                [_].[DueDateKey] as [DueDateKey],
                [_].[ShipDateKey] as [ShipDateKey],
                [_].[ResellerKey] as [ResellerKey],
                [_].[EmployeeKey] as [EmployeeKey],
                [_].[PromotionKey] as [PromotionKey],
                [_].[CurrencyKey] as [CurrencyKey],
                [_].[SalesTerritoryKey] as [SalesTerritoryKey],
                [_].[SalesOrderNumber] as [SalesOrderNumber],
                [_].[SalesOrderLineNumber] as [SalesOrderLineNumber],
                [_].[RevisionNumber] as [RevisionNumber],
                [_].[OrderQuantity] as [OrderQuantity],
                [_].[UnitPrice] as [UnitPrice],
                [_].[ExtendedAmount] as [ExtendedAmount],
                [_].[UnitPriceDiscountPct] as [UnitPriceDiscountPct],
                [_].[DiscountAmount] as [DiscountAmount],
                [_].[ProductStandardCost] as [ProductStandardCost],
                [_].[TotalProductCost] as [TotalProductCost],
                [_].[SalesAmount] as [SalesAmount],
                [_].[TaxAmt] as [TaxAmt],
                [_].[Freight] as [Freight],
                [_].[CarrierTrackingNumber] as [CarrierTrackingNumber],
                [_].[CustomerPONumber] as [CustomerPONumber],
                [_].[OrderDate] as [OrderDate],
                [_].[DueDate] as [DueDate],
                [_].[ShipDate] as [ShipDate],
                [_].[OrderQuantity] * [_].[UnitPrice] as [TotalUnitPrice]
            from [dbo].[FactResellerSales] as [_]
        ) as [$Outer]
        left outer join [dbo].[DimProduct] as [$Inner] on ([$Outer].[ProductKey2] = [$Inner].[ProductKey])
    ) as [rows]
    group by [ProductKey2],
        [EnglishProductName]
) as [_]
where [_].[Total Revenue] > 1000000;

-- Day 4
select [_].[Order Key],
    [_].[Description]
from 
(
    select [_].[Order Key] as [Order Key],
        [_].[City Key] as [City Key],
        [_].[Customer Key] as [Customer Key],
        [_].[Stock Item Key] as [Stock Item Key],
        [_].[Order Date Key] as [Order Date Key],
        [_].[Picked Date Key] as [Picked Date Key],
        [_].[Salesperson Key] as [Salesperson Key],
        [_].[Picker Key] as [Picker Key],
        [_].[WWI Order ID] as [WWI Order ID],
        [_].[WWI Backorder ID] as [WWI Backorder ID],
        [_].[Description] as [Description],
        [_].[Package] as [Package],
        [_].[Quantity] as [Quantity],
        [_].[Unit Price] as [Unit Price],
        [_].[Tax Rate] as [Tax Rate],
        [_].[Total Excluding Tax] as [Total Excluding Tax],
        [_].[Tax Amount] as [Tax Amount],
        [_].[Total Including Tax] as [Total Including Tax],
        [_].[Lineage Key] as [Lineage Key],
        [_].[Length] % 10 as [t0_0]
    from 
    (
        select [_].[Order Key] as [Order Key],
            [_].[City Key] as [City Key],
            [_].[Customer Key] as [Customer Key],
            [_].[Stock Item Key] as [Stock Item Key],
            [_].[Order Date Key] as [Order Date Key],
            [_].[Picked Date Key] as [Picked Date Key],
            [_].[Salesperson Key] as [Salesperson Key],
            [_].[Picker Key] as [Picker Key],
            [_].[WWI Order ID] as [WWI Order ID],
            [_].[WWI Backorder ID] as [WWI Backorder ID],
            [_].[Description] as [Description],
            [_].[Package] as [Package],
            [_].[Quantity] as [Quantity],
            [_].[Unit Price] as [Unit Price],
            [_].[Tax Rate] as [Tax Rate],
            [_].[Total Excluding Tax] as [Total Excluding Tax],
            [_].[Tax Amount] as [Tax Amount],
            [_].[Total Including Tax] as [Total Including Tax],
            [_].[Lineage Key] as [Lineage Key],
            len(replace([_].[Description], ' ', '*')) as [Length]
        from [Fact].[Order] as [_]
    ) as [_]
) as [_]
where [_].[t0_0] = 1 and [_].[t0_0] is not null;

-- Day 6
select [_].[Stock Item Key],
    [_].[Stock Item],
    [_].[Color]
from 
(
    select [_].[Stock Item Key] as [Stock Item Key],
        [_].[WWI Stock Item ID] as [WWI Stock Item ID],
        [_].[Stock Item] as [Stock Item],
        [_].[Color] as [Color],
        [_].[Selling Package] as [Selling Package],
        [_].[Buying Package] as [Buying Package],
        [_].[Brand] as [Brand],
        [_].[Size] as [Size],
        [_].[Lead Time Days] as [Lead Time Days],
        [_].[Quantity Per Outer] as [Quantity Per Outer],
        [_].[Is Chiller Stock] as [Is Chiller Stock],
        [_].[Barcode] as [Barcode],
        [_].[Tax Rate] as [Tax Rate],
        [_].[Unit Price] as [Unit Price],
        [_].[Recommended Retail Price] as [Recommended Retail Price],
        [_].[Typical Weight Per Unit] as [Typical Weight Per Unit],
        [_].[Photo] as [Photo],
        [_].[Valid From] as [Valid From],
        [_].[Valid To] as [Valid To],
        [_].[Lineage Key] as [Lineage Key],
        convert(nvarchar(max), [_].[DivisibleBy2]) as [t0_0]
    from 
    (
        select [_].[Stock Item Key] as [Stock Item Key],
            [_].[WWI Stock Item ID] as [WWI Stock Item ID],
            [_].[Stock Item] as [Stock Item],
            [_].[Color] as [Color],
            [_].[Selling Package] as [Selling Package],
            [_].[Buying Package] as [Buying Package],
            [_].[Brand] as [Brand],
            [_].[Size] as [Size],
            [_].[Lead Time Days] as [Lead Time Days],
            [_].[Quantity Per Outer] as [Quantity Per Outer],
            [_].[Is Chiller Stock] as [Is Chiller Stock],
            [_].[Barcode] as [Barcode],
            [_].[Tax Rate] as [Tax Rate],
            [_].[Unit Price] as [Unit Price],
            [_].[Recommended Retail Price] as [Recommended Retail Price],
            [_].[Typical Weight Per Unit] as [Typical Weight Per Unit],
            [_].[Photo] as [Photo],
            [_].[Valid From] as [Valid From],
            [_].[Valid To] as [Valid To],
            [_].[Lineage Key] as [Lineage Key],
            convert(decimal(38,6), [_].[Stock Item Key]) / convert(decimal(38,6), 2) as [DivisibleBy2]
        from 
        (
            select [_].[Stock Item Key],
                [_].[WWI Stock Item ID],
                [_].[Stock Item],
                [_].[Color],
                [_].[Selling Package],
                [_].[Buying Package],
                [_].[Brand],
                [_].[Size],
                [_].[Lead Time Days],
                [_].[Quantity Per Outer],
                [_].[Is Chiller Stock],
                [_].[Barcode],
                [_].[Tax Rate],
                [_].[Unit Price],
                [_].[Recommended Retail Price],
                [_].[Typical Weight Per Unit],
                [_].[Photo],
                [_].[Valid From],
                [_].[Valid To],
                [_].[Lineage Key]
            from [Dimension].[Stock Item] as [_]
            where [_].[Color] <> 'N/A'
        ) as [_]
    ) as [_]
) as [_]
where not ([_].[t0_0] like '%.5%');
