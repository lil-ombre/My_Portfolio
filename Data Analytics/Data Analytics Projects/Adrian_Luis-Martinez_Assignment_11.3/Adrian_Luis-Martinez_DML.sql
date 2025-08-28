/*
Adrian Luis-Martinez
Load Your Custom Database Assignment
DML SCRIPT
*/
SELECT * FROM clean_books_100;

## FILL AUTHOR TABLE
INSERT INTO AUTHOR
(Author_Name)
SELECT DISTINCT author_list FROM clean_books_100;

## FILL PUBLISHER TABLE
INSERT INTO PUBLISHER
(Publisher_Name)
SELECT DISTINCT publisher FROM clean_books_100;

SELECT * FROM PUBLISHER;

## FILL BOOK TABLE
INSERT INTO BOOK
(Title, ISBN, ISBN13, Average_Rating, Language_Code,
  Num_Pages, Ratings_Count, Text_Reviews_Count, Publication_Date)
SELECT 
title, isbn, isbn13, average_rating, language_code,
  num_pages, ratings_count, text_reviews_count, publication_date
FROM clean_books_100;

SELECT * FROM BOOK;

## FILL BOOK_AUTHOR TABLE
INSERT INTO BOOK_AUTHOR
(Book_ID, Author_ID)
SELECT DISTINCT b.Book_ID, a.Author_ID
FROM clean_books_100 AS cb
JOIN BOOK AS b ON cb.title = b.Title
JOIN AUTHOR AS a ON cb.author_list = a.Author_Name;

SELECT * FROM BOOK_AUTHOR;

## FILL BOOK_PUBLISHER TABLE
SHOW CREATE TABLE BOOK_PUBLISHER;

INSERT INTO BOOK_PUBLISHER (Book_ID, Publisher_ID)
SELECT DISTINCT b.Book_ID, p.Publisher_ID
FROM clean_books_100 AS cb
JOIN BOOK AS b ON cb.title = b.Title
JOIN PUBLISHER AS p ON cb.publisher = p.Publisher_Name;

SELECT * FROM BOOK_PUBLISHER;