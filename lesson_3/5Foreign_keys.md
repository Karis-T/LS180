## Using Foreign Keys

A foreign key refers to 2 different things:

- *Foreign key columns:* A column that establishes a relationship between 2 rows. This is done by pointing to a specific row in another table using its primary key
- *Foreign key constraints:* A constraint that enforces rules about permitted values in foreign key relationships. 

![Products have many orders](https://da77jsbdz4r05.cloudfront.net/images/foreign_keys/products_orders_erd.png)

![Database diagram](https://da77jsbdz4r05.cloudfront.net/images/foreign_keys/products_orders_dd.png)

in the above schema the product_d column is a foreign key, and it points to values in the primary key column of the products table

### Creating Foreign Key Columns

- create the column of the same type as the primary key column, and point it to values in the primary key column.
- primary foreign keys should share the same data type (products id is an integer as is orders product id)

### Creating Foreign Key Constraints

there are 2 ways to create a foreign key constraint:

- add a `REFERENCES` clause to `CREATE TABLE`

```sqlite
CREATE TABLE orders (
  id serial PRIMARY KEY,
  product_id integer REFERENCES products (id),
  quantity integer NOT NULL
);
```

- add a foreign key separately with `ALTER TABLE`

```sqlite
ALTER TABLE orders ADD CONSTRAINT orders_product_id_fkey FOREIGN KEY (product_id) REFERENCES products(id);
```

### Referential Integrity

- one of the main reasons we use foreign key constraints it *to preserve the referential integrity of database data*
-  the database handles this by ensuring every foreign key column value must first exist in the primary column that we reference.
- Any attempts to insert rows that violate a tables constraint is rejected 

