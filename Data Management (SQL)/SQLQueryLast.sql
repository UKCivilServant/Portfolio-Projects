
/* Work-Flow
--> Normalisation (Upto 3NF), Table Creation from case study
--> Putting dummy data in the tables
--> Data Transformation ( example with "CustomerInformation" table: extract data from the operational table, transform data in the staging table)
--> Validation of case study and business requirements by quering the data.
*/


/*                                    CASE STUDY 
                  Southdowns Electric Mountain Bike Rental (SEMBR) 
 
You are working for SEMBR, an electric bike hire company, similar to this company here: Cannonball Bikes. 
 
Current System:  
There is one rental centre in Eastbourne. They offer daily / weekly / monthly hire for electric bikes which allow people to ride on the South Downs (a 
national park). They have personal and business customers. SEMBR stores customer information, and many customers make repeat rentals. They currently stock two types of bike for hire:  
 
•	Full suspension  	(High Season £50 per day / Low Season £40 per day) 
•	Hardtail 	 	(High Season £40 per day / Low Season £30 per day) 
 
Each bike hire is recorded separately (i.e., if someone want 3 bikes for one day, that is three hires).
The cost of rental is more in the high season (May-August) than low season (September-April). 
This is based on the start date. All hirers must be over 18s (for insurance and safety reasons).
Customers must produce photo ID to make a booking. Customers return bikes to the Eastbourne centre.
Hires are recorded in an online booking diary system, using a spreadsheet template. 
There have been issues with double-booking / bikes being unavailable due to servicing and repairs etc.  
 
New System:
SEMBR have been invited to partner with Walk The Trails (WTT), a company similar to this: Natural Adventure Company.
WTT currently runs self-guided walking tours of the South Downs Way - a national trail for walking, biking, riding etc. 
that runs between Winchester and Eastbourne (160km). They wish to add self-guided bike tours to their offer. 
They will deal with supplying the accommodation bookings, route maps and daily luggage transfers as they do for their existing walking customers. 
There may be a small discount for bikes hired via WTT. 
 
WTT would like SEMBR to supply electric mountain bikes.
The bikes will need to be picked up and dropped off from both ends of the South Downs Way, as customers may travel the route in either direction. 
SEMBR will open a new rental centre in Winchester. They hope to minimise driving the bikes between locations. 
Staff will work across both locations as required. SEMBR will also offer support and emergency repairs over the route, 
fixing and replacing bikes along the trail, so that the tourist(s) can continue with their booked holiday. 
WTT will provide a holiday ID number for each bike booking (which may be for more than one bike). 
Other bookings will still be available to individual customers, as per the current system.
The range of bikes may be extended e.g. different sized frames. 
 
To achieve this, SEMBR will need to update their information system. 
A feasibility report has concluded that the company should use a relational database with a web front-end for their new system.  

It is your job to write a design report for the database element. 

APPENDIX 1: CASE STUDY AND REQUIREMENTS 

The new system should support the following requirements: 
 
1.	Register customers for first use, including name, address, dob. 
    A photo ID must be human-verified human to check age – this can be completed by WTT or SEMBR staff. 
2.	Record information for each bike, including type (currently two types, may be more in future), 
    unique frame number (UFN), service history and overall condition.  
3.	Show location of the bike – currently and on any given future date (based on bookings). 
4.	Record information about any emergency repairs (WTT bikes only), including whether SEMBR issued a replacement bike. 
    Include the holiday number from WTT.  
5.	Calculate the total number of bikes on hire for a given period. 
6.	Calculate the total income from hired bikes for a given period – split this between WTT and other hires.


APPENDIX 2: EXAMPLE DOCUMENT FOR NORMALISATION
CUSTOMER and HIRE record for normalisation
This is the prototype view of a customer record showing their hire history.
It will not contain all required data – you will need to add to what is here in your design (but should normalise just this data to inform your data model). 
Note that the earlier hires for this customer are via WTT, but the later ones are individual bookings.

CUSTOMER INFORMATION
CustomerID: AAA1111:
Forename: Jennie Surname: Harding DOB: 13/07/1969
Tel mobile: 07782632485
Tel home: 012330522649
Address: 45 Madeup Street, Brighton
Postcode: BN4 5GH		
-->ID VALIDATION
ID Type: passport / driving license / other 
Date Verified: 04/08/2023
Verified By (staffID): GR2r
Staff Name: Gill Roller	
-->ID SCAN
 	
UFN	  BIKE TYPE	        RENTAL START *	PICKUP LOCATION	     DAYS	COST PER DAY (£)	TOTAL PAID	  RETURN LOCATION	     RETURN SIGNOFF 	SIGNOFF BY	     WTT REF (OPTIONAL)
F14	  Full suspension	01/08/2023	    Eastbourne EB12 8RG	  10	      50	            500	     Winchester WC8 2LR	          yes	      GR2 Gill Roller	    WTT123
F22	  Full suspension	01/08/2023	    Eastbourne EB12 8RG	  10	      50	            500	     Winchester WC8 2LR	          yes	      GR2 Gill Roller	    WTT123
H86	  Hardtail	        18/09/2023	    Winchester WC8 2LR	   5	      30	            150	     Winchester WC8 2LR	          no**	      LW8 Lee Wilson	
F22	  Full suspension	12/10/2023	    Eastbourne EB12 8RG	   2	      40	             80	     Eastbourne EB12 8RG	      ***NULL	            NULL	

*note: varying price for same type of bike between August and October – this will change each year 
**note: bike damaged this hire, so it would have had to be repaired (details not shown here)
***note: bike not yet returned (hire still in progress)

*/


