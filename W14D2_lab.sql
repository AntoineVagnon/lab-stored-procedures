#Convert the given query into a simple stored procedure:
DELIMITER //
CREATE PROCEDURE GetCustomersWhoRentedActionMovies()
BEGIN
    SELECT first_name, last_name, email
    FROM customer
    JOIN rental ON customer.customer_id = rental.customer_id
    JOIN inventory ON rental.inventory_id = inventory.inventory_id
    JOIN film ON film.film_id = inventory.film_id
    JOIN film_category ON film_category.film_id = film.film_id
    JOIN category ON category.category_id = film_category.category_id
    WHERE category.name = "Action"
    GROUP BY first_name, last_name, email;
END //
DELIMITER ;

#Update the stored procedure to make it dynamic:
DELIMITER //
CREATE PROCEDURE GetCustomersByMovieCategory(IN categoryName VARCHAR(255))
BEGIN
    SELECT first_name, last_name, email
    FROM customer
    JOIN rental ON customer.customer_id = rental.customer_id
    JOIN inventory ON rental.inventory_id = inventory.inventory_id
    JOIN film ON film.film_id = inventory.film_id
    JOIN film_category ON film_category.film_id = film.film_id
    JOIN category ON category.category_id = film_category.category_id
    WHERE category.name = categoryName
    GROUP BY first_name, last_name, email;
END //
DELIMITER ;

#To use this procedure, we call it like this:
CALL GetCustomersByMovieCategory('Animation');

#Write a query to check the number of movies released in each movie category and convert it into a stored procedure:
SELECT category.name, COUNT(film.film_id) AS number_of_movies
FROM category
JOIN film_category ON category.category_id = film_category.category_id
JOIN film ON film.film_id = film_category.film_id
GROUP BY category.name;

DELIMITER //
CREATE PROCEDURE GetMovieCountByCategory(IN minMovies INT)
BEGIN
    SELECT category.name, COUNT(film.film_id) AS number_of_movies
    FROM category
    JOIN film_category ON category.category_id = film_category.category_id
    JOIN film ON film.film_id = film_category.film_id
    GROUP BY category.name
    HAVING number_of_movies > minMovies;
END //
DELIMITER ;

CALL GetMovieCountByCategory(50);

