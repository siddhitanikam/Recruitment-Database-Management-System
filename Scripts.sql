
--SCRIPTS
--1.	Write a script that declares and sets a variable named @TotalReimbursementProcessed, which is equal to the total processed amount. What is the datatype of the variable @ TotalReimbursementProcessed? If that total processed amount is less than $500, the script should return a result set consisting of InterviewID , TotalProcessedAmt  for each. Then also return the value of @ TotalReimbursementProcessed in the format of “Total reimbursement amount processed ...”. If the total outstanding balance due is more than $500, the script should return the message “'Total reimbursement amount processed for an interview is more than $500”. 

USE Recruitment;
DECLARE @TotalReimbursementProcessed money;
IF @TotalReimbursementProcessed < 500
BEGIN	
	PRINT 'Total reimbursement amount processed for an interview'+ CONVERT(varchar,@TotalReimbursementProcessed,1);
	SELECT InterviewID, SUM(ProcessedAmt) as TotalProcessedAmt
	FROM Reimbursement r
	WHERE IsProcessed = 1
	GROUP BY InterviewID;
END
ELSE
	PRINT 'Total reimbursement amount processed for an interview is more than $500';

 

--2.	Write a script that generates the date on which the candidate has given his last ineterview, using a view instead of a derived table. Also write the script that creates the view, then use SELECT statement to show result of the view. Make sure that your script tests for the existence of the view. The view doesn’t need to be redefined each time the script is executed.
USE Recruitment;
DECLARE @sqlstr VARCHAR(4000)
IF EXISTS(select 1 FROM SYS.VIEWS WHERE NAME ='LatestApplication')
BEGIN
	SELECT *
	FROM LatestApplication;
END
ELSE
BEGIN
	SET @sqlstr =
	'CREATE VIEW LatestApplication
	AS
	SELECT CandidateID, MAX(LastUpdateDate) AS Latest_Invoice_Date
	FROM Applications
	GROUP BY CandidateID'
	EXEC(@sqlstr)
END

 

--3.	Write a script that generates the date on which the interviewer has taken his last ineterview, using a view instead of a derived table. Also write the script that creates the view, then use SELECT statement to show result of the view. Make sure that your script tests for the existence of the view. The view doesn’t need to be redefined each time the script is executed.

DECLARE @latest VARCHAR(4000)
IF EXISTS(select 1 FROM SYS.VIEWS WHERE NAME ='LatestInterview')
BEGIN
	SELECT*
	FROM LatestInterview;
END
ELSE
BEGIN
	SET @latest =
	'CREATE VIEW LatestInterview
	AS
	SELECT InterviewerID, MAX(EndTime) AS LatestInterview
	FROM Interviews JOIN InterviewerMapping ON Interviews.InterviewID = InterviewerMapping.InterviewID
	GROUP BY InterviewerID'
	EXEC(@latest)
END

 

--4.	Write a script that uses dynamic SQL to return a single column that represents the number of rows in the first table in the current database. The script should automatically choose the table that appears first alphabetically, and it should exclude tables named dtproperties and sysdiagrams. Name the column CountOfTable, where Table is the chosen table name. Show results for AP database. 

USE Recruitment;

DECLARE @First_tab varchar(4000);
SET @First_tab =(SELECT TOP 1 name
FROM sys.tables
WHERE name <> 'dtproperties' OR name <> 'sysdiagrams'
ORDER BY name);
EXEC ('SELECT COUNT(*) AS CountOf' + @First_tab + ' FROM ' +@First_tab+';');
 