USE [WTT-SEMBR Cycle]

/*Table creation, ERD */

CREATE TABLE CustomerInformation(
    CustomerID VARCHAR(10) NOT NULL PRIMARY KEY,
    Forename VARCHAR(50),
    Surname VARCHAR(50),
    DOB DATE NOT NULL CHECK(
        DOB IS NOT NULL
        AND
        DOB <= '2005-12-15'),
    TeleMobile VARCHAR(15),
	TeleHome VARCHAR(15),
	Address1 VARCHAR(50),
	Address2 VARCHAR(50),
	PostCode VARCHAR(8)
);



CREATE TABLE Location(
    LocationID VARCHAR(8) NOT NULL PRIMARY KEY
	   CHECK(LocationID IN('WC8 2LR','EB12 8RG')),
	Location VARCHAR(10)
	   CHECK(Location IN('Winchester','Eastbourne'))
);

CREATE TABLE Staff (
    StaffID VARCHAR(5) NOT NULL PRIMARY KEY,
	Forename VARCHAR(50),
    Surname VARCHAR(50),
	Company CHAR(5)
	   CHECK(Company IN('WTT','SEMBR')),
    LocationID VARCHAR(8) REFERENCES Location(LocationID)

);

CREATE TABLE ID_Validation(
    PhotoID VARCHAR(12) NOT NULL PRIMARY KEY,
	ID_Scan Image, 
	StaffID VARCHAR(5) NOT NULL REFERENCES Staff(StaffID),
	VerificationStatus VARCHAR(12) CHECK(VerificationStatus IN ('Verified', 'Not Verified')) DEFAULT 'Not Verified',
	Date_Verified DATE,
	CustomerID VARCHAR(10) REFERENCES CustomerInformation(CustomerID)
);

CREATE TABLE Bike(
    BikeID VARCHAR(5) NOT NULL PRIMARY KEY,
	BikeType VARCHAR(15)
	   CHECK(BikeType IN('Full suspension','Hardtail')),
	Frame_Size VARCHAR(6)
	   CHECK(Frame_Size IN('Small','Medium','Large')),
	Overall_Condition VARCHAR(9)
	   CHECK(Overall_Condition IN('Good','Excellent','Bad')),
	Bike_Status VARCHAR(10)
	   CHECK(Bike_Status IN('Booked','Available','In-Service')) DEFAULT 'Available',
        LocationID VARCHAR(8) REFERENCES Location(LocationID)
);

CREATE TABLE Bike_Service_History(
    ServiceID INT IDENTITY NOT NULL PRIMARY KEY,
	Service_Date DATE,
	Description TEXT,
	Cost DECIMAL,
	BikeID VARCHAR(5) REFERENCES Bike(BikeID)

);

CREATE TABLE Booking(
    BookingID VARCHAR(10) NOT NULL PRIMARY KEY,
    CustomerID VARCHAR(10) REFERENCES CustomerInformation(CustomerID),
	BikeID VARCHAR(5) REFERENCES Bike(BikeID),
	Duration INT,
	Rental_Start DATE,
	Total_Paid DECIMAL,
	Pickup_Location VARCHAR(8) REFERENCES Location(LocationID),
	Return_Location VARCHAR(8) REFERENCES Location(LocationID),
	ReturnSignOff VARCHAR(3)
	   CHECK(ReturnSignOff IN('YES','NO')) DEFAULT NULL, 
	SignOffBy VARCHAR(5) REFERENCES Staff(StaffID),
	WTT_REF VARCHAR(10),
	Discount DECIMAL
);

