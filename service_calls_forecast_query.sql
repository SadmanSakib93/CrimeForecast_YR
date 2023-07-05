WITH distinct_calls AS (
	SELECT DISTINCT
		num_of_calls,
		DATE(date) AS date
	FROM timeseries_data_df
)

SELECT DATE(date) AS date, 
	LAG(num_of_calls) OVER (ORDER BY date) AS previous_day_calls,
    SUM(num_of_calls) OVER (ORDER BY date ROWS BETWEEN 6 PRECEDING AND 1 PRECEDING) as last_7_days_calls,
    SUM(num_of_calls) OVER (ORDER BY date ROWS BETWEEN 30 PRECEDING AND 1 PRECEDING) as last_30_days_calls,
    num_of_calls 
FROM distinct_calls