
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

## lists

```python
# array[start:end:step_count]

a = ['a', 'b', 'c', 'd', 'e', 'f', 'g', 'h']
#i= [ 0 ,  1 ,  2 ,  3 ,  4 ,  5 ,  6 ,  7 ]
#r= [-8 , -7 , -6 , -5 , -4 , -3 , -2 , -1 ]
print('Middle two:  ', a[3:5])
print('All but ends:', a[1:7])
a[:]      # ['a', 'b', 'c', 'd', 'e', 'f', 'g', 'h']
a[:5]     # ['a', 'b', 'c', 'd', 'e']
a[:-1]    # ['a', 'b', 'c', 'd', 'e', 'f', 'g']
a[4:]     #                     ['e', 'f', 'g', 'h']
a[-3:]    #                          ['f', 'g', 'h']
a[2:5]    # ['c', 'd', 'e']
a[2:-1]   # ['c', 'd', 'e', 'f', 'g']
a[-3:-1]  # ['f', 'g']
a[::2]    # ['a','c', 'e', 'g'] # even numbers ::2 means “Select every second item 
          # starting at the beginning.
a[1::2]   # ['b','d', 'f', 'h'] # odd numbers 
a[::-2]   # ['h', 'f', 'd', 'b'] # ::-2 means “Select every second item starting at the 
          # end and moving backward.
a[2::2]     # ['c', 'e', 'g']
a[-2::-2]   # ['g', 'e', 'c', 'a']
a[-2:2:-2]  # ['g', 'e']
a[2:2:-2]   # []
```

Given the code below, use the correct function on line 3 in order to find out the largest number in my_list.

```python
my_list = [10, 10.5, 20, 30, 25.6, 19.25, 11.01, 29.99]

print(sorted(my_list)) # ascending sort
print(sorted(my_list), reverse=True) # descending sort
print(sorted(my_list)[-1]) # largest element
print(sorted(my_list)[0]) # smallest element
print(sum(my_list)) # sum of elements 
print(set(my_list)) # remove duplicates
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
my_slice = my_list[2:5] # consecutive element [20, 30, 'Python']
```

- merge two lists

```python
a = [3, 4, 6, 10, 11, 18]
b = [1, 5, 7, 12, 13, 19, 21]
a.extend(b)

# remove duplicate and merge two lists
sorted(list(set(a+b)))

# print common elemenents
print(set(a)&set(b))
```

- sort list by lengths
```python
newlist=["sunil","kua","kumar","ku","kumaraswamy","ramaswamy","ramaswamykumaraswamy"]

def sort_list_by_length(list):
    list.sort(key=len)
    return list

# revese sort by length
def sort_list_by_length(list):
    list.sort(key=len, reverse=True)
    return list
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

Write a class called ClassOne starting on line 1 containing:

The __init__ method with two parameters p1 and p2. Define the corresponding attributes inside the __init__ method.

A method called square that takes one parameter p3 and prints out the value of p3 squared.


```python
class ClassOne:
    def __init__(self,p1:int, p2:int):
        self.p1=p1
        self.p2=p2
    
    def square(p3:int):
        print(p3**2)

p = ClassOne(1, 2)
print(type(p))
```

Considering the ClassOne class and the p object, write code on line 11 in order to access the p1 attribute for the current instance of the class and print its value to the screen.

```python
class ClassOne(object):
    def __init__(self, p1, p2):
        self.p1 = p1
        self.p2 = p2
    
    def square(self, p3):
        print(p3 ** 2)
 
p = ClassOne(1, 2)
 
print(p.p1)
```

Considering the ClassOne class and the p object, write code on line 11 in order to call the square() method for the current instance of the class using 10 as an argument and print the result to the screen.

```python
class ClassOne(object):
    def __init__(self, p1, p2):
        self.p1 = p1
        self.p2 = p2
    
    def square(self, p3):
        print(p3 ** 2)
 
p = ClassOne(1, 2)
 
