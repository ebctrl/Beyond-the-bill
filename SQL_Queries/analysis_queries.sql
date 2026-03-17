-- ============================================================================
-- BEYOND THE BILL — SQL Companion Queries
-- Dataset: Healthcare Admissions (55,500 records)
-- ============================================================================

-- 1. KPI Dashboard
SELECT 
    COUNT(*) AS total_admissions,
    ROUND(AVG("Billing Amount"), 2) AS avg_billing,
    ROUND(SUM("Billing Amount"), 2) AS total_billing,
    ROUND(AVG(julianday("Discharge Date") - julianday("Date of Admission")), 1) AS avg_los
FROM healthcare;


-- 2. Billing & LOS by Medical Condition
SELECT 
    "Medical Condition",
    COUNT(*) AS patients,
    ROUND(AVG("Billing Amount"), 2) AS avg_billing,
    ROUND(AVG(julianday("Discharge Date") - julianday("Date of Admission")), 1) AS avg_los,
    ROUND(AVG("Billing Amount") / 
          AVG(julianday("Discharge Date") - julianday("Date of Admission")), 2) AS daily_cost
FROM healthcare
GROUP BY "Medical Condition"
ORDER BY avg_billing DESC;


-- 3. Billing by Condition × Admission Type (pivot-style)
SELECT 
    "Medical Condition",
    ROUND(AVG(CASE WHEN "Admission Type" = 'Emergency' THEN "Billing Amount" END), 0) AS emergency_avg,
    ROUND(AVG(CASE WHEN "Admission Type" = 'Urgent' THEN "Billing Amount" END), 0) AS urgent_avg,
    ROUND(AVG(CASE WHEN "Admission Type" = 'Elective' THEN "Billing Amount" END), 0) AS elective_avg
FROM healthcare
GROUP BY "Medical Condition"
ORDER BY "Medical Condition";


-- 4. Insurance Provider comparison
SELECT 
    "Insurance Provider",
    COUNT(*) AS patients,
    ROUND(AVG("Billing Amount"), 2) AS avg_billing,
    ROUND(AVG(julianday("Discharge Date") - julianday("Date of Admission")), 1) AS avg_los,
    ROUND(SUM("Billing Amount"), 2) AS total_billing
FROM healthcare
GROUP BY "Insurance Provider"
ORDER BY avg_billing DESC;


-- 5. Age group analysis with CASE
SELECT 
    CASE 
        WHEN Age <= 25 THEN '13-25'
        WHEN Age <= 35 THEN '26-35'
        WHEN Age <= 45 THEN '36-45'
        WHEN Age <= 55 THEN '46-55'
        WHEN Age <= 65 THEN '56-65'
        WHEN Age <= 75 THEN '66-75'
        ELSE '76+'
    END AS age_group,
    COUNT(*) AS patients,
    ROUND(AVG("Billing Amount"), 2) AS avg_billing,
    ROUND(AVG(julianday("Discharge Date") - julianday("Date of Admission")), 1) AS avg_los,
    ROUND(AVG(CASE WHEN "Test Results" = 'Abnormal' THEN 1.0 ELSE 0.0 END) * 100, 1) AS abnormal_rate
FROM healthcare
GROUP BY age_group
ORDER BY age_group;


-- 6. Test Results distribution by Condition (crosstab)
SELECT 
    "Medical Condition",
    COUNT(*) AS total,
    ROUND(AVG(CASE WHEN "Test Results" = 'Normal' THEN 1.0 ELSE 0 END) * 100, 1) AS normal_pct,
    ROUND(AVG(CASE WHEN "Test Results" = 'Abnormal' THEN 1.0 ELSE 0 END) * 100, 1) AS abnormal_pct,
    ROUND(AVG(CASE WHEN "Test Results" = 'Inconclusive' THEN 1.0 ELSE 0 END) * 100, 1) AS inconclusive_pct
FROM healthcare
GROUP BY "Medical Condition"
ORDER BY abnormal_pct DESC;


-- 7. Monthly admissions trend with MoM growth (window function)
WITH monthly AS (
    SELECT 
        strftime('%Y-%m', "Date of Admission") AS month,
        COUNT(*) AS admissions,
        ROUND(AVG("Billing Amount"), 2) AS avg_billing
    FROM healthcare
    GROUP BY month
)
SELECT 
    month,
    admissions,
    avg_billing,
    LAG(admissions) OVER (ORDER BY month) AS prev_month,
    ROUND(
        (admissions - LAG(admissions) OVER (ORDER BY month)) * 100.0 /
        LAG(admissions) OVER (ORDER BY month), 1
    ) AS mom_growth_pct
FROM monthly
ORDER BY month;


-- 8. High-billing outlier detection (CTE + percentile)
WITH billing_stats AS (
    SELECT 
        AVG("Billing Amount") AS mean_billing,
        AVG("Billing Amount") + 2 * 
            (SUM("Billing Amount" * "Billing Amount") / COUNT(*) - 
             AVG("Billing Amount") * AVG("Billing Amount")) AS high_threshold
    FROM healthcare
)
SELECT 
    h."Medical Condition",
    h."Admission Type",
    h."Insurance Provider",
    h."Billing Amount",
    h.Age,
    julianday(h."Discharge Date") - julianday(h."Date of Admission") AS los
FROM healthcare h
WHERE h."Billing Amount" > 45000
ORDER BY h."Billing Amount" DESC
LIMIT 20;


-- 9. Medication effectiveness: abnormal rate per medication per condition
SELECT 
    "Medication",
    "Medical Condition",
    COUNT(*) AS patients,
    ROUND(AVG(CASE WHEN "Test Results" = 'Abnormal' THEN 1.0 ELSE 0 END) * 100, 1) AS abnormal_rate,
    RANK() OVER (
        PARTITION BY "Medical Condition" 
        ORDER BY AVG(CASE WHEN "Test Results" = 'Abnormal' THEN 1.0 ELSE 0 END)
    ) AS best_outcome_rank
FROM healthcare
GROUP BY "Medication", "Medical Condition"
ORDER BY "Medical Condition", best_outcome_rank;


-- 10. Admission volume by day of week
SELECT 
    CASE CAST(strftime('%w', "Date of Admission") AS INT)
        WHEN 0 THEN 'Sunday'
        WHEN 1 THEN 'Monday'
        WHEN 2 THEN 'Tuesday'
        WHEN 3 THEN 'Wednesday'
        WHEN 4 THEN 'Thursday'
        WHEN 5 THEN 'Friday'
        WHEN 6 THEN 'Saturday'
    END AS day_of_week,
    COUNT(*) AS admissions,
    ROUND(AVG("Billing Amount"), 2) AS avg_billing,
    ROUND(AVG(CASE WHEN "Admission Type" = 'Emergency' THEN 1.0 ELSE 0 END) * 100, 1) AS emergency_pct
FROM healthcare
GROUP BY day_of_week
ORDER BY admissions DESC;
