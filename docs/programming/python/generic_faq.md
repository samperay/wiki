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
    a,b=0,1 
    while a<n:
        print(a, end=" ")
        a,b=b,a+b
    print()

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

