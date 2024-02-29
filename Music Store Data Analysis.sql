-- Q1. WHO IS THE SENIOR MOST EMPLOYEE BASED ON JOB TITLE?
SELECT * FROM employee
ORDER BY levels DESC
LIMIT 1;

-- Q2. Which countries have the most Invoices?
SELECT billing_country AS country,COUNT(*) AS invoices
 FROM invoice
 GROUP BY billing_country
 ORDER BY COUNT(*) DESC;
 
 -- Q3.What are top 3 values of total invoice?
SELECT total as total_invoice FROM invoice
ORDER BY total DESC
LIMIT 3;

-- Q4. Which city has the best customers? We would like to throw a promotional Music Festival in the city we made the most money. 
-- Write a query that returns one city that has the highest sum of invoice totals. 
-- Return both the city name & sum of all invoice totals
SELECT billing_city AS city,SUM(total) 'invoice total' FROM invoice
GROUP BY billing_city
ORDER BY SUM(total) DESC
LIMIT 1;

-- Q5. Who is the best customer? The customer who has spent the most money will be declared the best customer. 
-- Write a query that returns the person who has spent the most money

SELECT c.customer_id,c.first_name,c.last_name,ROUND(SUM(total),2) AS most_spent FROM invoice i
JOIN customer c ON 
i.customer_id = c.customer_id
GROUP BY c.customer_id,c.first_name,c.last_name
ORDER BY SUM(total) DESC
LIMIT 1;

-- Q6.Write query to return the email, first name, last name, & Genre of all Rock Music listeners. 
-- Return your list ordered alphabetically by email starting with A?
SELECT first_name,last_name,email FROM customer
JOIN invoice ON customer.customer_id = invoice.customer_id
JOIN invoice_line ON invoice.invoice_id = invoice_line.invoice_id
WHERE track_id IN ( SELECT track_id FROM track
						JOIN genre ON track.genre_id = genre.genre_id
                        WHERE genre.name LIKE 'Rock')
ORDER BY customer.email;

-- Q7. Let's invite the artists who have written the most rock music in our dataset. 
-- Write a query that returns the Artist name and total track count of the top 10 rock bands.
SELECT artist.artist_id,artist.name,COUNT(artist.artist_id) 'NUMBER OF SONGS' FROM artist
JOIN album ON artist.artist_id = album.artist_id
JOIN track ON track.album_id = album.album_id
WHERE track_id IN (SELECT track_id FROM track
					JOIN genre ON track.genre_id = genre.genre_id
                    WHERE genre.name LIKE 'Rock')
GROUP BY artist.artist_id,artist.name
ORDER BY COUNT(artist.artist_id) DESC;

-- Q8. Return all the track names that have a song length longer than the average song length. 
-- Return the Name and Milliseconds for each track. Order by the song length with the longest songs listed first
SELECT name AS track_name,milliseconds FROM track
WHERE milliseconds > (SELECT AVG(milliseconds) FROM track)
ORDER BY milliseconds DESC;

-- Q9. Find how much amount spent by each customer on artists? Write a query to return customer name, artist name and total spent */
-- /* Steps to Solve: First, find which artist has earned the most according to the InvoiceLines. Now use this artist to find 
-- which customer spent the most on this artist. For this query, you will need to use the Invoice, InvoiceLine, Track, Customer, 
-- Album, and Artist tables. Note, this one is tricky because the Total spent in the Invoice table might not be on a single product, 
-- so you need to use the InvoiceLine table to find out how many of each product was purchased, and then multiply this by the price
-- for each artist./*

WITH artist_selling AS (SELECT artist.artist_id as id,artist.name as artist_name,ROUND(SUM(invoice_line.unit_price * invoice_line.quantity),2) AS atrist_sell FROM artist
	JOIN album ON artist.artist_id = album.artist_id
	JOIN track ON album.album_id = track.album_id
	JOIN invoice_line ON track.track_id = invoice_line.track_id
	GROUP BY artist.artist_id ,artist.name
	ORDER BY SUM(invoice_line.unit_price * invoice_line.quantity) DESC
	LIMIT 1
)

SELECT c.customer_id, c.first_name, c.last_name, bsa.artist_name, SUM(il.unit_price*il.quantity) AS amount_spent
FROM invoice i
JOIN customer c ON c.customer_id = i.customer_id
JOIN invoice_line il ON il.invoice_id = i.invoice_id
JOIN track t ON t.track_id = il.track_id
JOIN album alb ON alb.album_id = t.album_id
JOIN artist_selling bsa ON bsa.id = alb.artist_id
GROUP BY 1,2,3,4
ORDER BY 5 DESC;

--  Q10. We want to find out the most popular music Genre for each country. We determine the most popular genre as the genre 
-- with the highest amount of purchases. Write a query that returns each country along with the top Genre. For countries where 
-- the maximum number of purchases is shared return all Genres.
SELECT genre.genre_id as id,genre.name as music_genre,invoice.billing_country as country,COUNT(genre.genre_id) as purchases FROM genre
JOIN track ON genre.genre_id = track.genre_id
JOIN invoice_line ON track.track_id = invoice_line.track_id
JOIN invoice ON invoice_line.invoice_id = invoice.invoice_id
GROUP BY genre.genre_id,genre.name,invoice.billing_country
ORDER BY genre.genre_id,invoice.billing_country,COUNT(genre.genre_id);

-- Q11. Write a query that determines the customer that has spent the most on music for each country. 
-- Write a query that returns the country along with the top customer and how much they spent. 
-- For countries where the top amount spent is shared, provide all customers who spent this amount.
SELECT customer.customer_id,first_name,last_name,billing_country AS country,ROUND(SUM(total),2) AS most_spend FROM customer
JOIN invoice ON customer.customer_id = invoice.customer_id 
GROUP BY customer.customer_id,first_name,last_name,billing_country
ORDER BY most_spend DESC
--
-- AMJAD THE ANALYST ---------------------------------------
