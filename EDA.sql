/* 
=============================================================================
Project: Tech Company Layoffs - Exploratory Data Analysis (EDA)
Author: Raghad
Tool used: MySQL
Description: This script explores the cleaned dataset to uncover layoff trends, 
             rolling totals, and top impacted companies and industries.
=============================================================================
*/

-- =======================================================================
-- Basic EDA: Overall Metrics
-- =======================================================================

-- Q1: What is the maximum number of layoffs and highest percentage laid off at once?
SELECT 
	MAX(total_laid_off) AS max_laid_off, 
    MAX(percentage_laid_off) AS max_percentage
FROM staging_layoffs2;

-- Q2: What is the date range of this dataset?
SELECT 
    MIN(`date`) AS start_date, 
    MAX(`date`) AS end_date
FROM staging_layoffs2;

-- =======================================================================
-- Aggregate EDA: Layoffs by Dimensions
-- =======================================================================

-- Q3: Which companies had the most total layoffs?
SELECT 
	company, 
    SUM(total_laid_off) AS total_layoffs
FROM staging_layoffs2
GROUP BY company
ORDER BY 2 DESC;

-- Q4: Which industries were hit the hardest by layoffs?
SELECT 
	industry, 
    SUM(total_laid_off) AS total_layoffs
FROM staging_layoffs2
GROUP BY industry
ORDER BY 2 DESC;

-- Q5: What is the distribution of layoffs across different funding stages?
SELECT 
	stage,
    SUM(total_laid_off) AS total_layoffs
FROM staging_layoffs2
GROUP BY stage
ORDER BY 1 DESC;

-- =======================================================================
-- Advanced EDA: Time Series & Ranking (CTEs & Window Functions)
-- =======================================================================

-- Q6: How many total layoffs occurred per year?
SELECT 
	YEAR(`date`) AS `year`,
    SUM(total_laid_off) AS total_layoffs
FROM staging_layoffs2
GROUP BY YEAR(`date`)
ORDER BY 1 DESC;
    
-- Q7: What is the rolling total of layoffs month by month? (Trend Analysis)
WITH Rolling_Total AS (
    SELECT 
        SUBSTRING(`date`, 1, 7) AS `month`, 
        SUM(total_laid_off) AS total_off
    FROM staging_layoffs2
    WHERE SUBSTRING(`date`, 1, 7) IS NOT NULL
    GROUP BY `month`
    ORDER BY 1 ASC
)
SELECT 
    `month`, 
    total_off,
    SUM(total_off) OVER(ORDER BY `month`) AS rolling_total_layoffs
FROM Rolling_Total;

-- Q8: What are the top 3 companies with the most layoffs in each year?
WITH Company_Year AS (
    SELECT 
        company, 
        YEAR(`date`) AS `year`, 
        SUM(total_laid_off) AS total_laid_off
    FROM staging_layoffs2
    GROUP BY company, YEAR(`date`)
), Company_Year_Rank AS (
    SELECT 
        *, 
        DENSE_RANK() OVER(PARTITION BY `year` ORDER BY total_laid_off DESC) AS ranking
    FROM Company_Year
    WHERE `year` IS NOT NULL
)
SELECT *
FROM Company_Year_Rank
WHERE ranking <= 3;