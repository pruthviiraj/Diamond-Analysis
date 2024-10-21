/* Creating the database for mid-term-project as 'mid_term_project' */

CREATE DATABASE mid_term_project_1;
USE mid_term_project_1;

/* Creating 'diamonds' table */

CREATE TABLE diamonds (
  id SERIAL PRIMARY KEY,
  carat NUMERIC(5,2),
  cut VARCHAR(30),
  color CHAR(1),
  clarity VARCHAR(10),
  depth NUMERIC(5,2),
  tables NUMERIC(5,2),
  price INTEGER,
  x NUMERIC(5,2),
  y NUMERIC(5,2),
  z NUMERIC(5,2)
);

/* Importing "diamonds.csv" dataset to the 'diamonds' table */

LOAD DATA INFILE "C:/Users/pruth/OneDrive/Desktop/Pace University/Semester 1/DBMS/MID-Term/Project - 1/CSV files/diamonds.csv"
INTO TABLE diamonds
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(carat, cut, color, clarity, depth, tables, price, x, y, z);

SELECT * FROM diamonds LIMIT 10;

/* Creating 'diamond_char' table with constraints */

CREATE TABLE diamond_char (
  c_id INT PRIMARY KEY AUTO_INCREMENT,
  carat NUMERIC(5,2),
  cut VARCHAR(30),
  color CHAR(1),
  clarity VARCHAR(10)
);

/* Inserting the data into diamond_char table */ 

INSERT INTO diamond_char (c_id, carat, cut, color, clarity)
SELECT ROW_NUMBER() OVER (ORDER BY carat) as c_id, carat, cut, color, clarity
FROM diamonds;

SELECT * FROM diamond_char LIMIT 5;

/* Creating 'diamond_msrmt' table with constraints */

CREATE TABLE diamond_msrmt (
  m_id INTEGER PRIMARY KEY AUTO_INCREMENT,
  diamond_id INTEGER,
  depth NUMERIC(5,2),
  tables NUMERIC(5,2),
  price INTEGER,
  x NUMERIC(5,2),
  y NUMERIC(5,2),
  z NUMERIC(5,2),
  FOREIGN KEY (diamond_id) REFERENCES diamond_char (c_id)
);

/* Inserting the data into 'diamond_mrsmt' table */
INSERT INTO diamond_msrmt (m_id, diamond_id, depth, tables, price, x, y, z)
SELECT ROW_NUMBER() OVER (ORDER BY id) as m_id, id, depth, tables, price, x, y, z
FROM diamonds;

SELECT * FROM diamond_msrmt LIMIT 10;


/* Creating new procedure to insert a new diamond characteristic into 'diamond_char' table */

DELIMITER $$
CREATE PROCEDURE insert_diamond_char(
  IN carat_val NUMERIC(5,2),
  IN cut_val VARCHAR(30),
  IN color_val CHAR(1),
  IN clarity_val VARCHAR(10)
)
BEGIN
  INSERT INTO diamond_char (carat, cut, color, clarity) 
  VALUES (carat_val, cut_val, color_val, clarity_val);
END $$
DELIMITER ;

 /* Inserting data into stored procedures */
 
CALL insert_diamond_char(0.77, 'Premium', 'Z', 'ZS1');
SELECT * FROM diamond_char ORDER BY c_id DESC LIMIT 1;
 
/* Creating new procedure to insert a new diamond characteristic into 'diamond_msrmt' table */

DELIMITER $$
CREATE PROCEDURE insert_diamond_msrmt(
    IN p_diamond_id INTEGER,
    IN p_depth NUMERIC(5,2),
    IN p_tables NUMERIC(5,2),
    IN p_price INTEGER,
    IN p_x NUMERIC(5,2),
    IN p_y NUMERIC(5,2),
    IN p_z NUMERIC(5,2)
)
BEGIN
    INSERT INTO diamond_msrmt (diamond_id, depth, tables, price, x, y, z)
    VALUES (p_diamond_id, p_depth, p_tables, p_price, p_x, p_y, p_z);
END $$
DELIMITER ;

 /* Inserting data into stored procedures */
 
CALL insert_diamond_msrmt(1, 61.5, 55, 326, 3.95, 3.98, 2.43);
SELECT * FROM diamond_msrmt ORDER BY m_id DESC LIMIT 1;


/* Creating a function to calculate the average carat weight for a given cut */

DELIMITER $$
CREATE FUNCTION avg_carat_by_cut(cut_type VARCHAR(30))
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
DECLARE avg_carat DECIMAL(10,2);
SELECT AVG(carat) INTO avg_carat
FROM diamond_char
WHERE cut = cut_type;
RETURN avg_carat;
END $$
DELIMITER ;

