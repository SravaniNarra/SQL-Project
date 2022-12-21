/*Calculate average Unit Price for each CustomerId.*/

select c.CustomerID, p.ProductID,productname,
avg(od.unitprice) over(partition by c.CustomerID  order by od.orderid)Average_unit_price from order_details od
inner join orders o on o.orderid=od.OrderID
inner join customers c on o.CustomerID=c.CustomerID
inner join products p on od.ProductID=p.ProductID;

/*Calculate average Unit Price for each group of CustomerId AND EmployeeId.*/

SELECT c.CustomerId, 
       o.EmployeeId, 
       AVG(od.UnitPrice) OVER (PARTITION BY c.CustomerId, o.EmployeeId) AvgUnitPrice
from customers c inner join orders o on c.CustomerID=o.CustomerID
inner join order_details od on o.OrderID=od.OrderID;



/*Rank Unit Price in descending order for each CustomerId.*/

select c.customerid,od.unitprice,rank() over(partition by c.customerid order by od.unitprice desc)Unit_Rank from customers c
inner join orders o on c.customerid=o.customerid
inner join order_details od on o.orderid=od.orderid;

/*How can you pull the previous order date’s Quantity for each ProductId.*/

SELECT ProductId, 
       OrderDate, 
       Quantity, 
       LAG(Quantity) OVER (PARTITION BY ProductId ORDER BY OrderDate) AS Previous_orderdate_quantity
FROM Orders
INNER JOIN Order_Details ON orders.OrderID = Order_Details.OrderId;

/*How can you pull the following order date’s Quantity for each ProductId.*/

SELECT ProductId, 
       OrderDate, 
       Quantity, 
       lead(Quantity) OVER (PARTITION BY ProductId ORDER BY OrderDate) AS Following_orderdate_quantity
FROM Orders
INNER JOIN Order_Details ON orders.OrderID = Order_Details.OrderId;


/*Pull out the very first Quantity ever ordered for each ProductId.*/

SELECT ProductId, 
       OrderDate, 
       Quantity, 
       FIRST_VALUE(Quantity) OVER (PARTITION BY ProductId ORDER BY OrderDate) AS "FirstValue"
FROM Orders o
INNER JOIN Order_Details od ON o.orderid = od.orderid;

/*Calculate a cumulative moving average UnitPrice for each CustomerId.*/

SELECT CustomerId, 
       UnitPrice, 
       AVG(UnitPrice) OVER (PARTITION BY CustomerId 
       ORDER BY CustomerId 
       ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS Cum_Avg
FROM Orders o
INNER JOIN Order_Details od ON o.orderid = od.orderid;


/*
1. Can you define a trigger that is invoked automatically before a new row is inserted into a table?

Trigger: A trigger is a stored procedure in database which automatically invokes whenever a special event
in the database occurs. For example, a trigger can be invoked when a row is inserted into a 
specified table or when certain table columns are being updated.*/

# Below is trigger to be invoked if any new department name is entered.
DELIMITER //  
Create Trigger before_insert_department
BEFORE INSERT ON departments FOR EACH ROW   
BEGIN  
IF NEW.dept_name = 'HR' THEN SET NEW.dept_name = 'Human Resources';  
END IF;  
END //  

insert into departments values ('d003','HR');

/*
What are the different types of triggers?

There are 6 different types of triggers in MySQL:

1. Before Update Trigger: It is a trigger which occurs before an update is invoked. 
If we write an update statement, then the actions of the trigger will be performed before the update 
is implemented.
2. After Update Trigger: It is a trigger which occurs after an update is done. 
If we write an update statement, then the actions of the trigger will be performed after the update 
is implemented.
3. Before Insert Trigger: This trigger invokes before an insert statement is executed.
4. After Insert Trigger:This trigger invokes before an insert statement is executed.
5. Before Delete Trigger:As the name implies, this trigger occurs before deletion statement is implemented.
6. AFter Delete Trigger : As the name implies, this trigger occurs after deletion statement is implemented.

How is Metadata expressed and structured?

Metadata is “the data about the data.” Anything that describes the database.

Representation of metadata must satisfy these requirements:

All metadata must be in the same character set. Otherwise, neither the SHOW statements nor SELECT statements for tables in INFORMATION_SCHEMA would work properly because different rows in the same column of the results of these operations would be in different character sets.

Metadata must include all characters in all languages. Otherwise, users would not be able to name columns and tables using their own languages.

To satisfy both requirements, MySQL stores metadata in a Unicode character set, namely UTF-8. This does not cause any disruption if you never use accented or non-Latin characters. But if you do, you should be aware that metadata is in UTF-8.

The metadata requirements mean that the return values of the USER(), CURRENT_USER(), SESSION_USER(), SYSTEM_USER(), DATABASE(), and VERSION() functions have the UTF-8 character set by default.

The server sets the character_set_system system variable to the name of the metadata character set:

SHOW VARIABLES LIKE 'character_set_system';
+----------------------+---------+
| Variable_name        | Value   |
+----------------------+---------+
| character_set_system | utf8mb3 |
+----------------------+---------+


Explain RDS and AWS key management services.

RDS is a service provided by amazon which stands for Relational Data Base Service.
We can use amazon RDS to set up, operate, and scale a relational database in the cloud. 
Optionally, we can choose to encrypt the data stored on your Amazon RDS DB instance.

We can use AWS KMS to encrypt data across your AWS workloads, digitally sign data, encrypt within your  applications using AWS Encryption SDK, 
and generate and verify message authentication codes.

AWS Key Management Service (AWS KMS) lets you create, manage, and control cryptographic keys 
across our applications and more than 100 AWS services.



What is the difference between amazon EC2 and RDS?

 RDS automatically manages time-consuming tasks such as configuration, backups, and patches, 
 you can focus on building your application. It is cost effective solution as AWS takes full 
 responsibility for our database and it is easy to setup.RDS is a highly available relational database.
 
 Amazon EC2 cloud computing platform lets user create as many virtual servers as they need. 
 We should manually configure security, networking and manage the stored data.
 EC2 gives us full control over our database, OS and software stack.EC2 we should setup the database for high availability.
 
 If an automated and cost-effective solution is needed, we can choose RDS. Whereas, if we look out 
 for more control and flexibility, in that case we can go for EC2.



*/