# Reports
Taskwarrior has three kinds of reports. There are built-in reports that cannot be
modified, such as `info` and `summary`. There are built-in reports which can be
redefined completely or eliminated, such as `list`, `next`. And finally there are
your own custom reports. To generate a list of **all** the reports, use the `reports`
command:
```
❯ task reports

Report           Description
active           Active tasks
all              All tasks
blocked          Blocked tasks
blocking         Blocking tasks
burndown.daily   Shows a graphical burndown chart, by day
burndown.monthly Shows a graphical burndown chart, by month
burndown.weekly  Shows a graphical burndown chart, by week
completed        Completed tasks
ghistory.annual  Shows a graphical report of task history, by year
ghistory.monthly Shows a graphical report of task history, by month
history.annual   Shows a report of task history, by year
history.monthly  Shows a report of task history, by month
information      Shows all data and metadata
list             Most details of tasks
long             All details of tasks
ls               Few details of tasks
minimal          Minimal details of tasks
newest           Newest tasks
next             Most urgent tasks
oldest           Oldest tasks
overdue          Overdue tasks
projects         Shows all project names used
ready            Most urgent actionable tasks
recurring        Recurring Tasks
summary          Shows a report of task status by project
tags             Shows a list of all tags used
unblocked        Unblocked tasks
waiting          Waiting (hidden) tasks

28 reports
```

## Built-In Static Reports
Typically, a report consists of a table of data, with one row of data corresponding
to a single task, with the task attributes represented as columns. But there are 
other reports which do not conform to this structure. Those are the built-in static
reports, and they are not modifiable, because they are quirky and require custom code.
These reports are:
```
burndown.daily
burndown.monthly
burndown.weekly
calendar
colors
export
ghistory.annual
ghistory.monthly
history.annual
history.monthly
information
summary
timesheet
```
Each of these reports takes non-standard arguments, may or may not support
filters, and generates distinctive output.

## Built-In Modifiable Reports
These reports are standard format, using standard arguments, and are also
modifiable
```
active
all
blocked
blocking
completed
list
long
ls
minimal
newest
next
oldest
overdue
ready
recurring
unblocked
waiting
```

Suppose you wanted to remove a column from one of these reports, for example
`tags` from the minimal report. First look at the existing columns and labels of the `minimal` report:

```
❯ task show report.minimal.labels

Config Variable       Value
report.minimal.labels ID,Project,Tags,Description
```

```
❯  task show report.minimal.columns

Config Variable        Value
report.minimal.columns id,project,tags.count,description.count
```
Having determined what the current values are, simply override with the new
values:
```
❯ task config report.minimal.labels 'ID,Project,Description'
Are you sure you want to add 'report.minimal.labels' with a value of 'ID,Project,Description'? (yes/no) y
Config file /home/tovar/.taskrc modified.


❯ task config report.minimal.columns 'id,project,description.count'
Are you sure you want to add 'report.minimal.columns' with a value of 'id,project,description.count'? (yes/no) y
Config file /home/tovar/.taskrc modified.


❯ task list

ID Active Age   Priority Project Tags          Due        Description                                                    Urgency
 6   4d    5d   M                setup                    Add taskwarrior script to add routine tasks                       8.73
12         2d   L        routine care mindset  2023-09-11 Meditate 15 at 8                                                     7
13         2d   L        routine care mindset  2023-09-11 Meditate 15 at 12                                                 6.92
19         1d                                  2023-09-12 Send Alice a birthday card                                        9.39
20         1d                                  2023-09-12 Send Alice a birthday card                                        9.39
14         2d   L        routine care mindset  2023-09-12 Meditate 15 at 4                                                  6.62
21         1d                                  2023-09-13 Send Alice a birthday card                                        8.93
22         1d                                  2023-09-16 Send Alice a birthday card                                        7.56
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
26         1h                                             foo [1]                                                            0.8
25         1h                                             Download ♬ ♩ for the plane                                           0
27         1h                                             bar                                                                  0
28         1h                                             baz                                                                  0
29        43min                                           foo bar                                                              0
15         2d   M        routine care workout             Cardio 20 Min                                                     0.81
16         2d   M        routine mindset                  Listen Alux                                                       0.71
17         2d   M        routine care                     Cold shower                                                       0.71
18         2d   M        routine education                Listen German                                                     0.71

27 tasks
```
You can think of the built-in modifiable reports as a set of default custom reports.

## Custom Reports
Defining a custom report is straightforward. You have control over the data 
shown, the sort order and the column labels. A custom report is simply a set of
configuration vales, and those vales include:
- description
- columns
- labels
- sort
- filter

Let us quickly create a custom report, which will be named `simple`. This report
will display the task `ID`, `project` name and `description`. We will need to gather the 
five settings listed above.

The description is the easiest, and in this case the report will be described:
`Simple list of open tasks by project`

This is just a descriptive label that will be used when the report is listed. Next we
need to specify the columns in the report, and the order in which those are
shown. Here the `_columns` helper command will show the columns available:
```
❯ task _columns
color
cost
depends
description
due
end
entry
id
imask
last
mask
modified
parent
priority
project
recur
rtype
scheduled
start
status
tags
template
until
urgency
uuid
wait
```
That represents all the data that Taskwarrior stores, and therefore all the data
that may be shown in a report. Our `simple`  report will show `id`, `project` and
`description`, which are all in the list. This means our column list is simply:
`id,project,description`

