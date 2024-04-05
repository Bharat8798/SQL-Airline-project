CREATE DATABASE airlines
USE airlines
ALTER TABLE customer
ADD CONSTRAINT PK_customer PRIMARY KEY(customer_id);


ALTER TABLE passengers_on_flights
ADD CONSTRAINT FK_passengers_on_flights
FOREIGN KEY (customer_id) REFERENCES customer(customer_id);


ALTER TABLE ticket_details
ADD CONSTRAINT FK_ticket_details_customer
FOREIGN KEY (customer_id) REFERENCES customer(customer_id);



/*Write a query to create route_details table using suitable data types for the fields, 
such as route_id, flight_num, origin_airport, destination_airport, aircraft_id, and distance_miles. 
Implement the check constraint for the flight number and unique constraint for the route_id fields. 
Also, make sure that the distance miles field is greater than 0.
*/

CREATE TABLE route_details (
    r_id INT PRIMARY KEY,
    f_num INT NOT NULL,
    orgn_apt VARCHAR(50) NOT NULL,
    dstn_apt VARCHAR(50) NOT NULL,
    acft_id INT NOT NULL,
    distance INT CHECK(distance>0)
);

DELIMITER //

CREATE TRIGGER route_details_1
BEFORE INSERT ON route_details FOR EACH ROW
BEGIN
IF f_num <=0 THEN
SIGNAL SQLSTATE "45000"
SET message_text = "Flight number must be greater than zero";
END IF;
END//
DELIMITER ;



/*Write a query to display all the passengers (customers) who have travelled in routes 01 to 25. 
Take data  from the passengers_on_flights table.
*/

SELECT 
    customer_id
FROM
    passengers_on_flights
WHERE
    route_id BETWEEN 1 AND 25;
    
    
    
/*Write a query to identify the number of passengers and 
total revenue in business class from the ticket_details table
*/

SELECT 
    COUNT(customer_id),
    SUM(no_of_tickets * Price_per_ticket) AS TOTAL_REVENUE
FROM
    ticket_details
WHERE
    class_id = 'BUSSINESS';
    
    
    

/*Write a query to display the full name of the customer 
by extracting the first name and last name from the customer table.
*/


SELECT 
    CONCAT(first_name, ' ', last_name) AS FULL_NAME_OF_CUSTOMER
FROM
    customer;
    

/*Write a query to extract the customers who have registered and booked a ticket. 
Use data from the customer and ticket_details tables.
*/


SELECT 
  DISTINCT(CONCAT(first_name, ' ', last_name)) AS FULL_NAME 
FROM
    customer c
        INNER JOIN
    ticket_details t ON c.customer_id = t.customer_id;
    
    

/*Write a query to identify the customer’s first name and last name based on their customer ID 
and brand (Emirates) from the ticket_details table.
*/


SELECT 
    first_name, last_name
FROM
    customer C
        INNER JOIN
    ticket_details T ON C.customer_id = T.customer_id
WHERE
    brand = 'EMIRATES';
    
    
/*Write a query to identify the customers who have travelled by Economy Plus class 
using Group By and Having clause on the passengers_on_flights table.
*/



SELECT 
    customer_id
FROM
    passengers_on_flights
WHERE
    class_id = 'ECONOMY PLUS'
GROUP BY customer_id
HAVING COUNT(*) >= 1;


/*Write a query to identify whether the revenue has crossed 10000 
using the IF clause on the ticket_details table.
*/



SELECT 
    IF(SUM(no_of_tickets * Price_per_ticket) > 10000,
        'REVENUE CROSSED 10000',
        'REVENUE BELOW 10000') AS REVENUE
FROM
    ticket_details;
    
    
    
/*Write a query to create and grant access 
to a new user to perform operations on a database.
*/

-- Create a new user with a password
CREATE USER 'xyz'@'localhost:3306' IDENTIFIED BY 'local@123';

-- Grant permissions to the new user
GRANT SELECT, INSERT, UPDATE, DELETE ON airlines.* TO 'xyz'@'localhost:3306';

/*Write a query to find the maximum ticket price for each class 
using window functions on the ticket_details table.
*/


SELECT DISTINCT(class_id), 
MAX(Price_per_ticket) OVER(PARTITION BY class_id ) AS MAX_PRICE
FROM ticket_details;


/*Write a query to extract the passengers whose route ID is 4
 by improving the speed and performance 
 of the passengers_on_flights table.
*/
CREATE INDEX index_route ON passengers_on_flights(route_id);

SELECT 
    *
FROM
    passengers_on_flights
WHERE
    route_id = 4;

/* For the route ID 4, write a query to view the 
execution plan of the passengers_on_flights table.
*/
EXPLAIN
SELECT 
    *
FROM
    passengers_on_flights
WHERE
    route_id = 4;
    
    
/*Write a query to calculate the total price of all tickets booked by a customer 
across different aircraft IDs using rollup function.
*/


