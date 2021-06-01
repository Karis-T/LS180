CREATE DATABASE workshop;

\c workshop

CREATE TABLE devices (
  id serial PRIMARY KEY,
  name text NOT NULL,
  created_at timestamp DEFAULT NOW()
  -- CURRENT_TIMESTAMP is the alias to NOW()
);

CREATE TABLE parts (
  id serial PRIMARY KEY,
  part_number integer UNIQUE NOT NULL,
  device_id integer REFERENCES devices (id)
);

INSERT INTO devices (name)
  VALUES ('Accelerometer'),
         ('Gyroscope');

INSERT INTO parts (part_number, device_id)
  VALUES (12, 1),
         (14, 1),
         (16, 1),
         (31, 2),
         (33, 2),
         (35, 2),
         (37, 2),
         (39, 2),
         (50, NULL),
         (54, NULL),
         (58, NULL);

SELECT d.name, p.part_number FROM devices AS d
  INNER JOIN parts AS p ON p.device_id = d.id;

SELECT * FROM parts WHERE part_number::text LIKE '3%';

SELECT d.name, COUNT(p.device_id) FROM devices AS d
  INNER JOIN parts AS p ON d.id = p.device_id
  GROUP BY d.name;

SELECT d.name, COUNT(p.device_id) FROM devices AS d
  INNER JOIN parts AS p ON d.id = p.device_id
  GROUP BY d.name ORDER BY d.name DESC;

SELECT part_number, device_id FROM parts
  WHERE device_id IS NOT NULL;

SELECT part_number, device_id FROM parts
  WHERE device_id IS NULL;

SELECT name AS oldest_device FROM devices
  ORDER BY created_at LIMIT 1;

SELECT * FROM parts WHERE device_id = 2;

UPDATE parts SET device_id = 1
  WHERE id=7 OR id=8;

UPDATE parts SET device_id = 2
  WHERE part_number = (SELECT MIN(part_number) FROM parts);

DELETE FROM parts WHERE device_id = 1;
DELETE FROM devices WHERE name = 'Accelerometer'
-- deleting in reverse order violates foreign key constraint as we are referencing a non existent device
-- needs a ON DELETE CASCADE added to FOREIGN KEY to delete related data from different tables at the same time