-- 1b. Display the first and last name of each actor in a single column in upper case letters. Name the column `Actor Name`. 

USE sakila;

SHOW TABLES;

SELECT * FROM actor;

SELECT CONCAT(first_name, '  ', last_name) AS 'Actor Name'
FROM actor;


-- 2a. You need to find the ID number, first name, and last name of an actor, 
-- of whom you know only the first name, "Joe." What is one query would you use to obtain this information?

USE sakila;

SHOW TABLES;

SELECT * FROM actor;

SELECT actor_id, first_name, last_name
FROM actor
WHERE first_name = 'Joe';

-- 2b. Find all actors whose last name contain the letters `GEN`:

USE sakila;

SHOW TABLES;

SELECT * FROM actor;

SELECT first_name, last_name
FROM actor
WHERE last_name LIKE '%gen%';

-- 2c. Find all actors whose last names contain the letters `LI`. 
-- This time, order the rows by last name and first name, in that order:

USE sakila;

SHOW TABLES;

SELECT * FROM actor;

SELECT last_name, first_name
FROM actor
WHERE last_name LIKE '%LI%';

-- 2d. Using `IN`, display the `country_id` and `country` columns of the following countries: Afghanistan, Bangladesh, and China:

USE sakila;
SHOW TABLES;

SELECT * FROM country;

SELECT country_id, country
FROM country
WHERE country IN ('Afghanistan', 'Bangladesh', 'China');

-- 3a. Add a `middle_name` column to the table `actor`. 
-- Position it between `first_name` and `last_name`. Hint: you will need to specify the data type.

USE sakila;

SHOW TABLES;

SELECT * FROM actor;

ALTER TABLE actor
ADD middle_name VARCHAR(30) AFTER first_name;

SELECT * FROM actor;

-- 3b. You realize that some of these actors have tremendously long last names. 
-- Change the data type of the `middle_name` column to `blobs`.

USE sakila;

SHOW TABLES;

ALTER TABLE actor MODIFY middle_name blob;

SELECT * FROM actor;

-- 3c. Now delete the `middle_name` column.

USE sakila;

SHOW TABLES;

SELECT * FROM actor;

ALTER TABLE actor DROP middle_name;

SELECT * FROM actor;

 -- 4a. List the last names of actors, as well as how many actors have that last name.
 
 USE sakila;
 
 SHOW TABLES;
 
 SELECT * FROM actor;
 
 SELECT COUNT(last_name) AS Frequency , last_name FROM actor GROUP BY last_name;
 


-- 4b. List last names of actors and the number of actors who have that last name, 
-- but only for names that are shared by at least two actors

USE sakila;

SHOW TABLES;
 
SELECT * FROM actor;
 
SELECT COUNT(last_name) AS Frequency , last_name FROM actor GROUP BY last_name HAVING Frequency >= 2;

-- 4c. Oh, no! The actor `HARPO WILLIAMS` was accidentally entered in the `actor` table as `GROUCHO WILLIAMS`, 
-- the name of Harpo's second cousin's husband's yoga teacher. Write a query to fix the record.

USE sakila;

SHOW TABLES;

SELECT * FROM actor WHERE last_name = 'Williams';

UPDATE actor SET first_name='HARPO' WHERE first_name='GROUCHO';

SELECT * FROM actor WHERE last_name = 'Williams';

-- 4d. Perhaps we were too hasty in changing `GROUCHO` to `HARPO`. 
-- It turns out that `GROUCHO` was the correct name after all! 
-- In a single query, if the first name of the actor is currently `HARPO`, change it to `GROUCHO`. 
-- Otherwise, change the first name to `MUCHO GROUCHO`, as that is exactly what the actor will be with the grievous error. 
-- BE CAREFUL NOT TO CHANGE THE FIRST NAME OF EVERY ACTOR TO `MUCHO GROUCHO`, HOWEVER! 
-- (Hint: update the record using a unique identifier.)

USE sakila;

SHOW TABLES;

SELECT * FROM actor WHERE last_name = 'Williams';

UPDATE actor SET first_name='GROUCHO' WHERE first_name='HARPO';

SELECT * FROM actor WHERE last_name = 'Williams';

