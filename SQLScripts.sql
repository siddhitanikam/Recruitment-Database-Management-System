TESTING
VIEWS

 
--1. Write a view named InterviewReimbursements that returns six columns: InterviewID, ReimbursementID, RequestName, RequestedAmt, ProcessedAmt, IsProcessed. Then, write a SELECT statement that returns all the columns in the view. The view will return reimbursements done against every interview. 

USE Recruitment
GO

CREATE VIEW InterviewReimbursements AS
SELECT i.InterviewID, r.ReimbursementID, rt.RequestName, r.RequestedAmt, r.ProcessedAmt, r.IsProcessed
FROM Interviews i LEFT JOIN Reimbursement r ON i.InterviewID = r.InterviewID LEFT JOIN ReimbursementType rt ON r.RequestTypeID = rt.RequestTypeID;


select * from InterviewReimbursements; 
--2.	Write a view named InterviewCount that returns two columns: InterviewerID, TotalNoOfInterviews. This will give no of interviews taken by each interviewer Then, write a SELECT statement that returns all the columns in the view. Show the top 2 interviewers who have taken max number of interviews.

USE Recruitment
GO

CREATE VIEW InterviewCount AS
SELECT ir.InterviewerID, count(i.InterviewID) as TotalNoOfInterviews
FROM Interviewer ir LEFT JOIN InterviewerMapping im ON ir.InterviewerID = im.InterviewerID JOIN Interviews i ON im.InterviewID = i.InterviewID 
GROUP BY ir.InterviewerID;

SELECT TOP 2 InterviewerID, TotalNoOfInterviews FROM InterviewCount ORDER BY TotalNoOfInterviews DESC;

 
--3.	Write a view named ApplicationComplaintsRaised that returns application against which complaints were raised. Show the applications for which the complaints are raised also show the complaint details.

USE Recruitment
GO

CREATE VIEW ApplicationComplaintsRaised AS
SELECT a.ApplicationID, c.ComplaintID, c.Description, c.Status
FROM Applications a LEFT JOIN Complaint c ON a.ApplicationID = c.ApplicationID
WHERE c.ComplaintID is NOT NULL

SELECT * FROM ApplicationComplaintsRaised;
 
--4.	Write a view named ApplicationsReceived that returns applications which are received by the company(applicants having applied status). Show the applications and the candidates’ details with the order of their applications(First Come First Serve basis).

USE Recruitment
GO

CREATE VIEW ApplicationsReceived AS
SELECT a.ApplicationID, c.CandidateID, c.CandidateName, c.ShortProfile, a.ApplicationStatus, a.LastUpdateDate
FROM Applications a LEFT JOIN Candidates c ON a.CandidateID = c.CandidateID
WHERE lower(a.ApplicationStatus) = 'applied';

SELECT * FROM ApplicationsReceived ORDER BY LastUpdateDate ASC;
 

--STORED PROCEDURES
 
--1.	Create a stored procedure named interviewsCount that accepts three parameters. The procedure should return a result set consisting of Number of interviews taken by given interviewer between provided date range. 
Interviewer with ID 1 has taken total 4 interviews but only 3 lie within the given date range.
Query :
CREATE PROC interviewsCount
@InterviewerID int,
@DateMin datetime2,
@DateMax datetime2
AS

SELECT i.InterviewerID, COUNT(ins.InterviewID) as CountOfInterviews
FROM Interviewer i LEFT JOIN InterviewerMapping im on i.InterviewerID = im.InterviewerID LEFT JOIN Interviews ins ON im.InterviewID = ins.InterviewID
WHERE ins.StartTime > @DateMin 
	and ins.EndTime < @DateMax
	and i.InterviewerID = @InterviewerID
GROUP BY i.InterviewerID
;


EXEC interviewsCount 1, '2022-12-10 01:00:00', '2022-12-11 12:00:00'; 

--2.	Create a stored procedure named spCountApplication that accepts status. The procedure should return a result set consisting of Number of candidates having the given status.Database has 5 applicants with applied status.

CREATE PROC spCountApplication
@Status varchar(25) = NULL
AS
IF @Status IS NULL 
SET @Status = ' '
DECLARE @CountCandidates int = 0
IF @CountCandidates =0 
SELECT @CountCandidates = COUNT(*) FROM Applications WHERE ApplicationStatus= @Status
SELECT @Status AS ApplicationStatus, @CountCandidates AS NoOfApplications;

EXEC spCountApplication @Status = 'applied';	 

--3.	Create a stored procedure named spReimbursementsDone that accepts processedAmt. The procedure should return a result set consisting of processed Reimbursements which have greater value than the provided one.


