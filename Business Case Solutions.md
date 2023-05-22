# Business Case Solutions
This section provides Sql queries, steps and analysis in solving the business case questions provided by Danny.

## Questions and Solutions
**1.** What is the total amount each customer spent at the restaurant?

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

**2.** How many days has each customer visited the restaurant?

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

**3.** What was the first item from the menu purchased by each customer?

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

**4.** What is the most purchased item on the menu and how many times was it purchased by all customers?

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
















