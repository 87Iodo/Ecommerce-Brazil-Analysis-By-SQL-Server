# An Analysis on Brazilian E-Commerce Dataset with Microsoft SQL Server

## Table of Contents

- [Project Overview](#project-overview)
- [Data Sources](#data-sources)
- [Tools](#tools)
- [Process](#process)
- [Part 1: Adding New Table](#part-1-adding-new-table)
- [Part 2: Writing 10 Queries to Extract Information and Insights](#part-2-writing-10-queries-to-extract-information-and-insights)
- [Part 3: Putting Quaries into A Procedure](#part-3-putting-quaries-into-a-procedure)
- [Executing Procedure](#executing-procedure)
- [Limitations](#limitations)
- [References](#references)

### Project Overview

This goal of this project is to create a procedure of 10 queries in sql server that will allow users without sql knowledge to extract information, trends, and insights from datasets with just a simple prompt.

### Data Sources

E-Commerce Data: The dataset has information of 100k orders from 2016 to 2018 made at multiple marketplaces in Brazil. There are in total 8 csv files including customers, geolocation, order_items, order_payments, order-reviews, orders, products and sellers. Its features allow viewing an order from multiple dimensions: from order status, price, payment and freight performance to customer location, product attributes and finally reviews written by customers.

### Tools

- Microsoft SQL Server

### Process

The project is basically divided into 3 parts:
1. Adding new table for better analysis
2. Writing queries for 10 questions that will provide insights to the datasets
3. Putting queries into a procedure 

### Part 1: Adding New Table

The product category description in the dataset is in Portuguese. A table of English translation is created based on the products available in the dataset.

- Create an empty 'product_category_name_translation' table
- Insert available product categories in Portuguese from 'products' dataset into the empty table
- Create a temporary table with all the Engish translation of the product categories.
- Update the 'product_category_name_translation' table by joining it with English translation table

![image](https://github.com/87Iodo/Shopee-Brazil-Analysis-By-SQL-Server/assets/143507039/3b584ddf-6ab7-4e3c-9140-0cb8189651b9)


### Part 2: Writing 10 Queries to Extract Information and Insights

Few techniques are used to answer these questions including CTE, JOIN, DATEDIFF, CASE, VIEW, Variables and subquery.

Questions:
1. Which product categories have the highest sales volume from 2016 to 2018?
![image](https://github.com/87Iodo/Shopee-Brazil-Analysis-By-SQL-Server/assets/143507039/f3850230-2835-4597-8576-24899c860cea)

2. Which product categories contribute the most to the revenue from 2016 to 2018?
![image](https://github.com/87Iodo/Shopee-Brazil-Analysis-By-SQL-Server/assets/143507039/aa0704da-343f-4586-a50a-507d3e41157e)

3. What is the average delivery time for each product category?
![image](https://github.com/87Iodo/Shopee-Brazil-Analysis-By-SQL-Server/assets/143507039/e19262f5-d422-4199-93a2-0cf4a6aa5d10)

4. What are the most common reasons for customer complaints and returns?
![image](https://github.com/87Iodo/Shopee-Brazil-Analysis-By-SQL-Server/assets/143507039/6bf32e6d-b6d4-463c-8069-ad16f0231d22)

5. How does customer satisfaction vary by region?
![image](https://github.com/87Iodo/Shopee-Brazil-Analysis-By-SQL-Server/assets/143507039/27500d23-a287-45c1-a6a3-5a08b04d55da)

6. What is the average order value (AOV) and how does it vary by customer demographics?
![image](https://github.com/87Iodo/Shopee-Brazil-Analysis-By-SQL-Server/assets/143507039/ad90e9e4-f1fe-405a-a87d-3c1748c21648)

7. How does the frequency of purchases vary over time (e.g., by month or quarter)?
![image](https://github.com/87Iodo/Shopee-Brazil-Analysis-By-SQL-Server/assets/143507039/2c1a22a4-134c-45ed-820d-9da9f9d97d8c)

8. What are the top-performing products in terms of sales and customer ratings?
--Weighted rating is introduced here to give less emphasis to purchased items with less number of rating.
![image](https://github.com/87Iodo/Shopee-Brazil-Analysis-By-SQL-Server/assets/143507039/c9ceacb0-f53d-4161-8057-7f170ccb882c)

9. How does shipping cost impact the purchase decision and order value?
![image](https://github.com/87Iodo/Shopee-Brazil-Analysis-By-SQL-Server/assets/143507039/0fc5bf1c-0b10-4192-bded-5d44dbbd9d35)

10. What are the patterns in repeat purchases and customer loyalty?
![image](https://github.com/87Iodo/Shopee-Brazil-Analysis-By-SQL-Server/assets/143507039/96cc07e6-5e54-47f0-85af-464b1d7edaa3)

11. What are the top 3 most popular products for each product category?
![image](https://github.com/87Iodo/Ecommerce-Brazil-Analysis-By-SQL-Server/assets/143507039/d32af235-9642-4277-9575-58f8e46a563e)


### Part 3: Putting Quaries into A Procedure

Different queries are set as parameters in the procedure with exception built in to handle wrong parameter name. Addtional statements are added to ensure the view is droppped if it already exists to avoid conflicts.

![image](https://github.com/87Iodo/Shopee-Brazil-Analysis-By-SQL-Server/assets/143507039/0fd86685-b694-4c50-a431-c96c4c0acf88)
![image](https://github.com/87Iodo/Ecommerce-Brazil-Analysis-By-SQL-Server/assets/143507039/3f5e9ac7-240e-4fea-9eed-0b35b7747884)


### Executing Procedure

Users now is able to call out the information for analysis with a simple prompt.

![image](https://github.com/87Iodo/Shopee-Brazil-Analysis-By-SQL-Server/assets/143507039/6fe98ffc-602a-41ef-a193-12c3fddd2e3b)

When user enter the wrong parameter name, a message showing all the correct parameter names will be given.

![image](https://github.com/87Iodo/Shopee-Brazil-Analysis-By-SQL-Server/assets/143507039/d5b77ba6-7d7e-49a9-a723-981ef37d0c18)


### Limitations

Microsoft SQL Server does not have built-in functionality to direct translate dataset column names or values from one language to another, making it difficult to analyze review comments. To perform translations in SQL Server, external API such as Microsoft Translator Text API and integration with programming language like Python is required.

### References
- [kaggle](https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce/data)
