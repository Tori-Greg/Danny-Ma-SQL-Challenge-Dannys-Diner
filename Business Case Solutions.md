# SQL Challenge Week 1 - Dannys Diner

## Business Case Solutions
This section provides Sql queries, steps and analysis in solving the business case questions provided by Danny.

## Questions and Solutions
**1.** **What is the total amount each customer spent at the restaurant?**

__Query:__

    Select Customer_id, sum(Price) as Total_amount_spent
    From Sales
    join Menu
    on Sales.Product_id = Menu.Product_id
    Group by Customer_id;
    
__Output:__

| Customer_id | Total_amount_spent |
| ----------- | ------------------ |
| A           | 76                 |
| B           | 74                 |
| C           | 36                 |

#### Steps:

This query retrieves data from the "Sales" and "Menu" tables and calculates the total amount spent by each customer. Here's an explanation of each part of the query:

- SELECT Customer_id, sum(Price) as Total_amount_spent: This part specifies the columns that will be included in the result set. It selects the "Customer_id" column from the Sales table and calculates the sum of the "Price" column from the Menu table for each customer. The alias "Total_amount_spent" is given to the calculated sum.

- FROM Sales join Menu: This clause specifies the tables that are involved in the query. It indicates that data will be retrieved from the "Sales" and "Menu" tables.

- ON Sales.Product_id = Menu.Product_id: This is the join condition that establishes the relationship between the "Sales" and "Menu" tables. It matches rows where the "Product_id" column in the "Sales" table is equal to the "Product_id" column in the "Menu" table.

- GROUP BY Customer_id: This clause groups the result set by the "Customer_id" column. It means that the calculation of the total amount spent will be performed for each unique customer.

**_As seen in the output the query calculates the total amount spent by each customer_**

---

**2.** **How many days has each customer visited the restaurant?**

__Query:__

    Select Customer_id, count(distinct Order_date) as No_of_Days_Visited
    from Sales
    Group by Customer_id;
    
__Output:__

| Customer_id | No_of_Days_Visited |
| ----------- | ------------------ |
| A           | 4                  |
| B           | 6                  |
| C           | 2                  |

#### Steps:

The query retrieves data from the "Sales" table and calculates the number of distinct days visited by each customer. It groups the result set by the "Customer_id" column and includes the customer ID and the corresponding count of distinct order dates as "No_of_Days_Visited" for each customer.

- SELECT Customer_id, count(distinct Order_date) as No_of_Days_Visited: This part of the query selects two columns. First, it selects the "Customer_id" column from the Sales table, which represents the unique identifier for each customer. Second, it calculates the count of distinct "Order_date" values for each customer. The alias "No_of_Days_Visited" is given to the calculated count.

- FROM Sales: This clause specifies the table from which data will be retrieved, which in this case is the "Sales" table.

- GROUP BY Customer_id: This clause groups the result set by the "Customer_id" column. It means that the count of distinct order dates will be calculated for each unique customer.

---

**3.** **What was the first item from the menu purchased by each customer?**

__Query:__

    Select distinct(customer_id), Product_name, Order_date
    from Sales
    join Menu
    on Sales.Product_id = Menu.Product_id
    Where Order_date = Any (select min(Order_date) 
    from Sales
    Group by Customer_id);

__Output:__

| customer_id | Order_date | Product_name |
| ----------- | ---------- | ------------ |
| A           | 2021-01-01 | sushi        |
| A           | 2021-01-01 | curry        |
| B           | 2021-01-01 | curry        |
| C           | 2021-01-01 | ramen        |

#### Steps:

This query combines data from the "Sales" and "Menu" tables based on the matching product IDs. It retrieves distinct customer IDs, product names, and order dates. The result set is filtered to include only the records where the order date matches the minimum order date for each customer. This query essentially selects the earliest order for each customer and retrieves the corresponding customer ID, product name, and order date.

- SELECT distinct(customer_id), Product_name, Order_date: This part of the query specifies the columns that will be included in the result set. It selects the distinct values of the "customer_id" column, the "Product_name" column, and the "Order_date" column.

- FROM Sales join Menu: This clause specifies the tables that are involved in the query. It indicates that data will be retrieved from the "Sales" and "Menu" tables.

- ON Sales.Product_id = Menu.Product_id: This is the join condition that establishes the relationship between the "Sales" and "Menu" tables. It matches rows where the "Product_id" column in the "Sales" table is equal to the "Product_id" column in the "Menu" table.

