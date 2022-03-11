use chinook;

-- 1. How many songs are there in the playlist “Grunge”?
SELECT chinook.playlist.Name, COUNT(chinook.playlisttrack.PlaylistId) AS Tracks
from playlist
left join playlisttrack on playlist.PlaylistId = playlisttrack.PlaylistId
where Name like 'Grunge'
group by Name;

-- 2. Show information about artists whose name includes the text “Jack” and about artists whose name includes the text “John”, but not the text “Martin”.
SELECT * from artist
WHERE regexp_like(Name, 'jack') OR regexp_like(Name, 'john') AND not regexp_like(name, 'Martin');

-- 3. For each country where some invoice has been issued, show the total invoice monetary amount, but only for countries where at least $100 have been invoiced. Sort the information from higher to lower monetary amount.
SELECT DISTINCT BillingCountry, SUM(Total) Invoic_total
from invoice
group by BillingCountry
having Invoic_total >=100
order by Invoic_total DESC;

-- 4. Get the phone number of the boss of those employees who have given support to clients who have bought some song composed by “Miles Davis” in “MPEG Audio File” format.
SELECT DISTINCT employee.Phone
FROM invoiceline
join track on track.TrackId = invoiceline.TrackId
join mediatype on track.MediaTypeId = mediatype.MediaTypeId
join invoice on invoiceline.InvoiceId = invoice.InvoiceId
join customer on invoice.CustomerId = customer.CustomerId
join employee on customer.SupportRepId = employee.EmployeeId
where regexp_like(Composer, 'Miles Davis') AND regexp_like(mediatype.Name, 'MPEG Audio File');
-- got the number of the employee but not sure not to get the bosses number instead

-- 5. Show the information, without repeated records, of all albums that feature songs of the “Bossa Nova” genre whose title starts by the word “Samba”.
SELECT distinct album.AlbumId, Title, artist.Name AS Artist
FROM album
JOIN track on album.AlbumId = track.AlbumId
join artist on album.ArtistId = artist.ArtistId
join genre on track.GenreId = genre.GenreId
where chinook.genre.Name = 'Bossa Nova' AND regexp_like(chinook.album.Title, '^Samba');
-- as far as i can tell my searchin in the database as well there are no albums that matches this

-- 6. For each genre, show the average length of its songs in minutes (without indicating seconds). Use the headers “Genre” and “Minutes”, and include only genres that have any song longer than half an hour.
SELECT DISTINCT chinook.genre.Name as Genre, ROUND(SUM(chinook.track.Milliseconds/60/60),0) Minutes
from track
join genre on track.GenreId = genre.GenreId
group by genre.Name
having Minutes >= 300
order by Minutes DESC;


-- 7. How many client companies have no state?
SELECT COUNT(*) AS 'Companies without a state'
FROM customer where State is NULL;

-- 8. For each employee with clients in the “USA”, “Canada” and “Mexico” show the number of clients from these countries s/he has given support, only when this number is higher than 6. Sort the query by number of clients. Regarding the employee, show his/her first name and surname separated by a space. Use “Employee” and “Clients” as headers.
SELECT DISTINCT CONCAT(chinook.employee.FirstName, ' ', chinook.employee.LastName) Employee,
                count(chinook.customer.Country) Clients
FROM employee
join customer on employee.EmployeeId = customer.SupportRepId
WHERE regexp_like(customer.Country, 'USA') OR regexp_like(customer.Country, 'Mexico') OR regexp_like(customer.Country, 'Canada')
Group by chinook.employee.FirstName, chinook.employee.LastName
Having  Clients >= 6
order by clients DESC;

-- 9. For each client from the “USA”, show his/her surname and name (concatenated and separated by a comma) and their fax number. If they do not have a fax number, show the text “S/he has no fax”. Sort by surname and first name.
SELECT CONCAT(chinook.customer.FirstName, ',' , chinook.customer.LastName), IF(chinook.customer.Fax IS null, 'S/he has no fax', chinook.customer.Fax)
FROM customer WHERE regexp_like(Country, 'USA')
ORDER BY FirstName, LastName;


-- 10. For each employee, show his/her first name, last name, and their age at the time they were hired.
SELECT chinook.employee.FirstName, chinook.employee.LastName, (YEAR(HireDate)-YEAR(BirthDate)) AS 'Age at time of hiring'
from employee;
-- only calculated by year not including month and date