Output the text file with the lines reordered in lexicographical order.
```
sort
```

Output the text file with the lines reordered in reverse lexicographical order.
```
sort -r
```

Output the text file with the lines reordered in numerically ascending order.
```
sort -n
```

The text file, with lines re-ordered in descending order (numerically)
```
sort -n -r
```

Rearrange the rows of the table in descending order of the values for the average temperature in January (i.e, the mean temperature value provided in the second column) in a tab seperated file.
```
sort -k2 -n -r -t$'\t'
```

The data has been sorted in ascending order of the average monthly temperature in January (i.e, the second column) in a tsv file
```
sort -n -k2 -t$'\t'
```

The data has been sorted in descending order of the average monthly temperature in January (i.e, the second column).
```
sort -k2 -n -r -t '|'
```