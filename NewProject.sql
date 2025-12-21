CREATE DATABASE CabBookingSystem;

USE CabBookingSystem;

CREATE TABLE Customers (
    CustomerID INT PRIMARY KEY,
    Name VARCHAR(100),
    Email VARCHAR(100),
    Phone VARCHAR(20),
    RegistrationDate DATE
);

CREATE TABLE Drivers (
    DriverID INT PRIMARY KEY,
    Name VARCHAR(100),
    Phone VARCHAR(20),
    LicenseNumber VARCHAR(50),
    Rating DECIMAL(2,1)
);

CREATE TABLE Cabs (
    CabID INT PRIMARY KEY,
    DriverID INT,
    VehicleType VARCHAR(20),  -- Sedan, SUV, etc.
    LicensePlate VARCHAR(20),
    FOREIGN KEY (DriverID) REFERENCES Drivers(DriverID)
);

CREATE TABLE Bookings (
    BookingID INT PRIMARY KEY,
    CustomerID INT,
    CabID INT,
    BookingTime DATETIME,
    TripStartTime DATETIME,
    TripEndTime DATETIME,
    PickupLocation VARCHAR(100),
    DropoffLocation VARCHAR(100),
    Status VARCHAR(20), -- Completed, Cancelled, Ongoing
    Fare DECIMAL(10,2),
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID),
    FOREIGN KEY (CabID) REFERENCES Cabs(CabID)
);

CREATE TABLE TripDetails (
    TripID INT PRIMARY KEY,
    BookingID INT,
    DistanceKm DECIMAL(5,2),
    DurationMins INT,
    FOREIGN KEY (BookingID) REFERENCES Bookings(BookingID)
);

CREATE TABLE Feedback (
    FeedbackID INT PRIMARY KEY,
    BookingID INT,
    CustomerID INT,
    DriverID INT,
    Rating INT, -- 1 to 5
    Comments TEXT,
    FOREIGN KEY (BookingID) REFERENCES Bookings(BookingID),
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID),
    FOREIGN KEY (DriverID) REFERENCES Drivers(DriverID)
);

INSERT INTO Customers VALUES
(1, 'Aarav Sharma', 'aarav@gmail.com', '9876543210', '2023-01-10'),
(2, 'Diya Mehta', 'diya@gmail.com', '9823456789', '2023-02-15'),
(3, 'Karan Singh', 'karan@gmail.com', '9765432187', '2023-03-20'),
(4, 'Priya Nair', 'priya@gmail.com', '9887654321', '2023-04-05'),
(5, 'Rohit Verma', 'rohit@gmail.com', '9812345678', '2023-04-25');

INSERT INTO Drivers VALUES
(101, 'Sanjay Kumar', '9900112233', 'MH12AB1234', 4.5),
(102, 'Ravi Desai', '9877665544', 'MH14CD5678', 3.2),
(103, 'Meena Joshi', '9833445566', 'MH13EF4321', 4.8),
(104, 'Ajay Yadav', '9988776655', 'MH10GH6789', 2.9),
(105, 'Kavita Patil', '9822334455', 'MH16IJ1112', 3.9);

INSERT INTO Cabs VALUES
(201, 101, 'Sedan', 'MH01AA1234'),
(202, 102, 'SUV', 'MH02BB5678'),
(203, 103, 'Hatchback', 'MH03CC4321'),
(204, 104, 'Sedan', 'MH04DD6789'),
(205, 105, 'SUV', 'MH05EE1112');

INSERT INTO Bookings VALUES
(301, 1, 201, '2023-06-01 09:00:00', '2023-06-01 09:15:00', '2023-06-01 10:00:00', 'Pune Station', 'Airport', 'Completed', 450.00),
(302, 2, 202, '2023-06-02 14:00:00', NULL, NULL, 'Shivaji Nagar', 'Baner', 'Cancelled', 0.00),
(303, 3, 203, '2023-06-03 11:30:00', '2023-06-03 11:40:00', '2023-06-03 12:10:00', 'Hadapsar', 'Magarpatta', 'Completed', 200.00),
(304, 4, 204, '2023-06-04 18:00:00', '2023-06-04 18:10:00', '2023-06-04 19:10:00', 'Kothrud', 'Swargate', 'Completed', 350.00),
(305, 1, 205, '2023-06-05 08:00:00', NULL, NULL, 'Viman Nagar', 'Airport', 'Cancelled', 0.00);

INSERT INTO TripDetails VALUES
(401, 301, 20.5, 45),
(402, 303, 8.2, 30),
(403, 304, 12.0, 60);

INSERT INTO Feedback VALUES
(501, 301, 1, 101, 5, 'Smooth and quick ride.'),
(502, 303, 3, 103, 4, 'Good experience overall.'),
(503, 304, 4, 104, 2, 'Driver was late.'),
(504, 301, 1, 101, 5, 'Very polite and helpful driver.');

SELECT * FROM Customers;

select * from CabBookingSystem.Customers;

SHOW COLUMNS FROM Customers;

SELECT * FROM Drivers;

SELECT * FROM Cabs;

SELECT * FROM Bookings;

SELECT * FROM TripDetails;
SELECT * FROM Feedback;

SELECT 
    b.CustomerID,
    c.Name,
    COUNT(*) AS CompletedBookings
FROM 
    Bookings b
JOIN 
    Customers c ON b.CustomerID = c.CustomerID
WHERE 
    b.Status = 'Completed'
