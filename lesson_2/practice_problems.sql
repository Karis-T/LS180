/* Practice problems 1 */
-- 1
SQL is a specialized language because its only purpose is to interact with relational databases

-- 2
Data definition language
Data manipulation language
Data Control language

-- 3
SELECT 'canoe';
SELECT 'a long road';
SELECT 'weren''t';
SELECT '"No way!"';

-- 4
SELECT 'hello' || 'there';

-- 5
SELECT lower('HELLO');

-- 6
t and f

-- 7
SELECT trunc(4 * pi() * 26.3 ^ 2);


/* Practice problems 2 */
-- 1
both are string data types: varchar has a limit, text doesn't but there's no real performance difference between the two. text is not a standard SQL datatype and is unique to postgreSQL

-- 2
"all 3 store numeric type data: integers are whole numbers (non-fractional) only and don't store decimals. Both decimal and real store decimal numbers (fractional values) however real deals with floating points and decimal deals with limited prescision decimals"

-- 3
2147483647

-- 4
timestamp includes the current date and time
date only includes the date and no time

-- 5
TIMESTAMP '2004-10-19 10:23:54'
TIMESTAMP '2004-10-19 10:23:54+02'

PostgreSQL never examines the content of a literal string before determining its type, and therefore will treat both of the above as timestamp without time zone. To ensure that a literal is treated as timestamp with time zone (or timestamptz), give it the correct explicit type:

TIMESTAMP WITH TIME ZONE '2004-10-19 10:23:54+02'

/* Practice problems 3 */
-- 1
CREATE TABLE people (
  name varchar(255),
  age integer,
  occupation varchar(255)
);

-- 2
INSERT INTO people (name, age, occupation)
  VALUES ('Abby', 34, 'biologist'),
         ('Mu''nisah', 26, NULL),
         ('Mirabelle', 40, 'contractor');

-- 3
SELECT * FROM people LIMIT 1 OFFSET 1;
SELECT * FROM people WHERE name = 'Mu''nisah';
SELECT * FROM people WHERE age = 26;
SELECT * FROM people WHERE occupation IS NULL;

-- 4
CREATE TABLE birds (
  name varchar(255),
  length decimal(4,1),
  wingspan decimal(4,1),
  family text,
  extinct boolean
);

-- 5
INSERT INTO birds (name, length, wingspan, family, extinct)
  VALUES ('Spotted Towhee', 21.6, 26.7, 'Emberizidae', false),
         ('American Robin', 25.5, 36.0, 'Turdidae', false),
         ('Greater Koa Finch', 19.0, 24.0, 'Fringillidae', true),
         ('Carolina Parakeet', 33.0, 55.8, 'Psittacidae', true),
         ('Common Kestrel', 35.5, 73.5, 'Falconidae', false);

-- 6
SELECT name, family FROM birds
  WHERE extinct = false
  ORDER BY length DESC;

-- 7
SELECT round(avg(wingspan), 1), min(wingspan), max(wingspan) FROM birds;

-- 8
CREATE TABLE menu_items (
  item text,
  prep_time integer,
  ingredient_cost numeric(4,2),
  sales integer,
  menu_price numeric(4,2)
);

-- 9
INSERT INTO menu_items
  VALUES ('omelette', 10, 1.50, 182, 7.99),
         ('tacos', 5, 2.00, 254, 8.99),
         ('oatmeal', 1, 0.50, 79, 5.99);

-- 10

SELECT item, (menu_price - ingredient_cost) AS profit FROM menu_items
  ORDER BY (menu_price - ingredient_cost) DESC LIMIT 1;

-- 11
SELECT item, menu_price, ingredient_cost,
       round(prep_time/60.0 * 13.0, 2) AS labor, -- use floating numbers
       menu_price - ingredient_cost - round(prep_time/60.0 * 13.0, 2) AS profit
  FROM menu_items
  ORDER BY profit DESC;

/* Practice problems 4 */

-- 2
SELECT * FROM films;

-- 3
SELECT * FROM films WHERE length(title) < 12;

-- 4
ALTER TABLE films
ADD COLUMN director varchar(255),
ADD COLUMN duration integer;

-- 5
UPDATE films
SET director = 'John McTiernan',
    duration = 132 WHERE title = 'Die Hard';

UPDATE films
SET director = 'Michael Curtiz',
    duration = 102 WHERE title = 'Casablanca';

UPDATE films
SET director = 'Francis Ford Coppola',
    duration = 113 WHERE title = 'The Conversation';

-- 6
INSERT INTO films
  VALUES ('1984', 1956, 'scifi', 'Michael Anderson', 90),
         ('Tinker Tailor Soldier Spy', 2011, 'espionage', 'Tomas Alfredson', 127),
         ('The Birdcage', 1996, 'comedy', 'Mike Nichols', 118);
-- 7
SELECT title, 2021 - year AS age FROM films
ORDER BY year DESC;

SELECT title, extract("year" from current_date) - "year" AS age
  FROM films ORDER BY age ASC;

SELECT title, duration from films WHERE duration > 120
ORDER BY duration DESC;

SELECT title as longest_film FROM films
ORDER BY duration DESC LIMIT 1;

/* Practice problems 5 */
-- 3
SELECT state, count(state) FROM people
GROUP BY state ORDER BY count(state) DESC LIMIT 10;

-- 4
SELECT split_part(email, '@', 2) as domain, count(id)
FROM people GROUP BY split_part(email, '@', 2)
ORDER BY count DESC;

-- 5
DELETE FROM people
WHERE id = 3399;

-- 6
DELETE FROM people
WHERE state = CA;

-- 7
UPDATE people
SET given_name = upper(given_name)
WHERE email LIKE '%teleworm.us';

-- 8
DELETE FROM people;