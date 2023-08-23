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