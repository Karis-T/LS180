INSERT INTO countries
	VALUES (DEFAULT, 'France', 'Paris', 67158000);

INSERT INTO countries (name, capital, population)
	VALUES ('France', 'Paris', 67158000);

INSERT INTO countries (name, capital, population)
	VALUES ('USA', 'Washington D.C', 325365189),
	('Germany', 'Berlin', 82349400),
	('Japan', 'Tokyo', 126672000);

INSERT INTO celebrities (first_name, last_name, occupation, date_of_birth)
  VALUES ('Bruce', 'Springsteen', 'singer, songwriter', '1949-09-23');

INSERT INTO celebrities (first_name, last_name, occupation, date_of_birth)
  VALUES ('Scarlett', 'Johansson', 'actress', '1984-11-22');

INSERT INTO celebrities (first_name, last_name, occupation, date_of_birth, deceased)
VALUES ('Frank', 'Sinatra', 'Singer, Actor', '1915-12-12', true),
			 ('Tom', 'Cruise', 'Actor', '1962-07-03', DEFAULT);

INSERT INTO orders (customer_name, customer_email, burger, burger_cost, side, side_cost, drink, drink_cost, customer_loyalty_points)
  VALUES ('James Bergman', 'james1998@email.com', 'LS Chicken Burger', 4.50, 'Fries', 0.99, 'Cola', 1.50, 28),
         ('Natasha O''Shea', 'natasha@osheafamily.com', 'LS Cheeseburger', 3.50, 'Fries', 0.99, NULL, DEFAULT, 18),
         ('Natasha O''Shea', 'natasha@osheafamily.com', 'LS Double Deluxe Burger', 6.00, 'Onion Rings', 1.50, 'Chocolate Shake', 2.00, 42),
         ('Aaron Muller', NULL, 'LS Burger', 3.00, NULL, DEFAULT, NULL, DEFAULT, 10);