UPDATE actor SET first_name='MUCHO GROUCHO' WHERE first_name='GROUCHO';

SELECT * FROM actor WHERE last_name = 'Williams';

 -- 5a. You cannot locate the schema of the `address` table. Which query would you use to re-create it?
 
 USE sakila;
 
 SHOW TABLES;
 
 SELECT * FROM address;
 
 
-- 6a. Use `JOIN` to display the first and last names, as well as the address, of each staff member. 
-- Use the tables `staff` and `address`:

USE sakila;

SHOW TABLES;

SELECT * FROM staff;
SELECT * FROM address;

SELECT s.first_name, s.last_name, a.address
FROM staff s
INNER JOIN address a ON s.address_id = a.address_id;


-- 6b. Use `JOIN` to display the total amount rung up by each staff member in August of 2005. Use tables `staff` and `payment`. 

USE sakila;

SHOW TABLES;

SELECT * FROM payment;

SELECT * FROM staff;

SELECT SUM(p.amount) AS collected, s.first_name, s.last_name
FROM staff s
INNER JOIN payment p ON s.staff_id = p.staff_id
AND payment_date LIKE  '2005-08%'
GROUP BY s.staff_id;

-- 6c. List each film and the number of actors who are listed for that film. Use tables `film_actor` and `film`. Use inner join.

USE sakila;

SHOW TABLES;

SELECT * FROM film;
SELECT * FROM film_actor;

SELECT COUNT(a.actor_id) AS num_of_actors , f.title
FROM film f
INNER JOIN film_actor a ON a.film_id = f.film_id
GROUP BY f.title;

-- 6d. How many copies of the film `Hunchback Impossible` exist in the inventory system?

USE sakila;

SHOW TABLES;

SELECT * FROM inventory;
SELECT * FROM film;


SELECT film_id
FROM inventory
WHERE film_id;
(
	SELECT film_id
    FROM film
    WHERE title = 'Hunchback Impossible'
);


SELECT title 
FROM film
WHERE film_id = 439;


SELECT COUNT(film_id)
FROM inventory
WHERE film_id = 439;

-- 6e. Using the tables `payment` and `customer` and the `JOIN` command, list the total paid by each customer. 
-- List the customers alphabetically by last name:

USE sakila;

SHOW TABLES;

SELECT * FROM payment;
SELECT * FROM customer;

SELECT c.first_name, c.last_name, SUM(p.amount) AS total_payment
FROM payment p
INNER JOIN customer c ON c.customer_id = p.customer_id
GROUP BY c.last_name;

-- 7a. The music of Queen and Kris Kristofferson have seen an unlikely resurgence. 
-- As an unintended consequence, films starting with the letters `K` and `Q` have also soared in popularity. 
-- Use subqueries to display the titles of movies starting with the letters `K` and `Q` whose language is English. 

USE sakila;

SHOW TABLES;

SELECT * FROM film;
SELECT * FROM language;


SELECT title, language_id
FROM film
WHERE language_id IN
(
	SELECT language_id
    FROM language
    WHERE title LIKE 'K%' OR title LIKE 'Q%' AND language_id = 1
);

-- 7b. Use subqueries to display all actors who appear in the film `Alone Trip`.

USE sakila;

SHOW TABLES;

SELECT * FROM actor;

SELECT * FROM actor_info;

SELECT * FROM film_actor;

SELECT * FROM film;

SELECT first_name, last_name
FROM actor
WHERE actor_id IN
(
	SELECT actor_id
    FROM film_actor
    WHERE film_id IN
    (
		SELECT film_id
		FROM film
        WHERE title = 'ALONE TRIP'
    )
);


-- 7c. You want to run an email marketing campaign in Canada, 
-- for which you will need the names and email addresses of all Canadian customers. 
-- Use joins to retrieve this information.

USE sakila;

SHOW TABLES;

SELECT * FROM customer;

SELECT * FROM customer_list;

SELECT * FROM customer_email;


ALTER TABLE customer_email
ADD ID INTEGER;

SELECT * FROM customer_email;

UPDATE customer_email SET ID = customer_id;
SELECT * FROM customer_email;

SELECT first_name, last_name, email
FROM customer_email
WHERE ID IN
(
	SELECT ID 
    FROM customer_list
    WHERE country = 'Canada'
);



