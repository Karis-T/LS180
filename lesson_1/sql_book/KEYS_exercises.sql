CREATE TABLE continents (
  id serial PRIMARY KEY,
  continent_name varchar(50)
);

ALTER TABLE countries
DROP COLUMN continent;

ALTER TABLE countries
ADD COLUMN continent_id integer;

ALTER TABLE countries
ADD FOREIGN KEY (continent_id)
REFERENCES continents(id);

INSERT INTO continents (continent_name)
  VALUES ('Africa'),
         ('Asia'),
         ('Europe'),
         ('Europe'),
         ('North America'),
         ('South America');

INSERT INTO countries (
  name, capital, population, continent_id)
  VALUES ('Brazil','Brasilia', 208385000, 5),
         ('Egypt','Cairo', 96308900, 1),
         ('France', 'Paris', 67158000, 3),
         ('Germany','Berlin', 82349400, 3),
         ('Japan', 'Tokyo', 126672000, 2),
         ('USA', 'Washington D.C.', 325365189, 4);

ALTER TABLE singers
ADD CONSTRAINT unique_id UNIQUE (id);

CREATE TABLE albums (
  id serial PRIMARY KEY,
  album_name varchar(100),
  released date,
  genre varchar(100),
  label varchar(100),
  singer_id integer,
  FOREIGN KEY (singer_id) REFERENCES singers (id)
);

INSERT INTO albums (
  album_name, released, genre, label, singer_id)
  VALUES ('Born to Run', 'August 25, 1975', 'Rock and roll', 'Columbia', 1),
         ('Purple Rain', 'June 25, 1984', 'Pop, R&B, Rock', 'Warner Bros', 6),
         ('Born in the USA', 'June 4, 1984', 'Rock and roll, pop', 'Columbia', 1),
         ('Madonna', 'July 27, 1983', 'Dance-pop, post-disco', 'Warner Bros', 5),
         ('True Blue', 'June 30, 1986', 'Dance-pop, Pop', 'Warner Bros', 5),
         ('Elvis', 'October 19, 1956', 'Rock and roll, Rhythm and Blues', 'RCA Victor', 7),
         ('Sign o'' the Times', 'March 30, 1987', 'Pop, R&B, Rock, Funk', 'Paisley Park, Warner Bros', 6),
         ('G.I. Blues', 'October 1, 1960', 'Rock and roll, Pop', 'RCA Victor', 7);

CREATE TABLE customers (
  id serial PRIMARY KEY,
  customer_name varchar(100)
);

CREATE TABLE email_addresses (
  customer_id integer PRIMARY KEY,
  customer_email varchar(50),
  FOREIGN KEY (customer_id) REFERENCES customers (id) ON DELETE CASCADE
);

INSERT INTO customers (customer_name)
VALUES ('James Bergman'),
       ('Natasha O''Shea'),
       ('Aaron Muller');

INSERT INTO email_addresses (customer_id, customer_email)
VALUES (1, 'james1998@email.com'),
       (2, 'natasha@osheafamily.com');

CREATE TABLE products (
  id serial PRIMARY KEY,
  product_name varchar(50),
  product_cost decimal(4,2) DEFAULT 0,
  product_type varchar(20),
  product_loyalty_points integer
);

INSERT INTO products (
  product_name, product_cost, product_type, product_loyalty_points
)
  VALUES ('LS Burger', 3.00, 'Burger', 10),
         ('LS Cheeseburger', 3.50, 'Burger', 15),
         ('LS Chicken Burger', 4.50, 'Burger', 20),
         ('LS Double Deluxe Burger', 6.00, 'Burger', 30),
         ('Fries', 1.20, 'Side', 3),
         ('Onion Rings', 1.50, 'Side', 5),
         ('Cola', 1.50, 'Side', 5),
         ('Lemonade', 1.50, 'Drink', 5),
         ('Vanilla Shake', 2.00, 'Drink', 7),
         ('Chocolate Shake', 2.00, 'Drink', 7),
         ('Strawberry Shake', 2.00, 'Drink', 7);

DROP TABLE orders;
-- 1 to many: 1 person can have many orders

CREATE TABLE orders (
  id serial PRIMARY KEY,
  customer_id integer,
  order_status varchar(20),
  FOREIGN KEY (customer_id) REFERENCES customers (id) ON DELETE CASCADE
);

-- 1 to many: 1 order can have many products
CREATE TABLE order_items (
  id serial PRIMARY KEY,
  order_id integer,
  product_id integer,
  FOREIGN KEY (order_id) REFERENCES orders (id) ON DELETE CASCADE,
  FOREIGN KEY (product_id) REFERENCES products (id) ON DELETE CASCADE
);

INSERT INTO orders (customer_id, order_status)
  VALUES (1, 'In Progress'),
         (2, 'Placed'),
         (2, 'Complete'),
         (3, 'Placed');

INSERT INTO order_items (order_id, product_id)
VALUES (1, 3),
       (1, 5),
       (1, 6),
       (1, 8),
       (2, 2),
       (2, 5),
       (2, 7),
       (3, 4),
       (3, 2),
       (3, 5),
       (3, 5),
       (3, 6),
       (3, 10),
       (3, 9),
       (4, 1),
       (4, 5);

