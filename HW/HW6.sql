-- HW6.sql -- Homework 6
--
-- XUJIAN SHAO
-- UT EID: xs2929, UTCS username: xs2929
-- C S 347, Spring 2017, Dr. P. Cannata
-- Department of Computer Science, The University of Texas at Austin
--
DROP TRIGGER products_before_update;
DROP TRIGGER products_before_insert;
DROP TRIGGER products_after_update;
DROP TABLE PRODUCTS_AUDIT;
DROP SEQUENCE PA_SEQ;
--14-01
SET SERVEROUTPUT ON;

BEGIN
DELETE FROM ADDRESSES
WHERE CUSTOMER_ID=8;

DELETE FROM CUSTOMERS
WHERE CUSTOMER_ID=8;

COMMIT;
DBMS_OUTPUT.PUT_LINE('COMMIT SUCCESS');
EXCEPTION
WHEN OTHERS THEN
ROLLBACK;
DBMS_OUTPUT.PUT_LINE('Transaction rolled back');
END;
/

--14-02
SET SERVEROUTPUT ON;

BEGIN
INSERT INTO orders VALUES(10, 3, sysdate(), 10.00, 0.00, NULL, 4, 'American Express', '378282246310005', '04/2013', 4);
INSERT INTO order_items VALUES(13, 10, 6, '415.00', '161.85', 1);
INSERT INTO order_items VALUES(14, 10, 1, '699.00', '209.70', 1);

COMMIT;
DBMS_OUTPUT.PUT_LINE('COMMIT SUCCESS');
EXCEPTION
WHEN OTHERS THEN
ROLLBACK;
DBMS_OUTPUT.PUT_LINE('Transaction rolled back');
END;
/
--15-01
CREATE OR REPLACE PROCEDURE insert_category
(
  category_id_param        NUMBER,   
  category_name_param   VARCHAR2
)
AS
BEGIN
  INSERT INTO CATEGORIES
  VALUES (category_id_param, category_name_param);
  COMMIT;
EXCEPTION
WHEN OTHERS THEN
DBMS_OUTPUT.PUT_LINE('Duplicate category_id or category_name!');
END;
/
BEGIN
insert_category(1, 'Pianos');
insert_category(5,'Basses');
insert_category(5,'Pianos');
END;
/
--15-02
CREATE OR REPLACE FUNCTION discount_price
(
item_id_param NUMBER
)
RETURN NUMBER
AS 
discount_price_var NUMBER;
BEGIN
SELECT ITEM_PRICE - DISCOUNT_AMOUNT AS VAL
INTO discount_price_var
FROM ORDER_ITEMS
WHERE ITEM_ID=item_id_param;

RETURN discount_price_var;
END;
/


SELECT ITEM_ID, ITEM_PRICE,DISCOUNT_AMOUNT,discount_price(1) AS DISCOUNT_PRICE 
FROM ORDER_ITEMS
WHERE ITEM_ID=1;

--15-03

CREATE OR REPLACE FUNCTION item_total
(
item_id_param NUMBER
)
RETURN NUMBER
AS 
item_total_var NUMBER;
BEGIN
SELECT QUANTITY*discount_price(item_id_param) AS VAL
INTO item_total_var
FROM ORDER_ITEMS
WHERE ITEM_ID=item_id_param;

RETURN item_total_var;
END;
/


SELECT ITEM_ID,ITEM_PRICE,DISCOUNT_AMOUNT,QUANTITY,discount_price(ITEM_ID) AS DISCOUNT_PRICE,item_total(ITEM_ID) AS ITEM_TOTAL 
FROM ORDER_ITEMS
WHERE ITEM_ID=5;


--15-04
CREATE OR REPLACE PROCEDURE insert_products
(
product_id_param PRODUCTS.product_id%TYPE,
category_id_param PRODUCTS.category_id%TYPE,
product_code_param PRODUCTS.product_code%TYPE,
product_name_param PRODUCTS.product_name%TYPE,
list_price_param PRODUCTS.list_price%TYPE,
discount_percent_param PRODUCTS.discount_percent%TYPE
)
AS 
description_var PRODUCTS.description%TYPE;
date_added_var DATE;

