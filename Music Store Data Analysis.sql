Who is the senior most employee based on job title?
SELECT * FROM employee
ORDER BY levels DESC
LIMIT 1;

Which countries have the most Invoices?
select count(*), billing_country from invoice
group by billing_country
order by count(*) desc

What are top 3 values of total invoice?
SELECT total FROM invoice
ORDER BY total DESC
LIMIT 3

Which city has the best customers? We would like to throw a promotional Music
Festival in the city we made the most money. Write a query that returns one city that
has the highest sum of invoice totals. Return both the city name & sum of all invoice
totals
SELECT billing_city, SUM(total) FROM invoice
GROUP BY billing_city
ORDER BY sum(total) DESC
LIMIT 1

Who is the best customer? The customer who has spent the most money will be
declared the best customer. Write a query that returns the person who has spent the
most money
select customer.customer_id, customer.first_name, customer.last_name, sum(total) from invoice
inner join customer
on invoice.customer_id=customer.customer_id
group by customer.customer_id
ORDER BY sum(total) DESC
LIMIT 1

Write query to return the email, first name, last name, & Genre of all Rock Music
listeners. Return your list ordered alphabetically by email starting with A
select distinct first_name, last_name, email from customer
inner join invoice on customer.customer_id=invoice.customer_id
inner join invoice_line on invoice.invoice_id = invoice_line.invoice_id
where track_id in (select track.track_id from genre
inner join track on genre.genre_id=track.genre_id
where genre.name = 'Rock')	

select distinct first_name, last_name, email from customer
inner join invoice on customer.customer_id=invoice.customer_id
inner join invoice_line on invoice.invoice_id = invoice_line.invoice_id
inner join track on invoice_line.track_id=track.track_id
inner join genre on genre.genre_id=track.genre_id
where genre.name = 'Rock'


Let's invite the artists who have written the most rock music in our dataset. Write a
query that returns the Artist name and total track count of the top 10 rock bands
select artist.name, count(track.track_id) as track_id_count from artist
inner join album on artist.artist_id=album.artist_id
inner join track on album.album_id=track.album_id
group by artist.name
order by track_id_count desc


Return all the track names that have a song length longer than the average song length.
Return the Name and Milliseconds for each track. Order by the song length with the
longest songs listed first
select name, milliseconds from track
where milliseconds>(select avg(milliseconds) from track)
order by milliseconds desc


Find how much amount spent by each customer on artists? Write a query to return
customer name, artist name and total spent
with best_selling_artist as (
	select artist.artist_id, artist.name as artist_name, 
	sum(invoice_line.unit_price*invoice_line.quantity)
	from invoice_line
	inner join track on track.track_id = invoice_line.track_id
	inner join album on album.album_id=track.album_id
	inner join artist on artist.artist_id=album.artist_id
	group by artist.artist_id
	order by sum(invoice_line.unit_price*invoice_line.quantity) desc
	limit 1)
select c.customer_id, c.first_name, c.last_name,
bsa.artist_name, sum(il.unit_price*il.quantity)
from invoice
inner join customer as c on c.customer_id=invoice.customer_id
inner join invoice_line as il on il.invoice_id=invoice.invoice_id
inner join track as t on t.track_id=il.track_id
inner join album as alb on alb.album_id=t.album_id
inner join best_selling_artist as bsa on bsa.artist_id=alb.artist_id
group by 1,2,3,4
order by 5 desc



We want to find out the most popular music Genre for each country. We determine the
most popular genre as the genre with the highest amount of purchases. Write a query
that returns each country along with the top Genre. For countries where the maximum
number of purchases is shared return all Genres
with popular_genre as
(
	select customer.country, count(invoice_line.quantity), genre.name,
	row_number() over(partition by customer.country order by count(invoice_line.quantity) desc)
	from customer
	inner join invoice on customer.customer_id=invoice.customer_id
	inner join invoice_line on invoice_line.invoice_id=invoice.invoice_id
	inner join track on track.track_id=invoice_line.track_id
	inner join genre on genre.genre_id=track.genre_id
	group by customer.country, genre.name
)
select * from popular_genre where row_number<=1
					



Write a query that determines the customer that has spent the most on music for each
country. Write a query that returns the country along with the top customer and how
much they spent. For countries where the top amount spent is shared, provide all
customers who spent this amount
with customer_country as (
				select customer.country, customer.first_name, customer.last_name, sum(invoice.total),
				row_number() over(partition by customer.country order by sum(invoice.total) desc)
				from customer
				inner join invoice on customer.customer_id=invoice.customer_id
				group by customer.customer_id)
select * from customer_country 
where row_number<=1

or

select customer.country, customer.first_name, customer.last_name, sum(invoice.total),
row_number() over(partition by customer.country order by sum(invoice.total) desc)
from customer
inner join invoice on customer.customer_id=invoice.customer_id
group by customer.customer_id
where row_number<=1 









