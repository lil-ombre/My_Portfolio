############################################################################################
# Star Schema: Data Integrity Checks
#  by Adrian Luis-Martinez
############################################################################################

### Checking row counts match for all tables
SELECT 
  (SELECT COUNT(*) FROM emr.patient) AS emr_count,
  (SELECT COUNT(*) FROM dim_patient) AS dim_count;
  
SELECT 
  (SELECT COUNT(*) FROM emr.provider) AS emr_count,
  (SELECT COUNT(*) FROM dim_provider) AS dim_count;
  
  SELECT 
  (SELECT COUNT(*) FROM emr.diagnosis) AS emr_count,
  (SELECT COUNT(*) FROM dim_diagnosis) AS dim_count;
  
  SELECT 
  (SELECT COUNT(*) FROM emr.lab) AS emr_count,
  (SELECT COUNT(*) FROM dim_lab) AS dim_count;
  
  SELECT 
  (SELECT COUNT(*) FROM emr.clinical_procedures) AS emr_count,
  (SELECT COUNT(*) FROM dim_procedure) AS dim_count;
  
  SELECT 
  (SELECT COUNT(*) FROM emr.symptom) AS emr_count,
  (SELECT COUNT(*) FROM dim_symptom) AS dim_count;
  
  SELECT 
  (SELECT COUNT(*) FROM emr.visit_diagnosis) AS emr_count,
  (SELECT COUNT(*) FROM visit_diagnosis) AS dim_count;
  
  SELECT 
  (SELECT COUNT(*) FROM emr.visit) AS emr_count,
  (SELECT COUNT(*) FROM fact_visit) AS fact_count;
  
  SELECT 
  (SELECT COUNT(*) FROM emr.visit_lab) AS emr_count,
  (SELECT COUNT(*) FROM visit_lab) AS dim_count;
  
  SELECT 
  (SELECT COUNT(*) FROM emr.visit_procedure) AS emr_count,
  (SELECT COUNT(*) FROM visit_procedure) AS dim_count;
  
  SELECT 
  (SELECT COUNT(*) FROM emr.visit_symptom) AS emr_count,
  (SELECT COUNT(*) FROM visit_symptom) AS dim_count;
  
SELECT
(SELECT COUNT(DISTINCT visit_date) FROM emr.visit) AS visit_date_count,
(SELECT COUNT(*) FROM dim_date) AS dim_date_count;

SELECT * FROM fact_visit LIMIT 100;

### Checking for NULL foreign keys
SELECT * FROM fact_visit
WHERE patient_id IS NULL OR provider_id IS NULL OR date_id IS NULL;

### checking for duplicates in dim_date table
SELECT full_date, COUNT(*) as count
FROM dim_date
GROUP BY full_date
HAVING COUNT(*) > 1;

### referential intergity check
SELECT vd.visit_id
FROM visit_diagnosis vd
LEFT JOIN fact_visit fv ON vd.visit_id = fv.visit_id
WHERE fv.visit_id IS NULL;