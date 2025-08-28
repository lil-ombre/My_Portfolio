#######################################################
# Adrian Luis-Martinez
# Assignment 3: RESTful API Implementation
# SQL Queries
#######################################################

### 1. Select query to retrieve all books from the inventory
SELECT * FROM books;

### 2. Add a new book to the inventory
## Create new book and insert into books table first
INSERT INTO books (title, isbn, published_year, price, publisher_id)
VALUES ('new book', '123XYZ', 2003, 20.00, 1);
## Insert new book into inventory after
INSERT INTO inventory (book_id, quantity, location)
VALUES (LAST_INSERT_ID(), 5, 'Warehouse D');

### 3. Select query to retrieve details of a specific book using its ID (using book_id 1 for example).
SELECT * FROM books
WHERE book_id = 1;

### 4. Update query to change the quantity of a particular book in the inventory
## updating  quantity for book_id 1 as an example
UPDATE inventory
SET quantity = 30
WHERE book_id = 1;

### 5. Delete query to remove a book from the inventory. using book_id 1 as an example
DELETE FROM inventory
WHERE book_id = 1;
