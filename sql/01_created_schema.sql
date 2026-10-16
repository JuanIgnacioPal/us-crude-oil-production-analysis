
CREATE DATABASE IF NOT EXISTS us_crude_oil_analysis
    CHARACTER SET utf8mb4
    COLLATE utf8mb4_0900_ai_ci;

USE us_crude_oil_analysis;

CREATE TABLE IF NOT EXISTS dim_geography (
    series_id VARCHAR(40) NOT NULL,
    area_name VARCHAR(100) NOT NULL,
    area_type VARCHAR(30) NOT NULL,
    padd VARCHAR(20) NOT NULL,
    is_component TINYINT NOT NULL,

    PRIMARY KEY (series_id),

    CONSTRAINT chk_geography_type
        CHECK (
            area_type IN (
							'State',
							'Federal offshore',
							'PADD',
							'National',
							'State subdivision')
			  ),

    CONSTRAINT chk_geography_padd
        CHECK (
               (area_type = 'National' AND padd = 'Not applicable')
             OR  ( area_type <> 'National'
				AND padd IN ('PADD 1', 
							 'PADD 2', 
                             'PADD 3',
							 'PADD 4', 
                             'PADD 5')
               )
              ),

    CONSTRAINT chk_geography_component
        CHECK (
               (area_type IN ('State', 
							  'Federal offshore')
                AND is_component = 1)
					OR ( area_type IN ('PADD', 
									   'National', 
                                       'State subdivision')
                AND is_component = 0)
		      )
) ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS fact_production_monthly (
    month DATE NOT NULL,
    series_id VARCHAR(40) NOT NULL,
    production_kbpd DECIMAL(12,3) NOT NULL,

    PRIMARY KEY (month, series_id),

    CONSTRAINT fk_production_geography
        FOREIGN KEY (series_id)
			REFERENCES dim_geography (series_id),

    CONSTRAINT chk_production_month
        CHECK (DAYOFMONTH(month) = 1),

    CONSTRAINT chk_production_nonnegative
        CHECK (production_kbpd >= 0)
) ENGINE = InnoDB;