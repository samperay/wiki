
## Strings

my_string = "In 2010, someone paid 10k Bitcoin for two pizzas."

```python
print(my_string[-1]) # get the last character in the string.
print(my_string[7]) # return the comma character from the string.
print(my_string.index("B")) # index of the B character in the string.
print(my_string.count('o')) # number of occurrences of the letter o in the string.
print(my_string.upper()) # convert all letters in the string to uppercase.
print(my_string.find('Bitcoin')) # index at which the substring Bitcoin starts.
print(my_string.index('Bitcoin')) # index at which the substring Bitcoin starts.
print(my_string.startswith('X')) # check of the string starts with the letter X
print(my_string.swapcase()) # convert all uppercase letters to lowercase and viceversa
print(my_string.replace(" ", "")) # remove all spaces from the string
print("&".join(my_string)) # join the characters of the string using the & symbol as a delimiter.
print(my_string.title()) # convert the first letter of each word in the string to uppercase.
print(my_string[::7]) # return every 7th character of the string, starting with the first character.
print(my_string[10::]) # return the string except the first 10 characters
print(my_string[:-4]) # return the string except the last 4 characters
print(my_string[-9::]) # return the last 9 characters of the string
print(my_string[:12]) # return the first 12 characters in the string
my_other_string = "Poor guy!"
print(my_string+my_other_string) # concatenate strings
```

## nums_bool

## lists

https://www.programiz.com/python-programming/methods/list

Given the code below, use the correct function on line 3 in order to find out the largest number in my_list.

```python
my_list = [10, 10.5, 20, 30, 25.6, 19.25, 11.01, 29.99]

print(sorted(my_list)) # ascending sort
print(sorted(my_list), reverse=True) # descending sort
print(sorted(my_list)[-1]) # largest element
print(sorted(my_list)[0]) # smallest element
print(sum(my_list)) # sum of elements 
print(my_list.clear()) # delete all elemenents in list
```

- add the elements of [30.01, 30.02, 30.03] to **my_list** and **multiply the resulting list by 2**.

```python
my_list = [10, 10.5, 20, 30, 25.6, 19.25, 11.01, 29.99]
add = (my_list+[30.01, 30.02, 30.03])*2
print(add)
```

- return the element 20 from my_list based on its index.

```python
my_list = [10, 10.5, 20, 30, 'Python', 'Java', 'Ruby']

element = my_list[my_list.index(20)]
or
my_list[2]

print(element)
```

- return a slice made of [30, 'Python', 'Java'] from my_list based on negative indexes.

```python
my_list = [10, 10.5, 20, 30, 'Python', 'Java', 'Ruby']

my_slice = my_list[-4:-2] # [30, 'Python', 'Java']
my_slice=my_list[-4:] # [30, 'Python', 'Java', 'Ruby']
my_slice=my_list[3:] # [30, 'Python', 'Java', 'Ruby']
my_slice=my_list[3:] # [10, 10.5, 20]
my_slice=my_list[:-4] # [10, 10.5, 20]
my_slice = my_list[0:5] # [10, 10.5, 20, 30, 'Python']
my_slice = my_list[0::3] # every 3rd element [10, 30, 'Ruby']
my_slice = my_list[-1::-4] # every 4th element from last element #['Ruby', 20]
```
## sets
my_set = {1, 4, 6, 5, 9, 0, 8, 3, 2, 7, 11}

```python
my_set.add(19) # add element
my_set.remove(19) # delete element
```



```python
my_set1 = {1, 4, 6, 5, 9, 0, 8, 3, 2, 7, 11}
my_set2 = {12, 9, 4, 2, 0, 6}
common = my_set1.intersection(my_set2)  # Common elements 
join = my_set1.union(my_set2) # joining
```

find out the elements of my_set2 that are not members of my_set1.

```
diff = my_set2.difference(my_set1)
```


## tuples

```python
my_tup = ("Romania", "Poland", "Estonia", "Bulgaria", "Slovakia", "Slovenia", "Hungary")

number = my_tup.len(my_tup) # count of tuples
index = my_tup.index('Slovakia') # find out the index of Slovakia in my_tup.
last = max(my_tup) # find out the last element of my_tup in alphabetical order.
number = my_tup.count('Estonia') # find out the number of occurrences of Estonia in my_tup.
my_slice = my_tup[2:] # return all the elements of my_tup, except the first two of them
my_slice = my_tup[-5::] # from negative index, return all the elements of my_tup, except the first two of them

print(number)
```

