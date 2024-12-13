# Set Up Your Database

CREATE database STARTUP;
USE STARTUP;
SELECT 
    *
FROM
    FUNDING;

SELECT 
    year, SUM(INR_amount) AS total_fund
FROM
    funding
GROUP BY year
ORDER BY total_fund DESC;

-- Count of startups funded by city:
SELECT 
    citylocation, COUNT(startupname) AS no_of_startups
FROM
    funding
GROUP BY citylocation
ORDER BY no_of_startups DESC;

SELECT 
    industryvertical, SUM(INR_Amount)
FROM
    funding
GROUP BY industryvertical
LIMIT 5;

-- Monthly funding trend:
SELECT 
    year, MONTH, SUM(INR_Amount) AS fund_raised
FROM
    funding
GROUP BY year , month
ORDER BY year , month , fund_raised;

SELECT 
    investorsname AS investors, COUNT(*) AS no_of_investments
FROM
    funding
GROUP BY investorsname
ORDER BY no_of_investments DESC;

-- total investments by investors
SELECT 
    investorsname AS investors,
    SUM(inr_amount) AS invested_amount
FROM
    funding
GROUP BY investorsname
ORDER BY invested_amount DESC;

-- investers who invested in less no of startups but more amount

SELECT 
    investorsname AS investors,
    COUNT(*) AS no_of_investments,
    SUM(inr_amount) AS invested_amount
FROM
    funding
GROUP BY investors
ORDER BY no_of_investments ASC , invested_amount DESC;

-- Investment type percentage distribution:
SELECT 
    InvestmentType,
    SUM(inr_amount) toatl_amount,
    (SUM(inr_amount) / (SELECT 
            SUM(inr_amount)
        FROM
            funding) * 100) AS percentage_of_total
FROM
    funding
GROUP BY InvestmentType;

-- Identify startups receiving undisclosed funding:

SELECT 
    Startupname, InvestorsName, IndustryVertical, Amount_in_Usd
FROM
    funding
WHERE
    Amount_in_Usd = 'Undiscloused';

-- Funding by quarter and category:

SELECT 
    year, quarter, SUM(inr_amount), funding_category
FROM
    funding
GROUP BY year , quarter , funding_category
ORDER BY year , quarter;

-- Top Cities by Total Funding
SELECT 
    citylocation, SUM(INR_amount) AS investment
FROM
    funding
GROUP BY citylocation
ORDER BY investment DESC;

-- Yearly Growth Rate of Funding
select year,sum(inr_amount),
(sum(inr_amount)-lag(sum(INR_AMOUNT)) OVER (ORDER BY YEAR))/lag(sum(INR_AMOUNT))OVER (order by YEAR)*100 AS YOY_Growth
FROM FUNDING
GROUP BY YEAR;

-- Average Funding by Investment Type
SELECT 
    InvestmentType, AVG(INR_Amount) AS AVG_INVESTMENT
FROM
    funding
GROUP BY InvestmentType
ORDER BY AVG_INVESTMENT DESC;

-- Rank Industries by Total Funding
SELECT INDUSTRYVERTICAL AS INDUSTRY,sum(INR_AMOUNT),
RANK() OVER (ORDER  BY SUM(INR_AMOUNT) DESC) AS RANK_
FROM FUNDING
group by INDUSTRYVERTIcal;

-- Cumulative Funding Over Time
SELECT 
    month,
    CASE
        WHEN month = 'Jan' THEN 1
        WHEN month = 'Feb' THEN 2
        WHEN month = 'Mar' THEN 3
        WHEN month = 'Apr' THEN 4
        WHEN month = 'May' THEN 5
        WHEN month = 'Jun' THEN 6
        WHEN month = 'July' THEN 7
        WHEN month = 'Aug' THEN 8
        WHEN month = 'Sep' THEN 9
        WHEN month = 'Oct' THEN 10
        WHEN month = 'Nov' THEN 11
        WHEN month = 'Dec' THEN 12
        ELSE NULL
    END AS month_number
FROM
    funding;

select year,month,sum(inr_amount), 
sum(sum(inr_amount) ) over (order by year,month) as cumulative_funding
from funding
group by year,month
order by year,month;

-- Investors Investing in Multiple Cities
SELECT 
    investorsname, COUNT(DISTINCT (citylocation))
FROM
    funding
GROUP BY investorsname
HAVING COUNT(DISTINCT (citylocation)) > 1
ORDER BY COUNT(DISTINCT (citylocation)) DESC;

-- Cross-tab Query for Industry and City
SELECT 
    citylocation,
    SUM(CASE
        WHEN industryvertical = 'technology' THEN inr_amount
        ELSE 0
    END) AS technology_funding,
    SUM(CASE
        WHEN industryvertical = 'ecommerce' THEN inr_amount
        ELSE 0
    END) AS ecommerce_funding
FROM
    funding
GROUP BY citylocation;

-- Top Funded Startups in Each Industry
SELECT 
    startupname, industryvertical, inr_amount
FROM
    funding AS fd
WHERE
    inr_amount = (SELECT 
            MAX(inr_amount)
        FROM
            funding
        WHERE
            IndustryVertical = fd.IndustryVertical)
ORDER BY IndustryVertical;

-- Investors Funding More than Average

SELECT 
    investorsname, SUM(inr_amount),(select avg(inr_amount) from funding)
FROM
    funding	
WHERE
    inr_amount > (SELECT 
            AVG(inr_amount)
        FROM
            funding)
GROUP BY investorsname;

-- Funding Seasonality
select month,
avg(sum(inr_amount)) over (partition by MONTH) AS MONTHLY_FUNDING
FROM FUNDING
group by MONTH
ORDER BY MONTHLY_FUNDING DESC ;
 
-- Funding by Quarter and Category

SELECT 
    QUARTER, FUNDING_CATEGORY AS CATEGORY, SUM(INR_AMOUNT)
FROM
    FUNDING
GROUP BY QUARTER , CATEGORY
ORDER BY QUARTER DESC;

-- Percentage Contribution of Top Investor CTE
WITH INVESTORSTOTAL AS(
SELECT 
      INVESTORSNAME,SUM(INR_AMOUNT) AS _INVESTMENT
FROM FUNDING
GROUP BY INVESTORSNAME),
 total_investment as(
select sum(inr_amount)as total_amount
from funding)
SELECT 
     it.INVESTORSNAME,it._investment,
     (it._investment/ti.total_amount)*100 as percentage_contribution
from investorstotal it,
total_investment ti 
order by percentage_contribution desc;

-- Industries Receiving Consistent Funding over all years

SELECT 
    industryvertical, COUNT(DISTINCT year)
FROM
    funding
GROUP BY industryvertical
order by  COUNT(DISTINCT year) desc;

-- Most Active Investors
   
SELECT 
    investorsname, COUNT(investorsname) AS active_time,sum(inr_amount) inventment_toatl
FROM
    funding
GROUP BY investorsname
ORDER BY active_time DESC;
   


    





