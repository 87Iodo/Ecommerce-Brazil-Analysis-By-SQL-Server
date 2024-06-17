CREATE DATABASE shopee

--DROP DATABASE shopee

USE shopee

GO

--TASK 1. Create Translation Table for Product Category

CREATE TABLE product_category_name_translation (
	ID INT IDENTITY(1,1) PRIMARY KEY,
	product_category_name VARCHAR(50)
);

INSERT INTO product_category_name_translation
SELECT DISTINCT product_category_name FROM products
WHERE product_category_name IS NOT NULL
ORDER BY product_category_name;

SELECT * FROM product_category_name_translation

CREATE TABLE #english (
	ID INT IDENTITY(1,1) PRIMARY KEY,
	english_name NVARCHAR(100)
);

INSERT INTO #english (english_name)
VALUES
	('agro_industry_and_commerce')
	,('food')
	,('food_drink')
	,('art')
	,('arts_and_craftmanship')
	,('party_supplies')
	,('christmas_supplies')
	,('audio')
	,('auto')
	,('baby')
	,('drinks')
	,('health_beauty')
	,('toys')
	,('bed_bath_table')
	,('home_confort')
	,('home_comfort_2')
	,('home_construction')
	,('cds_dvds_musicals')
	,('cine_photo')
	,('air_conditioning')
	,('consoles_games')
	,('construction_tools_construction')
	,('costruction_tools_tools')
	,('construction_tools_lights')
	,('costruction_tools_garden')
	,('construction_tools_safety')
	,('cool_stuff')
	,('dvds_blu_ray')
	,('home_appliances')
	,('home_appliances_2')
	,('electronics')
	,('small_appliances')
	,('sports_leisure')
	,('fashion_bags_accessories')
	,('fashion_shoes')
	,('fashion_sport')
	,('fashio_female_clothing')
	,('fashion_childrens_clothes')
	,('fashion_male_clothing')
	,('fashion_underwear_beach')
	,('garden_tools')
	,('flowers')
	,('diapers_and_hygiene')
	,('industry_commerce_and_business')
	,('computers_accessories')
	,('musical_instruments')
	,('la_cuisine')
	,('books_imported')
	,('books_general_interest')
	,('books_technical')
	,('luggage_accessories')
	,('market_place')
	,('furniture_mattress_and_upholstery')
	,('kitchen_dining_laundry_garden_furniture')
	,('furniture_decor')
	,('office_furniture')
	,('furniture_bedroom')
	,('furniture_living_room')
	,('music')
	,('stationery')
	,('gaming PC')
	,('computers')
	,('perfumery')
	,('pet_shop')
	,('small_appliances_home_oven_and_coffee')
	,('portable kitchen and food preparers')
	,('watches_gifts')
	,('security_and_services')
	,('signaling_and_security')
	,('tablets_printing_image')
	,('telephony')
	,('fixed_telephony')
	,('housewares')

ALTER TABLE product_category_name_translation
ADD product_category_name_english NVARCHAR(100);

SELECT * FROM product_category_name_translation;

UPDATE product_category_name_translation
SET product_category_name_english = english_name
FROM product_category_name_translation a
JOIN #english b on a.ID = b.ID

SELECT * FROM product_category_name_translation



--DROP TABLE product_category_name_translation
--DROP TABLE #english



--QUESTIONS
--1. Which product categories have the highest sales volume from 2016 to 2018?

--SELECT order_id, order_delivered_customer_date FROM orders
--WHERE order_status = 'delivered';

--SELECT order_id, COUNT(order_item_id) as total_sales_volume, product_id FROM order_items
--WHERE order_id = '00143d0f86d6fbd9f9b38ab440ac16f5'
--GROUP BY order_id, product_id;

WITH Sales as (
	SELECT product_id, order_id, COUNT(order_id) as sales_per_order
	FROM order_items
	GROUP BY product_id, order_id
)
SELECT top 10 product_category_name_english AS product_category, SUM(s.sales_per_order) as total_sales_volume
FROM orders o
INNER JOIN Sales s on o.order_id = s.order_id
INNER JOIN products p on s.product_id = p.product_id
INNER JOIN product_category_name_translation pt on p.product_category_name = pt.product_category_name
WHERE o.order_status='delivered'
GROUP BY pt.product_category_name_english
ORDER BY SUM(s.sales_per_order) DESC;

