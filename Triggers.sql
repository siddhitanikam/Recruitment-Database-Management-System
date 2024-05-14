
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
 