SELECT customer_id,
		SUM(Price_per_ticket) AS TOTAL_PRICE
FROM 
	ticket_details T

GROUP BY (1) WITH ROLLUP;



/*Write a query to create a view with only business class customers 
along with the brand of airlines.
*/

CREATE VIEW business_class AS
    SELECT 
        customer_id, brand
    FROM
        ticket_details
    WHERE
        class_id = 'Bussiness';
        
        
-- QUERY TO VIEW THE RESULT OF  CREATED VIEW

SELECT * FROM business_class;

/*Write a query to create a stored procedure to get the details of all passengers 
flying between a range of routes defined in run time. 
Also, return an error message if the table doesn't exist.
*/

DROP PROCEDURE IF EXISTS details_of_passengers

DELIMITER //

CREATE PROCEDURE details_of_passengers(
    IN start_route INT,
    IN end_route INT
)
BEGIN
    DECLARE table_exists INT;

    -- Check if the table exists in the AIRLINES schema
    SELECT COUNT(*) INTO table_exists
    FROM information_schema.tables
    WHERE table_schema = 'airlines'
    AND table_name = 'passengers_on_flights';

    IF table_exists = 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Table "passengers_on_flights" does not exist in the AIRLINES schema';
    ELSE
        -- Table exists, fetch passenger details
        SELECT *
        FROM airlines.passengers
        WHERE route_id BETWEEN start_route AND end_route;
END IF;
END //

DELIMITER ;


/*Write a query to create a stored procedure that extracts all the details 
from the routes table where the travelled distance is more than 2000 miles.
*/

DELIMITER **
CREATE PROCEDURE route_detail()
BEGIN
SELECT 
    *
FROM
    routes
WHERE
    distance_miles > 2000;
END**
DELIMITER ;

CALL route_detail;


/*Write a query to create a stored procedure that groups the distance travelled by each flight into three categories. 
The categories are, short distance travel (SDT) for >=0 AND <= 2000 miles, 
intermediate distance travel (IDT) for >2000 AND <=6500,
 and long-distance travel (LDT) for >6500.
*/



DROP PROCEDURE IF EXISTS dist_travelled
DELIMITER **
CREATE PROCEDURE dist_travelled(IN f_num INT , OUT f_ctgry VARCHAR(50))
BEGIN
DECLARE dist INT DEFAULT 0;
DECLARE flight_ctgry int;
SELECT 
    distance_miles
INTO dist FROM
    routes
WHERE
    flight_num = f_num;
    
IF dist <= 2000 THEN
	SET f_ctgry = "Short Distance Travel (SDT)";
ELSEIF dist BETWEEN 2000 AND 6500 THEN
	SET f_ctgry = "Intermediate Distance Travel (IDT)";
ELSEIF dist >6500 THEN
	SET f_ctgry = "Long-Distance Travel (LDT)";
END IF;
END **
DELIMITER ;

CALL dist_travelled(1156, @f_ctgry);
SELECT @f_ctgry;




/*Write a query to extract ticket purchase date, customer ID, class ID and 
specify if the complimentary services are provided for the specific class 
using a stored function in stored procedure on the ticket_details table.
Condition:
If the class is Business and Economy Plus, 
then complimentary services are given as Yes, else it is No
*/

DELIMITER **
CREATE FUNCTION compservice(class VARCHAR(25)) 
RETURNS VARCHAR (10)
DETERMINISTIC
BEGIN

DECLARE service VARCHAR(50) DEFAULT " ";
IF class IN ("Bussiness"," Economy Plus") THEN
	SET service = "YES";
ELSE 
	SET service = "NO";
    END IF;
RETURN (service);
END **
DELIMITER ;


-- USING STORED FUNCTION IN STORED PROCEDURE
DELIMITER ==
CREATE PROCEDURE ticket_details()
BEGIN
SELECT 
    p_date,
    customer_id,
    class_id,
    compservice(class_id) AS complimentary_service
FROM
    ticket_details;
END ==
DELIMITER ;

CALL ticket_details;


/*Write a query to extract the first record of the customer 
whose last name ends with Scott using a cursor 
from the customer table.*/


DELIMITER //
CREATE PROCEDURE first_record()
BEGIN
DECLARE done INT DEFAULT 0;
DECLARE c_id INT;
DECLARE f_name VARCHAR(50);
DECLARE l_name VARCHAR(50);
DECLARE cursor_1 CURSOR FOR 
	SELECT 
    customer_id, first_name, last_name
FROM
    customer
WHERE
    last_name LIKE '%Scott'
    LIMIT 1;
    
DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

OPEN cursor_1;
FETCH cursor_1 INTO c_id, f_name, l_name;

IF NOT done THEN
        SELECT c_id, f_name, l_name;
    ELSE
        SELECT 'No customer with last name ending with Scott found.';
    END IF;

CLOSE cursor_1;
END//
DELIMITER ;

CALL first_record;
