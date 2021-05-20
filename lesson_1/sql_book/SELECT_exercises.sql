SELECT population FROM countries
WHERE name = 'USA';

SELECT population, capital FROM countries;

SELECT name FROM countries
ORDER BY name;

SELECT name, capital FROM countries
ORDER BY population;

SELECT name, capital FROM countries
ORDER BY population DESC;

SELECT name, binomial_name, max_weight_kg, max_age_years
FROM animals ORDER BY max_age_years, max_weight_kg, name DESC;

-- The initial ordering, by max_age_years, affects all five rows. Within this ordering, since three of the rows (Peregrine Falcon, Pigeon, and Dove) have the same value, the ordering between them is arbitrary.

-- The second level of ordering, by max_weight_kg, affects only these three rows; whatever happens at this level of ordering doesn't affect the initial level of ordering which placed the Golden Eagle and Kakapo rows at the bottom. Here again two of the rows (Pigeon, and Dove) have the same value, so the ordering between them is arbitrary.

-- The final level of ordering, by name, affects only those two rows who had the same value for the previous order condition. Here we specify a sort direction so that the Pigeon row ends up above the Dove row.

SELECT name FROM countries
WHERE population > 70000000;

SELECT first_name, last_name FROM celebrities
WHERE deceased = false OR deceased IS NULL;

SELECT first_name, last_name FROM celebrities
WHERE occupation ILIKE 'Sing%'
AND occupation ILIKE '%Act%';

SELECT burger FROM orders
WHERE burger_cost < 5
ORDER BY burger_cost;

SELECT customer_name, customer_email, customer_loyalty_points
FROM orders WHERE customer_loyalty_points >= 20
ORDER BY customer_loyalty_points DESC;

SELECT burger FROM orders
WHERE customer_name = 'Natasha O''Shea';

SELECT customer_name FROM orders
WHERE drink IS NULL;

SELECT burger, side, drink FROM orders
WHERE side != 'Fries' OR side IS NULL;

SELECT burger, side, drink, FROM orders
WHERE side IS NOT NULL AND drink IS NOT NULL;