p.square(10)
```

Considering the ClassOne class and the p object, write code on line 11 in order to set the value of the p2 attribute to 5 for the current instance of the class, without using a function.

```python
class ClassOne(object):
    def __init__(self, p1, p2):
        self.p1 = p1
        self.p2 = p2
    
    def square(self, p3):
        print(p3 ** 2)
 
p = ClassOne(1, 2)
 
p.p2 = 5
 
print(p.p2)
```

Considering the ClassOne class and the p object, write code on lines 11 and 12 in order to set the value of the p2 attribute to 50 for the current instance of the class using a function, and then get the new value of p2, again using a function, and print it out to the screen as well.

```python
class ClassOne(object):
    def __init__(self, p1, p2):
        self.p1 = p1
        self.p2 = p2
    
    def square(self, p3):
        print(p3 ** 2)
 
p = ClassOne(1, 2)
 
setattr(p, 'p2', 50)
print(getattr(p, 'p2'))
```

Considering the ClassOne class and the p object, write code on line 11 in order to check if p2 is an attribute of p, using a function, also printing the result to the screen.

```python
class ClassOne(object):
    def __init__(self, p1, p2):
        self.p1 = p1
        self.p2 = p2
    
    def square(self, p3):
        print(p3 ** 2)
 
p = ClassOne(1, 2)
 
print(hasattr(p, 'p2'))
```

Considering the ClassOne class and the p object, write code on line 11 to check if p is indeed an instance of the ClassOne class, using a function, also printing the result to the screen.

```python
class ClassOne(object):
    def __init__(self, p1, p2):
        self.p1 = p1
        self.p2 = p2
    
    def square(self, p3):
        print(p3 ** 2)
 
p = ClassOne(1, 2)
 
print(isinstance(p, ClassOne))
```

Considering the ClassOne class, write code starting on line 9 to create a child class called ClassTwo that inherits from ClassOne and also has its own method called times10() that takes a single parameter x and prints out the result of multiplying x by 10.

```python
class ClassOne(object):
    def __init__(self, p1, p2):
        self.p1 = p1
        self.p2 = p2
    
    def square(self, p3):
        print(p3 ** 2)
 
class ClassTwo(ClassOne):
    def times10(self, x):
        print(x * 10)
        
y = ClassTwo(10, 20)
print(y.p1)
```

Considering the ClassOne and ClassTwo classes, where the latter is a child of the former, write code on line 15 in order to call the times10() method from the child class having x equal to 45, also printing the result to the screen

```python
class ClassOne(object):
    def __init__(self, p1, p2):
        self.p1 = p1
        self.p2 = p2
    
    def square(self, p3):
        print(p3 ** 2)
 
class ClassTwo(ClassOne):
    def times10(self, x):
        return x * 10
        
obj = ClassTwo(15, 25)
 
print(obj.times10(45))
```

Considering the ClassOne and ClassTwo classes, write code on line 13 to verify that ClassTwo is indeed a child of ClassOne, also printing the result to the screen.

```python
class ClassOne(object):
    def __init__(self, p1, p2):
        self.p1 = p1
        self.p2 = p2
    
    def square(self, p3):
        print(p3 ** 2)
 
class ClassTwo(ClassOne):
    def times10(self, x):
        return x * 10
        
print(issubclass(ClassTwo, ClassOne))
```

## other concepts

Write a list comprehension on line 1 that will iterate over range(1, 5) and return a list of its elements.

```python
cph = [i for i in range(1, 5)]
print(cph)
```

Write a list comprehension on line 1 that will iterate over range(1, 15, 5) and return a list of its elements squared.

```python
cph = [i**2 for i in range(1,15,5)]
print(cph)
```

Write a list comprehension on line 1 that will iterate over range(5, 25, 3) and return a list of its elements squared only for the elements that are less than or equal to 16.

```python
cph = [i ** 2 for i in range(5, 25, 3) if i <= 16]
 
print(cph)
```

Write a dictionary comprehension on line 1 that will iterate over range(9) and return a dictionary of key-value pairs where the value is equal to the key times 3.

```python
cph = {x: x * 3 for x in range(9)}
 
