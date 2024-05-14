USE master
GO

IF DB_ID('Recruitment') IS NOT NULL
	DROP DATABASE Recruitment
GO

CREATE DATABASE Recruitment
GO 



USE Recruitment
GO

CREATE TABLE JobPosition(
	PositionID int IDENTITY(1,1) NOT NULL PRIMARY KEY,
	PositionTitle varchar(50) NOT NULL)
GO
     
CREATE TABLE JobCategory(
	CategoryID int IDENTITY(1,1) NOT NULL PRIMARY KEY,
	CategoryName varchar(50) NOT NULL)
GO

CREATE TABLE JobType(
	JobTypeID int IDENTITY(1,1) NOT NULL PRIMARY KEY,
	Type varchar(50) NOT NULL)
GO

CREATE TABLE Job(
	JobID int IDENTITY(1,1) NOT NULL PRIMARY KEY,
	PositionID int NOT NULL REFERENCES JobPosition (PositionID),
	CategoryID int NOT NULL REFERENCES JobCategory (CategoryID),
	JobType int NOT NULL REFERENCES JobType (JobTypeID),
	Medium varchar(10) NOT NULL,
	CONSTRAINT mediumCheck CHECK(lower(ltrim(rtrim(Medium))) IN ('online','onsite')))
GO

CREATE TABLE JobOpenings(
	JobOpeningID int IDENTITY(1,1) NOT NULL PRIMARY KEY,
	JobID int NOT NULL REFERENCES Job (JobID),
	NoOfPositions int NOT NULL)	
GO


CREATE TABLE Candidates(
	CandidateID int IDENTITY(1,1) NOT NULL PRIMARY KEY,
	CandidateName varchar(50) NOT NULL,
	Email varchar(50) NOT NULL,
	Phone varchar(20) NOT NULL,
	ShortProfile varchar(200)  NULL
)	
GO

CREATE TABLE Applications(
	ApplicationID int IDENTITY(1,1) NOT NULL PRIMARY KEY,
	JobOpeningID int NOT NULL REFERENCES JobOpenings (JobOpeningID),
	CandidateID int NOT NULL REFERENCES Candidates (CandidateID),
	ApplicationStatus varchar(50) NOT NULL,
	ApplicationStartDate dateTime2 NOT NULL,
	LastUpdateDate dateTime2 NOT NULL)
GO

CREATE TABLE Offers(
	OfferID int IDENTITY(1,1) NOT NULL PRIMARY KEY,
	CandidateID int NOT NULL REFERENCES Candidates (CandidateID),
	ApplicationID int NOT NULL REFERENCES Applications(ApplicationID),
	OfferStatus varchar(50) NOT NULL,
	CONSTRAINT OfferStatusCheck CHECK(lower(ltrim(rtrim(OfferStatus))) IN ('accepted','declined','negotiating','actionNeeded'))
)
GO

CREATE TABLE InterviewRemarks(
	RemarkID int IDENTITY(1,1) NOT NULL PRIMARY KEY,
	InterviewerRemarks varchar(200) NOT NULL,
	CandidateRemarks varchar(200) NULL)
	
GO

CREATE TABLE Interviews(
	InterviewID int IDENTITY(1,1) NOT NULL PRIMARY KEY,
	ApplicationID int NOT NULL REFERENCES Applications(ApplicationID),
	RemarkID int NOT NULL REFERENCES InterviewRemarks (RemarkID),
	StartTime dateTime2 NOT NULL,
	EndTime dateTime2 NOT NULL,
	Type varchar(10) NOT NULL,
	Result varchar(50) NOT NULL,
	CONSTRAINT TypeCheck CHECK(lower(ltrim(rtrim(Type))) IN ('online','onsite'))
	)
GO

CREATE TABLE Interviewer(
	InterviewerID int IDENTITY(1,1) NOT NULL PRIMARY KEY,
	Name varchar(50) NOT NULL,
	Department varchar(20) NOT NULL,
	Title varchar(20) NOT NULL)	
GO

