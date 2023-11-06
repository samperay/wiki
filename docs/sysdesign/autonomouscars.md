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
- 

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

Data volume: 

1msg =1KB  
  i.e 7000 msg = 7MB/sec
  i.e ~25GB/hr
  i.e ~605GB/day
  i.e ~221TB/year 

Retention period

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

**First component: **
- Receive telementry
- Validate telementry
- Store telementry
- Query & analyze telementry

**Second component:**
**Cars** - Source of the data, since no control for us

**Third component:**
**Telementry gateway** - receives telementry data from cars.
Since the load is very high, no validation, storing or query etc will be done.

**Fourth component:**
**Telementry pipeline** - It will receive the msg from the gateway, and put into the pipeline. hence no load on the system. i.e It will **queue** the telementry msg for processing

**Fifth component**
**telementry processor** - Validate and process any msg and store in the data base.

**Six component**
**telementry viewer** - Queries the database and displays real time data.(dashboards)

**seventh component**
**Data warehouse** - store aggregated msg from databases

**Eigth component**
**BI application:** It is used only to report and analysis.

**Ninth component:
**Archive DB** - Make sure you have huge database to just store rhe information. we don't need to query anything for operational purpose. incase you need to work, you need to put that data in the operational DB and work upon.




