# Hackerrank

## TL;DR

HackerRank shell problems are good drills for standard Unix text-processing tools. Most solutions read from stdin, transform lines, and write to stdout, so the important skill is choosing the smallest correct command and understanding delimiters, fields, character positions, and sort order. For SRE work, these same tools are useful for log triage, quick data cleanup, incident investigation, and shell pipelines.

See also: [Bash overview](overview.md), [Scripting FAQ](faq.md), [Linux admin basics](../admin/basics.md), and [Linux troubleshooting](../admin/troubleshooting.md).

```mermaid
flowchart LR
    A[stdin] --> B[cut/head/paste/sort/tail/tr/uniq]
    B --> C[stdout]
    C --> D[Next pipeline stage or answer]
```

## cut

`cut` extracts characters or fields from each input line. Use `-c` for character positions and `-f` for tab-delimited fields. Use `-d` when fields are separated by a delimiter other than tab.

Print the 3rd character from each line as a new line of output.

```bash
# Print character 3 from each input line.
cut -c3
```

Display the 2nd and 7th character from each line of text.

```bash
# Print characters 2 and 7 from each input line.
cut -c2,7
```

Display a range of characters starting at the 2nd position of a string and ending at the 7th position, both positions included.

```bash
# Print characters 2 through 7 from each input line.
cut -c2-7
```

Given a tab-delimited file with several columns, or TSV format, print the first three fields.

```bash
# Print fields 1 through 3 from tab-delimited input.
cut -f1-3
```

Print the characters from thirteenth position to the end.

```bash
# Print from character 13 through the end of each line.
cut -c13-
```

For each input sentence, identify and display its fourth word. Assume that the space (` `) is the only delimiter between words.

```bash
# Use a space delimiter and print field 4.
cut -d" " -f4
```

The output should contain `N` lines. For each input sentence, identify and display its first three words. Assume that the space (` `) is the only delimiter between words.

```bash
# Use a space delimiter and print fields 1 through 3.
cut -d" " -f1-3
```

For each line in the input, print the fields from the second field to the last field.

```bash
# Print from tab-delimited field 2 through the end.
cut -f2-
```

## head

`head` prints the beginning of input. It can count lines or bytes/characters depending on flags and platform behavior.

Output the first 20 lines of the given text file.

```bash
# Print the first 20 lines.
head -20
```

Output the first 20 characters of the text file.

```bash
# Print the first 20 bytes/characters from input.
head -c20
```

Display the lines from line number 12 to 22, both inclusive, for the input file.

Hint: first display the first 22 lines and then tail the last 11 lines.

```bash
# Print lines 12 through 22 by combining head and tail.
head -22 | tail -11
```

## paste

`paste` merges lines from files or stdin. With `-s`, it serializes all input lines into one line. With multiple `-` operands, it reads multiple columns from stdin.

Replace the newlines in the input file with semicolons.

```bash
# Join all input lines into one semicolon-delimited line.
paste -d";" -s
```

Restructure the file so that three consecutive rows are folded into one line and separated by semicolons.

```bash
# Fold each group of three input lines into one semicolon-delimited row.
paste -d ";" - - -
```

The delimiter between consecutive rows of data has been transformed from newline to tab. The delimiter option is not necessary because tab is the default delimiter of `paste`.

```bash
# Join all input lines into one tab-delimited line.
paste -s
```

Restructure the file so that every group of three consecutive rows is folded into one line and separated by tabs.

```bash
# Fold each group of three input lines into one tab-delimited row.
paste - - -
```

## sort

`sort` orders input lines. Use `-n` for numeric comparison, `-r` for reverse order, `-k` for key/field selection, and `-t` for delimiter selection.

Output the text file with the lines reordered in lexicographical order.

```bash
# Sort lines alphabetically.
sort
```

Output the text file with the lines reordered in reverse lexicographical order.

```bash
# Sort lines alphabetically in reverse order.
sort -r
```

Output the text file with the lines reordered in numerically ascending order.

