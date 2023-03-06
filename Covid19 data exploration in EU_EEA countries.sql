
-- Initial data retrieved from European Centre for Disease Prevention and Control (ECDC)
-- Population data taken from Eurostat


-- Total Observed Cases - Fatality Ratio, Total Deaths per 100k Population as of October 27th,2022 

SELECT countriesAndTerritories,
CONCAT(ROUND(SUM(deaths)/SUM(cases)*100,2),' %') as "Observed Cases - Fatality Ratio" ,
ROUND((SUM(deaths)/popData2020)*100000,1) as "Deaths per 100k Population" 
FROM covid_cases_deaths
GROUP BY countriesAndTerritories,popData2020
ORDER BY 2 desc, 3 desc;



-- Total Vaccinations Breakdown in EU/EEA countries as of February 10th,2023

SELECT *,
 a.FirstDose_Total + a.SecondDose_Total + a.DoseAdditional1_Total + a.DoseAdditional2_Total + a.DoseAdditional3_Total + a.UnknownDose_Total as Total_Doses
 FROM
(SELECT ReportingCountry,
SUM(FirstDose) as FirstDose_Total,
SUM(SecondDose) as SecondDose_Total,
SUM(DoseAdditional1) as DoseAdditional1_Total,
SUM(DoseAdditional2) as DoseAdditional2_Total,
SUM(DoseAdditional3) as DoseAdditional3_Total,
SUM(UnknownDose) as UnknownDose_Total
FROM covid_vaccinations
WHERE TargetGroup IN ('Age>18','Age<18','AgeUNK') 
GROUP BY ReportingCountry) a; 


-- Vaccinations per Month  in EU/EEA Countries  as of February 10th,2023

-- Using a CTE  for Total Vaccinations per Month and Reporting Country

WITH Total_Vacs as 
(SELECT  dateRef,     
ReportingCountry,     
SUM(FirstDose + SecondDose + DoseAdditional1 + DoseAdditional2 + DoseAdditional3 + UnknownDose) as TotalVaccinations
FROM     
covid_vaccinations 
WHERE TargetGroup IN ('Age>18','Age<18','AgeUNK') 
GROUP BY dateRef, ReportingCountry)
 
-- Calculating the Running Total Vaccinations per Month and Reporting Country

SELECT YEAR(a.dateRef) as year_date,
MONTH(a.dateRef) as month_date, 
cd.geoId,  
cd.countriesAndTerritories, 
a.TotalVaccinations, 
SUM(a.TotalVaccinations) OVER (PARTITION BY cd.countriesAndTerritories ORDER BY YEAR(a.dateRef),MONTH(a.dateRef),a.ReportingCountry) as RunningTotalVaccinations  
FROM 
Total_Vacs a
JOIN covid_cases_deaths cd 
ON a.ReportingCountry=cd.geoId
GROUP BY 1,2,3,4,5;