CREATE TABLE EmergencyRepairs(
    Emergency_RepairID INT IDENTITY NOT NULL PRIMARY KEY,
	Description TEXT,
	ReplacementBike VARCHAR(5) REFERENCES Bike(BikeID),
	Cost DECIMAL,
	BookingID VARCHAR(10) REFERENCES Booking(BookingID),
	WTT_REF VARCHAR(10)

);

/* Mock data generation*/

/*Customer*/

INSERT INTO CustomerInformation (CustomerID, Forename, Surname, DOB, TeleMobile, TeleHome, Address1, Address2, PostCode)
VALUES
('AAA111', 'Jennie', 'Harding', '1978-10-23', '+44 7123 456789', '+44 208 1234567', '45 Madeup Street', 'Brighton', 'BN4 5GH'),
('BBB222', 'John', 'Smith', '1985-05-15', '+44 7456 789012', '+44 207 2345678', '72 Elm Street', 'London', 'SW1A 1AA'),
('CCC333', 'Mary', 'Johnson',  '1990-12-02', '+44 7901 234567', '+44 161 3456789', '18 Oak Avenue', 'Manchester', 'M1 4JZ'),
('DDD444', 'Robert', 'Davis', '1982-08-10', '+44 7734 567890', '+44 121 4567890', '56 Willow Lane', 'Birmingham', 'B2 4DP'),
('EEE555', 'Sarah', 'Brown', '1975-03-30', '+44 7540 123456', '+44 113 5678901', '29 Pine Road', 'Leeds', 'LS1 3AB'),
('FFF666', 'David', 'Taylor',  '1988-06-14', '+44 7766 789012', '+44 141 2345678', '8 Cedar Close', 'Glasgow', 'G2 6DH'),
('GGG777', 'Emily', 'White',  '1972-09-05', '+44 7888 234567', '+44 151 3456789', '37 Birch Lane', 'Liverpool', 'L1 8JX'),
('HHH888', 'Daniel', 'Wilson',  '1983-11-19', '+44 7010 345678', '+44 117 4567890', '63 Maple Street', 'Bristol', 'BS1 6EL'),
('III999', 'Laura', 'Turner',  '1995-04-08', '+44 7702 456789', '+44 191 5678901', '24 Beech Road', 'Newcastle', 'NE1 7XY'),
('JJJ000', 'Michael', 'Harris',  '1980-01-12', '+44 7623 567890', '+44 114 2345678', '50 Aspen Avenue', 'Sheffield', 'S1 2FG');

SELECT*
FROM CustomerInformation

/*Location*/
INSERT INTO Location (LocationID, Location)
VALUES
( 'EB12 8RG','Eastbourne'),
( 'WC8 2LR','Winchester');

SELECT*
FROM Location

/*Staff*/

INSERT INTO Staff (StaffID, Forename, Surname, Company, LocationID) 
VALUES
('GR2r', 'Gill', 'Roller', 'SEMBR', 'EB12 8RG'),
('JK1s', 'John', 'Kane', 'WTT', 'WC8 2LR'),
('LS4t', 'Laura', 'Smith', 'WTT', 'WC8 2LR'),
('MP3u', 'Mike', 'Parker', 'SEMBR', 'EB12 8RG'),
('AS6v', 'Alice', 'Sullivan', 'SEMBR', 'EB12 8RG'),
('TB7w', 'Tom', 'Baker', 'WTT', 'EB12 8RG'),
('EF8x', 'Emma', 'Fisher', 'SEMBR', 'WC8 2LR'),
('RW9y', 'Richard', 'Wilson', 'SEMBR', 'EB12 8RG'),
('LH0z', 'Lisa', 'Harrison', 'WTT', 'EB12 8RG'),
('SM1a', 'Steve', 'Mills', 'WTT', 'WC8 2LR');


SELECT*
FROM Staff

/*Bike*/

 INSERT INTO Bike (BikeID, BikeType, Frame_Size, Overall_Condition, Bike_Status, LocationID)
 VALUES
