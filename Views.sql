
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
 
