--Q0: Our schemas can be found in the asupra4 database on our class server

--Q1: Create Table Statements
-- CREATE TABLE Restaurant (
-- 	rname VARCHAR(50), 
-- 	rlocation VARCHAR(50),
-- 	rating INT,
-- 	suppliers VARCHAR(100),
-- 	Primary Key (rname, rlocation)
-- );

-- Create TABLE Management (
-- 	rname VARCHAR(50),
-- 	rlocation VARCHAR(50),
-- 	owner_id VARCHAR(20),
-- 	years_owned INT,
-- 	ownership_type VARCHAR(50),
-- 	Primary Key (owner_id),
-- 	FOREIGN KEY (rname, rlocation) REFERENCES Restaurant(rname, rlocation)
	
-- );

-- CREATE TABLE m_own_r (
-- 	rname VARCHAR(50),
-- 	rlocation VARCHAR(50),
-- 	owner_id VARCHAR(20),
-- 	Primary Key (rname, rlocation, owner_id),
-- 	FOREIGN KEY (rname, rlocation) REFERENCES Restaurant(rname, rlocation),
-- 	FOREIGN KEY (owner_id) REFERENCES Management(owner_id)
-- );

-- Create Table Customer12 (
-- 	cname VARCHAR (50),
-- 	customer_id VARCHAR (20),
-- 	date_visited DATE,
-- 	Primary Key (customer_id)
-- );

-- Create Table c_visit_r (
-- 	rname VARCHAR(50),
-- 	rlocation VARCHAR(50),
-- 	customer_id VARCHAR (20),
-- 	Primary Key (rname, rlocation, customer_id),
-- 	FOREIGN KEY (rname, rlocation) REFERENCES Restaurant(rname, rlocation),
-- 	FOREIGN KEY (customer_id) REFERENCES Customer12(customer_id)
-- );

-- Create Table MenuItem (
-- 	dish_name VARCHAR(50),
-- 	price DECIMAL,
-- 	ingredients Text,
-- 	popularity VARCHAR(50),
-- 	Primary Key(dish_name, price)
-- );

-- Create Table CustomerOrder (
-- 	dish_name VARCHAR(50),
-- 	price DECIMAL,
-- 	receipt_number INT,
-- 	order_date DATE,
-- 	rating INT,
-- 	FOREIGN KEY (dish_name, price) references MenuItem(dish_name, price),
-- 	Primary Key (receipt_number)
-- );

-- Create Table c_places_o (
-- 	customer_id VARCHAR(50),
-- 	receipt_number INT,
-- 	FOREIGN KEY (receipt_number) REFERENCES CustomerOrder(receipt_number),
-- 	FOREIGN KEY (customer_id) REFERENCES Customer12(customer_id)
-- );

-- CREATE Table Supplier (
-- 	supplier_id VARCHAR(50),
-- 	supplier_location VARCHAR(100),
-- 	sname VARCHAR (50),
-- 	Primary Key (supplier_id)
-- );

-- Create Table s_supply_r (
-- 	supplier_id VARCHAR(50),
-- 	rname VARCHAR(50) ,
-- 	rlocation VARCHAR(50),
-- 	quantity INT,
-- 	supply_budget DECIMAL,
-- 	ingredient_price DECIMAL,
-- 	ingredient VARCHAR(50),
-- 	total_supply_cost DECIMAL,
-- 	current_stock INT,
-- 	FOREIGN KEY (rname, rlocation) REFERENCES Restaurant(rname, rlocation),
-- 	FOREIGN KEY (supplier_id) REFERENCES Supplier(supplier_id)
-- );

--Q2: Queries

--#4. How many ingredients does the average supplier provide? (Restaurant) 
SELECT AVG(num_ingredients) AS average_ingredients
FROM (
	SELECT COUNT(DISTINCT Ingredient) AS num_ingredients
	FROM s_supply_r
	GROUP BY supplier_id
) AS num;

--#5. What is the highest rated dish on average? (Restaurant, Customer12)
SELECT dish_name, AVG(rating) AS avg_rating
FROM CustomerOrder
GROUP BY dish_name
ORDER BY avg_rating DESC
LIMIT 1;

