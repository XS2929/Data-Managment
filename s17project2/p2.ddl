-- Generated by Oracle SQL Developer Data Modeler 4.2.0.921
--   at:        2017-02-16 21:38:12 CST
--   site:      Oracle Database 11g
--   type:      Oracle Database 11g

DROP SEQUENCE course_unique_number_seq;

DROP SEQUENCE p2_session_session_id_seq;

DROP SEQUENCE department_department_id_seq;

DROP SEQUENCE instructor_instructor_id_seq;

DROP TABLE course CASCADE CONSTRAINTS;

DROP TABLE department CASCADE CONSTRAINTS;

DROP TABLE instructor CASCADE CONSTRAINTS;

DROP TABLE p2_session CASCADE CONSTRAINTS;

CREATE TABLE course (
    unique_number   INTEGER NOT NULL,
    course_number   INTEGER,
    course_name     VARCHAR2(255)
);

ALTER TABLE course ADD CONSTRAINT course_pk PRIMARY KEY ( unique_number );

CREATE TABLE department (
    department_id     INTEGER NOT NULL,
    department_name   VARCHAR2(255)
);

ALTER TABLE department ADD CONSTRAINT department_pk PRIMARY KEY ( department_id );

CREATE TABLE instructor (
    instructor_id   INTEGER NOT NULL,
    first_name      VARCHAR2(255),
    last_name       VARCHAR2(255),
    department      VARCHAR2(255),
    type            VARCHAR2(18) NOT NULL,
    salary          INTEGER,
    major           VARCHAR2(255)
);

ALTER TABLE instructor ADD CONSTRAINT ch_inh_instructor CHECK (
    type IN (
        'INSTRUCTOR','PROFESSOR','TEACHING_ASSISTANT'
    )
);

ALTER TABLE instructor ADD CONSTRAINT instructor_exdep CHECK (
    (
            type = 'INSTRUCTOR'
        AND
            major IS NULL
        AND
            salary IS NULL
    ) OR (
            type = 'PROFESSOR'
        AND
            major IS NULL
    ) OR (
            type = 'TEACHING_ASSISTANT'
        AND
            salary IS NULL
    )
);

ALTER TABLE instructor ADD CONSTRAINT instructor_pk PRIMARY KEY ( instructor_id );

CREATE TABLE p2_session (
    session_id       INTEGER NOT NULL,
    unique_number    INTEGER NOT NULL,
    department_id    INTEGER NOT NULL,
    instructor_id    INTEGER NOT NULL,
    instructor_id1   INTEGER NOT NULL
);

ALTER TABLE p2_session ADD CONSTRAINT session_pk1 PRIMARY KEY ( session_id );

ALTER TABLE p2_session ADD CONSTRAINT course_session FOREIGN KEY ( unique_number )
    REFERENCES course ( unique_number );

ALTER TABLE p2_session ADD CONSTRAINT department_session FOREIGN KEY ( department_id )
    REFERENCES department ( department_id );

ALTER TABLE p2_session ADD CONSTRAINT phd_session FOREIGN KEY ( instructor_id1 )
    REFERENCES instructor ( instructor_id );

ALTER TABLE p2_session ADD CONSTRAINT professor_session FOREIGN KEY ( instructor_id )
    REFERENCES instructor ( instructor_id );

CREATE SEQUENCE course_unique_number_seq START WITH 1 NOCACHE ORDER;

CREATE OR REPLACE TRIGGER course_unique_number_trg BEFORE
    INSERT ON course
    FOR EACH ROW
    WHEN (
        new.unique_number IS NULL
    )
BEGIN
    :new.unique_number := course_unique_number_seq.nextval;
END;
/

CREATE SEQUENCE department_department_id_seq START WITH 1 NOCACHE ORDER;

CREATE OR REPLACE TRIGGER department_department_id_trg BEFORE
    INSERT ON department
    FOR EACH ROW
    WHEN (
        new.department_id IS NULL
    )
BEGIN
    :new.department_id := department_department_id_seq.nextval;
END;
/

CREATE SEQUENCE instructor_instructor_id_seq START WITH 1 NOCACHE ORDER;

CREATE OR REPLACE TRIGGER instructor_instructor_id_trg BEFORE
    INSERT ON instructor
    FOR EACH ROW
    WHEN (
        new.instructor_id IS NULL
    )
BEGIN
    :new.instructor_id := instructor_instructor_id_seq.nextval;
END;
/

CREATE SEQUENCE p2_session_session_id_seq START WITH 1 NOCACHE ORDER;

CREATE OR REPLACE TRIGGER p2_session_session_id_trg BEFORE
    INSERT ON p2_session
    FOR EACH ROW
    WHEN (
        new.session_id IS NULL
    )
BEGIN
    :new.session_id := p2_session_session_id_seq.nextval;
END;
/



-- Oracle SQL Developer Data Modeler Summary Report: 
-- 
-- CREATE TABLE                             4
-- CREATE INDEX                             0
-- ALTER TABLE                             10
-- CREATE VIEW                              0
-- ALTER VIEW                               0
-- CREATE PACKAGE                           0
-- CREATE PACKAGE BODY                      0
-- CREATE PROCEDURE                         0
-- CREATE FUNCTION                          0
-- CREATE TRIGGER                           4
-- ALTER TRIGGER                            0
-- CREATE COLLECTION TYPE                   0
-- CREATE STRUCTURED TYPE                   0
-- CREATE STRUCTURED TYPE BODY              0
-- CREATE CLUSTER                           0
-- CREATE CONTEXT                           0
-- CREATE DATABASE                          0
-- CREATE DIMENSION                         0
-- CREATE DIRECTORY                         0
-- CREATE DISK GROUP                        0
-- CREATE ROLE                              0
-- CREATE ROLLBACK SEGMENT                  0
-- CREATE SEQUENCE                          4
-- CREATE MATERIALIZED VIEW                 0
-- CREATE SYNONYM                           0
-- CREATE TABLESPACE                        0
-- CREATE USER                              0
-- 
-- DROP TABLESPACE                          0
-- DROP DATABASE                            0
-- 
-- REDACTION POLICY                         0
-- 
-- ORDS DROP SCHEMA                         0
-- ORDS ENABLE SCHEMA                       0
-- ORDS ENABLE OBJECT                       0
-- 
-- ERRORS                                   0
-- WARNINGS                                 0
