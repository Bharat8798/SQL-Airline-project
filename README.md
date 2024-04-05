# SQL-Airline-project
Air Cargo is an aviation company that provides air transportation services for passengers and freight. 
Air Cargo uses its aircraft to provide different services with the help of partnerships or alliances with other airlines. 
The company wants to prepare reports on regular passengers, busiest routes, ticket sales details, and other scenarios to improve the ease of travel and booking for customers.
Create an ER diagram for the given airlines database.
Write a query to create route_details table using suitable data types for the fields, such as route_id, flight_num, origin_airport, destination_airport, aircraft_id, and distance_miles. Implement the check constraint for the flight number and unique constraint for the route_id fields. Also, make sure that the distance miles field is greater than 0.
Write a query to display all the passengers (customers) who have travelled in routes 01 to 25. Take data  from the passengers_on_flights table.
Write a query to identify the number of passengers and total revenue in business class from the ticket_details table.
Write a query to display the full name of the customer by extracting the first name and last name from the customer table.
Write a query to extract the customers who have registered and booked a ticket. Use data from the customer and ticket_details tables.
Write a query to identify the customer’s first name and last name based on their customer ID and brand (Emirates) from the ticket_details table.
Write a query to identify the customers who have travelled by Economy Plus class using Group By and Having clause on the passengers_on_flights table.
Write a query to identify whether the revenue has crossed 10000 using the IF clause on the ticket_details table.
Write a query to create and grant access to a new user to perform operations on a database.
Write a query to find the maximum ticket price for each class using window functions on the ticket_details table.
Write a query to extract the passengers whose route ID is 4 by improving the speed and performance of the passengers_on_flights table.
 For the route ID 4, write a query to view the execution plan of the passengers_on_flights table.
Write a query to calculate the total price of all tickets booked by a customer across different aircraft IDs using rollup function.
Write a query to create a view with only business class customers along with the brand of airlines.
Write a query to create a stored procedure to get the details of all passengers flying between a range of routes defined in run time. Also, return an error message if the table doesn't exist.
Write a query to create a stored procedure that extracts all the details from the routes table where the travelled distance is more than 2000 miles.
Write a query to create a stored procedure that groups the distance travelled by each flight into three categories. The categories are, short distance travel (SDT) for >=0 AND <= 2000 miles, intermediate distance travel (IDT) for >2000 AND <=6500, and long-distance travel (LDT) for >6500.
Write a query to extract ticket purchase date, customer ID, class ID and specify if the complimentary services are provided for the specific class using a stored function in stored procedure on the ticket_details table.
Condition:

If the class is Business and Economy Plus, then complimentary services are given as Yes, else it is No
    20. Write a query to extract the first record of the customer whose last name ends with Scott using a cursor from the customer table.
