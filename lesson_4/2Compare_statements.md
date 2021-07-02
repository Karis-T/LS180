## Comparing SQL statements

- what difference does it make on how we structure queries if we can achieve the same result?
  - the amount of time it takes for a query to run
  - if your app only deals with small datasets then it might not be worth worrying about
  - when you scale an app, little differences may add up and becomes an opportunity for optimization
- SQL is a declarative language where all the "how" is abstracted away by the database engine
  - its possible to influence this process by the way you structure your queries
  - To find which query is the most efficient to run, compare different queries that produce the same output  

### How to assess a query with EXPLAIN

- use the `EXPLAIN` command for a step by step breakdown of how the query will be run internally by PostgreSQL.
- to execute a query PostgreSQL devises an appropriate **'[query plan](https://www.postgresql.org/docs/9.5/static/query-path.html)'** 
-  `EXPLAIN` allows you to access the query plan

To use `EXPLAIN` prepend it to the query you want to look at:

```sqlite
EXPLAIN SELECT * FROM books;

                       QUERY PLAN
----------------------------------------------------------
 Seq Scan on books  (cost=0.00..12.60 rows=260 width=282)
(1 row)
```

- query plans are structured as a node tree
  - The more 'elements' there are to your query the more nodes there will be in the tree
  - the above is a simple query so there is only one node in the plan tree
  - each node is made up of:
    - a node type (sequential scan on the `books` table) 
    - along with an estimated cost for that node (startup cost...total cost)
    - the estimated number of rows to be output by the node
    - the estimated average width of the rows in bytes
  - 'cost' is calculated using arbitrary units from the planners [cost parameters](https://www.postgresql.org/docs/current/static/runtime-config-query.html#RUNTIME-CONFIG-QUERY-CONSTANTS) and represent the estimated amount of effort / resources needed to execute the query as planned
- The main piece that you need to look out for to compare queries is the estimated 'total cost' at the top most node (`12.60` in the case above)

#### EXPLAIN ANALYZE

- by itself *`EXPLAIN` doesn't execute the query passed to it, it simply estimates the values* based on the planners knowledge of the schema and assumptions based on PostgreSQL system statistics.
- to assess actual data add the `ANALYZE` option to an `EXPLAIN` command:

```sqlite
EXPLAIN ANALYZE SELECT books.title FROM books
JOIN authors ON books.author_id = authors.id
WHERE authors.name = 'William Gibson';
                                           QUERY PLAN
---------------------------------------------------------------------------------------------
 Hash Join  (cost=14.03..27.62 rows=2 width=218) (actual time=0.029..0.034 rows=3 loops=1)
   Hash Cond: (books.author_id = authors.id)
   ->  Seq Scan on books  (cost=0.00..12.60 rows=260 width=222) (actual time=0.009..0.012 rows=7 loops=1)
   ->  Hash  (cost=14.00..14.00 rows=2 width=4) (actual time=0.010..0.010 rows=1 loops=1)
         Buckets: 1024  Batches: 1  Memory Usage: 9kB
         ->  Seq Scan on authors  (cost=0.00..14.00 rows=2 width=4) (actual time=0.006..0.007 rows=1 loops=1)
               Filter: ((name)::text = 'William Gibson'::text)
               Rows Removed by Filter: 2
 Planning time: 0.201 ms
 Execution time: 0.074 ms
(10 rows)
```

`ANALYZE` option actually runs the query :

- it includes everything that `EXPLAIN` outputs
- plus the actual time (in milliseconds) required to run the query and its constituent parts
- and the actual amount of rows returned by each plan node rather than default statistic values

#### Further Exploration

- EXPLAIN, the planner and EXPLAIN ANALYZE don't have to be understood to a great depth. to explore further on EXPLAIN see the [PostgreSQL Docs](https://www.postgresql.org/docs/current/static/using-explain.html) for a good overview on how its used
