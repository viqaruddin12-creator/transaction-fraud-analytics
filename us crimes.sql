create schema uscrms;
use uscrms;

#--  What is the total number of incidents?
SELECT COUNT(incident_id) AS total_incidents
FROM cleaned_us_gun_crimes;

#What is the total number of people killed?
SELECT SUM(n_killed) AS total_killed
FROM cleaned_us_gun_crimes;

#What is the total number of people injured?
SELECT SUM(n_injured) AS total_injured
FROM cleaned_us_gun_crimes;

# What is the total number of casualties?
SELECT SUM(total_casualties) AS total_casualties
FROM cleaned_us_gun_crimes;

#What is the average number of casualties per incident?
SELECT ROUND(AVG(total_casualties), 2) AS average_casualties
FROM cleaned_us_gun_crimes;

# How many incidents occurred in each state?
SELECT
    state,
    COUNT(incident_id) AS total_incidents
FROM cleaned_us_gun_crimes
GROUP BY state
ORDER BY total_incidents DESC;

# How many people were killed in each state?
SELECT
    state,
    SUM(n_killed) AS total_killed
FROM cleaned_us_gun_crimes
GROUP BY state
ORDER BY total_killed DESC;

#How many people were injured in each state?
SELECT
    state,
    SUM(n_injured) AS total_injured
FROM cleaned_us_gun_crimes
GROUP BY state
ORDER BY total_injured DESC;

#What are the total casualties in each state?
SELECT
    state,
    SUM(total_casualties) AS total_casualties
FROM cleaned_us_gun_crimes
GROUP BY state
ORDER BY total_casualties DESC;

# How many incidents occurred in each year?
SELECT
    year,
    COUNT(incident_id) AS total_incidents
FROM cleaned_us_gun_crimes
GROUP BY year
ORDER BY year;

# How many incidents occurred in each year?
SELECT
    year,
    COUNT(incident_id) AS total_incidents
FROM cleaned_us_gun_crimes
GROUP BY year
ORDER BY year;

#How many people were injured in each year?
SELECT
    year,
    SUM(n_injured) AS total_injured
FROM cleaned_us_gun_crimes
GROUP BY year
ORDER BY year;

#What are the total casualties in each year?
SELECT
    year,
    SUM(total_casualties) AS total_casualties
FROM cleaned_us_gun_crimes
GROUP BY year
ORDER BY year;

#How many incidents occurred by state and year?
SELECT
    state,
    year,
    COUNT(incident_id) AS total_incidents
FROM cleaned_us_gun_crimes
GROUP BY state, year
ORDER BY state, year;

# What is the average number of people killed per incident in each state?
SELECT
    state,
    ROUND(AVG(n_killed), 2) AS avg_killed_per_incident
FROM cleaned_us_gun_crimes
GROUP BY state
ORDER BY avg_killed_per_incident DESC;

# Which state has the most incidents?
SELECT
    state,
    COUNT(incident_id) AS total_incidents
FROM cleaned_us_gun_crimes
GROUP BY state
ORDER BY total_incidents DESC
LIMIT 1;

#Which state has the most incidents?
SELECT
    state,
    COUNT(incident_id) AS total_incidents
FROM cleaned_us_gun_crimes
GROUP BY state
ORDER BY total_incidents DESC
LIMIT 1;

#Which state has the most injuries?
SELECT
    state,
    SUM(n_injured) AS total_injured
FROM cleaned_us_gun_crimes
GROUP BY state
ORDER BY total_injured DESC
LIMIT 1;

#Which state has the most injuries?
SELECT
    state,
    SUM(n_injured) AS total_injured
FROM cleaned_us_gun_crimes
GROUP BY state
ORDER BY total_injured DESC
LIMIT 1;

#Which individual incident had the most total casualties?
SELECT
    incident_id,
    state,
    city_or_county,
    date,
    total_casualties
FROM cleaned_us_gun_crimes
ORDER BY total_casualties DESC
LIMIT 1;

#How many incidents had at least one person killed?
SELECT
    COUNT(incident_id) AS fatal_incidents
FROM cleaned_us_gun_crimes
WHERE n_killed > 0;

