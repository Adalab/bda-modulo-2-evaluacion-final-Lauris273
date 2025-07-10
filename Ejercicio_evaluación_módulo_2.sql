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

SELECT CONCAT(first_name, ' ', last_name) AS nombre_completo_actor
FROM actor; -- podría unirlos en una columna para confirmar que cada nombre va con su apellido (salen 200 rows)

-- mi solución: poniendo sólo first_name tenemos los nombres de todos los actores (salen 200 rows) (solicitan nombres, aunque veo más completa la del CONCAT)
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
WHERE actor_id BETWEEN 10 AND 20; -- actor_id entre 10 y 20, incluyendo 10 y 20, con BETWEEN
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
SELECT title
FROM film
WHERE rating NOT IN ("PG-13", "R"); -- otra opción sería usar el NOT IN que excluye los valores dados de la lista de valores de rating
-- sinceramente yo veo más completo con éste que sigue (lo incluyo por si fuera interesante saber la clasificación para el solicitante):
SELECT title, rating AS clasificación
FROM film
WHERE rating NOT IN ("PG-13", "R");

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
SELECT title
FROM film
WHERE description REGEXP 'dog|cat'; -- opción con REGEXP

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
WHERE release_year BETWEEN 2005 AND 2010; -- release_year entre 2005 y 2010, incluyendo 2005 y 2010, con el BETWEEN
SELECT title
FROM film
WHERE release_year > 2005 AND release_year < 2010; -- release_year entre 2005 y 2010, excluyendo 2005 y 2010

-- 17: Encuentra el título de todas las películas que son de la misma categoría que "Family".
-- esquema: category (category_id, name) <--> film_category (category_id, film_id) <--> film (film_id, title) 
-- mi solución: unir las tablas film, film_category y category con INNER JOIN (quiero sólo las pelis de categoría "Family")
SELECT f.title
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
FROM film; -- reviso los datos en film
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
-- esquema: film (film_id, title) <--> inventory (film_id, inventory_id) <--> rental (inventory_id, rental_id, rental_date, return_date)
-- miro qué hay en rental que me interese: rental_date, return_date son DATETIME e inventory_id la puedo unir al inventory_id de inventory
SELECT inventory_id, rental_date, return_date
FROM rental;
-- uso la función TIMESTAMPDIFF por que calcula la diferencia entre dos valores de tipo fecha/hora y devuelve la diferencia en la unidad que le indique (DAY)
-- su síntexis básica es TIMESTAMPDIFF(unidad, fecha_inicial, fecha_final) y calcula cuántos días hay de fecha_inicial hasta fecha_final
SELECT rental_id, rental_date, return_date
FROM rental
WHERE TIMESTAMPDIFF(DAY, rental_date, return_date) > 5; -- muchos rental_id, deberían salir muchas películas 
SELECT f.film_id, f.title
FROM film AS f
JOIN inventory AS i
ON f.film_id = i.film_id
JOIN rental AS r
ON i.inventory_id =r.inventory_id;

-- mi solución: uno las columnas con JOIN porque quiero sólo las coincidencias entre tablas, DISTINCT porque salen varias veces las mismas películas. 
-- Esto es porque salen muchos rental_id del TIMESTAMPDIFF (muchas películas se han devuelto después de 5 días). Como la subconsulta es un conjunto de datos, 
-- uso IN porque comprueba cada rental_id de la tabla rental con los rental_id de la subconsulta
SELECT DISTINCT f.title
FROM film AS f
JOIN inventory AS i
ON f.film_id = i.film_id
JOIN rental AS r
ON i.inventory_id =r.inventory_id
WHERE r.rental_id IN (SELECT rental_id
						FROM rental
						WHERE TIMESTAMPDIFF(DAY, rental_date, return_date) > 5);
                        
-- mi solución usando CTEs: creo alquiler_más_5_días con la subconsulta donde tengo los rental_id que tardaron más de 5 días en devolver. Ésta es una tabla "ficticia", no existe fuera,
-- aunque sí en la consulta, por lo que puedo unirla con un JOIN y comparar los rental_id de las tablas rental y alquiler_más_5_días. 
-- No puedo hacer 2 CTEs porque no hay columnas en común en las 2 consultas a parte de rental_id (lo he intentado!)
WITH alquiler_más_5_días AS (SELECT rental_id
								FROM rental
								WHERE TIMESTAMPDIFF(DAY, rental_date, return_date) > 5)
SELECT DISTINCT f.title
FROM film AS f
JOIN inventory AS i
ON f.film_id = i.film_id
JOIN rental AS r
ON i.inventory_id =r.inventory_id
JOIN alquiler_más_5_días AS a_m_5_d
ON r.rental_id = a_m_5_d.rental_id;

