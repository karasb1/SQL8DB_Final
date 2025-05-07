create database Airport;
go
use Airport;
go


create table Flights(
    FlightId int primary key,
    FlightNumber varchar(10) not null,
    DepartureTime datetime not null check (DepartureTime > getdate()),
    ArrivalTime datetime not null,
    Duration time,
    Origin varchar(50) not null,
    Destination varchar(50) not null
);

go
create table Passengers(
    PassengerId int primary key,
    FirstName varchar(50) not null,
    LastName varchar(50) not null,
    PassportNumber varchar(20) not null,
);

go
create table Tickets(
    TicketId int primary key,
    FlightId int not null,
    PassengerId int not null,
    SeatNumber varchar(5) not null,
    Price decimal(10, 2) not null,
    BookingDate datetime not null default getdate(),
    foreign key (FlightId) references Flights(FlightId),
    foreign key (PassengerId) references Passengers(PassengerId)
);


go
insert into Flights (FlightId, FlightNumber, DepartureTime, ArrivalTime, Duration, Origin, Destination) values
(1, 'UA123', '2025-10-01 10:00:00', '2025-10-01 12:00:00', '02:00:00','Kyiv', 'Lviv'),
(2, 'UA456', '2025-10-02 15:00:00', '2025-10-02 16:00:00', '01:00:00', 'Lviv', 'Odesa'),
(3, 'UA789', '2025-10-03 12:00:00', '2025-10-03 20:00:00', '08:00:00', 'Odesa', 'Kyiv'),
(4, 'UA101', '2025-10-04 09:00:00', '2025-10-04 11:00:00', '02:00:00', 'Kyiv', 'Kharkiv'),
(5, 'UA202', '2025-10-05 13:00:00', '2025-10-05 15:00:00', '02:00:00', 'Kharkiv', 'Lviv'),
(6, 'UA303', '2025-10-06 15:00:00', '2025-10-06 19:00:00', '04:00:00', 'Lviv', 'Odesa'),
(7, 'UA404', '2025-10-07 11:00:00', '2025-10-07 13:00:00', '02:00:00', 'Odesa', 'Kyiv'),
(8, 'UA505', '2025-10-08 15:00:00', '2025-10-08 17:00:00', '02:00:00', 'Kyiv', 'Lviv'),
(9, 'UA606', '2025-10-09 19:00:00', '2025-10-09 22:00:00', '03:00:00', 'Lviv', 'Kharkiv'),
(10, 'UA707', '2025-10-10 12:00:00', '2025-10-10 14:00:00', '02:00:00', 'Kharkiv', 'Odesa'),
(11, 'UA808', '2025-10-01 16:00:00', '2025-10-01 18:00:00', '02:00:00', 'Kyiv', 'Lviv');

go
insert into Passengers (PassengerId, FirstName, LastName, PassportNumber) values
(1, 'Ivan', 'Petrenko', 'AB1234567'),
(2, 'Olena', 'Shevchenko', 'CD7654321'),
(3, 'Mykola', 'Koval', 'EF9876543'),
(4, 'Svitlana', 'Ivanova', 'GH5432167'),
(5, 'Andriy', 'Sydorenko', 'IJ6543210'),
(6, 'Nataliya', 'Tkachenko', 'KL3210987'),
(7, 'Viktor', 'Pavlenko', 'MN0987654'),
(8, 'Yulia', 'Hrytsenko', 'OP8765432'),
(9, 'Serhiy', 'Bondarenko', 'QR2345678'),
(10, 'Tetiana', 'Kravchenko', 'ST3456789');

go
insert into Tickets (TicketId, FlightId, PassengerId, SeatNumber, Price) values
(1, 1, 1, '1A', 100.00),
(2, 1, 2, '1B', 100.00),
(3, 2, 3, '2A', 150.00),
(4, 3, 1, '3A', 200.00),
(5, 3, 2, '3B', 200.00),
(6, 4, 4, '4A', 250.00),
(7, 5, 5, '5A', 300.00),
(8, 6, 6, '6A', 350.00),
(9, 7, 7, '7A', 400.00),
(10, 8, 8, '8A', 450.00),
(11, 9, 9, '9A', 500.00),
(12, 10, 10, '10A', 550.00);


select *
from Flights
where Destination = 'Lviv' and CAST(DepartureTime as date) = '2025-10-01'
order by DepartureTime;

select *
from Flights
where Duration = (select max(Duration) from Flights);

select *
from Flights
where Duration > '02:00:00';

select Destination, count(*) as FlightCount
from Flights
group by Destination;

select Destination
from Flights
group by Destination
having count(*) = (select max(FlightCount) from (select Destination, count(*) as FlightCount from Flights group by Destination) as FlightCounts);

select Destination, count(*) as FlightCount, (select count(*) from Flights) as TotalFlights
from Flights
where MONTH(DepartureTime) = 10
group by Destination;

select *
from Flights
where CAST(DepartureTime as date) = CAST(getdate() as date) and FlightId not in (select FlightId from Tickets)
and FlightId in (select FlightId from Tickets where SeatNumber like 'B%');

select sum(Price) as TotalRevenue, count(*) as TotalTickets
from Tickets
where CAST(BookingDate as date) = '2025-10-01';

select FlightId, count(*) as SoldTickets
from Tickets
where CAST(BookingDate as date) = '2025-10-01'
group by FlightId;

select FlightNumber, Destination
from Flights;


drop database Airport;