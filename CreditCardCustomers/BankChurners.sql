-- Compare Credit Limit of customer who churns vs Limit of population
SELECT ( SELECT AVG(Credit_Limit) 
FROM bank_churners.bankchurners
WHERE Attrition_Flag = 'Attrited Customer') AS mean_credit_churn,
AVG(Credit_Limit) AS mean_credit_pop
FROM bank_churners.bankchurners;

-- Calculate the proportion of card category of churn customers
SELECT COUNT(*)/SUM(COUNT(*)) OVER(), Card_Category
FROM bank_churners.bankchurners
WHERE Attrition_Flag = 'Attrited Customer'
GROUP BY Card_Category;

-- Counting the income category of churn customers and calculate the proportion of each category
USE bank_churners;
CREATE VIEW churn_income AS
SELECT Income_Category, 
		COUNT(*) AS churn_income_count,
        100*COUNT(*) / SUM(COUNT(*)) OVER() AS churn_income_prop
FROM bank_churners.bankchurners
WHERE Attrition_Flag = 'Attrited Customer'
GROUP BY Income_Category;

-- Counting the income category of population customers and calculate the proportion of each category
USE bank_churners;
CREATE VIEW pop_income AS
SELECT Income_Category,
		COUNT(*) AS total_income_count,
        100*COUNT(*) / SUM(COUNT(*)) OVER() AS total_income_prop
FROM bank_churners.bankchurners
GROUP BY Income_Category;

-- Joining 2 views of income to compare population and churn customers
SELECT *
FROM bank_churners.pop_income 
INNER JOIN bank_churners.churn_income 
USING (Income_Category)
ORDER BY churn_income_prop DESC;


-- CREATING VIEWS FOR MEAN OF CREDIT LIMIT OF EACH INCOME CATEGORY OF CHURN AND POPULATION
USE bank_churners;
CREATE VIEW churn_credit_income AS
SELECT income_category, AVG(credit_limit) AS mean_credit_limit_churn
FROM bank_churners.bankchurners
WHERE Attrition_Flag = 'Attrited Customer'
GROUP BY Income_Category;

USE bank_churners;
CREATE VIEW pop_credit_income AS
SELECT income_category,AVG(credit_limit) AS mean_credit_limit_pop
FROM bank_churners.bankchurners
GROUP BY Income_Category
ORDER BY mean_credit_limit_pop;

-- Merge the above 2 view to compare the mean of credit_income of 2 groups 
SELECT *
FROM bank_churners.pop_credit_income 
INNER JOIN bank_churners.churn_credit_income
USING (income_category);

-- CREATING VIEWS THAT SHOWS THE CHURN CUSTOMERS WHO HAS CREDIT LIMIT LOWER THAN 75% OF MEAN OF THEIR INCOME GROUP (UNDERPERFORM)
USE bank_churners;
CREATE VIEW underperform_credit_churn AS
SELECT *
FROM (SELECT CLIENTNUM,Income_Category, Credit_Limit, Total_Revolving_Bal
FROM bank_churners.bankchurners
WHERE Attrition_Flag = 'Attrited Customer') AS I1
RIGHT JOIN 
(SELECT AVG(credit_limit)* 0.75 AS lower_bound, Income_Category
FROM bank_churners.bankchurners
GROUP BY Income_Category) AS I2
USING(income_category)
HAVING lower_bound > credit_limit;
-- Count all customers in churn group that have underperform credit limit
SELECT COUNT(*) as underperform_num
FROM bank_churners.underperform_credit_churn;
-- Count the underperform 'CREDIT LIMIT' customer of each 'INCOME CATEGORY' and calculate proportion within the churn group
SELECT Income_category,COUNT(*) as underperform_num,
		100*COUNT(*)/SUM(COUNT(*)) OVER() as underperform_prop
FROM bank_churners.underperform_credit_churn
GROUP BY income_category
ORDER BY underperform_num DESC; 

-- CREATING VIEWS THAT SHOWS THE POPULATION CUSTOMERS WHO HAS CREDIT LIMIT LOWER THAN 75% OF MEAN OF THEIR INCOME GROUP (UNDERPERFORM)
USE bank_churners;
CREATE VIEW underperform_credit_pop AS
SELECT *
FROM (SELECT CLIENTNUM,Income_Category, Credit_Limit, Total_Revolving_Bal
FROM bank_churners.bankchurners) AS I1
RIGHT JOIN 
(SELECT AVG(credit_limit)* 0.75 AS lower_bound, Income_Category
FROM bank_churners.bankchurners
GROUP BY Income_Category) AS I2
USING(income_category)
HAVING lower_bound > credit_limit;
-- Count all customers in population that have underperform credit limit
SELECT COUNT(*) as underperform_num
FROM bank_churners.underperform_credit_pop;
-- Count the underperform credit limit customer and calculate proportion of population customers
SELECT Income_category,COUNT(*) as underperform_num,
		 100*COUNT(*)/SUM(COUNT(*)) OVER() as underperform_prop
FROM bank_churners.underperform_credit_pop
GROUP BY income_category
ORDER BY underperform_num DESC; 
-- Calculate the percentage of churn customer has underperform credit limit vs all customer has underperform credit limit
SELECT(SELECT COUNT(*) as underperform_num
FROM bank_churners.underperform_credit_churn)/
(SELECT COUNT(*) as underperform_num
FROM bank_churners.underperform_credit_pop) AS credit_underperform_churn_percentage;