('F14', 'Full suspension', 'Medium', 'Excellent', 'Booked', 'EB12 8RG'),
('F22', 'Full suspension', 'Large', 'Good', 'Available', 'WC8 2LR'),
('H86', 'Full suspension', 'Small', 'Good', 'Available', 'WC8 2LR'),
('A01', 'Hardtail', 'Large', 'Excellent', 'Available', 'EB12 8RG'),
('B02', 'Hardtail', 'Medium', 'Excellent', 'Available', 'EB12 8RG'),
('C03', 'Hardtail', 'Small', 'Good', 'Available', 'WC8 2LR'),
('D04', 'Full suspension', 'Medium', 'Bad', 'In-Service', 'EB12 8RG'),
('E05', 'Hardtail', 'Large', 'Excellent', 'Booked', 'EB12 8RG'),
('G07', 'Hardtail', 'Small', 'Good', 'Available', 'WC8 2LR'),
('I09', 'Full suspension', 'Large', 'Good', 'Available', 'EB12 8RG');

  SELECT*
  FROM Bike

/*Service History*/
INSERT INTO Bike_Service_History (Service_Date, Description, Cost, BikeID) 
VALUES
('2022-01-15', 'Routine maintenance', 1.00, 'F14'),
('2022-03-22', 'Brake replacement', 3.00, 'H86'),
('2022-05-10', 'Tire change', 8.00, 'F22'),
('2022-07-18', 'Chain lubrication', 3.00, 'D04'),
('2022-09-05', 'Gear adjustment', 4.00, 'F14'),
('2022-11-12', 'Full service', 15.0, 'F22'),
('2023-02-08', 'Wheel truing', 6.00, 'G07'),
('2023-04-25', 'Handlebar upgrade', 9.00, 'F14'),
('2023-06-30', 'Pedal replacement', 3.00, 'I09'),
('2023-09-15', 'Suspension tuning', 7.00, 'H86');

SELECT * FROM Bike_Service_History
SELECT * FROM Bike_Service_History WHERE BikeID = 'F14';




/*Insert Into PhotoID*/
INSERT INTO ID_Validation(PhotoID,ID_Scan,Date_Verified,VerificationStatus, StaffID,CustomerID)
VALUES
('JH196ID001',(SELECT * FROM OPENROWSET(BULK N'C:\Workstation\MSc Data Analytics\MSc Data Analytics\Data Management\driving_1.jpg', SINGLE_BLOB) as Img),NULL,'Not Verified','AS6v','AAA111'),
('JD198ID002',(SELECT * FROM OPENROWSET(BULK N'C:\Workstation\MSc Data Analytics\MSc Data Analytics\Data Management\driving_3.jpg', SINGLE_BLOB) as Img),'2023-01-05','Verified','RW9y','BBB222'),
('AS19ID1003',(SELECT * FROM OPENROWSET(BULK N'C:\Workstation\MSc Data Analytics\MSc Data Analytics\Data Management\passport_1.jpg', SINGLE_BLOB) as Img),'2023-02-10','Verified','AS6v','CCC333'),
('BJ198ID004',(SELECT * FROM OPENROWSET(BULK N'C:\Workstation\MSc Data Analytics\MSc Data Analytics\Data Management\driving_4.jpg', SINGLE_BLOB) as Img),'2023-03-05','Verified','JK1s','DDD444'),
('EC197ID005',(SELECT * FROM OPENROWSET(BULK N'C:\Workstation\MSc Data Analytics\MSc Data Analytics\Data Management\passport_2.jpg', SINGLE_BLOB) as Img),'2023-04-15','Verified','EF8x','EEE555'),
('JH196ID006',(SELECT * FROM OPENROWSET(BULK N'C:\Workstation\MSc Data Analytics\MSc Data Analytics\Data Management\driving_1.jpg', SINGLE_BLOB) as Img),NULL,'Not Verified','MP3u','FFF666'),
('JD198ID007',(SELECT * FROM OPENROWSET(BULK N'C:\Workstation\MSc Data Analytics\MSc Data Analytics\Data Management\driving_3.jpg', SINGLE_BLOB) as Img),'2023-07-20','Verified','LS4t','GGG777'),
('AS19ID1008',(SELECT * FROM OPENROWSET(BULK N'C:\Workstation\MSc Data Analytics\MSc Data Analytics\Data Management\passport_1.jpg', SINGLE_BLOB) as Img),'2023-09-05','Verified','AS6v','HHH888'),
('BJ198ID009',(SELECT * FROM OPENROWSET(BULK N'C:\Workstation\MSc Data Analytics\MSc Data Analytics\Data Management\driving_4.jpg', SINGLE_BLOB) as Img),'2023-10-13','Verified','MP3u','III999'),
('EC197ID000',(SELECT * FROM OPENROWSET(BULK N'C:\Workstation\MSc Data Analytics\MSc Data Analytics\Data Management\passport_2.jpg', SINGLE_BLOB) as Img),'2023-11-19','Verified','EF8x','JJJ000');