SELECT avg_carat_by_cut('Ideal') AS avg_carat;

/* Creating function to find the number of diamonds with a specific clarity */

DELIMITER $$
CREATE FUNCTION count_diamonds_by_clarity(clarity_type VARCHAR(10))
RETURNS INT
DETERMINISTIC
BEGIN
DECLARE clarity_count INT;
SELECT COUNT(*) INTO clarity_count
FROM diamond_char
WHERE clarity = clarity_type;
RETURN clarity_count;
END $$
DELIMITER ;

SELECT count_diamonds_by_clarity('SI1') AS clarity_count;

/*  Creating Function to find the total carat weight for a given color */

DELIMITER $$
CREATE FUNCTION total_carat_by_color(color_type CHAR(1))
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
DECLARE total_carat DECIMAL(10,2);
SELECT SUM(carat) INTO total_carat
FROM diamond_char
WHERE color = color_type;
RETURN total_carat;
END $$
DELIMITER ;

SELECT total_carat_by_color('E') AS total_carat LIMIT 10;

/* 1. Creating a view that shows the average price, depth, and table percentage for each cut */

CREATE VIEW avg_price_depth_table_by_cut AS
SELECT cut,
  AVG(price) AS avg_price,
  AVG(depth) AS avg_depth,
  AVG(tables) AS avg_table
FROM diamond_char
JOIN diamond_msrmt ON diamond_char.c_id = diamond_msrmt.diamond_id
GROUP BY cut;

SELECT * FROM avg_price_depth_table_by_cut;

/* 2. Creating a view that shows the total carat weight and average price for each color */

CREATE VIEW total_carat_avg_price_by_color AS
SELECT color,
  SUM(carat) AS total_carat,
  AVG(price) AS avg_price
FROM diamond_char
JOIN diamond_msrmt ON diamond_char.c_id = diamond_msrmt.diamond_id
GROUP BY color;

SELECT * FROM total_carat_avg_price_by_color;

/* 3. Creating a view that shows the number of diamonds, total carat weight, 
and average carat weight for each clarity and cut combination */

CREATE VIEW diamonds_summary_by_clarity_cut AS
SELECT clarity, cut,
  COUNT(*) AS num_of_diamonds,
  SUM(carat) AS total_carat_weight,
  AVG(carat) AS avg_carat_weight
FROM diamond_char
GROUP BY clarity, cut;

SELECT * FROM diamonds_summary_by_clarity_cut LIMIT 10;

/* Creating an index on diamond_char table for clarity column */

CREATE INDEX idx_diamond_char_clarity ON diamond_char (clarity);
SHOW INDEX FROM diamond_char WHERE Key_name = 'idx_diamond_char_clarity';


/* Using ordered by total carat weight in descending order to find total
carat weight and average price for each color */

SELECT * FROM total_carat_avg_price_by_color
ORDER BY total_carat DESC;

/* Querying the no.of  diamonds, total carat weight, and average carat weight for 
 each clarity and cut combination where the average carat weight is between 0.7 and 2.0 */
 
SELECT * FROM diamonds_summary_by_clarity_cut
WHERE avg_carat_weight BETWEEN 0.7 AND 2.0 LIMIT 10;

/* Querying the average price, depth, and table percentage 
for each cut, grouped by cut, having an average price greater than 2000 */

SELECT cut, AVG(price) AS avg_price, AVG(depth) AS avg_depth, AVG(tables) AS avg_table
FROM diamond_char
JOIN diamond_msrmt ON diamond_char.c_id = diamond_msrmt.diamond_id
GROUP BY cut
HAVING AVG(price) > 2000
ORDER BY avg_price DESC;

/* Querying the no.of diamonds is greater than 500 and average carat weight is less than 0.6
   or the no.of diamonds less than 100 and average carat weight is greater than 1.0 */

SELECT * FROM diamonds_summary_by_clarity_cut
WHERE (num_of_diamonds > 500 AND avg_carat_weight < 0.6) OR (num_of_diamonds < 100 AND avg_carat_weight > 1.0)
LIMIT 5;

/* Quering the average depth and table percentage for each clarity, 
along with the number of diamonds for each clarity */

WITH clarity_summary AS (
  SELECT clarity, COUNT(*) AS num_of_diamonds, AVG(depth) AS avg_depth, AVG(tables) AS avg_table
  FROM diamond_char
  JOIN diamond_msrmt ON diamond_char.c_id = diamond_msrmt.diamond_id
  GROUP BY clarity
)
SELECT clarity, num_of_diamonds, ROUND(avg_depth, 2) AS avg_depth, ROUND(avg_table, 2) AS avg_table
FROM clarity_summary
ORDER BY num_of_diamonds DESC LIMIT 5;
