## Database Diagrams

- developers don't usually follow a particular convention so this makes it tricky to narrow down a practiced design
- When thinking about a database diagram you have to ask: "What level of abstraction is it currently at?"
- there are 3 levels of schema (levels of abstraction) and depending on the level you're working with will indicate what type of diagram you're looking at

### 1. Conceptual Schema

> High- level design focused on identifying entities and their relationships

- concerned with bigger objects and high level concepts. It thinks about the data in a very abstract way 

  - its not concerned with how the data or relationships between objects are stored in the database

  - eg. an app that makes phone calls and 2 contacts. A contact can have multiple phone numbers

    ![image-20210528140752706](C:\Users\Karis\AppData\Roaming\Typora\typora-user-images\image-20210528140752706.png)

  - big objects and how they relate to each other

  - entity relationship model / diagrams is a conceptual schema

  - entities are rectangles

    ![image-20210528140433049](C:\Users\Karis\AppData\Roaming\Typora\typora-user-images\image-20210528140433049.png)

  - to draw a relationship we use lines to connect entities:

  ![image-20210528140510568](C:\Users\Karis\AppData\Roaming\Typora\typora-user-images\image-20210528140510568.png)

  - one singular relationship
    - single instances of that entity on that side
  - many/ rake/ crows /foot relationships
    - multiple instances of that entity on that side

  ![image-20210528140635349](C:\Users\Karis\AppData\Roaming\Typora\typora-user-images\image-20210528140635349.png)

### 2. Logical Schema

- combination between conceptual and physical
  - lists all the attributes and data types
  - not database specific
  - logical schemas use standard sql column types as opposed to database specific ones
  - not common to work on this level
  - has more detail than conceptual concerned with implementation in a database, just not a specific database

### 3. Physical Schema

>low-level database-specific design focused on implementation

- concerned with the database specific implementation of a conceptual model

  - includes all the different attributes that an entity can hold
  - data types of all those entities
  - rules about those entities and their attributes relate to each other
  - map high level entities into specific tables and columns and datatypes

  ![image-20210528140941248](C:\Users\Karis\AppData\Roaming\Typora\typora-user-images\image-20210528140941248.png) 

- top: we are just talking about entities which are very abstract

- bottom: are descriptions of actual tables we use to store data for those entities- table names, contacts, calls, column name, column type attributes to the right, connections between primary key and foreign key
  - p = primary key
  - n = not null
  - f = foreign key

- the connection between contact and call is the same relationship indicated between the `id` and the `contact_id`

![image-20210528142039341](C:\Users\Karis\AppData\Roaming\Typora\typora-user-images\image-20210528142039341.png)

- **with 1 to many relationships when you see the "many" side it always means it will be a foreign key**
- when you see ERD ask yourself how will it translate into an actual database?

![image-20210528142932082](C:\Users\Karis\AppData\Roaming\Typora\typora-user-images\image-20210528142932082.png)

- when it comes to many to many relationships, while the conceptual schema has 3 entities, the physical schema has 4 tables

- **whenever you have a many to many relationship between 2 entities there's always going to be an extra table that represents that relationship**
  - the extra table is often called a "join" table because it joins the 2 sides of the relationship together

>The number of entities in a high level schema doesn't always match the number of database tables you have in a lower level / physical schema