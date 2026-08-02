## TL;DR

This document covers the full document lifecycle in Elasticsearch: creating and deleting indices, indexing documents (with and without explicit IDs), reading, updating, scripted updates, upserts, replacing, and deleting documents. It also covers Elasticsearch's routing mechanism, bulk operations for high-throughput ingestion, and the update-by-query / delete-by-query patterns. These are the CRUD fundamentals every SRE needs to debug data issues, build ingestion pipelines, and understand why a query is returning unexpected results.

See also: [Installation & Setup](./01_install.md) | [Mapping & Analysis](./03_mapping_analysis.md)

---

## Create Index

An index in Elasticsearch is analogous to a table in a relational database. When you create it explicitly, you control the number of primary shards (which cannot be changed after creation) and replica shards (which can be changed at any time). If you index a document without creating the index first, Elasticsearch creates it automatically with default settings.

```json
// Create an index named 'products' with 2 primary shards and 1 replica each.
// For a 2-node cluster, this results in 4 total shards (2 primary + 2 replica).
PUT /products
{
  "settings": {
    "number_of_shards": 2,
    "number_of_replicas": 1
  }
}
```

## Delete Index

Deleting an index is irreversible and removes all documents. Always double-check the index name before running this in production — there is no trash can.

```json
// Permanently delete the 'products' index and all its data
DELETE /products
```

## Create Document ID

Elasticsearch can auto-generate document IDs (using a UUID-like format) or you can supply your own. Auto-generated IDs use `POST`; explicit IDs use `POST` with the ID in the path, or `PUT`. Providing your own ID is important when you have a natural primary key (e.g. a product SKU or order ID) and want idempotent indexing — re-indexing the same document with the same ID updates it in place rather than creating a duplicate.

```json
// Auto-generate a document ID (Elasticsearch assigns a random UUID)
POST /products/_doc
{
  "name": "coffeemaker",
  "price": 64,
  "in_stock": 10
}
```

```json
// Index a document with a specific ID (100)
// If document 100 already exists, this REPLACES it entirely
POST /products/_doc/100
{
  "name": "mobile charger",
  "price": 1999,
  "in_stock": 0
}
```

## Get Document by ID

Retrieve a specific document by its ID, or retrieve all documents with a `match_all` query. The `_source` field in the response contains the original JSON you indexed.

```json
// Retrieve a single document by ID
GET /products/_doc/100

// Retrieve all documents in the index (default limit: 10)
GET /products/_search
{
  "query": {
    "match_all": {}
  }
}
```

## Update Document by ID

The `_update` API performs a partial update — only the fields you specify in `doc` are changed; all other fields remain untouched. This is different from a full document replacement (which uses `PUT`).

```json
// Partially update document 100: change only the 'name' field
POST /products/_update/100
{
  "doc": {
    "name": "mobile earbuds"
  }
}

// Verify the update
GET /products/_doc/100
```

## Add New Fields

You can add a completely new field to an existing document using the same `_update` API. Elasticsearch uses dynamic mapping to infer the field type from the value.

```json
// Add a 'tags' array field to document 100
POST /products/_update/100
{
  "doc": {
    "tags": ["electronics"]
  }
}

GET /products/_doc/100
```

## Scripted Updates

Scripted updates use Painless (Elasticsearch's scripting language) to perform programmatic modifications — incrementing a counter, applying conditional logic, or modifying values based on existing field values. They are more powerful than `doc` updates because the logic runs server-side, avoiding a read-modify-write race condition.

```json
// Decrement in_stock by 1 using a Painless script
// ctx._source gives you access to the current document's fields
POST /products/_update/100
{
  "script": {
    "source": "ctx._source.in_stock--"
  }
}
```

## Add Parameters to Scripts

Using `params` instead of hardcoded values in scripts is important for performance — Elasticsearch compiles scripts; a script with a hardcoded value is recompiled every time the value changes. Scripts with params are compiled once and reused.

```json
// Set in_stock to a parameterised value (avoids recompilation)
POST /products/_update/100
{
  "script": {
    "source": "ctx._source.in_stock = params.quantity",
    "params": {
      "quantity": 1
    }
  }
}

GET /products/_doc/100
```

## Upsert

An upsert runs a script if the document already exists, or creates a new document from the `upsert` block if it does not. This is the Elasticsearch equivalent of SQL's `INSERT ... ON CONFLICT DO UPDATE` and is essential for idempotent ingestion pipelines.

```json
// If document 101 exists: run the script (increment in_stock)
// If document 101 does NOT exist: create it using the 'upsert' block
POST /products/_update/101
{
  "script": {
    "source": "ctx._source.in_stock++"
  },
  "upsert": {
    "name": "iphone 11",
    "price": 309999,
    "in_stock": 8
  }
}

GET /products/_doc/101
```

## Replace Document

A `PUT` to `_doc` replaces the entire document. Unlike `_update`, this is a full replacement — any fields not included in the new body are removed. Use this when you want to overwrite a document completely.

```json
// Replace document 101 entirely (all previous fields are discarded)
PUT /products/_doc/101
{
  "name": "Google Pixel",
  "price": 121111,
  "in_stock": 3
}

GET /products/_doc/101
```

## Deleting a Document

```json
// Delete a single document by ID
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

