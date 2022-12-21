-- List full details of all hotels.
 SELECT * FROM Hotel;
-- List full details of all hotels in London.
SELECT * FROM Hotel WHERE city = ‘London’;
-- List the names and addresses of all guests in London, alphabetically ordered by name.
 SELECT guestName, guestAddress FROM Guest WHERE address LIKE ‘%London%’
 ORDER BY guestName;
-- Strictly speaking, this would also find rows with an address like: ‘10 London Avenue, New York’.
-- List all double or family rooms with a price below £40.00 per night, in ascending order of price.
 SELECT * FROM Room WHERE price < 40 AND type IN (‘D’, ‘F’)
 ORDER BY price;
-- (Note, ASC is the default setting).
-- List the bookings for which no dateTo has been specified.
 SELECT * FROM Booking WHERE dateTo IS NULL;

#Aggregate Functions
-- How many hotels are there?
 SELECT COUNT(*) FROM Hotel;
-- What is the average price of a room?
 SELECT AVG(price) FROM Room;
-- What is the total revenue per night from all double rooms?
 SELECT SUM(price) FROM Room WHERE type = ‘D’;
-- How many different guests have made bookings for August?
 SELECT COUNT(DISTINCT guestNo) FROM Booking
 WHERE (dateFrom <= DATE’2004-08-01’ AND dateTo >= DATE’2004-08-01’) OR
 (dateFrom >= DATE’2004-08-01’ AND dateFrom <= DATE’2004-08-31’);

#Subqueries and Joins
-- List the price and type of all rooms at the Grosvenor Hotel.
 SELECT price, type FROM Room
 WHERE hotelNo =
 (SELECT hotelNo FROM Hotel
 WHERE hotelName = ‘Grosvenor_Hotel’);
-- List all guests currently staying at the Grosvenor Hotel.
 SELECT * FROM Guest
 WHERE guestNo =
 (SELECT guestNo FROM Booking
 WHERE dateFrom <= CURRENT_DATE AND
 dateTo >= CURRENT_DATE AND
 hotelNo =
 (SELECT hotelNo FROM Hotel
 WHERE hotelName = ‘Grosvenor_Hotel’));
-- List the details of all rooms at the Grosvenor Hotel, including the name of the guest staying in the room, if the room is occupied.
 SELECT r.* FROM Room r LEFT JOIN
 (SELECT g.guestName, h.hotelNo, b.roomNo FROM Guest g, Booking b, Hotel h
 WHERE g.guestNo = b.guestNo AND b.hotelNo = h.hotelNo AND
 hotelName= ‘Grosvenor_Hotel’ AND
 dateFrom <= CURRENT_DATE AND
 dateTo >= CURRENT_DATE) AS XXX
 ON r.hotelNo = XXX.hotelNo AND r.roomNo = XXX.roomNo;
-- List the number of rooms in each hotel.
 SELECT hotelNo, COUNT(roomNo) AS count FROM Room
 GROUP BY hotelNo;
-- List the number of rooms in each hotel in London.
 SELECT hotelNo, COUNT(roomNo) AS count FROM Room r, Hotel h
 WHERE r.hotelNo = h.hotelNo AND city = ‘London’
 GROUP BY hotelNo; 