CREATE TABLE InterviewerMapping(
	InterviewID int NOT NULL REFERENCES Interviews(InterviewID),
	InterviewerID int  NOT NULL REFERENCES Interviewer(InterviewerID)
	)	
GO

CREATE TABLE Tests(
	TestID int IDENTITY(1,1) NOT NULL PRIMARY KEY,
	InterviewID int NOT NULL REFERENCES Interviews(InterviewID),
	Type varchar(10) NOT NULL,
	StartTime dateTime2 NOT NULL,
	EndTime dateTime2 NOT NULL,
	Answers varchar(500) NOT NULL,
	Grades varchar(20) NOT NULL,
	CONSTRAINT TestCheck CHECK(lower(ltrim(rtrim(Type))) IN ('online','onsite')),
	CONSTRAINT GradesCheck CHECK(lower(ltrim(rtrim(Grades))) IN ('passed','failed'))
	)
GO

CREATE TABLE GraderMapping(
	InterviewerID int NOT NULL REFERENCES Interviewer(InterviewerID),
	TestID int NOT NULL REFERENCES Tests(TestID)
	)	
GO

CREATE TABLE ReimbursementType(
	RequestTypeID int IDENTITY(1,1) NOT NULL PRIMARY KEY,
	RequestName varchar(50) NOT NULL,
	StandardAmt money NOT NULL)
GO

CREATE TABLE Reimbursement(
	ReimbursementID int IDENTITY(1,1) NOT NULL PRIMARY KEY,
	InterviewID int NOT NULL REFERENCES Interviews(InterviewID),
	RequestTypeID int NOT NULL REFERENCES ReimbursementType(RequestTypeID),
	RequestedAmt money DEFAULT 0,
	ProcessedAmt money DEFAULT 0,
	ReceiptLink varchar(200) NOT NULL,
	IsProcessed varchar(200) NOT NULL
	)
GO

CREATE TABLE DocumentType(
	DocumentTypeID int IDENTITY(1,1) NOT NULL PRIMARY KEY,
	DocumentTypeName varchar(50) NOT NULL
	)
GO

CREATE TABLE Documents(
	DocumentID int IDENTITY(1,1) NOT NULL PRIMARY KEY,
	CandidateID int NOT NULL REFERENCES Candidates (CandidateID),
	DocumentTypeID int NOT NULL REFERENCES DocumentType (DocumentTypeID),
	DocumentLink varchar(200) NOT NULL
)
GO

CREATE TABLE Onboarding(
	CandidateID int NOT NULL REFERENCES Candidates(CandidateID) PRIMARY KEY,
	JobID int NOT NULL REFERENCES Job (JobID),
	StartDate dateTime2 NOT NULL
)
GO

CREATE TABLE Complaint(
	ComplaintID int IDENTITY(1,1) NOT NULL PRIMARY KEY,
	ApplicationID int NOT NULL REFERENCES Applications(ApplicationID),
	Description varchar(200) NOT NULL,
	Status varchar(50) NOT NULL
)
GO



INSERT INTO JobPosition VALUES
('IT Manager'),
('Software Developer'),
('Project Manager'),
('Team Lead'),
('Senior Software Developer'),
('Associate Developer'),
('System Engineer'),
('Business Analyst'),
('Senior Business Analyst'),
('Database Engineer'),
('Database Architect'),
('QA Analyst'),
('Cybersecurity analyst');


INSERT INTO JobCategory VALUES
('Information security'),
('QA'),
('Software development '),
('Analyst'),
('Management'),
('Database Administrator'),
('Cyber Security');

INSERT INTO JobType VALUES
('Summer Internship'), 
('Full-time Job'), 
('Part-time job'), 
('Contract-based');


INSERT INTO Job VALUES 
(9,4,3,'onsite'),
(6,3,1,'online'),
(1,5,2,'onsite'),
(10,6,4,'online'),
(3,5,2,'onsite'),
(2,3,1,'online'),
(13,7,4,'online'),
(8,4,3,'onsite'),
(5,3,2,'onsite'),
(12,2,1,'online');



