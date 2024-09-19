## string inverse

```
string1="Sunil"
print(string1[::-1])

OR

revlist=[]
n=len(string1)-1
i=n
while i>=0 : 
    revlist.append(string1[i])
    i-=1
print("".join(revlist))
``` 

## verify palindrome

```
def palindrome(string: str):
	rev = string[::-1]
	return True if string == rev else False

if palindrome("mom"):
	print("Yes, its palindrome")
else:
	print("No, its not palindrome")
```

## first non-repeated char in str

```python
string = "geekforgeeks"

d={}

for eachword in string:
	d[eachword]=d.get(eachword,0)+1

for k,v in d.items():
	if v==1:
		print(k,v)
		break
```

## largest and second largest

```python
a = [100,2,3,4,5,99]

print(f"Largest element in an array: {sorted(a)[-1]}")
print(f"Second largest element in an array: {sorted(a)[-2]}")
print(f"smallest element in an array: {sorted(a)[0]}")
```

## merge two lists 

```python
a = [3, 4, 6, 10, 11, 18]
b = [1, 5, 7, 12, 13, 19, 21]
a.extend(b)
```

## remove dups merge two listed in sort

```
a = [3, 4, 6, 10, 11, 18,5,7,13]
b = [33,1, 5, 7, 12, 13, 19, 21]

sorted(list(set(a+b)))
```

## word frequency

```python
ss = """Nory was a Catholic because her mother was a Catholic, 
and Nory's mother was a Catholic because her father was a Catholic, 
and her father was a Catholic because his mother was a Catholic, 
or had been."""

d={}

for eachword in ss.split():
    # let's initialize eachword of the string to 0 initially and 
    # then get the word from the dictionary to increment by one.

    d[eackword]=d.get(eachword,0)+1 

print(d)
```

## dict of list

```python
ss={'Belaguam': 'karnataka', "hubbali": "karnataka", "hyderbad": "telengana", "nizam": "telengana", "tirupathi": "andhra", "chittor": "andhra"}

# {'karnataka': ['Belaguam', 'hubbali'], 'telengana': ['hyderbad', 'nizam'], 'andhra': ['tirupathi', 'chittor']}

from collections import defaultdict 
d1=defaultdict(list)

for k,v in ss.items():
	d1[v].append(k)

print(dict(d1))
```

## frequency of digits

```python
L = [1,2,4,8,16,32,64,128,256,512,1024,32768,65536,4294967296]

# {1: [1, 2, 4, 8], 2: [16, 32, 64], 3: [128, 256, 512], 4: [1024], 5: [32768, 65536], 10: [4294967296]}

from collections import defaultdict 
d1=defaultdict(list)

for i in L:
	d1[len(str(i))].append(i)
print(dict(d1))
```

## frequency of elements in a list.

```python 
l = [ 10, 20, 30, 40, 50, 50, 60,20,40, 40, 20,20]

d={}

for eachitem in l:
	d[eachitem]=d.get(eachitem,0)+1

print(d) # {10: 1, 20: 4, 30: 1, 40: 3, 50: 2, 60: 1}
```

## factorial 

```python
def fact(n):
	if n==1: return 1 
	
	result=n*fact(n-1)
	return result

print(fact(5)) # 120
```

## Fibonacci series 

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
```

## remove non-alphanumeric char

```python
import re
def strip_non_alphanum(string):
    return re.sub(r'\W+', '', string)

print(strip_non_alphanum("sunil@skjd878@@#@#!!@##@#@#_-;;';--")) #sunilskjd878_
```

## Power(2)
```python
def is_power_of_two(n):
    """Check if a number is a power of two."""
    return (n != 0) and (n & (n - 1) == 0)

print(is_power_of_two(16)) # True
```

## Reverse words in a sentence.

```python
ss="This is sunil"
print(" ".join(ss.split()[::-1]))
```

## Anagrams
```python
def is_anagram(str1, str2):
    """a word, phrase, or name formed by rearranging the letters of another, such as cinema, formed from iceman."""
    if len(str1) != len(str2):
        return False
    else:
        return sorted(str1) == sorted(str2)

print(is_anagram("sunil","linus")) # True
```

## Common element list

```python
a=[1,2,43,45,23,90]
b=[56,43,23,88]

print(set(a)) # Removes duplicates 
print(set(a)&set(b)) # prints common elements
```

## Sort a list(str) based on their lengths.
```python
def sort_list_by_length(list):
    list.sort(key=len)
    return list

newlist=["sunil","kua","kumar","ku","kumaraswamy","ramaswamy","ramaswamykumaraswamy"]

print(sort_list_by_length(newlist)) #['ku', 'kua', 'sunil', 'kumar', 'ramaswamy', 'kumaraswamy', 'ramaswamykumaraswamy']

# reverse order
def sort_list_by_length(list):
    list.sort(key=len, reverse=True)
    return list

newlist=["sunil","kua","kumar","ku","kumaraswamy","ramaswamy","ramaswamykumaraswamy"]

print(sort_list_by_length(newlist)) # ['ramaswamykumaraswamy', 'kumaraswamy', 'ramaswamy', 'sunil', 'kumar', 'kua', 'ku']
```

## prime number 

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

## find nth fibonacci number 

```python
# 0,1,1,2,3,5,8,13,21,34,55,89,144,233,377
def fib(n):
    if n == 0:
        return 0
    elif n == 1:
        return 1
    else:
        return (fib(n-1) + fib(n-2))

