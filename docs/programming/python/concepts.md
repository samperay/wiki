# Python Concepts

## First-Class Functions
If a function can be assigned to a variable or passed as object/variable to other function, that function is called as `first class function` 

example-1

```python
def square(x):
    return x*x 

def cube(x):
    return x*x*x

# Receives a function, executes and returns result. You will provide as an list here
def mymap(func,args):
    result = []
    for each_item in args:
        result.append(func(each_item))

    return result 

sqr=mymap(square,[1,2,3]) # Output: [1,4,9]
cub=mymap(cube,[1,2,3]) # Output: [1,8,27]

# provide a single value to get the result.
def print_result(x, func):
    """recieve a function and execute it and return result"""
    return func(x)

do_square = square     # assigning square function to a variable
do_cube = cube         # assigning cube function to a variable

res = print_result(5, do_square)   # passing function to another function
```

example-2

We would use first-class function to create an html tag

```python
def create_html(tag):
    def wrap_text(text):
        print(f"<{tag}>{msg}/<{tag}>")
    return wrap_text
```

`create_html` would return the fucntion(`wrap_text`), we would use that function to call our msg wrapped in the html msg. 

```python
print_h1=create_html("h1")
print_h1("Heading1") # Output: <h1>Heading1</h1> 
```

## Decorators

A decorator is a function that takes another function as an argument and returns a modified version of the function. Decorators are often used to add functionality to functions, such as logging, timing, or error handling.

```python
def log_function(func):
  def wrapper(*args, **kwargs):
    print("Calling function:", func.__name__)
    result = func(*args, **kwargs)
    print("Function returned:", result)
    return result
  return wrapper

@log_function
def my_function(x, y):
  return x + y

print(my_function(1, 2))
```

```python
def my_decorator(func):
    def wrapper():
        print("Something is happening before the function is called.")
        func()
        print("Something is happening after the function is called.")
    return wrapper

@my_decorator
def say_hello():
    print("Hello!")

say_hello()
```

A generator is a function that produces a sequence of values, one at a time. Generators are created using the yield keyword. Generators are useful for a variety of tasks, such as filtering a sequence of values, transforming a sequence of values, or iterating over a large sequence of values without storing the entire sequence in memory.

```python
def read_file(filename):
  with open(filename, 'r') as f:
    for line in f:
      yield line

for line in read_file('my_file.txt'):
  print(line)
```

![Differences](../../images/diff_decorators_generators.png)


```python
def timeit(func):
    def wrapper(*args, **kwargs):
        start = time.time()
        result = func(*args, **kwargs)
        end = time.time()
        print("Time taken to execute function:", end - start)
        return result
    return wrapper

@timeit
def factorial(n):
  print("Without using cache decorator")
  return n*factorial(n-1) if n else 1 

print(factorial(5))
```

## Closures

example-1

Python closure is a nested function that allows us to access variables of the outer function even after the outer function is closed.

```python
def outer_function():
messge="Hi"

def inner_function():
    print(messge) # you would be able to access the variable of outer function.

return inner_function()

hi=outer_function() # Output: Hi
```

example-2

let's modify the code and we could store the `inner_function` as variable and then call return value

```python
def outer_function(message):
	messge=message

	def inner_function():
		print(messge) # you would be able to access the variable of outer function.

	return inner_function

print_hi=outer_function("hi")
print_hello=outer_function("hello")

print(print_hi.__name__) # Output: inner_function
print(print_hello.__name__) # Output: inner_function

print_hi() # Output: hi
print_hello()  # Output: hello
```

example-3

let's use closure to add and subtract example, additionally while doing so, we could log it in the file `example.log`

```python
import logging
logging.basicConfig(filename="example.log",level=logging.DEBUG)

def logger(func):
	def log_func(*args):
		logging.info(f"logging {func.__name__} with arguments {args}")
		print(func(*args))
	return log_func

def add(x,y):
    return x+y

def sub(x,y):
    return x-y

add_logger=logger(add)
sub_logger=logger(sub)

print(add_logger.__name__) # Output: log_func  
print(sub_logger.__name__) # Output: log_func

add_logger(4,5) # Output: 9
sub_logger(20,10) # Output: 10
```

## Shallow and Deep Copy

A shallow copy creates a new object but references the same elements as the original object. In other words, it creates a new container object and fills it with references to the same elements as the original. The references point to the same memory addresses as the original elements. If any of the referenced elements are mutable, changes made to them will be reflected in both the original and the shallow copy.

