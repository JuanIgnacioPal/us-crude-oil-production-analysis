USE us_crude_oil_analysis;

-- A. Duplicated month-series combinations. 
-- Expected result: no rows. 

SELECT month, series_id,
	COUNT(*) AS record_count
FROM fact_production_monthly
	GROUP BY month, series_id
		HAVING COUNT(*) > 1;

-- B. Invalid production records.
-- Expected result: no records.
-- Zero production is still valid, and therefore preserved. 

SELECT month, series_id, production_kbpd
FROM fact_production_monthly
	WHERE month IS NULL
		OR series_id IS NULL
        OR TRIM(series_id) = ''
        OR production_kbpd IS NULL
        OR production_kbpd < 0
        OR DAYOFMONTH(month) <> 1
        OR month < '2010-01-01'
        OR month > '2026-07-01';

-- C. Production records without a geography match. 
-- Expected result: no rows.

SELECT f.month, f.series_id
FROM fact_production_monthly AS f
	LEFT JOIN dim_geography AS g
		ON f.series_id = g.series_id
			WHERE g.series_id IS NULL;
            
-- D. Missing month-series combination.
-- Expected result: no rows.

WITH RECURSIVE expected_months AS 
	(SELECT CAST('2010-01-01' AS DATE) AS month
    
    UNION ALL
    
    SELECT DATE_ADD(month, INTERVAL 1 month)
FROM expected_months
	WHERE month < '2026-07-01'
    )

	SELECT m.month, g.series_id, g.area_name
FROM expected_months AS m
	CROSS JOIN dim_geography AS g
    LEFT JOIN fact_production_monthly AS f
		ON f.month = m.month
        AND f.series_id = g.series_id 
			WHERE f.series_id IS NULL	
				ORDER BY g.series_id, m.month;

-- E. Geographic reconciliation summary 
-- Expected result: six rows, each covering 199 monthly comparsions. 
-- Diferences require review, they do not necessarily must equal zero.

WITH component_totals AS

-- National sum of states and federal offshore areas  

	(SELECT f.month, 'United States' AS comparison_area,
		   SUM(production_kbpd) AS component_sum_kbpd
FROM fact_production_monthly AS f
	INNER JOIN dim_geography AS g
		ON f.series_id = g.series_id
			WHERE g.is_component = 1 
				GROUP BY f.month
	UNION ALL
    
-- Component sums within each PADD

	SELECT f.month, g.padd AS comparison_area,
		   SUM(f.production_kbpd) AS component_sum_kbpd
FROM fact_production_monthly AS f
	INNER JOIN dim_geography AS g 
		ON f.series_id = g.series_id
			WHERE g.is_component = 1
				GROUP BY f.month, g.padd
	),
    published_totals AS 
	(SELECT f.month, 
			CASE WHEN g.area_type = 'National' 
				THEN 'United States' ELSE g.padd
					END AS comparison_area,
			f.production_kbpd AS published_total_kbpd
FROM fact_production_monthly AS f
	INNER JOIN dim_geography AS g
		ON f.series_id = g.series_id
			WHERE g.area_type IN ('National', 'PADD')
	),
    
    differences AS 
    (SELECT p.month, p.comparison_area, 
			c.component_sum_kbpd - p.published_total_kbpd AS difference_kbpd
FROM published_totals AS p
	INNER JOIN component_totals AS c 
		ON p.month = c.month
		AND p.comparison_area = c.comparison_area
	)
    SELECT comparison_area,
		   COUNT(*) AS months_compared,
           SUM(difference_kbpd = 0) AS exact_match_months,
           SUM(difference_kbpd <> 0) AS differing_months,
           MIN(difference_kbpd) AS min_difference_kbpd,
           MAX(difference_kbpd) AS max_difference_kbpd,
           MAX(ABS(difference_kbpd)) AS max_absolute_difference_kbpd
FROM differences 
	GROUP BY comparison_area
		ORDER BY comparison_area;
