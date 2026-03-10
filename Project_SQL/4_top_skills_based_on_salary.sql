/*
1.Which jobs in my field offer the highest salaries?
2.What skills are needed for those highest-paying roles?
3.Which skills are most in demand for my role?
4.Which skills are associated with the highest salaries in my role?
5.Which skills should I learn first for the best career return?
    a. Best option: skills that are both high in demand and high paying
*/

/*
Q4) What are the top skills based on salary?
    Look at the average salary associated with each skill for Data Analyst positions
    Focuses on roles with specified salaries, regardless of location
    Why? It reveals how different skills impact salary levels for Data Analysts and helps identify the most financially rewarding skills to acquire or improve

*/
SELECT
    skills,
    ROUND(AVG(j.salary_year_avg)) AS avg_salary
FROM job_postings_fact AS j
JOIN skills_job_dim AS sjd ON j.job_id = sjd.job_id
JOIN skills_dim AS sd ON sjd.skill_id = sd.skill_id 
WHERE   job_title_short = 'Data Analyst' AND 
        salary_year_avg IS NOT NULL AND
        job_work_from_home = TRUE
GROUP BY sd.skills
ORDER BY avg_salary DESC
LIMIT 25

/*
1. Data Engineering / Big Data
These are used for building data pipelines, processing large datasets, and managing distributed systems.
pyspark
databricks
airflow
scala
postgresql
linux
kubernetes
2. Machine Learning / Data Science
These are used for model building, experimentation, notebooks, and analytical computing.
datarobot
jupyter
pandas
numpy
scikit-learn
watson
3. DevOps / Software Development Workflow
These are used for version control, CI/CD, deployment, and team collaboration in software environments.
bitbucket
gitlab
jenkins
atlassian
4. Cloud / Platform Engineering
These are used for cloud infrastructure and platform-based application or data environments.
gcp
You could also place kubernetes here too, but it fits better under infrastructure-heavy engineering.
5. Backend / Software Development
These are more programming or backend-oriented and are not typical core Data Analyst tools.
golang
swift
twilio
elasticsearch
couchbase
6. BI / Analytics Tools
These are more reporting, dashboarding, and business analysis oriented.
microstrategy
7. Productivity / Documentation / Workspace Tools
These support documentation, planning, and knowledge management.
notion

*/