INSERT INTO MenuItem(dish_name, price)
Values
('Pork Xiao Long Bao', '14.09'),
('Brown Rice', '4.50'),
('Wonton Soup', '7.00');

INSERT INTO CustomerOrder(dish_name, price, receipt_number, order_date, rating)
VALUES
('Pork Xiao Long Bao', '14.09', '333', '2023-10-14', '3'),
('Pork Xiao Long Bao', '14.09', '339', '2023-10-14', '5'),
('Pork Xiao Long Bao', '14.09', '332', '2022-02-12', '4'),
('Brown Rice', '4.50', '640', '2022-03-14', '2'),
('Brown Rice', '4.50', '122', '2023-11-09', '5'),
('Wonton Soup', '7.00', '627', '2022-08-28', '5');

--#7. What day of the year is busiest on average for a restaurant? (Restaurant, Management, Employee)
SELECT DATE_PART('doy', order_date) AS doy, COUNT(*) AS order_count
FROM CustomerOrder
GROUP BY DATE_PART('doy', order_date)
ORDER BY order_count DESC
LIMIT 1;

-- Output:
-- "doy"	"order_count"
-- 287	2

--#8. What is the average restaurant rating in a certain location? (Customer12, Management)
SELECT rlocation, AVG(rating)
FROM Restaurant 
WHERE rlocation = 'Seattle, WA'
GROUP BY rlocation;

INSERT INTO Supplier(sname, supplier_id)
VALUES
('Supplier1', '1'),
('Supplier2', '2'),
('Supplier3', '3');

INSERT INTO s_supply_r(supplier_id, ingredient, ingredient_price, quantity)
VALUES 
('1', 'Tomatoes', '15', '20'),
('1', 'Lettuce', '10', '15'),
('2', 'Tomatoes', '20', '30'),
('3', 'Tomatoes', '3.99', '5');

--#12. Which suppliers have the best quantity-to-price ratio for a certain ingredient? (Management)
SELECT s.sname, sr.ingredient, sr.ingredient_price / sr.quantity AS price_per
FROM Supplier s
JOIN s_supply_r sr ON s.supplier_id = sr.supplier_id
WHERE sr.ingredient = 'Tomatoes'
ORDER BY price_per DESC;

-- Output:
-- "sname"	"ingredient"	"price_per"
-- "Supplier3"	"Tomatoes"	0.79800000000000000000
-- "Supplier1"	"Tomatoes"	0.75000000000000000000
-- "Supplier2"	"Tomatoes"	0.66666666666666666667

--#13.  What restaurant has the most locations? (Customer12, Management)
SELECT rname,  COUNT(rlocation) AS  total_locations
FROM  Restaurant
GROUP BY rname
ORDER BY total_locations DESC;

--#14. How many different owners have managed a given restaurant? (Customer12, Employee)
SELECT r.rname, r.rlocation, COUNT(DISTINCT m.owner_id)
FROM Restaurant r
LEFT JOIN Management m ON r.rname = m.rname
WHERE r.rname = 'Tai Tung' AND r.rlocation = 'Seattle, WA'
GROUP BY r.rname, r.rlocation;


INSERT INTO MenuItem(dish_name, price)
Values
('Mutton Rogan Josh', '15.00'),
('Egg Fried Rice', '9.54'),
('Fire Noodles', '8.56');

INSERT INTO CustomerOrder(dish_name, price, receipt_number, order_date, rating)
VALUES
('Mutton Rogan Josh', '15.00', '55', '2024-1-12', '5'),
('Egg Fried Rice', '9.54', '12', '2023-12-1', '4'),
('Fire Noodles', '8.56', '24', '2024-2-21', '3');

INSERT INTO Customer12(cname, customer_id, date_visited)
VALUES
('Christian', '2324', '2024-1-12'),
('Laurent', '9283', '2023-12-1'),
('Sierra', '8372', '2024-2-21');

--#16. Find the highest and lowest ratings given along with the date and customer who gave that rating. (Customer12, CustomerOrder)
(SELECT MAX(co.rating) AS rating, c.cname, c.customer_id, co.order_date
FROM CustomerOrder co
JOIN Customer12 c ON co.order_date = c.date_visited
GROUP BY co.rating, c.cname, c.customer_id, co.order_date
ORDER BY co.rating DESC
LIMIT 1)

