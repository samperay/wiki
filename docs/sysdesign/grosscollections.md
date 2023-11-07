In this case study, we are allowing customer to create shopping lists that get collected and delivered by grosscoll employees. It already available all oever world.  
Employees have dedicated tables and displaying the list

Design the **collection side** of the system. Cutomer side is already developed,

## System Requirements

### functional 

What should system do ?

- Web based 
- tablets receive the list to be called 
- Employees can mark items as collected or unavailable.
- When collection is done, list must be transferred to payment engine
- offline support is a must

### non-functional

What should system deal with ?

1. is it data intrinsic ?
2. Users ?
3. How much of data ?
4. Performance ?

Questions to ask customers ?

1. How many concurrent users ?
sol: 200

2. How many list processed/day ?
sol: 10000

3. whats the avg size of the shopping list?
sol: 500KB

4. Do we need offline support ?
sol: yes

5. What's the SLA ?
sol: highest possible

6. Since we already know that customer shopping is already developed, then how do lists arrive to the system ?
sol: Queue - which means we know that all the meg arrive in queue and we need to pull the msg and process the data. 

**Data volume**

1 list = 500KB
10000 list/per day =  ~5GB/per day
monthly = ~150GB/month
yearly = ~1800GB/year = ~2TB/year

## Map the components

**Componets**
- Employee have tablets
- offline support
- retrive lists
- mark items
- export list to payment engine

![gross_components](../images/gross_components.png)


we keep list receiver and service differently, because in future if there is any change in the database we don't have to work completely modifying the service..

## list receiver

