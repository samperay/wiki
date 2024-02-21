
# function

## minimize paramters

when you are writing the function, you need to **minimize the number of parameters**.

None parameter -> best possible option 

1 parameters -> very good possible option i.e log(message), sqr(x) ..etc 

2 parameters -> use with caution e.g point(2,3), login(email, password) ..etc

3 parameters -> avoid if possible

greater than 3 paramters -> always avoid. 

let's say if you don't want to use any of the paramters, then you would create an blueprint of the class object and write methods into it. then you can simply call the function, without any object.. BTW, clean code means ..

1. should be readable and meaningful
2. should reduce cognitive load
3. shoud be concise to the point
4. should avoid unintuitive names, complex nesting and big blocks.
5. should follow common best practices and patterns. 
6. should be fun to write and maintain code. 

if you have too many values, then try to add key:value pair in the functions and then use it. 

example

```
@dataclass
class Compare
    x:int
    y:int

    def small(self):
        if self.x < self.y: return self.x
        else: return self.y

    def big(self):
        if self.x > self.y: return self.x
        else: return self.y

operators=Compare(x=10,y=12)

print("small", operators.small())
print("big", operators.big())
```

Functions should be small and should do exactly one thing. 

## abstractions

There are two levels i.e 

**high level**  - functions which we write and there is no room for interpretation. 
e.g isEmail(email), userExists(username) etc

**low level** - these are low level API or built-in but the intrepation must be added.. 
e.g username.split("@") list_of_user.append(username) .. etc

Do not mix levels of abstrations, we must **split the the functions** if they are doing multiple works. 

so when do we need to split the functions ?

- Extract the code that works on the same functionality (do-not-repeat)
- Extract the code that requires more interpretation than the surrounding code
- Split functions reasonable

How would you make decision and don't split 
- you are jusy renaming the function 
- finding the new function will take longer than reading the extracted code 
- can't produce a reasonable name for the extracted function. 

**Pure function**

the same input always yeilds same output. it means they are predictable. 
no side effects.

```python
def genId(username):
    return f"id-{username}"
```

A function that just not only changes input/output but changes the overall system/program state. 

```python
def create_user(username):
    newuser = CreateUser(username)

    # inpure function
    startsession(newuser) # side effect is not bad, but can be avoided
    return newuser
```







