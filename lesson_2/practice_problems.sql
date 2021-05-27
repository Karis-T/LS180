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

/* Practice problems 6 */

-- 3
CREATE TABLE temperatures (
  date date NOT NULL,
  low integer NOT NULL,
  high integer NOT NULL
);

-- 4
INSERT INTO temperatures
VALUES ('2016-03-01', 34, 43),
       ('2016-03-02', 32, 44),
       ('2016-03-03', 31, 47),
       ('2016-03-04', 33, 42),
       ('2016-03-05', 39, 46),
       ('2016-03-06', 32, 43),
       ('2016-03-07', 29, 32),
       ('2016-03-08', 23, 31),
       ('2016-03-09', 17, 28);

-- 5
SELECT date, ROUND((high + low)/ 2.0, 1) as average
  FROM temperatures WHERE date BETWEEN '2016-03-02' AND '2016-03-08';
--  One other solution would be to cast the average value to a decimal with a precision of 3 and scale of 1, ((high + low) / 2.0)::decimal(3,1).
-- A combination of BETWEEN/AND is the same as using date >= '2016-03-02' AND date <='2016-03-08'

-- 6
ALTER TABLE temperatures
ADD COLUMN rainfall integer DEFAULT 0;

-- 7
UPDATE temperatures
  SET rainfall = (high + low)/2 - 35
  WHERE (high + low)/2 - 35 > 0;

-- 8
ALTER TABLE temperatures
ALTER COLUMN rainfall TYPE decimal(6, 3);

UPDATE temperatures
  SET rainfall = rainfall / 25.4;

-- 9
ALTER TABLE temperatures RENAME TO weather;

-- 10
\d weather
\d describes the argument passed to it

-- 11
pg_dump -d sql-course -t weather --inserts > dump.sql

/* Practice problems 6 */
-- 1
$ psql -d ./lesson_2/ktobias < films2.sql

-- 2
ALTER TABLE films ALTER COLUMN title SET NOT NULL;
ALTER TABLE films ALTER COLUMN year SET NOT NULL;
ALTER TABLE films ALTER COLUMN genre SET NOT NULL;
ALTER TABLE films ALTER COLUMN director SET NOT NULL;
ALTER TABLE films ALTER COLUMN duration SET NOT NULL;

-- 3
 nullable column is set to NOT NULL

-- 4
 ALTER TABLE films ADD CONSTRAINT title_unique UNIQUE (title);

-- 5
sitting at the bottom of the table labeled indexes:

-- 6
 ALTER TABLE films DROP CONSTRAINT title_unique;

-- 7
ALTER TABLE films ADD CONSTRAINT title_length CHECK (length(title) >= 1);

-- 8
ERROR:  new row for relation "films" violates check constraint "title_length"
DETAIL:  Failing row contains (, 1988, comedy, me, 100).

-- 9
under the table the label Check Constraints:

-- 10
ALTER TABLE films DROP CONSTRAINT title_length;

-- 11
ALTER TABLE films ADD CONSTRAINT year_range
CHECK (year BETWEEN 1900 AND 2100);

-- 12
year_range appears as check constraint under the table

-- 13
ALTER TABLE films ADD CONSTRAINT director_length
CHECK (length(director) >= 3 AND LIKE '% %');

ALTER TABLE films ADD CONSTRAINT director_name
CHECK (length(director) >= 3 AND position(' ' in director) > 0);

-- 14
director_name appears as check constraint under the table

-- 15
UPDATE films SET director = 'Johnny' WHERE title LIKE 'Die Hard';

ERROR:  new row for relation "films" violates check constraint "director_name"
DETAIL:  Failing row contains (Die Hard, 1988, action, Johnny, 132).

-- 16
data types (length limitation)
NOT NULL constraint
UNIQUE constraint
DEFAULT constraint
CHECK constraint

-- 17
Yes its possible to define conflicting constraints

CREATE TABLE shoes (name text, size numeric(3,1) DEFAULT 0);
ALTER TABLE shoes ADD CONSTRAINT shoe_size CHECK (size BETWEEN 1 AND 15);
INSERT INTO shoes (name) VALUES ('blue sneakers');

ERROR:  new row for relation "shoes" violates check constraint "shoe_size"
DETAIL:  Failing row contains (blue sneakers, 0.0)

-- 18
\d $table_name

/* Practice problems 7 */
-- 1
CREATE SEQUENCE counter;

-- 2
SELECT nextval('counter');

-- 3
DROP SEQUENCE counter;

-- 4
yes its possible:
CREATE SEQUENCE even_counter INCREMENT BY 2 MINVALUE 2;
SELECT nextval('even_counter');
nextval
---------
    2
(1 row)

SELECT nextval('even_counter');
nextval
---------
   4
(1 row)

-- 5
regions_id_seq

-- 6
ALTER TABLE films
ADD COLUMN id serial PRIMARY KEY;

-- 7
ERROR:  duplicate key value violates unique constraint "films_pkey"
DETAIL:  Key (id)=(3) already exists.

-- 8
ERROR:  multiple primary keys for table "films" are not allowed

-- 9
ALTER TABLE films
DROP CONSTRAINT films_pkey;

/* Practice problems 7 */
-- 1
psql -d films < films4.sql

-- 2
INSERT INTO films
  VALUES (DEFAULT, 'Wayne''s World', 1992, 'comedy', 'Penelope Spheeris', 95),
         (DEFAULT, 'Bourne Identity', 2002, 'espionage', 'Doug Liman', 118);

-- 3
SELECT DISTINCT genre FROM films;

-- 4
SELECT genre FROM films GROUP BY genre;

-- 5
SELECT ROUND(AVG(duration)) FROM films;

-- 6
SELECT genre, round(avg(duration)) as average_duration FROM films GROUP BY genre;

-- 7
SELECT year / 10 * 10 as decade, ROUND(AVG(duration)) as average_duration
  FROM films GROUP BY decade ORDER BY decade;

-- 8
SELECT * FROM films WHERE director LIKE 'John%';

-- 9
SELECT genre, count(genre) FROM films GROUP BY genre ORDER BY count DESC;

-- 10
SELECT round(year / 10) * 10 as decade, genre, string_agg(title, ', ') as films

-- 11
SELECT genre, sum(duration) AS total_duration FROM films
  GROUP BY genre, ORDER BY total_duration;