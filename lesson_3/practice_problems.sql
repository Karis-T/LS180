/* Practice problems 1 */
-- 2
SELECT count(id) FROM tickets;

-- 3
SELECT count(DISTINCT customer_id) FROM tickets;

-- 4
SELECT round(count(DISTINCT t.customer_id)::decimal
/ count(DISTINCT c.id) * 100, 2) FROM customers c
LEFT JOIN tickets t ON t.customer_id = c.id;

-- 5
SELECT e.name, count(t.event_id) popularity FROM events e
  JOIN tickets t ON t.event_id = e.id
  GROUP BY e.name ORDER BY popularity DESC;

-- 6
SELECT c.id, c.email, count(DISTINCT t.event_id) from customers c
  JOIN tickets t ON t.customer_id = c.id
  GROUP BY c.id HAVING count(DISTINCT event_id) = 3;

-- 7
SELECT e.name AS event, e.starts_at, sc.name AS section, st.row, st.number AS seat from tickets t
  JOIN events e ON (t.event_id = e.id)
  JOIN customers c ON (t.customer_id = c.id)
  JOIN seats st ON (t.seat_id = st.id)
  JOIN sections sc ON (st.section_id = sc.id)
  WHERE c.email = 'gennaro.rath@mcdermott.co';

/* Practice problems 2 */

-- 2
ALTER TABLE orders ADD CONSTRAINT orders_product_id_fkey FOREIGN KEY (product_id) REFERENCES products(id);

-- 3
INSERT INTO products (name) VALUES ('small bolt'), ('large bolt');
INSERT INTO orders (product_id, quantity) VALUES (1, 10), (1, 25), (2, 15);

-- 4
SELECT quantity, name FROM orders JOIN products ON orders.product_id = products.id;

-- 5
yes you can insert not null rows into foreign key columns
INSERT INTO orders (quantity) VALUES (42);

-- 6
error occurs if you have an existing null value in the column

-- 7
DELETE FROM orders WHERE product_id IS NULL;
ALTER TABLE orders ALTER COLUMN product_id SET NOT NULL;

-- 8
CREATE TABLE reviews (id serial primary key, review text not null, product_id integer references products (id));

-- 9
INSERT INTO reviews (review, product_id)
  VALUES ('a little small', 1),
         ('very round!', 1),
         ('could have been smaller', 2);

-- 10
false - foreign key columns allow NULL values. Use NOT NULL and foreign key constraints together;

/* Practice problems 3 */
-- 1
INSERT INTO calls ("when", duration, contact_id)
  VALUES ('2016-01-18 14:47:00', 632, 6);

-- 2
SELECT calls.when, calls.duration, contacts.first_name FROM calls JOIN contacts
  ON calls.contact_id = contacts.id WHERE contacts.id != 6;

SELECT calls.when, calls.duration, contacts.first_name FROM calls JOIN contacts
  ON calls.contact_id = contacts.id WHERE (contacts.first_name || ' ' || contacts.last_name) != 'William Swift';

-- 3
INSERT INTO contacts (first_name, last_name, number)
  VALUES ('Merve', 'Elk', '6343511126'),
         ('Sawa', 'Fyodorov', '6125594874');

INSERT INTO calls ("when", duration, contact_id)
  VALUES ('2016-01-17 11:52:00', 175, 26),
         ('2016-01-18 21:22:00', 79, 27);

-- 4
ALTER TABLE contacts ADD CONTSTRAINT number_unique UNIQUE (number);

-- 5
ERROR:  duplicate key value violates unique constraint "number_unique"
DETAIL:  Key (number)=(6125594874) already exists.

-- 6
when is a reserved keyword that forms part of case statement
non-reserved words can be used in table / column names but are known to the SQL parser and have a special meaning

if you get parser errors for commands that contain keywords try to add double quotes to see if the problem goes away