```bash
# Sort lines as numbers in ascending order.
sort -n
```

Output the text file with lines reordered in descending numeric order.

```bash
# Sort lines as numbers in descending order.
sort -n -r
```

Rearrange the rows of a tab-separated table in descending order by average temperature in January, the value in the second column.

```bash
# Sort tab-delimited rows by numeric field 2 in descending order.
sort -k2 -n -r -t$'\t'
```

Sort the data in ascending order of the average monthly temperature in January, the second column, in a TSV file.

```bash
# Sort tab-delimited rows by numeric field 2 in ascending order.
sort -n -k2 -t$'\t'
```

Sort the data in descending order of the average monthly temperature in January when fields are pipe-delimited.

```bash
# Sort pipe-delimited rows by numeric field 2 in descending order.
sort -k2 -n -r -t '|'
```

## tail

`tail` prints the end of input. It is useful for logs, recent records, and combining with `head` to select a range.

Output the last 20 lines of the text file.

```bash
# Print the last 20 lines.
tail -20
```

Display the last 20 characters of an input file.

```bash
# Print the last 20 bytes/characters from input.
tail -c20
```

## tr

`tr` translates, deletes, or squeezes characters. It works on character streams, not fields or regex-style words.

Output the text with all parentheses `()` replaced with box brackets `[]`.

```bash
# Translate opening/closing parentheses to opening/closing square brackets.
tr "()" "[]"
```

In a given fragment of text, delete all lowercase characters `a-z`.

```bash
# Delete lowercase letters.
tr -d "a-z"
```

Replace all sequences of multiple spaces with just one space.

```bash
# Squeeze repeated spaces into a single space.
tr -s " "
```

## uniq

`uniq` filters adjacent duplicate lines. It only detects consecutive duplicates, so use `sort | uniq` when duplicates may be separated.

Given a text file, remove consecutive repetitions of any line.

```bash
# Collapse adjacent duplicate lines.
uniq
```

Given a text file, count the number of times each line repeats itself. Only consider consecutive repetitions. Display the space-separated count and line, respectively. There should not be leading or trailing spaces.

```bash
# Count adjacent duplicates and remove leading alignment spaces from uniq output.
uniq -c | cut -c7-
```

Compare consecutive lines in a case-insensitive manner. If a line `X` is followed by case variants, the output should count all of them as the same, but display only the first form.

```bash
# Count adjacent duplicates case-insensitively and normalize uniq output spacing.
uniq -i -c | cut -c7-
```

Given a text file, display only lines which are not followed or preceded by identical replications.

```bash
# Print only lines that are unique relative to adjacent lines.
uniq -u
```

## Common Pitfalls

- Forgetting that most HackerRank shell commands read from stdin by default.
- Using `cut -f` on space-delimited data without `-d" "`.
- Expecting `uniq` to remove non-adjacent duplicates without sorting first.
- Using lexicographic sort when numeric sort is required.
- Forgetting that `paste - - -` groups three input lines at a time.
- Treating `tr` like a regex engine; it works on characters and character sets.

## Interview Questions

- What is the difference between `cut -c` and `cut -f`?
- Why does `cut -f` default to tab-delimited input?
- How do you print lines 12 through 22 using `head` and `tail`?
- What does `paste -s` do?
- How do you sort numerically by the second field?
- Why does `uniq` only remove adjacent duplicates?
- What does `tr -s " "` do?
- When would you use `sort | uniq` instead of `uniq` alone?

## Key Takeaways

These commands are small, but they compose into powerful pipelines. Learn what each tool expects as input, what it writes to stdout, and how delimiters or ordering affect correctness.

For SRE work, the same skills apply to log files, command output, CSV/TSV snippets, and quick incident summaries. Prefer the simplest pipeline that is correct and readable.

See also: [Bash overview](overview.md), [Scripting FAQ](faq.md), [Linux admin basics](../admin/basics.md), and [Linux troubleshooting](../admin/troubleshooting.md).
