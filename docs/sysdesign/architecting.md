# Architecting requirements

## Functional system requirements

The requirements are usually defined by the system analysts

Functional requirements outline the specific functions, features, and capabilities that a system or software must provide to meet the needs of users and achieve its intended purpose. These requirements describe the interactions between the system and its users, as well as the system's behavior under various conditions.

Examples of functional requirements:

- Users must be able to create an account and log in.
- The system shall allow users to add items to their shopping cart.
- The software must generate monthly sales reports.
- The website should display a list of recommended articles based on user preferences.

## Non-Functional system requirememts

Non-functional requirements define the qualities, characteristics, and constraints that govern how the **system performs rather than what it does**. These requirements focus on aspects such as performance, security, reliability, usability, and other attributes that contribute to the overall quality and user experience of the system.

**Performance**: The system must be able to handle a minimum of 1000 concurrent users without significant degradation in response time.

**Security**: User passwords must be securely hashed and stored in the database.

**Reliability**: The system should have an uptime of at least 99.9%.

**Usability**: The user interface must be intuitive and accessible to users with disabilities.

**Scalability**: The system architecture should support easy scaling to accommodate increased user load.

**Maintainability**: Code must be well-documented and adhere to coding standards.

**Compatibility**: The software must be compatible with major web browsers, including Chrome, Firefox, and Safari.

## Component mapping

Effective communication with **stakeholders, including users, clients, developers, and testers**, is crucial throughout this process. Regularly review and refine the mapped components to ensure that all requirements are accurately captured and prioritized. This mapping process serves as a foundation for **design, development, testing, and evaluation** activities during the system's lifecycle.

## Select technology stack 

- After mapping the components, you would be required to wisely select the technology stack, that includes the frontend, backend, data stores etc

## Design architecture

The architectural design process aims to **define how different software modules or components will interact**, how data will flow, and how the system will achieve its intended functionality while adhering to quality attributes. Here's an overview of the steps involved in designing software architecture:

1. **Requirements Analysis and Understanding:**
   
      - Gather and analyze the functional and non-functional requirements of the software system.
      - Understand the **user needs, business goals, and technical constraints **that the architecture must address.

2. **System Decomposition and Module Identification:**

      - Break down the software system into smaller, manageable modules or components.
      - Identify the major functional areas and define the responsibilities of each module.

3. **Architectural Styles and Patterns Selection:**
   
      - Choose appropriate architectural styles (e.g., client-server, microservices, layered, event-driven) that best suit the system's requirements.
      - Apply well-established architectural patterns (e.g., MVC, MVVM, RESTful API) to address common design challenges.

4. **Component Interaction and Communication:**
   
      - Define how different modules will communicate and interact with each other.
      - Determine communication protocols, data formats, and interfaces between components.

5. **Data Management and Storage:**
   
      - Design the data storage and management mechanisms, including databases, data models, and data access layers.
      - Address data consistency, integrity, and security requirements.

6. **User Interface Design:**
   
      - Create a user interface design that aligns with user needs and provides an intuitive user experience.
      - Determine the layout, navigation, and presentation of information.

7. **Security and Authentication:**
      
      - Plan for security measures, including user authentication, authorization, data encryption, and protection against common vulnerabilities.

8. **Scalability and Performance Considerations:**
   
      - Address scalability requirements by designing for horizontal or vertical scalability, load balancing, and caching strategies.
      - Optimize the system's performance through efficient algorithms and proper resource management.

9.  **Error Handling and Resilience:**
   
       - Design error handling mechanisms to gracefully handle exceptions and failures.
       - Implement strategies for fault tolerance, redundancy, and system recovery.

10. **Integration with External Services:**

    - Define how the software system will integrate with external APIs, third-party services, and other systems.

11. **Documentation and Communication:**
      
      - Document the architectural decisions, design rationale, and key design patterns used.
      - Communicate the architecture to the development team, stakeholders, and collaborators.

12. **Review and Validation:**
   
      - Conduct architecture reviews and design discussions to validate the proposed architecture against requirements.
      - Address any feedback and make necessary adjustments.

13. **Implementation and Development:**
   
    - Translate the architectural design into code by developing individual modules and components.
    - Ensure that the implementation adheres to the defined architecture and design principles.

14. **Continuous Improvement:**
    
    - Regularly review and refine the architecture as the project progresses and new insights are gained.
    - Consider feedback from users, performance metrics, and evolving requirements.

## Write architecture document. 

- Use visial or document representation so that all the users including CTO, CFO, developers, testers would be able to check the document to understand the system.
- Any changes in the architectute or the document has to be updated with changes.

## Support team 

- Once the system is in production, we would be required to maintain system for reliability and so on, hence we would be required to support the team for any issues or help. 


# Database choice

