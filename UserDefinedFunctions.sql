

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