## ranges

```python
print(list(range(10))) #[0,1,2..10]
print(list(range(0,10)))  #[0,1,2..10]
print(list(range(10,22,3))) # [10, 13, 16, 19] step function increase by 3
my_range = range(115, 125, 5) # return [115, 120] when converted to a list.
my_range = range(-75, -25,15 ) # return [-75, -60, -45, -30] 
my_range = range(-25, 139, 30) # return [-25, 5, 35, 65, 95, 125]
my_range = range(-10,-9) # return [-10]
```

## dictionaries

```python
crypto = {1: "Bitcoin", 2: "Ethereum", 3: "Litecoin", 4: "Stellar", 5: "XRP"}

crypto.pop(3) #  delete the key-value pair associated with key 3
del crypto[3] #  delete the key-value pair associated with key 3
add = sum(crypto) # sum of all the keys in the dictionary.
val = crypto.values() # get a list of all the values in the dictionary.
key = min(crypto) #smallest key in the dictionary.
crypto.popitem() # arbitrary key-value pair from the dictionary.
```

## data types

```python
value = 10
conv = bin(value) # convert value to a binary representation
conv = hex(value) # hexadecimal
conv = int(value,2) # decimal
```

## conditions

write code that prints out True! if x is a string and the first character in the string is T

```python
x = "The days of Python 2 are almost over. Python 3 is the king now."
if type(x)==str and x[0] == 'T':
    print("True!")
```

write code that prints out True! if at least one of the following conditions occurs:
- the string contains the character z
- the string contains the character y at least twice

```
x = "The days of Python 2 are almost over. Python 3 is the king now."

if "z" in x or x.count("y") >= 2:
print("True!")
```

write code that prints out True! if the index of the first occurrence of letter f is less than 10 and prints out False!

```python
x = "The days of Python 2 are almost over. Python 3 is the king now."

if x.index('f') < 10:
    print("True!")
else:
    print("False!")
```

write code that prints out True! if the last 3 characters of the string are all digits and prints out False!

```python
x = "The days of Python 2 are almost over. Python 3 is the king now."
 
if x[-3:].isdigit():
    print("True!")
else:
    print("False!")
```

write code that prints out True! if x has at least 8 elements and the element positioned at index 6 is a floating-point number and prints out False! 

```python
x = [115, 115.9, 116.01, ["length", "width", "height"], 109, 115, 119.5, ["length", "width", "height"]]
 
if len(x) >= 8 and type(x[6]) is float:
    print("True!")
else:
    print("False!")
```

write code that prints out True! if the second string of the first list in x ends with the letter h and the first string of the second list in x also ends with the letter h, and prints out False! 

```python
x = [115, 115.9, 116.01, ["length", "width", "height"], 109, 115, 119.5, ["length", "width", "height"]]
 
if x[3][1].endswith("h") and x[7][0].endswith("h"):
    print("True!")
else:
    print("False!")
```

write code that prints out True! if one of the following two conditions are satisfied and prints out False! otherwise.

- the third string of the first list in x ends with the letter h
- the second string of the second list in x also ends with the letter h

```python
x = [115, 115.9, 116.01, ["length", "width", "height"], 109, 115, 119.5, ["length", "width", "height"]]

if x[3][2].endswith('h') or x[7][1].endswith('h'):
    print("True!")
else:
    print("False!")
```

write code that prints out True! if the largest value among the first 3 elements of the list is less than or equal to the smallest value among the next 3 elements of the list. Otherwise, print out False!

```python
x = [115, 115.9, 116.01, 109, 115, 119.5, ["length", "width", "height"]]
 
if max(x[:3]) <= min(x[3:6]):
    print("True!")
else:
    print("False!")
```

write code that prints out True! if 115 appears at least once inside the list or if it is the first element in the list. Otherwise, print out False!

```python
x = [115, 115.9, 116.01, 109, 115, 119.5, ["length", "width", "height"]]
 
if x.count(115) >= 1 or x.index(115) == 0:
    print("True!")
else:
    print("False!")
```

write code that prints out True! if the value associated with key number 5 is Perl or the number of key-value pairs in the dictionary divided by 5 returns a remainder less than 2. Otherwise, print out False!

