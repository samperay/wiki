# Data Types in Golang

## 1. **Basic Types**
These are the fundamental data types in Go.

| **Type**      | **Description**                                | **Example**      |
|---------------|------------------------------------------------|------------------|
| **bool**      | Boolean values (`true` or `false`)             | `var isActive bool = true` |
| **string**    | Sequence of characters                        | `var name string = "Golang"` |
| **int**       | Signed integer (platform-dependent size)      | `var age int = 25` |
| **uint**      | Unsigned integer (platform-dependent size)    | `var count uint = 10` |
| **float32**   | 32-bit floating-point number                  | `var pi float32 = 3.14` |
| **float64**   | 64-bit floating-point number                  | `var pi float64 = 3.14159265359` |
| **complex64** | Complex number with float32 real/imag parts   | `var c complex64 = 1 + 2i` |
| **complex128**| Complex number with float64 real/imag parts   | `var c complex128 = 2 + 3i` |

---

## 2. **Integer Types**
Go provides multiple integer types of different sizes.

| **Type**      | **Size** | **Description**                     | **Example**      |
|---------------|----------|-------------------------------------|------------------|
| **int8**      | 8 bits   | Signed integer (-128 to 127)        | `var a int8 = 127` |
| **int16**     | 16 bits  | Signed integer (-32,768 to 32,767)  | `var b int16 = 32000` |
| **int32**     | 32 bits  | Signed integer (-2^31 to 2^31-1)    | `var c int32 = 2147483647` |
| **int64**     | 64 bits  | Signed integer (-2^63 to 2^63-1)    | `var d int64 = 9223372036854775807` |
| **uint8**     | 8 bits   | Unsigned integer (0 to 255)         | `var e uint8 = 255` |
| **uint16**    | 16 bits  | Unsigned integer (0 to 65,535)      | `var f uint16 = 65535` |
| **uint32**    | 32 bits  | Unsigned integer (0 to 2^32-1)      | `var g uint32 = 4294967295` |
| **uint64**    | 64 bits  | Unsigned integer (0 to 2^64-1)      | `var h uint64 = 18446744073709551615` |

---

## 3. **Derived Types**
Derived or composite types are built using basic types.

### a. **Array**
- Fixed-size collection of elements of the same type.
- Example: `var arr [3]int = [3]int{1, 2, 3}`

### b. **Slice**
- Dynamic-sized, more flexible version of an array.
- Example: `var slice []int = []int{1, 2, 3}`

### c. **Map**
- Key-value pairs (similar to dictionaries in Python).
- Example: `var m map[string]int = map[string]int{"one": 1, "two": 2}`

### d. **Struct**

- Collection of fields, used to define custom data types.
- Example:
```go
type Person struct {
    Name string
    Age  int
}
var p Person = Person{Name: "John", Age: 30}
```

### e. Pointer
Stores the memory address of a variable.
Example: var p *int = &a

### f. Interface
Defines a set of method signatures, allowing polymorphism.

```
type Shape interface {
    Area() float64
}
```

## Operators

Arthematic operators:  `+, -, *, / , %, ++, --`

Assignment operators: `=, +=, -=, *=, /=, %=, &=, !=, ^=, >>=, <<= `


Comparision operators : `<, >, ==, !=, <=, >=`

Logical operators: `&&, || !`

Bitwise operators: `&, |, ^, <<, >>`

## verb formats 

| **Verb** | **Description**                                        | **Example**              |
|----------|--------------------------------------------------------|--------------------------|
| `%v`     | Default format (value representation)                  | `fmt.Printf("%v", 42)`   |
| `%+v`    | Adds field names for structs                           | `fmt.Printf("%+v", struct{Name string}{"Go"})` |
| `%#v`    | Go syntax representation                               | `fmt.Printf("%#v", struct{Name string}{"Go"})` |
| `%T`     | Type of the value                                      | `fmt.Printf("%T", 42)`   |
| `%%`     | Literal percent sign                                   | `fmt.Printf("%%")`       |

---

## Boolean
| **Verb** | **Description**                                        | **Example**              |
|----------|--------------------------------------------------------|--------------------------|
| `%t`     | Boolean (`true` or `false`)                            | `fmt.Printf("%t", true)` |

---

## Integer
| **Verb** | **Description**                                        | **Example**              |
|----------|--------------------------------------------------------|--------------------------|
| `%b`     | Binary representation                                  | `fmt.Printf("%b", 42)`   |
| `%c`     | Character corresponding to the Unicode code point      | `fmt.Printf("%c", 65)`   |
| `%d`     | Decimal representation                                 | `fmt.Printf("%d", 42)`   |
| `%o`     | Octal representation                                   | `fmt.Printf("%o", 42)`   |
| `%O`     | Octal with leading `0o`                                | `fmt.Printf("%O", 42)`   |
| `%q`     | Single-quoted character literal, escapes if necessary  | `fmt.Printf("%q", 65)`   |
| `%x`     | Hexadecimal (lowercase)                                | `fmt.Printf("%x", 255)`  |
| `%X`     | Hexadecimal (uppercase)                                | `fmt.Printf("%X", 255)`  |
| `%U`     | Unicode format (e.g., `U+1234`)                        | `fmt.Printf("%U", '✓')`  |

