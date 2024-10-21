# Diamond Analysis using SQL
This project focuses on building a MySQL database to analyze diamond characteristics and measurements, enabling complex queries and insights into diamond pricing based on various features.

# Problem Overview:

The Diamond Analysis is designed to analyze a dataset of diamonds, with a focus on characteristics such as carat weight, cut, color, and clarity, as well as measurements like depth, table, and price. The project demonstrates the use of database management techniques, SQL queries, and performance optimizations to gain valuable insights from the data.

# Features

**Data Import:**
The dataset of diamonds is imported from a CSV file into MySQL.
Two tables, diamond_char and diamond_msrmt, store diamond characteristics and measurements, respectively.
 
**Key SQL Queries:**

**Average Price per Carat:** Analysis by cut, clarity, and color.

**Correlation Analysis:** Determining the relationship between carat weight and price.

**Advanced Filtering:** Queries to filter diamonds by specific characteristics (e.g., Ideal cut with color D or Premium cut with clarity IF).

**Aggregated Price Analysis:** Using SQL’s GROUP BY and HAVING clauses to calculate average and total prices for diamonds grouped by different attributes.
 
**MySQL Functions and Views:**
Custom functions automate diamond data insertion for both characteristics and measurements.
Views (diamond_info, avg_price_by_cut_clarity) provide a simplified view for data retrieval and combined insights from both tables.
 
 **Performance Optimization:**
Indexes on key columns (cut, price) to improve query performance for large datasets.

# Database Structure

**Tables:**
diamond_char: Contains information on carat weight, cut, color, and clarity.
diamond_msrmt: Stores measurements such as depth, table, price, and dimensions (x, y, z).
 
 **Relationships:**
The diamond_msrmt table references diamond_char via a foreign key (diamond_id), linking diamond characteristics to their measurements.

# SQL Highlights

**Aggregate Queries:**
Average, minimum, and maximum carat weights for each color.
Average price for diamonds grouped by cut and clarity.
 
**Advanced SQL:**
Complex queries using WITH, GROUP BY, and ORDER BY.
Example: Query to find the total price of diamonds grouped by cut and display the top two cuts with the highest total price.
 
**Correlation Analysis:**
The project calculates the correlation between diamond carat and price to evaluate the relationship between these factors.

# Future Improvements
Enhance the dataset with additional features for deeper analysis.
Add more complex queries, such as clustering diamonds based on price or measurements.
Implement further performance optimizations, such as partitioning large tables.
