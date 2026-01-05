/*
Question: What are the most in-demand skills for data analysts?
- Identify the top 5 in-demand skills for a data analyst.
- Why? Retrieves the top 5 skills with the highest demand in the job market, 
    providing insights into the most valuable skills for job seekers.
*/

SELECT
    skills,
    COUNT(skill_to_job.skill_id) AS demand_count
FROM
    skills_job_dim AS skill_to_job
LEFT JOIN skills_dim AS skills
    ON skill_to_job.skill_id = skills.skill_id
LEFT JOIN job_postings_fact AS jobs
    ON skill_to_job.job_id = jobs.job_id
WHERE
    job_title_short='Data Analyst'
GROUP BY
    skills
ORDER BY
    demand_count DESC
LIMIT 5;