SELECT*
FROM ID_Validation

/*Booking */

INSERT INTO Booking (BookingID, CustomerID, BikeID, Rental_Start,Total_Paid ,Duration, Pickup_Location, Return_Location, ReturnSignOff, SignOffBy, WTT_REF, Discount)
VALUES
    ('BK001', 'AAA111', 'F14', '2023-01-05',300 ,7, 'WC8 2LR', 'EB12 8RG', 'NO', NULL, 'WTT001', 3.00), 
    ('BK002', 'BBB222', 'H86', '2023-02-10',200, 5, 'EB12 8RG', 'WC8 2LR', 'YES', 'GR2r', 'WTT002', 2.10),
    ('BK003', 'CCC333', 'F22', '2023-03-15',150, 3, 'EB12 8RG', 'EB12 8RG', 'NO', NULL, 'WTT003', 5.00),
    ('BK004', 'AAA111', 'F14', '2023-04-20',250, 6, 'WC8 2LR', 'WC8 2LR', NULL, NULL, 'WTT004', 7.15),
    ('BK005', 'EEE555', 'H86', '2023-05-25',180, 4, 'EB12 8RG', 'EB12 8RG', 'NO', NULL, 'WTT005', 6.20),
    ('BK006', 'FFF666', 'F22', '2023-06-30',100, 2, 'WC8 2LR', 'WC8 2LR', 'YES', 'LS4t', NULL, NULL),
    ('BK007', 'GGG777', 'H86', '2023-07-05',350, 8, 'EB12 8RG', 'WC8 2LR', 'NO', NULL, NULL, NULL),
    ('BK008', 'AAA111', 'F22', '2023-08-10',50, 1, 'WC8 2LR', 'EB12 8RG', 'YES', 'MP3u', 'WTT008', 9.25),
    ('BK009', 'III999', 'H86', '2023-09-15',290, 7, 'EB12 8RG', 'WC8 2LR', 'NO', NULL, 'WTT009', NULL),
    ('BK010', 'JJJ000', 'F22', '2023-10-20',260, 5, 'WC8 2LR', 'EB12 8RG', NULL, NULL, NULL, NULL);

	SELECT*
	FROM Booking

/*EmergencyRepairs*/
INSERT INTO EmergencyRepairs (Description, ReplacementBike, Cost, BookingID,WTT_REF)
VALUES
    ('Flat tire repair', 'F14', 5.00, 'BK001','WTT001'),
    ('Brake replacement', NULL, 12.00, 'BK002','WTT002'),
    ('Chain repair', 'F22', 8.00, 'BK003','WTT001'),
    ('Gear adjustment', NULL, 4.00, 'BK004','WTT003'),
    ('Wheel alignment', 'F14', 6.00, 'BK005','WTT004'),
    ('Handlebar replacement', NULL, 9.00, 'BK006','WTT005'),
    ('Pedal repair', 'H86', 3.00, 'BK007','WTT006'),
    ('Suspension tuning', 'F14', 7.00, 'BK008','WTT007'),
    ('Seat replacement', 'F22', 2.00, 'BK009','WTT008'),
    ('Frame repair', 'H86', 15.00, 'BK010','WTT009');

	SELECT*
	FROM EmergencyRepairs



/* Data Transformation Demo. Example table: CustomerInformation*/

-- Extract data from the operational CustomerInformation table
SELECT
    CustomerID,
    Forename,
    Surname,
    DOB,
    TeleMobile,
    TeleHome,
    Address1,
    Address2,
    PostCode
INTO
    staging_CustomerInformation
FROM
    CustomerInformation; 


-- Transform data in the staging table
ALTER TABLE staging_CustomerInformation
ADD Age INT;

-- Update Age
UPDATE staging_CustomerInformation
SET Age = YEAR(GETDATE()) - YEAR(DOB);

