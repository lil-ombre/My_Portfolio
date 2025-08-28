/*
Adrian Luis-Martinez
Load Your Custom Database Assignment
QUERY SCRIPT
*/

## 1.How many books does each author have
SELECT a.Author_Name, COUNT(*) AS book_count
FROM AUTHOR AS a
JOIN BOOK_AUTHOR AS ba ON a.Author_ID = ba.Author_ID
GROUP BY a.Author_Name;

## 2.Top 5 books with the highest average rating
SELECT Title, Average_Rating
FROM BOOK
ORDER BY Average_Rating DESC
LIMIT 5;

## 3.TOP 5 Books with the most pages
SELECT Title, Num_Pages
FROM BOOK
ORDER BY Num_Pages DESC
LIMIT 5;

## 4. Number of books published by each publisher
SELECT p.Publisher_Name, COUNT(*) AS total_books
FROM PUBLISHER AS p
JOIN BOOK_PUBLISHER AS bp ON p.Publisher_ID = bp.Publisher_ID
GROUP BY p.Publisher_Name
ORDER BY total_books DESC;

## 5. Average rating by language 
SELECT Language_Code, AVG(Average_Rating) AS avg_rating
FROM BOOK
GROUP BY Language_Code
ORDER BY avg_rating DESC;