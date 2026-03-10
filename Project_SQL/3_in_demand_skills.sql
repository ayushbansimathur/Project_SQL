/*
1.Which jobs in my field offer the highest salaries?
2.What skills are needed for those highest-paying roles?
3.Which skills are most in demand for my role?
4.Which skills are associated with the highest salaries in my role?
5.Which skills should I learn first for the best career return?
    a. Best option: skills that are both high in demand and high paying
*/

SELECT
    job_title_short,
    skills,
    COUNT(skills) AS count_skills
FROM job_postings_fact AS j
JOIN skills_job_dim AS sjd ON j.job_id = sjd.job_id
JOIN skills_dim AS sd ON sjd.skill_id = sd.skill_id 
WHERE job_title_short = 'Data Analyst' AND j.job_location = 'Anywhere'
GROUP BY job_title_short, skills
ORDER BY count_skills DESC
LIMIT 5;