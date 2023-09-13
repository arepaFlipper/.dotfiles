# Searching
Searching for keywords and patterns in tasks is straightforward, and uses 
the `/pattern` syntax. First we create some sample tasks, then we'll search them:
```
❯ task add foo
Created task 26.

❯ task add bar
Created task 27.

❯ task add baz
Created task 28.
```

In order to locate that first task, by the keyword `foo` we do this:
```
❯ task /foo/ list

ID Age  Description Urgency
26 1min foo               0

1 task
```

The `/` characters delimit the search term, indicating what Taskwarrior should do.
Because task annotations are also searchable text, we can be sure that any
annotations containing the pattern `/foo/` will also be found. Let's add a task
which such an annotation:
```
❯ task 3 annotate footwear
Annotating task 3 'Grind the Usage Examples section of Taskwarrior docs'.
Annotated 1 task.

❯ task 26 annotate footwear
Annotating task 26 'foo'.
Annotated 1 task.

❯ task /foo/ long

ID Created    Mod   P Tags   Description
26 2023-09-13 23s            foo
                               2023-09-13 footwear
 3 2023-09-07  1min M growth Grind the Usage Examples section of Taskwarrior docs
                               2023-09-13 footwear

2 tasks
```
Here the `long` report is used, so we can see the full annotation text. Notice that
the `foo` in the description of task 26, as well as the `footwear` in the annotation 
of task 3 were both found.

## Regular Expressions
All search terms are by default "regular expressions". This means we could
have searched using this pattern, which means an `f` followed by to `o` characters:
```
❯ task /fo{2}/ long

ID Created    Mod  P Tags   Description
26 2023-09-13 8min          foo
                              2023-09-13 footwear
 3 2023-09-07 8min M growth Grind the Usage Examples section of Taskwarrior docs
                              2023-09-13 footwear

2 tasks
```

You could put the setting in your `.taskrc` file. You can also turn off regular 
expression support:
```
❯ task rc.regex:off /fo{2}/ long
Configuration override rc.regex:off
No matches.
```
This fails because the search term `/fo{2}/` is this time considered just text, not
a regular expression and this term does not appear in any task.

## Shell
If your search term contains one or more spaces, then your shell is going to 
break the search pattern into two arguments, and Taskwarrior will be confused.
Solve this by either quoting or escaping like these examples:
```
❯ task add "foo bar"
Created task 29.


❯ task '/foo bar/' list

ID Age   Description Urgency
29 11s   foo bar           0

1 task


❯ task /foo\ bar/ list

ID Age   Description Urgency
29 16s   foo bar           0

1 task
```
This guarantees that Taskwarrior sees one argument, `/foo bar/` instead of two,
`/foo`, `bar/`.

## Operators
The search pattern syntax of `/pattern` is there as a convenience, but there 
are more powerful low-level operators, such that the above pattern is equivalent 
to:
```
❯ task description~foo list

ID Age   Priority Tags   Description                                              Urgency
 3  5d   M        growth Grind the Usage Examples section of Taskwarrior docs [1]    5.53
26 27min                 foo [1]                                                      0.8
29  5min                 foo bar                                                        0

3 tasks
```

Here the `~` match operator works much like that in Bash. To invert that, to
search for descriptions that do not contain the pettern, use the no-match
operator:
```
❯ task 'desc!~foo' list

ID Active Age   Priority Project Tags          Due        Description                                                    Urgency
 6   4d    5d   M                setup                    Add taskwarrior script to add routine tasks                       8.73
12         2d   L        routine care mindset  2023-09-11 Meditate 15 at 8                                                  6.99
13         2d   L        routine care mindset  2023-09-11 Meditate 15 at 12                                                 6.91
19         1d                                  2023-09-12 Send Alice a birthday card                                        9.38
20         1d                                  2023-09-12 Send Alice a birthday card                                        9.38
14         2d   L        routine care mindset  2023-09-12 Meditate 15 at 4                                                   6.6
21         1d                                  2023-09-13 Send Alice a birthday card                                        8.92
22        23h                                  2023-09-16 Send Alice a birthday card                                        7.54
11         4d   L                domestic next            clean the workspace up                                            16.3
 5         5d   H                growth                   review the written taskwarrior to specify the .taskrc file        6.83
 3         5d   M                growth                   Grind the Usage Examples section of Taskwarrior docs [1]          5.53
 7         2w   M                setup                    set an special tmux script for task warrior                       4.78
 2         5d   M                growth                   Grind the portfolio until 1:43:00                                 4.73
 8         4d   M                domestic                 Cook lunch                                                        4.72
 9         4d   M                                         Meditation 20 min at 12                                           3.92
10         4d   M                                         Meditation 20 min at 4                                            3.92
 1         2w   L                growth                   prepare a german speech                                           1.28
 4         5d                    growth                   review the written taskwarrior to specify the .taskrc file        0.83
25        43min                                           Download ♬ ♩ for the plane                                           0
27        30min                                           bar                                                                  0
28        30min                                           baz                                                                  0
15         1d   M        routine care workout             Cardio 20 Min                                                     0.81
16         1d   M        routine mindset                  Listen Alux                                                       0.71
17         1d   M        routine care                     Cold shower                                                       0.71
18         1d   M        routine education                Listen German                                                     0.71

25 tasks
```
Here you see the `!~` no-match operator, an abbreviated `desc` attribute name,
and quoting, because Bash will interpret the `!` character in its own way.
