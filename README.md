# Retail Sales Data Analysis

## Project Overview
This project focuses mainly on (ETLA) extracting, transformation, loading and analysis of retail sales order data from Kaggle and getting buisness insights by answering analytical questions using SQL.

![image](https://github.com/user-attachments/assets/da5583dd-8ea1-4e80-9b25-fa3b85b6227c)


## Repository Structure
```
📂 Retail-Sales-Analysis
│── 📄 README.md  # Project Documentation
│── 📄 order_analysis.ipynb  # Python code for data processing
│── 📄 orders.csv  # Extracted data in csv format
│── 📄 orders.csv.zip  # Extracted zip file data
│── 📄 sql_queries.sql  # SQL queries file
```


## Project Flow
1. **Data Extraction**
   - Downloaded dataset from Kaggle using Kaggle API.
   - Unzipped the file as csv file format.
   - load the csv dataset into Pandas DataFrame.
     
2. **Data Transformation**
   - Renamed the columns in lowercase, and underscore formatting.
   - Converted null-related values in column `ship_mode` to NULL.
   - Changed `order_date` 's column datatype to `datetime` datatype.
   - Created new columns: `discount`, `sale_price`, `profit`.
  
3. **Data Loading**
   - Created a table `df_orders` and defined DDL for that table in PostgreSQL.
   - Loaded the transformed dataframe dataset into the local PostgreSQL server by SQLAlchemy.
     
4. **Data Analysis**
   - Answer below key business questions using SQL queries:
     - Top 10 revenue-generating products
     - Top 5 selling products per region
     - Month-over-month growth comparison
     - Best sales month for each category
     - Highest growth subcategory in 2023 vs. 2022
       
5. **Additional Analytical Breakdown**
   - Sales Performance Analysis
   - Product Performance Analysis
   - Discount & Pricing Analysis
   - Customer & Order Analysis
   - Time-Based Trends
  
## For additional Analytics, the following Questions were answered for each category.

1. **Sales Performance Analysis**
   - Total revenue and profit
   - Revenue and profit by year 
   - Region with highest revenue and profit
   - Trends over month for revenue and profit

2. **Product Performance Analysis**
   - Top selling products with units sold, categories, sub-category
   - Most profitable products
   - Best selling product's categories
   - Best top 5 selling product's sub-categories

3. **Discount and pricing analysis**
   - How did discount affects sales ? 
   - Profit margin for each category
  
4. **Customer Order analysis**
   - What is the order distribution by customer segment?

5. **Time-Based Trends**
   - Which day of weeks has higher order counts and revenue ?


  
  
  
