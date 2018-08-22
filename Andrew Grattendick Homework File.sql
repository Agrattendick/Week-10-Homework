USE sakila;

-- 1a. Display first and last names from table "actor"
#SELECT first_name, last_name FROM actor;

-- 1b. Display first and last names for the actors in a single column named "actor in upper case letters.
#SELECT UPPER (CONCAT_WS(" ", first_name, last_name)) AS actor
#FROM actor

-- 2a. Find the ID number, first name, and last name of an actor. Only know their first name "Joe" 
-- What one query would you use to obtain this information?
#SELECT actor_id, first_name, last_name 
#FROM actor
#WHERE first_name = 'JOE';

-- 2b. Find all actors whose last name contains the letters GEN.
#SELECT actor_id, first_name, last_name 
#FROM actor
#WHERE last_name LIKE '%GEN%';

-- 2c. Find all actors whose last names contain the letters LI. 
-- Order rows by last name and first name in that order.
#SELECT actor_id, first_name, last_name 
#FROM actor
#WHERE last_name LIKE '%LI%'
#ORDER BY last_name, first_name;

-- 2d. Using IN display the country_id and country columns of the following countries
-- Afghanistan, Bangladesh, China
#SELECT country_id, country FROM country
#WHERE country IN ('Afghanistan', 'Bangladesh', 'China');

-- 3a. Keep a description of each actor. No searches will be preformed here. 
-- create a column titled "description" and use the datatype BLOB
#ALTER TABLE actor
#ADD COLUMN description BLOB;

-- 3b. The description column is useless.  Delete it.
#ALTER TABLE actor
#DROP COLUMN description;

-- 4a. List the last names of actors, as well as how many actors have that name.
#SELECT last_name, COUNT(last_name) AS number_of_actors FROM actor GROUP BY last_name;

-- 4b. List the last names of actors and the number of actors with that last name, 
-- but only for names shared by two or more actors.
#SELECT last_name, COUNT(last_name) AS number_of_actors FROM actor GROUP BY last_name HAVING(number_of_actors) >=2;

-- 4c. The actor HARPO WILLIAMS was accidentally entered into the actor table as GROUCHO WILLIAMS.
-- Write a query to fix the record.
#UPDATE actor
#SET first_name = 'HARPO'
#WHERE first_name = 'GROUCHO' AND last_name = 'WILLIAMS';

-- 4d. We were too hasty (AGAIN!) It turns out the name GROUCHO WILLIAMS was correct all along.
-- In a single query if the first name of an actor is currently HARPO change it to GROUCHO.
#UPDATE actor
#SET first_name = 'GROUCHO'
#WHERE first_name = 'HARPO' AND last_name = 'WILLIAMS';

-- 5a. You cannot locate the schema of the address table. Which query would you use to recreate it?
#Do later

-- 6a. Use JOIN to display the first and last names of each staff memeber, as well as their address
-- use the tables staff and address
#SELECT staff.first_name, staff.last_name, address.address
#FROM staff
#INNER JOIN address 
#ON staff.address_id = address.address_id;

-- 6b. Use JOIN to display the total amount rung up by each staff member in august of 2005. 
-- Use the tables staff and payment.
#SELECT staff.first_name, staff.last_name, SUM(payment.amount) AS total_amount
#FROM staff
#JOIN payment
#ON staff.staff_id = payment.staff_id
#WHERE payment.payment_date LIKE '2005-08%'
#GROUP BY staff.staff_id;

-- 6c. List each film and the number of actors who are listed for that film.
-- Use the tables film_actor and film with Inner Join
#SELECT film.title, COUNT(film_actor.film_id) AS number_of_actors
#FROM film
#JOIN film_actor
#ON film.film_id=film_actor.film_id
#GROUP BY film_actor.film_id;

-- 6d. How many copies of Hunchback Impossible exist in the inventory system?
#SELECT film.title, COUNT(inventory.film_id) AS number_of_copies
#FROM film
#JOIN inventory
#ON film.film_id = inventory.film_id
#WHERE title = 'Hunchback Impossible'
#GROUP BY film.film_id;

-- 6e. Using the tables payment and customer and the JOIN command, list the total
-- paid by each customer. List customers alphabetically by last name.
#SELECT customer.first_name, customer.last_name, SUM(payment.amount) AS total_paid
#FROM customer
#JOIN payment
#ON customer.customer_id=payment.customer_id
#GROUP BY payment.customer_id
#ORDER BY customer.last_name;