You can think of "hardlink" in linux prespective. 

```
import copy

list1 = [1, 2, [3, 4]]
list2 = copy.copy(list1)

list2[0] = 5
list2[2].append(5)

print(list1)  # Output: [1, 2, [3, 4, 5]]
print(list2)  # Output: [5, 2, [3, 4, 5]]
```

### Shallow Copy Use Cases

**Cloning mutable objects:** Shallow copy is often used when you want to create a new object that shares the internal state with the original object. This can be useful when working with mutable objects like lists or dictionaries, where you want to create a modified version while preserving the original.

**Performance optimization:** Shallow copy can be more efficient in terms of time and memory when dealing with large objects or data structures. Instead of duplicating the entire object, a shallow copy simply creates references to the existing elements.

**Nested data structures:** Shallow copy is appropriate when you have nested data structures, such as a list of lists or a dictionary of dictionaries. It allows you to create a new structure that maintains references to the original nested objects.

**Deep Copy:**

A deep copy creates a new object and recursively copies all the elements from the original object to the new object. It creates a completely independent copy with its own set of elements. Any changes made to the copied elements will not affect the original object.

softlink from linux prespective. 

```python
import copy

list1 = [1, 2, [3, 4]]
list2 = copy.deepcopy(list1)

list2[0] = 5
list2[2].append(5)

print(list1)  # Output: [1, 2, [3, 4]]
print(list2)  # Output: [5, 2, [3, 4, 5]]
```

### Deep Copy Use Cases

**Creating independent copies:** Deep copy is used when you want to create a completely independent copy of an object and its internal state. This is useful when you need to modify the copied object without affecting the original object.

**Avoiding unintended side effects:** Deep copy ensures that any modifications made to the copied object or its nested elements do not impact the original object. This can be important when dealing with complex data structures or when multiple objects need to maintain their own separate state.

**Immutable objects:** Deep copy is suitable for creating copies of immutable objects, such as strings or tuples, where modifying the object is not possible. Deep copy allows you to create a new object with the same value.

## Iterators and Generators

**Iterator:**
An iterator is an object that allows sequential access to elements in a collection (e.g., lists, tuples, sets) without exposing the underlying structure.

It operates on the principle of "lazy evaluation," meaning it fetches the next element only when requested. This saves memory and improves performance when dealing with large collections.

Iterators use two primary methods:
__iter__: Returns the iterator object itself.
__next__: Retrieves the next element from the collection. If there are no more elements, it raises the StopIteration exception.

Iterators are typically used with a for loop or the built-in next() function.

```python
my_list = [1, 2, 3, 4]
my_iterator = iter(my_list)

print(next(my_iterator))  # Output: 1
print(next(my_iterator))  # Output: 2
print(next(my_iterator))  # Output: 3
print(next(my_iterator))  # Output: 4
# print(next(my_iterator)) # Raises StopIteration because no more elements.

```

**Generator:**

A generator is a special type of iterator that is created using a function with one or more yield statements.
It allows you to define an iterative algorithm by suspending the execution state and yielding values one at a time, instead of returning the entire collection at once.

Generators are memory-efficient because they produce elements on-the-fly and don't store the entire collection in memory.

They are usually implemented using a for loop or by calling the generator function directly.

```python
def my_generator():
    yield 1
    yield 2
    yield 3
    yield 4

gen = my_generator()

print(next(gen))  # Output: 1
print(next(gen))  # Output: 2
print(next(gen))  # Output: 3
print(next(gen))  # Output: 4
# print(next(gen)) # Raises StopIteration because there are no more elements.
```

**iterators** are objects that provide sequential access to elements in a collection, whereas **generators** are a type of iterator that allows you to define a sequence using a function with yield statements, offering memory-efficient and lazy evaluation behavior.

## Variable-Length Arguments

*args allows you to pass a variable number of non-keyword arguments to a function. It is used to handle scenarios where the exact number of arguments is not known in advance.

**kwargs allows you to pass a variable number of keyword arguments. It is used when you want to handle named arguments in a function.

```python
def my_function(*args, **kwargs):
    print("Arguments:", args)
    print("Keyword arguments:", kwargs)

my_function(1, 2, 3, name="John", age=30)
```

## Python Memory Management

Python uses a private heap that stores all objects and data structures. The memory management is handled by Python's memory manager, which ensures that memory is allocated efficiently and that the interpreter doesn't run out of memory. Python also has an in-built garbage collector, which reclaims memory by deallocating objects that are no longer in use. The primary mechanism for garbage collection is reference counting, but Python also uses a cycle detector to deal with reference cycles.

