/* Evaluación Final Módulo 2: SQL */

/* Para este ejercicio utilizaremos la bases de datos Sakila que hemos estado utilizando durante el repaso de
SQL. Es una base de datos de ejemplo que simula una tienda de alquiler de películas. Contiene tablas como
film (películas), actor (actores), customer (clientes), rental (alquileres), category (categorías), entre
otras. Estas tablas contienen información sobre películas, actores, clientes, alquileres y más, y se utilizan
para realizar consultas y análisis de datos en el contexto de una tienda de alquiler de películas. */
USE sakila;
-- reviso el esquema para comprender mejor cómo se orgnizan las tablas y sus relaciones

-- 1: Selecciona todos los nombres de las películas sin que aparezcan duplicados.
-- esquema: film (film_id, title)
-- ACLARACIÓN: cada vez que ponga "esquema" estoy haciendo referencia al esquema de la bbdd Sakila y a sus tablas y columnas, siendo tabla "film" (columnas "film_id, title")
SELECT film_id, title
FROM film; -- film_id es una PRIMARY KEY (PK) por lo que su valor es único pero no significa que los nombres (title) sean únicos

-- mi solución: uso un DISTINCT que nos da los valores únicos de los nombres de las películas:
SELECT DISTINCT title
FROM film; 

-- 2: Muestra los nombres de todas las películas que tengan una clasificación de "PG-13". --> rating = "PG-13"
-- esquema: film (title, rating)
SELECT title, rating -- verifico que salen los de 'PG-13'
FROM film
WHERE rating = "PG-13";

-- mi solución: con un WHERE puedo poner la condición "que la clasificación sea 'PG-13'":
SELECT title
FROM film
WHERE rating = "PG-13"; 

-- 3: Encuentra el título y la descripción de todas las películas que contengan la palabra "amazing" en su descripción. --> LIKE "%amazing%"
-- esquema: film (title, description)
-- mi solución: uso LIKE para buscar un patrón específico ("%amazing%") y pongo 2 '%' para que nos devuelva los amazing en cualquier parte de la descripción 
SELECT title, description
FROM film
WHERE description LIKE "%amazing%"; 

-- 4: Encuentra el título de todas las películas que tengan una duración mayor a 120 minutos.
-- esquema: film (title, length)
SELECT title, length -- verifico que salen los de más de 120 min
FROM film
WHERE length > 120;

-- mi solución: uso WHERE para poner la condición de más de 120 min:
SELECT title 
FROM film
WHERE length > 120;

-- 5: Recupera los nombres de todos los actores.
-- esquema: actor (actor_id, first_name, last_name)
SELECT actor_id, first_name, last_name
FROM actor; -- aqui tengo los nombres y apellidos, pero se solicita sólo nombre (salen 200 rows)

SELECT concat(first_name, ' ', last_name) AS nombre_completo_actor
FROM actor; -- podría unirlos en una columna para confirmar que cada nombre va con su apellido (salen 200 rows)

-- mi solución: poniendo sólo first_name tenemos los nombres de todos los actores (salen 200 rows)
SELECT first_name
FROM actor;

-- 6: Encuentra el nombre y apellido de los actores que tengan "Gibson" en su apellido.
-- esquema: actor (first_name, last_name)
-- mi solución: uso LIKE para buscar un patrón específico ("%Gibson%") y pongo 2 '%' para que nos devuelva los Gibson en cualquier parte del apellido
SELECT first_name, last_name
FROM actor
WHERE last_name LIKE "%Gibson%"; 

-- 7: Encuentra los nombres de los actores que tengan un actor_id entre 10 y 20.
-- no tengo muy claro si solicita que incluya los actor_id de 10 y 20, así que hago las 2:
-- esquema: actor (actor_id, first_name, last_name)
SELECT first_name, last_name, actor_id
FROM actor
WHERE actor_id >= 10 AND actor_id <= 20; -- entiendiendo que se solicita actor_id entre 10 y 20, incluyendo 10 y 20

SELECT first_name, last_name, actor_id
FROM actor
WHERE actor_id > 10 AND actor_id < 20; -- entiendiendo que se solicita actor_id entre 10 y 20, excluyendo 10 y 20

