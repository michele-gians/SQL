use sakila;

SELECT
COUNT(*) AS total_tables
FROM
information_schema.tables
WHERE
table_schema = 'sakila';

SELECT
table_name
FROM
information_schema.tables
WHERE
table_schema = 'sakila';

-- Scoprite quanti clienti si sono registrati nel 2006.

select count(*) as registati_2006
from customer
where create_date between '2006-01-01' and '2006-12-31';

select distinct count(*) as registati_2006
from customer
where year(create_date)=2006;

-- Trovate il numero totale di noleggi effettuati il giorno 1/1/2006.

select count(rental_id) 
from rental
where date(rental_date) = '2006-02-14';


-- Elencate tutti i film noleggiati nell’ultima settimana e tutte le informazioni legate al cliente che li ha noleggiati.

select film.title as nome_film, concat(customer.first_name, ' ',customer.last_name) as customer_name
FROM rental 
JOIN inventory on rental.inventory_id=inventory.inventory_id
JOIN film  on film.film_id=inventory.film_id
JOIN customer on customer.customer_id=rental.customer_id
where rental.rental_date >= (SELECT DATE_SUB(MAX(rental_date), INTERVAL 1 WEEK) FROM rental);


SELECT film.title, rental.rental_id, customer.first_name, customer.last_name, inventory_id, rental_date
FROM
rental
JOIN customer USING (customer_id)
JOIN inventory USING (inventory_id)
JOIN film USING (film_id)
WHERE
rental_date BETWEEN (SELECT(ADDDATE(MAX(rental_date), - 7)) FROM rental) AND (SELECT MAX(rental_date)FROM rental);


-- Calcolate la durata media del noleggio per ogni categoria di film.

select category.name as genere, avg(datediff(return_date,rental_date)) as durata_noleggio
from rental
join  inventory USING (inventory_id)
join film_category USING (film_id)
join category USING (category_id)
group by category_id;

select category.name as genere, avg(rental_duration) as durata_noleggio
from film
join film_category USING (film_id)
join category USING (category_id)
group by category_id;

SELECT category.name AS category,
SEC_TO_TIME(AVG(DATEDIFF(rental.return_date, rental.rental_date)) * 86400) AS avg_rental_duration
FROM category 
JOIN film_category USING(category_id)
JOIN film  USING(film_id)
JOIN inventory  USING(film_id)
JOIN rental USING(inventory_id)
GROUP BY category.name;

-- Trovate la durata del noleggio più lungo.

select max(datediff(return_date,rental_date)) 
from rental;

select max(rental_duration)
from film;


SELECT c.first_name, c.last_name
FROM customer c
LEFT JOIN rental r ON c.customer_id = r.customer_id AND MONTH(r.rental_date) = 1 AND YEAR(r.rental_date) = 2006
GROUP BY c.customer_id
HAVING COUNT(r.rental_id) = 0;

select c.customer_id, concat(first_name," ",last_name) from customer c 
where not exists (select r.customer_id from rental r where DATE_FORMAT(rental_date, "%m - %Y") = "01 - 2006" 
and r.customer_id = c.customer_id);





