-- A. Record counts.

USE us_crude_oil_analysis;
	SELECT 'dim_geography' as table_name,
		COUNT(*) AS record_count
FROM dim_geography

UNION ALL

SELECT 'fact_production_monthly',
	COUNT(*) 
FROM fact_production_monthly;
        
-- B. Temporal coverage, series count, and preserved zeros.

SELECT 
	MIN(month) AS first_month,
    MAX(month) AS last_month, 
		COUNT(DISTINCT month) AS monthly_periods,
        COUNT(DISTINCT series_id) AS series_count,
        SUM(production_kbpd = 0) AS zero_values
FROM fact_production_monthly;
    
-- C. Every geographic series should have 199 observations.
-- Expected results: no rows. 

SELECT g.series_id,
    COUNT(f.month) AS monthly_records
FROM dim_geography AS g
	LEFT JOIN fact_production_monthly AS f
		ON g.series_id = f.series_id
		 GROUP BY g.series_id
			HAVING COUNT(f.month) <> 199;
            
-- D. Classification counts after joining 

SELECT g.area_type,
	COUNT(DISTINCT g.series_id) AS series_count, 
	COUNT(*) AS monthly_records
FROM fact_production_monthly AS f
	LEFT JOIN dim_geography AS g
		ON f.series_id = g.series_id 
			GROUP BY g.area_type
				ORDER BY g.area_type;
                
-- E. Non-overlapping component records 

SELECT 
	COUNT(*) AS component_records
FROM fact_production_monthly AS f
	INNER JOIN dim_geography AS g 
		ON f.series_id = g.series_id 
			WHERE g.is_component = 1;
            
-- F. Reference observation 
SELECT month, 
	   series_id, 
       production_kbpd
FROM fact_production_monthly
	WHERE month = '2010-01-01' 
		AND
		  series_id ='MCRFPUS2';