BEGIN 
IF list_price_param<0 OR discount_percent_param<0 THEN
RAISE VALUE_ERROR;
END IF;
SELECT sysdate INTO date_added_var FROM dual;
description_var:='  ';
INSERT INTO PRODUCTS VALUES(
product_id_param,category_id_param,product_code_param,product_name_param,
description_var,list_price_param,discount_percent_param,date_added_var
);
EXCEPTION
WHEN VALUE_ERROR THEN
DBMS_OUTPUT.PUT_LINE('Both list_price and discount_percent should not be negative');
END;
/
CALL insert_products(11,1, 'CODE1','NAME_1',-5,10);
CALL insert_products(12,1, 'CODE2','NAME_2',666.66,10);
CALL insert_products(13,1, 'CODE3','NAME_3',666.66,-10);

--15-05
CREATE OR REPLACE PROCEDURE update_product_discount
(
product_id_param PRODUCTS.product_id%TYPE,
discount_percent_param PRODUCTS.discount_percent%TYPE
)
AS
BEGIN

IF discount_percent_param<0 OR discount_percent_param>100 THEN
RAISE VALUE_ERROR;
END IF;

UPDATE PRODUCTS
SET PRODUCTS.DISCOUNT_PERCENT=discount_percent_param
WHERE PRODUCTS.PRODUCT_ID=product_id_param;
COMMIT;
EXCEPTION
WHEN VALUE_ERROR THEN
DBMS_OUTPUT.PUT_LINE('discount_percent value must be in [0,100]');
END;
/
CALL update_product_discount(1,-10);
CALL update_product_discount(1,120);
CALL update_product_discount(1,31);

--16-01
CREATE OR REPLACE TRIGGER products_before_update
BEFORE UPDATE OF DISCOUNT_PERCENT ON PRODUCTS
FOR EACH ROW
BEGIN 
IF (:new.DISCOUNT_PERCENT NOT BETWEEN 1 AND 100) THEN
RAISE_APPLICATION_ERROR (-20001,'Discount_Percent must be in [1,100]');
END IF;
IF :new.DISCOUNT_PERCENT<1 THEN
:new.DISCOUNT_PERCENT := 100*(:new.DISCOUNT_PERCENT);
END IF;

END;
/

UPDATE PRODUCTS
SET DISCOUNT_PERCENT = -10
WHERE PRODUCT_ID=1;

UPDATE PRODUCTS
SET DISCOUNT_PERCENT = 0.1
WHERE PRODUCT_ID=1;

UPDATE PRODUCTS
SET DISCOUNT_PERCENT = 10
WHERE PRODUCT_ID=1;


--16-02

CREATE OR REPLACE TRIGGER products_before_insert
BEFORE INSERT ON PRODUCTS
FOR EACH ROW 
BEGIN 
IF :new.DATE_ADDED IS NULL THEN
:new.DATE_ADDED := SYSDATE;
END IF;
END;
/
INSERT INTO PRODUCTS
VALUES(13,1,'CODE 16-02','16-02',' ',100,20,NULL);

--16-03
CREATE  TABLE PRODUCTS_AUDIT(
  AUDIT_ID         NUMBER         NOT NULL,
  PRODUCT_ID        NUMBER        NOT NULL, 
  CATEGORY_ID        NUMBER         NOT NULL , 
  PRODUCT_CODE       VARCHAR2(10)    NOT NULL,
  PRODUCT_NAME      VARCHAR2(255)   NOT NULL,
  LIST_PRICE         NUMBER(10,2)     NOT NULL,
  DISCOUNT_PERCENT   NUMBER(10,2)      DEFAULT 0.00,
   DATE_UPDATED        DATE             DEFAULT NULL,
   CONSTRAINT pk1 PRIMARY KEY ( AUDIT_ID )
);
CREATE SEQUENCE PA_SEQ START WITH 1;

CREATE OR REPLACE TRIGGER products_after_update
AFTER DELETE OR INSERT OR UPDATE 
ON Products 
FOR EACH ROW
BEGIN
    INSERT INTO  PRODUCTS_AUDIT  
    VALUES(PA_SEQ.NEXTVAL,:old.PRODUCT_ID,:old.CATEGORY_ID,:old.PRODUCT_CODE,:old.PRODUCT_NAME,
    :old.LIST_PRICE,:old.DISCOUNT_PERCENT,:old.DATE_ADDED);
END;
/
UPDATE PRODUCTS
SET DATE_ADDED = SYSDATE
WHERE PRODUCT_ID=2;



