# COVID-19 Data Exploration using SQL

## Project Overview
A comprehensive SQL-based analysis of COVID-19 data exploring global pandemic trends, including death rates, infection patterns, and vaccination progress across different geographical regions.

## Dataset
The analysis uses two primary datasets:
- `CovidDeaths`: Contains data about deaths, cases, and population
- `CovidVaccinations`: Contains vaccination-related statistics

## Analysis Features

### Death Rate Analysis
- Total cases vs total deaths
- Death percentage by location
- Specific country analysis (US, India, etc.)
- Population impact assessment

### Infection Rate Analysis
- Cases vs population ratio
- Country-wise infection rates
- Highest infection rates globally

### Geographical Insights
- Continent-based analysis
- Country-specific trends
- Population-weighted metrics

### Vaccination Progress
- Daily vaccination tracking
- Population vs vaccination rates
- Rolling vaccination counts

## Technical Implementation
### SQL Techniques Used:
- Joins (for combining death and vaccination data)
- CTEs (Common Table Expressions)
- Window Functions (for running totals)
- Aggregate Functions
- Type Casting
- Pattern Matching

### Example Queries
```sql
-- Death Percentage Calculation
SELECT Location, date, total_cases, total_deaths,
    (total_deaths/total_cases)*100 as death_percentage 
FROM CovidDeaths
ORDER BY 1,2

-- Vaccination Progress
WITH PopvsVac AS
(
    SELECT dea.continent, dea.location, dea.date, dea.population,
           vac.new_vaccinations,
           SUM(CONVERT(int,vac.new_vaccinations)) 
           OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) 
           as rolling_people_vaccinated
    FROM CovidDeaths dea 
    JOIN CovidVaccinations vac
        ON dea.location = vac.location
        AND dea.date = vac.date
    WHERE dea.continent is not null
)
```

## Setup Instructions
1. Download the COVID deaths and vaccinations datasets
2. Create a new database named 'covidproject'
3. Import the CSV files into respective tables
4. Execute the SQL queries in the provided order

## Prerequisites
- SQL Server Management Studio
- Basic SQL knowledge
- Microsoft Excel (for viewing raw data)

## How to Run
1. Clone this repository
2. Set up the database using provided scripts
3. Execute queries in sequence
4. Analyze results

## Future Enhancements
- Add data visualizations
- Include more recent data
- Add regional analysis
- Implement automated updates

## Contributing
Feel free to fork this project and submit pull requests.