- WHERE Order_date = Any (select min(Order_date) from Sales Group by Customer_id): This is the WHERE clause that filters the result set. It specifies a condition where the "Order_date" must be equal to any of the minimum order dates for each customer. The subquery inside the parentheses calculates the minimum order date for each customer by grouping the "Sales" table by "Customer_id".

---

**4.** **What is the most purchased item on the menu and how many times was it purchased by all customers?**

__Query:__

    Select Product_name, count(product_name) as Frequency
    from Sales
    join Menu
    on Sales.Product_id = Menu.Product_id
    Group by Product_name
    Order by Frequency desc
    Limit 1;

__Output:__

| Product_name | Frequency |
| ------------ | --------- |
| ramen        | 8         |

#### Steps:

In summary, the query combines data from the "Sales" and "Menu" tables based on the matching product IDs. It calculates the frequency (count) of each product name in the sales data and retrieves the product name with the highest frequency. The result set will include the product name and its corresponding frequency, ordered in descending order of frequency. The LIMIT 1 clause ensures that only the top result is returned.

- SELECT Product_name, count(product_name) as Frequency: This part of the query specifies the columns that will be included in the result set. It selects the "Product_name" column from the Menu table and calculates the count of occurrences of each product name in the Sales table. The alias "Frequency" is given to the calculated count.

- FROM Sales join Menu: This clause specifies the tables that are involved in the query. It indicates that data will be retrieved from the "Sales" and "Menu" tables.

- ON Sales.Product_id = Menu.Product_id: This is the join condition that establishes the relationship between the "Sales" and "Menu" tables. It matches rows where the "Product_id" column in the Sales table is equal to the "Product_id" column in the Menu table.

- GROUP BY Product_name: This clause groups the result set by the "Product_name" column. It means that the count of occurrences will be calculated for each unique product name.

- ORDER BY Frequency desc: This clause specifies the ordering of the result set. It orders the rows in descending order based on the "Frequency" column, which represents the count of occurrences.

- LIMIT 1: This clause limits the result set to only one row. In this case, it retrieves the row with the highest frequency (count) of occurrences, as specified by the ORDER BY clause.


---

**5.** **Which item was the most popular for each customer?**

__Query:__

    Select Customer_id, Product_name, Popularity
    from(
    	Select Customer_id, Product_name, count(product_name) as Popularity,
    	Dense_rank() OVER (Partition by Customer_id Order by count(product_name) desc) as Rnk
    	from Sales
    	join Menu
    	on Sales.Product_id = Menu.Product_id
    	Group by Customer_id, product_name
    ) X
    Where X.Rnk = 1;
    
__Output:__

| Customer_id | Product_name | Popularity |
| ----------- | ------------ | ---------- |
| A           | ramen        | 3          |
| B           | curry        | 2          |
| B           | sushi        | 2          |
| B           | ramen        | 2          |
| C           | ramen        | 3          |

#### Steps:

The query combines data from the Sales and Menu tables based on the matching product IDs. It calculates the popularity (count) of each product for each customer, assigns ranks to the combinations of customer ID and product name, and selects only the records with the highest rank (i.e., the product with the highest count) for each customer. The result set includes the customer ID, product name, and popularity.

- The inner query starts with "Select Customer_id, Product_name, count(product_name) as Popularity." It retrieves the customer ID, product name, and counts the occurrences of each product name in the sales data. The alias "Popularity" is given to the calculated count.

- "Dense_rank() OVER (Partition by Customer_id Order by count(product_name) desc) as Rnk" is a window function used within the inner query. It assigns a rank to each combination of customer ID and product name based on the count of occurrences in descending order. The highest count will have a rank of 1.

- The inner query continues with "from Sales join Menu on Sales.Product_id = Menu.Product_id." It performs an inner join between the Sales and Menu tables based on the matching product IDs.

- The inner query also includes "Group by Customer_id, product_name." It groups the result set by customer ID and product name, allowing the count to be calculated for each unique combination.

- The inner query is then aliased as "X" to make it a subquery, and the outer query begins with "Select Customer_id, Product_name, Popularity from X." It selects the customer ID, product name, and popularity (count) columns from the subquery.