```python
x = {1: "Python", 2: "Java", 3: "Javascript", 4: "Ruby", 5: "Perl", 6: "C#", 7: "C++"}
 
if x[5] == "Perl" or len(x) % 5 < 2:
    print("True!")
else:
    print("False!")
```

 write code that prints out True! if 3 is a key in the dictionary and the smallest value (alphabetically) in the dictionary is C#. Otherwise, print out False!

 ```python
 x = {1: "Python", 2: "Java", 3: "Javascript", 4: "Ruby", 5: "Perl", 6: "C#", 7: "C++"}
 
if 3 in x and sorted(x.values())[0] == "C#":
    print("True!")
else:
    print("False!")
 ```

write code that prints out True! if the last character of the largest (alphabetically) value in the dictionary is n. Otherwise, print out False!

```python
x = {1: "Python", 2: "Java", 3: "Javascript", 4: "Ruby", 5: "Perl", 6: "C#", 7: "C++"}
 
if sorted(x.values())[-1][-1] == "n":
    print("True!")
else:
    print("False!")
```

write code that prints out True! if the largest key in the dictionary divided by the second largest key in the dictionary returns a remainder equal to the smallest key in the dictionary. Otherwise, print out False!

```python
x = {1: "Python", 2: "Java", 3: "Javascript", 4: "Ruby", 5: "Perl", 6: "C#", 7: "C++"}
 
if sorted(x.keys())[-1] % sorted(x.keys())[-2] == sorted(x.keys())[0]:
    print("True!")
else:
    print("False!")
```

write code that prints out True! if the sum of all the keys in the dictionary is less than the number of characters of the string obtained by concatenating the values associated with the first 5 keys in the dictionary. Otherwise, print out False!

```python
x = {1: "Python", 2: "Java", 3: "Javascript", 4: "Ruby", 5: "Perl", 6: "C#", 7: "C++"}
 
if sum(x) < len(x[1] + x[2] + x[3] + x[4] + x[5]):
    print("True!")
else:
    print("False!")
```

write code that prints out True! if the 3rd element of the first range is less than 2, prints out False! if the 5th element of the first range is 5, and prints out None! otherwise.

```python
x = [list(range(5)), list(range(5,9)), list(range(1,10,3))]

if x[0][2] < 2:
    print("True!")
elif x[0][4] == 5:
    print("False!")
else:
    print("None!")
```

write code that prints out True! if the 3rd element of the 3rd range is less than 6, prints out False! if the 1st element of the second range is 5, and prints out None! otherwise.

```python
x = [list(range(5)), list(range(5,9)), list(range(1,10,3))]
 
if x[2][2] < 6:
    print("True!")
elif x[1][0] == 5:
    print("False!")
else:
    print("None!")
```

 write code that prints out True! if the last element of the first range is greater than 3, prints out False! if the last element of the second range is less than 9, and prints out None! otherwise.

```python
x = [list(range(5)), list(range(5,9)), list(range(1,10,3))]
 
if x[0][-1] > 3:
    print("True!")
elif x[1][-1] < 9:
    print("False!")
else:
    print("None!")
```

write code that prints out True! if the length of the first range is greater than or equal to 5, prints out False! if the length of the second range is 4, and prints out None! otherwise.

```python
x = [list(range(5)), list(range(5,9)), list(range(1,10,3))]
 
if len(x[0]) >= 5:
    print("True!")
elif len(x[1]) == 4:
    print("False!")
else:
    print("None!")
```

write code that prints out True! if the sum of all the elements of the first range is greater than the sum of all the elements of the third range, prints out False! if the largest element of the second range is greater than the largest element of the third range, and prints out None! otherwise.

```python
x = [list(range(5)), list(range(5,9)), list(range(1,10,3))]
 
if sum(x[0]) > sum(x[2]):
    print("True!")
elif max(x[1]) > max(x[2]):
    print("False!")
else:
    print("None!")
```

write code that prints out True! if the largest element of the first range minus the second element of the 3rd range is equal to the first element of the first range, prints out False! if the length of the first range minus the length of the 2nd range is equal to the first element of the 3rd range, prints out Maybe! if the sum of all the elements of the 3rd range divided by 2 returns a remainder of 0, and prints out None! otherwise.

