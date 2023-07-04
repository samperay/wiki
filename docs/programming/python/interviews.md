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

## Reverse words order in a sentence.

```python
ss="This is sunil"
print(" ".join(ss.split()[::-1]))
```

- Check if a number is prime.
- Check if two strings are anagrams.
- Find the common elements between two lists.
- Find the missing number in an array of consecutive numbers.
- Remove duplicates from a list.
- Check if a linked list has a cycle.
- Reverse a linked list.
- Implement a stack using a list.
- Implement a queue using two stacks.
- Implement a binary search algorithm.
- Find the largest sum of contiguous subarray in an array.
- Find the median of two sorted arrays.
- Implement a binary tree and perform a preorder traversal.
- Find the longest common prefix in a list of strings.
- Sort a list of strings based on their lengths.
- Implement a depth-first search algorithm.
- Implement a breadth-first search algorithm.
- Find the nth Fibonacci number.
- Calculate the square root of a number.
- Find the maximum sum of a path in a binary tree.
- Implement a merge sort algorithm.
- Check if a binary tree is symmetric.

- Implement a hash table.
- Find the kth largest element in an unsorted array.
- Find the longest increasing subsequence in an array.
- Check if a binary tree is a binary search tree.
- Implement a depth-first search on a graph.
- Implement a breadth-first search on a graph.
- Calculate the factorial of a large number using dynamic programming.
- Implement the insertion sort algorithm.
- Find the maximum product of two integers in an array.
- Find the smallest missing positive number in an unsorted array.
- Determine if a number is a palindrome without converting it to a string.
- Implement a priority queue using a heap.
- Implement the quicksort algorithm.
- Find the longest palindromic substring in a string.
- Implement a binary search tree and perform an inorder traversal.
- Implement a binary search on a rotated sorted array.
- Find the number of islands in a grid.


