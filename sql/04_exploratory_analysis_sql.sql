USE us_crude_oil_analysis;

-- A. National monthly production and changes 
-- Expected result: 199 rows. 

WITH national_history AS (
	SELECT month, production_kbpd, 
		   LAG(production_kbpd, 1) 
				OVER(ORDER BY month) AS previous_month_kbpd,
		   LAG(production_kbpd, 12) 
				OVER(ORDER BY month) AS previous_year_kbpd
FROM fact_production_monthly
	WHERE series_id = 'MCRFPUS2'
    )

SELECT month, production_kbpd,
	   production_kbpd - previous_month_kbpd AS mom_change_kbpd,
       ROUND( 100.0 * (production_kbpd - previous_month_kbpd)
			 / NULLIF(previous_month_kbpd, 0), 2)
				AS mom_change_ptc,
                
	   production_kbpd - previous_year_kbpd AS yoy_change_kbpd,
	   ROUND( 100.0 * (production_kbpd - previous_year_kbpd)
			 / NULLIF(previous_year_kbpd, 0), 2)
				AS yoy_change_ptc
FROM national_history
	ORDER BY month;
    
-- B. Latest month component ranking 
-- Expected result: 34 rows, all for July 2026

 WITH latest_month AS (
	SELECT MAX(month) AS month
FROM fact_production_monthly
	WHERE series_id = 'MCRFPUS2'
    ),

national_total AS (
	SELECT f.month, production_kbpd AS national_kbpd
FROM fact_production_monthly AS f
	INNER JOIN latest_month AS l
		ON f.month = l.month
			WHERE f.series_id = 'MCRFPUS2'
	)
    
	SELECT f.month, 
		   DENSE_RANK() OVER(ORDER BY f.production_kbpd DESC) AS production_rank,
           g.area_name,
           g.area_type,
           g.padd,
           f.production_kbpd,
           ROUND(100.0 * f.production_kbpd / NULLIF(n.national_kbpd, 0), 2
           ) AS share_of_us_ptc
	FROM fact_production_monthly AS f
		INNER JOIN dim_geography AS g 
			ON f.series_id = g.series_id
		INNER JOIN national_total AS n 
			ON f.month = n.month
				WHERE g.is_component = 1 
					ORDER BY production_rank, g.area_name;

-- C. Latest-month published PADD totals and shares 
-- Expected result: five rows, all for July 2026.

WITH latest_month AS (
	SELECT MAX(month) AS month 
FROM fact_production_monthly
	WHERE series_id = 'MCRFPUS2'
    ),

national_total AS (
	SELECT f.month, f.production_kbpd AS national_kbpd
FROM fact_production_monthly AS f
	INNER JOIN latest_month AS l
		ON f.month = l.month
			WHERE f.series_id = 'MCRFPUS2'
	)
	
    SELECT f.month, f.production_kbpd,
		   g.padd, g.area_name,
           ROUND(100.0 * f.production_kbpd / NULLIF(n.national_kbpd, 0), 2)
			AS share_of_us_ptc
FROM fact_production_monthly AS f
	INNER JOIN dim_geography AS g
		ON f.series_id = g.series_id
	INNER JOIN national_total AS n 
		ON f.month = n.month 
			WHERE g.area_type = 'PADD'
				ORDER BY f.production_kbpd DESC, g.padd;
