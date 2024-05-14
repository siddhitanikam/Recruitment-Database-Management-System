
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