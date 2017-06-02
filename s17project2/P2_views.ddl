drop view TEACHING_ASSISTANT_view ;
drop view PROFESSOR_view ;

create view PROFESSOR_view as
SELECT 
    Instructor_ID,
    First_name,
    Last_name,
    Department,
    Salary,
    Type
    FROM INSTRUCTOR where type = 'PROFESSOR' ;

create or replace TRIGGER PROFESSOR_trigger
     INSTEAD OF insert ON PROFESSOR_view
     FOR EACH ROW
BEGIN
    insert into INSTRUCTOR(
        First_name,
        Last_name,
        Department,
        Salary,
        Type)
    VALUES ( 
        :NEW.First_name,
        :NEW.Last_name,
        :NEW.Department,
        :NEW.Salary,
        'PROFESSOR') ;
END;
/

create view TEACHING_ASSISTANT_view as
SELECT 
        Instructor_ID,
        First_name,
        Last_name,
        Department,
        Major,
        Type
FROM INSTRUCTOR where type = 'TEACHING_ASSISTANT' ;

create or replace TRIGGER TEACHING_ASSISTANT_trigger
     INSTEAD OF insert ON TEACHING_ASSISTANT_view
     FOR EACH ROW
BEGIN
    insert into INSTRUCTOR(
        First_name,
        Last_name,
        Department,
        Major,
        Type)
    VALUES ( 
        :NEW.First_name,
        :NEW.Last_name,
        :NEW.Department,
        :NEW.Major,
        'TEACHING_ASSISTANT') ;
END;
/

