SELECT countries.name, continents.continent_name FROM countries
JOIN continents ON (countries.continent_id = continents.id);

SELECT name, capital FROM countries
WHERE continent_id IN (SELECT id FROM continents WHERE continent_name = 'Europe');

SELECT DISTINCT s.first_name FROM singers s
JOIN albums a ON a.singer_id = s.id
WHERE a.label = 'Warner Bros';

SELECT s.first_name, s.last_name, a.album_name, a.released FROM singers s
JOIN albums a ON a.singer_id = s.id
WHERE s.deceased = false AND date_part('year', a.released) BETWEEN 1979 AND 1990
ORDER BY s.date_of_birth DESC;

SELECT s.first_name, s.last_name FROM singers s
LEFT JOIN albums a ON s.id = a.singer_id
WHERE a.singer_id IS NULL;

SELECT first_name, last_name FROM singers
WHERE id NOT IN (SELECT singer_id FROM albums);

SELECT orders.*, products.* FROM orders
JOIN order_items ON orders.id = order_items.order_id
JOIN products ON order_items.product_id = products.id;

-- id of any ORDER that includes fries
SELECT o.id FROM orders o
JOIN order_items oi ON o.id = oi.order_id
JOIN products p ON oi.product_id = p.id
WHERE p.product_name = 'Fries';

SELECT DISTINCT c.customer_name "Customers who like Fries" FROM customers c
JOIN orders o ON c.id = o.customer_id
JOIN order_items oi ON o.id = oi.order_id
JOIN products p ON oi.product_id = p.id
WHERE p.product_name = 'Fries';

-- total cost of Natasha O'Shea orders
SELECT sum(p.product_cost) from products p
JOIN order_items oi ON p.id = oi.product_id
JOIN orders o ON o.id = oi.order_id
WHERE o.customer_id = 2;

SELECT p.product_name, count(oi.product_id) from products p
JOIN order_items oi ON p.id = oi.product_id
GROUP BY p.product_name ORDER BY p.product_name ASC;