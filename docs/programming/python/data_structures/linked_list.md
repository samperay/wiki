## O(linked list operations)

There are few of the operations that which we do in the linked list, below snapshot describes you about the Big-O cases. 

![linked_list](linked_list.png)

## linked list under the hood. 

linked list appears to be as below, however in the memory they are scarattered in the different locations, but they are always connected with the pointer. There is **head** which is the start of the node and the **tail** which is the end of the node in the list. the connection elements between the nodes are the **pointers** which are connected

![linked_list_basic_structure](linked_list_basic_structure.png)

Under the hood, its nothing but a dictionary, which can be used as a variable to set and iterate the values.  

![linked_list_underhood](linked_list_underhood.png)

## linkedlist operations 

Methods that are used in the linked list class. 

```python
class LinkedList:
    def __init__(self,value)
    def append(self,value)
    def prepend(self,value)
    def insert(self,index,value)
    def pop(self,index,value)
    def print(self)
```

We can use a new node as class **Node** that creates a new node. 

```python
class Node:
    def __init__(self,value):
        self.value = value 
        self.next = None
```

## Code snippets

```python

class Node:
    def __init__(self,value):
        self.value = value
        self.next = None

class LinkedList:
    def __init__(self,value):
        new_node = Node(value)
        self.head = new_node
        self.tail = new_node
        self.length = 1

    def print_list(self):
        temp = self.head 
        while temp is not None:
            print(temp.value,end=' ')
            temp = temp.next

    def append(self,value):
        new_node=Node(value)
        if self.length==0:
            self.head = new_node.head
            self.tail = new_node.tail 
        else:
            self.tail.next = new_node
            self.tail = new_node
        self.length+=1
        return True

    def pop(self):
        # if node is empty
        if self.length == 0:
            return None
        else:
            # more than two nodes 
            temp=self.head 
            pre=self.head
            while(temp.next):
                pre=temp
                temp=temp.next
            self.tail = pre
            self.tail.next=None
            self.length-=1
            # if node is 0 after decrementing
            if self.length==0:
                self.head = None 
                self.tail = None
        return temp.value


my_linked_list = LinkedList(1)
my_linked_list.append(2) 
my_linked_list.append(3)

# print('Head:', my_linked_list.head.value)
# print('Tail:', my_linked_list.tail.value)
# print('Length:', my_linked_list.length)
print("intial linked list:", end= ' ') 
my_linked_list.print_list() # 1 2 3

print("\nlist after popping")
print(my_linked_list.pop()) # 3
print(my_linked_list.pop()) # 2
print(my_linked_list.pop()) # 1

print("intial linked list:", end= ' ') # empty node list
my_linked_list.print_list()
                                                                                                    
```

