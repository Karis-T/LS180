CREATE DATABASE auction;

\c auction

CREATE TABLE bidders (
  id serial PRIMARY KEY,
  name text NOT NULL
);

CREATE TABLE items (
  id serial PRIMARY KEY,
  name text NOT NULL,
  initial_price numeric(6,2) NOT NULL CHECK(initial_price BETWEEN 0.01 AND 1000.00),
  sales_price numeric(6,2) CHECK(sales_price BETWEEN 0.01 AND 1000.00)
);

CREATE TABLE bids (
  id serial PRIMARY KEY,
  bidder_id integer NOT NULL REFERENCES bidders (id) ON DELETE CASCADE,
  item_id integer NOT NULL REFERENCES items (id) ON DELETE CASCADE,
  amount numeric(6,2) NOT NULL CHECK(amount BETWEEN 0.01 AND 1000.00)
);

CREATE INDEX ON bids (bidder_id, item_id);

\copy bidders FROM './exercises/bidders.csv' WITH HEADER CSV;
\copy items FROM './exercises/items.csv' WITH HEADER CSV;
\copy bids FROM './exercises/bids.csv' WITH HEADER CSV;

-- \copy can use relative path
-- COPY only allows absolute path

SELECT name AS "Bid on Items" FROM items
WHERE id IN (SELECT item_id FROM bids);

SELECT name AS "Not Bid On" FROM items
WHERE id NOT IN (SELECT item_id FROM bids);

SELECT name FROM bidders
WHERE EXISTS (SELECT 1 FROM bids WHERE bids.bidder_id = bidders.id);
-- every true item will return 1
-- every non-true item will NULL

SELECT DISTINCT bidders.name FROM bidders
JOIN bids ON bidders.id = bids.bidder_id;

SELECT COUNT(bidder_id) FROM bids GROUP BY bidder_id ORDER BY count(bidder_id) DESC LIMIT 1;

SELECT MAX(bid_counts.count) FROM (SELECT COUNT(bidder_id) FROM bids GROUP BY bidder_id) AS bid_counts;
-- bid_counts is the table
-- count is the column name

SELECT name, (SELECT COUNT(item_id) FROM bids WHERE item_id = items.id) FROM items;
SELECT name, COUNT(item_id) FROM items LEFT JOIN bids ON item_id = items.id GROUP BY name;

SELECT id FROM items
WHERE ROW(name,initial_price, sales_price) =
      ROW('Painting', 100.00, 250.00);

EXPLAIN ANALYZE SELECT name FROM bidders
WHERE EXISTS (SELECT 1 FROM bids WHERE bids.bidder_id = bidders.id);