CREATE PROC spReimbursementsDone
@ProcessedAmt money NULL
AS
IF @ProcessedAmt =0 
SELECT @ProcessedAmt = MIN(ProcessedAmt) FROM Reimbursement WHERE IsProcessed= 1
SELECT ReimbursementID, rt.RequestName, r.ProcessedAmt, r.RequestedAmt FROM Reimbursement r JOIN ReimbursementType rt ON r.RequestTypeID = rt.RequestTypeID
where ProcessedAmt > @ProcessedAmt;


EXEC spReimbursementsDone 0;

 

--4.	Create a stored procedure named candidatesRejected which lists down all the candidates who are rejected at any stage.
--Procedure with no parameters passed. Just listing down candidates having rejected/waiting status.

CREATE PROC candidatesRejected
AS
SELECT c.CandidateID,ap.ApplicationID, CandidateName, ap.ApplicationStatus, ap.LastUpdateDate
FROM Candidates c LEFT JOIN Applications ap ON c.CandidateID = ap.CandidateID
WHERE lower(ApplicationStatus) IN('rejected', 'waiting');


EXEC candidatesRejected;

 

--USER DEFINED FUNCTIONS

--1.	Create a scalar-valued function named fnPassedTestEarly that returns the TestID of the test with passed grades and which was finished earliest of all. 

CREATE FUNCTION fnPassedTestEarly()
RETURNS INT
BEGIN
RETURN
(SELECT TestID
FROM Tests
WHERE lower(Grades) = 'passed'
ORDER BY EndTime asc
OFFSET 0 ROWS
FETCH FIRST 1 ROWS ONLY);
END


SELECT i.ApplicationID,i.ApplicationID,i.RemarkID,i.Type,i.Result 
FROM TESTS t JOIN Interviews i ON t.InterviewID = i.InterviewID
WHERE t.TestID = dbo.fnPassedTestEarly();
 

--2.	Create a scalar-valued function named fnPassedTestEarly that returns the latest rejected candidate. 


CREATE FUNCTION fnRejectedCandidates1()
RETURNS INT
BEGIN
RETURN
(SELECT CandidateID
FROM Applications ap
WHERE lower(ApplicationStatus) IN('rejected', 'waiting')
ORDER BY LastUpdateDate DESC
OFFSET 0 ROWS
FETCH FIRST 1 ROWS ONLY);
END

SELECT * FROM Candidates
WHERE CandidateID = dbo.fnRejectedCandidates1();
 

--3.	Create a scalar-valued function named fnInterviewsByInterviewer similar to stored procedure - interviewsCount.  The result should display the interviews taken by interviewer between the date range.

CREATE FUNCTION fnInterviewsByInterviewer(@InterviewerID int, @DateMin datetime2,
@DateMax datetime2)
RETURNS TABLE

RETURN
(SELECT i.InterviewerID, COUNT(ins.InterviewID) as CountOfInterviews
FROM Interviewer i LEFT JOIN InterviewerMapping im on i.InterviewerID = im.InterviewerID LEFT JOIN Interviews ins ON im.InterviewID = ins.InterviewID
WHERE ins.StartTime > @DateMin 
	and ins.EndTime < @DateMax
	and i.InterviewerID = @InterviewerID
GROUP BY i.InterviewerID)
;


SELECT *
FROM dbo.fnInterviewsByInterviewer(1,'2022-12-10 01:00:00', '2022-12-11 12:00:00');

 
--4.	Create a scalar-valued function named fnOffersByCandidate which will show the candidate’s information, who has received the offer

CREATE FUNCTION fnOffersByCandidate (@CandidateID int = 0)
RETURNS TABLE
RETURN
(SELECT c.CandidateID, c.CandidateName, c.ShortProfile, o.OfferStatus
FROM Candidates c JOIN Offers o ON c.CandidateID = o.CandidateID
WHERE c.CandidateID = @CandidateID);

SELECT * FROM dbo.fnOffersByCandidate(5); 

--TRANSACTIONS:
--1.	Write a set of action queries coded as a transaction to change status of an application to onboarding as we get entry in Onboarding table. Use SELECT statement to verify the results.

BEGIN TRAN

INSERT INTO Onboarding VALUES 
(6,3,dateadd(w,-20 ,GETDATE()))

UPDATE Applications SET ApplicationStatus = 'Onboarding' WHERE CandidateID = 6 and 
JobOpeningID = (SELECT JobOpeningID FROM JobOpenings WHERE JobID=3)

COMMIT TRAN

SELECT * FROM OnBoarding
SELECT * FROM Applications
 

