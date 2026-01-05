/*
Question: What are the top skills based on salary on job posted from India?
- Look at the average salary associated with each skill for Data Analyst positions
- Why? It reveals how different skills impact salary levels for Data Analysts and 
    helps identify the most financially rewarding skills to acquire or improve
*/

SELECT
    skills,
    ROUND(AVG(salary_year_avg),0) AS avg_salary
FROM
    job_postings_fact AS jobs
INNER JOIN skills_job_dim AS skill_to_job
    ON jobs.job_id = skill_to_job.job_id
INNER JOIN skills_dim AS skills
    ON skill_to_job.skill_id = skills.skill_id
WHERE
    salary_year_avg IS NOT NULL AND
    job_title_short='Data Analyst'
    AND job_country='India'
GROUP BY
    skills
ORDER BY
    avg_salary DESC
LIMIT 25
;
