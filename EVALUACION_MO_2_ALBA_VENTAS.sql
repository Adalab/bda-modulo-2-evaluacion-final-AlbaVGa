# EVALUACION FINAL MODULO 2 - ALBA VENTAS GALLEGO

USE sakila;

/* EJERCICIO_1. Selecciona todos los nombres de las películas sin que aparezcan duplicados.*/
 
 SELECT DISTINCT *
 FROM film;
 
 /* EJERCICIO_2. Muestra los nombres de todas las películas que tengan una clasificación de "PG-13".*/
  -- Tabla: film
  -- SELECT: title
  -- Condición: rating = 'PG-13'

SELECT 
	title
FROM film
WHERE rating = "PG-13";

/* EJERCICIO_3. Encuentra el título y la descripción de todas las películas que contengan la palabra "amazing" en su descripción.*/
 
-- Tabla: film 
-- Select: columnas empleadas title y description.
-- Condicion = "%amazing% con operador LIKE.

SELECT
	title,
	description
FROM film
WHERE `description` LIKE '%amazing%';

/* EJERCICIO_4. Encuentra el título de todas las películas que tengan una duración mayor a 120 minutos.*/ 

-- Tabla:film.
-- SELECT:title.
-- Condicion: length > 120m

SELECT
	title
FROM film
WHERE length > 120
ORDER BY length;

/* EJERCICIO_5. Recupera los nombres de todos los actores.*/

-- Tabla: actor
-- SELECT:first_name y last_name

SELECT 
	CONCAT(first_name, ' ', last_name) AS NombreYApellidos
FROM actor;

/* EJERCICIO_6. Encuentra el nombre y apellido de los actores que tengan "Gibson" en su apellido.*/

-- Tabla: actor
-- SELECT: first_name y last_name
-- Condición: apellido ="Gibson"

SELECT
	first_name AS Nombre,
	last_name AS Apellido
FROM actor AS a
WHERE a.last_name LIKE "%Gibson%";

/*EJERCICIO_7.Encuentra los nombres de los actores que tengan un actor_id entre 10 y 20.*/

-- Tabla: actor
-- SELECT: firs_name y actor_id
-- Condicion: actor_id BETWEEN 10 y 20.

SELECT
	first_name,
	actor_id
FROM actor
WHERE actor_id BETWEEN 10 AND 20;

/* EJERCICIO_8.Encuentra el título de las películas en la tabla film que no sean ni "R" ni "PG-13" en cuanto a su clasificación.*/

-- Tabla: film.
-- SELECT: title y rating.
-- Condición ni "R" ni "PG-13" --> NOT IN.
-- Aplicamos ORDER BY.

SELECT
	title
FROM film
WHERE rating NOT IN ('R','PG-13')
ORDER BY title DESC;

/* EJERCICIO_9. Encuentra la cantidad total de películas en cada clasificación de la tabla film y muestra la clasificación junto con el recuento.*/

-- Tablas: film_category y category
-- SELECT: name, film_id y category_id. category_id es el elemento comun entre tablas.
-- Tipo union a aplicar "LEFT JOIN" que devuelve todos los registros de la tabla de la izq "category" con las filas correspondientes de la tabla derecha "film_category". 
-- Aplicar COUNT para determina la cantidad total películas por clasificación.

SELECT *
FROM category;

SELECT *
FROM film_category;

SELECT
	c.name AS Clasificación,
	COUNT(film_id) AS CantidadTotal
FROM category AS c
LEFT JOIN film_category AS f
	ON f.category_id = c.category_id
GROUP BY
	c.name;

/* EJERCICIO_10.Encuentra la cantidad total de películas alquiladas por cada cliente y muestra el ID del cliente, su nombre y apellido junto con la cantidad de películas alquiladas.*/

-- Tablas; customer, rental y inventory
-- SELECT: rental_id, customer_id,first_name, last_name, customer_id e inventory_id. Customer_id e inventory_id son las columnas comunes entre customer-rental y rental-inventory
-- Tipo union; INNER JOIN, combina los registros de ambas tablas y devuelve los valores con coincidencias en ambas. Nos interesa esta union dado que nos muestra la cantidad total de películas alquiladas, e.i. nos devuelve solo los clientes que han alquilado.

