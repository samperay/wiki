Sorting refers to the process of arranging elements in a specific order, typically in ascending or descending order based on their values.

## bubble

Bubble Sort is a simple sorting algorithm that repeatedly steps through the list, compares adjacent elements, and swaps them if they are in the wrong order.

```python
def bubble_sort(my_list):
    n = len(my_list)
    for i in range(n):
        # Last i elements are already in place, no need to compare them
        for j in range(0, n-i-1):
            if my_list[j] > my_list[j+1]:
                # Swap the elements if they are in the wrong order
                my_list[j], my_list[j+1] = my_list[j+1], my_list[j]

    return my_list

print(bubble_sort([3,5,1,4,2]))
```

## selection

Selection Sort is a simple sorting algorithm that repeatedly selects the minimum (or maximum) element from the unsorted part of the array and places it at the beginning (or end) of the sorted part.

```python
def selection_sort(arr):
    n = len(arr)
    for i in range(n - 1):
        min_index = i
        for j in range(i + 1, n):
            if arr[j] < arr[min_index]:
                min_index = j

        # Swap the minimum element with the first element in the unsorted part
        arr[i], arr[min_index] = arr[min_index], arr[i]

print(selection_sort([64, 34, 25, 12, 22, 11, 90]))
```

## insertion

Insertion Sort is a simple sorting algorithm that builds the final sorted array one item at a time. It works by iteratively considering each element and inserting it into its correct position within the already sorted part of the array.

```python
def insertion_sort(arr):
    n = len(arr)
    for i in range(1, n):
        key = arr[i]  # Current element to be inserted
        j = i - 1

        # Move elements of arr[0..i-1], that are greater than key, to one position ahead of their current position
        while j >= 0 and key < arr[j]:
            arr[j + 1] = arr[j]
            j -= 1
        arr[j + 1] = key

print(insertion_sort([64, 34, 25, 12, 22, 11, 90]))
```

## merge 

### Sorted merge list

two merge list in the sorted order to make a single list

```python
def merge_helper(list1,list2):
    combined=[]
    i=0
    j=0
    while i<len(list1) and j<len(list2):
        if list1[i] < list2[j]:
            combined.append(list1[i])
            i+=1
        else:
            combined.append(list2[j])
            j+=1

    while i < len(list1):
        combined.append(list1[i])
        i+=1

    while j < len(list2):
        combined.append(list2[j])
        j+=1

    return combined

def merge_sort(mylist):
  if len(mylist) ==1:
    return mylist
  mid_index = int(len(mylist)/2) # find the mid of index
  left = merge_sort(mylist[:mid_index]) # split list to left until 1 item in sorted list
  right = merge_sort(mylist[mid_index:]) # split list to right until 1 item in sorted list

  return merge_helper(left,right) # combine two sorted list to make one

print(merge_sort([3,1,4,2])) # [1, 2, 3, 4]
```

### Big O

Space complexity: O(n)
Time complexity: O(n log(n))



## quick 

Quick Sort is a widely used efficient sorting algorithm that follows the divide-and-conquer approach to sort an array or list of elements. It works by selecting a 'pivot' element from the array and partitioning the other elements into two subarrays: one containing elements less than the pivot and another containing elements greater than the pivot. The subarrays are then recursively sorted.

```python
def swap(mylist,index1,index2):
  mylist[index1],mylist[index2]=mylist[index2],mylist[index1]

# return the index of the list
def pivot(mylist,pivot_index,end_index):
  swap_index = pivot_index
  for i in range(pivot_index+1,end_index+1):
    if mylist[i]<mylist[pivot_index]:
      swap_index+=1
      swap(mylist,swap_index,i)

  swap(mylist,pivot_index,swap_index)
  return swap_index

def quick_sort(mylist,left,right):
  if left<right:
    pivot_index = pivot(mylist,left,right)
    quick_sort(mylist,left,pivot_index-1)
    quick_sort(mylist,pivot_index+1,right)
  return mylist

mylist = [4,6,1,7,3,2,5]
print(pivot(mylist,0,6))
```