## Identity and Equality

`is`: Checks whether two **references** point to the same object (identity)
`==`: Checks whether the **values** of two objects are equal (equality).

## Object-Oriented Programming (OOP)

### Encapsulation

Bundling data and methods within a single unit.
when you create a class, it means you are `implementing encapsulation`

encapsulation allows us to restrict accessing variables and methods directly and prevent accidental data modification by creating private data members and methods within a class.

**public** : accessable anywhere form outside the class.

**private** : Accessible within the class

**Protected** : within the class and its sub-classes(inheritance)


#### Getters and Setters

getter method to access data members and the setter methods to modify the data members

private variables are not hidden fields like in other programming languages. The getters and setters methods are often used when:

When we want to avoid direct access to private variables
To add validation logic for setting a value

```python
class Employee:

    def __init__(self,name,salary,age):
        # public members
        self.name = name

        # private members
        self.__salary=salary
        self.__age=age

        # protected members
        self._project="Oracle pvt ltd"

    # getters
    def get_age(self):
        print(self.__age)

    # setters
    def set_age(self,age):
        # you can use the logic before changing
        # the object
        if age > 130:
            print("not sure anyone is alive.. please submit proof of living!")
        self.__age = age

    def show(self):
        print(f"{self.name}'s age is {self.__age} drawing salry of {self.__salary}")


class EmployeeDepartment(Employee):
    def __init__(self,name):
        Employee().__init__(self)
        self.name = name

    def show(self):
        print(f"{self.name} employee working in project {self._project}")


emp=Employee("employee",100000,33)
emp.show()

emp.set_age(29) #Private members can be accessed by using public methods.
emp.get_age()
print(emp._Employee__age) #Name mangling.

print(f"Employee project details: {emp._project}")


sunil=Employee("Sunil",100000,34)
sunil.set_age(32)
```

#### The `@property` Decorator

The @property decorator in Python is used to define methods that are accessed like attributes, providing a way to implement computed properties or control access to class attributes. It allows you to define a method that can be accessed as if it were an attribute, without the need to explicitly call it as a method.

```python
class Circle:
    def __init__(self,radius):
        self.radius = radius

    @property
    def diameter(self):
        return self.radius

    @diameter.setter
    def diameter(self,value):
        if value > 0:
             self.radius=value

    @diameter.deleter
    def diameter(self):
        del self.radius

    @property
    def area(self):
        return 3.14 * self.radius**2

mycircle=Circle(2)
mycircle.diameter=10  # you can use method as an attribute.
print(mycircle.diameter)

print("setter")

mycircle.diameter=0
print(mycircle.diameter) # Output: 10, since the value is set to 0, it would output the previous value associated in the object.

print("deleter")
del mycircle.diameter
print(mycircle.diameter)  # raise an exception as the circle object has deleted the 'radius' attribute
```

### Abstraction

#### Abstract Classes

Abstract classes are those classes that can't be instantiated directly, it would only serve as a blue print. They are always designed to be `subclassed` and they would contain `abstractmethod` that must be implemented by their subclass.

```python
from abc import ABC, abstractmethod

class Animal(ABC):
    @abstractmethod
    def make_sound(self):
        pass
```

When you are trying to instantiated `animal=Animal()`, it would throw an error.

```Error: Can't instantiate abstract class Animal with abstract methods make_sound```

Now, you would have an subclass of `Animal` that uses an `abstractmethod`

```python
class Dog(Animal):
    def make_sound(self):
        print("Woof")

class Cat(Animal):
    def make_sound(self):
        print("Meow")

dog=Dog()
dog.make_sound() # Output: Woof

cat=Cat()
cat.make_sound() # Output: Meow
```

### Constructors

Special method used to create and initialize an object of a class. The primary use of a constructor is to declare and initialize data member/instance variables of a class.

#### Constructor Types

- **Default Constructor** - It does not perform any task but initializes the objects

- **Non-parametrized constructor** - A constructor without any arguments is called a non-parameterized constructor.

- **parametrized constructor** - A constructor with defined parameters or arguments is called a parameterized constructor.

