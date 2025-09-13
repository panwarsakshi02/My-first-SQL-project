CREATE  DATABASE learning;
USE learning;
DROP TABLE IF exists books;
CREATE TABLE books(
Book_id INT PRIMARY KEY,
Titel VARCHAR(100),
Author VARCHAR(100),
Genre VARCHAR(50),
Published_year INT,
Price NUMERIC(10,2),
Stock INT
); 
DROP TABLE IF exists customers;
CREATE  TABLE Customers(
customer_ID INT PRIMARY KEY,
NAME VARCHAR(100),
Email VARCHAR(100),
phone VARCHAR (15),
city VARCHAR(100),
country VARCHAR (150),
);
DROP TABLE IF exists orders;
CREATE  TABLE Orders(
Order_ID INT PRIMARY KEY,
customer_ID INT REFERENCES customers(customer_ID),
Book_Id INT REFERENCES Books(book_ID),
Order_Date DATE,
Quantity INT,
Total_Amount NUMERIC(10,2)
);
--Insert data in books Table
BULK INSERT dbo.books
FROM 'C:\Users\Solan\OneDrive\Desktop\Books.csv' -- Path is from the server's point of view
WITH
(
    FIRSTROW = 2, -- Use this to skip the header row
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n', -- Or '\r\n' for Windows-style line endings
    TABLOCK
);
--Insert data in customers  Table
BULK INSERT dbo.customers
FROM'C:\Users\Solan\OneDrive\Desktop\Customers.csv' -- Path is from the server's point of view
WITH
(
    FIRSTROW = 2, -- Use this to skip the header row
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n', -- Or '\r\n' for Windows-style line endings
    TABLOCK
);

--Insert data in Orders Table
BULK INSERT dbo.Orders
FROM 'C:\Users\Solan\OneDrive\Desktop\Orders.csv' -- Path is from the server's point of view
WITH
(
    FIRSTROW = 2, -- Use this to skip the header row
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n', -- Or '\r\n' for Windows-style line endings
    TABLOCK
);

SELECT * FROM Books;
SELECT * FROM customers;
SELECT * FROM orders;



--1) retrieve all books in the fiction genere:
SELECT * FROM Books
WHERE Genre = 'Fiction';
--2) find book published after the year 1950:
SELECT * FROM Books
WHERE Published_year > '1950';
--3) list of customers from canada:
SELECT * FROM customers
WHERE country = 'canada';
-- 4) show orders placed in november 2023
SELECT * FROM orders
WHERE order_date between '2023-11-01' and '2023-11-30' ;
-- 5) retrieve the total stocks of books available:
SELECT SUM(stock) AS Total_stocks
FROM books;
--6) find the details of the most expensive books:
SELECT TOP 5  * FROM books
ORDER BY Price DESC
--7) show all customer who ordered more than 1 quantity of book:
SELECT * FROM Orders
WHERE Quantity > 1;
--8) retrieve all orders where the total amount exceeds $20
SELECT * FROM Orders
WHERE Total_Amount > 20;
--9) list all geners available in the books stables
SELECT DISTINCT genre FROM books;
--10) find the book with the lowest stocks:
SELECT TOP 10 *FROM  Books
ORDER BY stock ASC;
--11) calculate the total revenue generated from all orders:
SELECT SUM(Total_Amount) AS revenue FROM orders;
--Advance Questions:
--1) retrieve the total number of books sold for each genre:
SELECT
    b.Genre,                     -- Get the genre from the books table
    SUM(o.Quantity) AS TotalQuantityOrdered -- Sum the quantity from the orders table
FROM
    books AS b                   -- Alias 'books' as 'b' for brevity
JOIN
    orders AS o ON b.Book_Id = o.Book_Id -- Join books and orders on the Book_Id
GROUP BY
    b.Genre; 

-- JOIN
SELECT books.genre,SUM(orders.quantity) AS Total_books_sold
FROM books
JOIN orders
ON books.book_id = orders.book_id
GROUP BY books.genre
ORDER BY total_books_sold DESC
--2) find the average price of books in the "fantasy" genre:
SELECT AVG(price) AS Average_price
FROM books
WHERE genre = 'fantasy'
--3) list of customer who have placed at least 2 orders:
SELECT 
    c.Customer_ID,
    c.Name,
    COUNT(o.order_ID) AS Number_of_orders
FROM customers c
INNER JOIN Orders o ON c.customer_ID = o.customer_ID
GROUP BY c.Customer_ID, c.Name
HAVING COUNT(o.order_ID) >= 2
ORDER BY c.Name;

--4) find the most frequently orderded book:
SELECT Top 10 book_id ,count(order_id) AS order_count
FROM orders
GROUP BY book_id
ORDER BY order_count DESC
--5) show the top 3 most expensive books of 'fantasy' genre:
SELECT top 3  * From books
WHERE genre = 'fantasy'
ORDER BY price DESC;
--6) retrieve the total quantity of book sold by each author:
SELECT b.author,sum(o.quantity) AS Total_Books_sold
From Orders o
JOIN books b ON o.book_Id = b.book_id
Group By b.Author;
--7) list the cities where customer who spent over $30 are located:
SELECT distinct c.city , total_amount
FROM Orders o
JOIN Customers c ON o.Customer_id = c.Customer_id
WHERE o.Total_Amount > 30;

--8) find the coustumer who spent the most on orders:
SELECT top 10 c.Customer_id,NAME,total_amount
FROM Orders o
JOIN Customers c ON o.Customer_id = c.Customer_id 
ORDER BY Total_Amount DESC;

--9)calculate the stock remaining after fulfilling all orders:
SELECT b.Book_Id ,b.titel ,b.stock, COALESCE (SUM(quantity),0) AS order_Quantity
FROM books b
LEFT JOIN orders o ON b.book_Id = o.book_Id
GROUP BY
b.book_Id,
b.titel,
b.stock;

 ------END--------   