INSERT INTO JobOpenings VALUES 
(1,3),
(2,5),
(3,2),
(4,1),
(5,2),
(6,3),
(7,1);

INSERT INTO Candidates VALUES 
('Siddhita Nikam','siddhita123@gmail.com','3154662586','Java Developer 5 Years Experience'),
('Jethalal Gada','jgada12@gmail.com','3157896234','Business Analyst 8 Years Experiene'),
('Aatmaram Bhide','aatmarambhide4@gmail.com','3161129882','Project manager 15 Years Experience'),
('Hansraj Hathi','hhathi6@gmail.com','3164363530','Cyber Security Engineer 2 years Experience'),
('Roshan Singh Sodhi','roshansingh43@gmail.com','3167597178','Java Developer No experience'),
('Tarak Mehta','tarakmehta_23@gmail.com','3170830826','IT Manager 3 years experience'),
('Popatlal Pande','ppande24@gmail.com','3174064474','Database Engineer no experience'),
('Babita Iyer','babitaiyer1@gmail.com','3177298122','QA Analyst 6 years experience'),
('Abdul Sheikh','abduls54@gmail.com','3180531770','Software Developer2 years experience'),
('Natwarlal Udhaiwala','natukaka45@gmail.com','3183765418','Senior Business Analyst 7 years experience');


INSERT INTO Applications VALUES
(1,1,'Applied',GETDATE(),dateadd(w, -3, GETDATE())),
(1,3,'interview 1',GETDATE(),dateadd(w, -5, GETDATE())),
(4,5,'Applied',GETDATE(),dateadd(w, -1, GETDATE())),
(5,8,'Rejected',GETDATE(),dateadd(w, -2, GETDATE())),
(5,1,'offer extended',GETDATE(),dateadd(w, -3, GETDATE())),
(3,3,'interview 3',GETDATE(),dateadd(w, -6, GETDATE())),
(1,6,'Applied',GETDATE(),dateadd(w, -10, GETDATE())),
(2,7,'Waiting',GETDATE(),dateadd(w, -5, GETDATE())),
(4,9,'Applied',GETDATE(),dateadd(w, -1, GETDATE())),
(4,10,'Applied',GETDATE(),dateadd(w, -8, GETDATE())),
(7,5,'Onboarding',GETDATE(),dateadd(w, -3, GETDATE()));

INSERT INTO Offers VALUES
(1, 5, 'actionNeeded'),
(5, 11, 'accepted');


INSERT INTO InterviewRemarks VALUES
('Candidate seems to be good based on the 1st interview. Can proceeed with 2nd round','Cooperative Interviewer'),
('Candidate can proceed with round 2. Candidate could answer the questions satisfactorily in the 1st round',NULL),
('Candidate couldnt answer the 50% questions in the 2nd technical interview. Doesnt fit for this position','Tough Interview'),
('Candidate cleared the 1st technical round.',NULL),
('Candidate cleared the 2nd technical round. Can proceed with 3rd round of interview for behavioural questions',NULL),
('Candidate cleared the 3rd round of interview',NULL),
('Candidate is a good fit for the given requirements in the 1st technical round.',NULL),
('Candidate cleared the 2nd round of interview. Candidate is selected',NULL),
('Candidate is rejected in the 1st interview. Doesnt meet the requirements', 'Rude interviewer. Asked difficult questions which were not aligned with job position requirements'),
('Candidate did well the 1st technical round.',NULL),
('Candidate cleared the 2nd round of interview. Candidate is selected for the given position.',NULL);