But there are also formats for each column, and the `columns` command shows
them, with examples. Here are the formats for our three columns:
```
❯ task columns id

Columns Type    Modifiable Supported Formats Example
id      numeric Read Only  number*           123
uuid    string  Read Only  long*             f30cb9c3-3fc0-483f-bfb2-3bf134f00694
                           short             f30cb9c3
<uda>   <type>  Modifiable default*
                           indicator

* Means default format, and therefore optional.  For example, 'due' and 'due.formatted' are equivalent.

```
This is easy, because there is only one `id` format

```
❯ task columns project

Columns Type   Modifiable Supported Formats Example
project string Modifiable full*             home.garden
                          parent            home
                          indented            home.garden
<uda>   <type> Modifiable default*
                          indicator

* Means default format, and therefore optional.  For example, 'due' and 'due.formatted' are equivalent.
```

There are three formats for the `project` column, and the default, `full` is the
one we want.

```
❯ task columns description

Columns     Type   Modifiable Supported Formats Example
description string Modifiable combined*         Move your clothes down on to the lower peg
                                                  2023-09-13 Immediately before your lunch
                                                  2023-09-13 If you are playing in the match this afternoon
                                                  2023-09-13 Before you write your letter home
                                                  2023-09-13 If you're not getting your hair cut
                              desc              Move your clothes down on to the lower peg
                              oneline           Move your clothes down on to the lower peg 2023-09-13 Immediately before your lunch 2023-09-13 If you are playing in the match this afternoon
                                                2023-09-13 Before you write your letter home 2023-09-13 If you're not getting your hair cut
                              truncated         Move your clothes do...
                              count             Move your clothes down on to the lower peg [4]
                              truncated_count   Move your clothes do... [4]
<uda>       <type> Modifiable default*
                              indicator

* Means default format, and therefore optional.  For example, 'due' and 'due.formatted' are equivalent.
```

There are five formats for description. This time we prefer the `count` format, so
our columns list is now:
`id,project,description.count`

Labels are the column heading labes in the report. There are defaults, but we 
wish to specify these like this:
`ID,Proj,Desc`

Sorting is also straightforward, and we want the tasks sorted by project, and then
by entry, which is the creation date for a task. This illustrates that a task attribute
that is not visible can be used in the sort. The sort order is then:
`project+/,entry+`

The `+` means an ascending oreder, but we could heave used `-` for descending.
The `/` solidus indicates that project is a break column, which means a blank 
line is inserted between unique values, for a visual grouping effect.

Finally, we need a filter, otherwise our report will just display all tasks, which is
rarely wanted. Here we wish to see only pending tasks, and that means the filter is:
`status:pending`

Now we have our report definition, so we just create the five configuration entries 
like this:
```
❯ task config report.simple.description 'Simple list of open tasks by project'
❯ task config report.simple.columns 'id,project,description.count'
❯ task config report.simple.labels 'ID,Proj,Desc'
❯ task config report.simple.sort 'project+/,entry+'
❯ task config report.simple.filter 'status:pending'
```

Note the equivalent report directly from the configurations file would look like that:
```
report.simple.description=Simple list of open tasks by project
report.simple.columns=id,project,description.count
report.simple.labels=ID,Proj,Desc
report.simple.sort=project+\/,entry+
report.simple.filter=status:pending
```

And it is finished. Run the report like this:
```
❯ task simple

ID Proj    Desc
 1         prepare a german speech
 7         set an special tmux script for task warrior
 2         Grind the portfolio until 1:43:00
 3         Grind the Usage Examples section of Taskwarrior docs [1]
 4         review the written taskwarrior to specify the .taskrc file
 5         review the written taskwarrior to specify the .taskrc file
 6         Add taskwarrior script to add routine tasks
 8         Cook lunch
 9         Meditation 20 min at 12
10         Meditation 20 min at 4
11         clean the workspace up
19         Send Alice a birthday card
20         Send Alice a birthday card
21         Send Alice a birthday card
22         Send Alice a birthday card
25         Download ♬ ♩ for the plane
26         foo [1]
27         bar
28         baz
29         foo bar

12 routine Meditate 15 at 8
13 routine Meditate 15 at 12
14 routine Meditate 15 at 4
15 routine Cardio 20 Min
16 routine Listen Alux
17 routine Cold shower
18 routine Listen German

27 tasks

```

Custom reports also show up in the help output:
```
❯ task help | grep simple
       task <filter> simple                Simple list of open tasks by project
```

I can inspect the configuration:
```
❯ task show report.simple

Config Variable           Value
report.simple.columns     id,project,description.count
report.simple.description Simple list of open tasks by project
report.simple.filter      status:pending
report.simple.labels      ID,Proj,Desc
report.simple.sort        project+/,entry+

Some of your .taskrc variables differ from the default values.
  These are highlighted in color above.
```

Now the report is fully configured, it joins the other and is used in the same way.