-- 7d. Sales have been lagging among young families, 
-- and you wish to target all family movies for a promotion. 
-- Identify all movies categorized as famiy films.

USE sakila;

SHOW TABLES;

SELECT * FROM film_category;

SELECT * FROM category;

SELECT * FROM film;

SELECT title
FROM film
WHERE film_id in
(
	SELECT film_id 
    FROM film_category
    WHERE category_id IN
    (
		SELECT category_id
        FROM category
        WHERE name = 'Family'
    )
);

-- 7c. You want to run an email marketing campaign in Canada, 
-- for which you will need the names and email addresses of all Canadian customers. 
-- Use joins to retrieve this information.

USE sakila;

SHOW TABLES;

SELECT * FROM customer;

SELECT * FROM customer_list;

SELECT * FROM customer_email;


ALTER TABLE customer_email
ADD ID INTEGER;

SELECT * FROM customer_email;

UPDATE customer_email SET ID = customer_id;
SELECT * FROM customer_email;

SELECT first_name, last_name, email
FROM customer_email
WHERE ID IN
(
	SELECT ID 
    FROM customer_list
    WHERE country = 'Canada'
);



-- 7d. Sales have been lagging among young families, 
-- and you wish to target all family movies for a promotion. 
-- Identify all movies categorized as famiy films.

USE sakila;

SHOW TABLES;

SELECT * FROM film_category;

SELECT * FROM category;

SELECT * FROM film;

SELECT title
FROM film
WHERE film_id in
(
	SELECT film_id 
    FROM film_category
    WHERE category_id IN
    (
		SELECT category_id
        FROM category
        WHERE name = 'Family'
    )
);

-- 7e. Display the most frequently rented movies in descending order.

USE sakila;

SHOW TABLES;

SELECT * FROM film;

SELECT title, rental_duration
FROM film
ORDER BY rental_duration DESC;

-- 7f. Write a query to display how much business, in dollars, each store brought in.

USE sakila;
SHOW TABLES;

SELECT * FROM payment;
SELECT * FROM store;
SELECT * FROM staff;
SELECT * FROM staff_list;

SELECT * FROM sales_by_store;

SELECT SUM(amount) AS income, staff_id
FROM payment
GROUP BY staff_id;


-- 7g. Write a query to display for each store its store ID, city, and country.

USE sakila;

SHOW TABLES;

SELECT * FROM store;
SELECT * FROM sales_by_store;
SELECT * FROM city;
SELECT * FROM staff;

SELECT * FROM country;

SELECT * FROM address;

SELECT store_id, city.city, country.country
From store
Join address
using(address_id)
JOIN city
USING(city_id)
JOIN country
USING(country_id)


-- 7h. List the top five genres in gross revenue in descending order. 
-- (**Hint**: you may need to use the following tables: category, film_category, inventory, payment, and rental.)

USE sakila;

SHOW TABLES;

SELECT * FROM category;

SELECT * FROM film_category;

SELECT * FROM inventory;

SELECT * FROM payment;

SELECT * FROM rental;

SELECT category_id, category.name, sum(amount) as total_rev
FROM payment
JOIN rental
USING(rental_id)
JOIN inventory
USING(inventory_id)
JOIN film_category
USING(film_id)
JOIN category
USING(category_id)
GROUP BY category_id
ORDER BY total_rev DESC
LIMIT 5;

 -- 8a. In your new role as an executive, you would like to have an easy way of viewing the Top five genres by gross revenue. 
 -- Use the solution from the problem above to create a view. If you haven't solved 7h, you can substitute another query to create a view.
 
USE sakila;
 
SHOW TABLES;
 
CREATE VIEW genres_rev AS
SELECT category_id, category.name, sum(amount) as total_rev
FROM payment
JOIN rental
USING(rental_id)
JOIN inventory
USING(inventory_id)
JOIN film_category
USING(film_id)
JOIN category
USING(category_id)
GROUP BY category_id
ORDER BY total_rev DESC
LIMIT 5;

-- 8b. How would you display the view that you created in 8a?

SELECT * FROM genres_rev;

-- 8c. You find that you no longer need the view `top_five_genres`. Write a query to delete it.

DROP VIEW genres_rev;