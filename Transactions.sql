
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

