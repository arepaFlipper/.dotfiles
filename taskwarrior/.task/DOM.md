# DOM - Document Object Model
Taskwarrior has a **D**ocument **O**bject **M**odel, or DOM, which defines a way to
reference all the data managed by Taskwarrior. You may be familiar with the
DOM implemented by web browsers that let you access details on a page
programmatically. For example:
```
document.getElementById("myAnchor").href
```
Taskwarrior allows the same kind of data access in a similar form, for
example:
```
1. description
```

This references the description text of task 1. There is a `_get` [helper command](https://taskwarrior.org/docs/commands/_get)
that queries data using a DOM reference. Let's see it in action,
by first creating a detailed task.
```
❯ task add "Buy milk" due:tomorrow +store project:Home pri:H
Created task 61.
The project 'Home' has changed.  Project 'Home' is 0% complete (1 task remaining).

❯ task 61 info

Name          Value
ID            61
Description   Buy milk
Status        Pending
Project       Home
Entered       2023-09-28 10:16:30 (29s)
Due           2023-09-29 00:00:00
Last modified 2023-09-28 10:16:30 (29s)
Tags          store
Virtual tags  DUE LATEST MONTH PENDING PRIORITY PROJECT QUARTER READY TAGGED TOMORROW UDA UNBLOCKED WEEK YEAR
UUID          6fb2ea55-21af-419d-97dd-6463b42a8bb0
Urgency       16.34
Priority      H

    project             1 *    1 =      1
    tags              0.8 *    1 =    0.8
    due             0.712 *   12 =   8.54
    UDA priority.H      1 *    6 =      6
                                   ------
                                    16.34
```
All the attributes of that task are available via DOM references. Here are
some examples:
```
❯ task _get 61.description
Buy milk
❯ task _get 61.uuid
6fb2ea55-21af-419d-97dd-6463b42a8bb0
❯ task _get 6fb2ea55-21af-419d-97dd-6463b42a8bb0.id
61
❯ task _get 1.due.year
1969
❯ task _get 61.due.year
2023
❯ task _get 61.due.julian
272
```
### Supported References

##### system.version
The version of taskwarrior, for example:
```
❯ task _get system.version
2.6.2
```

##### system.os
The operating system, for example:
```
❯ task _get system.os
Linux
```

##### `rc.<name>`
Any configuration value default, with any overrides from the `.taskrc`
applied, then with any command line overrides applied last. For example:
```
❯ task _get rc.data.location
/$HOME/.task
```

##### `<attribute>`
Any task attribute. Note that no task ID or UUID is specified, so this variant
is only useful on the command line like this:
```
❯ task add "Pay rent" due:eom wait:'due - 3 days'
Created task 62.
```

Note the `due` is a DOM reference from earlier on the command line:
#####  `<id>.<attribute>`
Any attribute of the specified task ID. For example:
```
❯  task add Fix the leak depends:62 scheduled:62.due
Created task 63.
```
This makes the new task dependent on task 62, and scheduled on the due
date of task 3. Note that '3.due' is a DOM reference of a specific task.

#####  `<uuid>.<attribute>`
Any attribute of the specified task UUID, as above.
Any attribute that is of type `date` can be directly accessed as a date, or it
can be accessed by the elements of that date. For example:
- `<date>.year` The year, for example:
```
❯ task _get 62.due.year
2023
```
- `<date>.month` The month, for example:
```
❯ task _get 62.due.month
9
```

- `<date>.day` The day of the month, for example:
```
❯ task _get 62.due.day
30
```

- `<date>.week` The week number of the date, for example:
```
❯ task _get 62.due.week
39
```

- `<date>.weekday` The numbered weekday of the date,
where 0 is Sunday and 6 is Saturday. For Example
```
❯ task _get 62.due.weekday
6
```

- `<date>.julian` The Julian day of the date, which is the day
number of the date in the year. For example, January 1st is 1
February 10th is 41. For example
```
❯ task _get 62.due.julian
273
```

- `<date>.hour` The hour of the day, for example:
```
❯ task _get 62.due.hour
23
```

- `<date>.minute` The minute of the hour, for example:
```
❯ task _get 62.due.minute
59
```

- `<date>.second` The minute of the hour, for example:
```
❯ task _get 62.due.second
59
```

Tags can be accessed as a single item as an `<attribute>`, of the
individual tags can be accessed:
- `tags.<literal>` Direct access, per-tag. For example:
```
❯ task _get 61.tags.store
store
```

If the tag is present, it is shown, otherwise the result is blank, and
Taskwarrior exits with a non-zero status.
```
❯ task _get 61.tags.DUE
DUE
❯ task _get 61.tags.OVERDUE

```
Works for virtual tags too, in the same manner.

Annotations are compound data structures, with two elements, which are
`description` and `entry`. Annotations are accessed by an ordinal.
- `annotations.<N>.description` The description of the `Nth`
annotation, for example:
```
❯ task _get 61.annotations.0.description
```
- `annotations.<N>.entry` The creation `timestamp` of the `Nth`
annotation, for example:
```
❯ task _get 61.annotations.0.entry
```
Note that because `entry` is of type `date`, the individual elements
can be addressed, as above, for example:
```
❯ task _get 61.annotations.0.entry.year
```
UDA values can be accessed in the same manner.