-- 7a. The music of Queen and Kris Kristofferson has seeen an unlikely resurgence.
-- As an unintended consequence, films starting with the letters K and Q have also
-- soared in popularity. Use subquerries to display the titles of movies starting 
-- with the letters K and Q whose langage is English.
#SELECT title FROM film
#WHERE title LIKE 'Q%' OR title LIKE 'K%' AND language_id  IN(
#	SELECT language_id FROM language 
#	WHERE name = 'English');

-- 7b. Use subqueries to display all actors who appear in the film Alone Trip
#SELECT first_name, last_name FROM actor
#WHERE actor_id IN(
#	SELECT actor_id FROM film_actor
#	WHERE film_id IN(
#		SELECT film_id FROM film
#		WHERE title = 'Alone Trip'));

-- 7c. You want to run an email marketing campaign in Canada for which you will need the names
-- and email addresses of all Canadian customers. Use JOINS to retrive this information.
#SELECT customer.first_name, customer.last_name, customer.email FROM customer
#JOIN address
#ON customer.address_id = address.address_id
#JOIN city
#ON address.city_id = city.city_id
#JOIN country
#ON city.country_id = country.country_id
#WHERE country = 'Canada';

-- 7d. Sales have been lagging among young families and you wish to target all family movies
-- for a promotion, Identify all movies categorized as family films
#SELECT title FROM film
#WHERE film_id IN(
#	SELECT film_id FROM film_category
#    WHERE category_id IN(
#		SELECT category_id FROM category
#        WHERE name = 'Family'));

-- 7e. Display the most frequently rented movies in descending order.
#SELECT film.title AS film_title, COUNT(rental.inventory_id) AS number_of_rentals FROM film
#JOIN inventory
#ON film.film_id = inventory.film_id
#JOIN rental
#ON inventory.inventory_id = rental.inventory_id
#GROUP BY film.title
#ORDER BY number_of_rentals DESC;

-- 7f. Write a query to display how much business, in dollars, each store brought in.
#SELECT address.address AS store, CONCAT ('$', FORMAT(SUM(payment.amount), 2)) AS total_business 
#FROM address
#JOIN store
#ON address.address_id = store.address_id
#JOIN staff
#ON staff.store_id = store.store_id
#JOIN payment
#ON payment.staff_id = staff.staff_id
#GROUP BY staff.staff_id;
 
-- 7g. Write a query to display for each store it's store ID city, and country.
#SELECT address.address, store.store_id, city.city, country.country FROM address
#JOIN city
#ON address.city_id = city.city_id
#JOIN country
#ON city.country_id = country.country_id
#JOIN store
#ON store.address_id = address.address_id;

-- 7h. List the top five genres in gross revenue in descending order (HINT: you may need to 
-- use the following tables: category, film_category, inventory, payment, and rental)
SELECT category.name AS category, CONCAT('$', FORMAT (SUM(payment.amount),2)) AS gross_revenue 
FROM category
JOIN film_category
ON category.category_id = film_category.category_id
JOIN inventory
ON film_category.film_id = inventory.film_id
JOIN rental
ON inventory.inventory_id = rental.inventory_id
JOIN payment
ON rental.rental_id = payment.rental_id
GROUP BY category.name
ORDER BY gross_revenue DESC
LIMIT 5;

-- 8a. In your role as an executive, you would lie to have an easy way of viewing the TOP Five
-- genres by gross revenue. Use the solution from problem 7h. to create a view.

#CREATE VIEW top_five_genres AS
#SELECT category.name AS category, CONCAT('$', FORMAT (SUM(payment.amount),2)) AS gross_revenue 
#FROM category
#JOIN film_category
#ON category.category_id = film_category.category_id
#JOIN inventory
#ON film_category.film_id = inventory.film_id
#JOIN rental
#ON inventory.inventory_id = rental.inventory_id
#JOIN payment
#ON rental.rental_id = payment.rental_id
#GROUP BY category.name
#ORDER BY gross_revenue DESC
#LIMIT 5;

-- 8b. How would you display the View created in 8a.?
#SELECT * FROM top_five_genres;

-- 8c. You find that you nolonger need the view top_five_genres. Write a query to delete it.
#DROP VIEW top_five_genres;