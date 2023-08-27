## Intro to Analysis

**standard analyzer or text analyzer**

When we index a text value, it goes through an analysis process. The purpose of it is to store the values in a data structure that is efficient for searching. When a text value is indexed, a so-called analyzer is used to process the text.

An analyzer consists of three building blocks

- **character filters **

A character filter receives the original text and may transform it by adding, removing, or changing characters.
An analyzer may have zero or more character filters, and they are applied in the order in which they are specified.

e.g get all text using html_strip

-** a tokenizer **

An analyzer must contain exactly one tokenizer, which is responsible for tokenizing the text. By “tokenizing,” I am referring to the process of splitting the text into tokens. As part of that process, characters may be removed, such as punctuation, exclamation marks, etc.

e.g split a sentence into words by splitting the string whenever a whitespace is encountered.
The input string is therefore tokenized into a number of tokens.

- **token filters**

These receive the tokens that the tokenizer produced as input and they may add, remove, or modify tokens.
As with character filters, an analyzer may contain zero or more token filters, and they are applied in the order in which they are specified.

e.g token filter is probably the “lowercase” filter, which lowercases all letters.

**Output**: The result of analyzing text values is then stored in a searchable data structure.

**No character filter is used by default**, so the text is passed on to the tokenizer as is. The tokenizer splits the text into tokens according to the **Unicode Segmentation algorithm**.  tokenizer breaks sentences into words by whitespace, hyphens, and such. In the process, it also throws away punctuation such as commas, periods, exclamation marks, etc.

The **tokens are then passed on to a token filter** named “lowercase.” it lowercases all letters for the tokens. 

This **standard analyzer is used for all text fields** unless configured otherwise. There are a couple of analyzers available besides the “standard” analyzer, but that’s the one you will typically use.

From the elastic console, try to run the API query for the standard analyzer, you would understand.

```
POST /_analyze
{
    "text": "walk into bar and don't.... DRINK",
    "analyzer": "standard"
}
```

You can also write your custom analyzer, however it would behave same as standard analyzer outputs. 

```
POST /_analyze
{
    "text": "walk into bar and don't.... DRINK",
    "char_filter":[],
    "tokenizer":"standard",
    "filter":["lowercase"]
}
```

let’s take a look at what actually happens with the result, being the tokens. Elasticsearch uses more than one data structure, is to ensure efficient data retrieval for different access patterns.

e.g searching for a given term is handled differently than aggregating data.

Actually these data structures are all handled by **Apache Lucene** and not Elasticsearch.

##  Inverted indices

An inverted index is essentially a mapping between **tokens that are emitted by the analyzer**(a.k.a tokens) and which documents contain them.

Anyway, let’s take previous example and see how that would be stored within an inverted index.

Document #1 -> "walk into bar and don't.... DRINK" -> ["and","bar","don't","DRINK","into","walk"] 
Document #2 -> "I walk into bar" -> ["I","bar","into","walk"]

As you can see, each unique term is placed in the index together with information **about which documents contain the term**, sorted alphbetically. Suppose that we perform a search for the term "bar", we can see that documents #1 and #2 contain the term.

its called as inverted index because, the logical mapping is terms they contain to documents.  The inverted indices that are stored within **Apache Lucene** contain a bit more information, such as data that is used for **relevance scoring**.

As you can imagine, we don’t just want to get the documents back that contain a given term; we also want them to be ranked by how well they match.

## mapping

Mapping defines the structure of documents and how they are indexed and stored.  This includes the fields of a document and their data types. As a simplification, you can think of it as the equivalent of a table schema in a relational database.

In Elasticsearch, there are two basic approaches to mapping; **explicit and dynamic mapping**.  

**explicit mapping**, we define fields and their data types ourselves, typically when creating an index. 

**dymanic mapping**, field mapping will automatically be created when elasticsearch encounters a new field.
It will inspect the supplied field value to figure out how the field should be mapped, if you supply a string value, for instance, elasticsearch will use the "text" data type for the mapping.

## datatypes

there are many, few are discussed and frequently used. 

**Object**: JSON documents are hierarchical in nature, the document may contain inner objects which, in turn, may contain inner objects themselves, they are mapped using properties parameter. 

```json
PUT my-index-000001/_doc/1
{ 
  "region": "US",
  "manager": { 
    "age":     30,
    "name": { 
      "first": "John",
      "last":  "Smith"
    }
  }
}
```

Internally, this document is indexed as a simple, flat list of key-value pairs

