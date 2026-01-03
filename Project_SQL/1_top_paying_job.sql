/*
Question: What are the top-paying data analyst jobs?
- Identify the top 10 highest-paying Data Analyst roles that are available in India
- Focuses on job postings with specified salaries (remove nulls)
- BONUS: Include company names of top 10 roles
- Why? Highlight the top-paying opportunities for Data Analysts, offering insights into employment options and location.
*/

SELECT
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
    job_country = 'India' AND
    salary_year_avg IS NOT NULL
ORDER BY salary_year_avg DESC
LIMIT 10
;