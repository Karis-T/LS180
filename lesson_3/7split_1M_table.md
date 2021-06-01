## How to split up a table to 1:M

1. create a table that will store the desired data from existing table

   ```sqlite
   CREATE TABLE directors (id serial PRIMARY KEY, name text NOT NULL);
   ```

2. insert the existing data into the new table

   ```sqlite
   INSERT INTO directors (name) VALUES ('John McTiernan');
   INSERT INTO directors (name) VALUES ('Michael Curtiz');
   INSERT INTO directors (name) VALUES ('Francis Ford Coppola');
   INSERT INTO directors (name) VALUES ('Michael Anderson');
   INSERT INTO directors (name) VALUES ('Tomas Alfredson');
   INSERT INTO directors (name) VALUES ('Mike Nichols');
   ```

3. add a foreign key to the old table that references the new table to create a relationship between the tables

   ```sqlite
   ALTER TABLE films ADD COLUMN director_id integer REFERENCES directors (id);
   ```

   - don't set NOT NULL CONSTRAINT until you add values to this column (right now its empty)

4. insert foreign key values into the old table that aligns with the id values of the new table

   ```sqlite
   UPDATE films SET director_id=1 WHERE director = 'John McTiernan';
   UPDATE films SET director_id=2 WHERE director = 'Michael Curtiz';
   UPDATE films SET director_id=3 WHERE director = 'Francis Ford Coppola';
   UPDATE films SET director_id=4 WHERE director = 'Michael Anderson';
   UPDATE films SET director_id=5 WHERE director = 'Tomas Alfredson';
   UPDATE films SET director_id=6 WHERE director = 'Mike Nichols';
   ```

5. set foreign key column to be NOT NULL

   ```sqlite
   ALTER TABLE films ALTER COLUMN director_id SET NOT NULL;
   ```

6. DROP old columns that were split from the old table

   ```sqlite
   ALTER TABLE films DROP COLUMN director;
   ```

7. ADD CONSTRAINTS that were in the old dropped column to the new column in the new table

   ```sqlite
   ALTER TABLE directors ADD CONSTRAINT valid_name
   CHECK (length(name) >= 1 AND position(' ' in name) > 0);
   ```



#### NULL or NOT NULL?

the foreign keys in this database we used `NOT NULL` to prevent it from holding values. This is because with regard to modularity you need at least 1 or more directors for a film to exist. 

However there are other situations  where the foreign key column can be `NULL` which could be when the modularity for that entity is optional - ie you can have 0 or more of the entity for it to exist. It can also occur when data changes over time.

In this example sometimes we would need to store information about a movie without yet knowing the director. If this database was used in a movie studio this would be required as films begin the production process before they select a director, or the director leaves and the film currently has no director.

while its a good idea to restrict the tables schema to preserve its data's integrity, it can also limit what kind of data is stored, added and modified. 

Sometimes the database might need to be temporarily invalid whilst performing certain actions (see steps 3-5) but only if there's no other way around it.

