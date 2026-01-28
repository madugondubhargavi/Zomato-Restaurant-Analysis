CREATE DATABASE zomato_db;
USE zomato_db;


CREATE TABLE country_codes (
    country_code INT PRIMARY KEY,
    country_name VARCHAR(100)
);

CREATE TABLE zomato_restaurants (
    restaurant_id INT PRIMARY KEY,
    restaurant_name VARCHAR(255),
    country_code INT,
    city VARCHAR(100),
    cuisines VARCHAR(255),
    average_cost_for_two INT,
    price_range INT,
    votes INT,
    rating DECIMAL(3,2),
    has_table_booking VARCHAR(10),
    has_online_delivery VARCHAR(10),
    year INT,
    month INT,
    month_name VARCHAR(20),
    quarter VARCHAR(10)
);

SELECT COUNT(*) FROM country_codes;
SELECT COUNT(*) FROM zomato_restaurants;

SHOW TABLES;

SELECT * FROM country_codes LIMIT 5;
SELECT * FROM zomato_restaurants LIMIT 5;

-- JOIN
SELECT z.RestaurantName, c.country_name
FROM zomato_restaurants z
LEFT JOIN country_codes c
ON z.CountryCode = c.country_code
LIMIT 5;

-- VIEW
DROP VIEW IF EXISTS zomato_master;

CREATE VIEW zomato_master AS
SELECT 
    z.RestaurantID,
    z.RestaurantName,
    z.CountryCode,
    c.country_name,
    z.City,
    z.Cuisines,
    z.Average_Cost_for_two,
    z.Price_range,
    z.Votes,
    z.Rating,
    z.Has_Table_booking,
    z.Has_Online_delivery,
    z.Year,
    z.Month,
    z.Month_Name,
    z.Quarter
FROM zomato_restaurants z
LEFT JOIN country_codes c
ON z.CountryCode = c.country_code;


SELECT * FROM zomato_master LIMIT 5;

-- KPI'S
-- 1 Number of Restaurants by Country

SELECT country_name, COUNT(*) AS total_restaurants
FROM zomato_master
GROUP BY country_name
ORDER BY total_restaurants DESC;

-- 2 Restaurants by City

SELECT City, COUNT(*) AS total_restaurants
FROM zomato_master
GROUP BY City
ORDER BY total_restaurants DESC
LIMIT 10;

-- 3 Restaurants by Rating

SELECT Rating, COUNT(*) AS total_restaurants
FROM zomato_master
GROUP BY Rating
ORDER BY Rating DESC;

-- 4 Table Booking Percentage

SELECT Has_Table_booking, COUNT(*) * 100.0 / (SELECT COUNT(*) FROM zomato_master) AS percentage
FROM zomato_master
GROUP BY Has_Table_booking;

-- 5 Online Delivery Percentage

SELECT Has_Online_delivery, COUNT(*) * 100.0 / (SELECT COUNT(*) FROM zomato_master) AS percentage
FROM zomato_master
GROUP BY Has_Online_delivery;

-- 6 Restaurants by Opening Year / Month / Quarter
-- By Year
SELECT Year, COUNT(*) AS restaurants_opened
FROM zomato_master
GROUP BY Year
ORDER BY Year;

-- By Month
SELECT Month_Name, COUNT(*) AS restaurants_opened
FROM zomato_master
GROUP BY Month_Name;

-- By Quarter
SELECT Quarter, COUNT(*) AS restaurants_opened
FROM zomato_master
GROUP BY Quarter;

-- 7 Restaurant Bucket Analysis (Average Price)

SELECT Price_range, COUNT(*) AS total_restaurants, AVG(Rating) AS avg_rating
FROM zomato_master
GROUP BY Price_range
ORDER BY Price_range;

-- 8 Performance Based on Cost & Restaurant Count

SELECT Average_Cost_for_two, COUNT(*) AS restaurant_count, AVG(Rating) AS avg_rating
FROM zomato_master
GROUP BY Average_Cost_for_two
ORDER BY Average_Cost_for_two;

-- 9 Performance Based on Votes & Rating

SELECT Rating, AVG(Votes) AS avg_votes, COUNT(*) AS total_restaurants
FROM zomato_master
GROUP BY Rating
ORDER BY Rating DESC;


DESCRIBE zomato_restaurants;

-- Stored Procedures


-- Triggers
DELIMITER $$

CREATE TRIGGER trg_fix_negative_votes
BEFORE INSERT ON zomato_restaurants
FOR EACH ROW
BEGIN
    IF NEW.Votes < 0 THEN
        SET NEW.Votes = 0;
    END IF;
END$$

DELIMITER ;

SHOW TRIGGERS;















