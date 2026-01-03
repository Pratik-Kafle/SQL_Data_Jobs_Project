/*
Question: What skills are required for the top-paying data analyst jobs in India?
- Add the specific skills required for these roles
- Why? It provides a detailed look at which high-paying jobs demand certain skills, 
    helping job seekers understand which skills to develop that align with top salaries
*/

WITH top_paying_job AS
(
    SELECT
        job_id,
        job_title,
        salary_year_avg,
        name AS company_name
    FROM
        job_postings_fact AS jobs
    INNER JOIN company_dim AS company
        ON jobs.company_id = company.company_id
    WHERE
        job_title_short='Data Analyst' AND
        job_country = 'India' AND
        salary_year_avg IS NOT NULL
    ORDER BY
    salary_year_avg DESC
    LIMIT 10
)
SELECT
    top_paying_job.*,
    skills
FROM
    top_paying_job
INNER JOIN skills_job_dim AS skill_to_job
    ON top_paying_job.job_id=skill_to_job.job_id
INNER JOIN skills_dim AS skill
    ON skill_to_job.skill_id = skill.skill_id
ORDER BY
    salary_year_avg DESC
;
