# Tech Company Layoffs: SQL Data Cleaning & EDA

Hi! This is a personal project I worked on to practice my SQL skills on a messy, real-world dataset. The focus here is on data preparation (cleaning) and basic exploratory data analysis (EDA) using MySQL.

### What's this project about?
I took a raw dataset of global tech company layoffs and went through the process of cleaning it up so it's actually usable for analysis. After standardizing the data, I wrote a few queries to see the trends—like which industries were hit the hardest and how the layoffs added up month by month.

### The Process
I split the work into two main parts:

1. **Data Cleaning (`Data Cleaning.sql`):** 
This is where the heavy lifting happened. The raw data had duplicates, weird date formats, and missing values. I used Window Functions (`ROW_NUMBER`) to safely find and remove duplicates, standardized the text and date columns, and filled in blank industry fields based on existing company data.

2. **Data Exploration (`EDA.sql`):** 
Once the data was clean, I wanted to ask it a few questions. Aside from basic `GROUP BY` aggregations, I used CTEs and `DENSE_RANK()` to find the rolling total of layoffs per month and pinpoint the top 3 companies with the most layoffs each year.

### Files in this repo
- `Data Cleaning.sql`: The script where I cleaned and prepped the data.
- `EDA.sql`: The script for querying and analyzing the clean dataset.

Feel free to check out the SQL files to see the code!
