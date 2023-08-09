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
def sorted_merge(list1,list2):
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


print(sorted_merge([1,2,7,18],[4,5,6,13]))
```

### unsorted merge list




## quick 