--SELECT top 10 product_category_name_english AS product_category, COUNT(order_item_id) as total_sales_volume 
--FROM orders o
--INNER JOIN order_items oi ON o.order_id = oi.order_id
--INNER JOIN products p on oi.product_id = p.product_id
--INNER JOIN product_category_name_translation pt on p.product_category_name = pt.product_category_name
--WHERE o.order_status='delivered'
--GROUP BY pt.product_category_name_english
--ORDER BY COUNT(order_item_id) DESC;

--2. Which product categories contribute the most to the revenue from 2016 to 2018?

--SELECT order_id, price, freight_value FROM order_items
--WHERE order_id = '00143d0f86d6fbd9f9b38ab440ac16f5';

--SELECT * FROM order_payments
--WHERE order_id = '00143d0f86d6fbd9f9b38ab440ac16f5';

SELECT top 10 product_category_name_english AS product_category, ROUND(SUM(payment_value),2) as total_revenue
FROM order_payments op
INNER JOIN order_items oi ON op.order_id = oi.order_id
INNER JOIN products p on oi.product_id = p.product_id
INNER JOIN product_category_name_translation pt on p.product_category_name = pt.product_category_name
GROUP BY pt.product_category_name_english
ORDER BY SUM(payment_value) DESC;

--3. What is the average delivery time for each product category?

SELECT pt.product_category_name_english, AVG(DATEDIFF(DAY,order_purchase_timestamp,order_delivered_customer_date)) AS avg_delivery_time
FROM orders o
INNER JOIN order_items oi ON o.order_id = oi.order_id
INNER JOIN products p on oi.product_id = p.product_id
INNER JOIN product_category_name_translation pt on p.product_category_name = pt.product_category_name
WHERE o.order_status='delivered'
GROUP BY pt.product_category_name_english
ORDER BY AVG(DATEDIFF(DAY,order_purchase_timestamp,order_delivered_customer_date));

--4. What are the most common reasons for customer complaints and returns?

SELECT 
	CASE
		WHEN review_comment_message LIKE '%tarde%' THEN 'Late Delivery'
		WHEN review_comment_message LIKE '%dano%' THEN 'Damaged Product'
		WHEN review_comment_message LIKE '%errado%' THEN 'Wrong Item'
		WHEN review_comment_message LIKE '%qualidade%' THEN 'Poor Quality'
		WHEN review_comment_message LIKE '%falt%' THEN 'Missing Item'
		ELSE 'Other'
	END AS complaint_reason,
	COUNT(*) as number_of_complaint
FROM order_reviews
WHERE review_score <2 AND review_comment_message IS NOT NULL
GROUP BY
	CASE
		WHEN review_comment_message LIKE '%tarde%' THEN 'Late Delivery'
		WHEN review_comment_message LIKE '%dano%' THEN 'Damaged Product'
		WHEN review_comment_message LIKE '%errado%' THEN 'Wrong Item'
		WHEN review_comment_message LIKE '%qualidade%' THEN 'Poor Quality'
		WHEN review_comment_message LIKE '%falt%' THEN 'Missing Item'
		ELSE 'Other'
	END;


--5. How does customer satisfaction vary by region?

WITH ReviewCount as (
	SELECT 
		g.geolocation_state,
		COUNT(orre.review_score) as review_count,
		SUM(CAST(orre.review_score as float)) as total_review_score
	FROM order_reviews orre
	JOIN orders o on orre.order_id = o.order_id
	JOIN customers c on o.customer_id = c.customer_id
	JOIN geolocation g on g.geolocation_zip_code_prefix = c.customer_zip_code_prefix
	WHERE orre.review_score IS NOT NULL
	GROUP BY g.geolocation_state
)
SELECT geolocation_state, 
	ROUND(total_review_score/ review_count,2) as weighted_average_review_score
FROM ReviewCount
ORDER BY weighted_average_review_score DESC;


--6. What is the average order value (AOV) and how does it vary by customer demographics?

--Calculate the AOV and explore how it differs by age, gender, and location of customers.

