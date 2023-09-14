# Filters
A filter is a set of command line arguments that specify a set of tasks. A filter
can range from being simple to very complex. The simplest filter is an empty filter,
and we can illustrate this concept with the `count`:

```
❯ task count
177
```

These 170 tasks are the tasks in total, pending and completed, which represent are all
the tasks known to Taskwarrior. Any command that accepts a filter also accepts
no filter, as shown above. Now we introduce a filter with one term:
```
❯ task status:pending count
27

❯ task status:completed count
130
```

This is an example of the `name : value` form for specifying attribute values.
This filter shows that there are 27 pending tasks, and therefore 130 that are not
pending in some way. This form of filter also works for other attributes:
```
❯ task projects.any: list

ID Active Age   Priority Project Tags          Schedule Due        Description                                                    Urgency
 6   5d    6d   M                setup                             Add taskwarrior script to add routine tasks                       8.73
12         3d   L        routine care mindset           2023-09-11 Meditate 15 at 8                                                  7.45
13         3d   L        routine care mindset           2023-09-11 Meditate 15 at 12                                                 7.37
19         2d                                           2023-09-12 Send Alice a birthday card                                        9.83
20         2d                                           2023-09-12 Send Alice a birthday card                                        9.83
14         3d   L        routine care mindset           2023-09-12 Meditate 15 at 4                                                  7.06
21         2d                                           2023-09-13 Send Alice a birthday card                                        9.38
22         1d                                           2023-09-16 Send Alice a birthday card                                          13
11         5d   L                domestic next                     clean the workspace up                                            16.3
 5         6d   H                growth                            review the written taskwarrior to specify the .taskrc file        6.83
 3         6d   M                growth                            Grind the Usage Examples section of Taskwarrior docs [1]          5.53
 7         2w   M                setup                             set an special tmux script for task warrior                       4.79
 2         6d   M                growth                            Grind the portfolio until 1:43:00                                 4.73
 8         5d   M                domestic                          Cook lunch                                                        4.73
 9         5d   M                                                  Meditation 20 min at 12                                           3.93
10         5d   M                                                  Meditation 20 min at 4                                            3.93
 1         2w   L                growth                            prepare a german speech                                           1.29
 4         6d                    growth                            review the written taskwarrior to specify the .taskrc file        0.83
26         1d                                                      foo [1]                                                           0.81
25         1d                                                      Download ♬ ♩ for the plane                                        0.01
27         1d                                                      bar                                                               0.01
28         1d                                                      baz                                                               0.01
29        23h                                                      foo bar                                                              0
15         2d   M        routine care workout                      Cardio 20 Min                                                     0.81
16         2d   M        routine mindset                           Listen Alux                                                       0.71
17         2d   M        routine care                              Cold shower                                                       0.71
18         2d   M        routine education                         Listen German                                                     0.71

27 tasks

❯ task project:routine count
16
```
There are 16 tasks in the `routine` project.

The value parameter can be left empty in order to match only the items that do
not have a value of the relevant kind assigned to them. For example, you can
count the tasks that are not assigned to any project, like this:
```
❯ task project: count
161
```

In this example, we can see that the tasks not assigned `routine` project (161) have not
yet been assigned to any project at all.

Taskwarrior has other filters besides `name : value` filters. Here are two
examples, filtering on the presence and absence of a tag:
```
❯ task +mindset count
13

❯ task -mindset count
164
```

This shows us that there are 13 tasks that have the `mindset` tag, and 164 that do not. To
search for a word in the description or annotation:

```
❯ task /m..ting/ count
2
```
Here we see that 3 tasks have the word "`m..thing`" in the `description`. This is a 
regular expression, although it can also be just a simple word.

This assumes you have enabled regular expression support, using the
`rc.regex` configuration setting.

## Complex Filters
Filters gain complexity by adding more filter terms and logic. Suppose we want to 
see the number of tasks that have the `routine` project, and do not have the `care`
tag. Simply put both terms on the command line:
```
❯ task project:routine -care count
2

❯ task project:routine +care count
14
```
The two terms in the filter are both applied to the set of all tasks, or in other
words, a task must have both the `routine` project and not have the `care` tag to be
counted.

When a filter contains multiple terms like this, they are treated as a logical
conjunction, which is to say that both terms must match for a task to be selected
by the filter. If there were three terms in the filter, then all three must match.