-- EXPLORE DATA IN TOTAL REVOLVING BALANCE COLUMN
-- counting and calculating proportion of zero revolving customer in churn group
SELECT COUNT(*) AS zero_revolving_churn_num,
	100*COUNT(*)/(SELECT COUNT(*)
					FROM bank_churners.bankchurners
                    WHERE Attrition_Flag = 'Attrited Customer') AS zero_revolving_churn_prop
FROM bank_churners.bankchurners
WHERE Total_Revolving_Bal = 0
AND Attrition_Flag = 'Attrited Customer';
-- counting and calculating zero proportion of zero revolving customer in population
SELECT COUNT(*) AS zero_revolving_pop_num,
	100*COUNT(*)/(SELECT COUNT(*)
					FROM bank_churners.bankchurners) AS zero_revolving_pop_prop
FROM bank_churners.bankchurners
WHERE Total_Revolving_Bal = 0;
-- Calculate the churn percentage of zero revolving customer
SELECT (SELECT COUNT(*) 
FROM bank_churners.bankchurners
WHERE Total_Revolving_Bal = 0
AND Attrition_Flag = 'Attrited Customer') / 
(SELECT COUNT(*)
FROM bank_churners.bankchurners
WHERE Total_Revolving_Bal = 0) AS churn_per_zero_revol;

-- CONSIDER IF THE CHURN CUSTOMER THAT HAVE UNDERPERFORM CREDIT LIMIT OVERLAP WITH CHURN CUSTOMER HAS ZERO REVOLVING

SELECT COUNT(*)
FROM (SELECT  CLIENTNUM, Total_Revolving_Bal, Credit_Limit, Income_Category
FROM bank_churners.bankchurners
WHERE Total_Revolving_Bal = 0
AND Attrition_Flag = 'Attrited Customer') AS J1
JOIN
(SELECT CLIENTNUM
FROM bank_churners.underperform_credit_churn) AS J2
USING (CLIENTNUM);

-- EXPLORING DATA IN MONTH ON BOOK
-- calculating mean month on book of churners vs existing
SELECT (SELECT AVG(Months_on_book)
FROM bank_churners.bankchurners
WHERE Attrition_Flag = 'Attrited Customer') AS mean_months_on_book_churn,
(SELECT AVG(Months_on_book)
FROM bank_churners.bankchurners
WHERE Attrition_Flag = 'Existing Customer') AS mean_month_on_book_exist;

--  EXPLORING DATA IN MONTH INACTIVE 12
-- calculating and compare mean month inactive of churners vs population
SELECT (SELECT AVG(Months_Inactive_12_mon)
FROM bank_churners.bankchurners
WHERE Attrition_Flag = 'Attrited Customer') AS mean_months_inactive_churn,
(SELECT AVG(Months_Inactive_12_mon)
FROM bank_churners.bankchurners
WHERE Attrition_Flag = 'Existing Customer') AS mean_month_inactive_exist;

-- EXPLORING DATA IN TOTAL TRANSACTION COUNT AND TOTAL TRANSACTION AMOUNT
-- calculate mean of number of transactions of churn and exist group and population mean
SELECT AVG(Total_trans_ct)
FROM bank_churners.bankchurners
WHERE Attrition_Flag LIKE '%Attri%'; -- result: 44.93 
-- -> number of transaction by churn group is 35% lower than existing group, and 30% lower than population
SELECT AVG(Total_trans_ct)
FROM bank_churners.bankchurners
WHERE Attrition_Flag LIKE '%Exist%'; -- result 68.67
SELECT AVG(Total_trans_ct)
FROM bank_churners.bankchurners;-- result 64.85
-- finding how many percents existing group have total number of transactions lower than 44.93
SELECT(SELECT COUNT(*)
FROM bank_churners.bankchurners
WHERE total_trans_ct < 44.93
AND Attrition_Flag LIKE '%Exist%') / 
(SELECT COUNT(*)
FROM bank_churners.bankchurners
WHERE Attrition_Flag LIKE '%Exist%') AS percent_existing_less_trans_ct_than_churn; -- result: 18.53%
-- -> these 18.53% may have higher chances of becoming churning customers
-- calculate mean of amount of money transacted by 2 groups and population
SELECT AVG(Total_trans_amt)
FROM bank_churners.bankchurners
WHERE Attrition_Flag LIKE '%Attri%'; -- result: 3095$
SELECT AVG(Total_trans_ct)
FROM bank_churners.bankchurners
WHERE Attrition_Flag LIKE '%Exist%'; -- result: 4654$
SELECT AVG(Total_trans_ct)
FROM bank_churners.bankchurners; -- result: 4400$
-- finding how many percents existing group have total amount of transacted money lower than 3095$
SELECT(SELECT COUNT(*)
FROM bank_churners.bankchurners
WHERE total_trans_amt < 3095
AND Attrition_Flag LIKE '%Exist%') / 
(SELECT COUNT(*)
FROM bank_churners.bankchurners
WHERE Attrition_Flag LIKE '%Exist%') AS percent_existing_less_trans_amt_than_churn; -- result: 31.47%
-- -> these 31.47% of existing customer might have higher chances of churning