#  Classify incidents as Fatal or Non-Fatal.
SELECT
    CASE
        WHEN n_killed > 0 THEN 'Fatal'
        ELSE 'Non-Fatal'
    END AS incident_type,
    COUNT(incident_id) AS total_incidents
FROM cleaned_us_gun_crimes
GROUP BY incident_type;

# Which incidents had 5 or more casualties?
SELECT
    incident_id,
    state,
    city_or_county,
    date,
    total_casualties,
    n_killed,
    n_injured
FROM cleaned_us_gun_crimes
WHERE total_casualties >= 5
ORDER BY total_casualties DESC;

# Which states had more than 1,000 incidents?
SELECT
    state,
    COUNT(incident_id) AS total_incidents
FROM cleaned_us_gun_crimes
GROUP BY state
HAVING COUNT(incident_id) > 1000
ORDER BY total_incidents DESC;

# Which states had an average of more than 1 casualty per incident?
SELECT
    state,
    ROUND(AVG(total_casualties), 2) AS avg_casualties
FROM cleaned_us_gun_crimes
GROUP BY state
HAVING AVG(total_casualties) > 1
ORDER BY avg_casualties DESC;

# What is the most common gun type?
SELECT
    gun_type,
    COUNT(*) AS total_records
FROM cleaned_us_gun_crimes
WHERE gun_type IS NOT NULL
GROUP BY gun_type
ORDER BY total_records DESC
LIMIT 1;

# How do deaths and injuries vary by gun type?
SELECT
    gun_type,
    SUM(n_killed) AS total_killed,
    SUM(n_injured) AS total_injured,
    SUM(total_casualties) AS total_casualties
FROM cleaned_us_gun_crimes
WHERE gun_type IS NOT NULL
GROUP BY gun_type
ORDER BY total_casualties DESC;

# What is the distribution of participant gender?
SELECT
    participant_gender,
    COUNT(*) AS total_records
FROM cleaned_us_gun_crimes
WHERE participant_gender IS NOT NULL
GROUP BY participant_gender
ORDER BY total_records DESC;

# What is the distribution of participant age group?
SELECT
    participant_age_group,
    COUNT(*) AS total_records
FROM cleaned_us_gun_crimes
WHERE participant_age_group IS NOT NULL
GROUP BY participant_age_group
ORDER BY total_records DESC;

# What is the distribution of participant age group?
SELECT
    participant_age_group,
    COUNT(*) AS total_records
FROM cleaned_us_gun_crimes
WHERE participant_age_group IS NOT NULL
GROUP BY participant_age_group
ORDER BY total_records DESC;

# Which states have more incidents than the average state?
WITH state_counts AS (
    SELECT
        state,
        COUNT(incident_id) AS total_incidents
    FROM cleaned_us_gun_crimes
    GROUP BY state
)
SELECT
    state,
    total_incidents
FROM state_counts
WHERE total_incidents > (
    SELECT AVG(total_incidents)
    FROM state_counts
)
ORDER BY total_incidents DESC;

# Which incidents have more casualties than the average incident?
SELECT
    incident_id,
    state,
    city_or_county,
    date,
    total_casualties,
    n_killed,
    n_injured
FROM cleaned_us_gun_crimes
WHERE total_casualties > (
    SELECT AVG(total_casualties)
    FROM cleaned_us_gun_crimes
)
ORDER BY total_casualties DESC;

# Monthly incident analysis.
SELECT
    year,
    month,
    COUNT(incident_id) AS total_incidents,
    SUM(n_killed) AS total_killed,
    SUM(n_injured) AS total_injured,
    SUM(total_casualties) AS total_casualties,
    ROUND(AVG(total_casualties), 2) AS avg_casualties
FROM cleaned_us_gun_crimes
GROUP BY year, month
ORDER BY year, month;

#What is the fatality rate by state?
-- Fatality rate here means the percentage of incidents
-- that had at least one death.
SELECT
    state,
    COUNT(incident_id) AS total_incidents,
    SUM(
        CASE
            WHEN n_killed > 0 THEN 1
            ELSE 0
        END
    ) AS fatal_incidents,
    ROUND(
        100.0 * SUM(
            CASE
                WHEN n_killed > 0 THEN 1
                ELSE 0
            END
        ) / COUNT(incident_id),
        2
    ) AS fatality_rate
