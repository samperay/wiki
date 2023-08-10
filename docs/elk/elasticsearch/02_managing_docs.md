## Create index

```
PUT /products 
{
  "settings": {
    "number_of_shards": 2, 
    "number_of_replicas": 1
  }
}
```

## Delete index

```
DELETE /products
```

## Create index id 

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

## Get index by id 

```
GET /products/_doc/100

# Get all the documents
GET /products/_search
{
  "query": {
    "match_all": {}
  }
}

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

## Add new fields

```
POST /products/_update/100
{
  "doc": {
    "tags": ["electornics"]
  }
}

GET /products/_doc/100
```

## Scripted updates

```
POST /products/_update/100
{
  "script": {
    "source": "ctx._source.in_stock--"
  }
}
```

## Add parameters and query

```
POST /products/_update/100
{
  "script": {
    "source": "ctx._source.in_stock=params.quantity",
    "params": {
      "quantity":1
    }
    
  }
}

GET /products/_doc/100
```

## Upsert

Incase the document exists, then run the query & update else you would be creating a new document. 

```
POST /products/_update/101
{
  "script": {
    "source": "ctx._source.in_stock++"},
    "upsert":
    {
      "name": "iphone 11",
      "price": 309999,
      "in_stock": 8
    }
}

GET /products/_doc/101
```

## Replace document 

```
PUT /products/_doc/101
{
  "name": "Google pixel",
  "price": 121111,
  "in_stock": 3
}

GET /products/_doc/101
```

## Deleting document

```
DELETE /products/_doc/101
```

## Routing

When running a search request, Elasticsearch selects a node containing a copy of the index’s data and forwards the search request to that node’s shards. This process is known as search `**shard routing or routing**`

(How read and write happens in elastic search)[https://www.elastic.co/guide/en/elasticsearch/reference/current/docs-replication.html]

## update by query

Updates documents that match the specified query. If no query is specified, performs an update on every document in the data stream or index without modifying the source, which is useful for picking up mapping changes.

```
POST products/_update_by_query
{
  "script": {
    "source": "ctx._source.in_stock--"
  },
  "query": {
      "match_all": {}
    }
}
```

## delete by query 

Deletes documents that match the specified query.

```
POST products/_delete_by_query
{
  "query": {
      "match_all": {}
    }
}
```

## Bulk API 

Performs multiple indexing or delete operations in a single API call. This reduces overhead and can greatly increase indexing speed.

```
POST _bulk
{ "index" : { "_index" : "products", "_id" : "200" } }
{ "name" : "Mac Laptop", "price": 102121,"in_stock":10 }
{ "create" : { "_index" : "products", "_id" : "201" } }
{ "name" : "Laptop bags", "price": 1032,"in_stock":29 }
{ "update" : {"_id" : "200", "_index" : "products"} }
{ "doc" : { "name" : "Mac Laptop Premier", "price": 102121,"in_stock":10} }
{ "delete": { "_index" : "products", "_id" : "201" }}
{ "delete": { "_index" : "products", "_id" : "200" }}
```

Incase you want to use the curl to pass the data, you need to create a new file `request` and update `_bulk` data into the file and pass it to curl. 

```
curl -H "Content-Type:application/json" --cacert config/certs/http_ca.crt -u elastic:Xl4mktLmPkO=22=_DwEl -X POST https://localhost:9200/_bulk --data-binary "@request"; echo


{"took":39,"errors":false,"items":[{"index":{"_index":"products","_id":"200","_version":1,"result":"created","_shards":{"total":2,"successful":1,"failed":0},"_seq_no":13,"_primary_term":1,"status":201}},{"create":{"_index":"products","_id":"201","_version":1,"result":"created","_shards":{"total":2,"successful":1,"failed":0},"_seq_no":14,"_primary_term":1,"status":201}},{"update":{"_index":"products","_id":"200","_version":2,"result":"updated","_shards":{"total":2,"successful":1,"failed":0},"_seq_no":15,"_primary_term":1,"status":200}},{"delete":{"_index":"products","_id":"201","_version":2,"result":"deleted","_shards":{"total":2,"successful":1,"failed":0},"_seq_no":16,"_primary_term":1,"status":200}},{"delete":{"_index":"products","_id":"200","_version":3,"result":"deleted","_shards":{"total":2,"successful":1,"failed":0},"_seq_no":17,"_primary_term":1,"status":200}}]}


```