INSERT INTO Interviews VALUES
(2, 1, dateadd(hh, -2, dateadd(w, -1, GETDATE())),dateadd(hh, -1, dateadd(w, -1, GETDATE())), 'online', 'accepted'),
(4, 2, dateadd(hh, -2, dateadd(w, -3, GETDATE())),dateadd(hh, -1, dateadd(w, -3, GETDATE())), 'onsite', 'accepted'),
(4, 3, dateadd(hh, -2, dateadd(w, -1, GETDATE())),dateadd(hh, -1, dateadd(w, -1, GETDATE())), 'online', 'rejected'),
(6, 4, dateadd(hh, -2, dateadd(w, -4, GETDATE())),dateadd(hh, -1, dateadd(w, -4, GETDATE())), 'onsite', 'accepted'),
(6, 5, dateadd(hh, -2, dateadd(w, -6, GETDATE())),dateadd(hh, -1, dateadd(w, -6, GETDATE())), 'online', 'accepted'),
(6, 6, dateadd(hh, -2, dateadd(w, -4, GETDATE())),dateadd(hh, -1, dateadd(w, -4, GETDATE())), 'online', 'accepted'),
(5, 7, dateadd(hh, -2, dateadd(w, -3, GETDATE())),dateadd(hh, -1, dateadd(w, -3, GETDATE())), 'onsite', 'accepted'),
(5, 8, dateadd(hh, -2, dateadd(w, -1, GETDATE())),dateadd(hh, -1, dateadd(w, -1, GETDATE())), 'onsite', 'accepted'),
(8, 9, dateadd(hh, -2, dateadd(w, -1, GETDATE())),dateadd(hh, -1, dateadd(w, -1, GETDATE())), 'onsite', 'rejected'),
(11, 10, dateadd(hh, -6, dateadd(w, -1, GETDATE())),dateadd(hh, -4, dateadd(w, -1, GETDATE())), 'onsite', 'accepted'),
(11, 11, dateadd(hh, -2, dateadd(w, -1, GETDATE())),dateadd(hh, -1, dateadd(w, -1, GETDATE())), 'onsite', 'accepted');

INSERT INTO Interviewer VALUES
('Sumeet Raghvan', 'IT', 'Project Manager'),
('Siddharth Malhotra', 'Analysts', 'Business Analyst'),
('Dilip Tahil', 'IT', 'Team Lead'),
('Atul Anand', 'Management', 'Product Manager'),
('Sachin Patil', 'IT', 'Cyber Security');

INSERT INTO InterviewerMapping VALUES
(1,3),
(1,4),
(2,7),
(3,6),
(4,5),
(4,6),
(4,3),
(5,4),
(7,6),
(7,5),
(8,7),
(9,3),
(10,3),
(6,6),
(11,5),
(11,7);

INSERT INTO Tests VALUES
(1,'online',dateadd(hh, -2, dateadd(w, -1, GETDATE())),dateadd(hh, -2, dateadd(w, -1, GETDATE())), '1-a 2-c 3-c 4-d', 'passed'),
(2,'onsite',dateadd(hh, -2, dateadd(w, -1, GETDATE())),dateadd(hh, -1, dateadd(w, -1, GETDATE())), '1-true 2-false', 'passed'),
(3,'online',dateadd(hh, -2, dateadd(w, -3, GETDATE())),dateadd(hh, -1, dateadd(w, -2, GETDATE())), '1-false 2-false','failed'),
(4,'onsite',dateadd(hh, -2, dateadd(w, -1, GETDATE())),dateadd(hh, -1, dateadd(w, -1, GETDATE())), '1-d 2-c','passed'),
(5,'online',dateadd(hh, -2, dateadd(w, -1, GETDATE())),dateadd(hh, -1, dateadd(w, -1, GETDATE())), '1-a 2-c 3-c 4-d','passed'),
(6,'onsite',dateadd(hh, -2, dateadd(w, -1, GETDATE())),dateadd(hh, -1, dateadd(w, -1, GETDATE())), '1-false 2-true 3-true 4-false 5-a 6-b','passed'),
(7,'online',dateadd(hh, -7, dateadd(w, -1, GETDATE())),dateadd(hh, -1, dateadd(w, -6, GETDATE())), '2-a 3-e','passed'),
(8,'onsite',dateadd(hh, -2, dateadd(w, -1, GETDATE())),dateadd(hh, -1, dateadd(w, -1, GETDATE())), '1-a 2-c 3-c 4-d','passed'),
(9,'online',dateadd(hh, -2, dateadd(w, -1, GETDATE())),dateadd(hh, -1, dateadd(w, -1, GETDATE())), '','failed');

