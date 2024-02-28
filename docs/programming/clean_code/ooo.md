
## Diff b/w obj & ds

**Object**

- private internals/properties, public API
- Contain your business logic 
- Abstractions over conceretions

**data structures**

- public internals/properties, no API
- stores and transports data
- concertions only

## Object and polymorphism

The ability of an object to take many forms.

Classes should be small, and it should have Single Responsibility.

## Cohestion

how much are your class methods using the class properties.
Goal: not all the methods uses the propeties, but you can make sure that most of the properties will be used by the methods. i.e they are **highly cohesive**.

## law of demeter

principles of least knowledge: Don't depend on the internals of "strangers"(other objects that you don't know directly.)

Code in a methods may only access direct internals(properris and methods) of:
- the object it **belongs to**
- objects that are **stored in properties of that object**
- objects which are **received as methods parameters**
- objects which are **created in the method**

always tell what to do, instead of asking.

## SOLID

work on the solid principles desing for clean code.



