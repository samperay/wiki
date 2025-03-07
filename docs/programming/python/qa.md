
# Strings

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
```

**string concatenation**

```python
my_string = "In 2010, someone paid 10k Bitcoin for two pizzas."
my_other_string = "Poor guy!"
print(my_string+my_other_string)
```

## numbers & booleans

## lists

## sets

## tuples

## ranges

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