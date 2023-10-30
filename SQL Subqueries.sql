

## Introduction
#Welcome to the SQL Subqueries lab!
#In this lab, you will be working with the [Sakila](https://dev.mysql.com/doc/sakila/en/) database on movie rentals. Specifically, you will be practicing how to perform subqueries, which are queries embedded within other queries. Subqueries allow you to retrieve data from one or more tables and use that data in a separate query to retrieve more specific information.

# Challenge
#Write SQL queries to perform the following tasks using the Sakila database:
USE sakila;
#1. Determine the number of copies of the film "Hunchback Impossible" that exist in the inventory system.
SELECT COUNT(*) AS num_copies
FROM inventory AS i
JOIN film AS f ON i.film_id = f.film_id
WHERE f.title = 'Hunchback Impossible';

#OR
SELECT COUNT(*) AS num_copies
FROM inventory
WHERE film_id = (SELECT film_id 
				FROM film
                WHERE title = 'Hunchback Impossible');
#2. List all films whose length is longer than the average length of all the films in the Sakila database.
SELECT *
FROM film
WHERE length > (SELECT AVG (length)
				FROM film);

#3. Use a subquery to display all actors who appear in the film "Alone Trip".
SELECT actor.first_name, actor.last_name
FROM actor
WHERE actor.actor_id IN (SELECT film_actor.actor_id
					FROM film_actor
                    JOIN film ON film.film_id = film_actor.film_id
                    WHERE film.title = 'Alone Trip');
#OR
SELECT actor_id, first_name, last_name
FROM actor
WHERE actor_id IN (SELECT actor_id
					FROM film_actor
                    WHERE film_id = (SELECT film_id FROM film WHERE title = 'Alone Trip'));
                    


#**Bonus**:

#4. Sales have been lagging among young families, and you want to target family movies for a promotion.
#Identify all movies categorized as family films.
SELECT film.title
FROM film
JOIN film_category fc ON fc.film_id = film.film_id
JOIN category c ON c.category_id = fc.category_id
WHERE name = 'family';

#OR
SELECT title
FROM film
WHERE film_id IN (SELECT film_id
					FROM film_category
                    WHERE category_id = (SELECT category_id FROM category WHERE name = 'Family'));
                    

#5. Retrieve the name and email of customers from Canada using both subqueries and joins.
#To use joins, you will need to identify the relevant tables and their primary and foreign keys.
SELECT c.first_name, c.last_name, c.email
FROM customer c
JOIN address a ON c.address_id = a.address_id
JOIN city ON a.city_id = city.city_id
JOIN country ON city.country_id = country.country_id
WHERE country.country = 'Canada';

SELECT c.first_name, c.last_name, c.email
FROM customer c
JOIN address a ON c.address_id = a.address_id
JOIN city ON a.city_id = city.city_id
JOIN country ON city.country_id = country.country_id
WHERE country.country = (SELECT country
						 FROM country
                         WHERE country = 'Canada');



#6. Determine which films were starred by the most prolific actor in the Sakila database.
#A prolific actor is defined as the actor who has acted in the most number of films.
#First, you will need to find the most prolific actor and then use that actor_id to find the different films that he or she starred in.
SELECT f.title
FROM film f
JOIN film_actor fa ON f.film_id = fa.film_id
WHERE fa.actor_id = ( SELECT actor_id
					  FROM film_actor
                      GROUP BY actor_id
                      ORDER BY COUNT(*) DESC
                      LIMIT 1);


#7. Find the films rented by the most profitable customer in the Sakila database.
#You can use the customer and payment tables to find the most profitable customer, i.e., the customer who has made the largest sum of payments.
SELECT f.title
FROM film f
JOIN inventory i ON f.film_id = i.film_id
JOIN rental r ON i.inventory_id = r.inventory_id
JOIN payment p ON r.rental_id = p.rental_id
WHERE p.customer_id = (SELECT customer_id
					   FROM payment
                       GROUP BY customer_id
                       ORDER BY SUM(amount) DESC
                       LIMIT 1);

#8. Retrieve the client_id and the total_amount_spent of those clients who spent more than the average of the total_amount spent by each client.
#You can use subqueries to accomplish this.
SELECT customer_id, SUM(amount) AS total_amount_spent
FROM payment
GROUP BY customer_id
HAVING SUM(amount) > (SELECT AVG(total_amount)
					  FROM (SELECT SUM(amount) AS total_amount
							FROM payment
                            GROUP BY customer_id) AS subquerie);