print(cph)
```

Write a set comprehension on line 1 that will iterate over range(10, 19) and return a set of its elements divided by 2.5.

```python
cph = {x / 2.5 for x in range(10, 19)}
 
print(cph)
```

Write a lambda function on line 1 that takes two parameters x and y and multiplies x with y.

```python
lam = lambda x, y: x * y
 
print(lam(2, 5))
```

Write a lambda function on line 1 that takes a list list1 as a parameter, and multiplies each element of range(1, 5) with each element of list1 using a list comprehension.

```python
lam = lambda list1: [x * y for x in range(1, 5) for y in list1]
 
print(lam([1, 2]))
```

Use the correct function from the itertools module on line 6, in between the parentheses of list(), in order to concatenate list1 and list2.

```python
import itertools
 
list1 = [1, 2, 3]
list2 = [4, 5]
 
result = list(itertools.chain(list1, list2))
 
print(result)
```

Use the correct function from the itertools module with a for loop and a nested if/else block in order to return all the numbers starting at 20 and up to 31 with a step of 2. Be careful not to end up with an infinite loop!

```python
import itertools
 
for i in itertools.count(20, 2):
    if i < 31:
        print(i)
    else:
        break
```

Use the correct function from the itertools module on line 5, in between the parentheses of list(), in order to return the elements for which the lambda function given as an argument returns False.

```python
import itertools
 
lam = lambda x: x < 5
 
result = list(itertools.filterfalse(lam, range(10)))
 
print(result)
```

## interview essentials

**factorial**

```python
def fact(n):
	if n==1: return 1 
	
	result=n*fact(n-1)
	return result

print(fact(5)) # 120
```

**fibonacci series**

```python
def fib(n):
    sum=0
    a,b=0,1 
    while a<n:
        sum+=a
        print(a, end=" ")
        a,b=b,a+b
    print()
    print("sum of fibonacci numbers:", sum)

fib(90) # 0 1 1 2 3 5 8 13 21 34 55 89 

# Print fibonacci numbers using recurrsion

def fib(n):
    if n == 0:
        return 0
    elif n == 1:
        return 1
    else:
        return (fib(n-1) + fib(n-2))

print(fib(6)) # 8
```

**sum of fibonacci numbers**

```python
def fib(n):
    if n <= 1:
        return n
    else:
        return fib(n-1) + fib(n-2)

print(fib(10))
```

**string reverse**

```python
string1="Sunil"
print(string1[::-1])

# traditional method

revlist=[]
n=len(string1)-1
i=n
while i>=0 : 
    revlist.append(string1[i])
    i-=1
print("".join(revlist))
```

**reverse sentence**
```python
ss="This is sunil"
print(" ".join(ss.split()[::-1]))
```

**Palindrome**
```python
string="mom"
print("True") if string == string[::-1] else print("False")
```
**word frequency**
```python
ss = """Nory was a Catholic because her mother was a Catholic, 
and Nory's mother was a Catholic because her father was a Catholic, 
and her father was a Catholic because his mother was a Catholic, 
or had been."""

d={}

for eachword in ss.split():
    d[eachword]=d.get(eachword,0)+1 

print(d)
```

**digit frequency**
```python
L = [1,2,4,8,16,32,64,128,256,512,1024,32768,65536,4294967296]

# {1: [1, 2, 4, 8], 2: [16, 32, 64], 3: [128, 256, 512], 4: [1024], 5: [32768, 65536], 10: [4294967296]}

from collections import defaultdict 
d1=defaultdict(list)

for i in L:
	d1[len(str(i))].append(i)
print(dict(d1))
```

**list element frequency**
```python 
l = [ 10, 20, 30, 40, 50, 50, 60,20,40, 40, 20,20]

d={}

for eachitem in l:
	d[eachitem]=d.get(eachitem,0)+1

print(d) # {10: 1, 20: 4, 30: 1, 40: 3, 50: 2, 60: 1}
```

**anagams**
```python
def is_anagram(str1, str2):
    """a word, phrase, or name formed by rearranging the letters of another, such as cinema, formed from iceman."""
    if len(str1) != len(str2):
        return False
    else:
        return sorted(str1) == sorted(str2)

