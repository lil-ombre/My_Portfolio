/*
SQL DDL STATEMENTS PRACTICE
*/
CREATE TABLE CITY(
City_ID INT,
City VARCHAR(50) NOT NULL,
CONSTRAINT PK_CITY PRIMARY KEY(City_ID)
);

CREATE TABLE OCCUPATION(
Occupation_ID INT AUTO_INCREMENT,
Occupation VARCHAR(50),
CONSTRAINT PK_OCCUPATION PRIMARY KEY(Occupation_ID)
);

CREATE TABLE PERSON(
Person_ID INT AUTO_INCREMENT,
Person_Name VARCHAR(50),
Age INT,
Salary INT,
City_ID INT,
Occupation_ID INT,
CONSTRAINT PK_PERSON PRIMARY KEY(Person_ID),
CONSTRAINT FK_CITY FOREIGN KEY(City_ID) REFERENCES CITY(City_ID)
);

desc PERSON;

ALTER TABLE PERSON
ADD CONSTRAINT FK_OCCUPATION FOREIGN KEY(Occupation_ID) 
REFERENCES OCCUPATION(Occupation_ID);

ALTER TABLE PERSON
ADD REMOTE BOOLEAN;

ALTER TABLE PERSON
DROP REMOTE;

ALTER TABLE PERSON
MODIFY Person_Name VARCHAR(256);

CREATE TABLE TEST(
Test_ID INT UNIQUE,
Created_Date DATETIME DEFAULT now()
);

INSERT INTO TEST 
(Test_ID)
VALUES
(2);

SELECT *
FROM TEST;

DROP TABLE TEST;

/*
SQL DML STATEMENTS PRACTICE
*/

DESC CITY;

INSERT INTO CITY
(City_ID,City)
VALUES
(1,'New York'),
(2,'Los Angeles'),
(3,'Chicago'),
(4,'Houston'),
(5,'San Francisco'),
(6,'Seattle');

SELECT * FROM CITY;

CREATE TABLE BULK_DATA(
Person_Name VARCHAR(50),
AGE INT,
City VARCHAR(50),
Salary INT,
Occupation VARCHAR(50)
);

INSERT INTO BULK_DATA
VALUES
('Alice',25,'New York',55000,'Data Analyst'),
('Bob',30,'Los Angeles',62000,'Software Engineer'),
('Charlie',28,'Chicago',58000,'Marketing Manager'),
('Diana',32,'Houston',64000,'HR Specialist'),
('Ethan',27,'San Francisco',60000,'Product Manager'),
('Fiona',29,'Seattle',59000,'UX Designer');

SELECT * FROM BULK_DATA;

INSERT INTO OCCUPATION
(Occupation)
SELECT DISTINCT Occupation FROM BULK_DATA;

INSERT INTO PERSON
(Person_Name,Age,Salary,City_ID,Occupation_ID)
SELECT b.Person_Name,
b.Age,
b.Salary,
c.City_ID,
o.Occupation_ID
FROM BULK_DATA AS b
LEFT JOIN CITY AS c ON b.City = c.City
LEFT JOIN OCCUPATION AS o ON b.Occupation = o.Occupation;

SELECT * FROM PERSON;

UPDATE PERSON
SET Person_Name = 'Robert'
WHERE Person_Name = 'Bob';

UPDATE PERSON
SET Salary = Salary + (Salary * 0.2)
WHERE City_ID IN (
SELECT City_ID
FROM CITY
WHERE City = 'New York');

SELECT p.*,o.*
FROM PERSON AS p, OCCUPATION AS o
WHERE p.Occupation_ID = o.Occupation_ID
AND o.Occupation IN (
'Data Analyst',
'Software Engineer',
'Marketing Manager'
);

UPDATE PERSON AS p, OCCUPATION AS o
SET Salary = Salary + (Salary * .1)
WHERE p.Occupation_ID = o.Occupation_ID
AND o.Occupation IN (
'Data Analyst',
'Software Engineer',
'Marketing Manager'
);

DELETE FROM CITY
WHERE CITY = 'NEW YORK';
# Error Code: 1175. You are using safe update mode and you tried to update a table without a WHERE that uses a KEY column.  To disable safe mode, toggle the option in Preferences -> SQL Editor and reconnect.

UPDATE PERSON
SET CITY_ID = (SELECT DISTINCT CITY_ID FROM CITY WHERE CITY = 'Houston')
WHERE CITY_ID IN (
SELECT DISTINCT CITY_ID
FROM CITY
WHERE City = 'New York');

DELETE FROM CITY
WHERE City = 'New York';

CREATE TABLE PERSON_BACKUP
AS
SELECT * FROM PERSON;

SELECT * FROM PERSON_BACKUP;

DELETE FROM PERSON;

SELECT * FROM PERSON;

INSERT INTO PERSON
SELECT * FROM PERSON_BACKUP;

SELECT * FROM PERSON;

DROP TABLE PERSON_BACKUP;

INSERT INTO OCCUPATION
(Occupation_ID,Occupation)
VALUES
(300,'Data Sceintist');

SELECT * FROM OCCUPATION;

INSERT INTO OCCUPATION
(Occupation)
VALUES
('DBA');

DELETE FROM OCCUPATION
WHERE Occupation IN (
'Data Scientist', 'DBA');

# FOR FUNSIES
UPDATE OCCUPATION
SET Occupation = 'Data Scientist'
WHERE Occupation_ID = 300;

SELECT * FROM OCCUPATION;

ALTER TABLE OCCUPATION AUTO_INCREMENT = 6;

INSERT INTO OCCUPATION
(Occupation)
VALUES
('Data Scientist'),
('DBA');

CREATE TABLE TEST(
ID INT AUTO_INCREMENT,
MyName VARCHAR(50),
PRIMARY KEY(ID)
);

INSERT INTO TEST
(MyName)
VALUES
('Sean');

SELECT * FROM TEST;

TRUNCATE TABLE TEST;

DROP TABLE TEST;