-- A. Record counts

USE us_crude_oil_analysis;
	SELECT "dim_geogrpahy" as table_name,
		COUNT(*) AS "record_count"
			FROM dim_geography;

UNION ALL

SELECT "fact_production_monthly"
