--1
--SELECT PRODUCT_CODE "product_code",PRODUCT_NAME "product_name",LIST_PRICE "list_price",DISCOUNT_PERCENT "discount_percent"
--FROM PRODUCTS
--ORDER BY LIST_PRICE DESC

--2
--SELECT LAST_NAME||', '||FIRST_NAME AS "fullname" 
--FROM CUSTOMERS
--WHERE SUBSTR(LAST_NAME,1,1) BETWEEN 'M' AND 'Z'
--ORDER BY LAST_NAME

--3
--SELECT PRODUCT_NAME "product_name",LIST_PRICE "list_price",DATE_ADDED "date_added" 
--FROM PRODUCTS
--WHERE LIST_PRICE>500 AND LIST_PRICE<2000
--ORDER BY DATE_ADDED DESC

--4
--SELECT PRODUCT_NAME "product_name",LIST_PRICE "list price",DISCOUNT_PERCENT "DISCOUNT_PERCENT",DISCOUNT_PERCENT*LIST_PRICE/100 AS "discount_amount",LIST_PRICE-DISCOUNT_PERCENT*LIST_PRICE/100 AS "discount price"
--FROM PRODUCTS
--WHERE ROWNUM<=5
--ORDER BY 5 DESC

--5
--SELECT item_id,item_price,discount_amount,quantity,price_total,discount_total,item_total
--FROM
--(
--SELECT ITEM_ID AS item_iD,ITEM_PRICE AS item_price,DISCOUNT_AMOUNT AS discount_amount,QUANTITY AS quantity,ITEM_PRICE*QUANTITY AS price_total,DISCOUNT_AMOUNT*QUANTITY AS discount_total,QUANTITY*(ITEM_PRICE-DISCOUNT_AMOUNT) AS item_total
--FROM ORDER_ITEMS)d
--WHERE d.item_total>500
--ORDER BY d.item_total DESC

--6
--SELECT ORDER_ID "order_id",ORDER_DATE "order_date",SHIP_DATE "ship_date" FROM ORDERS
--WHERE SHIP_DATE IS NULL

--7
--SELECT SYSDATE "today_unformatted",TO_CHAR(SYSDATE,'MM/DD/YYYY') "today_formatted"
--FROM Dual

--8 
--SELECT price,tax_rate,tax_amount,price+tax_amount AS total FROM 
--(SELECT price,tax_rate,price*tax_rate AS tax_amount FROM
--(
--SELECT 100 AS price,0.07 AS tax_rate FROM Dual
--)a
--)b