```python
x = [list(range(5)), list(range(5,9)), list(range(1,10,3))]
 
if max(x[0]) - x[2][1] == x[0][0]:
    print("True!")
elif len(x[0]) - len(x[1]) == x[2][0]:
    print("False!")
elif sum(x[2]) % 2 == 0:
    print("Maybe!")
else:
    print("None!")
```

write code that prints out True! if the sum of the last 3 elements of the first range plus the sum of the last 3 elements of the 3rd range is equal to the sum of the last 3 elements of the 2nd range, and prints out False! if the length of the first range times 2 is less than the sum of all the elements of the 3rd range.

```python
x = [list(range(5)), list(range(5,9)), list(range(1,10,3))]
 
if sum(x[0][-3:]) + sum(x[2][-3:]) == sum(x[1][-3:]):
    print("True!")
elif len(x[0]) * 2 < sum(x[2]):
    print("False!")
```

write code that prints out True! if the 2nd character of the value at key 1 is also present in the value at key 4, and prints out False! otherwise.

```python
x = {1: "Python", 2: "Java", 3: "Javascript", 4: "Ruby", 5: "Perl", 6: "C#", 7: "C++"}
 
if x[1][1] in x[4]:
    print("True!")
else:
    print("False!")
```

write code that prints out True! if the second to last character of the value at key 3 is the first character of the value at key 5, and prints out False! otherwise.

```python
x = {1: "Python", 2: "Java", 3: "Javascript", 4: "Ruby", 5: "Perl", 6: "C#", 7: "C++"}
 
if x[3][-2] == x[5][0]:
    print("True!")
else:
    print("False!")
```

write code that prints out True! if the number of characters of the smallest value in the dictionary is equal to the number of occurrences of letter a in the value at key 3, and prints out False! otherwise.

```python
x = {1: "Python", 2: "Java", 3: "Javascript", 4: "Ruby", 5: "Perl", 6: "C#", 7: "C++"}
 
if len(min(x.values())) == x[3].count("a"):
    print("True!")
else:
    print("False!")
```

## loops

Write a for loop that iterates over the x list and prints out all the elements of the list in reversed order and multiplied by 10.

```python
x = [10, 12, 13, 14, 17, 19, 21, 22, 25]
for i in sorted(x,reverse=True):
    print(i*10)
```

Write a for loop that iterates over the x list and prints out all the elements of the list divided by 2 and the string Great job! after the list is exhausted.

```python
x = [10, 12, 13, 14, 17, 19, 21, 22, 25]
for i in x:
    print(i / 2)
else:
    print("Great job!")
```

Write a for loop that iterates over the x list and prints out the index of each element.

```python
x = [10, 12, 13, 14, 17, 19, 21, 22, 25]

for index,item in enumerate(x):
    print(index)

x = [10, 12, 13, 14, 17, 19, 21, 22, 25]
 
for i in x:
    print(x.index(i))
```

Write a while loop that prints out the value of x squared while x is less than or equal to 5. Be careful not to end up with an infinite loop!

```python
x = 0
 
while x <= 5:
    print(x ** 2)
    x = x + 1
```


Write a while loop that prints out the value of x times 10 while x is less than or equal to 4 and then prints out Done! when x becomes larger than 4. Be careful not to end up with an infinite loop!

```python
x = 0
 
while x <= 4:
    print(x * 10)
    x = x + 1
else:
    print("Done!")
```

Write a while loop that prints out the value of x plus 10 while x is less than or equal to 15 and the remainder of x divided by 5 is 0. Be careful not to end up with an infinite loop!

```python
x = 10
 
while x <= 15 and x % 5 == 0:
    print(x + 10)
    x = x + 1
```

Write a while loop that prints out the absolute value of x while x is negative. Be careful not to end up with an infinite loop!

```python
x = -7
 
while x < 0:
    print(abs(x))
    x = x + 1
```

Write a while loop that prints out the value of x times y while x is greater than or equal to 5 and less than 10, and prints out the result of x divided by y when x becomes 10. Be careful not to end up with an infinite loop!

```python
x = 5
y = 2
 
while x >= 5 and x < 10:
    print(x * y)
    x = x + 1
else:
    print(x / y)
```

Write code that will iterate over the x list and multiply by 10 only the elements that are greater than 20 and print them out to the screen.

Hint: use nesting!

```python
x = [10, 12, 13, 14, 17, 19, 21, 22, 25]
 
for i in x:
    if i > 20:
        print(i * 10)
```