```json
{
  "region":             "US",
  "manager.age":        30,
  "manager.name.first": "John",
  "manager.name.last":  "Smith"
}
```

In a case where you have documents of same tokens, then it would make a flat array of internal documents and query.
which would perform "OR" operation and provides wrong results.. hence we use the word **nested** 

```json
{
  "region":             "US",
  "manager.age":        [30,50,60]
  "manager.name.first": ["John","Mat","Suj"],
  "manager.name.last":  ["Smith","Hew","Samuel"]
}

```

**Keyword**: exact matching of values, typically used for filtering, aggregating, sorting 
e.g search articles only "published"

**text**: use for full text searches. 
e.g entire body of article


References: 
https://www.elastic.co/guide/en/elasticsearch/reference/current/sql-data-types.html

## coercion

Data types are inspected when indexing docs, invalid values are rejected. so that only text fields are indexed. 

Note: 
- Enabled by default
- Always try using correct data types

```json
PUT /coercion_test/_doc/1 {
    "price": 7.4
}
```

Creates and indexde as **float** as a new document. 

```json
PUT /coercion_test/_doc/1 {
    "price": "7.4"
}
```

Creates and indexed as **string** as a new document. 

## understand arrays

Array values should be of same data type
Array may contain nested arrays
Arrays are flattened during indexing

Note: Remember to use the nested data type for arrays of objects if you need to query the objects independently

```json
POST /products/_doc {
    "tags": ["item1","item2"]
}
```

## adding explict mapping

all field mapping defined in properties key, including nested objected
and create index.

```json
PUT /reviews {
    "mappings": {
        "properties" {
            "rating": { "type": "float"},
            "content": { "type": "text"},
            "product_id": { "type": "integer"},
            "author": {
                "properties": {
                    "first_name": {"type": "text"},
                    "last_name": { "type", "text"},
                    "email": {"type": "keyword"}

                }
            }
        }
    }
}
```

The above one is one method of creating an index, but there is second method of using i.e (**dot-notation**)
which is easy to create index.

```json
PUT /reviews {
    "mappings": {
        "properties" {
            "rating": { "type": "float"},
            "content": { "type": "text"},
            "product_id": { "type": "integer"},
            "author.first_name": {"type": "text"},
            "author.last_name": { "type", "text"},
            "author.email": {"type": "keyword"}

                
            
        }
    }
}
```

create a new document

```json
PUT /reviews/_doc/1 {
    "rating": 4.3,
    "content": "Elastic search is good",
    "product_id": 123,
    "author": {
        "first_name": "Sunil",
        "last_name": "Kumar",
        "email": "sun@gmail.com"
    }
}
```

incase you don't provide email and submit, coercion while indexing would throw an error because its enabled by default.

## retrive mapping 

```
GET /reviews/_mapping

GET /reviews/_mapping/field/content

GET /reviews/_mapping/field/author.email
```

lets say you need to map a new value to already created index..

```json
PUT /reviews/_mapping {
    "properties": {
        "created_at":  {
            "type": "date"
            }
    }
}

GET /reviews/_mapping
```

## how date works in elasticsearch

dates are referred in three ways and elastic search would convert those date and time formts into a long string. 

- specially formatted strings
- milliseconds since the EPOCH(long)
- seconds since the EPOCH(integrer)

supported formats 

- date without time
- date with time
- milliseconds since the EPOCH(long) defaults to UTC

```json
PUT /reviews/_doc/1 {
    "rating": 4.3,
    "content": "Elastic search is good",
    "product_id": 123,
    "author": {
        "first_name": "Sunil",
        "last_name": "Kumar",
        "email": "sun@gmail.com",
        "birth": "2015-04-15"  # only date
        "birth": "2015-04-15T15:00:00Z" T seperated by date and time, followed by Z(UTC)
        "birth": "123223023823772" # UNIX EPOCH timestamp
    }
}

GET /reviews/_search {
    "query" {
        "match_all": {}
    }
}

```

## mapping parameters

- format: customize date format, however recommended `date`
- properties: used for object and nested 
- coerce: index validation (enabled by default). you can disable during start but can be overide 
when creating
- doc_values: used mainly for apache lucene, opposite for interved index.
- norms: normalizing factors used for revelance scores, i.e ranking. 
- index: 
- null_value:  cannont be index or searched
- copy_to: used to copy multiple field values into a group field(not tokes/terms), when search this field you won't get results because its not indexed.


