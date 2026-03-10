/*
1.Which jobs in my field offer the highest salaries?
2.What skills are needed for those highest-paying roles?
3.Which skills are most in demand for my role?
4.Which skills are associated with the highest salaries in my role?
5.Which skills should I learn first for the best career return?
    a. Best option: skills that are both high in demand and high paying
*/

WITH skills_demand AS (
        SELECT
            job_title_short,
            sd.skill_id,
            skills,
            COUNT(skills) AS count_skills
        FROM job_postings_fact AS j
        JOIN skills_job_dim AS sjd ON j.job_id = sjd.job_id
        JOIN skills_dim AS sd ON sjd.skill_id = sd.skill_id 
        WHERE job_title_short = 'Data Analyst' AND j.job_location = 'Anywhere'
        GROUP BY job_title_short, skills, sd.skill_id
        ),
    average_salary AS (
        SELECT
            sd.skill_id,
            skills,
            ROUND(AVG(j.salary_year_avg)) AS avg_salary
        FROM job_postings_fact AS j
        JOIN skills_job_dim AS sjd ON j.job_id = sjd.job_id
        JOIN skills_dim AS sd ON sjd.skill_id = sd.skill_id 
        WHERE   job_title_short = 'Data Analyst' AND 
                salary_year_avg IS NOT NULL AND
                job_work_from_home = TRUE
        GROUP BY sd.skills, sd.skill_id
        )

SELECT
    skills_demand.skills,
    skills_demand.count_skills,
    average_salary.avg_salary
FROM skills_demand
JOIN average_salary ON skills_demand.skill_id = average_salary.skill_id
WHERE skills_demand.count_skills > 10
ORDER BY
    average_salary.avg_salary DESC,
     skills_demand.count_skills DESC
LIMIT 25;