Write code that will iterate over the x and y lists and multiply each element of x with each element of y, also printing the results to the screen.

Hint: use nesting!

```python
x = [2, 4, 6]
y = [5, 10]
 
for i in x:
    for j in y:
        print(i * j)
```

Write code that will iterate over the x and y lists and multiply each element of x with each element of y that is less than 12, also printing the results to the screen.

Hint: use nesting!

```python
x = [2, 4, 6, 8]
y = [5, 10, 15, 20]
 
for i in x:
    for j in y:
        if j < 12:
            print(i * j)
```

Write code that will iterate over the x and y lists and multiply each element of x that is greater than 5 with each element of y that is less than 12, also printing the results to the screen.

Hint: use nesting!

```python
x = [2, 4, 6, 8]
y = [5, 10, 15, 20]
 
for i in x:
    for j in y:
        if i> 5 and j < 12:
            print(i * j)
```

Write code that will iterate over the x and y lists and multiply each element of x with each element of y that is less than or equal to 10, also printing the results to the screen. For y's elements that are greater than 10, multiply each element of x with y squared.

Hint: use nesting!

```python
x = [2, 4, 6, 8]
y = [5, 10, 15, 20]
 
for i in x:
    for j in y:
        if j <= 10:
            print(i * j)
        else:
            print(i * j ** 2)
```

Write code that will print out each character in x doubled if that character is also inside y.

Hint: use nesting!

```python
x = "cryptocurrency"
y = "blockchain"
 
for i in x:
    if i in y:
        print(i * 2)
```

Write code that will iterate over the range generated by range(9) and for each element that is between 3 and 7 inclusively print out the result of multiplying that element by the second element in the same range.

Hint: use nesting!

```python
my_range = range(9)

print(newrange)
for i in my_range:
    if 3 <= i <= 7:
        print(i * my_range[1])
```

Write code that will iterate over the range starting at 1, up to but not including 11, with a step of 2, and for each element that is between 3 and 8 inclusively print out the result of multiplying that element by the last element in the same range. For any other element of the range (outside [3-8]) print Outside!

Hint: use nesting!

```python
for i in range(1,11,2):
    if 3 <= i <= 8:
        print(i * range(1,11,2)[-1])
    else:
        print("Outside!")
```

Write code that will iterate over the range starting at 5, up to but not including 25, with a step of 5, and for each element that is between 10 and 21 inclusively print out the result of multiplying that element by the second to last element of the same range. For any other element of the range (outside [10-21]) print Outside! Finally, after the entire range is exhausted print out The end!

Hint: use nesting!

```python
for i in range(5,25,5):
    if 10 <= i <= 21:
        print(i * range(5,25,5)[-2])
    else:
        print("Outside!")
else:
    print("The end!")
```

Write a while loop that prints out the value of x times 11 while x is less than or equal to 11.  When x becomes equal to 10, print out x is 10! Be careful not to end up with an infinite loop!

```python
x = 5
 
while x <= 11:
    if x == 10:
        print("x is 10!")
        x = x + 1
    else:
        print(x * 11)
        x = x + 1
```

Insert a break statement where necessary in order to obtain the following result:

1
1
100
20
10

```python
x = [1, 2]
y = [10, 100]
 
for i in x:
    for j in y:
        if i % 2 == 0:
            print(i * j)
            break
        print(i)
    print(j)
```

Insert a break statement where necessary in order to obtain the following result:

1
10
20
2
10

```python
x = [1, 2]
y = [10, 100]
 
for i in x:
    for j in y:
        if i % 2 == 0:
            print(i * j)
        print(i)
        break
    print(j)
```

Insert a break statement where necessary in order to obtain the following result:

1
1
100
10


```python
x = [1, 2]
y = [10, 100]
 
for i in x:
    for j in y:
        if i % 2 == 0:
            break
            print(i * j)
        print(i)
    print(j)
```

Insert a continue statement where necessary in order to obtain the following result:

1
1
100
20
200
100

```python
x = [1, 2]
y = [10, 100]
 
for i in x:
    for j in y:
        if i % 2 == 0:
            print(i * j)
            continue
        print(i)
    print(j)
```

Insert a continue statement where necessary in order to obtain the following result:

1
1
100
100