-- mis soluciones: 
SELECT first_name
FROM actor
WHERE actor_id >= 10 AND actor_id <= 20; -- actor_id entre 10 y 20, incluyendo 10 y 20
SELECT first_name
FROM actor
WHERE actor_id > 10 AND actor_id < 20; -- actor_id entre 10 y 20, excluyendo 10 y 20

-- 8: Encuentra el título de las películas en la tabla film que no sean ni "R" ni "PG-13" en cuanto a su clasificación.
-- esquema: film (title, rating)
SELECT title, rating -- verifico que rating salen 
FROM film
GROUP BY rating; -- tenemos PG, G, NC-17, PG-13 y R
SELECT title, rating AS clasificación
FROM film
WHERE rating <> "PG-13" AND rating <> "R"; 

-- mi solución: solo solicitan título de las películas
SELECT title
FROM film
WHERE rating <> "PG-13" AND rating <> "R";
-- sinceramente yo lo veo más completo con éste que sigue (lo incluyo por si fuera interesante saber la clasificación para el solicitante):
SELECT title, rating AS clasificación
FROM film
WHERE rating <> "PG-13" AND rating <> "R";

-- 9: Encuentra la cantidad total de películas en cada clasificación de la tabla film y muestra la clasificación junto con el recuento.
-- esquema: film (film_id, title, rating)
-- mi solución: uso un COUNT para contar el número de películas y GROUP BY para agrupar por cada clasificación
SELECT COUNT(film_id) AS recuento_películas, rating AS clasificación
FROM film
GROUP BY rating;

-- 10: Encuentra la cantidad total de películas alquiladas por cada cliente y muestra el ID del cliente, su nombre y apellido junto con la cantidad de películas alquiladas.
-- esquema: customer (customer_id, first_name, last_name) <--> rental (inventory_id, customer_id) <--> inventory (film_id, inventory_id)
-- ACLARACIÓN: uso <--> en lugar de poner "ésta tabla1 se une a la tabla2". Es sólo una forma de decir que se relacionan entre ellas 
-- mi solución: uno las tablas con INNER JOIN porque sólo quiero las películas alquiladas (no quiero todas las películas ni todos los clientes), 
-- uso GROUP BY para agrupar los clientes y COUNT para contar las películas alquiladas por cada cliente
SELECT c.customer_id, c.first_name, c.last_name, COUNT(i.film_id) AS cantidad_total_películas_alquiladas
FROM customer AS c
INNER JOIN rental AS r
ON c.customer_id = r.customer_id
INNER JOIN inventory as i
ON r.inventory_id = i.inventory_id
GROUP BY c.customer_id;

-- 11: Encuentra la cantidad total de películas alquiladas por categoría y muestra el nombre de la categoría junto con el recuento de alquileres.
-- esquema: category (category_id, name) <--> film_category (category_id, film_id) <--> film (film_id) <--> inventory (film_id, inventory_id) <--> rental (inventory_id, customer_id)
-- cantidad total de películas alquiladas:
SELECT COUNT(i.film_id) AS cantidad_total_películas_alquiladas  -- 16044 pelis
FROM rental AS r
INNER JOIN inventory as i
ON r.inventory_id = i.inventory_id;
-- mi solución: cantidad total de películas alquiladas por categoría:
SELECT c.name AS categoría, COUNT(i.film_id) AS cantidad_total_películas_alquiladas
FROM rental AS r
INNER JOIN inventory as i
ON r.inventory_id = i.inventory_id
INNER JOIN film as f
ON i.film_id = f.film_id
INNER JOIN film_category as f_c
ON f.film_id = f_c.film_id
INNER JOIN category as c
ON f_c.category_id = c.category_id
GROUP BY c.name; 

-- 12: Encuentra el promedio de duración de las películas para cada clasificación de la tabla film y muestra la clasificación junto con el promedio de duración.
-- entiendo que nos solicitan el promedio (AVG) de duración (length) de las películas para cada clasificación (rating) de la tabla film
-- esquema: film (film_id, length, rating)
SELECT film_id, length, rating
FROM film; -- reviso los datos
SELECT AVG(length) AS promedio_duración
FROM film; -- así nos da el promedio de duración de todas las películas

-- mi solución: con AVG(length) saco el promedio de duración y agrupando con GROUP BY rating saco el promedio de duración para cada clasificación
SELECT rating AS clasificación, AVG(length) AS promedio_duración
FROM film
GROUP BY rating;