```python
class Employee:
    # class variable
    count=0
    # Parameterized Constructor with default values
    def __init__(self,name="Raghu",age=12):
        self.name = name
        self.age=age
        Employee.count+=1

    # Non Parametrized Constructor.
    # def __init__(self):
    #    self.name="Raju"
    #    self.age=18"

    # when there is no __init__ method, its default constructor

    def display(self):
        print(f"employee {self.name} is around {self.age} years old")


emp1=Employee("Ram",18)
emp1.display() # Output: employee Ram is around 18 years old

# Object created with default values
emp2=Employee()
emp2.display() # Output: employee Raghu is around 12 years old

print(f"Total number of employees: {Employee.count}")
```

#### Constructor Chaining with `super()`

Constructor chaining is the process of calling one constructor from another constructor. Constructor chaining is useful when you want to invoke multiple constructors, one after another, by initializing only one instance. constructor chaining is convenient when we are dealing with inheritance.

```python
class Vehicle:
    def __init__(self,engine):
        self.engine = engine

class Car(Vehicle):
    def __init__(self,engine, max_speed):
        super().__init__(engine)
        self.max_speed=max_speed

class ElectricCar(Car):
    def __init__(self,engine,max_speed,km):
        super().__init__(engine,max_speed)
        self.km=km

ev = ElectricCar('1500cc', 240, 750)
print(f"{ev.engine} is having max speed {ev.max_speed} travelling distance of {ev.km}")
```

### Polymorphism

Polymorphism in Python is the ability of an object to take many forms. Polymorphism is mainly used with inheritance.

#### Method Overriding

Using method overriding `polymorphism` allows us to defines methods in the child class that have the same name as the methods in the parent class. This `process of re-implementing the inherited method in the child class` is known as **Method Overriding**.


```python
class Vehicle:
    def __init__(self,name,color):
        self.name = name
        self.color = color

    def show(self):
        print(f"{self.name} is having color of {self.color}")


    def max_speed(self):
        print("Vehicle max speed is 150")

    def change_gear(self):
        print('Vehicle change 6 gear')

class Car(Vehicle):

    # due to polymorphism, max_speed() and change_gear()
    # methods are overridden for the car object.

    def max_speed(self):
        print("car max speed is 250")

    def change_gear(self):
        print('car change 7 gear')



car = Car('Benz', 'Red')
car.show() # this method isin't overridden.
car.max_speed()

vehicle = Vehicle('Volvo', 'Yello')
vehicle.show()
vehicle.max_speed()
```

#### Duck Typing

```python
class StudentASection:
    def students(self):
        print("A section students")

    def class_teacher(self):
        print("Mohan")

class StudentBSection:
    def students(self):
        print("B section students")

    def class_teacher(self):
        print("Mohana")

a_section_student=StudentASection()
b_section_student=StudentBSection()

# you can create function and pass as objects
#def some_function(obj):
#    obj.call_methods

for students in (a_section_student,b_section_student):
    students.students()
    students.class_teacher()
```

You could also pass as a single object to the above `objects into the function`


```python
def get_student_details(obj):
    obj.students()
    obj.class_teacher()

get_student_details(a_section_student)
get_student_details(b_section_student)
```

### Instance, Class, and Static Methods

`class and static methods` are special types of methods that have different behaviours and use cases when compared to `regular instances methods`


#### Instance Methods

these are bound to regular object instance. they can access and modify the object's state and can be called on an object instance.

```python
class Person:
    def __init__(self, name, age):
        # instance variables
        self.name = name
        self.age=age

    # instance methods
    def get_name(self):
        return self.name

    # instance methods
    def get_age(self):
        return self.age

    # instance methods
    def set_name(self,newname):
        self.name = newname

    # instance methods
    def set_age(self, newage):
        self.age = newage


person1 = Person("Sunil", 30)
print(person1.get_name())
print(person1.get_age())
person1.set_name("Kumar")
print(person1.get_name())
```

#### Class Methods

class methods are bound to class itself and they can access only class variables. It can only allow to change the class variable state across all the class objects.

Class methods are used when we are dealing with factory methods. factory methods are those which returns the class object for different purposes.

They are always called using `ClassName.method_name()`

![class images](../../images/class_method.webp)

```python
from datetime import date

class Student:
    collage_name = "ABC Collage"
    def __init__(self,name,age):
        self.name = name
        self.age = age

    @classmethod
    def calculate_age(cls,name,birthyear):
        # calulate age and set it as age, then
        # return a new object
        return cls(name,date.today().year-birthyear)


    def show(self):
        print(f"{self.name} age is: {self.age} studying in colleage: {Student.collage_name}")


sunil = Student("Sunil",39)
sunil.show()

shiva=Student.calculate_age("Shiva",1983) # invoke a new clas
shiva.show()
```