```python
x = [1, 2]
y = [10, 100]
 
for i in x:
    for j in y:
        if i % 2 == 0:
            continue
            print(i * j)
        print(i)
    print(j)
```

## exceptions

Add the necessary clause(s) to the code below so that in case the code under try raises no exceptions then the program prints out the result of the math operation and the string Clean! to the screen.

```python
try:
    print(25 % 5 ** 5 + 5)
except:
    print("Bug!")
else:
    print("Clean!")
```

Add the necessary clause(s) to the code below so that no matter if the code under try raises any exceptions or not, then the program prints out the string Result! to the screen.

```python
try:
    print(25 % 0 ** 5 + 5)
except:
    print("Bug!")
finally:
    print("Result!")
```

Add the necessary clause(s) to the code below so that in case the code under try raises the ZeroDivisionError exception then the program prints out the string Zero! to the screen; additionally, if the code under try raises the IndexError exception then the program prints out the string Index! to the screen.

```python
x = [1, 9, 17, 32]
 
try:
    print(x[3] % 3 ** 5 + x[4])
except ZeroDivisionError:
    print("Zero!")
except IndexError:
    print("Index!")
```

Add the necessary clause(s) to the code below so that in case the code under try raises no exceptions then the program prints out the result of the math operation and the string Clean! to the screen. If the code under try raises the ZeroDivisionError exception then the program prints Zero! to the screen. Ultimately, regardless of the result generated by the code under try, the program should print out Finish! to the screen.

```python
try:
    print(25 % 5 ** 5 + 5)
except ZeroDivisionError:
    print("Zero!")
else:
    print("Clean!")
finally:
```

## functions

Implement a function called my_func() that takes a single parameter x and multiplies it with each element of range(5), also adding each multiplication result to a new (initially empty) list called my_new_list. Finally, the list should be printed out to the screen after the function is called.

```python
def my_func(x):
    my_new_list = []
    for i in range(5):
        my_new_list.append(i * x)
    return my_new_list
 
result = my_func(2)
print(result)
```

Implement a function called my_func() that takes a single parameter x (a tuple) and for each element of the tuple that is greater than 4 it raises that element to the power of 2, also adding it to a new (initially empty) list called my_new_list. Finally, the code returns the result when the function is called.

```python
def my_func(x):
    my_new_list = []
    for i in x:
        if i > 4:
            my_new_list.append(i ** 2)
    return my_new_list
 
result = my_func((2, 3, 5, 6, 4, 8, 9))
print(result)
```

Implement a function called my_func() that takes a single parameter x (a dictionary) and multiplies the number of elements in the dictionary with the largest key in the dictionary, also returning the result when the function is called.

```python
def my_func(x):
    return len(x) * sorted(x.keys())[-1]
 
result = my_func({1: 3, 2: 3, 4: 5, 5: 9, 6: 8, 3: 7, 7: 0})
print(result)
```

Implement a function called my_func() that takes a single positional parameter x and a default parameter y which is equal to 10 and multiplies the two, also returning the result when the function is called.

```python
def my_func(x, y = 10):
    return x * y
 
result = my_func(5)
print(result)
```

Implement a function called my_func() that takes a single positional parameter x and two default parameters y and z which are equal to 100 and 200 respectively, and adds them together, also returning the result when the function is called

```python
def my_func(x, y = 100, z = 200):
    return x + y + z
 
result = my_func(50)
print(result)
```

Implement a function called my_func() that takes two default parameters x (a list) and y (an integer), and returns the element in x positioned at index y, also printing the result to the screen when called.

```python
def my_func(x: list, y:int):
    return x[y]

result = my_func(list(range(2,25,2)), 4)
print(result)
``` 

Implement a function called my_func() that takes a positional parameter x and a variable-length tuple of parameters and returns the result of multiplying x with the second element in the tuple, also returning the result when the function is called.

```python
def my_func(x, *args):
    return x * args[1]
 
result = my_func(5, 10, 20, 30, 50)
print(result)
```

Implement a function called my_func() that takes a positional parameter x and a variable-length dictionary of (keyword) parameters and returns the result of multiplying x with the largest value in the dictionary, also returning the result when the function is called.

```python
def my_func(x, **kwargs):
    return x * sorted(kwargs.values())[-1]
 
result = my_func(10, val1 = 10, val2 = 15, val3 = 20, val4 = 25, val5 = 30)
print(result)
```

