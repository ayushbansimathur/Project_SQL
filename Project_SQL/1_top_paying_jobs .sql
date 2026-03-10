SELECT
    job_id,
    job_title_short,
    c.name AS company_name,
    job_location,
    job_schedule_type,
    salary_year_avg,
    job_posted_date
FROM job_postings_fact AS j
JOIN company_dim AS c ON j.company_id = c.company_id
WHERE
        job_title_short = 'Data Analyst' AND
        job_location = 'Anywhere' AND
        salary_year_avg IS NOT NULL
ORDER BY
    salary_year_avg DESC
LIMIT 10;