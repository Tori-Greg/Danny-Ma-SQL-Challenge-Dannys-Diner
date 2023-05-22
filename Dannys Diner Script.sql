-- Firstly Create all tables

Create Table Sales
(Customer_id varchar(40),
Order_date date,
Product_id int)

Create Table Menu
(Product_id int,
Product_name varchar(40),
Price int)

Create Table Members
(Customer_id varchar(40),
Join_date Date

-- Afterwards Insert values into each table
--Sales 
Insert Into Sales Values
('A', '2021-01-01', '1'),
('A', '2021-01-01', '2'),
('A', '2021-01-07', '2'),
('A', '2021-01-10', '3'),
('A', '2021-01-11', '3'),
('A', '2021-01-11', '3'),
('B', '2021-01-01', '2'),
('B', '2021-01-02', '2'),
('B', '2021-01-04', '1'),
('B', '2021-01-11', '1'),
('B', '2021-01-16', '3'),
('B', '2021-02-01', '3'),
('C', '2021-01-01', '3'),
('C', '2021-01-01', '3'),
('C', '2021-01-07', '3')
 
 --Menu
Insert Into Menu Values
('1', 'sushi', '10'),
('2', 'curry', '15'),
('3', 'ramen', '12')

--Members
Insert into Members Values
('A', '2021-01-07'),
('B', '2021-01-09')

-- Questions??
--(1) What is the total amount each customer spent at the restaurant?
Select Customer_id, sum(Price) as Total_amount_spent
From DannySQLChallenge1..Sales
join DannySQLChallenge1..Menu
on sales.Product_id = Menu.Product_id
Group by Customer_id

--(2) How many days has each customer visited the restaurant?
Select Customer_id, count(distinct Order_date) as No_of_Days_Visted
from DannySQLChallenge1..Sales
Group by Customer_id

--(3) What was the first item from the menu purchased by each customer?
Select distinct(customer_id), Product_name, Order_date
from DannySQLChallenge1..Sales
join DannySQLChallenge1..Menu
on Sales.Product_id = Menu.Product_id
Where sales.Order_date = Any (select min(Order_date) from DannySQLChallenge1..Sales
Group by Customer_id)

--(4) What is the most purchased item on the menu and how many times was it purchased by all customers?
Select top (1) Product_name, count(product_name) as Frequency
from DannySQLChallenge1..Sales
join DannySQLChallenge1..Menu
on Sales.Product_id = Menu.Product_id
Group by Product_name
Order by Frequency desc

--(5)Which item was the most popular for each customer?
Select *
from(
	Select Customer_id, product_name, count(product_name) as popularity,
	Dense_rank() OVER (Partition by Customer_id Order by count(product_name) desc) as Rnk
	from DannySQLChallenge1..Sales
	join DannySQLChallenge1..Menu
	on Sales.Product_id = Menu.Product_id
	Group by Customer_id, product_name
) X
Where X.Rnk = 1

--(6) Which item was purchased first by the customer after they became a member?
Select * from
	(
	Select Sales.Customer_id, Order_date, product_name, Join_date, 
	DENSE_RANK() Over(Partition by Sales.customer_id  order by Order_date Asc) Rnk
	from DannySQLChallenge1..Sales
	join DannySQLChallenge1..Menu
	on Sales.Product_id = Menu.Product_id 
	join DannySQLChallenge1..Members
	on Sales.Customer_id = Members.Customer_id
	where Order_date >= Join_date
	)Entire
Where Entire.Rnk = 1

--(7) Which item was purchased just before the customer became a member?
Select * from
	(
	Select Sales.Customer_id, Order_date, product_name, Join_date, 
	DENSE_RANK() Over(Partition by Sales.customer_id  order by Order_date Asc) Rnk
	from DannySQLChallenge1..Sales
	join DannySQLChallenge1..Menu
	on Sales.Product_id = Menu.Product_id 
	join DannySQLChallenge1..Members
	on Sales.Customer_id = Members.Customer_id
	where Order_date < Join_date
	)Entire
Where Entire.Rnk = 1

--(8) What is the total items and amount spent for each member before they became a member?
Select Sales.Customer_id,Sum(Price) Total_amount, count(product_name) Total_Items 
from DannySQLChallenge1..Sales
join DannySQLChallenge1..Menu
on Sales.Product_id = Menu.Product_id 
join DannySQLChallenge1..Members
on Sales.Customer_id = Members.Customer_id
where Order_date < Join_date
Group by Sales.Customer_id

--(9) If each $1 spent equates to 10 points and sushi has a 2x points multiplier - how many points would each customer have?
Select Customer_id, sum(Points) from 
(
Select Sales.Customer_id, Product_name, Sum(Price) Total_amount, count(product_name) Total_Items,
CASE
	When Product_name = 'Sushi' Then Sum(price) * 20
	Else sum(price) * 10
End as Points
from DannySQLChallenge1..Sales
join DannySQLChallenge1..Menu
on Sales.Product_id = Menu.Product_id 
Group by Sales.Customer_id, Product_name
) Multiplier
Group by Customer_id

--(10) In the first week after a customer joins the program (including their join date) they earn 2x points
--     on all items, not just sushi - how many points do customer A and B have at the end of January?
  
Select Members.Customer_id,
Sum(Case
	When Order_date >= Join_date AND Order_date < DATEADD( Month, 1, Join_date)
	Then Price * 2
	Else 0
	End) as Points
from DannySQLChallenge1..Sales
join DannySQLChallenge1..Menu
on Sales.Product_id = Menu.Product_id 
join DannySQLChallenge1..Members
on Sales.Customer_id = Members.Customer_id
WHERE
 Members.customer_id IN ('A', 'B')
  AND MONTH(order_date) = MONTH(join_date)
  AND YEAR(order_date) = YEAR(join_date)
GROUP BY
  Members.customer_id


  -- *** Bonus Questions
  --(1)
Select Sales.Customer_id, Order_date, Product_name, Price,
Case When Order_date >= Join_date Then 'Y'
	Else 'N'
	End as 'Member'
from DannySQLChallenge1..Sales
Full Outer join DannySQLChallenge1..Menu
on Sales.Product_id = Menu.Product_id 
Full Outer join DannySQLChallenge1..Members
on Sales.Customer_id = Members.Customer_id

--(2) 
With CTE_Bonus2 as 
(
Select Sales.Customer_id, Order_date, Product_name, Price, 
Case When Order_date >= Join_date Then 'Y'
	Else 'N'
	End as 'Member'
from DannySQLChallenge1..Sales
Full Outer join DannySQLChallenge1..Menu
on Sales.Product_id = Menu.Product_id 
Full Outer join DannySQLChallenge1..Members
on Sales.Customer_id = Members.Customer_id
)
Select * ,
Case
	When Member = 'N' Then Null 
	Else Dense_RANK() Over(Partition by customer_id, Member  Order by Order_date)
	End as RNK
	From CTE_Bonus2

