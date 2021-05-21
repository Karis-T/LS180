ALTER TABLE animals
ADD COLUMN class varchar(100);

UPDATE animals SET class = 'Aves';

ALTER TABLE animals
ADD COLUMN phylum varchar(100),
ADD COLUMN kingdom varchar(100);

UPDATE animals
SET phylum = 'Chordata', kingdom = 'Animalia';

ALTER TABLE countries
ADD COLUMN continent varchar(50);

UPDATE countries
SET continent = 'Europe'
WHERE name = 'France' OR name = 'Germany';

UPDATE countries
SET continent = 'Asia'
WHERE name = 'Japan';

UPDATE countries
SET continent = 'North America'
WHERE name = 'USA';

UPDATE celebrities
SET deceased = true WHERE first_name = 'Elvis' AND last_name = 'Presley';

ALTER TABLE celebrities
ALTER column deceased SET NOT NULL;

DELETE FROM celebrities WHERE first_name = 'Tom' AND last_name = 'Cruise';

ALTER TABLE celebrities
RENAME TO singers;

DELETE FROM singers
WHERE occupation NOT ILIKE 'singer%';

DELETE FROM countries;

UPDATE orders SET drink = 'Lemonade' WHERE id = 1;

UPDATE orders
SET side = 'Fries', side_cost = 0.99, customer_loyalty_points = 13
WHERE id = 4;

UPDATE orders
SET side_cost = 1.20
WHERE side = 'Fries';