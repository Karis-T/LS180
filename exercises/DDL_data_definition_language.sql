CREATE DATABASE extrasolar;

\c extrasolar

CREATE TABLE stars (
  id serial PRIMARY KEY,
  name varchar(25) UNIQUE NOT NULL,
  distance integer NOT NULL CHECK (distance > 0),
  spectral_type char(1),
  companions integer NOT NULL CHECK (companions >= 0)
);

CREATE TABLE planets (
  id serial PRIMARY KEY,
  designation char(1),
  mass integer
);

ALTER TABLE planets ADD COLUMN star_id integer NOT NULL REFERENCES stars (id);

ALTER TABLE stars ALTER COLUMN name TYPE varchar(50);

/*
Further exploration: increasing the size of varchar is automatic but decreasing it when the values are too large to fit the new limit will raise an error.

ERROR: value too long for type character varying(10)

You can truncate the value and avoid the error

ALTER TABLE stars
ALTER name TYPE varchar(25)
USING substr(name, 1, 25);
*/

ALTER TABLE stars ALTER COLUMN distance TYPE numeric;

/*
Further exploration: changing the data type to integer and adding the following whole number value doesn't cause any concerns but if we were to add a decimal value instead it rounds the decimal value to the nearest integer.

ie 4.3 becomes 4 and 9.8 becomes 10.
*/

ALTER TABLE stars
ADD CHECK (spectral_type IN ('O', 'B', 'A', 'F', 'G', 'K', 'M')),
ALTER COLUMN spectral_type SET NOT NULL;

/*
Further exploration: the values added contained 2 conflicts that will violate the constraints added after data insertion:
1. a null values
2. values that aren't contained in the CHECK list

which produces the following errors:
1. column "spectral_type" contains null values
2. check constraint "stars_spectral_type_check" is violated by some row

to add the above constraints, any rows that violate them must be updated / deleted first

you can also bypass incorrect entries with the following:
ALTER TABLE stars
ALTER COLUMN spectral_type SET NOT NULL,
  ADD CHECK (spectral_type ~ '[OBADGKM]') NOT VALID;

NOT VALID allows you to skip a scan that verifies if the existing rows in the table comply
with the new CHECK constraint, this doesn't apply to NOT NULL constraints however.
*/

ALTER TABLE stars DROP CONSTRAINT stars_spectral_type_check;

CREATE TYPE spectral_type_enum AS ENUM ('O', 'B', 'A', 'F', 'G', 'K', 'M');

ALTER TABLE stars ALTER COLUMN spectral_type TYPE spectral_type_enum
USING spectral_type::spectral_type_enum;

/*
Further Exploration:
The USING clause tells postgreSQL how to convert char values into an enumerated type. Now we can use spectral_values as if they are enumerated values
*/

ALTER TABLE planets
ALTER COLUMN mass TYPE numeric,
ALTER COLUMN mass SET NOT NULL,
ADD CHECK (mass > 0.0),
ALTER COLUMN designation SET NOT NULL;


ALTER TABLE planets
ADD COLUMN semi_major_axis numeric NOT NULL;

/*
Further Exploration:
When you try to add this column that contains existing values with a NOT NULL constraint it will not allow you to add the column as it will contain NOT NULL values automatically for exisiting values.

ADD COLUMN semi_major_axis numeric NOT NULL;
ERROR:  column "semi_major_axis" contains null values

You can choose to:
- add the NOT NULL constraint after adding values to the new column,
- delete the existing data and add it after you add the column with the not null constraint, making sure you have not null values
*/


CREATE TABLE moons (
  id serial PRIMARY KEY,
  designation integer NOT NULL CHECK (designation > 0),
  semi_major_axis numeric CHECK (semi_major_axis > 0.0),
  mass numeric CHECK (mass > 0.0);
  planet_id integer NOT NULL REFERENCES planets (id)
);
