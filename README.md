# Introduction
This project analyzes the Data Analyst job market using SQL and real job posting data. It focuses on five core questions: which roles pay the most, which skills appear most often, which skills are linked to higher salaries, and which skills offer the best overall career return.

The purpose is to turn raw job market data into clear and practical insights. By comparing salary trends and skill demand, this project highlights the tools and technologies that matter most for anyone looking to grow as a Data Analyst.


Check the project out here: [project_sql_folder](/Project_SQL/)


# Background
I created this project as a real-world SQL analysis to better understand the Data Analyst job market and the trends shaping it. I wanted to go beyond theory and work on something practical that could help me see what employers are actually looking for, which roles pay the most, and which skills are becoming more valuable in the market.

Instead of relying on assumptions or generic career advice, I used job posting data to answer five focused questions: which Data Analyst roles offer the highest salaries, what skills are required for those top-paying jobs, which skills are most in demand, which skills are tied to higher salaries, and which skills provide the best combination of strong demand and strong pay. The goal was to turn raw market data into useful insights that can support smarter learning and career decisions.

# Tools I Used
To analyze the data analyst job market in depth, I used a set of core tools that supported data extraction, management, and project organization.

- SQL: Used to query the dataset, explore patterns, and generate insights from the data.

- PostgreSQL: Served as the database system for storing and managing the job posting data efficiently.

- Visual Studio Code: Used as the main workspace for writing, editing, and running SQL queries.

- Git & GitHub: Helped manage version control, track changes, and organize project files for collaboration and progress tracking.

# The Analysis

## 1. Which Data Analyst jobs offer the highest salaries?

This question focuses on identifying the top-paying remote Data Analyst roles in the dataset. To keep the analysis targeted, I filtered for `Data Analyst` positions only, restricted the results to jobs listed as `Anywhere`, and excluded postings where salary information was missing. This made it possible to compare only remote roles with clearly stated annual salaries.

To answer this, I joined the job postings table with the company table so I could show not just the role, but also the company behind each posting. I then sorted the jobs by average yearly salary in descending order and limited the output to the top 10 results. This gave a clear view of the highest-paying opportunities available for remote Data Analysts.

### SQL Query

```sql
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
```

### What this query does

- Filters the dataset to only include `Data Analyst` roles
- Restricts results to remote jobs listed as `Anywhere`
- Removes postings with missing salary values
- Joins company data to display employer names
- Sorts jobs from highest to lowest salary
- Returns the top 10 highest-paying roles

### Insights

The results show that remote Data Analyst roles can reach very high salary levels, with some postings going far beyond standard market ranges. Mantys appears at the top with a salary of `$650,000`, followed by Meta at `$336,500`, while companies such as AT&T, Pinterest, UCLA Health Careers, and SmartAsset also offer salaries above `$180,000`.

A strong pattern here is that the highest end of the market is not evenly distributed. Mantys is a major outlier, while most of the remaining top-paying roles fall into a narrower range between about `$184,000` and `$336,500`. This suggests that while elite remote Data Analyst roles do exist, extremely high salaries are rare and should be interpreted carefully. For job seekers, the practical takeaway is that remote Data Analyst positions can be financially attractive, especially at companies that value strong analytical and technical capability.

### Horizontal Bar Graph
![alt text](image.png)

## 2. What skills are required for the highest-paying Data Analyst jobs?

This question builds on the first analysis by looking at the skills attached to the top-paying remote Data Analyst roles. The goal here was not just to identify which jobs pay the most, but also to understand what technical capabilities are repeatedly showing up in those high-paying positions.

To answer this, I first created a Common Table Expression called `top_paying_jobs` to isolate the top 10 highest-paying remote Data Analyst roles with known salaries. I then joined that result with the skills mapping table and the skills dimension table to bring in the associated skills for each job. This made it possible to see which tools and technologies were most commonly required across elite-paying Data Analyst roles.

### SQL Query

```sql
WITH top_paying_jobs AS (
    SELECT
        job_id,
        job_title_short,
        c.name AS company_name,
        salary_year_avg
    FROM job_postings_fact AS j
    LEFT JOIN company_dim AS c ON j.company_id = c.company_id
    WHERE
        job_title_short = 'Data Analyst' AND
        job_location = 'Anywhere' AND
        salary_year_avg IS NOT NULL
    ORDER BY
        salary_year_avg DESC
    LIMIT 10
)

SELECT
    top_paying_jobs.*,
    skills_dim.skills
FROM top_paying_jobs
JOIN skills_job_dim ON top_paying_jobs.job_id = skills_job_dim.job_id
JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
ORDER BY salary_year_avg DESC;
```

### What this query does

- Creates a list of the top 10 highest-paying remote `Data Analyst` jobs
- Joins those jobs with the skills mapping table
- Pulls the corresponding skill names from the skills dimension table
- Returns each top-paying job along with its required skills
- Orders the output from the highest salary downward

### Insights

