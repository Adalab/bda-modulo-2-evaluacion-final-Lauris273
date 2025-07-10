Este documento contiene información sobre el desarrollo del Ejercicio de Evaluación del Módulo 2 "Extraer información de la web y bases de datos" de la alumna de Adalab Laura Fernández Rodríguez (Lauris273 en GitHub).

En esta evaluación se revisarán mi comprensión y habilidades con SQL, por lo que los resultados de la evaluación se presentarán en un archivo sql.
Como base de datos tomamos la Base de Datos Sakila, la cuál contiene tablas como film (películas), actor (actores), customer (clientes), rental (alquileres), category (categorías), entre otras. Estas tablas contienen información sobre películas, actores, clientes, alquileres y más, y se utilizan para realizar consultas y análisis de datos en el contexto de una tienda de alquiler de películas. 
En total son 24 ejercicios + 1 bonus (cuyas soluciones se subirán en archivo sql) y posteriormente realizaré una entrevista técnica en la que explicaré mis resultados y otros conceptos del módulo. La evalación tendrá los siguientes criterios de evaluación: 
Extracción de datos
- Entender que es una API y para qué son útiles.*
- Manejarlos resultados de un json para su limpieza y extracción de datos.*
- Saber extraer datos con Beautiful Soup y Selenium
SQL
- Dominar las queries básicas: SELECT; UPDATE; DELETE; INSERT. Por ejemplo:
SELECT DISTINCT title
    FROM film; 
- Dominar las funciones GROUP BY, WHERE y HAVING. Por ejemplo:
SELECT a.first_name, a.last_name
    FROM actor AS a
    JOIN film_actor AS f_a
    ON a.actor_id = f_a.actor_id
    JOIN film AS f
    ON f_a.film_id = f.film_id
    GROUP BY a.first_name, a.last_name
    HAVING COUNT(f.film_id) > 10;
- Dominar el uso de JOINS (incluyendo UNION y UNION ALL)*
- Dominar el uso de Subconsultas. Por ejemplo:
SELECT DISTINCT f.title
    FROM film AS f
    JOIN inventory AS i
    ON f.film_id = i.film_id
    JOIN rental AS r
    ON i.inventory_id =r.inventory_id
    WHERE r.rental_id IN (SELECT rental_id
                            FROM rental
                            WHERE TIMESTAMPDIFF(DAY, rental_date, return_date) > 5);
- Dominar el uso de las Subconsultas Correlacionadas