In system design how good your database design is and **how well it can scale depends very much on the choice of database** that you've used. Now databases generally **do not impact your functional requirements**, but normally the ***non-functional requirements are impacted*** by the choice of database. 

We will look at some of the potential solutions or possible set of databases that you can use to handle non-functional requirements (i.e certain query patterns, or certain kind of a data structure or certain kind of a scale to handle.) 

Now normally the choice of database depends on a below three factors. 

- Data structure(**very structured data** or a **totally non structured data**)
- Choice of database(**query pattern** that you have.)
- Scaling(kind of a scale to handle)

**Structured information:** it would be an information that you can easily model in form of tables and tables would have rows and columns of information. e.g user information, payments, social network etc. let's say if we have a structured data the next question would be..do we need any **atomic City or transactional guarantees** from the db or not? 

Example: you have two bank accounts A and B. So when transactions happens i.e debited from A account, it should be either credited to B account and vice versa, your total bank account statements should also reflect those changes.
then you need an relational db with **atomicity, consistent transactions** i.e **ACID** guarantee

Relational DB's frequently used are MySQL, Oracle, SQL Server, Postgres. Even if there is no atomicity required, you can still use relational or non-relational db.

## Caching

**Use cases**

- While querying a db and you do not want to query the db many times, so you cache the value. 
- Alternativel, if you are making a remote call to a different service and that is having a high latency, you might want to cache the response of that system locally at your end in a caching solution.

Caching always stored as **key/value pairs**. So key normally is whatever your **where clause is in the query or whatever your query param or request params** are when you're making an API call and **value is basically the response that you are expecting from the other system**. So all of these kind of values would be stored in normally 
key value stores. 

**Caching tools:**

- Redis - Preferrable as easy to use/stable and very well tested
- Memcached, you could use "
- etcd 
- Hazelcast

## Storage

**File storage:** - You can store images locally and can serve but not redunant to failures.

**Cloud storage:** -  These are not dbs, but when ever you want to store images/videos, you can use this as a data store, which comes along with the CDN for faster serving across different geographical locations.

## Search

you might be designing something like an **uber or Google Maps** kind of a thing where you want to provide **text** **searching capabilit**y with support for fuzzy search. So for all of these kind of use cases you would be using something called as a **Text Search Engine**. Now a very common implementation of a Text Search Engine is provided by **Elastic Search and Solr**, and both of them are built on top of something called an **Apache Lucene** now Lucene fundamentally provides these text searching capabilities and that is then being used by both of these products Elastic Search(ES) and Solr, Now one more thing that they support is something called as a **Fuzzy Search**. So what is that is.. 
 
Let's say if you are searching for the word Airport and let's say is the user typed in "AIRPROT" with the wrong spelling, okay. this O and R are interchanged right.  Now, If a user searches for this and you do not return back any result, then that's a bad user experience, right. So you need your database to be able to figure out that the user did not really meant this thing [AIRPROT], the user actually meant AIRPORT, right? how does that database identify, so this word can be converted into the correct spelling of airport by changing two characters, right. R needs to be converted into O and O needs to be converted into R, right? so this is at an edit distance of two. So you can provide **a level of fuzziness that your search engine needs to support**. This has a fuzziness factor of two, which is the **Edit Distance**. Normally there are a lot of other factors also that come in but this is roughly how fuzzy searching is implemented in most of the solutions. **So wherever you have any search capabilities there you use either Elastic Search or Solr**. 

**Note:** One important thing about both of these are, these are **NOT databases**. These are **search engines**. So the difference between a Search Engine and a Database is whenever you write something in a Database, Database gives you a guarantee that that data wouldn't be lost.

## Metrics

Let's say you are storing some metrics kind of a data. So let's say if you are building a system like **Graphite, Grafana or Prometheus** which is basically an application metrics tracking system. So let's say if the use case that you are given is a lot of applications are pushing metrics related to their throughput, their CPU utilizations, their latencies, and all of that. And you want to build a system to support that. Then is when comes something called as a **Time Series Database**. Now think of Time Series Database as an extension of relational databases but with not all the functionalities and certain additional functionalities. 

So regular relational databases that you have would have the ability to update a lot of records right or they would also give you the ability to very random records but whenever you are building a metrics monitoring kind of a system you would never do random updates. You would always do sequential update in append-only mode if you wish to write entries. Also, read queries that you do, they are kind of bulk read queries with the time range. You query for last few minutes of data or few hours of data or few days of data, now time series databases are optimized for this kind of a query pattern and input pattern. 

Few of the time-series databases

- InfluxDB
- openTSDB(Open Time Series Database)

## Analytics