- "Where X.Rnk = 1" filters the result set by the rank column "Rnk" from the subquery. It only includes the records where the rank is equal to 1, meaning it selects the product with the highest count of occurrences for each customer.

---

**6.** **Which item was purchased first by the customer after they became a member?**

__Query:__

    Select * from
    	(
    	Select Sales.Customer_id, Order_date, product_name, Join_date, 
    	DENSE_RANK() Over(Partition by Sales.customer_id  order by Order_date Asc) Rnk
    	from Sales
    	join Menu
    	on Sales.Product_id = Menu.Product_id 
    	join Members
    	on Sales.Customer_id = Members.Customer_id
    	where Order_date >= Join_date
    	)Entire
    Where Entire.Rnk = 1;
    
__Output:__

| Customer_id | Order_date | product_name | Join_date  | Rnk |
| ----------- | ---------- | ------------ | ---------- | --- |
| A           | 2021-01-07 | curry        | 2021-01-07 | 1   |
| B           | 2021-01-11 | sushi        | 2021-01-09 | 1   |

**_The outcome indicates that only Customer A and Customer B are identified as members, while Customer C is not yet registered as a member._**

#### Steps:

The query combines data from the Sales, Menu, and Members tables. It retrieves the customer ID, order date, product name, and join date for each record where the order date is greater than or equal to the join date. The query assigns a dense rank to each combination of customer ID and order date, and then selects only the records with a rank of 1 (i.e., the earliest order) for each customer. The result set includes all columns from the selected records.

- The outer query starts with "Select * from (", which indicates that a subquery is being used as the source of the data for the outer query.

- The inner query begins with "Select Sales.Customer_id, Order_date, product_name, Join_date, DENSE_RANK() Over(Partition by Sales.customer_id order by Order_date Asc) Rnk." It selects several columns, including the customer ID, order date, product name, join date, and a calculated column called "Rnk" that assigns a dense rank to each combination of customer ID and order date. The dense rank is determined by ordering the rows within each customer ID group in ascending order of order date.

- The inner query continues with "from Sales join Menu on Sales.Product_id = Menu.Product_id join Members on Sales.Customer_id = Members.Customer_id." It performs three joins: Sales and Menu based on matching product IDs, and Sales and Members based on matching customer IDs. This allows the query to retrieve data from these three tables.

- "where Order_date >= Join_date" is the filtering condition in the inner query. It specifies that only records where the order date is greater than or equal to the join date should be included. The closing parentheses ")" denotes the end of the subquery and the start of the outer query.

- "Where Entire.Rnk = 1" is the final filtering condition in the outer query. It selects only the records from the subquery where the rank ("Rnk") is equal to 1, meaning it retains only the earliest order for each customer.

---

**7.** **Which item was purchased just before the customer became a member?**

__Query:__

    Select Customer_id, Product_name, Order_date, Join_date 
    from
    	(
    	Select Sales.Customer_id, Order_date, product_name, Join_date, 
    	DENSE_RANK() Over(Partition by Sales.customer_id  order by Order_date Asc) Rnk
    	from Sales
    	join Menu
    	on Sales.Product_id = Menu.Product_id 
    	join Members
    	on Sales.Customer_id = Members.Customer_id
    	where Order_date < Join_date
    	)Entire
    Where Entire.Rnk = 1;
    
__Output:__

| Customer_id | Product_name | Order_date | Join_date  |
| ----------- | ------------ | ---------- | ---------- |
| A           | sushi        | 2021-01-01 | 2021-01-07 |
| A           | curry        | 2021-01-01 | 2021-01-07 |
| B           | curry        | 2021-01-01 | 2021-01-09 |

#### Steps:

The query combines data from the Sales, Menu, and Members tables. It retrieves the customer ID, product name, order date, and join date for each record where the order date is earlier than the join date. The query assigns a dense rank to each combination of customer ID and order date, and then selects only the records with a rank of 1 (i.e., the earliest order) for each customer. The result set includes Customer_id, Product_name, Order_date, and Join_date columns from the selected records.

- The outer query starts with "Select Customer_id, Product_name, Order_date, Join_date from (", indicating that a subquery is being used as the source of the data for the outer query. The columns selected in the outer query include Customer_id, Product_name, Order_date, and Join_date.

