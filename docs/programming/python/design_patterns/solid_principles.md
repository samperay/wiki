**SOLID** is an acronym that stands for five key design principles: 

- Single responsibility principle
- Open-closed principle
- Liskov substitution principle
- Interface segregation principle
- Dependency inversion principle

## Single Responsibility Principle (SRP)

The Single Responsibility Principle (SRP) states that a class or module should have only one reason to change. In other words, each class or module should have a single responsibility or purpose.

```
class Student:
    def __init__(self, name, id_number):
        self.name = name
        self.id_number = id_number

    def get_name(self):
        return self.name

    def get_id_number(self):
        return self.id_number

    def __str__(self):
        return f"name: {self.name} \nid: {self.id_number}\n"

    # Breaking SRP because, its saving to database and not associated with 
    Student class, so it should not be overloaded.
    def register(self, filename):
        with open(filename, "w") as fh:
            fh.write(f"name: {self.name} \nid: {self.id_number}\n")
```

In order not to use the above rule, you would be modifying the rule as below and re-writing the function. 

```
class StudentRegistration:
    def save_to_file(self,student, filename):
        with open(filename, "w") as fh:
            fh.write(f"name: {student.name} \nid: {student.id_number}\n")
```

Create couple of students

```
student1=Student("Sunil", "1")
student2=Student("Shiva", "2")
```

Save the student registration by using seperate class and save them.

```
register_student=StudentRegistration()
filename=r"/Users/sunilamperayani/sandbox/design-patterns/students.db"
print("saving the student to the database.")
register_student.save_to_file(student1,filename)
```

Another example, 

```
class FileReader:
    def __init__(self, file_path):
        self.file_path = file_path
    
    def read_file(self):
        with open(self.file_path, 'r') as f:
            return f.read()
```

## Open-Closed Principle (OCP)

The Open-Closed Principle (OCP) states that software entities (classes, modules, functions, etc.) should be open for extension but closed for modification. In other words, the behavior of a software entity should be easily extended without modifying its source code.

Let's explain by example...

You have a products, and you need to filter the products.

### Without OCP

```
class Product:
    def __init__(self, name,size,color):
        self.name = name 
        self.size = size
        self.color = color
    
class ProductFilter:
    def filter_by_size(self,product,size):
        for p in products:
            if p.size == size: yield p 
```

Let's say you need to `filter_by_color` / `filter_by_color_and_size` / `filter_by_color_or_size`. In future, you have more parameters like "weight, height, thickness etc" .. you can't scale the class as such. 

Hence once you create a **class you would need to close the class for modifications and open for extension**.

```
apple = Product("Apple", COLOR.GREEN, SIZE.SMALL)
tree = Product("Tree", COLOR.GREEN, SIZE.LARGE)
house = Product("House", COLOR.BLUE, SIZE.MEDIUM)

products = [apple,tree,house]

pf = ProductFilter()
print('Green products (old):')
for p in pf.filter_by_color(products,COLOR.GREEN):
    print(f' - {p.name} is green')
```

### With OCP

You create a new functionality for `specifications` which satisfies the criteria for filtering. We would create a two base classes which can be used to override logic in future cases. 

```
# Base class
class Specification:
    def is_satisfied(self, item):
        pass

# Overide the base class and use your logic for 
# future application.

class ColorSpecification(Specification):
    def __init__(self, color):
        self.color = color

    def is_satisfied(self, item):
        return item.color == self.color

class SizeSpecification(Specification):
    def __init__(self, size):
        self.size = size

    def is_satisfied(self, item):
        return item.size == self.size

class HeightSpecifcation(Specification):
    pass 

class WeightSpecification(Specification):
    pass

```

We will create filter specification and override from this section. 

```
# Base class
class Filter:
    def filter(self, items, spec):
        pass


# Overrise the baseclass and use for your application/business logic.

class BetterFilter(Filter):
    def filter(self, items, spec):
        for item in items:
            if spec.is_satisfied(item):
                yield item
```

