We would discuss more about the code structure, formating and comments in this section. 

## comments

### Bad comments

- avoid redunant comments. i.e your vars name and code would almost mean same thing
- avoid dividers or blockers i.e naming globals etc in "****" for better reading etc, if this is big then create a new file and import it.
- misleading comments i.e method is being done something but comment is something
- comented code i.e delete code incase not required

### Good comments

- legal information i.e disclaimer etc 
- explanation which can't be replaced by good namming i.e regular expression 
- warining i.e works only in dev env or etc 
- todo nodes i.e add unfinished code to be written 
- docstring i.e writing for the API would make sense. 

## code formatting

code formating improves readibilty and transports meaning. this would be lang specific. always use specific conventions and guide lines while writing code. 

### vertical formating 

- veritical space between lines
  
**code should be readable like an essay** - top to bottom without too many jumps. 
If the code is too big in the file, then try considering breaking code into different multiple files and classes. this makes code short and readable. 

Different concepts("areas") should be seperated by spacing. i.e imports and function should be having a one blank line.  

- grouping of code i.e all the related concepts should be kept the same. if we are writing to save code, all the code related to save should be one below the block.

### horizontal formating 

lines of code should be readable without scrollng. avoid very long "sentences"

- indentation i.e use it even if its not required.
- line width  i.e break long line of code into shorter. 
- space between code 
- use clear variable name rather than long name