When you have lot of information and you want to store all of that information of a company in a certain kind of a data store for various kind of analytics requirements, like Amazon or Uber or any system design where you want to provide **analytics** on all the transactions of how many orders i'm having or geographies are giving me what revenues, most purchaes item etc, you need a **Data Warehouse**

**Data Warehouse** is basically a large database in which you can dump all of that data and provide various querying capabilities on top of the data to serve a lot of reports. Now these are generally not used for transactional systems, these are generally used for **offline reporting**. So if you have that kind of use case then you can use something like a **Hadoop** which can very well sit in for that purpose, where you put in a lot of data from various transactional systems and then build a lot of systems that can provide reporting on top of that data. 

## Document database

 Now let's say you do not have structured data, So maybe you are trying to build a catalog kind of a system for an e-commerce platform like Amazon which has information of all the items that are available on that platform. e.g catalog for Amazon i.e there is the item like shirt - A shirt would have an attribute like a size:(large, a color). Now normally when you are on an e-commerce platform you not only need to see these attributes if it is just about seeing them you could kind of **dump it as a Json and store it in any databases**. Now querying on a JSON or random attributes is a bit tricky on the relational databases, but there are certain kinds of databases that are optimized for those kind of queries. So these are the databases where you have a lot of data not just data in terms of volume but in terms of structure. So if you have lot of attributes that can come in and a wide variety of queries that can come in, then you fall into this category, and if that is the case then you need to use something called as a **document DB**. Now there are a lot of providers of document **DBs, MongoDB, Couchbase** are some of them. Earlier we looked at Elastic Search and Solr for text searching those are also special cases of Document Database.

 ## Columnar database
 
If you have an ever-increasing data.(i.e Uber), all the drivers of Uber are continuously sending location pings. so let's stay there are some number of drivers and they kind of translate into X number of location records per day. So there would be X number of records inputted per day. But this X would not be a constant, it would be a growing number why because the number of drivers of uber are increasing day by day right so this data would become probably X one day one. Additively 1.1X on day two, 1.2x on date three, so on and so forth. So it would not be increasing in a linear fashion it would be increasing but in a more than a linear fashion. So that is what I am calling an ever increasing data. Plus if you have finite number of type of queries. So let's if you want to track location pings of drivers the most important query that you will do is find all the locations of a driver whose driver ID is something right. So if you have less number of type of queries(maybe high volume) but a large amount of data then these kind of databases would be the best choice for you. This is something called as a **columnar DB** or **Column oriented DB**. **Cassandra** and **HBase** are the most used and most stable options out there for these kind of scenarios. most preffereeed option would be Cassandra which is not very heavy for deployment.

## Use cases

### Use case - 1
 
Now let's take an example of us building an e-commerce platform something like an Amazon. Now when you are managing inventory on that side you want to make sure that you are not over selling items. So let's say there is just one quantity of a particular item left and there are 10 users who want to buy that you want to have this ACID properties there to make sure that only one of the users should be able to commit the transaction other users should not be able to commit the transaction, right. You can put constraints and all of that on there. It would make sense to use a RDBMS database for the inventory management system of a system like Amazon or maybe an order management system right But if you look at the data of Amazon it is an ever interesting data. Why? because the number of orders are additive each day new orders are coming in they cannot purge the data due to lot of legal reasons plus the number of orders are also increasing so it naturally fits into this model right with you where I am recommending together Cassandra. So what you could use is a combination of both of these databases. **You could use MySQL or any other RDBMS alternate for storing data about the orders it has just placed and not yet deliver to the customer. Once the item is delivered to the customer you can then remove from this RDBMS, and put it into Cassandra as a permanent store.**


### Use case - 2

Now let's look at another example again taking an example of Amazon, let's say if you want to build a reporting kind of a thing which lets you query something like get me all the users who have bought sugar in last five days now sugar is not just a product. There are a lot of sellers selling different sugar alternates of different companies maybe, of different qualities maybe, right. so sugar would then be like a lot of item IDs right and on top of those a lot of item IDs there must be a lot of orders. Now again I am saying that **orders would either be in Cassandra or RDBMS**, but if you are doing random queries where some you might want to query on who bought sugar, who bought TV, who bought TV of certain quality, who bought a fridge of certain quality, that kind of logically goes into a model where I was recommending to use a **Document DB**. now what you could do is you could store the querying part over here(Document DB). You could basically say that I'll store a subset of order information into a MongoDB which says that user ID so and so, had an order ID so-and-so, on some particular date, which has these ten item ID in the certain quantity, right On this database you could run a query which will return you a list of users and list of order right and then you could take those Order IDs and query on both of these **systems(RDBMS+Cassandra)** right so here we are using all the **three systems in combination to provide various querying capabilities like with user bought what kind of use case**, right. So in any real world scenario you would have to use a combination of such databases to fulfill the functional and non-functional requirements that you have.