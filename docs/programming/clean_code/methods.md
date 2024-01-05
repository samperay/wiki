
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

