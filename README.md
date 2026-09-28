# E-Commerce Profitability & Fulfillment Analysis

An end-to-end data analysis project where I cleaned raw e-commerce data with Python, modeled it in PostgreSQL, answered business questions with SQL, and built a 6-page Power BI dashboard. I built it for the ZoomCharts Challenge (September 2026).

**Author:** Prakrit Kumar
**Tools:** Python (Pandas, NumPy), PostgreSQL, Power BI

---

## Business Problem

The company sells online across multiple regions and channels, but high sales do not always mean high profit. Discounts, returns, shipping, payment fees and marketing costs all eat into the margin.

I wanted to find out:
- Which categories, products and customer segments actually make money, and which ones lose it?
- How much do discounts and returns hurt the contribution margin?
- Which sales channels, regions and fulfillment centers cost the most?
- Are deliveries on time, and does that change with location or carrier?

---

## Dataset

The data comes as one Excel file (`Raw_data.xlsx`) with 10 tables in a star schema:

| Type | Tables |
|---|---|
| Fact | `FactOrderLine` (9,109 rows, 46 columns) |
| Dimensions | `DimDate`, `DimProduct`, `DimCustomer`, `DimGeography`, `DimPromotion`, `DimFulfillment`, `DimSalesChannel`, `DimReturnReason`, `DimCohortAge` |

The data covers orders from 2024 to 2025. There is also a data dictionary sheet explaining every column.

---

## How I Did It

### 1. Data Cleaning (Python)
File: `notebook/Data_Cleaning.ipynb`

- Loaded all sheets and checked head, info, nulls, duplicates and statistics for each table.
- Found no duplicate rows.
- Found some nulls in the fact table (delivery date, actual delivery days, on-time flag, return date). I did **not** fill them, because they are meaningful: 142 orders were cancelled due to stockout so they were never delivered, and most orders were simply never returned.
- Converted all column names to lowercase so they work cleanly with PostgreSQL.

### 2. Database Design (PostgreSQL)
File: `sql/01_database_creation.sql`

- Created all 10 tables with primary keys, foreign keys and proper data types.
- Kept the star schema: one fact table connected to 9 dimension tables. The date table is used for order, ship, delivery and return dates.

### 3. SQL Analysis
File: `sql/02_sales_analysis.sql`

I wrote 20 business questions in three levels:

- **Easy (Q1-Q5):** yearly totals, category profit, monthly trend, channel fees, region-wise sales and delivery days.
- **Medium (Q6-Q13):** discount buckets, return loss by reason, subcategory margin %, customer segments, fulfillment on-time rate, promotion ROI, month-over-month growth using `LAG()`.
- **Advanced (Q14-Q20):** running totals, quarterly P&L waterfall, loss-making products, ranking with `RANK()`, cohort analysis and outlier detection.

> **Status:** Q1-Q12 are done. Q13-Q20 are still in progress and I will keep updating this file.

### 4. Dashboard (Power BI)
File: `dashboard/Zoomchart_dashboard.pbix`

The report has 6 pages with slicers and navigation buttons:

1. **Home Page** - cover and navigation
2. **Executive Overview** - main KPIs, sales trend and profit summary
3. **Customer & Sales Analysis** - customer segments and sales performance
4. **Fulfillment, Returns & Profitability** - delivery performance and return losses
5. **Product & Promotion Analysis** - category, product and campaign results
6. **Geography Analysis** - region and country performance

![Executive Overview](images/executive_overview.png)

---

## Key Insights

- **Top category:** [category name] gave the highest contribution margin of [value].
- **Discounts:** orders with more than [x]% discount had a much lower average margin than orders with small discounts.
- **Returns:** [reason group] was the biggest driver of return loss.
- **Channels:** [channel name] had the highest payment fees.
- **Delivery:** [region/carrier] had the lowest on-time delivery rate.

---

## Recommendations

- Review or limit heavy discounts on products where the margin is already low.
- Look into the top return reasons and fix them at the source (product quality, size info, packaging).
- Compare carriers and fulfillment centers on cost *and* on-time rate before choosing one.

---

## Project Structure

````
ecommerce-profitability-fulfillment-analysis/
├── data/
│   └── Raw_data.xlsx
├── notebook/
│   └── Data_Cleaning.ipynb
├── sql/
│   ├── 01_database_creation.sql
│   └── 02_sales_analysis.sql
├── dashboard/
│   └── Zoomchart_dashboard.pbix
├── images/
└── README.md
````

## How to Run

1. Open `Data_Cleaning.ipynb` in Jupyter and run it with `Raw_data.xlsx` in the same folder.
2. Run `01_database_creation.sql` in PostgreSQL to create the tables, then load the cleaned data.
3. Run the queries from `02_sales_analysis.sql`.
4. Open the `.pbix` file in Power BI Desktop.

## What I Learned

- Cleaning data is not just removing nulls. Some nulls carry business meaning.
- Designing a star schema first makes both SQL and Power BI much easier.
- Window functions like `LAG()` and `RANK()` are very useful for trend and ranking questions.

## Contact

**Prakrit Kumar** - Aspiring Data Analyst, Pune
LinkedIn: [https://www.linkedin.com/in/prakritsingh-08-india/] | Email: [prakritsingh900@gmail.com]
````
````
