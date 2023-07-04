WITH distinct_crimes AS (
	SELECT DISTINCT
		num_of_crimes,
		DATE(date) AS date
	FROM timeseries_data_df
)

SELECT DATE(date) AS date, 
	SUM(num_of_crimes) OVER (ORDER BY date ROWS BETWEEN 1 PRECEDING AND CURRENT ROW) as previous_day_crimes,
    SUM(num_of_crimes) OVER (ORDER BY date ROWS BETWEEN 6 PRECEDING AND CURRENT ROW) as last_7_days_crimes,
    SUM(num_of_crimes) OVER (ORDER BY date ROWS BETWEEN 30 PRECEDING AND CURRENT ROW) as last_30_days_crimes,
    num_of_crimes 
FROM distinct_crimes