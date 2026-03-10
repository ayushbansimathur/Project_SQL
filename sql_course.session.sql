SELECT
    job_title_short,
    skills,
    COUNT(skills) AS count_skills
FROM job_postings_fact AS j
JOIN skills_job_dim AS sjd ON j.job_id = sjd.job_id
JOIN skills_dim AS sd ON sjd.skill_id = sd.skill_id 
WHERE job_title_short = 'Business Analyst'
GROUP BY job_title_short, skills
ORDER BY count_skills DESC
LIMIT 10;