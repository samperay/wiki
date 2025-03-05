
## 1

Given the code below, insert the correct negative index on line 3 in order to get the last character in the string.

```python
my_string = "In 2010, someone paid 10k Bitcoin for two pizzas."
print(my_string[-1])
```

## 2

Given the code below, insert the correct positive index on line 3 in order to return the comma character from the string.

```python
my_string = "In 2010, someone paid 10k Bitcoin for two pizzas."
print(my_string[7])
```

## 3

Given the code below, insert the correct method on line 3 in order to return the index of the B character in the string.

```python
my_string = "In 2010, someone paid 10k Bitcoin for two pizzas."
print(my_string.index("B"))
```

## 4

Given the code below, insert the correct method on line 3 in order to return the number of occurrences of the letter o in the string.

```python
my_string = "In 2010, someone paid 10k Bitcoin for two pizzas."
print(my_string.count('o'))
```

## 6

Given the code below, insert the correct method on line 3 in order to convert all letters in the string to uppercase.

```python
my_string = "In 2010, someone paid 10k Bitcoin for two pizzas."
print(my_string.upper())
```

## 7

Given the code below, insert the correct method on line 3 in order to get the index at which the substring Bitcoin starts.

```python
my_string = "In 2010, someone paid 10k Bitcoin for two pizzas."
print(my_string.find('Bitcoin')) or print(my_string.index('Bitcoin'))
```

## 8 

Given the code below, insert the correct method on line 3 in order to check of the string starts with the letter X.

```python
my_string = "In 2010, someone paid 10k Bitcoin for two pizzas."
print(my_string.startswith('X'))
```

## 9
Given the code below, insert the correct method on line 3 in order to convert all uppercase letters to lowercase and all lowercase letters to uppercase.


```python
my_string = "In 2010, someone paid 10k Bitcoin for two pizzas."
print(my_string.swapcase())
```

## 10

Given the code below, insert the correct method on line 3 in order to remove all spaces (single Space characters from the keyboard) from the string.

```python
my_string = "In 2010, someone paid 10k Bitcoin for two pizzas."
print(my_string.replace(" ", ""))
```

## 11

Given the code below, insert the correct method on line 3 in order to join the characters of the string using the & symbol as a delimiter.

```python
my_string = "In 2010, someone paid 10k Bitcoin for two pizzas."
print("&".join(my_string))
```
## 183

Implement a function called my_func() that takes two default parameters x (a list) and y (an integer), and returns the element in x positioned at index y, also printing the result to the screen when called.

```python
def my_func(x: list, y:int):
    return x[y]

result = my_func(list(range(2,25,2)), 4)
print(result)
```