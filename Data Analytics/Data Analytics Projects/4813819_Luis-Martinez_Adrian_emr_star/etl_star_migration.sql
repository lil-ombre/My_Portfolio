############################################################################################
# Star Schema: ETL Star Migration
#  by Adrian Luis-Martinez
############################################################################################

####### loading data into dimmension tables

### Loading patients data into dim_patient
INSERT INTO dim_patient (patient_id, first_name, last_name, gender, birthdate)
SELECT patient_id, first_name, last_name, gender, dob
FROM emr.patient;

### Loading provider data into dim_provider
INSERT INTO dim_provider (provider_id, first_name, last_name, specialty)
SELECT provider_id, first_name, last_name, specialty
FROM emr.provider;

### Loading diagnosis data into dim_diagnosis
INSERT INTO dim_diagnosis (diagnosis_id, icd10_code, name)
SELECT diagnosis_id, icd10_code, name
FROM emr.diagnosis;

### Loading lab data into dim_lab
INSERT INTO dim_lab (lab_id, cpt_code, lab_name)
SELECT lab_id, cpt_code, lab_name
FROM emr.lab;

### Loading clinical_procedures data into dim_procedure
INSERT INTO dim_procedure (procedure_id, proc_name, icd10_code, description)
SELECT procedure_id, proc_name, icd10_code, description
FROM emr.clinical_procedures;

### Loading symptom data into dim_symptoms
INSERT INTO dim_symptom (symptom_id, note)
SELECT symptom_id, note
FROM emr.symptom;

### Loading visit_date data from visit table into dim_date
INSERT INTO dim_date (date_id, full_date)
SELECT 
    DENSE_RANK() OVER (ORDER BY visit_date) AS date_id,
    visit_date
FROM (
    SELECT DISTINCT visit_date
    FROM emr.visit
) AS unique_dates;

####### loading fact_visit table

INSERT INTO fact_visit (
    visit_id, patient_id, provider_id, date_id,
    diagnosis_count, lab_count, procedure_count, symptom_count
)
SELECT
    v.visit_id,
    v.patient_id,
    v.provider_id,
    dd.date_id,
    -- Aggregate counts for diagnosis_count, lab_count, procedure_count, symptom_count fields
    (SELECT COUNT(*) FROM emr.visit_diagnosis vd WHERE vd.visit_id = v.visit_id) AS diagnosis_count,
    (SELECT COUNT(*) FROM emr.visit_lab vl WHERE vl.visit_id = v.visit_id) AS lab_count,
    (SELECT COUNT(*) FROM emr.visit_procedure vp WHERE vp.visit_id = v.visit_id) AS procedure_count,
    (SELECT COUNT(*) FROM emr.visit_symptom vs WHERE vs.visit_id = v.visit_id) AS symptom_count
FROM emr.visit AS v
JOIN dim_date AS dd ON v.visit_date = dd.full_date;

####### loading bridge tables

### Loading visit_diagnosis data into new visit_diagnosis
INSERT INTO visit_diagnosis (visit_id, diagnosis_id)
SELECT visit_id, diagnosis_id
FROM emr.visit_diagnosis;

### Loading visit_lab data into new visit_lab
INSERT INTO visit_lab (visit_id, lab_id)
SELECT visit_id, lab_id
FROM emr.visit_lab;

### Loading visit_procedure data into new visit_procedure
INSERT INTO visit_procedure (visit_id, procedure_id)
SELECT visit_id, procedure_id
FROM emr.visit_procedure;

### Loading visit_symptom data into new visit_symptom
INSERT INTO visit_symptom (visit_id, symptom_id)
SELECT visit_id, symptom_id
FROM emr.visit_symptom;