Explanation of above code.

- we created two objects, one using the constructor and the second using the `calculate_age()`

- The constructor takes two arguments name and age. On the other hand, class method takes cls, name, and birth_year and `returns a class instance which nothing but a new object`

- The `@classmethod` decorator is used for converting `calculate_age() method to a class method.`

- The `calculate_age()` method takes Student class (cls) as a first parameter and `returns constructor by calling Student(name, date.today().year - birthYear), which is equivalent to Student(name, age).`

#### Static Methods

Any method we create in a class will automatically be created as an instance method. We must explicitly tell Python that it is a static method using the `@staticmethod`

```python
class Student:
    @staticmethod
    def student_greeting(greeting_msg):
        print(f"Hello {greeting_msg}")


Student.student_greeting("Welcome Students !")

sunil=Student()
sunil.student_greeting('Welcome Sunil !')
```

```python
class Employee:
    def __init__(self,name,project_name):
        self.name = name
        self.project_name=project_name

    # instance method
    def work(self):
        requirements = self.gather_requirements(self.project_name)
        for task in requirements:
            print(f"Completed: {task}")


    @staticmethod
    def gather_requirements(project_name):
        if project_name == "ABC":
            requirements = ["task1", "task2"]
        else:
            requirements = ["task1"]

        return requirements

emp = Employee("Sunil","ABC")
emp.work()
```

**output:**

```
Completed: task1
Completed: task2
```

#### Updating Class Variables

```
@classmethod
def change_collage(cls, newcollname):
    # change class variable
    cls.collage_name=newcollname

Student.change_collage("New coll")
sunil.show()
```

#### Comparing `@staticmethod` and `@classmethod`

@staticmethod: Defines a method that doesn’t require access to the instance (self) or class (cls). It behaves like a plain function but belongs to the class’s namespace.

@classmethod: Defines a method that receives the class (cls) as its first argument instead of the instance (self). It can modify the class state that applies across all instances of the class.

```python
class MyClass:
    @staticmethod
    def static_method():
        print("This is a static method.")

    @classmethod
    def class_method(cls):
        print(f"This is a class method of {cls.__name__}")

MyClass.static_method()
MyClass.class_method()
```

#### Server Examples

##### Creating a Default Server with `@classmethod`
A class method is a method that takes the class itself as the first argument, rather than an instance of the class. It is useful when you want to perform operations that involve the class itself (for example, modifying class variables or calling other class methods). Class methods are defined using the @classmethod decorator, and the first argument is conventionally named cls.

**When to use @classmethod:**
When you need to work with the class as a whole (like creating factory methods, manipulating class-level data, or altering class attributes).
When you want to create alternative constructors.
When the logic is related to the class, not specific instances.


```
class Server:
    server_count = 0  # Class variable to track how many servers exist

    def __init__(self, name, ip):
        self.name = name
        self.ip = ip
        Server.server_count += 1

    @classmethod
    def create_default_server(cls):
        return cls("DefaultServer", "192.168.0.1")

# Example usage
server1 = Server("MainServer", "192.168.1.1")
server2 = Server.create_default_server()  # Using class method to create an instance

print(server1.name)  # Output: MainServer
print(server2.name)  # Output: DefaultServer
print(Server.server_count)  # Output: 2

```

##### Validating an IP Address with `@staticmethod`

A static method does not receive any special first argument (neither self nor cls). It behaves like a regular function but belongs to the class's namespace. You use a static method when the method's logic neither depends on the instance nor the class, but you want to group it inside the class for logical reasons.

**When to use @staticmethod:**

When you need utility functions that are logically related to the class but don't need access to instance (self) or class (cls) data.
When the method doesn't modify class or instance state.

```
class Server:

    def __init__(self, name, ip):
        self.name = name
        self.ip = ip

    @staticmethod
    def is_valid_ip(ip):
        parts = ip.split(".")
        return len(parts) == 4 and all(0 <= int(part) < 256 for part in parts)

# Example usage
print(Server.is_valid_ip("192.168.1.1"))  # Output: True
print(Server.is_valid_ip("999.999.999.999"))  # Output: False

```

**Summary:**

Class Method (@classmethod): Use when you need to operate on the class itself. The method has access to the class via cls.

Static Method (@staticmethod): Use when the logic doesn't need to access the instance (self) or class (cls). It is more like a utility function within the class.
