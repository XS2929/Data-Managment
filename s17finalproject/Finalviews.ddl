drop view CTR_ACC_view ;
drop view CTR_AD_view ;

create view CTR_ACC_view as
SELECT 
    STAFF_ID,
    STAFF_name,
    REQUESTS_MADE,
    Type
    FROM S17_25_CTR_S where type = 'Accountant' ;

create or replace TRIGGER S17_25_CTR_Acc_trigger
     INSTEAD OF insert ON CTR_ACC_view
     FOR EACH ROW
BEGIN
    insert into S17_25_CTR_S(
        STAFF_NAME,
        Type)
    VALUES ( 
        :NEW.STAFF_NAME,
        'Accountant') ;
END;
/

create view CTR_AD_view as
SELECT 
        STAFF_ID,
        STAFF_name,
        REQUESTS_CHECKED,
        Type
        FROM S17_25_CTR_S where type = 'Admin' ;

create or replace TRIGGER CTR_ACC_trigger
     INSTEAD OF insert ON CTR_AD_view
     FOR EACH ROW
BEGIN
    insert into S17_25_CTR_S(
        STAFF_NAME,
        Type)
    VALUES ( 
        :NEW.STAFF_NAME,
        'Admin') ;
END;
/
