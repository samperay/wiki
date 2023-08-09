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