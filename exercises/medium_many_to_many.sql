each customer can have many services
every service can have many customers
both have optional modularity

CREATE DATABASE billing;
\c billing

CREATE TABLE customers(
  id serial PRIMARY KEY,
  name text NOT NULL,
  payment_token char(8) NOT NULL UNIQUE CHECK (payment_token LIKE UPPER(payment_token))
);

CREATE TABLE services(
  id serial PRIMARY KEY,
  description text NOT NULL,
  price numeric(10,2) NOT NULL CHECK (price >= 0.00)
);

INSERT INTO customers (name, payment_token)
  VALUES ('Pat Johnson', 'XHGOAHEQ'),
         ('Nancy Monreal', 'JKWQPJKL'),
         ('Lynn Blake', 'KLZXWEEE'),
         ('Chen Ke-Hua', 'KWETYCVX'),
         ('Scott Lakso', 'UUEAPQPS'),
         ('Jim Pornot', 'XKJEYAZA');

INSERT INTO services (description, price)
  VALUES ('Unix Hosting', 5.95),
         ('DNS', 4.95),
         ('Whois Registration', 1.95),
         ('High Bandwidth', 15.00),
         ('Business Support', 250.00),
         ('Dedicated Hosting', 50.00),
         ('Bulk Email', 250.00),
         ('One-to-one Training', 999.00);

CREATE TABLE customers_services (
  id serial PRIMARY KEY,
  customer_id integer REFERENCES customers (id) ON DELETE CASCADE NOT NULL,
  service_id integer REFERENCES services (id) NOT NULL,
  UNIQUE (customer_id, service_id)
);

INSERT INTO customers_services (customer_id, service_id)
  VALUES (1, 1),
         (1, 2),
         (1, 3),
         (3, 1),
         (3, 2),
         (3, 3),
         (3, 4),
         (3, 5),
         (4, 1),
         (4, 4),
         (5, 1),
         (5, 2),
         (5, 6),
         (6, 1),
         (6, 6),
         (6, 7);

SELECT DISTINCT c.* FROM customers c
INNER JOIN customers_services cs
    ON c.id = cs.customer_id;

SELECT * FROM customers
  WHERE id IN (SELECT customer_id FROM customers_services);

SELECT * FROM customers
WHERE id NOT IN
  (SELECT customer_id FROM customers_services);

SELECT DISTINCT c.* FROM customers c
LEFT JOIN customers_services cs
       ON c.id = cs.customer_id
WHERE service_id IS NULL;

SELECT c.*, s.* FROM customers c
FULL JOIN customers_services cs ON cs.customer_id = c.id
FULL JOIN services s ON s.id = cs.service_id
WHERE cs.service_id IS NULL OR cs.customer_id IS NULL;

SELECT s.description FROM customers_services cs
  RIGHT OUTER JOIN services s ON cs.service_id = s.id
  WHERE cs.service_id IS NULL;

SELECT c.name,
       string_agg(s.description, E'\n') AS services
FROM customers c
LEFT OUTER JOIN customers_services cs
             ON c.id = cs.customer_id
LEFT OUTER JOIN services s
             ON s.id = cs.service_id
GROUP BY c.id;

SELECT CASE lag(customers.name) OVER (ORDER BY customers.name)
       WHEN customers.name THEN NULL
       ELSE customers.name
       END,
       services.description
  FROM customers
       LEFT OUTER JOIN customers_services
       ON customer_id = customers.id

       LEFT OUTER JOIN services
       ON services.id = service_id;

SELECT s.description, COUNT(cs.service_id)
FROM services s
INNER JOIN customers_services cs
        ON s.id = cs.service_id
GROUP BY s.description
HAVING COUNT(cs.service_id) >= 3;

SELECT sum(s.price) AS gross
FROM services s
INNER JOIN customers_services cs
        ON s.id = cs.service_id;

INSERT INTO customers (name, payment_token)
  VALUES ('John Doe', 'EYODHLCN');

INSERT INTO customers_services (customer_id, service_id)
  VALUES (7, 1),
         (7, 2),
         (7, 3);

SELECT sum(s.price)
FROM customers c
INNER JOIN customers_services cs
        ON c.id = cs.customer_id
INNER JOIN services s
        ON s.id = cs.service_id
WHERE s.price > 100;

SELECT sum(s.price)
FROM customers c
CROSS JOIN services s
WHERE s.price > 100;

DELETE FROM customers_services WHERE service_id = 7;
DELETE FROM services WHERE description = 'Bulk Email';

DELETE FROM customers WHERE name = 'Chen Ke-Hua';