```
apple = Product("Apple", COLOR.GREEN, SIZE.SMALL)
tree = Product("Tree", COLOR.GREEN, SIZE.LARGE)
house = Product("House", COLOR.BLUE, SIZE.MEDIUM)

products = [apple,tree,house]

bf = BetterFilter()

print('Green products (new):')
green = ColorSpecification(COLOR.GREEN)
for p in bf.filter(products,green):
    print(f' - {p.name} is green')

print('Blue products (new):')
blue = ColorSpecification(COLOR.BLUE)
for p in bf.filter(products,blue):
    print(f' - {p.name} is blue')

print('Large products:')
large = SizeSpecification(SIZE.LARGE)
for p in bf.filter(products, large):
    print(f' - {p.name} is large')
```

Another example, 

```
class Shape:
    def area(self):
        pass


class Rectangle(Shape):
    def __init__(self, width, height):
        self.width = width
        self.height = height
    
    def area(self):
        return self.width * self.height


class Circle(Shape):
    def __init__(self, radius):
        self.radius = radius
    
    def area(self):
        return 3.14 * self.radius**2


def calculate_total_area(shapes):
    total_area = 0
    for shape in shapes:
        total_area += shape.area()
    return total_area
```

## Liskov substitution principle (LSP)

In this principle, if the program is using the base class, it should be able to work correctly with any derived class of that base class without needing to know the specific subclass. 

let's read using demo

### Without LSP

we would calculate the area of `rectangle` and `square`. A rectable would have a `height` and `width` where as square would have all the sides as same so we would equate height=width and then calculate the result of the area. 

```
# Base class
class Rectangle:
    def __init__(self, width, height)
        self.width=width
        self.height=height

    def set_width(self,width):
        self.width=width 

    def set_height(self,height):
        self.height=height

    def area(self):
        return self.height * self.width

# Derived/subclass
class Square(Rectangle):
    # Override from the base class

    # This breaks the LSP principle, you can see the output
    def __init__(self,length):
        super().__init__(length,length)

    def set_width(self,width):
        self.width=width 
        self.height=height

    def set_height(self,height):
        self.height=height
        self.width = height

def print_area(rectangle):
    rectangle.set_width(5)
    rectangle.set_height(4)
    print("Area", rectangle.area())

rectangle=Rectangle(5,4) # Area: 20
square=Square(5) # Area: 16 
```

You might have seen the above square method, since its being overridden from the rectangle class, the value has been changed completely in violation of LSP. 

We would rectify now and see how we can use that prunciple. 

### With LSP

we would define the base class `shape` which can be overridden and calculates the area of the shape. 

```
class Shape:
    def area(self):
        pass

class Rectangle(Shape):
    def __init__(self, width, height):
        self.width = width
        self.height = height

    def area(self):
        return self.width * self.height

class Square(Shape):
    def __init__(self, length):
        self.side_length = length

    def area(self):
        return self.side_length**2

def print_area(shape):
    print("Area:", shape.area())

rectangle=Rectangle(5,3)
square=Square(5)

print_area(rectangle) # Output: Area: 15
print_area(square) # Output: Area: 25
```

## Interface Segregation Principle (ISP)

The Interface Segregation Principle (ISP) states that clients should not be forced to depend on interfaces they do not use.

### Example - 1 [ Violation ]

```
class Animal:
    def move(self):
        pass

    def eat(self):
        pass

    def swim(self):
        pass


class Fish(Animal):
    def move(self):
        print("Swimming")

    def eat(self):
        print("Eating underwater")

    def swim(self):
        print("Swimming")


class Bird(Animal):
    def move(self):
        print("Flying")

    def eat(self):
        print("Eating insects")

    def swim(self):
        raise NotImplementedError()


class Client:
    def __init__(self, animal):
        self.animal = animal

    def move_animal(self):
        self.animal.move()

    def feed_animal(self):
        self.animal.eat()

    def swim_animal(self):
        self.animal.swim()


# Usage
fish = Fish()
bird = Bird()

fish_client = Client(fish)
bird_client = Client(bird)

fish_client.swim_animal() # Expected output: "Swimming"
bird_client.swim_animal() # Raises NotImplementedError
```

In this example, we have an Animal interface that defines three methods: move, eat, and swim. The Fish and Bird classes implement the Animal interface. `The Fish class implements all three methods, while the Bird class implements only move and eat`.

