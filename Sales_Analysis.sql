/* ============================================================
   🚀 E-COMMERCE PROFITABILITY - SQL BUSINESS QUESTIONS
   📊 Analyzing Profit & Loss Using PostgreSQL

   Author       : Prakrit Kumar
   Role         : Data Analyst
   Tool         : PostgreSQL
   Start Date   : 13 | September | 2026
============================================================ */

select * from dimgeography;
select * from dimdate;
select * from dimproduct;
select * from dimcustomer;
select * from dimpromotion;
select * from dimfulfillment;
select * from dimsaleschannel;
select * from dimreturnreason;
select * from dimcohortage;
select * from factorderline;

-- ========== EASY ==========
-- Q1: Year-wise (2024 vs 2025) total GrossSales, DiscountAmount, NetSales, and ContributionMargin

   select d.year,
          sum(f.grosssales) as total_sales,
		  sum(f.discountamount) as total_discount_amount,
		  sum(f.netsales) as total_netsales,
		  sum(f.contributionmargin) as total_contibutionmargin
   from factorderline f
   join dimdate d
   on f.orderdatekey = d.datekey
   group by d.year
   order by d.year;

-- Q2: Product Category-wise total NetSales and ContributionMargin (most profitable category)

	select d.category,
	       sum(f.netsales) as total_netsales,
		   sum(f.contributionmargin) as total_contibutionmargin
    from factorderline f
	join dimproduct d
	on f.productkey = d.productkey
	group  by d.category
	order by sum(f.contributionmargin) desc;

-- Q3: Month-wise (YearMonth) NetSales trend (best performing month)

   select d.month, 
          d.monthnumber,
		  sum(f.netsales) as total_netsales		  
   from factorderline f
   join dimdate d
   on f.orderdatekey = d.datekey
   group by d.month,d.monthnumber
   order by d.monthnumber;

-- Q4: SalesChannel-wise NetSales and total PaymentFee (most expensive channel by fee)

   select d.saleschannel,
          sum(f.netsales) as total_netsales,
		  sum(f.paymentfee) as total_paymentfee
   from factorderline f
   join dimsaleschannel d
   on f.saleschannelkey = d.saleschannelkey
   group by d.saleschannel
   order by sum(f.paymentfee) desc; 

-- Q5: Region/Country-wise NetSales and average ActualDeliveryDays

   select d.region,
          d.country,
          sum(f.netsales) as total_netsales,
		  Round(avg(f.actualdeliverydays),2) as avg_Actual_Delivery_Days
   from factorderline f
   join dimgeography d
   on f.geographykey = d.geographykey
   group by d.region,d.country
   order by sum(f.netsales) desc;

-- ========== MEDIUM ==========
select * from dimgeography;
select * from dimdate;
select * from dimproduct;
select * from dimcustomer;
select * from dimpromotion;
select * from dimfulfillment;
select * from dimsaleschannel;
select * from dimreturnreason;
select * from dimcohortage;
select * from factorderline;
-- Q6: AppliedDiscountPct bucketed (0-10%, 10-20%, 20-30%, 30%+) with average ContributionMargin per bucket

	select 
	      CASE
			  WHEN applieddiscountpct >= 0 AND applieddiscountpct  <= 0.10 THEN '0-10%'
			  WHEN applieddiscountpct >= 0.10 AND applieddiscountpct <= 0.20 THEN '10-20%'
			  WHEN applieddiscountpct >= 0.20 AND applieddiscountpct <= 0.30 THEN '20-30%'
			  WHEN applieddiscountpct >= 0.30 THEN '30%+'
			  else 'No'
         END AS discount_bucket,
		 COUNT(*) AS total_orders,
		 round(avg(contributionmargin),2) as avg_ContributionMargin_per_bucket,
		 SUM(netsales) AS total_net_sales
    from factorderline
	group by 1
	order by 1;

-- Q7: ReturnReasonGroup-wise total ReturnLoss and RefundAmount (biggest loss driver)

    select d.returnreasongroup,
	       sum(f.returnloss) as total_returanloss,
		   sum(f.refundamount) as total_refuan_amount
    from factorderline f
	join dimreturnreason d
	on f.returnreasonkey = d.returnreasonkey
	group by 1
	order by 2;

