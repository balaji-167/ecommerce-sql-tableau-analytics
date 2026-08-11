# E-commerce Business Analysis using SQL and Tableau

Turning raw e-commerce data into a structured database and four interactive dashboards that answer where the revenue comes from, which products actually make money, and why customers stop coming back.

**[View the interactive dashboard on Tableau Public](https://public.tableau.com/shared/92S6K28XY?:display_count=n&:origin=viz_share_link)**

---

## Project Overview

An online store generates data from everywhere. Orders, individual product lines, website sessions, clicks, reviews. On their own, none of those files answers a business question. They sit in separate places, in inconsistent formats, and anyone who wants a straight answer ends up rebuilding the same calculation from scratch every time.

This project takes those raw files, loads them into PostgreSQL, cleans and restructures them in layers, and models them so that any business question can be answered from one consistent source. It then builds four Tableau dashboards on top of that model, covering overall performance, product profitability, customer health and user behaviour.

The point of the project is not just the dashboards. It is the layer underneath them that makes the numbers agree with each other.

---

## Business Problem

Most e-commerce businesses know their revenue. Far fewer can say where it is actually coming from, which products are carrying it, and which customers are quietly leaving.

Growth spend usually goes into acquiring more traffic, because traffic is easy to measure. Meanwhile customers who were already bought and paid for stop returning, and nobody notices until the growth number flattens. This project was built to expose that gap with numbers rather than opinion.

---

## Questions This Project Answers

1. How is the business performing overall, and where is the revenue concentrated by market and over time?
2. Which products and categories actually generate profit, as opposed to simply generating sales?
3. Where are customers being lost, both inside the buying journey and after their first purchase?

---

## Tools and Technologies

| Tool | Purpose |
| :--- | :--- |
| PostgreSQL | Database, data modeling and SQL analysis |
| SQL | Cleaning, transformation, joins, CTEs, views and window functions |
| Tableau Public | Interactive dashboards and reporting |
| Draw.io | Data architecture and data model diagrams |
| CSV | Raw and processed data storage |
| GitHub | Documentation and portfolio publishing |

---

## Skills Demonstrated

* SQL data cleaning and standardisation
* Layered data architecture design
* Star schema modeling with fact and dimension views
* Window functions, CTEs and ranking logic
* Funnel analysis and cohort retention analysis
* RFM segmentation, churn classification and customer lifetime value
* Dashboard design and interactive reporting
* Business insight generation

---

## Understanding the Data

### What the data covers

The project works with five kinds of records from an online store.

| Record type | What it holds |
| :--- | :--- |
| Orders | One row per order placed, with the customer, date and value |
| Order items | One row per product inside an order, which is where profit is calculated |
| Sessions | One row per visit to the website |
| Events | One row per action taken during a visit, such as viewing a page or adding to cart |
| Reviews | Ratings and written feedback left on products |

Sessions and events are what make this more than a sales analysis. Order data tells you what people bought. Event data tells you what they nearly bought and where they gave up.

### Plain language glossary

| Term | What it means in simple words |
| :--- | :--- |
| Average Order Value | Total revenue divided by number of orders. What a typical order is worth |
| Median Order Value | The middle order. Half of all orders are worth more, half less |
| Profit margin | The share of the selling price the business actually keeps after cost |
| Funnel | The steps a visitor passes through on the way to buying. Every step loses some people |
| Churn | A customer who stopped buying and has not returned |
| Customer Lifetime Value | The total money a customer is expected to bring in across their whole relationship with the business |
| RFM | A way of scoring customers on how recently they bought, how often, and how much they spent |
| Cohort retention | Grouping customers by the month they joined, then tracking how many of them come back each month afterwards |
| Star schema | A way of organising tables so that business questions can be answered without complicated joins |

### Why the data is built in three layers

The database is organised using a Medallion approach, which simply means the data is improved in stages rather than cleaned all at once.

```text
Raw CSV files
      ↓
Bronze layer     raw data loaded exactly as received, nothing changed
      ↓
Silver layer     cleaned and standardised views
      ↓
Gold layer       fact and dimension views ready for reporting
      ↓
Tableau dashboards
```

The reason for working this way is traceability. If a number on a dashboard looks wrong, you can walk backwards through the layers to find exactly where it changed, instead of guessing. The raw file is never overwritten, so the whole pipeline can be rerun from scratch at any time.

---

## Data Model

The Gold layer follows a star schema style model. Two dimension views describe who and what, and five fact views record what happened.

**Dimension views**

| View | Description |
| :--- | :--- |
| `gold.dim_customers` | Customer attributes |
| `gold.dim_products` | Product attributes |

**Fact views**

| View | Description |
| :--- | :--- |
| `gold.fact_orders` | Order level transactions |
| `gold.fact_order_items` | Product level order lines |
| `gold.fact_sessions` | Session level user activity |
| `gold.fact_events` | Event level clickstream behaviour |
| `gold.fact_reviews` | Product review facts |

![E-commerce Data Model](assets/ecommerce_data_model.png)

---

## Step by Step Process

### Step 1: Data Cleaning and Standardisation

The Silver layer exists purely to make the raw data trustworthy before anything is measured.

* Standardised column names so that the same field is called the same thing everywhere.
* Corrected data types, converting product IDs, quantities and cart sizes into proper integer formats instead of text.
* Converted date and time fields into real date types, without which no trend, cohort or retention analysis is possible.
* Cleaned numeric fields and standardised country codes so that the same market does not split into two rows on a chart.
* Preserved review text intact for feedback analysis rather than stripping it during cleaning.
* Validated primary and foreign key relationships across tables to confirm that orders link correctly to customers and products.

**Why this matters to the business.** The last point is the one that saves a project. If order items do not join cleanly to orders, revenue by product silently stops matching total revenue, and two dashboards end up disagreeing in front of stakeholders.

### Step 2: Exploratory Data Analysis

* Measured overall scale first: total revenue, orders, customers and order value, to establish what normal looks like before drilling into anything.
* Compared average order value against median order value to understand the shape of the revenue rather than just its size.
* Broke revenue down by country and by month to see where it comes from and whether it is moving.
* Examined the spread of product ratings and the distribution of customers across value segments.

**What came out of it.** Average order value came in at $133.81 while the median was $86.46. That gap is the interesting part. It means a smaller group of larger orders is pulling the average up, and that the typical customer spends noticeably less than the headline average suggests. Any target set against the average alone would be set too high.

### Step 3: SQL Analysis

This is where the analytical views were built, using joins, CTEs, CASE logic, window functions, ranking and date functions.

* Built a product profitability analysis comparing revenue against profit at both product and category level, since the highest selling product and the most profitable product are not always the same one.
* Built a session funnel to measure how many visitors move from viewing a page, to adding to cart, to checkout, to purchase.
* Built cohort retention analysis to track how many customers from each joining month return in later months.
* Applied RFM segmentation and churn classification to sort customers into active, at risk and lost groups.
* Calculated customer lifetime value and identified which lapsed customers carry the most recoverable revenue.
* Measured conversion across combinations of traffic source and device.

**Results.**

| Area | Finding |
| :--- | :--- |
| Scale | Approximately $4.49M revenue across 33,580 orders from 16,268 customers |
| Order value | Average of $133.81 against a median of $86.46 |
| Markets | The United States was the largest revenue contributing country |
| Products | Top revenue products also contribute strongly to profit, and Electronics carried the highest category profit margin |
| Funnel | Traffic falls from around 120K page views to around 34K purchases, with the largest single drop between Add to Cart and Checkout |
| Channels | The Social and Tablet combination produced the strongest conversion rate |
| Retention | Retention weakens sharply in the months after acquisition, and the churned share of customers is high |

### Step 4: Business Insight Generation

* The product side of this business is healthy. Margins are balanced across categories, the best sellers are also profitable, and there is no sign of revenue being propped up by loss making products.
* The real weakness is retention, not acquisition. The business is successfully bringing customers in and then losing them, which means money spent on more traffic is being poured into a leaking bucket.
* The biggest single recoverable loss sits between Add to Cart and Checkout. A customer at that point has already chosen the product. Losing them is a friction problem, not a demand problem, and friction is cheaper to fix than demand is to create.
* Channel performance should not be judged on traffic volume. The strongest converting source and device combination is not the highest traffic one, so optimising for visits alone would push spend in the wrong direction.
* There is a clearly identifiable group of lapsed customers with high past value. Winning back a customer who has already bought once costs far less than acquiring a stranger.

---

## Dashboards

### Executive Overview

Total revenue, orders, customers, average and median order value, the monthly revenue trend and revenue by country. This is the page that answers how the business is doing before anyone asks why.

![Executive Overview Dashboard](assets/dashboard_1_executive_overview.png)

### Product and Category Performance

Top products by revenue and by profit, a product profitability matrix, category revenue against profit, margin ranking and the rating distribution. Built so that a merchandising decision can be made from one screen.

![Product and Category Performance Dashboard](assets/dashboard_2_product_performance.png)

### Customer Health and Retention

Churn risk funnel, revenue at risk, customer lifetime value matrix, RFM value segments, a retention curve and a ranked list of the best recovery targets. This page turns churn from a statistic into a named list of customers worth contacting.

![Customer Health and Retention Dashboard](assets/dashboard_3_customer_retention.png)

### Customer Behaviour and Conversion

Session funnel conversion, a source and device conversion heatmap, the most common user path transitions and a cohort retention heatmap. This is the page that shows where people leave rather than what they bought.

![Customer Behaviour Dashboard](assets/dashboard_4_customer_behavior.png)

---

## Business Recommendations

1. **Fix the cart to checkout drop first.** It is the largest loss in the funnel and it involves customers who have already decided to buy. Show the full cost including delivery earlier, reduce distractions on the cart page, add trust signals and reminders for abandoned carts, and treat mobile checkout as its own problem rather than a smaller version of desktop.
2. **Run reactivation before increasing acquisition spend.** Target high value lapsed customers and recent one time buyers first, since both groups have already proven they will pay. The recovery target list on the retention dashboard is where this campaign starts.
3. **Push the products that earn, not the products that sell.** Give high margin products more visibility, plan inventory around them, and build bundles that pull profitable items alongside popular ones.
4. **Build a review engine for top revenue products.** Request reviews after delivery, prioritise the products that carry the most revenue, and surface rating and review count where the buying decision is made.
5. **Judge marketing channels on conversion and customer value, not on traffic.** Shift spend towards the source and device combinations that actually convert, and connect each channel back to the lifetime value of the customers it brings in.

---

## Repository Structure

```text
ecommerce-sql-tableau-analytics/
│
├── sql/          SQL scripts for the Bronze, Silver and Gold layers
├── data/         Raw, cleaned and reporting ready data
├── tableau/      Tableau workbook and public dashboard link
├── assets/       Dashboard screenshots and data model diagrams
├── docs/         Business insights, dashboard guide, SQL summary, data dictionary
├── README.md
└── LICENSE
```

---

## How to Reproduce This Project

1. Import the raw CSV files into PostgreSQL as the Bronze layer.
2. Run the SQL scripts in the `sql/` folder in order.
3. Create the Silver layer cleaned views.
4. Create the Gold layer fact, dimension and analytical views.
5. Export the Gold layer outputs as CSV files.
6. Connect those CSV files to Tableau.
7. Open the Tableau workbook to load the four dashboards.

---

## Supporting Documentation

| Document | Description |
| :--- | :--- |
| [Business Insights](docs/business_insights.md) | Detailed findings and recommendations |
| [Dashboard Guide](docs/dashboard_guide.md) | Walkthrough of all four Tableau dashboards |
| [SQL Analysis Summary](docs/sql_analysis_summary.md) | SQL workflow, concepts and analytical views |
| [Data Dictionary](docs/data_dictionary.md) | Field level definitions |

---

## License

Released under the MIT License.

---

## About the Author

**Balaji Reddy**
[LinkedIn](https://linkedin.com/in/balajireddy16) | [GitHub](https://github.com/balaji-167)