UNION

(SELECT MIN(co.rating) AS rating, c.cname, c.customer_id, co.order_date
FROM CustomerOrder co
JOIN Customer12 c ON co.order_date = c.date_visited
GROUP BY co.rating, c.cname, c.customer_id, co.order_date
ORDER BY co.rating ASC
LIMIT 1);

-- Output:
-- "rating"	"cname"	"customer_id"	"order_date"
-- 3	"Sierra"	"8372"	"2024-02-21"
-- 5	"Christian"	"2324"	"2024-01-12"

--#17. For each restaurant location, find their top supplier. (Restaurant, supplier)
SELECT s.supplier_id, s.sname, r.rname, MAX(sr.quantity) AS amount_supplied
FROM Restaurant r
JOIN Supplier s ON r.suppliers = s.sname
JOIN s_supply_r sr ON s.supplier_id = sr.supplier_id
GROUP BY s.supplier_id, s.sname, r.rname;

--#18. Find the date where the most popular dish was also the most expensive? (MenuItem, Order)
SELECT c.dish_name, MAX(c.price) AS most_expensive, c.order_date
FROM MenuItem m
JOIN CustomerOrder c ON m.dish_name = c.dish_name
WHERE popularity = 'most popular'
GROUP BY c.dish_name, c.order_date;

-- Q3: Demo Queries

--Dylan
SELECT DATE_PART('doy', order_date) AS doy, COUNT(*) AS order_count
FROM CustomerOrder
GROUP BY DATE_PART('doy', order_date)
ORDER BY order_count DESC
LIMIT 1;

-- Output:
-- "doy"	"order_count"
-- 287	2

-- Ysabelle
SELECT s.sname, sr.ingredient, sr.ingredient_price / sr.quantity AS price_per
FROM Supplier s
JOIN s_supply_r sr ON s.supplier_id = sr.supplier_id
WHERE sr.ingredient = 'Tomatoes'
ORDER BY price_per DESC;

-- Output:
-- "sname"	"ingredient"	"price_per"
-- "Supplier3"	"Tomatoes"	0.79800000000000000000
-- "Supplier1"	"Tomatoes"	0.75000000000000000000
-- "Supplier2"	"Tomatoes"	0.66666666666666666667

--Arjun
(SELECT MAX(co.rating) AS rating, c.cname, c.customer_id, co.order_date
FROM CustomerOrder co
JOIN Customer12 c ON co.order_date = c.date_visited
GROUP BY co.rating, c.cname, c.customer_id, co.order_date
ORDER BY co.rating DESC
LIMIT 1)

UNION

(SELECT MIN(co.rating) AS rating, c.cname, c.customer_id, co.order_date
FROM CustomerOrder co
JOIN Customer12 c ON co.order_date = c.date_visited
GROUP BY co.rating, c.cname, c.customer_id, co.order_date
ORDER BY co.rating ASC
LIMIT 1);

-- Output:
-- "rating"	"cname"	"customer_id"	"order_date"
-- 3	"Sierra"	"8372"	"2024-02-21"
-- 5	"Christian"	"2324"	"2024-01-12"

--Q4: Reflection
-- We started out with a rough idea of making a database for the restaurant industry, including relationships 
-- between restaurants, suppliers and customers. Our first ERD was fairly simple, and after feedback, we expanded 
-- it to include more important columns and have a clearer organization. One of the biggest useful things that we 
-- learned during this process was how to take a rough concept for a database and materialize it into one that would 
-- actually be fully usable. One of the challenges of the process was deciding on the columns for each table. Every 
-- table we included could have included many more columns if we wanted that to be a part of the design—for example, 
-- MenuItem could have a column Silverware that specifies whether a dish needs to be served with a fork/spoon/knife/chopsticks/etc. 
-- Because each table could have endless columns, we did our best to consolidate each one to only the most necessary columns that 
-- provide important information about each entry and help connect the table to the other tables as needed. Another challenge was 
-- deciding how to translate our ERD diagram into SQL code, such as the relationships between tables. We worked through this by working 
-- together in person on the programming and going through different implementation options to see what would work best.


