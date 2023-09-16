# Tags & Virtual Tags

The basic tag syntax is very powerful and simple to use. There are two ways to
use this, shown here:
```
❯ task +domestic list
ID Age  Priority Tags          Description                Urgency
11 7d   L        domestic next clean the workspace up        16.3
 8 7d   M        domestic      Cook lunch                    4.74

2 tasks

❯ task -care list
ID Active Age  Priority Project Tags          Schedule Due        Description                                                    Urgency
 6   7d   8d   M                setup                             Add taskwarrior script to add routine tasks                       8.74
19        3d                                           2023-09-12 Send Alice a birthday card                                        10.7
20        3d                                           2023-09-12 Send Alice a birthday card                                        10.7
21        3d                                           2023-09-13 Send Alice a birthday card                                        10.3
22        3d                                           2023-09-16 Send Alice a birthday card                                        13.9
11        7d   L                domestic next                     clean the workspace up                                            16.3
 5        8d   H                growth                            review the written taskwarrior to specify the .taskrc file        6.84
 3        8d   M                growth                            Grind the Usage Examples section of Taskwarrior docs [1]          5.54
 7        2w   M                setup                             set an special tmux script for task warrior                        4.8
 2        8d   M                growth                            Grind the portfolio until 1:43:00                                 4.74
 8        7d   M                domestic                          Cook lunch                                                        4.74
 9        7d   M                                                  Meditation 20 min at 12                                           3.94
10        7d   M                                                  Meditation 20 min at 4                                            3.94
 1        2w   L                growth                            prepare a german speech                                            1.3
 4        8d                    growth                            review the written taskwarrior to specify the .taskrc file        0.84
26        2d                                                      foo [1]                                                           0.81
25        3d                                                      Download ♬ ♩ for the plane                                        0.02
27        2d                                                      bar                                                               0.01
28        2d                                                      baz                                                               0.01
29        2d                                                      foo bar                                                           0.01
16        4d   M        routine mindset                           Listen Alux                                                       0.72
18        4d   M        routine education                         Listen German                                                     0.72

22 tasks
```

These two commands illustrate the complete tag interface. The first command is
a filter that list only tasks that have the `domestic` tag. The second command is a 
filter that lists only tasks that do not have the `care` tag. The `+` and `-` syntax
therefore means presence and absence of a tag. This is simple to use, and can
be combined like this:
```
❯ task +domestic -next list
ID Age  Priority Tags     Description    Urgency
 8 7d   M        domestic Cook lunch        4.74

1 task
```

This shows tasks that have the `domestic` tag, but do not have the `next` tag. This is
a very simple and easy to use mechanism, but it does require that your tasks are
properly tagged. In other words, it is based directly on task metadata.

A tag may be any single word that does not start with a digit, punctuation, or
mathematical operator.

## Complex Filters
Some Taskwarrior filters are simple in concept, but the syntax is not that
straightforward. For example, to determine whether a task has a due date that
falls on the current day, you need to use this filter:
```
❯ task +due.after:yesterday and due.before:tomorrow list
```

This filters tasks with a due date during the narrow time window of `today`. Note
that it is not sufficient to just specify the date, because due dates all have
associated times (defaulting to 00:00:00), and if you want to match the date, you
need to consider the time. So for example, this command does not list tasks due
today:
```
❯ task due.today list
```
Instead, this filter matches tasks with a due date of today, and a time of 0:00. In
order to see all tasks de today, you need to provide proper range bracketing.

## Simplification
Here is where virtual tags can help, by providing a simple tag interface to more
complex state conditions of the task. There is a virtual tag, named `TODAY` that
can be used in filters, and it means that instead of this filter:
```
❯ task due.after:yesterday and due.before:tomorrow list
```

We can now use this:
```
❯ task +TODAY list
```
Which is a much simpler way of filtering tasks due today. Because this is a tag
interface, we can also invert it:
```
❯ task -TODAY list
```

This shows only tasks that are not due today.

Virtual tags are built in to Taskwarrior. They are evaluated at run time, which
means they do not require direct metadata, and therefore do not occupy space in
the data files, but are determined according to the state of the task in the same
way that the complex filter example above is determined.

Thus virtual tags combine the simplicity of the tag interface with more complex
defined conditions, for convenience.

## Supported Virtual Tags
Here is the full list of supported virtual tags:
- `BLOCKED` Is the task dependent on another incomplete task?
- `UNBLOCKED` The opposite of `BLOCKED`, for convenience. Note
`+BLOCKED == -UNBLOCKED`  and vice versa.
- `BLOCKING` Does another task depend on this incomplete task?
- `DUE` Is this task due within 7 days? Determined by `rc.due`
- `DUETODAY` Is this task due sometime today?
- `TODAY` Is this task due sometime today?
- `OVERDUE` Is this task due sometime today?
- `WEEK` Is this task due this week?
- `MONTH` Is this task due this month?
- `QUARTER` Is this task due this quarter?
- `YEAR` Is this task due this year?
- `ACTIVE` Is the task active, i.e. does it have a start date?
- `SCHEDULE` Is the task scheduled, i.e. does it have a scheduled date?
- `PARENT` Is the task a hidden parent recurring task?
- `CHILD` Is the task a recurring child task?
- `UNTIL` Does the task expire, i.e. does it have an until date?
- `WAITING` Is the task hidden, i.e. does it have wait date?
- `ANNOTATED` Does the task have any annotations?
- `READY` Is the task pending, not blocked, and either not scheduled, or
scheduled before now.
- `YESTERDAY` Was the task due yesterday?
- `TOMORROW` Is the task due tomorrow?
- `TAGGED` Does the task have any tags?
- `PENDING` Is the task in the pending state?
- `COMPLETED` Is the task in the completed state?
- `DELETED` Is the task in the deleted state?
- `UDA` Does the task contain any `UDA` values?
- `ORPAHN` Does the task contain any orphaned `UDA` values?
- `PRIORITY` Does the task have a priority?
- `PROJECT` Does the task have a project?
- `LATEST` Is the task the most recently added task?
