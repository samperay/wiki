In this case study, we are working on autonomous cars that are manufacturing vehicles, at present there are already 20K cars running, by end of year it would be arounf 200K. We are required to work on the telementry of the cars relability and display details about it.  i.e breakdown, malfunctions, accidents, and use the same data for better needs.

## Requirements

what should system do ?

- Web based
- CURD Operations
- Manager alerts
  - breakdowns
  - malfunctions
- provide information to the admin team
- alert to near hospitals or mechanic shops
- road assistance

### Functional

What system should do ?

1. Web based 
2. Receive telementry from cars(localtion, speed, breakdown)
3. Store telementry in persistent store
4. Display dashboard summarizing the data
5. Perform analysis on the data.

### Non Functional

What the systen should deal with ?

So when we are designing the non-functional, we must first start witj what we already know of..

1. Data intensive system 
2. Not a lot of users
3. A lot of data
4. Performance is important

Questions to ask customers ?

1. How many expected concurrent users ?
Sol: 10

2. How many telementry msg received per second (load avg)
Sol: 7000/sec

3. What is the avg size of each msg
sol: 1KB ( quite small)

4. Is the msg schema-less ( any predefined data structures, etc )
sol: yes ( not predefined)

5. Can we tolerate some msg loss ?
sol: sort of.. 

6. What is desired SLA ?
sol: Highest possible..

**Data volume:**

1msg =1KB  
i.e 7000 msg = 7MB/sec
i.e ~25GB/hr
i.e ~605GB/day
i.e ~221TB/year 

**Retention period**

How long you want your rectods to be kept in the DB ?

What happens to them after the retention period ?

- Deleted
- Move to archived data store

Motivation:

- keeps db from expoloding
- improve query performance

Two types of data:

- Operational, near realtime (location, speed).. etc
Retention period: 1 week

- Aggregated and ready for analysis(Business Intelligence)
Retention period: Forever

## Mapping components

**Component:**
- Receive telementry
- Validate telementry
- Store telementry
- Query & analyze telementry

**First component:**
**Cars** - Source of the data, since no control for us

**Second component:**
**Telementry gateway** - receives telementry data from cars.
Since the load is very high, no validation, storing or query etc will be done.

**Third component:**
**Telementry pipeline** - It will receive the msg from the gateway, and put into the pipeline. hence no load on the system. i.e It will **queue** the telementry msg for processing

**Fourth component**
**telementry processor** - Validate and process any msg and store in the data base.

**Fifth component**
**telementry viewer** - Queries the database and displays real time data.(dashboards)

**Six component**
**Data warehouse** - store aggregated msg from databases

**Seventh component**
**BI application:** It is used only to report and analysis.

**Eighth component**:
**Archive DB** - Make sure you have huge database to just store the information. we don't need to query anything for operational purpose. incase you need to work, you need to put that data in the operational DB and work upon.

## Telementry Gateway

- Receives data from cars using TCP
- Pushes the data to pipeline

### Application Type

- Web App & Web API - No
- Mobile App - No
- Console - Yes
- Service - Yes
- Desktop App - No

### Technology stack 

**Considerations:**
- Load ( 7000 msg/sec) 
- Persormance is very good
- Team's current knowledge and skill set
- Environment (OS..etc)

### Telementry gateway ques for customer 

ask customer about environment and skill set.. 
Custome reply : python and javascript with good linux skills

But we can't use python for this as its interpreeted lang and very slow
Hence we go for **nodejs** which is great performance runs on linux and leverage javascript

### Architecture

- User/interface: No 
- Business logic : No
- Data Access: No
- Data store: No

Since telementry data uses none of the above, we don't need anything from above 
**We need Service interface and qquickly pushes into pipeline**

**Redunancy for telementry gateway**
place the gateway behind the Load balancer(3 instances) - scale across traffic and regions as the data will be high.

## Telementry pipeline

- Gets msg from the gateway
- Queus the telementry for further processing
- Basically, queue for streaming high volume of data

### Telementry pipeline ques for customer

- is there any existing queue mechanism in company ?  No
- use 3rd party - we will go with **Apache kafka**.

**Apache Kafka** 

**Pros:**

- Very popular
- Handle massive amount of data
- HA

**Cons:**

- Complex to setup and configure

## Telementry processor

- Receives from the pipeline
- Process the msg(mainly validation)
- Stores msg in the database

### Application Type 

Web App & Web API - No
Mobile App - No
Console - Yes
Service - Yes
Desktop App - No


### Technology stack 

**Considerations:**

- Processor:
Solution: nodejs - already used, fast and great support for kafka

**Operational DB:**
- Data store: schema-less msg support
- quick retrivals
- no complex queries

Solutiom: **MangoDB** 

**Archive Db:**

- support for huge amt of data
- not accessed frequently
- no need for fast retrival
- save costs

Solution: Cloud storage (Azure)

### Architecture

User/interface: No 
Business logic : No
Data Access: No
Data store: No

**Redunancy for telementry processor**
place the gateway behind the Load balancer(3 instances) - scale across traffic and regions as the data will be high.

## Telementry viewer

- Allow end uses to query data
- Displays real time data

What it doesn't do - Analyze the data..

### Application Type 

Web App & Web API - yes
Mobile App - No
Console - No
Service - No
Desktop App - No

### Technology stack 

Backend:
Solution: NodeJS

Frontend: 
Solution: ReactJS

### Architecture

We need to use classic 3-layered arch for this component.

User/interface: Yes 
Business logic : Yes
Data Access: Yes
Data store: No

### Design API component

- Get latest errors for all cars

```GET /api/v1/telementry/erorrs 
200 Ok or Empty list or dict
```

- Get latest telementry for specified car

```
GET /api/v1/telementry/{carid}
200 OK / 404 Not Found

```
- Get latest errors for specific car
```
GET /api/v1/telementry/error/{carid}
200 OK/ 404 Not Found
```

**Redunancy for telementry viewer**
place the gateway behind the Load balancer(3 instances) - scale across traffic and regions as the data will be high.

## BI Application

- Analyze telementry data
- Display custom reports about data, trends, forcasts

how many cars did break during the last month
what is the total distance the cars drove  etc 


### Application Type 

Doesn't matter 
BI application is always based on the existing ones

Figure our from the gartner 

Power BI - Microsoft 
ableau 

Note: Designing BI is not part of arch job
Inform the customer saying that we are not part of BI experts, he can bring anyone he wishes to and we would be working with him to assist him as we laid out the high level system specs