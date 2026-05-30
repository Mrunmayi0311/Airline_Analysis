/*
==============================================
 High Cloud Airline Dashboard Analysis Queries
 Created By: Mrunmayi Moraskar

==============================================
*/

create database project;
Use maindata;
select * from maindata;
ALTER TABLE Maindata CHANGE `Month (#)` Month INT;
ALTER TABLE Maindata CHANGE `# Available Seats` Available_Seats INT;
ALTER TABLE Maindata CHANGE`# Transported Passengers` Transported_Passengers INT;
ALTER TABLE Maindata CHANGE `Carrier Name` Carrier_Name varchar(100);
ALTER TABLE Maindata CHANGE `# Departures Scheduled` Departures_Scheduled INT;
ALTER TABLE Maindata CHANGE `# Departures Performed` Departures_Performed INT;
ALTER TABLE Maindata CHANGE `From - To City` From_To_City varchar(100);
ALTER TABLE Maindata CHANGE `%Distance Group ID` Distance_group_ID INT;
ALTER TABLE Maindata CHANGE `%Airline ID` Airline_ID INT;

## Q1- Getting Date Field
ALTER TABLE Maindata ADD COLUMN Date_Field DATE;

SET SQL_SAFE_UPDATES = 0;

UPDATE Maindata SET Date_Field = 
STR_TO_DATE(CONCAT(Year, '-', LPAD(Month, 2, '0'), '-', LPAD(Day, 2, '0')), '%Y-%m-%d');

## Q1.A. Year
SELECT Year(Date_Field) as Year FROM Maindata;

## Q1.B. Month No
 SELECT Month(Date_Field) as Monthno FROM Maindata;

## Q1.C Month Name
SELECT MONTHNAME(Date_Field) As Monthfullname From Maindata;

## Q1.D Quarter
 SELECT CONCAT('Q', QUARTER(Date_Field)) as Quarter FROM Maindata;

## Q1.E YearMonth ( YYYY-MMM)
SELECT DATE_FORMAT(Date_Field,'%Y-%b') as YearMonth FROM Maindata;

##Q1.F Weekdayno
SELECT DAYOFWEEK(Date_Field) as Weekdayno FROM Maindata;

##Q1.G Weekdayname
SELECT DAYNAME(Date_Field) as Weekdayname FROM Maindata;

##Q1.H FinancialMOnth
SELECT
CASE
    WHEN MONTH(Date_Field) >= 4 THEN MONTH(Date_Field) - 3
    ELSE MONTH(Date_Field) + 9
  END AS FinancialMonth
FROM Maindata;

##Q1.I Financial Quarter 
SELECT
  CASE
    WHEN MONTH(Date_Field) BETWEEN 4 AND 6 THEN 'Q1'
    WHEN MONTH(Date_Field) BETWEEN 7 AND 9 THEN 'Q2'
    WHEN MONTH(Date_Field) BETWEEN 10 AND 12 THEN 'Q3'
    ELSE 'Q4'
  END AS FinancialQuarter
FROM Maindata;

-------------------------------------------------------------------------------------------------------------------------------------------
## 2. Find the load Factor percentage on a yearly , Quarterly , Monthly basis ( Transported passengers / Available seats)

## Load Factor percentage on a yearly Basis

SELECT 
    YEAR(Date_Field) AS Year,
    ROUND(
        SUM(Transported_Passengers) / SUM(Available_Seats) * 100,
        2
    ) AS Load_Factor_Percentage
FROM Maindata
GROUP BY YEAR(Date_Field)
ORDER BY Year;

## Load Factor percentage on a Quarterly Basis

SELECT 
    CONCAT('Q', QUARTER(Date_Field)) as Quarter,
    ROUND(
        SUM(Transported_Passengers) / SUM(Available_Seats) * 100,
        2
    ) AS Load_Factor_Percentage
FROM Maindata
GROUP BY Quarter
ORDER BY Quarter;

## Load Factor percentage on a Monthly Basis

SELECT 
    MONTHNAME(Date_Field) as MONTH_NAME,
    ROUND(
        SUM(Transported_Passengers) / SUM(Available_Seats) * 100,
        2
    ) AS Load_Factor_Percentage
FROM Maindata
GROUP BY MONTH_NAME
ORDER BY MONTH_NAME;

-------------------------------------------------------------------------------------------------------------------------------------------

## 3. Find the load Factor percentage on a Carrier Name basis ( Transported passengers / Available seats)

SELECT 
     Carrier_Name,
    ROUND(
        SUM(Transported_Passengers) / SUM(Available_Seats) * 100,
        2
    ) AS Load_Factor_Percentage
FROM Maindata
GROUP BY Carrier_Name
ORDER BY Load_Factor_Percentage Desc
limit 10;

-------------------------------------------------------------------------------------------------------------------------------------------
## 4. Identify Top 10 Carrier Names based passengers preference 

SELECT 
     Carrier_Name,
count(Transported_Passengers) AS Transported_Passengers
FROM Maindata
GROUP BY Carrier_Name
ORDER BY Transported_Passengers Desc
limit 10;
-------------------------------------------------------------------------------------------------------------------------------------------

## 5. Display top Routes ( from-to City) based on Number of Flights 

SELECT 
     From_To_City,
count(Airline_ID) As No_of_Flights
FROM Maindata
GROUP BY From_To_City
ORDER BY No_of_Flights Desc
limit 10;

-------------------------------------------------------------------------------------------------------------------------------------------

## 6. Identify the how much load factor is occupied on Weekend vs Weekdays.

SELECT
    CASE WHEN DAYOFWEEK(Date_Field) IN (1, 7) THEN 'Weekend'
        ELSE 'Weekday'
    END AS Day_Type,
  ROUND((SUM(Transported_Passengers) / SUM(Available_Seats)) * 100,2) AS Load_Factor_percentage
FROM Maindata GROUP BY Day_Type;

-------------------------------------------------------------------------------------------------------------------------------------------
## 7. Identify number of flights based on Distance group

SELECT 
     Distance_group_ID,
count(Airline_ID) As No_of_Flights
FROM Maindata
GROUP BY Distance_group_ID
ORDER BY Distance_group_ID 
limit 10;

    