print(fib(6)) # 8
```

## sum of all fibonacci numbers 
```python
def fib(n):
    if n <= 1:
        return n
    else:
        return fib(n-1) + fib(n-2)

print(fib(10))
```

## max product in an array

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

## reverse digit 

```python
def reverse(x):
    rev = 0
    while x > 0:
        rev = rev * 10 + x % 10
        x //= 10
    return rev
```

## merge and sort the 2 lists to 1 list

## calculate sum of odd/even numbers

## sum digits

```python
num=123
sum=0

for i in str(num):
    sum+=int(i)
print(sum)
```

## string of numbers

```python
strnum=[]
for i in range(1,100):
    strnum.append(str(i))

print(strnum)
```

## fetch consecutive element in list

```python
print("update the code here)
```

## TODO

## Practical Questions
- what is the use of yield and why should we use them ?
- Can you explain about the **args** and **args**
- What is the use of map, filter and reduce ? can you provide some examples ?
- Why do we need to use lambda and how can we use them ?

- what is list comprehension and provide me an example ?
- what is dictionary comprehension, provide me with an example ?
- Find the sum of all the numbers from 1 to 50 ?
- Can you print the string in reverse order using **iterative** && **recursive** method ?
- Find the factorial of the number using both **iterative** && **recursive** method ?
- Find the Fibonacci numbers using **iterative** && **recursive** method ?
- Can you provide me an example of **terenary** operator ?
- Given a number, how would you reverse a number ?
- Find out the sum of even/odd numbers using **filter**, **map** ?
- Remove the duplicate elements in a list ?
- Given a string, how would you remove the list of whitespaces from it and create a new string ?
- Print the index from the given list ?
- How do you create tuples from list/dictionary ?
- what's the difference between append, extend and concatenate ?
- Find the max/min element in a list ?
- How do you join elements of two lists ?
- Find the common elements of the two lists ?
- Given the list can you find the reverse of it ?
- Given the string, convert to Upper/Lower case ?
- Write a function which searches a particular work from the file ?

## More questions 
- calculate the factorial of a number.
- check if a given number is prime or not.
- find the largest element in a list.
- check if two strings are anagrams.
- reverse a string.
- find the sum of all the elements in a list.
- find the second largest element in a list.
- remove duplicates from a list.
- check if a given string is a palindrome.
- sort a list in descending order.
- find the sum of digits in a number.
- find the smallest element in a list.
- merge two sorted lists into a single sorted list.
- remove all occurrences of an element from a list.
- find the length of a string.
- find the first non-repeated character in a string.
- find the greatest common divisor (GCD) of two numbers.
- find the least common multiple (LCM) of two numbers.
- count the number of vowels in a string.
- count the number of words in a string.
- find the maximum subarray sum in a given list of integers.
- check if a given string contains only digits.
- check if a given string is a valid email address.
- generate all possible permutations of a given string.
- find the median of a list of numbers.
- convert a decimal number to binary.
- convert a binary number to decimal.
- check if a given number is a perfect square.
- check if a given number is an Armstrong number.
- find the largest palindrome made from the product of two n-digit numbers.
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
- implement a binary search algorithm.
- implement a bubble sort algorithm.
- implement a selection sort algorithm.

## more questions

- find the sum of digits of a number.
- check whether a given number is prime or not.
- find the largest number among three numbers.
- find the factorial of a number.
- reverse a string.
- check whether a given string is a palindrome or not.
- remove duplicate elements from a list.
- find the second largest number in a list.
- sort a list of numbers in ascending order.
- find the sum of all even numbers in a list.
- find the greatest common divisor (GCD) of two numbers.
- find the least common multiple (LCM) of two numbers.
- count the number of vowels in a string.
- count the frequency of each element in a list.
- find the square root of a number.
- generate all prime numbers between two given numbers.
- find the sum of all odd numbers in a list.
- find the length of the longest increasing subsequence in a list of integers.
- check whether a given string is a valid palindrome permutation.
- find the maximum sum subarray of a given array of integers.
- find the frequency of each word in a given string.
- count the number of occurrences of a given substring in a string.
- find the first non-repeating character in a given string.
- implement binary search on a sorted list.
- implement bubble sort.
- implement selection sort.
- implement insertion sort.
- implement merge sort.
- implement quick sort.
- find the sum of all elements in a two-dimensional array.
- implement matrix multiplication.
- find the transpose of a matrix.
- find the determinant of a matrix.
- check whether a given matrix is symmetric or not.
- find the maximum element in a two-dimensional array.
- find the minimum element in a two-dimensional array.
- implement linear search.
- find the sum of digits of a given number using recursion.
- find the factorial of a given number using recursion.
- find the nth Fibonacci number using recursion.
- find the GCD of two numbers using recursion.
- find the LCM of two numbers using recursion.
- reverse a linked list.
- implement a stack using an array.
- implement a queue using an array.
- implement a binary search tree.
- implement depth-first search (DFS) on a graph.
- implement breadth-first search (BFS) on a graph.
- find the shortest path between two nodes in a graph using Dijkstra's algorithm.
- find the minimum spanning tree of a graph using K- 