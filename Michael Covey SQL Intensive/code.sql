SELECT *
FROM survey
LIMIT 10;

/*********************************************/

SELECT question AS 'Question', 
COUNT(user_id) AS 'Responses'
FROM survey
GROUP BY 1;

/*********************************************/

SELECT *
FROM quiz
LIMIT 5;

SELECT *
FROM home_try_on
LIMIT 5;

SELECT *
FROM purchase
LIMIT 5;

/*********************************************/

--Creates funnel
SELECT 
 DISTINCT q.user_id,
 h.user_id IS NOT NULL AS 'is_home_try_on',
 h.number_of_pairs AS 'number_of_pairs',
 p.user_id IS NOT NULL AS 'is_purchase'
FROM quiz AS 'q'
LEFT JOIN home_try_on AS 'h'
  ON h.user_id = q.user_id
LEFT JOIN purchase AS 'p'
  ON p.user_id = h.user_id
LIMIT 10;

/*********************************************/

--Counts total shoppers, home try-ons, and purchasers
WITH funnel AS(
SELECT 
 DISTINCT q.user_id,
 h.user_id IS NOT NULL AS 'is_home_try_on',
 h.number_of_pairs AS 'number_of_pairs',
 p.user_id IS NOT NULL AS 'is_purchase'
FROM quiz AS 'q'
LEFT JOIN home_try_on AS 'h'
  ON h.user_id = q.user_id
LEFT JOIN purchase AS 'p'
  ON p.user_id = h.user_id)
SELECT COUNT(*) AS 'All users',
SUM(is_home_try_on) AS 'Home Try-Ons',
SUM(is_purchase) AS 'Purchasers'
FROM funnel;


/*********************************************/


--Counts purchasers who got either 3 or 5 home try-on pairs
WITH funnel AS(
SELECT 
 DISTINCT q.user_id,
 h.user_id IS NOT NULL AS 'is_home_try_on',
 h.number_of_pairs AS 'number_of_pairs',
 p.user_id IS NOT NULL AS 'is_purchase'
FROM quiz AS 'q'
LEFT JOIN home_try_on AS 'h'
  ON h.user_id = q.user_id
LEFT JOIN purchase AS 'p'
  ON p.user_id = h.user_id)
SELECT number_of_pairs, SUM(is_purchase) AS 'Count'
FROM funnel
GROUP BY number_of_pairs
HAVING number_of_pairs IS NOT NULL;

/*********************************************/

--Count total number of home try-ons (regardless of purchase)
SELECT number_of_pairs, COUNT(*) AS 'Count'
FROM home_try_on
GROUP BY 1;

/*********************************************/

--Counts purchasers who got either 3 or 5 home try-on pairs
WITH funnel AS(
SELECT 
 DISTINCT q.user_id, p.price,
 h.user_id IS NOT NULL AS 'is_home_try_on',
 h.number_of_pairs AS 'number_of_pairs',
 p.user_id IS NOT NULL AS 'is_purchase'
FROM quiz AS 'q'
LEFT JOIN home_try_on AS 'h'
  ON h.user_id = q.user_id
LEFT JOIN purchase AS 'p'
  ON p.user_id = h.user_id)
SELECT number_of_pairs, AVG(price)
FROM funnel
GROUP BY number_of_pairs
HAVING number_of_pairs IS NOT NULL;

/*********************************************/

--Purchasers based on gender of quiz-takers
WITH funnel AS(
SELECT 
 DISTINCT q.style AS 'gender', q.user_id,
 h.user_id IS NOT NULL AS 'is_home_try_on',
 h.number_of_pairs AS 'number_of_pairs',
 p.user_id IS NOT NULL AS 'is_purchase'
FROM quiz AS 'q'
LEFT JOIN home_try_on AS 'h'
  ON h.user_id = q.user_id
LEFT JOIN purchase AS 'p'
  ON p.user_id = h.user_id)
SELECT gender, SUM(is_purchase)
FROM funnel
GROUP BY gender;

/*********************************************/

--Quiz-takers broken out by gender
SELECT style, COUNT(*)
FROM quiz
GROUP BY 1;

/*********************************************/

--Gender X Fit crosstab
SELECT style, fit, COUNT(fit)
FROM quiz
WHERE NOT style LIKE '%skip%'
GROUP BY 1, 2;

/*********************************************/

--Gender X Shape crosstab
SELECT style, shape, COUNT(shape)
FROM quiz
WHERE NOT style LIKE '%skip%'
GROUP BY 1, 2;

/*********************************************/

--Gender X Color crosstab
SELECT style, color, COUNT(*)
FROM quiz
WHERE NOT style LIKE '%skip%'
GROUP BY 1, 2;

/*********************************************/

--Purchasers based on fit selection of quiz-takers
WITH funnel AS(
SELECT 
 DISTINCT q.fit AS 'Fit', q.user_id,
 h.user_id IS NOT NULL AS 'is_home_try_on',
 h.number_of_pairs AS 'number_of_pairs',
 p.user_id IS NOT NULL AS 'is_purchase'
FROM quiz AS 'q'
LEFT JOIN home_try_on AS 'h'
  ON h.user_id = q.user_id
LEFT JOIN purchase AS 'p'
  ON p.user_id = h.user_id)
SELECT Fit, SUM(is_purchase)
FROM funnel
GROUP BY Fit;
--All fit selections regardless of purchase
SELECT fit, COUNT(*)
FROM quiz
GROUP BY 1;

/*********************************************/

--Purchasers based on shape selection of quiz-takers
WITH funnel AS(
SELECT 
 DISTINCT q.shape AS 'Shape', q.user_id,
 h.user_id IS NOT NULL AS 'is_home_try_on',
 h.number_of_pairs AS 'number_of_pairs',
 p.user_id IS NOT NULL AS 'is_purchase'
FROM quiz AS 'q'
LEFT JOIN home_try_on AS 'h'
  ON h.user_id = q.user_id
LEFT JOIN purchase AS 'p'
  ON p.user_id = h.user_id)
SELECT Shape, SUM(is_purchase)
FROM funnel
GROUP BY Shape;
--All shape selections regardless of purchase
SELECT shape, COUNT(*)
FROM quiz
GROUP BY 1;

/*********************************************/

--Purchasers based on color selection of quiz-takers
WITH funnel AS(
SELECT 
 DISTINCT q.color AS 'Color', q.user_id,
 h.user_id IS NOT NULL AS 'is_home_try_on',
 h.number_of_pairs AS 'number_of_pairs',
 p.user_id IS NOT NULL AS 'is_purchase'
FROM quiz AS 'q'
LEFT JOIN home_try_on AS 'h'
  ON h.user_id = q.user_id
LEFT JOIN purchase AS 'p'
  ON p.user_id = h.user_id)
SELECT Color, SUM(is_purchase)
FROM funnel
GROUP BY Color;
--All color selections regardless of purchase
SELECT color, COUNT(*)
FROM quiz
GROUP BY 1;

/*********************************************/