The Client class depends on the Animal interface, but it doesn't require all the methods defined in the interface. `The swim method is not relevant for birds, so it raises a NotImplementedError`.

This violates the Interface Segregation Principle because the `Animal interface is too broad and forces clients to depend on methods they don't need`. In this case, the Bird class is forced to implement a method it doesn't need.

In order to make this principle non-violating, we could create separate interfaces for `Swimmable, Flyable, and Eatable`, and let the clients depend on the specific interfaces they require.


### Example - 2 [ Non-Violation ]

```
from abc import ABC, abstractmethod


class Moveable(ABC):
    @abstractmethod
    def move(self):
        pass


class Eatable(ABC):
    @abstractmethod
    def eat(self):
        pass


class Swimmable(ABC):
    @abstractmethod
    def swim(self):
        pass


class Fish(Moveable, Eatable, Swimmable):
    def move(self):
        print("Swimming")

    def eat(self):
        print("Eating underwater")

    def swim(self):
        print("Swimming")


class Bird(Moveable, Eatable):
    def move(self):
        print("Flying")

    def eat(self):
        print("Eating insects")


class Client:
    def __init__(self, moveable_animal, eatable_animal=None, swimmable_animal=None):
        self.moveable_animal = moveable_animal
        self.eatable_animal = eatable_animal
        self.swimmable_animal = swimmable_animal

    def move_animal(self):
        self.moveable_animal.move()

    def feed_animal(self):
        if self.eatable_animal:
            self.eatable_animal.eat()

    def swim_animal(self):
        if self.swimmable_animal:
            self.swimmable_animal.swim()


# Usage
fish = Fish()
bird = Bird()

fish_client = Client(fish, fish, fish)
bird_client = Client(bird, bird)

fish_client.swim_animal()  # Expected output: "Swimming"
bird_client.swim_animal()  # No output (bird cannot swim)

```
## Dependency Inversion Principle (DIP)

The Dependency Inversion Principle (DIP) is a principle in object-oriented design that states that high-level modules should not depend on low-level modules. Instead, both should depend on abstractions. It promotes decoupling and flexibility in the codebase

### Example - 1 [ Violation ]

```
class PaymentProcessor:
    def process_payment(self, amount):
        print(f"Processing payment of ${amount}")

class PaymentService:
    def __init__(self):
        self.payment_processor = PaymentProcessor()

    def perform_payment(self, amount):
        self.payment_processor.process_payment(amount)

# Usage
payment_service = PaymentService()
payment_service.perform_payment(100)  # Output: "Processing payment of $100"

```

`PaymentService` class directory depends on the `PaymentProcessor`, creating an instance insite its consyructor there by, establishing a strong coupling between the two classes, violating `Dependency Inversion Principle`

### Example - 2 [ Fixing ]

```
from abc import ABC, abstractmethod

class PaymentProcessor(ABC):
    @abstractmethod
    def process_payment(self, amount):
        pass

class CreditCardPaymentProcessor(PaymentProcessor):
    def process_payment(self, amount):
        print(f"processing credit card payment {amount}")

class PaypalPaymentProcessor(PaymentProcessor):
    def process_payment(self, amount):
        print(f"processing paypal payment {amount}")

class PaymentServices:
    def __init__(self, payment_processor):
        self.payment_processor=payment_processor

    def perform_payment(self, amount):
        self.payment_processor.process_payment(amount)

creditcard_processor=CreditCardPaymentProcessor()
paypal_processor=PaypalPaymentProcessor()

payment_service=PaymentServices(creditcard_processor)
payment_service.perform_payment(100)

payment_service=PaymentServices(paypal_processor)
payment_service.perform_payment(200)
```

the `PaymentProcessor` abstract class, which serves as the abstraction that both the `PaymentService` and the concrete payment processors (`CreditCardPaymentProcessor and PayPalPaymentProcessor`) depend on

By introducing the abstraction and decoupling the high-level and low-level modules, we adhere to the Dependency Inversion Principle, promoting flexibility, maintainability, and easier integration of new payment processors in the future