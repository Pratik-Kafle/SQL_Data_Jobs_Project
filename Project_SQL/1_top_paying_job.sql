/*
Question: What are the top-paying data analyst jobs?
- Identify the top 10 highest-paying Data Analyst roles.
- Why? Highlight the top-paying opportunities for Data Analysts, offering insights into employment options and location flexibility.
*/

SELECT
    job_title_short,
	job_title,
	job_location,
	job_schedule_type,
	salary_year_avg,
	job_posted_date::DATE,
    name AS company_name
FROM
    job_postings_fact AS jobs
INNER JOIN company_dim AS company
    ON jobs.company_id = company.company_id
WHERE
    job_title_short='Data Analyst' AND
    salary_year_avg IS NOT NULL
ORDER BY salary_year_avg DESC
LIMIT 10
;