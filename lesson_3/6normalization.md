## Normalization

![img](https://da77jsbdz4r05.cloudfront.net/images/one_to_many/step1.png)

The above table represents the calls that came through containing the:

- primary key
- when the call was made
- duration of the call
- the first and last name of the caller
- and the callers number

![img](https://da77jsbdz4r05.cloudfront.net/images/one_to_many/step2.png)

While this table contains all the data we would want to know about calls there is a few issues with regard to **duplicated data and schema design**:

- **update anomaly:** is when you have more than 1 answer for a given question due to inconsistent data. For example if you needed to change the contacts name or number you'll have to update every row that has that content. This could lead to inconsistent data if one forgot to update every row.
- **insertion anomaly:** storing the information for a contact before placing a call to them 
- **deletion anomaly:** losing all the information about a contact if we delete the history of calls to them

#### Denormalization

also known as duplicated data, which is desirable in some cases as it can make retrieval operations more efficient.

#### Normalization

is when we design schema to minimize / eliminate the 3 anomalies mentioned above. To do this we must: 

1. extract the data into additional tables
2. use foreign keys to tie back to its associated data.

- **foreign key columns:** columns that store references to primary key columns in a database. Foreign keys usually point to other tables but sometimes they will point to rows in the same table.

#### JOIN breakdown

- when we normalize the data, we prevent duplication and the previous anomalies but we can no longer see the table with a simple `SELECT * FROM calls` statement. 

- if we list multiple tables in a `SELECT` statement's `FROM` clause the database returns every possible combination of rows. Usually this isn't what we want because unrelated rows are connected and the database doesn't know how to sync up the rows from the 2 different tables.

- listing multiple tables with `FROM` is valid, but its not the result we want

- to tell the database how to connect the rows and return data that makes sense we must tell the database:

  - to use the foreign key in the `calls` table - `contact_id`
  - doing so matches the rows in `calls` to rows in `contacts` based on their `id`

- we can perform this action using a `JOIN` clause and specify how to connect the 2 tables:

  ```sqlite
  SELECT * FROM calls INNER JOIN contacts ON calls.contact_id = contacts.id;
  ```

  - `SELECT` returns all columns
  - `FROM calls INNER JOIN contacts` from the rows in calls matched with the rows in contacts
  - `ON calls.contact_id = contacts.id` when the contact_id foreign key in calls matches the primary key id of contacts
  - the above is correct but often we want more control over what columns are returned, here we can include a `SELECT` list (the downside is that it becomes longer):

  ```sqlite
  SELECT calls.when, calls.duration, contacts.first_name, contacts.last_name, contacts.number
  FROM calls INNER JOIN contacts ON calls.contact_id = contacts.id;
  ```

  which returns:

  ```sqlite
          when         | duration | first_name | last_name |   number
  ---------------------+----------+------------+-----------+------------
   2016-01-02 04:59:00 |     1821 | William    | Swift     | 7204890809
   2016-01-08 15:30:00 |      350 | Yuan       | Ku        | 2195677796
   2016-01-11 11:06:00 |      111 | Tamila     | Chichigov | 5702700921
   2016-01-13 18:13:00 |     2521 | Tamila     | Chichigov | 5702700921
   2016-01-17 09:43:00 |      982 | Yuan       | Ku        | 2195677796
  (5 rows)
  ```

  

  

