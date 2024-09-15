Given a text file, remove the consecutive repetitions of any line.
```
uniq
```

Given a text file, count the number of times each line repeats itself. Only consider consecutive repetitions. Display the space separated count and line, respectively. There shouldn't be any leading or trailing spaces. Please note that the uniq -c command by itself will generate the output in a different format than the one expected here.
```
uniq -c | cut -c7-
```

compare consecutive lines in a case insensitive manner. So, if a line X is followed by case variants, the output should count all of them as the same (but display only the form X in the second column).
```
uniq -i -c | cut -c7-
```

Given a text file, display only those lines which are not followed or preceded by identical replications.
```
uniq -u
```