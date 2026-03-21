# Target Brazil E-commerce Analysis (BigQuery SQL)

## Overview
This project analyzes Target’s e-commerce operations in Brazil using SQL on BigQuery. The dataset contains approximately 100,000 orders placed between 2016 and 2018, providing insights into customer behavior, order trends, delivery performance, and payment patterns.

The goal of this analysis is to extract meaningful business insights that can help improve operational efficiency, customer experience, and overall decision-making.

---

## Business Objective
- Understand customer purchasing behavior
- Analyze order trends over time
- Evaluate delivery performance vs estimated timelines
- Identify regional performance differences
- Study payment methods and seasonality
- Analyze pricing and freight cost distribution

---

## Tools & Technologies
- Google BigQuery
- SQL

---

## Dataset Description
The dataset includes information related to:

- Orders (order status, timestamps)
- Payments (payment type, installments)
- Shipping (freight value, delivery time)
- Customers (location: city, state)
- Products (categories, pricing)
- Reviews (customer satisfaction)

---

## Analysis Performed

### Order Trends
- Yearly order growth analysis
- Monthly order trends by payment type
- Seasonal patterns in order placement

### Payment Analysis
- Orders based on payment installments
- Distribution of payment types

### Delivery Performance
- Difference between actual and estimated delivery time
- Fastest delivery states
- States with highest & lowest delivery time

### Pricing & Freight Analysis
- Total & average order value by state
- Freight cost distribution across states
- States with highest & lowest freight values
- Year-over-year cost increase analysis (2017–2018)

### Customer Analysis
- Customer distribution across states
- Customer location insights (city/state level)
- Time-of-day purchase behavior

---

## Key Insights
- Identified states with faster-than-expected delivery performance
- Observed significant variation in freight costs across regions
- Found clear seasonality patterns in order placement
- Payment methods and installment usage influence order trends
- Customer distribution is concentrated in specific regions

---

## Project Structure

target-sql-analysis/

queries/ # SQL query files
images/ # Query results 
README.md # Project documentation


---

## How to Use
1. Open the SQL files inside the `queries/` folder
2. Run them in BigQuery
3. Refer to screenshots in `images/` for outputs
4. Modify queries for deeper analysis if needed

---

## Conclusion
This project demonstrates how SQL and BigQuery can be used to analyze large-scale e-commerce data and generate actionable insights. It highlights key business metrics such as delivery efficiency, customer behavior, and revenue patterns, which are critical for data-driven decision-making.






