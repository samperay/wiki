# Hackerrank 

## cut 

print the 3rd character from each line as a new line of output.

```bash
cut -c3
```

Display the 2nd and 7th character from each line of text.

```bash
cut -c2,7
```

Display a range of characters starting at the 2nd position of a string and ending at the 7th position (both positions included)

```bash
cut -c2-7
```

Given a tab delimited file with several columns (tsv format) print the first three fields.

```bash
cut -f1-3
```

Print the characters from thirteenth position to the end.
```
cut -c13-
```

Each Input sentence, identify and display its fourth word. Assume that the space (' ') is the only delimiter between words.

```bash
cut -d" " -f4
```

The output should contain N lines. For each input sentence, identify and display its first three words. Assume that the space (' ') is the only delimiter between words.

```bash
cut -d" " -f1-3
```

For each line in the input, print the fields from second fields to last field.

```bash
cut -f2-
```

## head

Output the first 20 lines of the given text file.

```bash
head -20
```

Output the first 20 characters of the text file

```bash
head -c20
```

Display the lines (from line number 12 to 22, both inclusive) for the input file.

**Hint:** First display first 22 lines and then tail(22-12=10)

```bash
head -22|tail -11
```

## paste

Replace the newlines in the input file with semicolons

```bash
paste -d";" -s
```

Restructure the file so that three consecutive rows are folded into one line and are separated by semicolons.

```bash
paste -d ";" - - -
```

The delimiter between consecutive rows of data has been transformed from the newline to a tab. Previous solution: paste -s -d"\\t". The delimiter option is not necessary as tab is the delimiter of paste by default

```bash
paste -s
```

Restructure the file in such a way, that every group of three consecutive rows are folded into one, and separated by tab.

```bash
paste - - -
```

## sort

Output the text file with the lines reordered in lexicographical order.

```bash
sort
```

Output the text file with the lines reordered in reverse lexicographical order.

```bash
sort -r
```

Output the text file with the lines reordered in numerically ascending order.

```bash
sort -n
```

The text file, with lines re-ordered in descending order (numerically)

```bash
sort -n -r
```

Rearrange the rows of the table in descending order of the values for the average temperature in January (i.e, the mean temperature value provided in the second column) in a tab seperated file.

```bash
sort -k2 -n -r -t$'\t'
```

The data has been sorted in ascending order of the average monthly temperature in January (i.e, the second column) in a tsv file

```bash
sort -n -k2 -t$'\t'
```

The data has been sorted in descending order of the average monthly temperature in January (i.e, the second column).

```bash
sort -k2 -n -r -t '|'
```

## tail 

Output the last 20 lines of the text file.

```bash
tail -20
```

Display the last 20 characters of an input file.

```bash
tail -c20
```

## tr

Output the text with all parentheses () replaced with box brackets [].

```bash
tr "()" "[]"
```

In a given fragment of text, delete all the lowercase characters a - z

```bash
tr -d "a-z"
```

Replace all sequences of multiple spaces with just one space.

```bash
tr -s " "
```

## uniq

Given a text file, remove the consecutive repetitions of any line.

```bash
uniq
```

Given a text file, count the number of times each line repeats itself. Only consider consecutive repetitions. Display the space separated count and line, respectively. There shouldn't be any leading or trailing spaces. Please note that the uniq -c command by itself will generate the output in a different format than the one expected here.

```bash
uniq -c | cut -c7-
```

compare consecutive lines in a case insensitive manner. So, if a line X is followed by case variants, the output should count all of them as the same (but display only the form X in the second column).

```bash
uniq -i -c | cut -c7-
```

Given a text file, display only those lines which are not followed or preceded by identical replications.

```bash
uniq -u
```

