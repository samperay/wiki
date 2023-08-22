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