- The inner query begins with "Select Sales.Customer_id, Order_date, product_name, Join_date, DENSE_RANK() Over(Partition by Sales.customer_id order by Order_date Asc) Rnk." It selects several columns, including the customer ID, order date, product name, join date, and a calculated column called "Rnk." The DENSE_RANK() function assigns a dense rank to each combination of customer ID and order date. The ranking is determined by ordering the rows within each customer ID group in ascending order of the order date. The inner query continues with "from Sales join Menu on Sales.Product_id = Menu.Product_id join Members on Sales.Customer_id = Members.Customer_id." It performs three joins: Sales and Menu based on matching product IDs, and Sales and Members based on matching customer IDs. This allows the query to retrieve data from these three tables.

- "where Order_date < Join_date" is the filtering condition in the inner query. It specifies that only records where the order date is earlier than the join date should be included. The closing parentheses ")" denotes the end of the subquery and the start of the outer query.

- "Where Entire.Rnk = 1" is the final filtering condition in the outer query. It selects only the records from the subquery where the rank ("Rnk") is equal to 1, meaning it retains only the earliest order for each customer.

---

**8.** **What is the total items and amount spent for each member before they became a member?**

__Query__

    Select Sales.Customer_id,Sum(Price) Total_amount, count(product_name) Total_Items 
    from Sales
    join Menu
    on Sales.Product_id = Menu.Product_id 
    join Members
    on Sales.Customer_id = Members.Customer_id
    where Order_date < Join_date
    Group by Sales.Customer_id
    Order by 1;

__Output:__

| Customer_id | Total_amount | Total_Items |
| ----------- | ------------ | ----------- |
| A           | 25           | 2           |
| B           | 40           | 3           |

#### Steps:

In summary, this query combines data from the Sales, Menu, and Members tables. It calculates the total amount spent by each customer ("Total_amount") based on the sum of prices in the Sales table, and it also calculates the total number of items purchased by each customer ("Total_Items") based on the count of product names. The query only considers records where the order date is earlier than the join date. The result set is grouped by customer ID and ordered by customer ID in ascending order.

- SELECT Sales.Customer_id, SUM(Price) AS Total_amount, COUNT(product_name) AS Total_Items: This part of the query selects three columns. First, it selects the "Customer_id" column from the Sales table. Second, it calculates the sum of the "Price" column and aliases it as "Total_amount". Third, it calculates the count of the "product_name" column and aliases it as "Total_Items".

- FROM Sales join Menu on Sales.Product_id = Menu.Product_id join Members on Sales.Customer_id = Members.Customer_id: This clause specifies the tables involved in the query and the join conditions. It joins the Sales table with the Menu table based on the matching product IDs and joins the resulting data with the Members table based on the matching customer IDs.

- WHERE Order_date < Join_date: This is the filtering condition that specifies that only records where the order date is earlier than the join date should be included in the query result.

- GROUP BY Sales.Customer_id: This clause groups the result set by the "Customer_id" column. It means that the subsequent calculations (sum and count) will be performed for each unique customer ID.

- ORDER BY 1: This clause orders the result set by the first column, which is "Sales.Customer_id", in ascending order.

---

**9.** **If each $1 spent equates to 10 points and sushi has a 2x points multiplier - how many points would each customer have?**

__Query:__

    Select Customer_id, sum(Points)Points from 
    (
    Select Sales.Customer_id, Product_name, Sum(Price) Total_amount, count(product_name) Total_Items,
    CASE
    	When Product_name = 'Sushi' Then Sum(price) * 20
    	Else sum(price) * 10
    End as Points
    from Sales
    join Menu
    on Sales.Product_id = Menu.Product_id 
    Group by Sales.Customer_id, Product_name
    ) Multiplier
    Group by Customer_id;

__Output:__

| Customer_id | Points |
| ----------- | ------ |
| A           | 860    |
| B           | 940    |
| C           | 360    |

#### Steps:

The query combines data from the Sales and Menu tables. It calculates the total amount spent and the total number of items purchased for each customer and product combination. Additionally, it calculates the points for each combination based on a conditional statement. The outer query then groups the result set by customer ID and calculates the sum of points for each customer. The result set includes the customer ID and the total sum of points for each customer.

- The outer query starts with "SELECT Customer_id, SUM(Points) Points from (", indicating that a subquery is being used as the source of the data for the outer query. The columns selected in the outer query include Customer_id and the sum of Points.

