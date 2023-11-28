## Overview

Naming (variables, properties, functions, methods, classes) correctly and in an understandable way if an extremely important part of writing clean code.

Names have one simple purpose: They should describe what's stored in a variable or property or what a function or method does. Or what kind of object will be created when instantiating a class.

**Variables and properties hold data** - numbers, text (strings), boolean values, objects, lists, arrays, maps etc. Hence the name should imply which kind of data is being stored. Therefore, variables and properties should typically receive a **noun as a name**. e.g: user, product, customer, database, transaction etc. 

Alternatively, you could also use a short phrase with an **adjective** - typically for storing boolean values. e.g: isValid, didAuthenticate, isLoggedIn, emailExists

**Functions & Methods**  - Functions and methods can be called to then execute some code. That means that they perform tasks and operations. Therefore, functions and methods should typically receive a verb as a name. e.g: login(), createUser(), database.insert(), log() etc.

Alternatively, functions and methods can also be used to primarily produce values - then, especially when producing booleans, you could also go for short phrases with adjectives. e.g: isValid(...), isEmail(...), isEmpty(...) etc.


**Classes** - Classes are used to create objects (unless it's a static class). Hence the class name should describe the kind of object it will create. Even if it's a static class (i.e. it won't be instantiated), you will still use it as some kind of container for various pieces of data and/ or functionality - so you should then describe that container. 

Good class names - just like good variable and property names - are therefore **nouns**. e.g: User, Product,RootAdministrator, Transaction, Payment etc

## Name Casing

**snake_case** - everything is lowercase and vars seperated by underscore, that includes functions and vars
e.g python

**cameCase** - There is no space and everystart of new char starts with capital letter, that includes functions, methods, and vars
e.g Java, JavaScript

**PascalCase** - Used many prg, used mainly in Classes e.g Python, Java, Javascript

**Kebab-case** - mainly used in HTML prog lang

