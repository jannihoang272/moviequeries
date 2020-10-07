/* List unrated movie titles showing at any theater in a city beginning with the letter 'I' 
and were only seen by customers whose first name starts with 'A' .*/
/* MOVIES (MovieID, Title, Rating)

THEATERS (TheaterID, TheaterName, OwnerID, LocationID)

LOCATION (LocationID, City, State)

OWNERS(OwnerID, FName, LName)

TICKETS (MovieID, TheaterID, RewardID, SalesDate, TicketsSold)

REWARDS (RewardID, CustFName, CustLName, Email) */

Use Movies;

SELECT Title
FROM MOVIES, TICKETS, THEATERS, LOCATION, REWARDS 
WHERE MOVIES.MovieID = TICKETS.MovieID
AND TICKETS.RewardID = REWARDS.RewardID
AND TICKETS.TheaterID = THEATERS.TheaterID
AND THEATERS.LocationID = LOCATION.LocationID
AND MOVIES.Rating IS NULL
AND LOCATION.City LIKE 'I%'
AND REWARDS.CustFName LIKE 'A%';

/* List the movie titles, total tickets sold, and total profit amounts for each movie with a rating of ‘PG-13’ 
and a grand total profit of $200 or more. Movie showings earn 35% profit from its number of tickets sold.  
Individual tickets are sold for $13.50 each. */
SELECT Title, SUM(TicketsSold) AS TotalTicketsSold, SUM(TicketsSold*13.50*0.35) AS TotalProfit
FROM MOVIES, TICKETS
WHERE MOVIES.MovieID = TICKETS.MovieID
AND MOVIES.Rating = 'PG-13' 
GROUP BY Title, Rating
HAVING SUM(TicketsSold*13.50*0.35) >= 200;

/* List the movie titles showing at a theater owned by ‘David Jackson’. Use a subquery. */
SELECT Title
FROM MOVIES
WHERE MovieID IN
	(SELECT MovieID
	FROM TICKETS
	WHERE TheaterID IN
		(SELECT TheaterID
		FROM THEATERS
		WHERE OwnerID IN
			(SELECT OwnerID
			FROM OWNERS
			WHERE FName = 'DAVID' AND LName = 'Jackson')));
SELECT Title, FName, LName
FROM MOVIES, TICKETS, THEATERS, OWNERS
WHERE MOVIES.MovieID = TICKETS.MovieID
AND TICKETS.TheaterID = THEATERS.TheaterID
AND THEATERS.OwnerID = OWNERS.OwnerID
AND FName = 'DAVID' AND LName = 'Jackson';

/* List the unique movie titles with a rating of 'R' that sold more than 25 tickets, but exclude the city of Brea.  */
SELECT DISTINCT Title
FROM MOVIES, TICKETS, THEATERS, LOCATION
WHERE MOVIES.MovieID = TICKETS.MovieID
AND TICKETS.TheaterID = THEATERS.TheaterID
AND THEATERS.LocationID = LOCATION.LocationID
AND MOVIES.Rating = 'R'
AND TICKETS.TicketsSold > 25
AND LOCATION.City <> 'Brea';

/* List the movie titles showing at a theater owned by 'David Jackson'.*/
SELECT DISTINCT Title
FROM MOVIES, TICKETS, THEATERS, OWNERS
WHERE MOVIES.MovieID = TICKETS.MovieID
AND TICKETS.TheaterID = THEATERS.TheaterID
AND THEATERS.OwnerID = OWNERS.OwnerID
AND OWNERS.FName = 'David' AND OWNERS.LName = 'Jackson';

/* List the movie titles and total tickets sold for each city 
with a grand total of 80 or less total tickets sold.  Sort in descending order by city. */
SELECT Title, SUM(TicketsSold) AS TotalTicketsSold
FROM MOVIES, TICKETS, LOCATION, THEATERS
WHERE MOVIES.MovieID = TICKETS.MovieID
AND TICKETS.TheaterID = THEATERS.TheaterID
AND THEATERS.LocationID = LOCATION.LocationID
GROUP BY Title, City
HAVING SUM(TicketsSold) <= 80
ORDER BY City DESC;

/* List the unique movie theaters with the number of movie showings for theaters whose owner’s last name is 'Huang'.  */
SELECT DISTINCT THEATERS.TheaterID, COUNT(MovieID) AS NumberOfMovies
FROM TICKETS, THEATERS, OWNERS
WHERE TICKETS.TheaterID = THEATERS.TheaterID
AND THEATERS.OwnerID = OWNERS.OwnerID
AND OWNERS.LName = 'Huang'
GROUP BY THEATERS.TheaterID;

/* List the owners and the number of theaters owned by each owner, but exclude owners with less than 2 theaters. */
SELECT OWNERS.OwnerID, FName, LName, COUNT(TheaterID) AS NumberOfTheaters
FROM OWNERS, THEATERS
WHERE OWNERS.OwnerID = THEATERS.OwnerID
GROUP BY OWNERS.OwnerID, FName, LName
HAVING COUNT(TheaterID) >= 2;

/* List the customers and total tickets sold to each customer that went to a showing in theaters 
whose owner’s last name ends with a 'th'. */
SELECT CustFName, CustLName, SUM(TicketsSold) AS TotalTicketsSold, LName
FROM TICKETS, THEATERS, OWNERS, REWARDS
WHERE TICKETS.RewardID = REWARDS.RewardID
AND TICKETS.TheaterID = THEATERS.TheaterID
AND THEATERS.OwnerID = OWNERS.OwnerID
GROUP BY CustFName, CustLName, LName;

SELECT *
FROM OWNERS
WHERE LName LIKE '%th';

/*List the movie titles showing at Anaheim or Placentia. Use a subquery.*/
SELECT Title
FROM MOVIES
WHERE MovieID IN
	(SELECT MovieID
	FROM TICKETS
	WHERE TheaterID IN
		(SELECT TheaterID
		FROM THEATERS
		WHERE LocationID IN
			(SELECT LocationID
			FROM LOCATION
			WHERE City = 'Anaheim' OR City = 'Placentia')));

SELECT DISTINCT Title, City
FROM MOVIES, TICKETS, THEATERS, LOCATION
WHERE MOVIES.MovieID = TICKETS.MovieID
AND TICKETS.TheaterID = THEATERS.TheaterID
AND THEATERS.LocationID = LOCATION.LocationID
AND City = 'Anaheim' OR City = 'Placentia';
