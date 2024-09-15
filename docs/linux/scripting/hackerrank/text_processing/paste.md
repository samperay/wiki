Replace the newlines in the input file with semicolons
```
paste -d";" -s
```

Restructure the file so that three consecutive rows are folded into one line and are separated by semicolons.
```
paste -d ";" - - -
```

The delimiter between consecutive rows of data has been transformed from the newline to a tab. Previous solution: paste -s -d"\\t". The delimiter option is not necessary as tab is the delimiter of paste by default
```
paste -s
```

Restructure the file in such a way, that every group of three consecutive rows are folded into one, and separated by tab.
```
paste - - -
```