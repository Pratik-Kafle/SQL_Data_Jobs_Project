/*
Question: What are the most optimal skills to learn (aka it’s in high demand and a high-paying skill)?
- Identify skills in high demand and associated with high average salaries for Data Analyst roles
- Concentrates on remote positions with specified salaries
- Why? Targets skills that offer job security (high demand) and financial benefits (high salaries), 
    offering strategic insights for career development in data analysis
*/

SELECT
    skills.skill_id,
    skills,
    COUNT(skill_to_job.skill_id) AS demand_count,
    ROUND(AVG(salary_year_avg),0) AS avg_salary
FROM
    job_postings_fact AS jobs
INNER JOIN
    skills_job_dim AS skill_to_job
    ON jobs.job_id = skill_to_job.job_id
INNER JOIN
    skills_dim AS skills
    ON skill_to_job.skill_id = skills.skill_id
WHERE
    salary_year_avg IS NOT NULL
    AND job_title_short='Data Analyst'
    AND job_work_from_home=TRUE
GROUP BY
    skills.skill_id,
    skills
HAVING
    COUNT(skill_to_job.skill_id)>10
ORDER BY
    avg_salary DESC,
    demand_count DESC
;

--Using CTE for above query since we have already got top demanded skills(Query 3) and top paying skills(Query 4)
WITH skill_demand AS
(
    SELECT
        skills.skill_id,
        skills.skills,
        COUNT(skill_to_job.job_id) AS demand_count
    FROM
        skills_job_dim AS skill_to_job
    INNER JOIN skills_dim AS skills
        ON skill_to_job.skill_id = skills.skill_id
    INNER JOIN job_postings_fact AS jobs
        ON skill_to_job.job_id = jobs.job_id
    WHERE
        salary_year_avg IS NOT NULL
        AND job_title_short='Data Analyst'
        AND job_work_from_home=TRUE
    GROUP BY
        skills.skill_id,
        skills.skills
),
average_salary AS
(
    SELECT
        skill_to_job.skill_id,
        ROUND(AVG(salary_year_avg),0) AS avg_salary
    FROM
        job_postings_fact AS jobs
    INNER JOIN skills_job_dim AS skill_to_job
        ON jobs.job_id = skill_to_job.job_id
    INNER JOIN skills_dim AS skills
        ON skill_to_job.skill_id = skills.skill_id
    WHERE
        salary_year_avg IS NOT NULL
        AND job_title_short='Data Analyst'
        AND job_work_from_home=TRUE
    GROUP BY
        skill_to_job.skill_id
)
SELECT
    skill_demand.skill_id,
    skill_demand.skills,
    demand_count,
    avg_salary
FROM
    average_salary
INNER JOIN skill_demand
    ON average_salary.skill_id = skill_demand.skill_id
WHERE demand_count>10
ORDER BY
    avg_salary DESC,
    demand_count DESC
;