-- 13: Encuentra el nombre y apellido de los actores que aparecen en la película con title "Indian Love".
-- esquema: actor (actor_id, first_name, last_name) <--> film_actor (actor_id, film_id) <--> film (film_id, title)
-- mi solución: uniendo las tablas actor, film_actor y film puedo sacar el nombre de los actores de "Indian Love"
SELECT a.first_name, a.last_name
FROM actor AS a
INNER JOIN film_actor AS f_a
ON a.actor_id = f_a.actor_id
INNER JOIN film AS f
ON f_a.film_id = f.film_id
WHERE f.title = "Indian Love"; 

-- 14: Muestra el título de todas las películas que contengan la palabra "dog" o "cat" en su descripción.
-- esquema: film (title, description)
-- mi solución: uso LIKE para buscar un patrón específico, pongo 2 '%' a los lados para que nos devuelva los patrones en cualquier parte de la descripción, 
-- y uso OR porque solicitan películas con "dog" o "cat"
SELECT title
FROM film
WHERE description LIKE "%dog%" OR description LIKE "%cat%";

-- 15: Hay algún actor o actriz que no aparezca en ninguna película en la tabla film_actor.
-- esquema: actor (actor_id, first_name, last_name) <--> film_actor (actor_id, film_id) <--> film (film_id, title)
-- la tabla actor tiene a cada uno de los actores, la tabla film_actor une a los actores que salen en películas y la tabla film tiene cada una de las películas
-- la lógica es que no debería haber ningún actor/actriz si no sale en ninguna película (pero han podido almacenar más actores, quien sabe)
-- mi solución: uno actor con film_actor con un LEFT JON porque quiero saber todos los actores y dónde se unen las tablas (qué actores están en películas) 
SELECT a.first_name, a.last_name
FROM actor AS a
LEFT JOIN film_actor AS f_a
ON a.actor_id = f_a.actor_id
WHERE f_a.film_id IS NULL;

-- 16: Encuentra el título de todas las películas que fueron lanzadas entre el año 2005 y 2010.
-- esquema: film (film_id, title, release_year)
SELECT title, release_year
FROM film
WHERE release_year >= 2005 AND release_year <= 2010; -- entiendiendo que se solicita release_year entre 2005 y 2010, incluyendo 2005 y 2010
SELECT title, release_year
FROM film
WHERE release_year > 2005 AND release_year < 2010; -- si se solicita release_year entre 2005 y 2010, excluyendo 2005 y 2010

-- mis soluciones:
SELECT title
FROM film
WHERE release_year >= 2005 AND release_year <= 2010; -- release_year entre 2005 y 2010, incluyendo 2005 y 2010
SELECT title
FROM film
WHERE release_year > 2005 AND release_year < 2010; -- release_year entre 2005 y 2010, excluyendo 2005 y 2010

-- 17: Encuentra el título de todas las películas que son de la misma categoría que "Family".
-- esquema: category (category_id, name) <--> film_category (category_id, film_id) <--> film (film_id, title) 
-- mi solución: unir las tablas film, film_category y category con INNER JOIN (quiero sólo las pelis de categoría "Family")
SELECT f.title, c.name
FROM film AS f
INNER JOIN film_category AS f_c
ON f.film_id = f_c.film_id
INNER JOIN category AS c
ON f_c.category_id = c.category_id
WHERE c.name = "Family";

-- 18: Muestra el nombre y apellido de los actores que aparecen en más de 10 películas.
-- esquema: actor (actor_id, first_name, last_name) <--> film_actor (actor_id, film_id) <--> film (film_id, title)
-- saco los actores (nombre y apellido) y la cantidad de películas en las que aparecen
SELECT a.first_name, a.last_name, COUNT(f.film_id) AS su_cantidad_de_películas
FROM actor AS a
JOIN film_actor AS f_a
ON a.actor_id = f_a.actor_id
JOIN film AS f
ON f_a.film_id = f.film_id
GROUP BY a.first_name, a.last_name;

