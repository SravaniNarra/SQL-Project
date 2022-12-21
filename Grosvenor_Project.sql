create database Grosvenor;
use Grosvenor_new;

create table hotel(
hotel_no varchar(5) not null primary key,
hotel_name varchar(20) not null,
address varchar(50) not null
);

create table room(
room_no varchar(4) not null,
hotel_no varchar(5),
foreign key (hotel_no) references hotel(hotel_no),
type_of_room char(9) not null,
price decimal not null
);

create table booking(
hotel_no char(4),
room_no char(4),
foreign key (hotel_no) references hotel(hotel_no),
guest_no char(4) not null primary key,
from_date datetime not null,
to_date datetime not null
);


create table guest(
guest_no char(10),
foreign key (guest_no) references booking(guest_no),
guest_name varchar(20) not null,
guest_address varchar(50) not null
);


insert into hotel values
('H101','Grosvenor','London'),
('H102','Gateway','London'),
('H201','Grosvenor','New York'),
('H202','Plaza','New York'),
('H401','Grosvenor','Manchester'),
('H104','Grosvenor','London'),
('H105','Gateway','London'),
('H203','Grosvenor','sheffield'),
('H402','Plaza','New York'),
('H206','Grosvenor','Manchester');


select * from hotel;

Insert into room values
('201','H101','Single','30.5'),
('202','H101','Double','40.02'),
('203','H101','Single','30.5'),
('204','H101','Double','40.02'),
('205','H101','Double','40.02'),
('206','H101','Suite','100'),
('201','H102','Single','25'),
('202','H102','Double','30.5'),
('203','H102','Single','25'),
('204','H102','Double','30.5'),
('205','H102','Double','30.5'),
('206','H102','Suite','80'),
('201','H201','Single','80'),
('202','H201','Double','100'),
('203','H201','Single','80'),
('204','H201','Double','100'),
('205','H201','Double','100'),
('206','H201','Suite','300');

select * from room;

insert into booking values
('H101','201','1','2000-08-01','2000-08-04'),
('H101','201','2','2000-09-01','2000-09-04'),
('H401','202','3','1999-08-01','1990-08-04'),
('H105','203','4','2001-10-01','2001-10-04'),
('H112','204','5','2000-08-04','2000-08-06'),
('H401','202','6','2002-09-01','2002-09-04'),
('H112','202','7','2000-08-11','2000-08-12'),
('H402','203','8','2011-04-01','2011-04-04'),
('H105','201','9','2001-08-29','2001-08-30');


select * from booking;

insert into guest values
('1','John Smith','New York'),
('2','Mary Jones','London'),
('3','Thomas Smith','London'),
('4','Joseph Schmo','Greenwich'),
('5','Ima Sample','London'),
('6','Shesa Sample','New York'),
('7','George Seaver','London'),
('8','Jerome Koosman','Greenwich');

select * from guest;

update room set price=price*1.05;

create table booking_old(
hotel_no char(4),
room_no char(4),
foreign key (hotel_no) references hotel(hotel_no),
guest_no char(4) not null primary key,
from_date datetime not null,
to_date datetime not null
);

insert into booking_old(select * from booking where to_date<'2000-01-01');
delete from booking where to_date<'2000-01-01';

-- Simple Queries
/*1. List full details of all hotels*/

select * from hotel;

/*2. List full details of all hotels in London.*/

select * from hotel where address like'London';

/* 3.  List the names and addresses of all guests in London, alphabetically ordered by name.*/

select guest_name,guest_address from guest where guest_address like 'London' order by guest_name;

/*4. List all double or family rooms with a price below £40.00 per night, in ascending order of price.*/

select * from room where type_of_room='Double' and price<40 order by price;

/*List the bookings for which no date_to has been specified.*/

/*Ideally it is not possible to enter null value for to_date as we 
have declared to_date to be not null.  But query is to be written as below*/

select * from booking where to_date like ' ';

select * from booking where to_date is null;

-- Aggregate Functions

/*1. How many hotels are there?*/

select count(hotel_name) from hotel;

/*2. What is the average price of a room?*/

select avg(price) from room;

/*3. What is the total revenue per night from all double rooms?*/


select type_of_room,sum(price) as totalrevenue from room where type_of_room='Double';

/*4. How many different guests have made bookings for August?*/

select count(*) as august_booking from booking where month(from_date) = 08;

-- Subqueries and Joins

/*1. List the price and type of all rooms at the Grosvenor Hotel.*/

select type_of_room,price from room
inner join hotel on room.hotel_no=hotel.hotel_no
where hotel_name='grosvenor';


/*2. List all guests currently staying at the Grosvenor Hotel.*/

select g.guest_name,h.hotel_name from guest g
inner join booking b on g.guest_no=b.guest_no
inner join hotel h on b.hotel_no=h.hotel_no
where h.hotel_name='grosvenor' and from_date<=current_date() and
to_date>=current_date();


/*3. List the details of all rooms at the Grosvenor Hotel, including the name of the guest staying in the

room, if the room is occupied.*/

-- Note - Here I have given data all are preoccupied hence not added any condition.

select g.guest_name,r.type_of_room,r.price from room r
left join booking b on r.room_no=b.room_no
left join guest g on b.guest_no=g.guest_no
where g.guest_name is not null;


/*4. What is the total income from bookings for the Grosvenor Hotel today?*/

select sum(price) as totalincome from room r
inner join booking b on r.room_no=b.room_no
where from_date=sysdate();

/*5. List the rooms that are currently unoccupied at the Grosvenor Hotel.*/
select * from room;
select * from booking;

select r.* from room r
where r.room_no not in (select b.room_no from booking b);


/*6. What is the lost income from unoccupied rooms at the Grosvenor Hotel?*/

select sum(price) as lostincome from room r
where r.room_no not in (select b.room_no from booking b);

-- Grouping

/*1. List the number of rooms in each hotel.*/

select h.hotel_name, count(r.room_no) as NumofRooms from hotel h
inner join room r on h.hotel_no=r.hotel_no
group by h.hotel_name;

/*2. List the number of rooms in each hotel in London.*/

select h.hotel_name, count(r.room_no) as NumofRooms,h.address from hotel h
inner join room r on h.hotel_no=r.hotel_no
where h.address='London'
group by hotel_name;

/*3. What is the average number of bookings for each hotel in August?*/

select avg(guest_no) as avg_booking from booking where month(from_date) = 08;

/*4. What is the most commonly booked room type for each hotel in London?*/

select r.type_of_room  from room r
where r.room_no in (select b.room_no from booking b)
group by r.type_of_room;

/*5. What is the lost income from unoccupied rooms at each hotel today?*/

select r.type_of_room,r.price as lostincome from room r
where r.room_no not in (select b.room_no from booking b
where b.from_date=sysdate() 
);