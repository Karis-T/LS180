## Convert a 1:M table into a M:M Table

While in the last assignment we designated the entity relationship between directors and films is that a director can have many films but a single film can only have one director. In reality though there are sometimes more than one director directing a film so we are going to update the table to reflect this relationship. A ERD here can visually represent the relationship:

![Films have multiple directors](https://da77jsbdz4r05.cloudfront.net/images/om_to_mm/director_film_erd2.png)

the way we are going to convert a 1:M table into a M:M table is to add a a join table to store the relationships between directors and films

### Steps to convert a 1:M to a M:M

1. create a join table and using foreign keys allow each entity to have many of its counterpart:

   ```sqlite
   CREATE TABLE directors_films (
   	id serial PRIMARY KEY,
     director_id integer REFERENCES directors (id),
     film_id integer REFERENCES films (id)
   );
   --use alphbetical order when the table name has more than 1 word	
   ```

2. INSERT data from existing tables into the join table:

   ```sqlite
   INSERT INTO directors_films (film_id, director_id)
   	VALUES (1, 1),
   				 (2, 2),
   				 (3, 3),
   				 (4, 4),
   				 (5, 5),
   				 (6, 6),
   				 (7, 3),
   				 (8, 7),
   				 (9, 8),
   				 (10, 4);
   ```

3. DROP any unwanted columns from the old foreign key column in the original Many table (in this case its `films`):

   ```sqlite
   ALTER TABLE films DROP COLUMN director_id;
   ```


- now you can select the two tables from the join table:

  ```sqlite
  SELECT f.title, d.name 
  	FROM films f
  		INNER JOIN directors_films df ON f.id = df.film_id
  		INNER JOIN directors d ON d.id = df.director_id
  	ORDER BY f.title;
  	
  	         title           |         name
  ---------------------------+----------------------
   12 Angry Men              | Sidney Lumet
   1984                      | Michael Anderson
   Casablanca                | Michael Curtiz
   Die Hard                  | John McTiernan
   Let the Right One In      | Michael Anderson
   The Birdcage              | Mike Nichols
   The Conversation          | Francis Ford Coppola
   The Godfather             | Francis Ford Coppola
   Tinker Tailor Soldier Spy | Tomas Alfredson
   Wayne's World             | Penelope Spheeris
  (10 rows)
  ```
  

- If there is multiple directors per film you can duplicate the films like so:

  ```sqlite
  INSERT INTO directors (name)
    VALUES ('Joel Coen'),
           ('Ethan Coen'),
           ('Frank Miller'),
           ('Robert Rodriguez');
  
  INSERT INTO films (title, year, genre, duration)
    VALUES ('Fargo', 1996, 'comedy', 98),
           ('No Country for Old Men', 2007, 'western', 122),
           ('Sin City', 2005, 'crime', 124),
           ('Spy Kids', 2001, 'scifi', 88);
  
  INSERT INTO directors_films (film_id, director_id)
    VALUES (11, 9),
           (12, 9),
           (12, 10), -- duplicated film different director
           (13, 11),
           (13, 12), -- duplicated film different director
           (14, 12);
  ```

  

```sqlite
SELECT d.name AS directors, COUNT(df.film_id) AS films 
	FROM directors d
		INNER JOIN directors_films df ON d.id = df.director_id
	GROUP BY directors
	ORDER BY films DESC, directors;
	
      directors       | films
----------------------+-------
 Francis Ford Coppola |     2
 Joel Coen            |     2
 Robert Rodriguez     |     2
 Tomas Alfredson      |     2
 Ethan Coen           |     1
 Frank Miller         |     1
 John McTiernan       |     1
 Michael Anderson     |     1
 Michael Curtiz       |     1
 Mike Nichols         |     1
 Penelope Spheeris    |     1
 Sidney Lumet         |     1
(12 rows)
```