---

## Floating-Point and Complex
| **Verb** | **Description**                                        | **Example**              |
|----------|--------------------------------------------------------|--------------------------|
| `%b`     | Exponent as a power of two                             | `fmt.Printf("%b", 3.14)` |
| `%e`     | Scientific notation (lowercase `e`)                    | `fmt.Printf("%e", 3.14)` |
| `%E`     | Scientific notation (uppercase `E`)                    | `fmt.Printf("%E", 3.14)` |
| `%f`     | Decimal point, no exponent                             | `fmt.Printf("%f", 3.14)` |
| `%F`     | Same as `%f`                                           | `fmt.Printf("%F", 3.14)` |
| `%g`     | Compact representation (`%e` or `%f`)                  | `fmt.Printf("%g", 3.14)` |
| `%G`     | Compact representation (`%E` or `%F`)                  | `fmt.Printf("%G", 3.14)` |

---

## String and Slice
| **Verb** | **Description**                                        | **Example**              |
|----------|--------------------------------------------------------|--------------------------|
| `%s`     | String (plain text)                                    | `fmt.Printf("%s", "Go")` |
| `%q`     | Double-quoted string, escapes if necessary             | `fmt.Printf("%q", "Go")` |
| `%x`     | Hex dump of string (lowercase)                         | `fmt.Printf("%x", "Go")` |
| `%X`     | Hex dump of string (uppercase)                         | `fmt.Printf("%X", "Go")` |

---

## Pointer
| **Verb** | **Description**                                        | **Example**              |
|----------|--------------------------------------------------------|--------------------------|
| `%p`     | Pointer (base 16, with leading `0x`)                   | `fmt.Printf("%p", &a)`   |

---

## Width and Precision
| **Option** | **Description**                                      | **Example**              |
|------------|------------------------------------------------------|--------------------------|
| `%5d`      | Minimum width of 5 (right-aligned)                   | `fmt.Printf("%5d", 42)`  |
| `%-5d`     | Minimum width of 5 (left-aligned)                    | `fmt.Printf("%-5d", 42)` |
| `%.2f`     | Precision (2 decimal places)                         | `fmt.Printf("%.2f", 3.14159)` |
| `%5.2f`    | Width 5, precision 2                                 | `fmt.Printf("%5.2f", 3.14159)` |

## Control flow

### **if and elif **

```go
func main() {
a := 10
b := 10

if a > b {
	fmt.Println("a is greater than b")
	} else if b > a {
		fmt.Println("b is greater than a")
		} else if a == b {
			fmt.Println("a is equal to b")
		}
	
}
```

### for 

```go

func main() {
	for i:=0 ; i<=10; i++ {
		fmt.Println(i)
	}

	// for loop with condition
	j := 0
	for j <= 10 {
		fmt.Println(j)
		j++
	}

	// for loop with range
	k := []int{1,2,3,4,5}
	for index, value := range k {
		fmt.Println(index, value)
	}	


	// for loop with map
	l := map[string]string{"a": "apple", "b": "banana"}
	for key, value := range l {
		fmt.Println(key, value)
	}

	// for loop with string
	m := "Hello World"
	for index, value := range m {
		fmt.Println(index, string(value))
	}

	// for loop with break
	for i:=0; i<=10; i++ {
		if i == 5 {
			break
		}
		fmt.Println(i)
	}

	// for loop with continue
	for i:=0; i<=10; i++ {
		if i == 5 {
			continue
		}
		fmt.Println(i)
	}

	// for loop with goto
	i := 0
	Loop:
		fmt.Println(i)
		i++
		if i <= 10 {
			goto Loop
		}

	// for loop with nested loop
	for i:=0; i<=5; i++ {
		for j:=0; j<=5; j++ {
			fmt.Println(i, j)
		}
	}

}
```

### switch

```go
func main() {
	var num int
	fmt.Printf("%T %v\n", num, num)
	fmt.Printf("Enter a number from 1 to 3: ")
	fmt.Scan(&num)

	switch num {
		case 1:
			fmt.Printf("You entered 1")
		case 2:
			fmt.Printf("You entered 2")
		case 3:
			fmt.Printf("You entered 3")
        case 4,5:
            fmt.Printf("You entered either 4 or 5")
		default:
			fmt.Printf("You entered an invalid number")
		}
}
```