SELECT
	c.customer_id AS Cliente,
	c.first_name AS Nombre,
	c. last_name AS Apellido,
	COUNT(rental_id) AS CantidadPeliculasAlquiladas
FROM customer AS c
INNER JOIN rental AS r
	ON c.customer_id = r.customer_id
INNER JOIN inventory  AS i
	ON r.inventory_id = i.inventory_id
GROUP BY 
	c.customer_id,
	c.first_name,
	c.last_name
ORDER BY CantidadPeliculasAlquiladas DESC;

/* EJERCICIO_11. Encuentra la cantidad total de películas alquiladas por categoría y muestra el nombre de la categoría junto con el recuento de alquileres.*/
-- Tablas: film,film_category, category, rental e inventory.
-- SELECT: inventory_id, rental_id, film_id,category_i, film_id
-- Posibles formas de resolver:aplicando 4 INNER JOIN o con subconsultas.En este último caso se ha realizado una query con cantidad total pelis alquiladas por categoría.

-- SIN  SUBCONSULTAS
SELECT
	c.name,
	COUNT(r.rental_id) AS TotalPelículasCategoría
FROM category AS c
INNER JOIN film_category AS fc
	ON c.category_id = fc.category_id
INNER JOIN inventory AS i
	ON fc.film_id = i.film_id
INNER JOIN rental AS r
	ON i.inventory_id = r.inventory_id
GROUP BY
	c.name;

-- CON SUBCONSULTAS
SELECT c.name AS Nombre,
       (SELECT COUNT(r.rental_id)
        FROM rental AS r
        INNER JOIN inventory  AS i 
        ON r.inventory_id = i.inventory_id
        WHERE i.film_id IN (
            SELECT fc.film_id
            FROM film_category AS fc
            WHERE fc.category_id = c.category_id
        )) AS TotalPelículasCategoría
FROM category AS c;

/* EJERCICIO_12.Encuentra el promedio de duración de las películas para cada clasificación de la tabla film y muestra la clasificación junto con el promedio de duración.*/
-- Tabla: film
-- SELECT: rating y promedioduración.
-- Aplicamos AVG para determinar promedio duracion peliculas por clasificación.

SELECT 
	rating,
	AVG(length) AS PromedioDuracion
FROM film
GROUP BY rating;

/* EJERCICIO_13.Encuentra el nombre y apellido de los actores que aparecen en la película con title "Indian Love".*/
-- Compruebo que la película esta en mi BBD.
-- Query Principal
	-- Tablas: film, film_actor y actor.
	-- Select: first_name y last_name.
	-- Condición: title LIKE "%Indian Love%".
	-- Tipo Union: LEFT JOIN.

 SELECT 
	a.first_name,
	a.last_name
FROM actor AS a
LEFT JOIN  film_actor AS fa
	ON a.actor_id = fa.actor_id
LEFT JOIN film AS f
	ON fa.film_id = f.film_id
WHERE f.title LIKE'%Indian Love%';

 /* EJERCICIO_14.Muestra el título de todas las películas que contengan la palabra "dog" o "cat" en su descripción.*/

-- Varias formas de resolver el ejercicio:con LIKE, o bien, con REGEXP, haciendo OPERADOR '|'(alternativas).
SELECT 
	title
FROM film
WHERE `description`LIKE'%dog%' OR `description` LIKE '%cat%';

SELECT 
	title
FROM film
WHERE `description` REGEXP 'dog|cat';

/*EJERCICIO_15.Encuentra el título de todas las películas que fueron lanzadas entre el año 2005 y 2010.*/
-- Tabla: film.
-- SELECT: title y release_year.
-- CONDICION: (2005-2010).
SELECT
	title,
	release_year
FROM film
WHERE release_year BETWEEN 2004 AND 2010;

/*EJERCICIO_16.Encuentra el título de todas las películas que son de la misma categoría que "Family".*/

-- Tabla:film, category y film_category.
-- SELECT: title y name.
-- Condicion: name ="Family".

SELECT 
	f.title
