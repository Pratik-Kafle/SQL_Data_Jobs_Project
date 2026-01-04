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
    job_country = 'India' AND
    salary_year_avg IS NOT NULL
ORDER BY salary_year_avg DESC
LIMIT 10
;