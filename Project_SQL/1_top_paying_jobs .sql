/*
1.Which jobs in my field offer the highest salaries?
2.What skills are needed for those highest-paying roles?
3.Which skills are most in demand for my role?
4.Which skills are associated with the highest salaries in my role?
5.Which skills should I learn first for the best career return?
    a. Best option: skills that are both high in demand and high paying
*/

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