FROM film AS f
INNER JOIN film_category AS fc
	ON f.film_id = fc.film_id
INNER JOIN category AS c
	ON fc.category_id = c.category_id
WHERE c.name = 'Family'
ORDER BY title DESC;

/*EJERCICIO_17.Encuentra el título de todas las películas que son "R" y tienen una duración mayor a 2 horas en la tabla film.*/
-- Tabla: film
-- SELECT:title, rating y length.
-- Condiciones: rating ('R') y length > 120min.

SELECT 
	title,
	rating
FROM film
WHERE rating IN ('R') AND length > 120;

/*EJERCICIO_18. Muestra el nombre y apellido de los actores que aparecen en más de 10 películas.*/

-- Tablas: actor y film_actor.
-- SELECT: first_name y last_name. Columnas comunes entre tablas: actor_id.
-- Condición: COUNT(film_id) > 10 peliculas
-- Tipo UNION empleada INNER JOIN
-- HAVING para filtrar sobre GROUP BY

SELECT *
FROM actor;

SELECT
	a.first_name AS Nombre,
	a.last_name AS Apellido
FROM actor AS a
INNER JOIN film_actor AS fa
	ON a.actor_id = fa.actor_id
GROUP BY
	fa.actor_id
HAVING COUNT(fa.film_id) >10;

/*EJERCICO_19. Hay algún actor o actriz que no apareca en ninguna película en la tabla film_actor.*/

-- Tablas: actor y film_actor.
-- SELECT: first_name y last_name. Columnas comunes entre tablas  actor_id.
-- LEFT JOIN. Todos los registro de la tabla  actor (izq) y los comunes de film_actor(dcha)
-- Condicion: en ninguna película ( IS NULL).

SELECT 
	a.first_name AS Nombre,
	a.last_name  AS Apellidos
FROM actor AS a
LEFT JOIN film_actor AS fa 
	ON a.actor_id = fa.actor_id
WHERE fa.film_id IS NULL;


/*EJERCICIO_20.Encuentra las categorías de películas que tienen un promedio de duración superior a 120 minutos y muestra el nombre de la categoría junto con el promedio de duración.*/

-- Tablas: category, film_category y film.
-- SELECT: category_id, name y AVG(length). Columnas comunes entre tablas"category_id" y "film_id".
-- LEFT JOIN. Todos los registro de la tabla  actor (izq) y los comunes de film_actor(dcha)

SELECT
	c.category_id AS IdCategoria,
	c.name AS Nombre,
	AVG(f.length) AS PromedioDuracion
FROM category AS c
INNER JOIN film_category AS fc 
	ON c.category_id = fc.category_id
INNER JOIN film AS f 
	ON fc.film_id = f.film_id
GROUP BY
	c.category_id, 
c.name
HAVING AVG(f.length) > 120;

/* EJERCICIO_21.Encuentra los actores que han actuado en al menos 5 películas y muestra el nombre del actor junto con la cantidad de películas en las que han actuado.*/

-- Tablas: actor y film_actor.
-- Columnas comunes: actor_id.
-- Elementos SELECT: actor, nombre y conteo películas.
-- UNION: LEFT JOIN, muestra todos los actores incluso si no salen en la película.
-- Agrupamos sobre actores y filtramos con HAVING sobre los que aparecen en más de 5 películas.

SELECT
	a.actor_id,
	a.first_name AS Nombre,
	COUNT(fa.film_id) AS CantidadPelisActor
FROM actor AS a
LEFT JOIN film_actor AS fa
	ON a.actor_id =fa.actor_id
GROUP BY
	a.actor_id
HAVING COUNT(fa.film_id) >5;

/*EJERCICIO_22. Encuentra el título de todas las películas que fueron alquiladas por más de 5 días. Utiliza una subconsulta para encontrar los rental_ids con una duración superior a 5 días y luego selecciona las
películas correspondientes.*/ 

-- Tablas:film, inventory y rental.
-- Query Principal:
	-- SELECT: title
    -- Subconsulta

-- -- Subconsulta: con los inventory_id de la tabla rental que han sido alquilados durante más de 5 días.
SELECT r.inventory_id
FROM rental AS r
WHERE DATEDIFF(r.return_date, r.rental_date) > 5;