-- Q8: ProductSubcategory-wise ContributionMargin% = ContributionMargin / NetSales (loss-making subcategories)

	select subcategory,
	       total_contributionmargin,
		   total_net_sales,
		   round((total_contributionmargin / NULLIF(total_net_sales, 0)) * 100,2) AS loss_making_subcategories
	from (
		    select d.subcategory as subcategory,
			       sum(f.contributionmargin) as total_contributionmargin,
				   sum(f.netsales) as total_net_sales
		    from factorderline f
			join dimproduct d
			on f.productkey = d.productkey
			group by 1) as t
	where total_contributionmargin > 0
	order by loss_making_subcategories asc;	  

-- Q9: CustomerSegment-wise NetSales, ContributionMargin, and Average Order Value

   SELECT 
      c.customersegment,
      SUM(f.netsales) AS total_netsales,
      SUM(f.contributionmargin) AS total_contributionmargin,
      ROUND(SUM(f.netsales) / nullif(COUNT(DISTINCT f.orderid),0),2) AS average_order_value
   FROM factorderline f
   JOIN dimcustomer c 
   ON f.customerkey = c.customerkey
   GROUP BY c.customersegment
   ORDER BY total_netsales DESC;

-- Q10: FulfillmentCenter/Carrier-wise On-Time Delivery Rate (AVG(OnTimeFlag)) and total FulfillmentCost

   select d.fulfillmentcenter,
          d.carrier,
          sum(f.fulfillmentcost) as total_fulfillmentcost,
		  round(avg(f.ontimeflag) * 100 , 2)as on_time_rate
   from factorderline f 	  
   join dimfulfillment d
   on f.fulfillmentkey = d.fulfillmentkey
   group by 1,2
   order by 4 desc;
   
-- Q11: PromotionCampaign-wise ROI (GrossSales vs AllocatedMarketingCost) plus promoted vs non-promoted ContributionMargin comparison

    SELECT 
	     p.campaign,
	     SUM(f.grosssales) AS total_gross_sales,
	     SUM(f.allocatedmarketingcost) AS total_marketing_cost,
	     ROUND(((SUM(f.grosssales) - SUM(f.allocatedmarketingcost)) / NULLIF(SUM(f.allocatedmarketingcost), 0)) * 100,2)
		 AS roi_percentage
	FROM factorderline f
	JOIN dimpromotion p 
	ON f.promotionkey = p.promotionkey
	GROUP BY p.campaign
    ORDER BY roi_percentage DESC; 

-- Q12: Month-over-month NetSales growth % using LAG() window function

    select 
	      monthnumber as month_number,
		  month as month,
		  total_netsales,
		  previsus_month_sales,
		  (total_netsales-previsus_month_sales) as groth_and_loss,
		  round(((total_netsales-previsus_month_sales) / previsus_month_sales) * 100,2) as growth_percentage,
		  case
		      when (total_netsales-previsus_month_sales) > 0 then 'profit'
			  else 'loss'
		  end as indicate	  
     from(		  
			select 
			      d.monthnumber,
				  d.month,
				  sum(f.netsales) as total_netsales,
				  lag(sum(f.netsales)) over(order by d.monthnumber ) as previsus_month_sales
			from factorderline f
			join dimdate d
			on f.orderdatekey = d.datekey
			group by  d.monthnumber,d.month
		  )
      order by month_number;			
			
-- Q13: LifecycleStage-wise (from DimCohortAge) average NetSales per customer

  


-- ========== ADVANCED ==========
select * from dimgeography;
select * from dimdate;
select * from dimproduct;
select * from dimcustomer;
select * from dimpromotion;
select * from dimfulfillment;
select * from dimsaleschannel;
select * from dimreturnreason;
select * from dimcohortage;
select * from factorderline;
-- Q14: Month-wise cumulative running total of NetSales and ContributionMargin using SUM() OVER (ORDER BY month)



-- Q15: Quarter-wise full P&L waterfall: GrossSales -> Discount -> Refund -> NetSales -> all costs -> ContributionMargin



-- Q16: Top 10 loss-making products by total ContributionMargin, with their average discount% and return rate



-- Q17: CustomerSegment x Region matrix profitability, ranked with RANK() to find best/worst 5 combinations



-- Q18: Cohort heatmap: CohortMonth x MonthsSinceFirstPurchase wise ContributionMargin trend



-- Q19: Discount% vs ReturnRate vs Margin bucketed aggregate table (for scatter/bubble chart use)




-- Q20: Outlier detection: products whose ContributionMargin is below (category AVG - 2*STDDEV) using window functions





