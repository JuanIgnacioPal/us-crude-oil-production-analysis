USE us_crude_oil_analysis;

-- A. Complete-year national averages and annual growth
-- Expected result: 16 rows, 2010-2025

WITH annual_rates AS (
    SELECT YEAR(month) AS production_year,
           COUNT(DISTINCT month) AS months_covered,
           SUM(DAY(LAST_DAY(month))) AS days_covered,
           SUM(production_kbpd * DAY(LAST_DAY(month)))
               / SUM(DAY(LAST_DAY(month))) AS average_kbpd
    FROM fact_production_monthly
    WHERE series_id = 'MCRFPUS2'
    GROUP BY YEAR(month)
    HAVING COUNT(DISTINCT month) = 12
),
annual_comparison AS (
    SELECT a.*,
           p.average_kbpd AS previous_year_kbpd 
    FROM annual_rates AS a
    LEFT JOIN annual_rates AS p
        ON p.production_year = a.production_year - 1
)
SELECT production_year,
       months_covered,
       days_covered,
       ROUND(average_kbpd, 3) AS average_kbpd,
       ROUND(average_kbpd - previous_year_kbpd, 3) AS annual_change_kbpd,
       ROUND(100.0 * (average_kbpd - previous_year_kbpd)
             / NULLIF(previous_year_kbpd, 0), 2) AS annual_growth_pct
FROM annual_comparison
ORDER BY production_year;

-- B. National YTD comparsion 
-- Expected result: two rows, 2025 and 2026.

WITH latest_period AS (
	SELECT MAX(month) AS latest_month
FROM fact_production_monthly
	WHERE series_id = 'MCRFPUS2'),

ytd_rates AS (
	SELECT YEAR(f.month) AS production_year,
		   MONTH(l.latest_month) AS cutoff_month,
           COUNT(*) AS months_covered,
           SUM(DAY(LAST_DAY(f.month))) AS days_covered,
           SUM(f.production_kbpd * DAY(LAST_DAY(f.month)))
			   / SUM(DAY(LAST_DAY(f.month))) AS average_kbpd
FROM fact_production_monthly AS f
	CROSS JOIN latest_period AS l 
		WHERE series_id = 'MCRFPUS2'
			AND YEAR(f.month) IN (YEAR(l.latest_month), YEAR(l.latest_month) - 1)
            AND MONTH(f.month) <= MONTH(l.latest_month)
				GROUP BY YEAR(f.month), MONTH(l.latest_month)
					HAVING COUNT(DISTINCT f.month) = cutoff_month
	)

	SELECT c.production_year, c.cutoff_month, c.months_covered, c.days_covered,
		   ROUND(c.average_kbpd, 3) AS ytd_average_kbpd,
           ROUND(c.average_kbpd - p.average_kbpd, 3) AS ytd_change_kbpd,
           ROUND(100.0 * (c.average_kbpd - p.average_kbpd) 
				/ NULLIF(p.average_kbpd, 0), 2) AS ytd_change_ptc
FROM ytd_rates AS c
	LEFT JOIN ytd_rates AS p
		ON p.production_year = c.production_year - 1
			ORDER BY c.production_year;

-- C. Latest-month Top 5 share
-- Expected result: one row, five selected components. 

WITH latest_period AS (
	SELECT MAX(month) AS latest_month
FROM fact_production_monthly
	WHERE series_id = 'MCRFPUS2'),

ranked_components AS (
	SELECT f.month, f.series_id, f.production_kbpd, 
		   ROW_NUMBER() OVER(ORDER BY f.production_kbpd DESC, f.series_id) 
			AS selection_position
FROM fact_production_monthly AS f
	INNER JOIN dim_geography AS g 
		ON f.series_id = g.series_id
			WHERE g.is_component = 1),

top_five AS (
	SELECT month, COUNT(*) AS selected_components,
		   SUM(production_kbpd) AS top5_kbpd
FROM ranked_components 
	WHERE selection_position <= 5
		GROUP BY month)

SELECT t.month, t.selected_components, t.top5_kbpd,
	   n.production_kbpd AS national_kbpd,
       ROUND(100.0 * t.top5_kbpd / NULLIF(n.production_kbpd, 0), 2)
		AS top5_share_pct
FROM top_five AS t 
	INNER JOIN fact_production_monthly AS n
		ON n.month = t.month
			WHERE n.series_id = 'MCRFPUS2';
            
-- D. Latest_month YoY growth contributions 
-- Expected result: 34 components plus one residual row.

WITH latest_period AS (
    SELECT MAX(month) AS latest_month
    FROM fact_production_monthly
    WHERE series_id = 'MCRFPUS2'
),
national_comparison AS (
    SELECT c.month,
           c.production_kbpd AS current_us_kbpd,
           p.production_kbpd AS previous_us_kbpd
    FROM fact_production_monthly AS c
    INNER JOIN latest_period AS l
        ON c.month = l.latest_month
    INNER JOIN fact_production_monthly AS p
        ON p.series_id = c.series_id
       AND p.month = DATE_SUB(c.month, INTERVAL 1 YEAR)   
    WHERE c.series_id = 'MCRFPUS2'
),
component_changes AS (
    SELECT c.month,
           g.series_id,
           g.area_name,
           c.production_kbpd - p.production_kbpd AS change_kbpd,
           n.previous_us_kbpd                              
    FROM fact_production_monthly AS c
    INNER JOIN dim_geography AS g
        ON c.series_id = g.series_id
    INNER JOIN national_comparison AS n
        ON c.month = n.month
    INNER JOIN fact_production_monthly AS p
        ON p.series_id = c.series_id
       AND p.month = DATE_SUB(c.month, INTERVAL 1 YEAR)
    WHERE g.is_component = 1
),
contribution_rows AS (
    SELECT month,
           'Component' AS row_type,
           area_name,
           change_kbpd,
           100.0 * change_kbpd / NULLIF(previous_us_kbpd, 0) AS contribution_pp
    FROM component_changes

    UNION ALL

    SELECT n.month,
           'Residual',
           'Geographic reconciliation residual',
           n.current_us_kbpd - n.previous_us_kbpd - SUM(c.change_kbpd),
           100.0 * (n.current_us_kbpd - n.previous_us_kbpd - SUM(c.change_kbpd))
               / NULLIF(n.previous_us_kbpd, 0)            
    FROM national_comparison AS n
    INNER JOIN component_changes AS c
        ON n.month = c.month
    GROUP BY n.month, n.current_us_kbpd, n.previous_us_kbpd
)
SELECT month,
       row_type,
       area_name,                                      
       change_kbpd,
       ROUND(contribution_pp, 6) AS contribution_pp
FROM contribution_rows
ORDER BY row_type, contribution_pp DESC, area_name;