-- mi solución: nombre y apellido de los actores que aparecen en más de 10 películas usando COUNT para hacer el recuento, un GROUP BY para agruparlos por nombre y apellido
-- y HAVING para realizar la condición de "más de 10", pues COUNT es una función de agregación que nos da un recuento que no existe en la tabla original, nos da una columna de grupo nueva
-- (que es cuando usamos el HAVING). Si la columna estuviera en la tabla podría usar un WHERE.
SELECT a.first_name, a.last_name
FROM actor AS a
JOIN film_actor AS f_a
ON a.actor_id = f_a.actor_id
JOIN film AS f
ON f_a.film_id = f.film_id
GROUP BY a.first_name, a.last_name
HAVING COUNT(f.film_id) > 10;
-- a mi parecer es más correcto incluir su_cantidad_de_películas por si fuera necesario saber cuántas peliculas (pero no lo pone el enunciado, lo dejo a parte)
SELECT a.first_name, a.last_name, COUNT(f.film_id) AS su_cantidad_de_películas
FROM actor AS a
JOIN film_actor AS f_a
ON a.actor_id = f_a.actor_id
JOIN film AS f
ON f_a.film_id = f.film_id
GROUP BY a.first_name, a.last_name
HAVING COUNT(f.film_id) > 10;

-- 19: Encuentra el título de todas las películas que son "R" y tienen una duración mayor a 2 horas en la tabla film.
-- entiendo que por "las películas que son "R"" se refiere al rating (tenemos PG, G, NC-17, PG-13 y R), 
-- y que duración mayor a 2 horas (son 120 min) se refiere a length > 120 
-- esquema: film (title, rating, length)
SELECT title, rating, length
FROM film; -- seviso los datos en film
SELECT title, rating, length
FROM film
WHERE rating = "R" AND length > 120;

-- mi solución: uso WHERE porque rating y length son 2 columnas de la tabla film (condiciones individuales)
SELECT title
FROM film
WHERE rating = "R" AND length > 120;

-- 20: Encuentra las categorías de películas que tienen un promedio de duración superior a 120 minutos y muestra el nombre de la categoría junto con el promedio de duración.
-- entiendo que promedio de duración superior a 120 minutos es AVG(length) > 120
-- esquema: category (category_id, name) <--> film_category (category_id, film_id) <--> film (film_id, title, length)
SELECT AVG(length)
FROM film; -- 115.27 la media de duración de las películas

-- mi solución: uso AVG(f.length) para sacar la media de duración y agrupando con GROUP BY me da la media de duración de cada categoría
-- y ahora uso HAVING para poner la condición "promedio de duración superior a 120 minutos" con la función de agragación AVG que es una columna que no existe en la tabla original
SELECT c.name AS nombre_categoría, AVG(f.length) AS promedio_duración
FROM category AS c
JOIN film_category AS f_c
ON c.category_id = f_c.category_id
JOIN film AS f
ON f_c.film_id = f.film_id
GROUP BY c.name
HAVING AVG(length) > 120;

-- 21: Encuentra los actores que han actuado en al menos 5 películas y muestra el nombre del actor junto con la cantidad de películas en las que han actuado.
-- esquema: actor (actor_id, first_name, last_name) <--> film_actor (actor_id, film_id) <--> film (film_id, title)
-- actores y su cantidad de películas (en las que han acuado):
SELECT a.first_name, a.last_name, COUNT(f.film_id) AS cantidad_películas
FROM actor AS a
JOIN film_actor AS f_a
ON a.actor_id = f_a.actor_id
JOIN film AS f
ON f_a.film_id = f.film_id
GROUP BY a.first_name, a.last_name
ORDER BY cantidad_películas; -- todos han actuado en más de 5 películas. Pero ¿y si no fuera así?

-- mi solución: uso COUNT para hacer el recuento de cantidad de películas, uno las 3 tablas con JOIN (que es un INNER join), y uso GROUP BY para agrupar por nombre y apellido 
-- (podría haber usado el actor_id en su lugar) y HAVING para la condición de "al menos 5" (que entiendo por ">= 5") "cantidad de películas" que es una columna q no existe en film
SELECT a.first_name, a.last_name, COUNT(f.film_id) AS cantidad_películas
FROM actor AS a
JOIN film_actor AS f_a
ON a.actor_id = f_a.actor_id
JOIN film AS f
ON f_a.film_id = f.film_id
GROUP BY a.first_name, a.last_name
HAVING cantidad_películas >= 5
ORDER BY cantidad_películas;

-- 22: Encuentra el título de todas las películas que fueron alquiladas por más de 5 días. Utiliza una subconsulta para encontrar los rental_ids con una duración superior a 5 días 
-- y luego selecciona las películas correspondientes.



