-- HW3.sql -- Homework 3
--
-- XUJIAN SHAO
-- UT EID: xs2929, UTCS username: xs2929
-- C S 347, Spring 2017, Dr. P. Cannata
-- Department of Computer Science, The University of Texas at Austin
--
--5-01
SELECT COUNT(*) AS ORDER_AMT, SUM(TAX_AMOUNT) AS TOTAL_TAX_AMOUNT
FROM ORDERS

--5-02
SELECT CATEGORY_NAME,COUNT(*) AS PRODUCT_COUNT, MAX(LIST_PRICE) AS MOST_EXPENSIVE_PRODUCT_PRICE
FROM (SELECT* FROM CATEGORIES JOIN PRODUCTS
ON CATEGORIES.CATEGORY_ID=PRODUCTS.CATEGORY_ID)
GROUP BY CATEGORY_NAME
ORDER BY COUNT(*) DESC

--5-03
SELECT EMAIL_ADDRESS,SUM(ITEM_PRICE*QUANTITY) AS ITEM_PRICE_TOTAL, SUM(DISCOUNT_AMOUNT*QUANTITY) AS DISCOUNT_AMOUNT_TOTAL 
FROM CUSTOMERS JOIN ORDERS ON CUSTOMERS.CUSTOMER_ID=ORDERS.CUSTOMER_ID JOIN ORDER_ITEMS
ON ORDERS.ORDER_ID=ORDER_ITEMS.ORDER_ID
GROUP BY EMAIL_ADDRESS
ORDER BY SUM(ITEM_PRICE*QUANTITY) DESC

--5-04
SELECT EMAIL_ADDRESS, COUNT(*) AS NUMBER_OF_ORDERS, SUM((ITEM_PRICE-DISCOUNT_AMOUNT)*QUANTITY) AS TOTAL_AMOUNT
FROM CUSTOMERS JOIN ORDERS ON CUSTOMERS.CUSTOMER_ID=ORDERS.CUSTOMER_ID JOIN ORDER_ITEMS ON ORDER_ITEMS.ORDER_ID=ORDERS.ORDER_ID
GROUP BY EMAIL_ADDRESS
HAVING COUNT(*)>1
ORDER BY TOTAL_AMOUNT DESC

--5-05
SELECT EMAIL_ADDRESS, COUNT(*) AS NUMBER_OF_ORDERS, SUM((ITEM_PRICE-DISCOUNT_AMOUNT)*QUANTITY) AS TOTAL_AMOUNT
FROM CUSTOMERS JOIN ORDERS ON CUSTOMERS.CUSTOMER_ID=ORDERS.CUSTOMER_ID JOIN ORDER_ITEMS ON ORDER_ITEMS.ORDER_ID=ORDERS.ORDER_ID
WHERE ITEM_PRICE>400
GROUP BY EMAIL_ADDRESS
HAVING COUNT(*)>1
ORDER BY TOTAL_AMOUNT DESC

--5-06
SELECT PRODUCT_NAME, SUM(ITEM_PRICE-DISCOUNT_AMOUNT) AS TOTAL_AMOUNT
FROM PRODUCTS JOIN ORDER_ITEMS 
ON PRODUCTS.PRODUCT_ID=ORDER_ITEMS.PRODUCT_ID
GROUP BY ROLLUP(PRODUCT_NAME)

--5-07
SELECT EMAIL_ADDRESS, COUNT(DISTINCT PRODUCT_ID) AS DISTINCT_PRODUCT_COUNT FROM 
CUSTOMERS JOIN ORDERS ON CUSTOMERS.CUSTOMER_ID=ORDERS.CUSTOMER_ID
JOIN ORDER_ITEMS ON ORDERS.ORDER_ID=ORDER_ITEMS.ORDER_ID
GROUP BY EMAIL_ADDRESS

--6-01
SELECT DISTINCT CATEGORY_NAME FROM CATEGORIES
WHERE CATEGORY_ID IN
(SELECT CATEGORY_ID FROM PRODUCTS)
ORDER BY CATEGORY_NAME

--6-02
SELECT PRODUCT_NAME,LIST_PRICE FROM PRODUCTS
WHERE LIST_PRICE>(SELECT AVG(LIST_PRICE) FROM PRODUCTS)
ORDER BY LIST_PRICE DESC

--6-03
SELECT CATEGORY_NAME FROM CATEGORIES C
WHERE NOT EXISTS 
(SELECT * FROM PRODUCTS  WHERE PRODUCTS.CATEGORY_ID=C.CATEGORY_ID) 

--6-04
SELECT EMAIL_ADDRESS, MAX(ORDER_TOTAL)
FROM
(SELECT EMAIL_ADDRESS, ORDERS.ORDER_ID, SUM((ITEM_PRICE-DISCOUNT_AMOUNT)*QUANTITY) AS ORDER_TOTAL
FROM CUSTOMERS JOIN ORDERS ON CUSTOMERS.CUSTOMER_ID=ORDERS.CUSTOMER_ID JOIN ORDER_ITEMS ON ORDERS.ORDER_ID=ORDER_ITEMS.ORDER_ID
GROUP BY EMAIL_ADDRESS,ORDERS.ORDER_ID)
GROUP BY EMAIL_ADDRESS

--6-05
SELECT P1.PRODUCT_NAME,P1.DISCOUNT_PERCENT
FROM PRODUCTS P1
WHERE P1.DISCOUNT_PERCENT NOT IN (SELECT P2.DISCOUNT_PERCENT FROM PRODUCTS P2 WHERE P1.PRODUCT_NAME<>P2.PRODUCT_NAME) 
ORDER BY PRODUCT_NAME

--6-06
SELECT EMAIL_ADDRESS, ORDER_ID, ORDER_DATE 
FROM CUSTOMERS F1 JOIN ORDERS ON F1.CUSTOMER_ID=ORDERS.CUSTOMER_ID
WHERE ORDER_DATE=(SELECT MIN(ORDER_DATE) FROM ORDERS F2 WHERE F1.CUSTOMER_ID=F2.CUSTOMER_ID)












