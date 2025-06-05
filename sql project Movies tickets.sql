-- Movies Ticket Booking System
create database MoviesTickets;
use MoviesTickets;
create table Theaters
(
TheaterId int primary key auto_increment,
TheaterName varchar(100),
Location varchar(200),
TotalSeats int
);
insert into Theaters(TheaterName,Location,TotalSeats)values
('PVR Cinema','Saket',200),
('INOX','Connought Place',300),
('Cinepolis','South Delhi',200),
('Carnival','Rohini',250),
('Wave Cinema','Noida',300),
('Logix','Noida',250);
select * from Theaters;

create table Movies
(
MoviesId int primary key,
MoviesName varchar(200),
Duration int,
TheaterId int,
foreign key(TheaterId)references Theaters(TheaterId)
);
insert into Movies(MoviesId,MoviesName,Duration,TheaterId)values
(101,'Inception',148,1),
(102,'The Dark Knight',152,2),
(103,'Avengers',181,3),
(104,'The Godfather',175,4),
(105,'Mrs.',185,5),
(106,'Chhava',181,6),
(107,'Pushpa',190,1),
(108,'Venom',165,2),
(109,'Fall',181,5),
(110,'Titanic',195,4);
select * from Movies;

create table Customers
(
CustomerId int primary key,
Name varchar(200),
Email varchar(100),
PhoneNumber varchar(15)
);
insert into Customers(CustomerId,Name,Email,PhoneNumber)values
(1,'Amit','amit@123gmail.com',9999295641),
(2,'Sonam','sonam@679gmail.com',8750571923),
(3,'Pooja','poojasingh@gmail.com',9650963050),
(4,'Neha','neha@gmail.com',9931254331),
(5,'Rohit','rohitthakur@gmail.com',7899345621),
(6,'Jyoti','jyoti@gmail.com',9876345223),
(7,'Ankush','ankushsingh@gmail.com',8906754883),
(8,'Riya','riya@gmail.com',8756984321),
(9,'Ravi','raviverma@gmail.com',9800224578),
(10,'Mohit','mohit@gmail.com',9976897631);
select * from Customers;

create table Bookings
 (
 BookingId int primary key,
 CustomerId int,
 MoviesId int,
 ShowTime datetime,
 seatsBooked int,
 TotalAmount decimal(10,2),
 foreign key(CustomerId)references Customers(CustomerId),
 foreign key(MoviesId)references Movies(MoviesId)
 );
 insert into Bookings(BookingId,CustomerId,MoviesId,ShowTime,seatsBooked,TotalAmount)values
 (11,1,101,'2025-03-04 14:30:00',4,800.00),
 (12,2,102,'2025-03-05 17:00:00',3,450.00),
 (13,3,103,'2025-03-06 20:00:00',5,1000.00),
 (14,4,104,'2025-03-04 14:30:00',4,800.00),
 (15,5,105,'2025-02-28 17:00:00',3,450.00),
 (16,6,106,'2025-03-02 20:00:00',5,1000.00),
 (17,7,107,'2025-03-06 20:00:00',5,1000.00),
 (18,8,108,'2025-03-16 19:30:00',6,1200.00),
 (19,9,109,'2025-02-22 15:45:00',2,450.00),
 (20,10,110,'2025-03-02 20:30:00',5,1000.00);
  select * from Bookings;
  
  -- ER Diagram
  
  -- Queries
  -- 1.Retrieve available seats for a showtime at a specific theater
 SELECT 
    t.TheaterId,
    t.TheaterName,
    m.MoviesName,
    b.ShowTime,
    t.TotalSeats - COALESCE(SUM(b.seatsBooked), 0) AS AvailableSeats
FROM 
    Theaters t
JOIN 
    Movies m ON t.TheaterId = m.TheaterId
LEFT JOIN 
    Bookings b ON m.MoviesId = b.MoviesId AND b.ShowTime = '2025-03-04 14:30:00'
WHERE 
    t.TheaterId = 1  -- Replace with your desired theater ID
GROUP BY 
    t.TheaterId, t.TheaterName, m.MoviesName, b.ShowTime, t.TotalSeats;

-- 2.Retrieve a customer's booking history
SELECT 
    c.CustomerId,
    c.Name,
    m.MoviesName AS MovieTitle,
    b.ShowTime,
    b.seatsBooked AS TotalSeatsBooked,
    b.TotalAmount
FROM 
    Bookings b
JOIN 
    Customers c ON b.CustomerId = c.CustomerId
JOIN 
    Movies m ON b.MoviesId = m.MoviesId
WHERE 
    c.CustomerId = 1  -- Replace with your desired customer ID
ORDER BY 
    b.ShowTime DESC;
    
    -- 3.Total bookings and revenue per movie per month
   SELECT 
    m.MoviesId,
    m.MoviesName,
    DATE_FORMAT(b.ShowTime, '%Y-%m') AS Month,
    COUNT(b.BookingId) AS TotalBookingsCount,
    SUM(b.TotalAmount) AS TotalRevenue
FROM 
    Bookings b
JOIN 
    Movies m ON b.MoviesId = m.MoviesId
GROUP BY 
    m.MoviesId, m.MoviesName, Month
ORDER BY 
    Month, TotalBookingsCount DESC;
    
    -- User Privileges and Roles Management
    -- 1.Create Roles
    -- Create roles for each type of user
CREATE ROLE Admin;
CREATE ROLE Manager;
CREATE ROLE CustomerUser;

-- 2. Create Users and Assign Roles
-- Create users
CREATE USER 'admin_user'@'localhost' IDENTIFIED BY 'Admin@123';
CREATE USER 'manager_user'@'localhost' IDENTIFIED BY 'Manager@123';
CREATE USER 'customer_user'@'localhost' IDENTIFIED BY 'Customer@123';

-- Grant roles to users
GRANT Admin TO 'admin_user'@'localhost';
GRANT Manager TO 'manager_user'@'localhost';
GRANT CustomerUser TO 'customer_user'@'localhost';

-- 3.Assign Privolegs to Roles
GRANT ALL PRIVILEGES ON MoviesTickets.* TO Admin;
-- Manager – Manage movies, bookings, and theaters (but not users)
GRANT SELECT, INSERT, UPDATE, DELETE 
ON MoviesTickets.* TO Manager;


-- CustomerUser – Book and view movies only
GRANT SELECT, INSERT ON MoviesTickets.Bookings TO CustomerUser;

GRANT SELECT, INSERT ON Bookings TO CustomerUser;





    
    
  

    
    
    
 


   
  
  
  
  
 