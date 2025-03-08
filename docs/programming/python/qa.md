
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

## data types

## conditions

## loops

## exceptions

## functions

## files

## regular expressions

## classes

## other concepts



## 183

Implement a function called my_func() that takes two default parameters x (a list) and y (an integer), and returns the element in x positioned at index y, also printing the result to the screen when called.

```python
def my_func(x: list, y:int):
    return x[y]

result = my_func(list(range(2,25,2)), 4)
print(result)
``` 