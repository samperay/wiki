
**Keep your control structures clean**

- avoid deep nesting.
- use factory functions and polymorphism
- prefer positive checks(e.g IsValid, IsEmpty..etc)
- Utilize errors

## Guards

Use guards and fail fast

```python
if !(email.includes('@')):
    return  # fail fast instead of deep nesting 

# if there remaining code, then you would execute from here
```

## Embrace errors

Throwing + handling errors can **replace if statements** and lead to more focussed functions.
If something is an error, make it error insterad of using if-else statements to fix it..
you can use **try-catch** to log error.