print(is_anagram("sunil","linus")) # True
```

**prime numbers**

```python
def is_prime(num):
    if num > 1:
        for i in range(2, num):
            if (num % i) == 0:
                print(num, "is not a prime number")
                print(i, "times", num // i, "is", num)
                break
        else:
            print(num, "is a prime number")

```

**max product in array**

```python
def max_product(arr):
    max_product = 0
    for i in range(len(arr)):
        for j in range(i + 1, len(arr)):
            if arr[i] * arr[j] > max_product:
                max_product = arr[i] * arr[j]
    return max_product

print(max_product([5, 20, 2, 6])) # 120
```

**revese digit**
```python
def reverse(x):
    rev = 0
    while x > 0:
        rev = rev * 10 + x % 10
        x //= 10
    return rev
print(reverse(1234))
```

**sum digit**

```python
num=123
sum=0

for i in str(num):
    sum+=int(i)
print(sum)
```

**sum of even/odd numbers**

```python
print("even numbers sum:",sum(list(range(0,50,2))))
print("odd numbers sum:"sum(list(range(1,50,1))))

even_nums=0
for i in list(range(0,50,2)):
    even_nums+=i
print(even_nums)
```

**Count vovels**

```python
from collections import Counter

def count_each_vowel():
    s= "I am goinf outside for lunch. will be back by another thirty minutes"
    vowels = "aeiouAEIOU"
    vowel_counts = Counter(char for char in s if char in vowels)
    print(vowel_counts)


count_each_vowel()
```

## Builtins

### string

```python
capitalize()	Converts the first character to upper case
casefold()	    Converts string into lower case
center()	    Returns a centered string
count()	        Returns the number of times a specified value occurs in a string
encode()	    Returns an encoded version of the string
endswith()	    Returns true if the string ends with the specified value
expandtabs()	Sets the tab size of the string
find()	        Searches the string for a specified value and returns the position of where it was found
format()	    Formats specified values in a string
format_map()	Formats specified values in a string
index()	        Searches the string for a specified value and returns the position of where it was found
isalnum()	    Returns True if all characters in the string are alphanumeric
isalpha()	    Returns True if all characters in the string are in the alphabet
isascii()	    Returns True if all characters in the string are ascii characters
isdecimal()	    Returns True if all characters in the string are decimals
isdigit()	    Returns True if all characters in the string are digits
isidentifier()	Returns True if the string is an identifier
islower()	    Returns True if all characters in the string are lower case
isnumeric()	    Returns True if all characters in the string are numeric
isprintable()	Returns True if all characters in the string are printable
isspace()	    Returns True if all characters in the string are whitespaces
istitle()	    Returns True if the string follows the rules of a title
isupper()	    Returns True if all characters in the string are upper case
join()	        Converts the elements of an iterable into a string
ljust()	        Returns a left justified version of the string
lower()	        Converts a string into lower case
lstrip()	    Returns a left trim version of the string
maketrans()	    Returns a translation table to be used in translations
partition()	    Returns a tuple where the string is parted into three parts
replace()	    Returns a string where a specified value is replaced with a specified value
rfind()	        Searches the string for a specified value and returns the last position of where it was found
rindex()	    Searches the string for a specified value and returns the last position of where it was found
rjust()	        Returns a right justified version of the string
rpartition()    Returns a tuple where the string is parted into three parts
rsplit()	    Splits the string at the specified separator, and returns a list
rstrip()	    Returns a right trim version of the string
split()	        Splits the string at the specified separator, and returns a list
splitlines()    Splits the string at line breaks and returns a list
startswith()    Returns true if the string starts with the specified value
strip()	        Returns a trimmed version of the string
swapcase()	    Swaps cases, lower case becomes upper case and vice versa
title()	        Converts the first character of each word to upper case
translate()	    Returns a translated string
upper()	        Converts a string into upper case
zfill()	        Fills the string with a specified number of 0 values at the beginning
```

### list 

```python
append()	Adds an element at the end of the list
clear()	    Removes all the elements from the list
copy()	    Returns a copy of the list
count()	    Returns the number of elements with the specified value
extend()	Add the elements of a list (or any iterable), to the end of the current list
index()	    Returns the index of the first element with the specified value
insert()	Adds an element at the specified position
pop()	    Removes the element at the specified position
remove()	Removes the first item with the specified value
reverse()	Reverses the order of the list
sort()	    Sorts the list
```

### dictionary 

```python
clear()	    Removes all the elements from the dictionary
copy()	    Returns a copy of the dictionary
fromkeys()	Returns a dictionary with the specified keys and value
get()	    Returns the value of the specified key
items()	    Returns a list containing a tuple for each key value pair
keys()	    Returns a list containing the dictionary's keys
pop()	    Removes the element with the specified key
popitem()	Removes the last inserted key-value pair
setdefault() Returns the value of the specified key.If the key does not exist: insert the key, with the specified value
update()	Updates the dictionary with the specified key-value pairs
values()	Returns a list of all the values in the dictionary
```

### tuple 

```python
count()   Returns the number of times a specified value occurs in a tuple
index()   Searches the tuple for a specified value and returns the position of where it was found 
```

### set 

```python
add()	        Adds an element to the set
clear()	        Removes all the elements from the set
copy()	        Returns a copy of the set
difference()	Returns a set containing the difference between two or more sets
difference_update()	Removes the items in this set that are also included in another, specified set
discard()	    Remove the specified item
intersection()	Returns a set, that is the intersection of two or more sets
intersection_update()	Removes the items in this set that are not present in other, specified set(s)
isdisjoint()	Returns whether two sets have a intersection or not
issubset()	    Returns whether another set contains this set or not
issuperset()	Returns whether this set contains another set or not
pop()	        Removes an element from the set
remove()	    Removes the specified element
symmetric_difference()	Returns a set with the symmetric differences of two sets
symmetric_difference_update()	inserts the symmetric differences from this set and another
union()	        Return a set containing the union of sets
update()	    Update the set with another set, or any other iterable
```

### files

```python
close()	        Closes the file
detach()	    Returns the separated raw stream from the buffer
fileno()	    Returns a number that represents the stream, from the operating system's perspective
flush() 	    Flushes the internal buffer
isatty()	    Returns whether the file stream is interactive or not
read()	        Returns the file content
readable()	    Returns whether the file stream can be read or not
readline()	    Returns one line from the file
readlines()	    Returns a list of lines from the file
seek()	        Change the file position
seekable()	    Returns whether the file allows us to change the file position
tell()	        Returns the current file position
truncate()	    Resizes the file to a specified size
writable()	    Returns whether the file can be written to or not
write()	        Writes the specified string to the file
writelines()	Writes a list of strings to the file
```

### other
```python
abs()	    Returns the absolute value of a number
all()	    Returns True if all items in an iterable object are true
any()	    Returns True if any item in an iterable object is true
ascii()	    Returns a readable version of an object. Replaces none-ascii characters with escape character
bin()	    Returns the binary version of a number
bool()	    Returns the boolean value of the specified object
bytearray()	Returns an array of bytes
bytes()	    Returns a bytes object
callable()	Returns True if the specified object is callable, otherwise False
chr()	    Returns a character from the specified Unicode code.
classmethod()	Converts a method into a class method
compile()	Returns the specified source as an object, ready to be executed
complex()	Returns a complex number
delattr()	Deletes the specified attribute (property or method) from the specified object
dict()	    Returns a dictionary (Array)
dir()	    Returns a list of the specified object's properties and methods
divmod()	Returns the quotient and the remainder when argument1 is divided by argument2
enumerate()	Takes a collection (e.g. a tuple) and returns it as an enumerate object
eval()	    Evaluates and executes an expression
exec()	    Executes the specified code (or object)
filter()	Use a filter function to exclude items in an iterable object
float()	    Returns a floating point number
format()	Formats a specified value
frozenset()	Returns a frozenset object
getattr()	Returns the value of the specified attribute (property or method)
globals()	Returns the current global symbol table as a dictionary
hasattr()	Returns True if the specified object has the specified attribute (property/method)
hash()	    Returns the hash value of a specified object
help()	    Executes the built-in help system
hex()	    Converts a number into a hexadecimal value
id()	    Returns the id of an object
input()	    Allowing user input
int()	    Returns an integer number
isinstance()	Returns True if a specified object is an instance of a specified object
issubclass()	Returns True if a specified class is a subclass of a specified object
iter()	    Returns an iterator object
len()	    Returns the length of an object
list()	    Returns a list
locals()	Returns an updated dictionary of the current local symbol table
map()	    Returns the specified iterator with the specified function applied to each item
max()	    Returns the largest item in an iterable
memoryview()	Returns a memory view object
min()	    Returns the smallest item in an iterable
next()	    Returns the next item in an iterable
object()	Returns a new object
oct()	    Converts a number into an octal
open()	    Opens a file and returns a file object
ord()	    Convert an integer representing the Unicode of the specified character
pow()	    Returns the value of x to the power of y
print()	    Prints to the standard output device
property()	Gets, sets, deletes a property
range()	    Returns a sequence of numbers, starting from 0 and increments by 1 (by default)
repr()	    Returns a readable version of an object
reversed()	Returns a reversed iterator
round()	    Rounds a numbers
set()	    Returns a new set object
setattr()	Sets an attribute (property/method) of an object
slice()	    Returns a slice object
sorted()	Returns a sorted list
staticmethod()	Converts a method into a static method
str()	    Returns a string object
sum()	    Sums the items of an iterator
super()	    Returns an object that represents the parent class
tuple()	    Returns a tuple
type()	    Returns the type of an object
vars()	    Returns the __dict__ property of an object
zip()	    Returns an iterator, from two or more iterators
```

### counter

```python
Counter(elements)	Creates a Counter object from an iterable or a dictionary.
.most_common([n])	Returns the n most common elements as a list of tuples. If n is omitted, returns all elements.
.elements()	Returns an iterator over elements, repeating each as per its count.
.subtract(iterable or mapping)	Subtracts counts from another iterable or mapping.
.update(iterable or mapping)	Adds counts from another iterable or mapping.
.clear()	Removes all elements from the Counter.
.copy()	Returns a shallow copy of the Counter.
.keys()	Returns a list of unique elements (like a dictionary).
.values()	Returns a list of counts corresponding to the elements.
.items()	Returns a list of (element, count) pairs.
.total()	Returns the sum of all counts (Python 3.10+).
+Counter	Adds two Counters, summing up counts for common elements.
-Counter	Subtracts counts, keeping only positive counts.
&Counter	Returns the intersection (min counts) of two Counters.
```

## TODO

### Practical Questions
- what is the use of yield and why should we use them ?
- What is the use of map, filter and reduce ? can you provide some examples ?
- Why do we need to use lambda and how can we use them ?
- what is dictionary comprehension, provide me with an example ?
- Given a string, how would you remove the list of whitespaces from it and create a new string ?
- what's the difference between append, extend and concatenate ?
- find the first non-repeated character in a string.
- count the number of words in a string.
- find the maximum subarray sum in a given list of integers.
- check if a given string contains only digits.
- check if a given string is a valid email address.
- generate all possible permutations of a given string.
- convert a decimal number to binary.
- convert a binary number to decimal.
- check if a given number is a perfect square.
- check if a given number is an Armstrong number.
- find the longest common prefix among a list of strings.
- find the longest common suffix among a list of strings.
- find the first non-repeating character in a list.
- find the first repeating character in a list.
- remove all whitespace characters from a string.
- implement a Caesar cipher.
- find the number of occurrences of a substring in a given string.
- find the index of the first occurrence of a substring in a given string.
- count the number of lines in a file.
- count the number of words in a file.
- count the number of characters in a file.
- check if a given string is a valid IP address.
- check if a given string is a valid URL.
- find the most common element in a list.

## Data Structures

### Single linked list

### Double linked list

### Stacks & Queues

### Trees

### Hash tables

### Graphs

### Heaps

### Recursions

### Sorting

### Other coding exercises