GROUP BY 
    b.CustomerID, c.Name
ORDER BY 
    CompletedBookings DESC;


SELECT 
    c.CustomerID,
    c.Name,
    COUNT(b.BookingID) AS Total_Bookings,
    SUM(CASE WHEN b.Status = 'Cancelled' THEN 1 ELSE 0 END) AS Cancelled_Bookings,
    ROUND((SUM(CASE WHEN b.Status = 'Cancelled' THEN 1 ELSE 0 END) * 100.0) / COUNT(b.BookingID), 2) AS Cancel_Percentage
FROM 
    Customers c
JOIN 
    Bookings b ON c.CustomerID = b.CustomerID
GROUP BY 
    c.CustomerID, c.Name
HAVING 
    (SUM(CASE WHEN b.Status = 'Cancelled' THEN 1 ELSE 0 END) * 1.0 / COUNT(b.BookingID)) > 0.3;



SELECT 
    DAYNAME(BookingTime) AS DayOfWeek,
    COUNT(*) AS TotalBookings
FROM 
    Bookings
GROUP BY 
    DayOfWeek
ORDER BY 
    TotalBookings DESC;


SELECT 
    d.DriverID,
    d.Name,
    AVG(f.Rating) AS AvgRating
FROM 
    Feedback f
JOIN 
    Drivers d ON f.DriverID = d.DriverID
GROUP BY 
    d.DriverID, d.Name
HAVING 
    AvgRating < 3.0;
    
    
SELECT 
    d.DriverID,
    d.Name,
    td.DistanceKm,
    b.BookingID
FROM 
    TripDetails td
JOIN 
    Bookings b ON td.BookingID = b.BookingID
JOIN 
    Cabs c ON b.CabID = c.CabID
JOIN 
    Drivers d ON c.DriverID = d.DriverID
WHERE 
    b.Status = 'Completed'
ORDER BY 
    td.DistanceKm DESC
LIMIT 5;


SELECT 
    d.DriverID,
    d.Name,
    COUNT(*) AS TotalTrips,
    SUM(CASE WHEN b.Status = 'Cancelled' THEN 1 ELSE 0 END) AS CancelledTrips,
    ROUND(
        (SUM(CASE WHEN b.Status = 'Cancelled' THEN 1 ELSE 0 END) * 100.0) / COUNT(*), 
        2
    ) AS CancelledPercentage
FROM 
    Bookings b
JOIN 
    Cabs c ON b.CabID = c.CabID
JOIN 
    Drivers d ON c.DriverID = d.DriverID
GROUP BY 
    d.DriverID, d.Name
HAVING 
    CancelledPercentage > 30;
    
    
SELECT 
    DATE_FORMAT(BookingTime, '%Y-%m') AS Month,
    SUM(Fare) AS MonthlyRevenue
FROM 
    Bookings
WHERE 
    Status = 'Completed'
    AND BookingTime >= DATE_SUB(CURDATE(), INTERVAL 6 MONTH)
GROUP BY 
    DATE_FORMAT(BookingTime, '%Y-%m')
ORDER BY 
    Month;


SELECT 
    DATE_FORMAT(BookingTime, '%Y-%m') AS Month,
    SUM(Fare) AS MonthlyRevenue
FROM 
    Bookings
WHERE 
    Status = 'Completed'
    AND BookingTime BETWEEN '2023-01-01' AND '2023-06-30'
GROUP BY 
    DATE_FORMAT(BookingTime, '%Y-%m')
ORDER BY 
    Month;
    
    
SELECT 
    PickupLocation, 
    DropoffLocation, 
    COUNT(*) AS TripCount
FROM 
    Bookings
WHERE 
    Status = 'Completed'
GROUP BY 
    PickupLocation, DropoffLocation
ORDER BY 
    TripCount DESC
LIMIT 3;


SELECT 
    d.DriverID,
    d.Name,
    d.Rating,
    COUNT(b.BookingID) AS CompletedTrips,
    SUM(b.Fare) AS TotalFare
FROM 
    Drivers d
JOIN 
    Cabs c ON d.DriverID = c.DriverID
JOIN 
    Bookings b ON c.CabID = b.CabID
WHERE 
    b.Status = 'Completed'
GROUP BY 
    d.DriverID, d.Name, d.Rating
ORDER BY 
    d.Rating DESC;


SELECT 
    c.VehicleType,
    SUM(b.Fare) AS TotalRevenue
FROM 
    Cabs c
JOIN 
    Bookings b ON c.CabID = b.CabID
WHERE 
    b.Status = 'Completed'
GROUP BY 
    c.VehicleType;




SELECT 
    c.CustomerID,
    c.Name,
    COUNT(b.BookingID) AS TotalBookings,
    MAX(b.BookingTime) AS LastBookingDate,
    DATEDIFF(CURDATE(), MAX(b.BookingTime)) AS DaysSinceLastBooking
FROM 
    Customers c
LEFT JOIN 
    Bookings b ON c.CustomerID = b.CustomerID
GROUP BY 
    c.CustomerID, c.Name
ORDER BY 
    DaysSinceLastBooking DESC;
    
    
    
    
    SELECT 
    CASE 
        WHEN WEEKDAY(BookingTime) IN (5, 6) THEN 'Weekend'
        ELSE 'Weekday'
    END AS DayType,
    COUNT(*) AS TotalBookings
FROM Bookings
WHERE Status = 'Completed'
GROUP BY DayType;