The results show that `SQL` is the most consistently required skill across the highest-paying Data Analyst roles. It appears more often than any other skill, which reinforces its importance as a foundational tool in analytics. Alongside SQL, `Python`, `Tableau`, `R`, and `Excel` also appear repeatedly, showing that high-paying roles often expect a mix of querying, programming, visualization, and business reporting skills.

Another important pattern is that many of these top-paying roles go beyond basic analytics tools. Skills such as `Azure`, `AWS`, `Databricks`, `Snowflake`, `PySpark`, and `GitLab` suggest that some of the best-paying Data Analyst jobs overlap with data engineering, cloud platforms, and modern analytics infrastructure. This means that the highest compensation is often tied to broader technical range, not just dashboarding or spreadsheet work.

### Horizontal Bar Graph
![alt text](image-1.png)

## 3. Which skills are most in demand for Data Analyst roles?

This question focuses on identifying the skills that appear most frequently in remote Data Analyst job postings. While the first two analyses looked at top-paying roles and the skills attached to them, this one shifts attention to overall market demand. The goal was to find out which skills employers ask for most often when hiring for Data Analyst positions.

To answer this, I joined the job postings table with the skills mapping table and the skills dimension table. I then filtered the data for `Data Analyst` roles that were listed as `Anywhere` and counted how many times each skill appeared across those postings. Finally, I grouped the results by skill, sorted them in descending order by frequency, and kept only the top 5 most requested skills.

### SQL Query

```sql
SELECT
    job_title_short,
    skills,
    COUNT(skills) AS count_skills
FROM job_postings_fact AS j
JOIN skills_job_dim AS sjd ON j.job_id = sjd.job_id
JOIN skills_dim AS sd ON sjd.skill_id = sd.skill_id
WHERE
    job_title_short = 'Data Analyst' AND
    j.job_location = 'Anywhere'
GROUP BY
    job_title_short,
    skills
ORDER BY
    count_skills DESC
LIMIT 5;
```

### What this query does

- Filters the dataset to only include remote `Data Analyst` roles
- Joins job postings with skill mapping data
- Counts how many times each skill appears in the filtered postings
- Groups the results by job title and skill name
- Sorts skills by demand from highest to lowest
- Returns the top 5 most in-demand skills

### Insights

The results show that `SQL` is by far the most in-demand skill for remote Data Analyst roles, appearing in `7,291` job postings. It leads by a large margin, which confirms that querying and working with structured data remains the most essential capability in the analytics job market.

Behind SQL, the next most requested skills are `Excel`, `Python`, `Tableau`, and `Power BI`. This shows that employers are looking for a blend of spreadsheet analysis, programming, and data visualization skills. In other words, strong Data Analysts are expected not only to extract and manipulate data, but also to analyze it, communicate it clearly, and support decision-making through reporting tools.

### Horizontal Bar Graph
![alt text](image-2.png)

## 4. Which skills are associated with the highest salaries in Data Analyst roles?

This analysis focuses on identifying the skills linked to the highest average salaries in Data Analyst job postings. Unlike the demand analysis, this question is not about how often a skill appears. Instead, it looks at the average salary attached to each skill to understand which tools and technologies are associated with stronger financial outcomes.

To answer this, I joined the job postings table with the skills mapping table and the skills dimension table. I then filtered the data for `Data Analyst` roles where salary information was available and where the job was work-from-home. After that, I grouped the results by skill and calculated the average yearly salary for each one. Finally, I sorted the skills from the highest average salary to the lowest and returned the top 25 results.

### SQL Query

```sql
SELECT
    skills,
    ROUND(AVG(j.salary_year_avg)) AS avg_salary
FROM job_postings_fact AS j
JOIN skills_job_dim AS sjd 
    ON j.job_id = sjd.job_id
JOIN skills_dim AS sd 
    ON sjd.skill_id = sd.skill_id
WHERE
    job_title_short = 'Data Analyst' AND
    salary_year_avg IS NOT NULL AND
    job_work_from_home = TRUE
GROUP BY 
    sd.skills
ORDER BY 
    avg_salary DESC
LIMIT 25;
```
### What this query does

- Filters the dataset to only include `Data Analyst` roles
- Keeps only records with a non-null salary
- Restricts the analysis to work-from-home roles
- Joins job postings with skill mapping data
- Calculates the average salary associated with each skill
- Sorts the skills from highest-paying to lowest-paying
- Returns the top 25 highest-paying skills

### Insights

The results show that `PySpark` is associated with the highest average salary at `$208,172`, followed by `Bitbucket` at `$189,155`. Other high-paying skills include `Couchbase`, `Watson`, `DataRobot`, `GitLab`, `Jupyter`, `Pandas`, and `Databricks`. A clear pattern here is that many of the top-paying skills are not basic reporting tools. Instead, they are tied to big data processing, machine learning workflows, cloud platforms, and development environments.

This suggests that the highest salaries in Data Analyst roles are often connected to more advanced technical capabilities. While foundational tools like SQL, Excel, and Tableau are essential for entering and growing in the field, premium salaries tend to appear in roles that overlap with data engineering, machine learning, and platform-oriented analytics work. In other words, the more a Data Analyst can operate beyond basic reporting and into scalable data systems, the greater the earning potential.

