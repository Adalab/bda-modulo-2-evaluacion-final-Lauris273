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
-- esquema: actor (first_name, last_name)















