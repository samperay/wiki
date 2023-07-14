## List

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

### unpacking

```python
car_ages = [0, 9, 4, 8, 7, 20, 19, 1, 6, 15]
car_ages_descending = sorted(car_ages, reverse=True)
# oldest, second_oldest = car_ages_descending [ Error:  too many values to unpack ] 

oldest = car_ages_descending[0]
second_oldest = car_ages_descending[1]
others = car_ages_descending[2:]

print("Erorr prone way: ",oldest, second_oldest, others) # Error prone, you might change boundaries on one line and forget to update the others.

# Better handling 
oldest, second_oldest, *others = car_ages_descending
print("Without Error way: ",oldest, second_oldest, others)

# You can use others in anyway you wish to..
oldest, *others, youngest = car_ages_descending
print("oldest and youngest: ", oldest, youngest, others)
```

### methods 

**Method	    Description**

append()	add an item to the end of the list
extend()	add all the items of an iterable to the end of the list
insert()	inserts an item at the specified index
remove()	removes item present at the given index
pop()	    returns and removes item present at the given index
clear()	    removes all items from the list
index()	    returns the index of the first matched item
count()	    returns the count of the specified item in the list
sort()	    sort the list in ascending/descending order
reverse()	reverses the item of the list
copy()	    returns the shallow copy of the list

## Tuples

**Advantages of Tuple over List in Python**
Since tuples are quite similar to lists, both of them are used in similar situations.

However, there are certain advantages of implementing a tuple over a list:

- We generally use tuples for heterogeneous (different) data types and lists for homogeneous (similar) data types.
- Since tuples are immutable, iterating through a tuple is faster than with a list. So there is a slight performance boost.
- Tuples that contain immutable elements can be used as a key for a dictionary. With lists, this is not possible.
- If you have data that doesn't change, implementing it as tuple will guarantee that it remains write-protected.


## Set

mixed_set = {'Hello', 101, -2, 'Bye'}

# create an empty set
empty_set = set()

# create an empty dictionary
empty_dictionary = { }

### methods

**Function	Description**

all()	    Returns True if all elements of the set are true (or if the set is empty).
any()	    Returns True if any element of the set is true. If the set is empty, returns False.
enumerate()	Returns an enumerate object. It contains the index and value for all the items of the set as a pair.
len()	    Returns the length (the number of items) in the set.
max()	    Returns the largest item in the set.
min()	    Returns the smallest item in the set.
sorted()	Returns a new sorted list from elements in the set(does not sort the set itself).
sum()	    Returns the sum of all elements in the set.

## Dictionary 

### methods 

**Function	Description**

pop()	    Remove the item with the specified key.
update()	Add or change dictionary items.
clear()	    Remove all the items from the dictionary.
keys()	    Returns all the dictionary's keys.
values()	Returns all the dictionary's values.
get()	    Returns the value of the specified key.
popitem()	Returns the last inserted key and value as a tuple.
copy()	    Returns a copy of the dictionary.

## string 

### methods 

**Methods	        Description**

upper()	        converts the string to uppercase
lower()	        converts the string to lowercase
partition()	    returns a tuple
replace()	    replaces substring inside
find()	        returns the index of first occurrence of substring
rstrip()	    removes trailing characters
split()	        splits string from left
startswith()	checks if string starts with the specified string
isnumeric()	    checks numeric characters
index()	        returns index of substring