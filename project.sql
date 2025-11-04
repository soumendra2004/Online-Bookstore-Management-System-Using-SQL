--Create tables

DROP TABLE IF EXISTS Books;
CREATE TABLE Books(
	Book_ID SERIAL PRIMARY KEY,
	Title VARCHAR(100),
	Author VARCHAR(100),
	Genre VARCHAR(100),
	Published_Year INT,
	Price NUMERIC(10,2),
	stock INT
);
SELECT * FROM Books;
DROP TABLE IF EXISTS customers;
CREATE TABLE Customers(
	Customer_ID SERIAL PRIMARY KEY,
	Name VARCHAR(100),
	Email VARCHAR(100),
	Phone VARCHAR(15),
	City VARCHAR(50),
	Country VARCHAR(150)
);
SELECT * FROM Customers;
DROP TABLE IF EXISTS orders;
CREATE TABLE Orders (
	Order_ID SERIAL PRIMARY KEY,
	Customer_ID INT REFERENCES Customers(Customer_ID),
	Book_ID INT REFERENCES Books(Book_ID),
	Order_Date Date,
	Quantity INT,
	Total_Amount NUMERIC(10,2)
);

SELECT * FROM Orders;

COPY
Orders(Order_ID, Customer_ID,Book_ID ,Order_Date, Quantity, Total_Amount)
FROM 'C:/Users\dasso/Downloads/Orders.csv'
DELIMITER','
CSV HEADER;
	
--1.) Retrieve all Books in the "Fiction" genre:
SELECT * FROM Books
WHERE Genre='Fiction';

--2.) books  Published After the year 1950:
SELECT * FROM Books
WHERE published_year>1950;

--3.)List all customers from Canada:
SELECT * FROM Customers
WHERE country='Canada';

--4.)Orders Placed in November 2023:
SELECT * FROM Orders
WHERE Order_date BETWEEN '2023-11-01' AND '2023-11-30';

--5) Retrieve the total stock of books available:
SELECT SUM(stock) AS Total_Stock
From Books;

--6)Details of the most Expensive Book:
SELECT * FROM Books ORDER BY Price;
SELECT * FROM Books ORDER BY Price DESC;
SELECT * FROM Books ORDER BY Price DESC LIMIT 1;

--7)All the Customers Who Ordered More Than 1 quantity of a book:
SELECT * FROM Orders
WHERE quantity>1;

--8)Retrieve All the orders Where the total amount exceeds $20:
SELECT * FROM Orders
WHERE total_amount>20;

--9)List all the genres avaliable in the Books Table:
SELECT DISTINCT genre FROM Books;

--10) The Book with the Lowest Stock:
SELECT * FROM Books ORDER BY stock;
SELECT * FROM Books ORDER BY stock ASC;
SELECT * FROM Books ORDER BY stock ASC LIMIT 1;

--11)Calculate The Total Revenue generated From All Orders:
SELECT SUM(total_amount) AS Revenue FROM Orders;

--1)Retrieve The total number of books sold for each genre:
SELECT * FROM Orders;
SELECT b.Genre,SUM(O.quantity) AS Total_Books_sold
FROM Orders O
Join Books b ON O.book_id=b.book_id
GROUP BY b.Genre;

--2)avg Price of books in the 'Fantasy' genre:
SELECT AVG(price) AS Average_Price
FROM Books
WHERE Genre='Fantasy';

--3)List Customers who have placed at least 2 orders:
SELECT o.customer_id,c.name,COUNT(o.Order_id) AS ORDER_COUNT
FROM orders o
JOIN customers c ON o.customer_id=c.customer_id
GROUP BY o.customer_id,c.name
HAVING COUNT(Order_id)>=2;

--4)Most frequently Ordered Book:
SELECT o.Book_id,b.title,COUNT(o.order_id)AS ORDER_COUNT
FROM orders o
JOIN books b ON o.book_id=b.book_id
GROUP BY o.book_id,b.title
ORDER BY ORDER_COUNT DESC LIMIT 1;

--5)Show The Top 3 Most Expensive Books Of 'Fantasy' Genre:
SELECT * FROM books
WHERE genre='Fantasy'
ORDER BY price DESC LIMIT 3;

--6)Retrieve The total quantity of books sold by each author:
SELECT b.author,SUM(o.quantity) AS Total_Books_Sold
FROM ORDERS o
JOIN books b ON o.book_id=b.book_id
GROUP BY b.Author;

--7)LIST the cities where customers who spent over $30 are located:
SELECT c.city
FROM orders o
JOIN customers c ON o.customer_id=c.customer_id
WHERE o.total_amount>30;

SELECT DISTINCT c.city ,total_amount
FROM orders o
JOIN customers c ON o.customer_id=c.customer_id
WHERE o.total_amount>30;

--8)Customers who spent the Most on orders:
SELECT c.customer_id,c.name,SUM(o.total_amount) AS Total_Spent
FROM orders o
JOIN customers c ON o.customer_id=c.customer_id
GROUP BY c.customer_id,c.name
ORDER BY Total_spent DESC LIMIT 1;

--9)Calculate the stock remaining after fullfilling all orders:

SELECT b.book_id,b.title,b.stock,COALESCE(SUM(o.quantity),0)AS Order_quantity,
	b.stock-COALESCE(SUM(o.quantity),0)AS Remaining_Quantity
FROM books b
LEFT JOIN orders o ON b.book_id=o.book_id
GROUP BY b.book_id;

SELECT b.book_id,b.title,b.stock,COALESCE(SUM(o.quantity),0)AS Order_quantity,
	b.stock-COALESCE(SUM(o.quantity),0)AS Remaining_Quantity
FROM books b
LEFT JOIN orders o ON b.book_id=o.book_id
GROUP BY b.book_id ORDER BY book_id;