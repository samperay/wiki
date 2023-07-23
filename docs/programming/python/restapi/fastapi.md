## Install FastAPI

```
pip install "fastapi[all]"
```

## Hello World from FastAPI

```python
from fastapi import FastAPI
import uvicorn

app = FastAPI()

@app.get("/")
async def root():
    return {"message": "Hello World"}

if __name__ == "__main__":
    uvicorn.run(app, host="0.0.0.0", port=8000)
```

## path parameters

You can declare path "parameters" or "variables" with the same syntax used by Python format strings
path parameter **item_id** will be passed to your function as the argument item_id

```python
@app.get("/items/{item_id}")
async def read_item(item_id): # data convertion happens here
    return {"item_id": item_id}
```

you can declare it with the data types
```python
async def read_item(item_id: int ): # item_id is declared to be an int 
```

All the data validation is performed under the hood by Pydantic, so you get all the benefits from it.
You can use the same type declarations with str, float, bool and many other complex data types.

Always remember, the order in which path parameters execute matters. 
let's say you have two api calls, the one which is first defined will be returned. the path for /users/{user_id} would match also for /users/me, "thinking" that it's receiving a parameter user_id with a value of "me". 

If there is same two rest api end points, the one which is defined first would always be executed. 

```python
@app.get("/users/me")
#some code

@app.get("/users/{user_id}")
#some code
```

## query parameters

When you declare other function parameters that are not part of the path parameters, they are automatically interpreted as "query" parameters. The query is the set of key-value pairs that go after the ? in a URL, separated by & characters.

```python
fake_items_db = [{"item_name": "Foo"}, {"item_name": "Bar"}, {"item_name": "Baz"}]

@app.get("/items/")
async def read_item(skip: int = 0, limit: int = 10):
    # Query params are: skip = 0, limit = 10
    return fake_items_db[skip : skip + limit]
```

http://127.0.0.1:8000/items/?skip=0&limit=10
