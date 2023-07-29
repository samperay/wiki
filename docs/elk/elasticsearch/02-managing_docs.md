## Creation index

```
PUT /products 
{
  "settings": {
    "number_of_shards": 2, 
    "number_of_replicas": 1
  }
}
```

## Deletion index

```
DELETE /products
```

## index documents 

Creating some random document ID

```
POST /products/_doc
{
  "name": "coffeemaker",
  "price": 64,
  "in_stock": 10
}

```

You can also create with index which you wish

```
POST /products/_doc/100
{
  "name": "mobile charger",
  "price": 1999,
  "in_stock": 0
}
```

## Retrieve index by id 

```
GET /products/_doc/100
```

## Update index by id

```
POST /products/_update/100
{
  "doc": {
    "name": "mobile earbuds"
  }
}

GET /products/_doc/100

```

