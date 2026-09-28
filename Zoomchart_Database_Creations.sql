/* ============================================================
   🗄️ 0. DATABASE & TABLE CREATION
   Setting up PostgreSQL database for E-Commerce Profitability Project
============================================================ */

-- My (1) table is dimgeography table

create table dimgeography (

	geographykey       text primary key,
    region             text,
    country            text,
    city               text,
    aovindex           numeric(15,2),
    shippingcostindex  numeric(15,2),
    expectedontimerate numeric(15,2)
);

-- my (2) table is dimdate table

create table dimdate(

	datekey         int primary key,
  	date            date,
 	year            int,
	quarter         text,
 	yearquarter     text,
 	monthnumber     int,
 	month           text,
 	yearmonth       text,
 	weeknumber      int,
 	yearweek        text,
	day             int,
	dayofweeknumber int,
 	dayofweek       text,
	daytype         text
);

-- my (3) table is dimproduct table

create table dimproduct(

	ProductKey       text primary key,
	SKU              text,
    Department       text,
	Category         text,
	Subcategory      text,
	ProductName      text,
	Brand            text,
	BrandTier        text,
	ListPrice        numeric(15,2),
	StandardUnitCost numeric(15,2),
	WeightClass      text,
	ReturnRisk       numeric(15,2),
	ReorderLeadDays  int,
	Seasonality      text
	
);

-- my (4) table is dimcustomer table


create table dimcustomer(

	customerkey          text primary key,
	customerlabel        text,
	customersegment      text,
	loyaltytier          text,
	acquisitionchannel    text,
	firstpurchasedatekey int,
	cohortmonth          text,
	cohortyear           int,
	cohortquarter        text,
	homegeographykey     text,
	preferredcategory    text,
	ageband              text
);

-- my (5) table is dimpromotion table

create table dimpromotion(

	promotionkey        text primary key,
    promotionobjective  text,
    campaign            text,
    discounttype        text,
    defaultdiscountrate numeric(15,2),
    freeshippingflag    int,
    trafficquality      text
);

-- my (6) table is dimfullfillment table 

create table dimfulfillment(

	fulfillmentkey    text primary key,
    fulfillmentmodel  text,
    fulfillmentcenter text,
    carrier           text,
    servicelevel      text,
    basepromiseddays  int,
    costindex         numeric(15,2)
);

-- my (7) table is dimsaleschannel table

create table dimsaleschannel(

	saleschannelkey text primary key,
    channelgroup    text,
    saleschannel    text,
    devicetype      text,
    paymentfeerate  numeric(15,2)
);

-- my (8) table is dimreturnreason table

create table dimreturnreason(

   returnreasonkey       text primary key,
   returnreasongroup     text,
   returnreason          text,
   inventoryrecoveryrate numeric(15,2)
);

-- my (9) table is dimcohortage table

create table dimcohortage(

    cohortagekey             int primary key,
    monthssincefirstpurchase int,
    cohortagelabel           text,
    lifecyclestage           text
);

-- my (10) table is factorderline table

create table factorderline(

    lineid                  TEXT PRIMARY KEY,
    orderid                 TEXT,
    orderdatekey            INT,
    shipdatekey             INT,
    deliverydatekey         INT,
    returndatekey           INT,
    productkey              TEXT,
    customerkey             TEXT,
    geographykey            TEXT,
    promotionkey            TEXT,
    fulfillmentkey          TEXT,
    saleschannelkey         TEXT,
    returnreasonkey         TEXT,
    cohortagekey             INT,
    orderstatus              TEXT,
    orderedquantity          INT,
    fulfilledquantity        INT,
    returnedquantity         INT,
    openingstockunits        INT,
    stockstatus              TEXT,
    unitlistprice            NUMERIC(15,2),
    unitcost                 NUMERIC(15,2),
    applieddiscountpct       NUMERIC(15,2),
    returnrecoverypct        NUMERIC(15,2),
    grosssales               NUMERIC(15,2),
    discountamount           NUMERIC(15,2),
    salesbeforereturns       NUMERIC(15,2),
    refundamount             NUMERIC(15,2),
    netsales                 NUMERIC(15,2),
    shippingrevenue          NUMERIC(15,2),
    productcost              NUMERIC(15,2),
    outboundshippingcost     NUMERIC(15,2),
    returnshippingcost       NUMERIC(15,2),
    fulfillmentcost          NUMERIC(15,2),
    paymentfee               NUMERIC(15,2),
    allocatedmarketingcost   NUMERIC(15,2),
    returnprocessingcost     NUMERIC(15,2),
    contributionrevenue      NUMERIC(15,2),
    contributionmargin       NUMERIC(15,2),
    lostsalesvalue           NUMERIC(15,2),
    returnloss               NUMERIC(15,2),
    promiseddeliverydays     INT,
    actualdeliverydays       NUMERIC(15,2),
    ontimeflag               NUMERIC(15,2),
    ispromoted               INT,
    currency                 TEXT,
   
    FOREIGN KEY (orderdatekey)    REFERENCES dimdate(datekey),
    FOREIGN KEY (shipdatekey)     REFERENCES dimdate(datekey),
    FOREIGN KEY (deliverydatekey) REFERENCES dimdate(datekey),
    FOREIGN KEY (returndatekey)   REFERENCES dimdate(datekey),
    FOREIGN KEY (productkey)      REFERENCES dimproduct(productkey),
    FOREIGN KEY (customerkey)     REFERENCES dimcustomer(customerkey),
    FOREIGN KEY (geographykey)    REFERENCES dimgeography(geographykey),
    FOREIGN KEY (promotionkey)    REFERENCES dimpromotion(promotionkey),
    FOREIGN KEY (fulfillmentkey)  REFERENCES dimfulfillment(fulfillmentkey),
    FOREIGN KEY (saleschannelkey) REFERENCES dimsaleschannel(saleschannelkey),
    FOREIGN KEY (returnreasonkey) REFERENCES dimreturnreason(returnreasonkey),
    FOREIGN KEY (cohortagekey)    REFERENCES dimcohortage(cohortagekey)
);

/*DROP TABLE IF EXISTS 
    factorderline,
    dimgeography,
    dimdate,
    dimproduct,
    dimcustomer,
    dimpromotion,
    dimfulfillment,
    dimfullfillment,
    dimsaleschannel,
    dimreturnreason,
    dimcohortage
CASCADE;*/























