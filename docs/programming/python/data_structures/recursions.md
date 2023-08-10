Recursion is a programming technique in which a function calls itself to solve a problem. Recursive functions break down complex problems into smaller, more manageable subproblems, and these subproblems are solved by invoking the same function recursively. 

examples using recursion

```python
# sum of factorial
def fact(n):
    if n == 0: 
        return 1 
    else:
        return n*fact(n-1)
```

```python
# sum of fibonacci numbers 
def fib(n):
    if n<=1: 
        return n
    else:
        return fib(n-1)+fib(n-2)
```

```python
# list of fib numbers
def fibonacci_list(n):
    if n <= 0:
        return []
    elif n == 1:
        return [0]
    elif n == 2:
        return [0, 1]
    else:
        fib_list = fibonacci_list(n - 1)
        fib_list.append(fib_list[-1] + fib_list[-2])
        return fib_list
```

## Binary Search Tree(BST)

### contains

```python
class Node:
    def __init__(self,value):
        self.value = value 
        self.left = None 
        self.right=None

class BinarySearchTree:
    def __init__(self):
        self.root=None

    def __r_contains(self,current_node,value):
      if current_node == None:
        return False 

      if value == current_node.value:
        return True

      if value < current_node.value:
        return self.__r_contains(current_node.left,value)

      if value>current_node.value:
        return self.__r_contains(current_node.right, value)

    def r_contains(self,value):
      return self.__r_contains(self.root,value)


    def insert(self,value):
        new_node = Node(value)
        if self.root is None:
            self.root=new_node
            return True 
        temp = self.root
        while(True):
            # if the node of same value already exists
            if new_node.value==temp.value: 
                return False

            # if the node value is less then root value, add to left
            if new_node.value < temp.value:
                if temp.left is None:
                    temp.left = new_node
                    return True
                temp = temp.left
            else:
                # if the node value is greater then root value, add to right
                if temp.right is None:
                    temp.right = new_node
                    return True
                temp=temp.right

my_tree=BinarySearchTree()
my_tree.insert(2)
my_tree.insert(1)
my_tree.insert(3)
print(my_tree.r_contains(13))
```

### insert 