- The inner query begins with "SELECT Sales.Customer_id, Product_name, SUM(Price) Total_amount, COUNT(product_name) Total_Items, CASE When Product_name = 'Sushi' Then SUM(price) * 20 Else SUM(price) * 10 End as Points." It selects several columns, including the customer ID, product name, total amount (sum of prices), total items (count of product names), and a calculated column called "Points." The Points column is determined based on a conditional statement (CASE). If the product name is 'Sushi', the sum of the price is multiplied by 20; otherwise, it is multiplied by 10.

- The inner query continues with "FROM Sales JOIN Menu ON Sales.Product_id = Menu.Product_id." It performs an inner join between the Sales and Menu tables based on the matching product IDs. This allows the query to retrieve data from these two tables.

- "GROUP BY Sales.Customer_id, Product_name" groups the result set by the customer ID and product name. It means that the subsequent calculations and conditional statements will be performed for each unique combination of customer ID and product name. The closing parentheses ")" denotes the end of the subquery and the start of the outer query.

- "GROUP BY Customer_id" in the outer query groups the result set by customer ID. It combines the data for each customer and prepares for the sum calculation.

---

**10.** **In the first week after a customer joins the program (including their join date) they earn 2x points on all items, not just sushi - how many points do customer A and B have at the end of January?**

__Query:__

    SELECT Members.Customer_id,
        SUM(CASE
            WHEN Order_date >= Join_date AND Order_date < DATE_ADD(Join_date, INTERVAL 1 MONTH)
            THEN Price * 2
            ELSE 0
        END) AS Points
    FROM Sales
    JOIN Menu ON Sales.Product_id = Menu.Product_id
    JOIN Members ON Sales.Customer_id = Members.Customer_id
    WHERE Members.customer_id IN ('A', 'B')
        AND MONTH(order_date) = MONTH(join_date)
        AND YEAR(order_date) = YEAR(join_date)
    GROUP BY Members.customer_id
    Order by 1;
    
__Output:__

| Customer_id | Points |
| ----------- | ------ |
| A           | 102    |
| B           | 44     |

#### Steps:

The query retrieves the total points earned by customers 'A' and 'B' within a specific month based on their order history. It calculates the total points earned by customers 'A' and 'B' for a specific month. It considers the order date, join date, and price information from the Sales, Menu, and Members tables. The points are calculated based on specific conditions and then summed up for each customer. The result set is ordered by the customer ID in ascending order.

- The SELECT statement specifies the columns to be included in the result set. In this case, it selects the Customer_id from the Members table and calculates the sum of points using a CASE statement.

- The CASE statement evaluates each row in the Sales table. If the order date falls within the same month as the join date (for the respective customer), the points are calculated as Price * 2. Otherwise, the points are set to 0. The query joins the Sales, Menu, and Members tables using the specified join conditions to retrieve the necessary data.

- The WHERE clause filters the result set to include only customers 'A' and 'B' and ensures that the order date and join date are in the same month and year.

- The GROUP BY clause groups the result set by the customer ID to calculate the sum of points for each customer.

- The ORDER BY clause sorts the result set in ascending order based on the customer ID.

---
### Business Solutions

To assist Danny in gaining a deeper understanding of his customers' needs and desires and making well-informed decisions for his restaurant, we can provide the following business solutions:

- Customer Segmentation: Analyze the customer data to segment customers based on various factors such as demographics, ordering preferences, frequency of visits, and average spending. This will help Danny understand different customer groups and tailor marketing strategies and menu offerings to meet their specific needs.

- Menu Analysis: Analyze the popularity and profitability of each menu item (sushi, curry, ramen) to identify the best-selling items and any underperforming dishes. This analysis can help Danny make informed decisions about menu pricing, specials, and potential menu expansions or modifications.

- Loyalty Program Evaluation: Review the current customer loyalty program to assess its effectiveness and impact on customer retention and satisfaction. Analyze customer data to determine the program's usage, benefits, and customer engagement. Based on the findings, recommend potential enhancements or changes to improve the program's effectiveness.

- Customer Feedback Analysis: Gather and analyze customer feedback through surveys, reviews, or social media to understand customer preferences, satisfaction levels, and areas for improvement. This feedback can provide valuable insights for enhancing the dining experience, improving service quality, and addressing any customer concerns.

**_By implementing these solutions, Danny can gain valuable insights about his customers, make data-driven decisions, and improve the overall performance and success of Danny's Diner._**