## Arrays

```go
func main() {
  var arr1 = [3]int{1,2,3}
  arr2 := [5]int{4,5,6,7,8}

  fmt.Println(arr1)
  fmt.Println(arr2)
}
```

### Slices

Like arrays, slices are also used to store multiple values of the same type in a single variable.

However, unlike arrays, the length of a slice can grow and shrink as you see fit.

```go
func main() {
  myslice1 := []int{}
  fmt.Println(len(myslice1)) // 0
  fmt.Println(cap(myslice1)) // 0
  fmt.Println(myslice1) // []

  myslice2 := []string{"Go", "Slices", "Are", "Powerful"}
  fmt.Println(len(myslice2)) // 4
  fmt.Println(cap(myslice2)) // 4
  fmt.Println(myslice2) // [Go Slices Are Powerful]
  fmt.Println(myslice2[0]) // Go

  myslice2 = append(myslice2, "New", "append")
  fmt.Println(myslice2)

  fmt.Println(len(myslice2)) // 6
  fmt.Println(cap(myslice2)) // 8

  // append one slice to another

  myslice1 := []int{1,2,3}
  myslice2 := []int{4,5,6}
  myslice3 := append(myslice1, myslice2...)
}
```

### Maps

Maps are used to store data values in key:value pairs.

A map is an unordered and changeable collection that does not allow duplicates.

Maps hold references to an underlying hash table.

```go
func main() {
	var a = map[string]string {"name":"John", "age":"25", "job":"Engineer", "salary":"50000"}

	

	b:=make(map[string]string) // empty map

	b["name"]="John"
	b["age"]="25"
	b["job"]="Engineer"
	b["salary"]="50000"


	b["name"]="Doe" // update value
	b["color"]="Red" // add new key value pair

	delete(b, "color") // delete key value pair

	key, value := a["name"] // check if key exists
	fmt.Println(key, value)

	_, value = a["name1"] // check if value exists
	fmt.Println(value)	
	fmt.Println("a: ",a)
	fmt.Println("b: ",b)

	for k, v := range a {
		fmt.Printf("%v : %v, ", k, v) //loop with no order
	  }

	fmt.Println()
	fmt.Println()
	for _, element := range a {
		fmt.Printf("%v : %v, \n", element, a[element]) // loop with the defined order
	}

}
```

## Functions 

Information can be passed to functions as a parameter. Parameters act as variables inside the function.

```go 
func Add(a int, b int) int {
	return a+b 
}

func main() {
	result := Add(1, 2)
	fmt.Println("Sum of two numbers:", result)
}
```

If you need to omit the return result, you need to use '_'


```go

func myFunction(x int, y string) (result int, txt1 string) {
	result = x + x
	txt1 = y + " World!"
	return
  }

func main() {
	_, b := myFunction(5, "Hello")
  fmt.Println(b) // Hello World
}
```

```go
func sumOfFib(n int ) int {
	if n < 0 {
		return 0
	}

	a,b:=0,1
	sum := a +b 

	for i:=3; i<=n; i++ {
		next:=a+b 
		sum+=next
		a=b
		b=next
	}

	return sum 

}

func printFib(n int) {
	if n < 0 {
		fmt.Println("invalid input")
		return
	}

	a,b := 0,1
	for i:=1;i<=n; i++ {
		fmt.Printf("%d ", a)
		a,b=b, a+b

	}

	fmt.Println()
}

func main() {
	println(fact(5))
	println(sumOfFib(6))
	printFib(6)
}
```

## Pointers

## Struct, Methods and Interfaces

A struct (short for structure) is used to create a collection of members of different data types, into a single variable.

```go

type Person struct {
	name string
	age int
	job string
	salary int
  }

func main() {
	var pers1 Person


  pers1.name = "Hege"
  pers1.age = 45
  pers1.job = "Teacher"
  pers1.salary = 6000

  // Access and print Pers1 info
  fmt.Println("Name: ", pers1.name)
  fmt.Println("Age: ", pers1.age)
  fmt.Println("Job: ", pers1.job)
  fmt.Println("Salary: ", pers1.salary)
}
```

Pass struct as function

```go
type Person struct {
	name string
	age int
	job string
	salary int
  }

func printPerson(pers1 Person) {
	  // Access and print Pers1 info
	  fmt.Println("Name: ", pers1.name)
	  fmt.Println("Age: ", pers1.age)
	  fmt.Println("Job: ", pers1.job)
	  fmt.Println("Salary: ", pers1.salary)
}


func main() {
	var pers1 Person


  pers1.name = "Hege"
  pers1.age = 45
  pers1.job = "Teacher"
  pers1.salary = 6000

  printPerson(pers1)

}
```
