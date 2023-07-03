WITH distinct_crimes AS (
	SELECT DISTINCT
		num_of_crimes,
		DATE(date) AS date
	FROM timeseries_data_df
),

weekly_crimes AS (
	SELECT 
		DATE(date, '-7 DAYS', 'WEEKDAY 1') AS week,
		COUNT(*) AS weekly_num_crimes 
	FROM distinct_crimes
	GROUP BY 1
),

recent_7_day_crimes AS (
	SELECT 
		crimes.week,
		COUNT(recent_crimes.num_of_crimes) AS crime_count
	FROM weekly_crimes crimes
	JOIN distinct_crimes recent_crimes
		ON recent_crimes.date < crimes.week
		AND recent_crimes.date >= DATE(crimes.week, '-7 DAYS') 
	GROUP BY 1
),

recent_30_day_crimes AS (
	SELECT 
		crimes.week,
		COUNT(recent_crimes.num_of_crimes) AS crime_count
	FROM weekly_crimes crimes
	JOIN distinct_crimes recent_crimes
		ON recent_crimes.date < crimes.week
		AND recent_crimes.date >= DATE(crimes.week, '-30 DAYS') 
	GROUP BY 1
)

SELECT
	crimes.week,
	COALESCE(recent_7_day_crimes.crime_count, 0) AS crime_count_7_day,
	COALESCE(recent_30_day_crimes.crime_count, 0) AS crime_count_30_day
FROM weekly_crimes crimes
LEFT JOIN recent_7_day_crimes
	ON recent_7_day_crimes.week = crimes.week
LEFT JOIN recent_30_day_crimes
	ON recent_30_day_crimes.week = crimes.week
