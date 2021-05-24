createdb animals
-- or
CREATE DATABASE animals;

CREATE TABLE birds (
  id serial PRIMARY KEY,
  name varchar(25),
  age integer,
  species varchar(15)
);

INSERT INTO birds (name, age, species)
VALUES ('Charlie', 3, 'Finch'),
       ('Allie', 5, 'Owl'),
       ('Jennifer', 3, 'Magpie'),
       ('Jamie', 4, 'Owl'),
       ('Roy', 8, 'Crow');

SELECT * FROM birds;
-- or
SELECT name, age, species FROM birds;

SELECT * FROM birds WHERE age < 5;

UPDATE birds SET species = 'Raven'
WHERE species = 'Crow';

UPDATE birds SET species = 'Hawk'
WHERE species = 'Owl' AND name = 'Jamie';

DELETE FROM birds
WHERE age = 3 AND species = 'Finch';

ALTER TABLE birds ADD CONSTRAINT check_age CHECK (age > 0);
-- shorthand if we don't need a custom name
ALTER TABLE birds ADD CHECK (age > 0);

DROP TABLE birds;

dropdb animals
-- or
DROP DATABASE animals;