# Data Jobs Analysis
## Introduction
📊 Dive into the data job market! Focusing on data analyst roles, this project explores 💰 top-paying jobs, 🔥 in-demand skills, and 📈 where high demand meets high salary in data analytics.

🔍 SQL queries? Check them out here: [Project_SQL folder](/Project_SQL/)
Note
### The questions I wanted to answer through my SQL queries were:

1. What are the top-paying data analyst jobs?
2. What skills are required for these top-paying jobs?
3. What skills are most in demand for data analysts?
4. Which skills are associated with higher salaries?
5. What are the most optimal skills to learn?

# Tools I Used
For my deep dive into the data analyst job market, I harnessed the power of several key tools:

- **SQL:** Core tool for Quering and Analysing
- **PostgreSQL:** Database management system
- **Visual Studio Code:** Writing and executing SQL queries
- **Git & GitHub:** Version control and project sharing
### 1. Top Paying Data Analyst Jobs
To identify the highest-paying roles, I filtered data analyst positions by average yearly salary worldwide. This query highlights the high paying opportunities in the field.
```sql
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
```
Here's the breakdown of the top data analyst jobs in 2023:
- **Wide Salary Range:** Top 10 paying data analyst roles span from $285,000 to $650,000.
- **Diverse Employers:** Companies like Mantys, Illuminate solutions, Meta and Open AI are among those offering high salaries.
- **Job Title Variety:** There's a high diversity in job titles, from Data Analyst to Sr.Data Analyst, reflecting varied roles and specializations within data analytics.

![Top Paying Roles](/Images/1_top_paying_job.png)
*Bar graph visualizing the salary for the top 10 salaries for data analysts; Copilot generated this graph from my SQL query results*

### 2. Skills for Top Paying Jobs
To understand what skills are required for the top-paying jobs in India, I joined the job postings with the skills data, providing insights into what employers value for high-compensation roles.
```sql
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
```
Here's the breakdown of the most demanded skills for the top 10 highest paying data analyst jobs posted from india in 2023:
- **SQL** is leading with a bold count of 5.
- **Power BI** follows closely with a bold count of 4.
- Other skills like **Python**, **aws**, **Pandas**, and **Excel** show varying degrees of demand.
![Top_Paying_skills](/Images/2_top_paying_job_skills.jpeg)
*Bar graph visualizing the count of skills for the top 10 paying jobs for data analysts; Copilot generated this graph from my SQL query results*

### 3. In-Demand Skills for Data Analysts

This query helped identify the skills most frequently requested in job postings, directing focus to areas with high demand.
```sql
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
LIMIT 5
;
```
Here's the breakdown of the most demanded skills for data analysts in 2023:
Foundation tools like *SQL and Excel* remains critical, while *Python and Visualization tools* are increasingly imoprtant for analysis and storytelling.
| Skills   | Demand Count |
|----------|--------------|
| SQL      | 92628        |
| Excel    | 67031        |
| Python   | 57326        |
| Tableau  | 46554        |
| Power BI | 39468        |

### 4. Skills Based on Salary
Exploring the average salaries associated with different skills revealed which skills are the highest paying in India.
```sql
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
```
Here's a breakdown of the results for top paying skills for Data Analysts:
- **High‑Value Technical Skills:** PySpark, PostgreSQL, MySQL, and Linux.
- **Core Data Analyst Stack** Pandas, Matplotlib, DAX, and, Snowflake.
- **Modern Data Platforms:** Airflow, Databricks, MongoDB and, Scala.
These results show that analysts with *engineering-adjacent and cloud skills* tent to earn high salaries.

| Skills        | Average Salary ($) |
|---------------|-------------------:|
| PySpark       |            165,000 |
| GitLab        |            165,000 |
| PostgreSQL    |            165,000 |
| MySQL         |            165,000 |
| Linux         |            165,000 |
| Databricks    |            135,994 |
| MongoDB       |            135,994 |
| Scala         |            135,994 |
| Pandas        |            122,463 |
| Snowflake     |            111,213 |
| Matplotlib    |            111,175 |
| DAX           |            111,175 |
| Airflow       |            109,052 |

### 5. Most Optimal Skills to Learn

This final query combines **salary, demand, and remote-work roles** to identify the most optimal skills for data analyst to learn.

```sql
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
```
| Skills     | Demand Count | Average Salary ($)|
|------------|--------------|-------------------:|
| go         | 27           |            115,320 |
| confluence | 11           |            114,210 |
| hadoop     | 22           |            113,193 |
| snowflake  | 37           |            112,948 |
| azure      | 34           |            111,225 |
| bigquery   | 13           |            109,654 |
| aws        | 32           |            108,317 |
| java       | 17           |            106,906 |
| ssis       | 12           |            106,683 |
| jira       | 20           |            104,918 |

Here's a breakdown of the most optimal skills for Data Analysts in 2023: 
- **High-Demand Programming Languages:** SQL, Python and R stand out for their high demand, with demand counts of 398, 236 and 148 respectively. Despite their high demand, their average salaries are around $97,237 for SQL, $101,397 for Python and $100,499 for R, indicating that proficiency in these languages is highly valued but also widely available.
- **Cloud Tools and Technologies:** Skills in specialized technologies such as Snowflake, Azure, AWS, and BigQuery show significant demand with relatively high average salaries, pointing towards the growing importance of cloud platforms and big data technologies in data analysis.
- **Business Intelligence and Visualization Tools:** Tableau and Looker, with demand counts of 230 and 49 respectively, and average salaries around $99,288 and $103,795, highlight the critical role of data visualization and business intelligence in deriving actionable insights from data.
- **Database Technologies:** The demand for skills in traditional and NoSQL databases (Oracle, SQL Server, NoSQL) with average salaries ranging from $97,786 to $104,534, reflects the enduring need for data storage, retrieval, and management expertise.

# What I Learned

- **🧩 Advanced SQL Querying:** Skilled in writing complex queries, including table joins and using WITH clauses for temporary tables.
- **📊 Data Aggregation:** Experienced in applying GROUP BY with aggregate functions such as COUNT() and AVG() to summarize data effectively.
- **💡 Analytical Problem-Solving:** Able to translate business questions into clear, actionable SQL queries that deliver meaningful insights.

### Insights
From the analysis, several general insights emerged:

1. **Top-Paying Data Analyst Jobs**: The highest-paying jobs for data analysts that are posted offer a wide range of salaries, the highest at $650,000!
2. **Skills for Top-Paying Jobs**: High-paying data analyst jobs require advanced proficiency in SQL, suggesting it’s a critical skill for earning a top salary.
3. **Most In-Demand Skills**: SQL is also the most demanded skill in the data analyst job market, thus making it essential for job seekers.
4. **Skills with Higher Salaries**: Specialized skills, such as Neo4j and GDPR, are associated with the highest average salaries, indicating a premium on niche expertise.
5. **Optimal Skills for Job Market Value**: SQL leads in demand and offers for a high average salary, positioning it as one of the most optimal skills for data analysts to learn to maximize their market value.

### Closing Thoughts

This project enhanced my SQL skills and provided valuable insights into the data analyst job market. The findings from the analysis serve as a guide to prioritizing skill development and job search efforts. Aspiring data analysts can better position themselves in a competitive job market by focusing on high-demand, high-salary skills. This exploration highlights the importance of continuous learning and adaptation to emerging trends in the field of data analytics.

