## How PostgreSQL Executes Queries

### A declarative Language

declarative language implies that SQL explains what to do but not how to do it. This means its up to PostgreSQL to determine how to best execute the query and return the intended results.

**Benefits:**

- By simplifying the database interactions as mentioned, it allows the user to think on a high level about what kind of format and data they'd like to retrieve.

  **Disadvantages:**

- Lacking control over the database enables the database to perform a task in an inefficient way which results in wasted time, resources and query delays

However there are ways we can signal (give requirements) to the database about how it should execute a query.

### How PostgreSQL Executes a Query

While there are many variables involved, there is a high level process that each query goes through. knowing the steps can help you

- learn the difference between two queries that appear return the same result
- understand why some queries are rejected by the database

#### Breakdown of the `SELECT` Query Process

1. **Rows are collected into a virtual derived table**

   The database creates a 'temporary table' using the data from all the tables listed in the queries `FROM` clause (This includes  tables used in the `JOIN` clauses)

2. **Rows are filtered by `WHERE` conditions**

   All the conditions in the `WHERE` clause are evaluated for each row. Those that don't meet the criteria are removed 

3. **Rows are divided into groups**

   If a query includes a `GROUP BY` clause, the rows are divided into the specified groups

4. **Groups are filtered by `HAVING` conditions**

   `HAVING` conditions apply to the values used to create groups (not individual rows) and work similar to `WHERE` conditions. 

   This implies that the column mentioned in the `HAVING` clause usually should appear in the `GROUP BY` clause and / or an aggregate function in the same query. 

   Both `GROUP BY` and aggregate functions group data and the `HAVING` clause filters that aggregate / grouped data. 

5. **Compute values to return using select list**

   each element in the `SELECT` list is evaluated, which includes functions and the resulting values are either:

   - associated with the name of the column they're from
   - or the name of the last function evaluated 

   unless an alias is specified using `AS` 

6. **Sort results**

   The results are sorted based on the criteria in the `ORDER BY` clause. Without ordering, results are returned based on how the database executed the query / rows' orders from the original tables.

   Because of this its always best to specify an explicit order if your app relies on specific row order

7. **Limit results**

   If `LIMIT` or `OFFSET` are present in the query they're used to adjust which rows are returned.

