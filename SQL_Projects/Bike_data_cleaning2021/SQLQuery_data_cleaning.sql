select * from portfolio_project.dbo.[uncleaned bike sales data]

--remove the unwanted Year column

alter table portfolio_project.dbo.[uncleaned bike sales data]
drop column [Year]

--remove the month,bikes and sub category column 
alter table portfolio_project.dbo.[uncleaned bike sales data]
drop column [Month] , Product_Category, Sub_Category


--Now the data after removal of all unwanted columns

select * from portfolio_project.dbo.[uncleaned bike sales data]

--check for duplicate values and remove them
WITH duplicate AS (
    SELECT *,
        ROW_NUMBER() OVER (
            PARTITION BY
                Sales_Order, [Date], [Day], Customer_Age, Age_Group, Customer_Gender, Country, [State],
                Product_Description, Order_Quantity, Unit_Cost, Unit_Price, Profit, Cost, Revenue
            ORDER BY (SELECT NULL) -- This should be inside the OVER() clause
        ) AS rn
    FROM portfolio_project.dbo.[uncleaned bike sales data]
)
   

   --delete the duplicate

   --Delete from duplicate
   --where rn> 1

   --Now check for duplicate
   select * from duplicate
   where rn > 1

--Now check the data
select * from portfolio_project.dbo.[uncleaned bike sales data]

--now change the data one null value is there and sales order tw same value we need to chane it

--identify row number and change the value of sales order

select ROW_NUMBER() over (order by Sales_Order) as rn, *
from portfolio_project.dbo.[uncleaned bike sales data]

--check for the data type of each column

select * from portfolio_project.dbo.[uncleaned bike sales data]
--Sales order= int, Day= tiny int

--now change the value of sales order and update null value to 5

update portfolio_project.dbo.[uncleaned bike sales data]
set Sales_Order = 261696
where Sales_Order= 261695 and Customer_Gender ='M'

update portfolio_project.dbo.[uncleaned bike sales data]
set Age_Group = 'Adults (35-64)'
where Sales_Order= 261709

update portfolio_project.dbo.[uncleaned bike sales data]
set Product_Description = 'Mountain-200 Black, 42'
where Sales_Order= 261715



select * from portfolio_project.dbo.[uncleaned bike sales data]

--find the order quantity and replace the null value

q=1, uc=1266,up=2320,p=1054,c=1266, revenue=2320

up=uc+p
uc=q*amount
c=uc *q
p+c=revenue

update portfolio_project.dbo.[uncleaned bike sales data]
set  Cost= 2504.00, Unit_Cost= 1252.00
where Sales_Order= 261699

update portfolio_project.dbo.[uncleaned bike sales data]
set Revenue= 3076.00, Unit_Price= 769.00
where Sales_Order= 261702

--after filling null values and droping columns the final data set
select * from portfolio_project.dbo.[uncleaned bike sales data]