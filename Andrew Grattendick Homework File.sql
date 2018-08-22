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

-- 7a. 