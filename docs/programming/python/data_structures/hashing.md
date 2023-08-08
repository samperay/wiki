## Overview

Hashing is a technique used in computer science to map data of arbitrary size to fixed-size values, usually integers, which are used as keys to access or store data in a data structure called a hash table. Hashing allows for efficient data retrieval and storage by reducing the search space and providing constant-time average complexity for common operations like insertion, deletion, and retrieval.

Deterministic hashing refers to the property of a hash function where the same input will always produce the same hash value. In other words, given a specific input, the hash function will consistently generate the exact same output hash code. This property is crucial for the reliability and predictability of hash-based data structures and algorithms.

Python's dictionaries handle the details of hashing and collision resolution internally, making it easy to work with hashed data without needing to implement these aspects yourself.


```python

student_scores = {
    "Alice": 95,
    "Bob": 88,
    "Charlie": 92,
    "David": 78
}

for name, score in student_scores.items():
    print(f"{name}: {score}")

```

## Collisions

Separate chaining is a collision resolution strategy used in hash-based data structures, such as hash tables, to handle situations where multiple keys hash to the same index. It involves creating a separate data structure, often a linked list, for each index in the hash table where collisions occur.

### Hash Table Initialization

The hash table is divided into a fixed number of buckets (or slots), each with a unique index. Each bucket can hold multiple key-value pairs.

### Hashing

When a new key needs to be inserted into the hash table or when you want to retrieve a value associated with a key, a hash function is applied to the key to determine the index (bucket) where it should be stored or looked up.

### Collision Handling
- If two or more keys hash to the same index (collision), separate chaining is used to handle the collision.
- At each index where a collision occurs, a separate data structure (typically a linked list) is maintained.

### Insertion

To insert a new key-value pair:
- Hash the key to find the appropriate index (bucket).
- Insert the key-value pair at the end of the linked list (or another chosen data structure) associated with that index.

### Retrieval 

To retrieve the value associated with a key:
- Hash the key to find the appropriate index.
- Traverse the linked list at that index to find the desired key and retrieve its corresponding value.

### Deletion

To delete a key-value pair:
- Hash the key to find the appropriate index.
- Search the linked list for the key and remove the corresponding pair if found.

## Constructor 

```python
class HashTable:
  def __init__(self, size=7):
    self.data_map = [None]*size

  def __hash(self,key):
    my_hash=0
    for letter in key:
      my_hash=(my_hash+ord(letter)*23) % len(self.data_map)
    return my_hash

hash_table = HashTable()
hash_table.print_hash_table()
```

## print table

```python
def print_hash_table(self):
    for k,v in enumerate(self.data_map):
        print(k,": ", v)
```

## set item

```python
def set_item(self,key,value):
    index = self.__hash(key)
    if self.data_map[index] == None:
        self.data_map[index]=[]
    self.data_map[index].append([key,value])
```

## get item

```python
def get_item(self,key):
    index = self.__hash(key)
    if self.data_map[index] is not None:
        for i in range(len(self.data_map[index])):
        if self.data_map[index][i][0] == key:
            return self.data_map[index][i][1]
    return None
```

## get all keys 

```python
def keys(self):
    all_keys=[]
    for i in range(len(self.data_map)):
        if self.data_map[i] is not None:
        for j in range(len(self.data_map[i])):
            all_keys.append(self.data_map[i][j][0])
    return all_keys
```

## Big-O

In the best scenerio, the item we are searching in the hash table is found at the index, it wouldbe **O(1)**. 
In wrost case even if the item is entirely hashed in the list, the max would be **O(n)**, but however since we are hashing the key value pair are evenly distributed and have very less collisions, we would say its always the hash is 
**O(1)**


## Interview Q

provided the two lists, get the item in common. provide me the best solution in terms of bigO

list1 = [2,3,4]
list2 = [1,6,4]

There are two approches for this. 

1. You would be iterating first item of list1 against all the elements in list2 and so on. Once you find you would be returning True or else False. Since there are multiple nested loops **O(n^2)**

```python
# code goes here
```

2. Create a dict for list1 and check if the key of dict in list2. Once you find you would return True or else False. 
This would have O(2n) i.e removing constants, it would be **O(n)**

```python
# code goes here
```