WITH EachOtherPayment as(
	SELECT o.order_id, SUM(op.payment_value) as order_payment
	FROM orders o
	INNER JOIN order_payments op on o.order_id = op.order_id
	GROUP BY o.order_id
),
	CustomerDemopgaphic as (
	SELECT o.order_id, c.customer_state
	FROM orders o
	INNER JOIN customers c on o.customer_id = c.customer_id
)
SELECT cd.customer_state, AVG(eop.order_payment) as AOV
FROM EachOtherPayment eop
INNER JOIN CustomerDemopgaphic cd on eop.order_id = cd.order_id
GROUP BY cd.customer_state
ORDER BY AVG(eop.order_payment) DESC;

--OR

SELECT 
c.customer_state as state, SUM(op.payment_value)/COUNT(DISTINCT(o.order_id)) as AOV
FROM customers c 
JOIN orders o on c.customer_id = o.customer_id
JOIN order_payments op on o.order_id = op.order_id
GROUP BY c.customer_state
ORDER BY AVG(op.payment_value) DESC;




--7. How does the frequency of purchases vary over time (e.g., by month or quarter)?

--Investigate seasonal trends in purchasing behavior to plan marketing and inventory strategies.

SELECT 
	YEAR(order_delivered_customer_date) as order_year
	,DATEPART(QUARTER, order_delivered_customer_date) as order_quarter
	,MONTH(order_delivered_customer_date) as order_month
	,COUNT(order_id) as order_count
FROM orders
WHERE order_delivered_customer_date IS NOT NULL
GROUP BY
	YEAR(order_delivered_customer_date)
	,DATEPART(QUARTER, order_delivered_customer_date)
	,MONTH(order_delivered_customer_date)
ORDER BY
	YEAR(order_delivered_customer_date)
	,DATEPART(QUARTER, order_delivered_customer_date)
	,MONTH(order_delivered_customer_date);



--8. What are the top-performing products in terms of sales and customer ratings?

--Identify products that not only sell well but also receive high customer ratings, indicating overall success.


--WITH ProductSales as (
--	SELECT product_id, order_id, COUNT(order_id) as sales_per_order
--	FROM order_items
--	GROUP BY product_id, order_id
--),
--	ProductRating as (
--	SELECT order_id, review_score
--	FROM order_reviews
--	WHERE review_score IS NOT NULL
--)
--SELECT product_id, SUM(sales_per_order) as total_sales_volume, AVG(CAST(review_score as float)) as average_rating
--FROM ProductSales ps
--INNER JOIN ProductRating pr on ps.order_id = pr.order_id
--GROUP BY product_id
--ORDER BY SUM(sales_per_order) DESC, AVG(CAST(review_score as float)) DESC;

CREATE VIEW product_volume_rating as
WITH ProductSales as (
	SELECT product_id, order_id, COUNT(order_id) as sales_per_order
	FROM order_items
	GROUP BY product_id, order_id
),
	ProductRating as (
	SELECT order_id, review_score
	FROM order_reviews
	WHERE review_score IS NOT NULL
)
SELECT product_id, SUM(sales_per_order) as total_sales_volume, ROUND(AVG(CAST(pr.review_score as float)),2) as average_rating
FROM ProductSales ps
INNER JOIN ProductRating pr on ps.order_id = pr.order_id
GROUP BY product_id
--ORDER BY SUM(sales_per_order), ROUND(AVG(CAST(pr.review_score as float)),2) DESC;

--DROP VIEW product_volume_rating

--SELECT * FROM product_volume_rating

DECLARE @C float;
SET @C = (SELECT 
AVG(average_rating) 
--SUM(total_sales_volume*average_rating)/SUM(total_sales_volume)
FROM product_volume_rating);

DECLARE @m float;
SET @m = 10;

--SELECT 'The value of the variable is: ' + CAST(@C AS VARCHAR) AS VariableValue;

SELECT 
	product_id, total_sales_volume, ROUND((total_sales_volume/(total_sales_volume+@m)*average_rating)+(@m/(@m+total_sales_volume)*@C),2) as weighted_rating
FROM product_volume_rating
--ORDER BY (total_sales_volume/(total_sales_volume+@m)*average_rating)+(@m/(@m+total_sales_volume)*@C) DESC
ORDER BY 
total_sales_volume DESC, 
ROUND((total_sales_volume/(total_sales_volume+@m)*average_rating)+(@m/(@m+total_sales_volume)*@C),2) DESC;

