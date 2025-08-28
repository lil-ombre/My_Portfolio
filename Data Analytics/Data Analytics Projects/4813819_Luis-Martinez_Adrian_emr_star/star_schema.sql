############################################################################################
# Star Schema: Create Table Statements
#  by Adrian Luis-Martinez
############################################################################################
SHOW TABLES;
SELECT * FROM visit_symptom;
DESCRIBE visit;
DESCRIBE visit_lab;
DESCRIBE dim_patient;
DESCRIBE provider;
DESCRIBE diagnosis;
DESCRIBE lab;
DESCRIBE clinical_procedures;
DESCRIBE symptom;

### Creating fact_visit table
CREATE TABLE fact_visit(
	visit_id INT PRIMARY KEY,
    patient_id INT,
    provider_id INT,
    date_id INT,
-- Summary counts for reporting
    diagnosis_count INT,
    lab_count INT,
    procedure_count INT,
    symptom_count INT,
-- Reference ID's for 
    FOREIGN KEY (patient_id) REFERENCES dim_patient (patient_id),
    FOREIGN KEY (provider_id) REFERENCES dim_provider (provider_id),
    FOREIGN KEY (date_id) REFERENCES dim_date (date_id)
);

### Creating dim_patient table
CREATE TABLE dim_patient (
patient_id INT PRIMARY KEY,
first_name VARCHAR(50),
last_name VARCHAR(50),
gender VARCHAR(50),
birthdate date
);

### Creating dim_provider table
CREATE TABLE dim_provider(
provider_id INT PRIMARY KEY,
first_name VARCHAR(50),
last_name VARCHAR(50),
specialty VARCHAR(50)
);

### Creating dim_diagnosis table
CREATE TABLE dim_diagnosis (
diagnosis_id INT PRIMARY KEY,
icd10_code varchar(45) NOT NULL,
name varchar(250) NOT NULL
);

### Create dim_lab table
CREATE TABLE dim_lab (
lab_id INT PRIMARY KEY,
cpt_code varchar(45) NOT NULL,
lab_name varchar(255) NOT NULL
);

### Create dim_procedure table
CREATE TABLE dim_procedure (
procedure_id INT PRIMARY KEY,
proc_name VARCHAR(100) NOT NULL,
icd10_code VARCHAR(50) NOT NULL,
description VARCHAR(255) NOT NULL
);

### Creating dim_symptom table
CREATE TABLE dim_symptom (
symptom_id INT PRIMARY KEY,
note VARCHAR(500) NOT NULL
);

### Creating dim_date table
CREATE TABLE dim_date (
date_id INT PRIMARY KEY,
full_date DATE
);

######## Creating bridge tables

### Creating visit_diagnosis table
CREATE TABLE visit_diagnosis (
    visit_id INT,
    diagnosis_id INT,
    PRIMARY KEY (visit_id, diagnosis_id),
    FOREIGN KEY (visit_id) REFERENCES fact_visit(visit_id),
    FOREIGN KEY (diagnosis_id) REFERENCES dim_diagnosis(diagnosis_id)
);

CREATE TABLE visit_lab (
    visit_id INT,
    lab_id INT,
    PRIMARY KEY (visit_id, lab_id),
    FOREIGN KEY (visit_id) REFERENCES fact_visit(visit_id),
    FOREIGN KEY (lab_id) REFERENCES dim_lab(lab_id)
);

CREATE TABLE visit_procedure (
    visit_id INT,
    procedure_id INT,
    PRIMARY KEY (visit_id, procedure_id),
    FOREIGN KEY (visit_id) REFERENCES fact_visit(visit_id),
    FOREIGN KEY (procedure_id) REFERENCES dim_procedure(procedure_id)
);

CREATE TABLE visit_symptom (
    visit_id INT,
    symptom_id INT,
    PRIMARY KEY (visit_id, symptom_id),
    FOREIGN KEY (visit_id) REFERENCES fact_visit(visit_id),
    FOREIGN KEY (symptom_id) REFERENCES dim_symptom(symptom_id)
);