-- Query Principal
SELECT 
	f.title AS Título
FROM film AS f
WHERE f.film_id IN (
		SELECT r.inventory_id
		FROM rental AS r
		WHERE DATEDIFF(r.return_date, r.rental_date) > 5);

/*EJERCICIO_23.Encuentra el nombre y apellido de los actores que no han actuado en ninguna película de la categoría "Horror". Utiliza una subconsulta para encontrar los actores que han actuado en películas de la
categoría "Horror" y luego exclúyelos de la lista de actores.*/
-- Tablas: actor, film_actor, category y film_category.
-- Query principal:
	-- SELECT: first_name y last_name.
    -- NOT IN para excluir los actores que participan en películas "Horror"
    -- Subconsulta: actores que participan en películas de horror.
		-- Columnas comunes: category_id(category-film_category), film_id(film_category-film_actor) y actor_id (film_actor -actor).
        -- TIPO UNION empleamos INNER JOIN para seleccionar solo actores asociados  a cateegoría 'horror'.
-- Verificar resultado.

-- Query Principal

SELECT
	a.last_name AS Apellido,
	a.first_name AS Nombre
FROM actor AS a
WHERE a.actor_id NOT IN(
	SELECT
	fa.actor_id
	FROM category AS c
	INNER JOIN film_category AS fc
	ON c.category_id = fc.category_id
	INNER JOIN film_actor AS fa
	ON fc.film_id = fa.film_id
	WHERE c.name = 'Horror');

-- Subsconsulta
SELECT
	fa.actor_id
FROM category AS c
INNER JOIN film_category AS fc
	ON c.category_id = fc.category_id
INNER JOIN film_actor AS fa
	ON fc.film_id = fa.film_id
WHERE c.name = 'Horror';

-- Verificamos los actores que trabajan en películas de horror.
SELECT
    fa.actor_id,
    a.first_name, 
    a.last_name
FROM film_actor AS fa
INNER JOIN film_category AS fc 
	ON fa.film_id = fc.film_id
INNER JOIN category AS c 
	ON fc.category_id = c.category_id
INNER JOIN actor AS a 
	ON fa.actor_id = a.actor_id
WHERE c.name = 'Horror';

/*EJERCICIO_24. Encuentra el título de las películas que son comedias y tienen una duración mayor a 180 minutos en la tabla film.*/

-- Query principal
SELECT
f.title AS PelículasComedias
FROM film AS f
WHERE f.film_id IN(SELECT 
	fc.film_id
	FROM film_category AS fc
	LEFT JOIN category AS c
	ON fc.category_id = c.category_id
	WHERE c.name ='Comedy')
AND length > 180;

-- Subcobsulta: películas  en la categoría de comedia.
SELECT 
fc.film_id
FROM film_category AS fc
LEFT JOIN category AS c
ON fc.category_id = c.category_id
WHERE c.name ='Comedy';

/*EJERCICIO_25.Encuentra todos los actores que han actuado juntos en al menos una película. La consulta debe mostrar el nombre y apellido de los actores y el número de películas en las que han actuado juntos*/
-- Tabla: actor y film_actor
-- Columnas comunes = actor_id
-- Tipo UNION: SELF JOIN, nos permite combinar la tabla film_actor consigo misma. Unimos con la tabla actor para sacar detalles de actor1 y actor2.
SELECT
	a1.first_name AS Nombre1,
	a1.last_name AS Apellido1,
	a2.first_name AS Nombre2,
	a2.last_name AS Apellido2,
COUNT(DISTINCT fa1.film_id) AS NumPelisJuntos
FROM film_actor AS fa1
JOIN film_actor AS fa2
	ON fa1.film_id = fa2.film_id
JOIN actor AS a1
	ON fa1.actor_id = a1.actor_id
JOIN actor AS a2
	ON fa2.actor_id = a2.actor_id
WHERE fa1.actor_id < fa2.actor_id  
GROUP BY
a1.actor_id,
a2.actor_id
HAVING COUNT(DISTINCT fa1.film_id) >= 1;




