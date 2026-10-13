/* 
=============================================================================
Project: Tech Company Layoffs - Data Cleaning
Author: Raghad
Tool used: MySQL
Description: This script cleans and standardizes raw data regarding tech 
             company layoffs. It handles duplicates, missing values, 
             and formats text/date fields for exploratory data analysis (EDA).
=============================================================================
*/

-- =======================================================================
-- Step 1: Remove Duplicates
-- =======================================================================

-- Create a staging table to work on, preserving the original raw data
DROP TABLE IF EXISTS `staging_layoffs2`;
CREATE TABLE `staging_layoffs2` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  `REC_NUM` INT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Insert data and assign a row number to identify duplicate records
INSERT staging_layoffs2
SELECT 
	*,
	ROW_NUMBER() OVER (PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, `date`) AS row_num
FROM staging_layoffs;

-- Delete the identified duplicates
SET SQL_SAFE_UPDATES = 0;
DELETE
FROM staging_layoffs2
WHERE REC_NUM > 1;

-- =======================================================================
-- Step 2: Standardizing the Data
-- =======================================================================

-- Trim whitespace from company names
UPDATE staging_layoffs2
SET company = TRIM(company);

-- Standardize 'Crypto' industry variations into a single category
UPDATE staging_layoffs2
SET industry = 'Crypto'
WHERE industry LIKE 'Crypto%';

-- Standardize country names (e.g., removing trailing dots like 'United States.')
UPDATE staging_layoffs2
SET country = TRIM(TRAILING '.' FROM country);

-- Convert 'date' column from text to standard DATE format (YYYY-MM-DD)
UPDATE staging_layoffs2
SET `date` = STR_TO_DATE(`date`,'%m/%d/%Y');

ALTER TABLE staging_layoffs2
MODIFY COLUMN `date` DATE;

-- =======================================================================
-- Step 3: Dealing with Nulls & Blanks
-- =======================================================================

-- Populate blank industry fields based on existing data for the same companies
UPDATE staging_layoffs2
SET industry = 'Travel'
WHERE company = 'Airbnb' AND industry = '';

UPDATE staging_layoffs2
SET industry = 'Transportation'
WHERE company = 'Carvana' AND industry = '';

UPDATE staging_layoffs2
SET industry = 'Consumer'
WHERE company = 'Juul' AND industry = '';

-- =======================================================================
-- Step 4: Remove Redundant Columns and Rows
-- =======================================================================

-- Drop records where both crucial metrics are null (unusable for analysis)
DELETE
FROM staging_layoffs2
WHERE 
	total_laid_off IS NULL
	AND percentage_laid_off IS NULL;

-- Drop the row number column as it is no longer needed
ALTER TABLE staging_layoffs2
DROP COLUMN REC_NUM;