-- 23: Encuentra el nombre y apellido de los actores que no han actuado en ninguna película de la categoría "Horror". Utiliza una subconsulta para encontrar 
-- los actores que han actuado en películas de la categoría "Horror" y luego exclúyelos de la lista de actores.
-- esquema: actor (actor_id, first_name, last_name) --> film_actor (film_id, actor_id) --> film (film_id, title) --> film_category (film_id, category_id) --> category (category_id, name)
SELECT a.actor_id, a.first_name, a.last_name
FROM actor AS a
INNER JOIN film_actor AS f_a
ON a.actor_id = f_a.actor_id
INNER JOIN film AS f
ON f_a.film_id = f.film_id
INNER JOIN film_category AS f_c
ON f.film_id = f_c.film_id
INNER JOIN category AS c
ON f_c.category_id = c.category_id
WHERE c.name = "Horror"; -- 317 actores en la subconsulta, que hay que excluir de la consulta

-- mi solución: en la consulta saco los actores cuyos actor_id NO ESTÉN en la subconsulta, que nos dice quienes sí han participado en películas de horror
SELECT a.first_name, a.last_name
FROM actor AS a
WHERE a.actor_id NOT IN (SELECT a.actor_id
							FROM actor AS a
							INNER JOIN film_actor AS f_a
							ON a.actor_id = f_a.actor_id
							INNER JOIN film AS f
							ON f_a.film_id = f.film_id
							INNER JOIN film_category AS f_c
							ON f.film_id = f_c.film_id
							INNER JOIN category AS c
							ON f_c.category_id = c.category_id
							WHERE c.name = "Horror")
ORDER BY a.last_name; -- me salen 44 actores que no han participado en películas de Horror

-- mi solución usando CTEs: aquí sí tengo actor_id en las 2. Lo que cambia está en el último SELECT: uso los nombres de las tablas ficticias, uso un LEFT JOIN porque 
-- quiero a los actores que no estén en la subconsulta y le digo ésta condición en el WHERE horror.actor_id IS NULL, que es "donde no estén los actores de las pelis de horror"
WITH actores_pelis_horror AS (SELECT a.actor_id
								FROM actor AS a
								INNER JOIN film_actor AS f_a
								ON a.actor_id = f_a.actor_id
								INNER JOIN film AS f
								ON f_a.film_id = f.film_id
								INNER JOIN film_category AS f_c
								ON f.film_id = f_c.film_id
								INNER JOIN category AS c
								ON f_c.category_id = c.category_id
								WHERE c.name = "Horror"), 
todos_los_actores AS (SELECT a.actor_id, a.first_name, a.last_name
                         FROM actor AS a)
SELECT todos.first_name, todos.last_name
FROM todos_los_actores AS todos
LEFT JOIN actores_pelis_horror AS horror
ON todos.actor_id = horror.actor_id
WHERE horror.actor_id IS NULL
ORDER BY todos.last_name;

-- 24: Encuentra el título de las películas que son comedias (Comedy) y tienen una duración mayor a 180 minutos en la tabla film.
-- esquema: film (film_id, title, length) --> film_category (film_id, category_id) --> category (category_id, name)
SELECT title, length
FROM film
WHERE length > 180; -- películas con duración > 180 min

-- mi solución: unir las tablas con JOIN (cólo quiero películas q sean comedia) e incluir un WHERE con las 2 condiciones c.name = "Comedy" AND f.length > 180
SELECT f. title
FROM film AS f
JOIN film_category AS f_c
ON f.film_id = f_c.film_id
JOIN category AS c
ON f_c.category_id = c.category_id
WHERE c.name = "Comedy" AND f.length > 180; 

-- BONUS: 
-- 25.Encuentra todos los actores que han actuado juntos en al menos una película. 
-- La consulta debe mostrar el nombre y apellido de los actores y el número de películas en las que han actuado juntos.
-- esquema: actor (actor_id, first_name, last_name) --> film_actor (film_id, actor_id) --> film (film_id, title)
-- entiendo que queremos comparar actores, así que sería hacer un SELF JOIN:
SELECT a1.first_name AS nombre1_actor1,
		a1.last_name AS apellido_actor1,
		a2.first_name AS nombre_actor2,
		a2.last_name AS apellido_actor2,
        COUNT(film_id)
FROM actor As a1, actor As a2
JOIN film_actor -- pero hay q unirla a film_actor con un JOIN
ON actor_id  -- y ahora con qué lo uno? con a1 o con a2?
WHERE a1.actor_id <> a2.actor_id -- no compara consigo mismo
AND film_id = film_id; -- misma película: necesito 2 film_id voy a unirlo con 2 film_actor

-- mi solución: no sale
-- lo he intentado pero no comprende qué es a1.actor_id en el WHERE y si lo incluyo en el SELECT también me dice que es Unknown
-- probablemente haya algo más erróneo...
SELECT a1.first_name AS nombre1_actor1,
		a1.last_name AS apellido_actor1,
		a2.first_name AS nombre_actor2,
		a2.last_name AS apellido_actor2,
        COUNT(f_a1.film_id)
FROM actor As a1, actor As a2
JOIN film_actor AS f_a1
ON a1.actor_id = f_a1.actor_id
JOIN film_actor AS f_a2
ON a2.actor_id = f_a2.actor_id
WHERE a1.actor_id <> a2.actor_id -- no compara consigo mismo
AND f_a1.film_id = f_a2.film_id; -- misma película