This assumed conjunction is another command line syntax shortcut. The long
form of this command line is:
```
❯ task project:routine and -care count
2

❯ task project:routine and +care count
14
```

See the `and` operator between the filter terms? That is assumed to be there if
not specifically stated. The unstated implication is that the disjunction (`or`) is also
supported.

```
❯ task project:routine or -care count
177
```

This example asks how many tasks are part of the `routine` project, or do not have
the `work` tag - either is a match.

## Precedence
It was mentioned earlier that the simplest filter was an empty filter, such as in use
by the `count` command. Now we shall consider the `ls` report, which has a filter
of:
```
❯ task show report.ls.filter

Config Variable  Value
report.ls.filter status:pending -WAITING
```

This report filter is combined with the command line filter that you specify:
```
❯ task project:routine ls

ID Project Tags         Due  Description
15 routine care workout      Cardio 20 Min
17 routine care              Cold shower
16 routine mindset           Listen Alux
18 routine education         Listen German
13 routine care mindset      Meditate 15 at 12
14 routine care mindset      Meditate 15 at 4
12 routine care mindset      Meditate 15 at 8

7 tasks
```

This yields a combined filter of: `status:pending project:routine -WAITING`

Which has an implicit conjunction: `status:pending and project:routine and -WAITING`
```
❯ task project:routine ls

ID Project Tags         Due  Description
15 routine care workout      Cardio 20 Min
17 routine care              Cold shower
16 routine mindset           Listen Alux
18 routine education         Listen German
13 routine care mindset      Meditate 15 at 12
14 routine care mindset      Meditate 15 at 4
12 routine care mindset      Meditate 15 at 8

7 tasks
❯ task status:pending project:routine -WAITING

ID Age  P Project Tag          Due   Description       Urg
12 3d   L routine care mindset -2d   Meditate 15 at 8  7.46
13 3d   L routine care mindset -2d   Meditate 15 at 12 7.38
14 3d   L routine care mindset -2d   Meditate 15 at 4  7.08
15 3d   M routine care workout       Cardio 20 Min     0.82

7 tasks, truncated to 4 lines
❯ task status:pending and project:routine and -WAITING

ID Age  P Project Tag          Due   Description       Urg
12 3d   L routine care mindset -2d   Meditate 15 at 8  7.46
13 3d   L routine care mindset -2d   Meditate 15 at 12 7.38
14 3d   L routine care mindset -2d   Meditate 15 at 4  7.08
15 3d   M routine care workout       Cardio 20 Min     0.82

7 tasks, truncated to 4 lines
```

Now suppose we wanted to use a disjunction fulter with the `ls` command:
```
❯ task project:routine or project:work ls
```

Do you see the precedence problem? The intended filter is this: 
`status:pending and (project:routine or project:Garden)`

Which includes the parentheses to group the disjunction. Going back to the original
filter, we now know that it needs this form:
```
❯ task (project:routine or project:Garden) list
```

Except now, we have one more problem - those parentheses have special meaning to
the shell, and must be escaped in one of the following ways:
```
❯ task \(project:routine or project:Garden\) list
```

```
❯ task '(project:routine or project:Garden)' list
```

```
❯ task "(project:routine or project:Garden)" list
```

Note that there are may characters used by the Taskwarrior command line that have
special meaning to the shell, and as such must be properly escaped.

Also note that when searching for tasks without the specified entry at the end of the
parenthesis, you need to add a space, otherwise you'll get "Mismatched parentheses in expression".

This:
```
❯ task '(project: )'

ID Age  P Tag           S    Due   Description                Urg
11 5d   L domestic next            clean the workspace up     16.3
22 2d                         1d   Send Alice a birthday card   13
19 2d                        -2d   Send Alice a birthday card 9.85
20 2d                        -2d   Send Alice a birthday card 9.85

20 tasks, truncated to 4 lines
```

Not that:
```
❯ task '(project:)'
Mismatched parentheses in expression
```

## Configuration
Regular expressions in pattern filters are only used when enabled with:
`regex=on`

This config is set by default. If not enabled, the patterns are literal strings to be
matched. Case sensitivity for string searches and regular expressions is controlled by:
`search.case.sensitive=yes`
The default config is `yes`.