-- Format TeleMobile and TeleHome
UPDATE staging_CustomerInformation
SET TeleMobile = REPLACE(TeleMobile, '-', ''),
    TeleHome = REPLACE(TeleHome, '-', '');

-- Handiling Null values
UPDATE staging_CustomerInformation
SET TeleMobile = 'N/A'
WHERE TeleMobile IS NULL;

UPDATE staging_CustomerInformation
SET TeleHome = 'N/A'
WHERE TeleHome IS NULL;

UPDATE staging_CustomerInformation
SET Address1 = 'N/A'
WHERE Address1 IS NULL;

UPDATE staging_CustomerInformation
SET Address2 = 'N/A'
WHERE Address2 IS NULL;



/* Requirements of the case study. Checking if they met partially, fully or not. */

-- Requirement: Show location of the bike – currently and on any given future date (based on bookings). 
-- Currrent Location
SELECT
    Booking.BikeID,
    Bike.Bike_Status,
	Booking.BookingID,
	Booking.Rental_Start,
    Location.Location AS CurrentLocation
FROM
    Bike
JOIN
    Booking ON Booking.BikeID = Bike.BikeID
JOIN
    Location ON Location.LocationID = Booking.Pickup_Location
WHERE
    Bike.Bike_Status = 'Booked'
ORDER BY
    Booking.Rental_Start DESC -- If there are multiple bookings, this will give the most recent one

--Future Location

DECLARE @TargetDate DATE = '2023-01-12';  -- Replace with the desired future date

SELECT
    Bike.BikeID,
    Bike.Bike_Status,
    Location.Location AS FutureLocation
FROM
    Bike
JOIN
    Booking ON Bike.BikeID = Booking.BikeID
JOIN
    Location ON Booking.Return_Location = Location.LocationID
WHERE
    Bike.Bike_Status = 'Booked'
    AND  DATEADD(DAY, Duration, Rental_Start)  = @TargetDate
ORDER BY
    Booking.Rental_Start DESC;

/* Register customers for first use, including name, address, dob. 
A photo ID must be human-verified human to check age – this can be completed by WTT or SEMBR staff. */

SELECT Forename,
       Surname,
	   Address2 AS City,
	   DOB,
	   VerificationStatus,
	   StaffID
FROM CustomerInformation
JOIN ID_Validation ON ID_Validation.CustomerID = CustomerInformation.CustomerID


-- Requirement: Calculate total income for the given period.

DECLARE @StartDate DATE = '2023-01-01';
DECLARE @EndDate DATE = '2023-08-31';    

SELECT
    SUM(Total_Paid) AS TotalIncome,
    SUM(CASE WHEN WTT_REF IS NOT NULL THEN Total_Paid * 0.35 ELSE 0 END) AS WTTIncome,
    SUM(CASE WHEN WTT_REF IS NOT NULL THEN Total_Paid * 0.65 ELSE 0 END) AS SEMBRIncome,
    SUM(CASE WHEN WTT_REF IS NULL THEN Total_Paid ELSE 0 END) AS SEMBRIncome
FROM Booking
WHERE Rental_Start BETWEEN @StartDate AND @EndDate;


-- Requirement: Calculate the total number of bikes on hire for a given period.

DECLARE @StartDate_ DATE = '2023-01-01';  
DECLARE @EndDate_ DATE = '2023-12-01';    

SELECT
    COUNT(DISTINCT BikeID) AS TotalBikesOnHire
FROM
    Booking
WHERE
    Rental_Start < DATEADD(DAY, Duration, @EndDate_)
    AND DATEADD(DAY, Duration, Rental_Start) >= @StartDate_;


/*Record information about any emergency repairs (WTT bikes only),
including whether SEMBR issued a replacement bike. Include the holiday number from WTT. */

SELECT * FROM EmergencyRepairs


/* Requirement: Record information for each bike, including type (currently two types, may be more in future),
unique frame number (UFN), service history and overall condition. */

SELECT Bike.BikeType AS Bike_Type,
       Bike.BikeID AS Unique_Frame_Number,
	   Bike.Overall_Condition,
	   Bike_Service_History.Description AS Service_History,
	   '£' + CAST(CAST(Bike_Service_History.Cost AS DECIMAL(10,2)) AS VARCHAR) AS Service_Cost

FROM Bike
JOIN Bike_Service_History ON Bike_Service_History.BikeID= Bike.BikeID 