--Product with high or low rating but low number of review will be adjusted closer to mean rating
--Product with high or low rating and high number of review will be adjusted closer to the actual rating



--9. How does shipping cost impact the purchase decision and order value?

--Analyze the relationship between shipping costs and order values to determine if high shipping costs deter customers.

CREATE VIEW shipping_cost_analysis as
SELECT total_freight_value, order_value, COUNT(order_id) as number_of_order
FROM (
	SELECT order_id, SUM(freight_value) as total_freight_value, SUM(price) as order_value from order_items
	GROUP BY order_id
	) as subquery
GROUP BY total_freight_value, order_value
--ORDER BY total_freight_value

SELECT 
	CASE 
		WHEN total_freight_value = 0 THEN '0'
		WHEN total_freight_value > 0 AND total_freight_value<= 10 THEN '0.01-10'
		WHEN total_freight_value > 10 AND total_freight_value<= 20 THEN '10.01-20'
		WHEN total_freight_value > 20 AND total_freight_value<= 30 THEN '20.01-30'
		WHEN total_freight_value > 30 AND total_freight_value<= 40 THEN '30.01-40'
		WHEN total_freight_value > 40 AND total_freight_value<= 50 THEN '40.01-50'
		WHEN total_freight_value > 50 AND total_freight_value<= 60 THEN '50.01-60'
		WHEN total_freight_value > 60 AND total_freight_value<= 70 THEN '60.01-70'
		WHEN total_freight_value > 70 AND total_freight_value<= 80 THEN '70.01-80'
		WHEN total_freight_value > 80 AND total_freight_value<= 90 THEN '80.01-90'
		ELSE 'More than 100'
	END as freight_value_range,
	AVG(order_value) as average_order_value,
	SUM(number_of_order) as total_orders
FROM shipping_cost_analysis
GROUP BY
	CASE 
		WHEN total_freight_value = 0 THEN '0'
		WHEN total_freight_value > 0 AND total_freight_value<= 10 THEN '0.01-10'
		WHEN total_freight_value > 10 AND total_freight_value<= 20 THEN '10.01-20'
		WHEN total_freight_value > 20 AND total_freight_value<= 30 THEN '20.01-30'
		WHEN total_freight_value > 30 AND total_freight_value<= 40 THEN '30.01-40'
		WHEN total_freight_value > 40 AND total_freight_value<= 50 THEN '40.01-50'
		WHEN total_freight_value > 50 AND total_freight_value<= 60 THEN '50.01-60'
		WHEN total_freight_value > 60 AND total_freight_value<= 70 THEN '60.01-70'
		WHEN total_freight_value > 70 AND total_freight_value<= 80 THEN '70.01-80'
		WHEN total_freight_value > 80 AND total_freight_value<= 90 THEN '80.01-90'
		ELSE 'More than 100'
	END
ORDER BY
	CASE 
		WHEN total_freight_value = 0 THEN '0'
		WHEN total_freight_value > 0 AND total_freight_value<= 10 THEN '0.01-10'
		WHEN total_freight_value > 10 AND total_freight_value<= 20 THEN '10.01-20'
		WHEN total_freight_value > 20 AND total_freight_value<= 30 THEN '20.01-30'
		WHEN total_freight_value > 30 AND total_freight_value<= 40 THEN '30.01-40'
		WHEN total_freight_value > 40 AND total_freight_value<= 50 THEN '40.01-50'
		WHEN total_freight_value > 50 AND total_freight_value<= 60 THEN '50.01-60'
		WHEN total_freight_value > 60 AND total_freight_value<= 70 THEN '60.01-70'
		WHEN total_freight_value > 70 AND total_freight_value<= 80 THEN '70.01-80'
		WHEN total_freight_value > 80 AND total_freight_value<= 90 THEN '80.01-90'
		ELSE 'More than 100'
	END;


--10. What are the patterns in repeat purchases and customer loyalty?

--Explore customer retention rates and identify factors that contribute to repeat purchases and long-term loyalty.