FROM cleaned_us_gun_crimes
GROUP BY state
ORDER BY fatality_rate DESC;

#  What is the monthly fatality rate?
SELECT
    year,
    month,
    COUNT(incident_id) AS total_incidents,
    SUM(
        CASE
            WHEN n_killed > 0 THEN 1
            ELSE 0
        END
    ) AS fatal_incidents,
    ROUND(
        100.0 * SUM(
            CASE
                WHEN n_killed > 0 THEN 1
                ELSE 0
            END
        ) / COUNT(incident_id),
        2
    ) AS fatality_rate
FROM cleaned_us_gun_crimes
GROUP BY year, month
ORDER BY year, month;

#  Rank states by total number of incidents.
SELECT
    state,
    COUNT(incident_id) AS total_incidents,
    RANK() OVER (
        ORDER BY COUNT(incident_id) DESC
    ) AS incident_rank
FROM cleaned_us_gun_crimes
GROUP BY state
ORDER BY incident_rank;

# Rank states by total number of deaths.
SELECT
    state,
    SUM(n_killed) AS total_killed,
    RANK() OVER (
        ORDER BY SUM(n_killed) DESC
    ) AS death_rank
FROM cleaned_us_gun_crimes
GROUP BY state
ORDER BY death_rank;

# What percentage of all incidents came from each state?
SELECT
    state,
    COUNT(incident_id) AS total_incidents,
    ROUND(
        100.0 * COUNT(incident_id)
        / SUM(COUNT(incident_id)) OVER(),
        2
    ) AS incident_percentage
FROM cleaned_us_gun_crimes
GROUP BY state
ORDER BY incident_percentage DESC;

# What is the running total of incidents by year?
SELECT
    year,
    COUNT(incident_id) AS yearly_incidents,
    SUM(COUNT(incident_id)) OVER (
        ORDER BY year
    ) AS running_total
FROM cleaned_us_gun_crimes
GROUP BY year
ORDER BY year;

# Compare each year with the previous year.
WITH yearly AS (
    SELECT
        year,
        COUNT(incident_id) AS total_incidents
    FROM cleaned_us_gun_crimes
    GROUP BY year
)
SELECT
    year,
    total_incidents,
    LAG(total_incidents) OVER (
        ORDER BY year
    ) AS previous_year_incidents
FROM yearly
ORDER BY year;

#What is the year-over-year percentage change in incidents?
WITH yearly AS (
    SELECT
        year,
        COUNT(incident_id) AS total_incidents
    FROM cleaned_us_gun_crimes
    GROUP BY year
),
comparison AS (
    SELECT
        year,
        total_incidents,
        LAG(total_incidents) OVER (
            ORDER BY year
        ) AS previous_year_incidents
    FROM yearly
)SELECT
    year,
    total_incidents,
    previous_year_incidents,
    ROUND(
        (total_incidents - previous_year_incidents)
        * 100.0 / previous_year_incidents,
        2
    ) AS yoy_percentage_change
FROM comparison
ORDER BY year;

 # Which state had the highest year-over-year incident growth?
WITH state_year AS (
    SELECT
        state,
        year,
        COUNT(incident_id) AS total_incidents
    FROM cleaned_us_gun_crimes
    GROUP BY state, year
),
comparison AS (
    SELECT
        state,
        year,
        total_incidents,
        LAG(total_incidents) OVER (
            PARTITION BY state
            ORDER BY year
        ) AS previous_year_incidents
    FROM state_year
),growth AS (
    SELECT
        state,
        year,
        total_incidents,
        previous_year_incidents,
        ROUND(
            (total_incidents - previous_year_incidents)
            * 100.0 / previous_year_incidents,
            2
        ) AS growth_percentage
    FROM comparison
    WHERE previous_year_incidents > 0
)
SELECT
    state,
    year,
    total_incidents,
    previous_year_incidents,
    growth_percentage
FROM growth
ORDER BY growth_percentage DESC
LIMIT 1;


