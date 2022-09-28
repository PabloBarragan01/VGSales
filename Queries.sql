--Create Table

USE [PortfolioProjects]
GO

CREATE TABLE [dbo].[VGSales](
	[Name] [varchar](100) NULL,
	[Platform] [varchar](100) NULL,
	[Year_of_Release] [smallint] NULL,
	[Genre] [varchar](100) NULL,
	[Publisher] [varchar](100) NULL,
	[NA_Sales] [float] NULL,
	[EU_Sales] [float] NULL,
	[JP_Sales] [float] NULL,
	[Other_Sales] [float] NULL,
	[Global_Sales] [float] NULL,
	[Critic_Score] [tinyint] NULL,
	[Critic_Count] [tinyint] NULL,
	[User_Score] [float] NULL,
	[User_Count] [smallint] NULL,
	[Developer] [varchar](100) NULL,
	[Rating] [varchar](100) NULL
)
GO


-- Select all columns
SELECT *
FROM [dbo].[VGSales]
GO

-- Delete games without Name or Year
DELETE
  FROM [dbo].[VGSales]
  WHERE Name IS NULL OR Year_of_Release IS NULL
  GO


-- 1. Total number of games
SELECT COUNT(*) AS Total_Games
FROM [dbo].[VGSales]
GO


-- 2. Witch year had more releases
SELECT Year_of_Release, COUNT(*) AS Total_Games
FROM [dbo].[VGSales]
GROUP BY Year_of_Release
ORDER BY Total_Games DESC
GO


-- 3. Witch genre made the most
SELECT Genre, count(*) AS Total_Games
FROM [dbo].[VGSales]
GROUP BY Genre
ORDER BY Total_Games DESC
GO


-- 4. Witch year had more sales
SELECT Year_of_Release, ROUND(SUM(Global_Sales),2) AS Total_Games_Sales
FROM [dbo].[VGSales]
GROUP BY Year_of_Release
ORDER BY Total_Games_Sales DESC
GO


-- 5. Witch genre had more sales
SELECT Genre, ROUND(SUM(Global_Sales),2) AS Total_Games_Sales
FROM [dbo].[VGSales]
GROUP BY Genre
ORDER BY Total_Games_Sales DESC
GO


-- 6. What are the most sold games
SELECT Name AS Game, ROUND(SUM(Global_Sales),2) AS Total_Games_Sales
FROM [dbo].[VGSales]
GROUP BY Name
ORDER BY Total_Games_Sales DESC
GO


-- 7. Witch console made the most
SELECT Platform, count(*) AS Total_Games
FROM [dbo].[VGSales]
GROUP BY Platform
ORDER BY Total_Games DESC
GO


-- 8. What console sold more games. Open by Region
SELECT PLatform, ROUND(SUM(NA_Sales),2) AS NorthAmerica_Sales, ROUND(SUM(EU_Sales),2) AS Europe_Sales, ROUND(SUM(JP_Sales),2) AS Japan_Sales, ROUND(SUM(Other_Sales),2) AS Other_Sales, ROUND(SUM(Global_Sales),2) AS Total_Games_Sales
FROM [dbo].[VGSales]
GROUP BY Platform
ORDER BY Total_Games_Sales DESC
GO


-- 9. What Publisher sold more games
SELECT Publisher, ROUND(SUM(Global_Sales),2) AS Total_Games_Sales
FROM [dbo].[VGSales]
GROUP BY Publisher
ORDER BY Total_Games_Sales DESC
GO


-- 10. Most sold game by Platform
WITH Sales AS
(SELECT Platform, Name, ROUND(Global_Sales,2) AS Total_Games_Sales,
	ROW_NUMBER() OVER(PARTITION BY Platform ORDER BY Global_Sales DESC) AS Sales_Platform_Rank
FROM VGSales)
SELECT *
FROM  Sales
WHERE Sales_Platform_Rank = 1
ORDER BY Total_Games_Sales DESC
GO


-- 11. Most sold game by Year
WITH Sales AS
(SELECT Year_Of_Release, Name, ROUND(Global_Sales,2) AS Total_Games_Sales,
	ROW_NUMBER() OVER(PARTITION BY Year_Of_Release ORDER BY Global_Sales DESC) AS Sales_Year_Rank
FROM VGSales)
SELECT *
FROM  Sales
WHERE Sales_Year_Rank = 1
ORDER BY Year_of_Release ASC
GO


-- 12. Top 5 Games by Genre
WITH Sales AS
(SELECT Genre, Name, ROUND(Global_Sales,2) AS Total_Games_Sales,
	ROW_NUMBER() OVER(PARTITION BY Genre ORDER BY Global_Sales DESC) AS Sales_Genre_Rank
FROM VGSales)
SELECT Genre, Name, SUM(Total_Games_Sales) AS Total_Games_Sales
FROM  Sales WHERE Sales_Genre_Rank <= 5
GROUP BY Genre, Name
ORDER BY Genre ASC, Total_Games_Sales DESC
GO


-- 13. Which genre game has been released the most in a single year
WITH Sales AS
(SELECT Year_of_Release, Genre, count(*) AS Games_Released,
	ROW_NUMBER() OVER(PARTITION BY Year_Of_Release ORDER BY count(*) DESC) AS Sales_Genre_Rank
FROM VGSales
GROUP BY Year_of_Release, Genre)
SELECT Year_of_Release, Genre, Games_Released
FROM Sales WHERE Sales_Genre_Rank = 1
GO


-- 14. Which genre game has sold the most in a single year
WITH Sales AS
(SELECT Year_of_Release, Genre, ROUND(Global_Sales,2) AS Total_Games_Sales,
	ROW_NUMBER() OVER(PARTITION BY Year_Of_Release ORDER BY Global_Sales DESC) AS Sales_Genre_Rank
FROM VGSales)
SELECT Year_of_Release, Genre, SUM(Total_Games_Sales) AS Total_Games_Sales
FROM  Sales WHERE Sales_Genre_Rank =1
GROUP BY Year_of_Release, Genre
ORDER BY Year_of_Release ASC, Total_Games_Sales DESC
GO


-- 15. Top 5 most sold games by Decade
WITH Sales AS
(SELECT FLOOR(year(CONVERT(date,CONVERT(varchar(10),Year_of_Release)))/10)*10 AS Decade, Name, ROUND(Global_Sales,2) AS Total_Games_Sales,
	ROW_NUMBER() OVER(PARTITION BY FLOOR(year(CONVERT(date,CONVERT(varchar(10),Year_of_Release)))/10)*10 ORDER BY Global_Sales DESC) AS Sales_Genre_Rank
FROM VGSales)
SELECT Decade, Name, SUM(Total_Games_Sales) AS Total_Games_Sales
FROM  Sales WHERE Sales_Genre_Rank <=5
GROUP BY Decade, Name
ORDER BY Decade ASC, Total_Games_Sales DESC
GO