### Horizontal Bar Graph
![alt text](image-3.png)

## 5. Which skills should I learn first for the best career return?

This analysis combines the results of skill demand and salary data to identify the best skills to learn for career growth as a Data Analyst. Instead of looking only at the most requested skills or only at the highest-paying skills, this query focuses on skills that offer a strong balance of both demand and earning potential.

To answer this, I created two Common Table Expressions. The first one, `skills_demand`, counts how often each skill appears in Data Analyst job postings where the location is listed as `Anywhere`. The second one, `average_salary`, calculates the average salary associated with each skill for Data Analyst roles with known salaries that are also work-from-home. I then joined these two results using `skill_id`, filtered for skills with demand above 10 postings, and sorted the final output by average salary first and demand second.

### SQL Query

```sql
WITH skills_demand AS (
    SELECT
        job_title_short,
        sd.skill_id,
        skills,
        COUNT(skills) AS count_skills
    FROM job_postings_fact AS j
    JOIN skills_job_dim AS sjd 
        ON j.job_id = sjd.job_id
    JOIN skills_dim AS sd 
        ON sjd.skill_id = sd.skill_id
    WHERE 
        job_title_short = 'Data Analyst' 
        AND j.job_location = 'Anywhere'
    GROUP BY 
        job_title_short, 
        skills, 
        sd.skill_id
),
average_salary AS (
    SELECT
        sd.skill_id,
        skills,
        ROUND(AVG(j.salary_year_avg)) AS avg_salary
    FROM job_postings_fact AS j
    JOIN skills_job_dim AS sjd 
        ON j.job_id = sjd.job_id
    JOIN skills_dim AS sd 
        ON sjd.skill_id = sd.skill_id
    WHERE   
        job_title_short = 'Data Analyst' AND 
        salary_year_avg IS NOT NULL AND
        job_work_from_home = TRUE
    GROUP BY 
        sd.skills, 
        sd.skill_id
)

SELECT
    skills_demand.skills,
    skills_demand.count_skills,
    average_salary.avg_salary
FROM skills_demand
JOIN average_salary 
    ON skills_demand.skill_id = average_salary.skill_id
WHERE 
    skills_demand.count_skills > 10
ORDER BY
    average_salary.avg_salary DESC,
    skills_demand.count_skills DESC
LIMIT 25;
```

### What this query does

- Creates one result set for skill demand
- Creates another result set for average salary by skill
- Joins both result sets using `skill_id`
- Filters out skills with very low demand
- Ranks skills by salary first and demand second
- Returns the top 25 skills with the best mix of demand and pay

### Insights

The results show that `PySpark` stands out as the strongest skill overall, combining a high average salary of `$208,172` with demand across `111` postings. Other strong skills include `Pandas`, `Databricks`, `Airflow`, `PostgreSQL`, `GCP`, and `Hadoop`, all of which appear with a solid combination of demand and salary. These are especially valuable because they are not only well paid, but also requested often enough to make them practical learning investments.

Another important takeaway is that many of the best-return skills go beyond traditional dashboarding and reporting. While tools like SQL, Excel, Tableau, and Power BI are essential for core Data Analyst work, this query shows that skills tied to data engineering, cloud systems, and machine learning workflows tend to provide stronger long-term career upside. This means that once the fundamentals are in place, expanding into tools like `PySpark`, `Databricks`, `Airflow`, and `GCP` can provide better returns in both job opportunities and salary growth.

### Horizontal Bar Graph
![alt text](image-4.png)

# What I Learned

This project helped me understand how SQL can be used not just to query data, but to answer practical career questions with real market evidence. By working through multiple business-focused questions, I improved my ability to use filtering, joins, aggregations, sorting, and Common Table Expressions to extract meaningful insights from a large dataset.

From the job market perspective, I learned that `SQL` is the most important core skill for Data Analyst roles because it appears consistently in both high-paying and high-demand job postings. I also learned that tools like `Python`, `Tableau`, `Excel`, and `Power BI` remain highly valuable, but higher salary potential often comes from expanding into more advanced areas such as `PySpark`, `Databricks`, `Airflow`, `GCP`, and other data engineering or cloud-related tools. This showed me that the best career path is to build a strong foundation in core analytics skills first and then move into more technical tools for stronger long-term growth.

# Conclusion

This project showed that the Data Analyst job market rewards a combination of strong fundamentals and broader technical capability. Core tools such as `SQL`, `Excel`, `Python`, `Tableau`, and `Power BI` continue to drive demand across the market, making them essential skills for anyone entering or growing in this field. At the same time, the salary analysis showed that more advanced tools linked to big data, cloud systems, and machine learning workflows are often associated with higher-paying opportunities.

Overall, the analysis makes one thing clear: the best career return does not come from learning only the most popular tools or only the highest-paying tools in isolation. It comes from building a balanced skill set that combines market demand with salary potential. For aspiring Data Analysts, this means starting with the core analytics stack and then strategically expanding into tools like `PySpark`, `Databricks`, `Airflow`, and `GCP` to strengthen both job prospects and long-term earning potential.