--2.	Write a set of action queries coded as a transaction to move rows from the Reimbursement table to the ReimbursementArchive table. Insert all processed reimbursements from Reimbursement into ReimbursementArchive. Then, delete all processed reimbursements from the Reimbursement table, but only if the invoice exists in the ReimbursementArchive table. Use SELECT statement to verify the results.
CREATE TABLE ReimbursementArchive(
	ReimbursementID int,
	InterviewID int,
	RequestTypeID int,
	RequestedAmt money,
	ProcessedAmt money,
	ReceiptLink varchar(200),
	IsProcessed varchar(200)
	)
GO

BEGIN TRAN

INSERT INTO ReimbursementArchive
SELECT r.*
FROM Reimbursement r
WHERE IsProcessed = 1;

DELETE FROM Reimbursement 
WHERE ReimbursementID IN(SELECT ReimbursementID FROM ReimbursementArchive);

COMMIT TRAN;
SELECT * FROM Reimbursement;

SELECT * FROM ReimbursementArchive;
 
--3.	Write a set of action queries coded as a transaction to change status of an application to onboarding as we get entry in Onboarding table. Use SELECT statement to verify the results.

BEGIN TRAN
INSERT INTO Complaint VALUES (7, 'Very rude behavior from interviewer', 'Under Review');

UPDATE Applications
SET ApplicationStatus = 'waiting'
WHERE ApplicationID = 7;

COMMIT TRAN;

SELECT * FROM Complaint
SELECT * FROM Applications
 

--4.	Write a set of action queries coded as a transaction to change medium of an job to online.

BEGIN TRAN
	
UPDATE Job SET Medium = 'online' WHERE JobID IN (SELECT DISTINCT JobID FROM JobOpenings) 

COMMIT TRAN;

SELECT * FROM Job JOIN JobOpenings ON Job.JobID = JobOpenings.JobID;

 
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
 


--TRIGGERS
 
--1.	Write a trigger on database so that whenever a new table is created, the trigger will generate a message indicating the same.

CREATE TRIGGER RecruitmentDB_CreateTable
ON DATABASE
AFTER CREATE_TABLE
AS
DECLARE @EventData xml;
SELECT @EventData = EVENTDATA();
DECLARE @EventType varchar(100);
SET @EventType =
@EventData.value('(/EVENT_INSTANCE/EventType)[1]',
'varchar(100)');
IF @EventType = 'CREATE_TABLE'
PRINT 'A new table has been created.';

PRINT CONVERT(varchar(max), @EventData);

USE Recruitment
GO
CREATE TABLE Onboarded_candidate
(OnboardingID int NOT NULL PRIMARY KEY,
CandidateFirstName varchar(50) NOT NULL,
CandidateLastName varchar(50),
StartDate datetime2 NOT NULL);
 

--2.	Write a trigger on database so that whenever a table is dropped, the trigger will generate a message indicating the same.

CREATE TRIGGER Recruitment_DropTable
ON DATABASE
AFTER DROP_TABLE
AS
DECLARE @EventData xml;
SELECT @EventData = EVENTDATA();
DECLARE @EventType varchar(100);
SET @EventType =
@EventData.value('(/EVENT_INSTANCE/EventType)[1]',
'varchar(100)');
IF @EventType = 'DROP_TABLE'
PRINT 'A table has been dropped.';
PRINT CONVERT(varchar(max), @EventData);

USE Recruitment
GO
DROP TABLE Onboarded_candidate
 

--3.	Write A Trigger to update the application status of the application for which complaint is raised. On update/insert in complaint table, application status will change in applications table.

Use Recruitment
GO
CREATE TRIGGER ComplaintInserts
ON Complaint
AFTER INSERT
AS
UPDATE Applications
SET ApplicationStatus = 'waiting'
WHERE ApplicationID IN (SELECT ApplicationID FROM Complaint WHERE ComplaintID = (SELECT MAX(ComplaintID) FROM Complaint));


INSERT INTO Complaint VALUES 
(2,'Very tough questions and rude behavior from interviewer', 'Under Review')

 
 


--4.	Write a trigger on Onboarding table so that whenever there is a new entry in onboarding table for a candidate application status for that jobid in the applications table will change to ‘Onboarding’.

CREATE TRIGGER OnboardingInsert3
ON Onboarding
AFTER INSERT
AS
UPDATE Applications
SET ApplicationStatus = 'Onboarding'
WHERE JobOpeningID IN
(SELECT JobOpeningID FROM JobOpenings WHERE JobID = (SELECT JobID FROM inserted) AND CandidateID = (SELECT CandidateID FROM inserted));

INSERT INTO Onboarding VALUES 
(6,3,dateadd(w,-20 ,GETDATE()));

SELECT * FROM Applications;
SELECT * from Onboarding;
 