Write code that will import only the pi variable from the math module and then it will format it in order to have only 4 digits after the floating point. Of course, print out the result to the screen using the print() function.

```python
from math import pi
 
print("%.4f" % pi)
```

## files

## regular expressions

s = "Bitcoin was born on Jan 3rd 2009 as an alternative to the failure of the current financial system. In 2017, the price of 1 BTC reached $20000, with a market cap of over $300B."

```python
import re
 
result = re.match("Bitcoin", s) # match 'Bitcoin' at start
result = re.match(r"B.{6} .{3}", s) # match 'Bitcoin' using dot syntax
result = re.match("Bitcoin", s, re.I) # match 'Bitcoin' at start of str ignore case
result = re.search(r"(\d{4})\s", s) # match the year `2009`
result = re.search(r"(\d{4}),", s) # search 2017 
result = re.search(r"(.{3}\s\d\w\w\s\d{4})\s", s) # match the date Jan 3rd 2009
result = re.search(r"([A-Z]{3})", s) # match BTC in the string
result = re.search(r"([0-9]\s[A-Z]{3})", s) # match 1 BTC in the string
result = re.search(r"(\$\d{5}),", s) # match $20000
result = re.search(r"(\$\d{3}[A-Z])\.", s) # match $300B
result = re.search(r"\s(.{6} .{3} .{2})\s", s) # match market cap
print(result.group())
```

s = "Bitcoin, Market Cap: $184,073,529,068, Price: $10,259.02, Volume 24h: $15,670,986,269, Circulating Supply: 17,942,600 BTC, Change 24h: 0.10%"

```python
import re

result = re.search(r"\$(\d{3},[0-9]{3},\d{3},[0-9]{3}),", s) #  match 184,073,529,068
result = re.search(r"\$(\d{1,3},\d{1,3}\.\d{1,3}),", s) # match 10,259.02
result = re.search(r"\s([0-9]{2},[0-9]{3},[0-9]{3}\s.{3}),", s) # match 17,942,600 BTC
result = re.search(r"\s(.{4}\s\d\.\d\d%)", s) # match 24h: 0.10%

# match Volume 24h: $15,670,986,269
result = re.search(r"\.\d\d, (.{1,}:\s\$\d{2,},\d{2,},\d{2,},\d{2,}), ", s)

# match Circulating Supply: 17,942,600 BTC 
result = re.search(r"(\w+ \w+: \d{2}.+? [A-Z]{3}), ", s) 

result = re.search(r",([0-9]{3}\.[0-9]{2},\s.)", s) # match 259.02, V 
result = re.findall(r"\s(\d{4})", s) # match all the years
result = re.findall(r"\d{1,}", s) # match all the numbers (3, 2009
result = re.findall(r"\s(\w{3})\s", s) # match all the three-letter words
result = re.findall(r"([A-Z]{1}.+?)\s", s) # match all the words starting with an uppercase letter
result = re.findall(r"\s(o.{1})\s", s) # match all the two-letter words starting with the letter o
result = re.findall(r"\w{8,}", s) # match all the words that have at least 8 characters

# match all the words starting with a or c and that have at least 3 letters
result = re.findall(r"\s([ac]\w{2,})\s", s) 

result = re.sub(r"\s\d{4}", " XXXX", s) # replace all the years in the string with XXXX
print(result.group(1))
```


s = "Bitcoin was born on Jan 3rd 2009 as an alternative to the failure of the current financial system. In 2017, the price of 1 BTC reached $20000, with a market cap of over $300B. Bitcoin, Market Cap: $184,073,529,068, Price: $10,259.02, Volume 24h: $15,670,986,269, Circulating Supply: 17,942,600 BTC, Change 24h: 0.10%"

```python
import re
 
# replace each floating-point number in the string (10,259.02 and 0.10) with a dot (.) 
result = re.sub(r"\d{1,},*\d*\.\d{1,}", ".", s)

# replace all occurrences of BTC in the string with Bitcoin
result = re.sub(r"[A-Z]{3}", "Bitcoin", s)

# replace all the digits less than or equal to 5 in the string with 8
result = re.sub(r"[0-5]", "8", s)

# replace all the words starting with an uppercase letter or digits greater than or equal to 6 in the string with W
result = re.sub(r"[A-Z]\w{1,}|[6-9]", "W", s)
 
print(result)
```

## classes

## other concepts



