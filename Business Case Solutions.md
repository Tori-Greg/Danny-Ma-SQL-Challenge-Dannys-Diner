# Business Case Solutions
This section provides Sql queries, steps and analysis in solving the business case questions provided by Danny.

## Questions and Solutions
**1.** What is the total amount each customer spent at the restaurant?

__Query__

    Select Customer_id, sum(Price) as Total_amount_spent
    From Sales
    join Menu
    on Sales.Product_id = Menu.Product_id
    Group by Customer_id;
    
__Output__

| Customer_id | Total_amount_spent |
| ----------- | ------------------ |
| A           | 76                 |
| B           | 74                 |
| C           | 36                 |

---

#### Steps

This query retrieves data from the "Sales" and "Menu" tables and calculates the total amount spent by each customer. Here's an explanation of each part of the query:

- SELECT Customer_id, sum(Price) as Total_amount_spent: This part specifies the columns that will be included in the result set. It selects the "Customer_id" column from the Sales table and calculates the sum of the "Price" column from the Menu table for each customer. The alias "Total_amount_spent" is given to the calculated sum.

- FROM Sales join Menu: This clause specifies the tables that are involved in the query. It indicates that data will be retrieved from the "Sales" and "Menu" tables.

- ON Sales.Product_id = Menu.Product_id: This is the join condition that establishes the relationship between the "Sales" and "Menu" tables. It matches rows where the "Product_id" column in the "Sales" table is equal to the "Product_id" column in the "Menu" table.

- GROUP BY Customer_id: This clause groups the result set by the "Customer_id" column. It means that the calculation of the total amount spent will be performed for each unique customer.

**_As seen in the output the query calculates the total amoount spent by each customer_**