INSERT INTO GraderMapping VALUES
(3, 1),
(7, 2),
(5, 3),
(6, 4),
(4, 5),
(3, 6),
(5, 7),
(6, 8),
(4, 9);

INSERT INTO ReimbursementType VALUES
('Airline reservation details', 700.00), 
('Hotel reservation details', 300.00),
('Car Rental',150.00),
('Food Expenses',100.00);

INSERT INTO Reimbursement VALUES
(2, 1, 500.00, 500.00, 1, 'emirates.pdf'),
(7, 4, 100.00, 100.00, 1, 'miradoor.docx'),
(4, 3, 100.00, 100.00, 1, 'zipcar.docx'),
(8, 1, 700.00, 700.00, 1, 'etihad.pdf'),
(2, 2, 350.00, 300.00, 1, 'dragonfly.pdf'),
(4, 4, 100.00, 100.00, 1,'sandeep.docx'),
(2, 4, 100.00, 0, 0, 'restBill.pdf'),
(9, 1, 600.00, 600.00, 1, 'airindia.docx'),
(10, 2, 300.00, 300.00, 1, ''),
(9, 2, 350.00, 0, 0, 'ranch.docx'),
(9, 4, 50.00, 50.00, 1, 'chipotle.pdf'),
(8, 2, 200.00, 200.00, 1, 'fivestar.pdf');

INSERT INTO DocumentType VALUES
('CV'),
('Reference Letter'),
('Cover Letter');

INSERT INTO Documents VALUES
(1, 1, 'cv.pdf'),
(2, 1, 'cv_developer.pdf'),
(2, 2, 'rl_developer.pdf'),
(3, 1, 'cv3.pdf'),
(4, 1, 'cv_manager.pdf'),
(5, 1, 'cv_sd.pdf'),
(6, 3, 'cover1.pdf'),
(8, 1, 'resume_BA.pdf'),
(8, 2, 'rl_BA.pdf'),
(9, 1, 'resume3.pdf'),
(10, 1, 'resume.pdf'),
(8, 3, 'cover2.pdf');

INSERT INTO Complaint VALUES
(8, 'Interviewer asked questions not aligned with the requirements. Very Rude behaviour. ', 'Under Review');

INSERT INTO Onboarding VALUES
(1, 5, dateadd(w, 20, GETDATE())),
(5, 7, dateadd(w, 30, GETDATE()));

USE Recruitment
GO

CREATE VIEW InterviewReimbursements AS
SELECT i.InterviewID, r.ReimbursementID, rt.RequestName, r.RequestedAmt, r.ProcessedAmt, r.IsProcessed
FROM Interviews i LEFT JOIN Reimbursement r ON i.InterviewID = r.InterviewID LEFT JOIN ReimbursementType rt ON r.RequestTypeID = rt.RequestTypeID;


select * from InterviewReimbursements;

USE Recruitment
GO

CREATE VIEW InterviewCount AS
SELECT ir.InterviewerID, count(i.InterviewID) as TotalNoOfInterviews
FROM Interviewer ir LEFT JOIN InterviewerMapping im ON ir.InterviewerID = im.InterviewerID JOIN Interviews i ON im.InterviewID = i.InterviewID 
GROUP BY ir.InterviewerID;

SELECT TOP 2 InterviewerID, TotalNoOfInterviews FROM InterviewCount ORDER BY TotalNoOfInterviews DESC;


USE Recruitment
GO

select * from Interviews where InterviewID in(1, 4,9,10)
select * from InterviewerMapping where InterviewerID = 1

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


CREATE PROC spCountApplication
@Status varchar(25) = NULL
AS
IF @Status IS NULL 
SET @Status = ' '
DECLARE @CountCandidates int = 0
IF @CountCandidates =0 
SELECT @CountCandidates = COUNT(*) FROM Applications WHERE ApplicationStatus= @Status
SELECT @Status AS ApplicationStatus, @CountCandidates AS NoOfApplications;

EXEC spCountApplication @Status = 'applied';