SELECT number_of_purchases, COUNT(customer_unique_id) as number_of_customer
FROM (
SELECT customer_unique_id, COUNT(customer_id) as number_of_purchases
FROM customers
GROUP BY customer_unique_id
	) as subquery
GROUP BY number_of_purchases
ORDER BY number_of_purchases DESC;


--Create Procedure

CREATE PROCEDURE AnalyzeEcommercialData
	@QueryType NVARCHAR(50)
AS
BEGIN
	SET NOCOUNT ON;

	--Query 1
	IF @QueryType = 'TopPerformingProductByVolume'
	BEGIN
		WITH Sales as (
			SELECT product_id, order_id, COUNT(order_id) as sales_per_order
			FROM order_items
			GROUP BY product_id, order_id
		)
		SELECT top 10 product_category_name_english AS product_category, SUM(s.sales_per_order) as total_sales_volume
		FROM orders o
		INNER JOIN Sales s on o.order_id = s.order_id
		INNER JOIN products p on s.product_id = p.product_id
		INNER JOIN product_category_name_translation pt on p.product_category_name = pt.product_category_name
		WHERE o.order_status='delivered'
		GROUP BY pt.product_category_name_english
		ORDER BY SUM(s.sales_per_order) DESC;
	END
	--Query 2
	ELSE IF @QueryType = 'TopPerformingProductBySales'
	BEGIN
		SELECT top 10 product_category_name_english AS product_category, ROUND(SUM(payment_value),2) as total_revenue
		FROM order_payments op
		INNER JOIN order_items oi ON op.order_id = oi.order_id
		INNER JOIN products p on oi.product_id = p.product_id
		INNER JOIN product_category_name_translation pt on p.product_category_name = pt.product_category_name
		GROUP BY pt.product_category_name_english
		ORDER BY SUM(payment_value) DESC;
	END
	--Query 3
	ELSE IF @QueryType = 'DeliveryTimeByProductCategory'
	BEGIN
		SELECT pt.product_category_name_english, AVG(DATEDIFF(DAY,order_purchase_timestamp,order_delivered_customer_date)) AS avg_delivery_time_day
		FROM orders o
		INNER JOIN order_items oi ON o.order_id = oi.order_id
		INNER JOIN products p on oi.product_id = p.product_id
		INNER JOIN product_category_name_translation pt on p.product_category_name = pt.product_category_name
		WHERE o.order_status='delivered'
		GROUP BY pt.product_category_name_english
		ORDER BY AVG(DATEDIFF(DAY,order_purchase_timestamp,order_delivered_customer_date));
	END
	--Query 4
	ELSE IF @QueryType = 'CustomerComplaintReason'
	BEGIN
		SELECT 
			CASE
				WHEN review_comment_message LIKE '%tarde%' THEN 'Late Delivery'
				WHEN review_comment_message LIKE '%dano%' THEN 'Damaged Product'
				WHEN review_comment_message LIKE '%errado%' THEN 'Wrong Item'
				WHEN review_comment_message LIKE '%qualidade%' THEN 'Poor Quality'
				WHEN review_comment_message LIKE '%falt%' THEN 'Missing Item'
				ELSE 'Other'
			END AS complaint_reason,
			COUNT(*) as number_of_complaint
		FROM order_reviews
		WHERE review_score <2 AND review_comment_message IS NOT NULL
		GROUP BY
			CASE
				WHEN review_comment_message LIKE '%tarde%' THEN 'Late Delivery'
				WHEN review_comment_message LIKE '%dano%' THEN 'Damaged Product'
				WHEN review_comment_message LIKE '%errado%' THEN 'Wrong Item'
				WHEN review_comment_message LIKE '%qualidade%' THEN 'Poor Quality'
				WHEN review_comment_message LIKE '%falt%' THEN 'Missing Item'
				ELSE 'Other'
			END;
	END
	--Query 5
	ELSE IF @QueryType = 'CustomerSatisfactionByState'
	BEGIN
		WITH ReviewCount as (
			SELECT 
				g.geolocation_state,
				COUNT(orre.review_score) as review_count,
				SUM(CAST(orre.review_score as float)) as total_review_score
			FROM order_reviews orre
			JOIN orders o on orre.order_id = o.order_id
			JOIN customers c on o.customer_id = c.customer_id
			JOIN geolocation g on g.geolocation_zip_code_prefix = c.customer_zip_code_prefix
			WHERE orre.review_score IS NOT NULL
			GROUP BY g.geolocation_state
		)
		SELECT geolocation_state, 
			ROUND(total_review_score/ review_count,2) as weighted_average_review_score
		FROM ReviewCount
		ORDER BY weighted_average_review_score DESC;
	END
	--Query 6
	ELSE IF @QueryType = 'AverageOrderValueByState'
	BEGIN
		SELECT 
		c.customer_state as state, ROUND(SUM(op.payment_value)/COUNT(DISTINCT(o.order_id)),2) as AOV
		FROM customers c 
		JOIN orders o on c.customer_id = o.customer_id
		JOIN order_payments op on o.order_id = op.order_id
		GROUP BY c.customer_state
		ORDER BY ROUND(SUM(op.payment_value)/COUNT(DISTINCT(o.order_id)),2) DESC;
	END
	--Query 7
	ELSE IF @QueryType = 'PurchaseFrequencyOvertime'
	BEGIN
		SELECT 
			YEAR(order_delivered_customer_date) as order_year
			,DATEPART(QUARTER, order_delivered_customer_date) as order_quarter
			,MONTH(order_delivered_customer_date) as order_month
			,COUNT(order_id) as order_count
		FROM orders
		WHERE order_delivered_customer_date IS NOT NULL
		GROUP BY
			YEAR(order_delivered_customer_date)
			,DATEPART(QUARTER, order_delivered_customer_date)
			,MONTH(order_delivered_customer_date)
		ORDER BY
			YEAR(order_delivered_customer_date)
			,DATEPART(QUARTER, order_delivered_customer_date)
			,MONTH(order_delivered_customer_date);
	END
	--Query 8
	ELSE IF @QueryType = 'TopPerformingProductBySalesAndWeightedRating'
	BEGIN
	IF OBJECT_ID('product_volume_rating','V') IS NOT NULL
		DROP VIEW product_volume_rating;
		EXEC('
			CREATE VIEW product_volume_rating AS
			WITH ProductSales as (
				SELECT product_id, order_id, COUNT(order_id) as sales_per_order
				FROM order_items
				GROUP BY product_id, order_id
			),
				ProductRating as (
				SELECT order_id, review_score
				FROM order_reviews
				WHERE review_score IS NOT NULL
			)
			SELECT product_id, SUM(sales_per_order) as total_sales_volume, ROUND(AVG(CAST(pr.review_score as float)),2) as average_rating
			FROM ProductSales ps
			INNER JOIN ProductRating pr on ps.order_id = pr.order_id
			GROUP BY product_id;
			');

			DECLARE @m float;
			DECLARE @C float;

			SET @m = 10;
			SET @C = (SELECT 
			AVG(average_rating) 
			FROM product_volume_rating);

			SELECT 
				product_id, total_sales_volume, ROUND((total_sales_volume/(total_sales_volume+@m)*average_rating)+(@m/(@m+total_sales_volume)*@C),2) as weighted_rating
			FROM product_volume_rating
			ORDER BY 
			total_sales_volume DESC, 
			ROUND((total_sales_volume/(total_sales_volume+@m)*average_rating)+(@m/(@m+total_sales_volume)*@C),2) DESC;
	END
	--Query 9
	ELSE IF @QueryType='ShippingCostByOrderValueAndCount'
	BEGIN
	IF OBJECT_ID('shipping_cost_analysis','V') IS NOT NULL
		DROP VIEW shipping_cost_analysis;
	EXEC ('
		CREATE VIEW shipping_cost_analysis as
		SELECT total_freight_value, order_value, COUNT(order_id) as number_of_order
		FROM (
			SELECT order_id, SUM(freight_value) as total_freight_value, SUM(price) as order_value from order_items
			GROUP BY order_id
			) as subquery
		GROUP BY total_freight_value, order_value
		');
	SELECT 
		CASE 
			WHEN total_freight_value = 0 THEN '0'
			WHEN total_freight_value > 0 AND total_freight_value<= 10 THEN '0.01-10'
			WHEN total_freight_value > 10 AND total_freight_value<= 20 THEN '10.01-20'
			WHEN total_freight_value > 20 AND total_freight_value<= 30 THEN '20.01-30'
			WHEN total_freight_value > 30 AND total_freight_value<= 40 THEN '30.01-40'
			WHEN total_freight_value > 40 AND total_freight_value<= 50 THEN '40.01-50'
			WHEN total_freight_value > 50 AND total_freight_value<= 60 THEN '50.01-60'
			WHEN total_freight_value > 60 AND total_freight_value<= 70 THEN '60.01-70'
			WHEN total_freight_value > 70 AND total_freight_value<= 80 THEN '70.01-80'
			WHEN total_freight_value > 80 AND total_freight_value<= 90 THEN '80.01-90'
			ELSE 'More than 100'
		END as freight_value_range,
		AVG(order_value) as average_order_value,
		SUM(number_of_order) as total_orders
	FROM shipping_cost_analysis
	GROUP BY
		CASE 
			WHEN total_freight_value = 0 THEN '0'
			WHEN total_freight_value > 0 AND total_freight_value<= 10 THEN '0.01-10'
			WHEN total_freight_value > 10 AND total_freight_value<= 20 THEN '10.01-20'
			WHEN total_freight_value > 20 AND total_freight_value<= 30 THEN '20.01-30'
			WHEN total_freight_value > 30 AND total_freight_value<= 40 THEN '30.01-40'
			WHEN total_freight_value > 40 AND total_freight_value<= 50 THEN '40.01-50'
			WHEN total_freight_value > 50 AND total_freight_value<= 60 THEN '50.01-60'
			WHEN total_freight_value > 60 AND total_freight_value<= 70 THEN '60.01-70'
			WHEN total_freight_value > 70 AND total_freight_value<= 80 THEN '70.01-80'
			WHEN total_freight_value > 80 AND total_freight_value<= 90 THEN '80.01-90'
			ELSE 'More than 100'
		END
	ORDER BY
		CASE 
			WHEN total_freight_value = 0 THEN '0'
			WHEN total_freight_value > 0 AND total_freight_value<= 10 THEN '0.01-10'
			WHEN total_freight_value > 10 AND total_freight_value<= 20 THEN '10.01-20'
			WHEN total_freight_value > 20 AND total_freight_value<= 30 THEN '20.01-30'
			WHEN total_freight_value > 30 AND total_freight_value<= 40 THEN '30.01-40'
			WHEN total_freight_value > 40 AND total_freight_value<= 50 THEN '40.01-50'
			WHEN total_freight_value > 50 AND total_freight_value<= 60 THEN '50.01-60'
			WHEN total_freight_value > 60 AND total_freight_value<= 70 THEN '60.01-70'
			WHEN total_freight_value > 70 AND total_freight_value<= 80 THEN '70.01-80'
			WHEN total_freight_value > 80 AND total_freight_value<= 90 THEN '80.01-90'
			ELSE 'More than 100'
		END;
	END
	--Query 10
	ELSE IF @QueryType = 'CustomerLoyalty'
	BEGIN
	SELECT number_of_purchases, COUNT(customer_unique_id) as number_of_customer
	FROM (
	SELECT customer_unique_id, COUNT(customer_id) as number_of_purchases
	FROM customers
	GROUP BY customer_unique_id
		) as subquery
	GROUP BY number_of_purchases
	ORDER BY number_of_purchases DESC;
	END
	ELSE
	BEGIN
		RAISERROR('Invalid QueryType provided. Valid options are:  
																	, TopPerformingProductByVolume
																	, TopPerformingProductBySales
																	, DeliveryTimeByProductCategory
																	, CustomerComplaintReason
																	, CustomerSatisfactionByState
																	, AverageOrderValueByState
																	, PurchaseFrequencyOvertime
																	, TopPerformingProductBySalesAndWeightedRating
																	, ShippingCostByOrderValueAndCount
																	, CustomerLoyalty',16,1);
	END
END;

--DROP PROCEDURE AnalyzeEcommercialData

EXEC AnalyzeEcommercialData @QueryType = 'AverageOrderValueByState'
EXEC AnalyzeEcommercialData @QueryType = 'ShippingCostByOrderValueAndCount'



EXEC AnalyzeEcommercialData @QueryType = 'ShippingCostByOrderValueAndCoun'
