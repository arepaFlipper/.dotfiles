# Task_Warrior: Task Manager lessons

- Add a new task:
```
❯ task add get milk
Created task 1.
```
- List all tasks:
```
❯ task list

ID Age   Description  Urg
 1 13s   get milk        0

1 task
```

- Delete a task:
```
❯ task delete 1
```


```
❯ task list
No matches.
Recently upgraded to 2.6.0. Please run 'task news' to read highlights about the new release.
```

Add a new task:
```
❯ task add "buy milk"
Created task 1.
```

Add a new task:
```
❯ task add "buy eggs"
Created task 2.
```

Add a new task:
```
❯ task add "bake cake"
Created task 3.
```

List all tasks:
```
❯ task list

ID Age   Description   Urg
 1 26s   buy milk         0
 2 16s   buy eggs         0
 3  8s   bake cake        0

3 tasks
```

Details about a task:
```
❯ task 1

Name          Value
ID            1
Description   buy milk
Status        Pending
Entered       2023-08-21 13:03:30 (40s)
Last modified 2023-08-21 13:03:30 (40s)
Virtual tags  PENDING READY UNBLOCKED
UUID          9eb8ea44-60a1-4cf5-a215-491f63085f9f
Urgency          0
```

The taskwarrior configuration file is .taskrc
Edit details about a task:
```
❯ task 1 edit

```

Add annotations to a task:
```
❯ task 1 annotate "buy 2% milk"
Annotating task 1 'buy milk'.
Annotated 1 task.
```

Check the effects of the annotation into the task details:
```
❯ task 1 edit
Launching 'NVIM_APPNAME=LazyVim nvim "task.9eb8ea44.task"' now...
Editing complete.
No edits were detected.
```

List all tasks, and see the effects of the annotation:
```
❯ task list

ID Age   Description   Urg
 1 38min buy milk [1]   0.8
 2 38min buy eggs         0
 3 38min bake cake        0

3 tasks
```

Detail the task, and see the effects of the annotation:
```
❯ task 1

Name          Value
ID            1
Description   buy milk
                2023-08-21 13:41:49 buy 2% milk
Status        Pending
Entered       2023-08-21 13:03:30 (39min)
Last modified 2023-08-21 13:41:49 (1min)
Virtual tags  ANNOTATED PENDING READY UNBLOCKED
UUID          9eb8ea44-60a1-4cf5-a215-491f63085f9f
Urgency        0.8

    annotations    0.8 *    1 =    0.8
                                ------
                                   0.8

Date                Modification
2023-08-21 13:41:49 Annotation of 'buy 2% milk' added.
```

## Lesson 3: Linking Tasks & Setting Projects
Detail the 3rd task:
```
Name          Value
ID            3
Description   bake cake
Status        Pending
Entered       2023-08-21 13:03:48 (48min)
Last modified 2023-08-21 13:03:48 (48min)
Virtual tags  LATEST PENDING READY UNBLOCKED
UUID          19f619d8-9951-4457-bf9a-8f7571528095
Urgency          0
```

Modify the priority of the 3rd task to high priority:
```
❯ task 3 modify priority:H
Modifying task 3 'bake cake'.
Modified 1 task.
```

When we see the details of the 3rd task, 
we see that the priority is set to high, 
and it scores the level of urgency to 6:
```
❯ task 3

Name          Value
ID            3
Description   bake cake
Status        Pending
Entered       2023-08-21 13:03:48 (48min)
Last modified 2023-08-21 13:52:36 (9s)
Virtual tags  LATEST PENDING PRIORITY READY UDA UNBLOCKED
UUID          19f619d8-9951-4457-bf9a-8f7571528095
Urgency          6
Priority      H

    UDA priority.H      1 *    6 =      6
                                   ------
                                        6

Date                Modification
2023-08-21 13:52:36 Priority set to 'H'.
```

When we list tasks:
```
❯ task list

ID Age   P Description   Urg
 3 52min H bake cake        6
 1 52min   buy milk [1]   0.8
 2 52min   buy eggs         0

3 tasks
```

Then we set a task dependency by:
```
❯ task 3 modify depends:2
Modifying task 3 'bake cake'.
Modified 1 task.
```

List all tasks, to see the effect of the dependency:
```
❯ task list

ID Age   D P Description   Urg
 2 56min     buy eggs         8
 3 56min D H bake cake        1
 1 56min     buy milk [1]   0.8

3 tasks
```
The lines of the output above are going to be highlighted
in white (the task that we perform first) and 
grey (the task that we cannot perform until white is done).

Now if we check the details on the edit file of the 3rd task, 
we see that the dependency has been set, and the task and the 
dependency section, there is a link pointing to the 2nd task:
```
❯ task 3 edit
Launching 'NVIM_APPNAME=LazyVim nvim "task.19f619d8.task"' now...
...
  Annotation:        2023-08-21 14:05:40 -- 
# Dependencies should be a comma-separated list of task IDs/UUIDs or ID ranges, with no spaces.
  Dependencies:      2
# User Defined Attributes
...
```

Let's add an extra dependency to the 3rd task:
```
❯ task 3 modify depends:1
Modifying task 3 'bake cake'.
Modified 1 task.
```

See the effects of the dependency:
```
❯ task 3 edit
Launching 'NVIM_APPNAME=LazyVim nvim "task.19f619d8.task"' now...
...
  Annotation:        2023-08-21 14:05:40 -- 
# Dependencies should be a comma-separated list of task IDs/UUIDs or ID ranges, with no spaces.
  Dependencies:      2,1
# User Defined Attributes
...
```
So the above means that the 3rd task depends on the 1st and 2nd tasks
to be completed.

Now let's take a look at projects,
let's add a new project by adding a label a 
task to an specified project:
```
❯ task 3 modify project:party
Modifying task 3 'bake cake'.
Modified 1 task.
The project 'party' has changed.  Project 'party' is 0% complete (1 task remaining).
```

If we list tasks to see the effects of the recently changed:
```
❯ task list

ID Age  D P Project Description   Urg
 1 1h               buy milk [1]   8.8
 2 1h               buy eggs         8
 3 1h   D H party   bake cake        2

3 tasks
```
We can notice that the 3rd task is now assigned party project
by seeing the project column in the details of the 3rd task.

We can also add multiple tasks to a project:
```
❯ task 1 2 modify project:grocery
This command will alter 2 tasks.
Modifying task 1 'buy milk'.
Modifying task 2 'buy eggs'.
Modified 2 tasks.
The project 'grocery' has changed.  Project 'grocery' is 0% complete (2 of 2 tasks remaining).
```

List all tasks to see the effects of the recently changed:
```
❯ task list

ID Age  D P Project Description   Urg
 1 1h       grocery buy milk [1]   9.8
 2 1h       grocery buy eggs         9
 3 1h   D H party   bake cake        2

3 tasks
```

## Lesson 4: Miscellaneous Commands & Tags

Use the calculator:
```
❯ task calc 2+5
7
```

Display a calendar:

```
❯ task calendar

        August 2023             September 2023             October 2023              November 2023             December 2023             January 2024              February 2024

     Su Mo Tu We Th Fr Sa      Su Mo Tu We Th Fr Sa      Su Mo Tu We Th Fr Sa      Su Mo Tu We Th Fr Sa      Su Mo Tu We Th Fr Sa      Su Mo Tu We Th Fr Sa      Su Mo Tu We Th Fr Sa
  31        1  2  3  4  5   35                 1  2   40  1  2  3  4  5  6  7   44           1  2  3  4   48                 1  2    1     1  2  3  4  5  6    5              1  2  3
  32  6  7  8  9 10 11 12   36  3  4  5  6  7  8  9   41  8  9 10 11 12 13 14   45  5  6  7  8  9 10 11   49  3  4  5  6  7  8  9    2  7  8  9 10 11 12 13    6  4  5  6  7  8  9 10
  33 13 14 15 16 17 18 19   37 10 11 12 13 14 15 16   42 15 16 17 18 19 20 21   46 12 13 14 15 16 17 18   50 10 11 12 13 14 15 16    3 14 15 16 17 18 19 20    7 11 12 13 14 15 16 17
  34 20 21 22 23 24 25 26   38 17 18 19 20 21 22 23   43 22 23 24 25 26 27 28   47 19 20 21 22 23 24 25   51 17 18 19 20 21 22 23    4 21 22 23 24 25 26 27    8 18 19 20 21 22 23 24
  35 27 28 29 30 31         39 24 25 26 27 28 29 30   44 29 30 31               48 26 27 28 29 30         52 24 25 26 27 28 29 30    5 28 29 30 31             9 25 26 27 28 29
                                                                                                          52 31

Legend: today, weekend, due, due-today, overdue, scheduled, weeknumber.

```

Export tasks to JSON format:

```
❯ task export
[
{"id":1,"description":"buy milk","entry":"20230821T180330Z","modified":"20230821T191646Z","project":"grocery","status":"pending","uuid":"9eb8ea44-60a1-4cf5-a215-491f63085f9f","annotations":[{"entry":"20230821T184149Z","description":"buy 2% milk"}],"urgency":9.8},
{"id":2,"description":"buy eggs","entry":"20230821T180340Z","modified":"20230821T191646Z","project":"grocery","status":"pending","uuid":"28ecb42d-b172-4ac6-b2dd-898aab89d262","urgency":9},
{"id":3,"description":"bake cake","entry":"20230821T180348Z","modified":"20230821T191559Z","priority":"H","project":"party","status":"pending","uuid":"19f619d8-9951-4457-bf9a-8f7571528095","depends":["28ecb42d-b172-4ac6-b2dd-898aab89d262","9eb8ea44-60a1-4cf5-a215-491f63085f9f"],"urgency":2},
{"id":0,"description":"buy milk","end":"20230821T180251Z","entry":"20230821T180138Z","modified":"20230821T180253Z","status":"deleted","uuid":"c99b4c15-9b70-45e3-aac5-3b15afe9f236","urgency":0},
{"id":0,"description":"buy eggs","end":"20230821T180244Z","entry":"20230821T180149Z","modified":"20230821T180247Z","status":"deleted","uuid":"ffef9144-98ae-41ce-a037-6b1a877f4da0","urgency":0},
{"id":0,"description":"bake cake","end":"20230821T180219Z","entry":"20230821T180158Z","modified":"20230821T180221Z","status":"deleted","uuid":"31a109a3-ad0c-4029-8379-da332367ee0e","urgency":0},
{"id":0,"description":"bake cake","end":"20230821T180237Z","entry":"20230821T180228Z","modified":"20230821T180239Z","status":"deleted","uuid":"d0de7ba3-4d43-4a78-9671-914713b849a9","urgency":0},
{"id":0,"description":"get milk","end":"20230821T175922Z","entry":"20230821T175246Z","modified":"20230821T175927Z","status":"deleted","uuid":"02f8ffad-e263-49e5-9446-999660f07acf","urgency":0}
]
```

Export tasks to JSON format into file:

```
❯ task export > backup.txt
```

See the current state of the list:

```
❯ task list

ID Age  D P Project Description   Urg
 1 3h       grocery buy milk [1]   9.8
 2 3h       grocery buy eggs         9
 3 3h   D H party   bake cake        2

3 tasks
```

Append text into the 3rd task message:

```
❯ task 3 append MUST
Appending to task 3 'bake cake MUST'.
Appended 1 task.
Project 'party' is 0% complete (1 task remaining).
```

See the effects of the appended text on the list:

```
❯ task list

ID Age  D P Project Description        Urg
 1 3h       grocery buy milk [1]        9.8
 2 3h       grocery buy eggs              9
 3 3h   D H party   bake cake MUST        2

3 tasks
```

Undo the last modification:

```
❯ task undo

The last modification was made 2023-08-21

                                          Prior Values                                                               Current Values
dep_28ecb42d-b172-4ac6-b2dd-898aab89d262  x                                                                          x
dep_9eb8ea44-60a1-4cf5-a215-491f63085f9f  x                                                                          x
depends                                   28ecb42d-b172-4ac6-b2dd-898aab89d262,9eb8ea44-60a1-4cf5-a215-491f63085f9f  28ecb42d-b172-4ac6-b2dd-898aab89d262,9eb8ea44-60a1-4cf5-a215-491f63085f9f
description                               bake cake                                                                  bake cake MUST
entry                                     2023-08-21                                                                 2023-08-21
modified                                  2023-08-21                                                                 2023-08-21
priority                                  H                                                                          H
project                                   party                                                                      party
status                                    pending                                                                    pending
uuid                                      19f619d8-9951-4457-bf9a-8f7571528095                                       19f619d8-9951-4457-bf9a-8f7571528095

The undo command is not reversible.  Are you sure you want to revert to the previous state? (yes/no) yes
Modified task reverted.
```
As you can see in the output above, it display the previous state of the task and compare it with the current state
to see the changes that are going to be applied.

Append text into the 3rd task message:

```
❯ task 3 append for Joe
Appending to task 3 'bake cake for Joe'.
Appended 1 task.
Project 'party' is 0% complete (1 task remaining).
❯ task list

ID Age  D P Project Description           Urg
 1 3h       grocery buy milk [1]           9.8
 2 3h       grocery buy eggs                 9
 3 3h   D H party   bake cake for Joe        2

3 tasks
```

We also can prepend texts into message:
```
❯ task 3 prepend MUST
Prepending to task 3 'MUST bake cake for Joe'.
Prepended 1 task.
Project 'party' is 0% complete (1 task remaining).
```

Let's see the current state of the list:
```
❯ task list

ID Age  D P Project Description                Urg
 1 4h       grocery buy milk [1]                9.8
 2 4h       grocery buy eggs                      9
 3 4h   D H party   MUST bake cake for Joe        2

3 tasks
```

Now, check what is the option `projects` for:
```
❯ task projects

Project Tasks
grocery     2
party       1

2 projects (3 tasks)
```
It display the projects tags in the list.

The `log` allows you to add a task that's already in 
`completed` state:
```
❯ task log get birthday card
```

So if we see the current state of the list:
```
❯ task

ID Age  Deps P Project Description              Urg
 1 4h          grocery buy milk                  9.8
                         2023-08-21 buy 2% milk
 2 4h          grocery buy eggs                    9
 3 4h   1 2  H party   MUST bake cake for Joe      2

3 tasks
```
There is no view of `get birthday card` task. But
if we check into:
```
❯ task completed

ID UUID     Created    Completed  Age   Description
 - a22ae088 2023-08-21 2023-08-21 45s   get birthday card

1 task
```
The `completed` task display the task that are in that 
state.

Now we can also see the details to a task by its ID:
```
❯ task a22ae088

Name          Value
ID            -
Description   get birthday card
Status        Completed
Entered       2023-08-21 17:11:51 (10min)
End           2023-08-21 17:11:51
Last modified 2023-08-21 17:11:51 (10min)
Virtual tags  COMPLETED UNBLOCKED
UUID          a22ae088-265b-41e2-8df2-61fb05640616
Urgency          0
```

We can even modify a completed task by its ID:
```
❯ task a22ae088 modify project:party
Modifying task a22ae088 'get birthday card'.
Modified 1 task.
Note: Modified task a22ae088 is completed. You may wish to make this task pending with: task a22ae088 modify status:pending
The project 'party' has changed.  Project 'party' is 50% complete (1 of 2 tasks remaining).
```

Now, `TaskWarrior` also provides of set of functionalities to generate reports
like `timesheet`:
```
❯ task timesheet

Wk  Date       Day ID       Action    Project Due Task
W34 2023-08-21 Mon a22ae088 Completed party       get birthday card

1 completed, 0 started.
```

The `ghistory` allows you to see a report of each state of the tasks:
```
❯ task ghistory

Year Month  Number Added/Completed/Deleted
2023 August                                                                                                         9          1                                                         5

Legend: Added, Completed, Deleted

```

We can generate reports by week as well:
```
❯ task ghistory.weekly

Year Month  Day Number Added/Completed/Deleted
2023 August  20                                                                                                      9          1                                                        5

Legend: Added, Completed, Deleted

```

The `history` option display the same information but in kind of like
Excel spreadsheet format:
```
❯ task history

Year Month   Added Completed Deleted Net
2023 August      9         1       5   3

     Average     9         1       5   3

```

To see a bar-chart report:
```
❯ task burndown.daily

                                                                                        Daily Burndown
6 |
  |
  |
  |
  |                                                                                                                                                                                    Done
  |                                                                                                                                                                                    Started
3 |                                                                                                                                                                                    Pending
  |
  |
  |
  |
  |
  |
0 +-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    25 26 27 28 29 30 01 02 03 04 05 06 07 08 09 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 01 02 03 04 05 06 07 08 09 10 11 12 13 14 15 16 17 18 19 20 21
    Jun               Jul                                                                                          Aug

 Net Fix Rate:         -
 Estimated completion: No convergence
```

To see all available options:
```
❯ task show
```

There is a way to set the task we are working on,
first let's display the our current tasks list we are working on:
```
❯ task active
No matches.
```

Let's say that we are going to start to work on the 1st task:
```
❯ task 1 start
Starting task 1 'buy milk'.
Started 1 task.
Project 'grocery' is 0% complete (2 of 2 tasks remaining).
```

Now, let's see the current state of `active` task:
```
❯ task active

ID Started    Active Age  Project Description
 1 2023-08-21   8s   4h   grocery buy milk
                                    2023-08-21 buy 2% milk

1 task
```

Now, start to work on the 2nd task, as well:
```
❯ task 2 start
Starting task 2 'buy eggs'.
Started 1 task.
You have more urgent tasks.
Project 'grocery' is 0% complete (2 of 2 tasks remaining).
```

We have two tasks working on:
```
❯ task active

ID Started    Active Age  Project Description
 1 2023-08-21  26s   4h   grocery buy milk
                                    2023-08-21 buy 2% milk
 2 2023-08-21   2s   4h   grocery buy eggs

2 tasks
```

See the current state of the list:
```
❯ task list

ID Active Age  D P Project Description                Urg
 2   7min 4h       grocery buy eggs                     13
 1   7min 4h       grocery buy milk [1]               13.8
 3        4h   D H party   MUST bake cake for Joe        2

3 tasks
```
There are only 3 task on list

We can duplicate a task by running:
```
❯ task 3 duplicate
Duplicated task 3 'MUST bake cake for Joe'.
Created task 4.
Duplicated 1 task.
The project 'party' has changed.  Project 'party' is 33% complete (2 of 3 tasks remaining).
```

Now we have 4 tasks:
```
❯ task list

ID Active Age   D P Project Description                Urg
 2   8min  4h       grocery buy eggs                     13
 1   8min  4h       grocery buy milk [1]               13.8
 3         4h   D H party   MUST bake cake for Joe        2
 4        11s   D H party   MUST bake cake for Joe        2

4 tasks
```

Brute edit a task to make a Cake for Sally:
```
❯ task 4 edit
Launching 'NVIM_APPNAME=LazyVim nvim "task.c7777110.task"' now...
Editing complete.
Edits were detected.
Description modified.
```
```
❯ task list

ID Active Age  D P Project Description                  Urg
 2   8min 4h       grocery buy eggs                       13
 1   9min 4h       grocery buy milk [1]                 13.8
 3        4h   D H party   MUST bake cake for Joe          2
 4        1min D H party   MUST bake cake for Sally        2

4 tasks
```

Modify the 3rd task:
```
❯ task 3 modify tag:joe
Modifying task 3 'MUST bake cake for Joe'.
Modified 1 task.
Project 'party' is 33% complete (2 of 3 tasks remaining).
❯ task 4 modify tag:sally
Modifying task 4 'MUST bake cake for Sally'.
Modified 1 task.
Project 'party' is 33% complete (2 of 3 tasks remaining).
```

```
❯ task list

ID Active Age  D P Project Tags  Description                  Urg
 2  10min 4h       grocery       buy eggs                       13
 1  10min 4h       grocery       buy milk [1]                 13.8
 3        4h   D H party   joe   MUST bake cake for Joe        2.8
 4        2min D H party   sally MUST bake cake for Sally      2.8

4 tasks
```

Modify the 1st and 2nd task (this does not work properly):
```
❯ task 1 2 modify tag: joe sally
This command will alter 2 tasks.
Modifying task 1 'joe sally'.
Modifying task 2 'joe sally'.
Modified 2 tasks.
Project 'grocery' is 0% complete (2 of 2 tasks remaining).
```
The space character ` ` between the colon `:` and the tag `joe`
break the command:
```
❯ task list

ID Active Age  D P Project Tags  Description                  Urg
 2  11min 4h       grocery       joe sally                      13
 1  12min 4h       grocery       joe sally [1]                13.8
 3        4h   D H party   joe   MUST bake cake for Joe        2.8
 4        3min D H party   sally MUST bake cake for Sally      2.8

4 tasks
```
Let's undo the last modification:
```
❯ task undo

The last modification was made 2023-08-21

             Prior Values                          Current Values
description  buy eggs                              joe sally
entry        2023-08-21                            2023-08-21
modified     2023-08-21                            2023-08-21
project      grocery                               grocery
start        2023-08-21                            2023-08-21
status       pending                               pending
uuid         28ecb42d-b172-4ac6-b2dd-898aab89d262  28ecb42d-b172-4ac6-b2dd-898aab89d262

The undo command is not reversible.  Are you sure you want to revert to the previous state? (yes/no) y
Modified task reverted.
```
The undo performs only once on each task:
```
❯ task list

ID Active Age  D P Project Tags  Description                  Urg
 2  12min 4h       grocery       buy eggs                       13
 1  12min 4h       grocery       joe sally [1]                13.8
 3        4h   D H party   joe   MUST bake cake for Joe        2.8
 4        4min D H party   sally MUST bake cake for Sally      2.8

4 tasks


❯ task undo

The last modification was made 2023-08-21

                       Prior Values                          Current Values
annotation_1692643309  buy 2% milk                           buy 2% milk
description            buy milk                              joe sally
entry                  2023-08-21                            2023-08-21
modified               2023-08-21                            2023-08-21
project                grocery                               grocery
start                  2023-08-21                            2023-08-21
status                 pending                               pending
uuid                   9eb8ea44-60a1-4cf5-a215-491f63085f9f  9eb8ea44-60a1-4cf5-a215-491f63085f9f

The undo command is not reversible.  Are you sure you want to revert to the previous state? (yes/no) y
Modified task reverted.


❯ task list

ID Active Age  D P Project Tags  Description                  Urg
 2  12min 4h       grocery       buy eggs                       13
 1  12min 4h       grocery       buy milk [1]                 13.8
 3        4h   D H party   joe   MUST bake cake for Joe        2.8
 4        4min D H party   sally MUST bake cake for Sally      2.8

4 tasks
```
This time we try removing the space character ` ` between the colon
and the tag `joe`:
```
❯ task 1 2 modify tag:joe sally
This command will alter 2 tasks.
Modifying task 1 'sally'.
Modifying task 2 'sally'.
Modified 2 tasks.
Project 'grocery' is 0% complete (2 of 2 tasks remaining).
```
It only adds the tag `joe`:
```
❯ task list

ID Active Age  D P Project Tags  Description                  Urg
 2  12min 4h       grocery joe   sally                        13.8
 1  13min 4h       grocery joe   sally [1]                    14.6
 3        4h   D H party   joe   MUST bake cake for Joe        2.8
 4        5min D H party   sally MUST bake cake for Sally      2.8

4 tasks
```
```
❯ task undo

The last modification was made 2023-08-21

             Prior Values                          Current Values
description  buy eggs                              sally
entry        2023-08-21                            2023-08-21
modified     2023-08-21                            2023-08-21
project      grocery                               grocery
start        2023-08-21                            2023-08-21
status       pending                               pending
uuid         28ecb42d-b172-4ac6-b2dd-898aab89d262  28ecb42d-b172-4ac6-b2dd-898aab89d262
tags                                               joe
tags_joe                                           x

The undo command is not reversible.  Are you sure you want to revert to the previous state? (yes/no) y
Modified task reverted.
```
```
❯ task undo

The last modification was made 2023-08-21

                       Prior Values                          Current Values
annotation_1692643309  buy 2% milk                           buy 2% milk
description            buy milk                              sally
entry                  2023-08-21                            2023-08-21
modified               2023-08-21                            2023-08-21
project                grocery                               grocery
start                  2023-08-21                            2023-08-21
status                 pending                               pending
uuid                   9eb8ea44-60a1-4cf5-a215-491f63085f9f  9eb8ea44-60a1-4cf5-a215-491f63085f9f
tags                                                         joe
tags_joe                                                     x

The undo command is not reversible.  Are you sure you want to revert to the previous state? (yes/no) y
Modified task reverted.
```
We add them one by one:
```
❯ task list

ID Active Age  D P Project Tags  Description                  Urg
 2  13min 4h       grocery       buy eggs                       13
 1  13min 4h       grocery       buy milk [1]                 13.8
 3        4h   D H party   joe   MUST bake cake for Joe        2.8
 4        5min D H party   sally MUST bake cake for Sally      2.8

4 tasks
❯ task 1 2 modify tag:joe
This command will alter 2 tasks.
Modifying task 1 'buy milk'.
Modifying task 2 'buy eggs'.
Modified 2 tasks.
Project 'grocery' is 0% complete (2 of 2 tasks remaining).
❯ task list

ID Active Age  D P Project Tags  Description                  Urg
 2  14min 4h       grocery joe   buy eggs                     13.8
 1  14min 4h       grocery joe   buy milk [1]                 14.6
 3        4h   D H party   joe   MUST bake cake for Joe        2.8
 4        6min D H party   sally MUST bake cake for Sally      2.8

4 tasks
```
```
❯ task 1 2 modify tag:sally
This command will alter 2 tasks.
Modifying task 1 'buy milk'.
Modifying task 2 'buy eggs'.
Modified 2 tasks.
Project 'grocery' is 0% complete (2 of 2 tasks remaining).
❯ task list

ID Active Age  D P Project Tags  Description                  Urg
 2  14min 4h       grocery sally buy eggs                     13.8
 1  14min 4h       grocery sally buy milk [1]                 14.6
 3        4h   D H party   joe   MUST bake cake for Joe        2.8
 4        6min D H party   sally MUST bake cake for Sally      2.8

4 tasks
```
But the right way to do it is by separating the tags with a comma `,`:
```
❯ task 1 2 modify tag:sally,joe
This command will alter 2 tasks.
Modifying task 1 'buy milk'.
Modifying task 2 'buy eggs'.
Modified 2 tasks.
Project 'grocery' is 0% complete (2 of 2 tasks remaining).
```
This is the expected output:
```
❯ task list

ID Active Age  D P Project Tags      Description                  Urg
 2  14min 4h       grocery joe sally buy eggs                     13.9
 1  15min 4h       grocery joe sally buy milk [1]                 14.7
 3        4h   D H party   joe       MUST bake cake for Joe        2.8
 4        6min D H party   sally     MUST bake cake for Sally      2.8

4 tasks
```

We can edit multiple task on one command,
but what the following command is going to do is
arrange an stack of tasks to edit one by one on 
the EDITOR:
```
❯ task 1 2 edit
Launching 'NVIM_APPNAME=LazyVim nvim "task.9eb8ea44.task"' now...
Editing complete.
Edits were detected.
Launching 'NVIM_APPNAME=LazyVim nvim "task.28ecb42d.task"' now...
Editing complete.
Edits were detected.
```
```
❯ task list

ID Active Age  D P Project Tags       Description                  Urg
 2  16min 4h       grocery Tester baz buy eggs                     13.9
 1  16min 4h       grocery Bar Foo    buy milk [1]                 14.7
 3        4h   D H party   joe        MUST bake cake for Joe        2.8
 4        8min D H party   sally      MUST bake cake for Sally      2.8

4 tasks

```

To display the tags used along our tasks:
```
❯ task tags

Tag    Count
Bar        1
Foo        1
Tester     1
baz        1
joe        1
sally      1


6 tags
(4 tasks)
```

## Lesson 5

Check the current list:
```
❯ task completed

ID UUID     Created    Completed  Age  Project Description
 - a22ae088 2023-08-21 2023-08-21 1h   party   get birthday card

1 task
```
We want the list empty

We also can delete by ID as well:
```
❯ task delete a22ae088
Delete task a22ae088 'get birthday card'? (yes/no) yes
Deleting task a22ae088 'get birthday card'.
Deleted 1 task.
Note: Modified task a22ae088 is completed. You may wish to make this task pending with: task a22ae088 modify status:pending
The project 'party' has changed.  Project 'party' is 0% complete (2 of 2 tasks remaining).

```

Check the projects list out:
```
❯ task projects

Project Tasks
grocery     2
party       2

2 projects (4 tasks)
```

We may an entire project and the tasks associated with
by running:
```

❯ task delete grocery
This command has no filter, and will modify all (including completed and deleted) tasks.  Are you sure? (yes/no) yes
This command will alter 10 tasks.
Delete task 1 'buy milk'? (yes/no/all/quit) y
Deleting task 1 'buy milk'.

Delete task 2 'buy eggs'? (yes/no/all/quit) y
Deleting task 2 'buy eggs'.
Unblocked 3 'MUST bake cake for Joe'.
Unblocked 4 'MUST bake cake for Sally'.

Delete task 3 'MUST bake cake for Joe'? (yes/no/all/quit) y
Deleting task 3 'MUST bake cake for Joe'.

Delete task 4 'MUST bake cake for Sally'? (yes/no/all/quit) y
Deleting task 4 'MUST bake cake for Sally'.
Task c99b4c15 'buy milk' is not deletable.
Task ffef9144 'buy eggs' is not deletable.
Task 31a109a3 'bake cake' is not deletable.
Task d0de7ba3 'bake cake' is not deletable.
Task 02f8ffad 'get milk' is not deletable.
Task a22ae088 'get birthday card' is not deletable.
Deleted 4 tasks.
The project 'grocery' has changed.  Project 'grocery' is 0% complete (0 of 0 tasks remaining).
The project 'party' has changed.  Project 'party' is 0% complete (0 of 0 tasks remaining).
```
```
❯ task list
No matches.
```
```
❯ task projects
No projects.
```

Now add a task:
```
❯ task add "bake cake for joe"
Created task 1.
```
```
❯ task list

ID Age   Description           Urg
 1 17s   bake cake for joe        0

1 task
```
```
❯ source ~/.zshrc
```
```
❯ task list

ID Age  Description           Urg
 1 2min bake cake for joe        0

1 task
```

We can use the aliases bash functionality to create a shortcut
for `task add` command
```
❯ tn "bake cake for sally"
Created task 2.
```
```
❯ task list

ID Age   Description             Urg
 1  3min bake cake for joe          0
 2 10s   bake cake for sally        0

2 tasks
```
Refresh the .zshrc file:
```
❯ source ~/.zshrc
```

This alias `tl` is actually used by `tmux` to list all sessions:
```
❯ tl
dotfiles: 1 windows (created Mon Aug 21 16:52:03 2023) (attached)
```

Refresh the .zshrc file:
```
❯ source ~/.zshrc
```

Alias `twl` to shortcut for `task list`:
```
❯ twl

ID Age  Description             Urg
 1 4min bake cake for joe          0
 2 1min bake cake for sally        0

2 tasks
```

```
❯ tn "buy eggs"
Created task 3.
```

```
❯ tn "buy milk"
Created task 4.
```
```
❯ twl

ID Age   Description             Urg
 1  6min bake cake for joe          0
 2  2min bake cake for sally        0
 3 13s   buy eggs                   0
 4  6s   buy milk                   0

4 tasks
```
```
❯ source ~/.zshrc
```

Now `tproj` is a shortcut for `task modify project:<arg>`
```
❯ tproj 1 joe
Modifying task 1 'bake cake for joe'.
Modified 1 task.
The project 'joe' has changed.  Project 'joe' is 0% complete (1 task remaining).
```

```
❯ twl

ID Age  Project Description             Urg
 2 5min         bake cake for sally        0
 3 2min         buy eggs                   0
 4 2min         buy milk                   0
 1 8min joe     bake cake for joe          1

4 tasks
```

```
❯ tproj 2 sally
Modifying task 2 'bake cake for sally'.
Modified 1 task.
The project 'sally' has changed.  Project 'sally' is 0% complete (1 task remaining).
```

```
❯ twl

ID Age  Project Description             Urg
 3 3min         buy eggs                   0
 4 3min         buy milk                   0
 1 9min joe     bake cake for joe          1
 2 6min sally   bake cake for sally        1

4 tasks
```

Let's modify the tag of the 3rd task:
```
❯ task 3 modify tag:"Dactyl Manuform"
Modifying task 3 'buy eggs'.
Modified 1 task.
```

```
❯ twl

ID Age   Project Tags            Description             Urg
 3  5min         Dactyl Manuform buy eggs                 0.8
 4  5min                         buy milk                   0
 1 11min joe                     bake cake for joe          1
 2  7min sally                   bake cake for sally        1

4 tasks
```

```
❯ source ~/.zshrc
```

Now `ttag` is a shortcut for `task modify tag:<arg>`
```
❯ ttag 4 Dactyl Manuform Keyboard
Modifying task 4 'buy milk'.
Modified 1 task.
```

```
❯ twl

ID Age   Project Tags                     Description             Urg
 3  9min         Dactyl Manuform          buy eggs                 0.8
 4  9min         Dactyl Manuform Keyboard buy milk                 0.8
 1 15min joe                              bake cake for joe          1
 2 11min sally                            bake cake for sally        1

4 tasks
```
### Corrections

```
❯ twl

ID Age   Project Tags                     Description             Urg
 3 29min         Dactyl Manuform          buy eggs                 0.8
 4 29min         Dactyl Manuform Keyboard buy milk                 0.8
 1 35min joe                              bake cake for joe          1
 2 32min sally                            bake cake for sally        1

4 tasks
```

We could filter task by tag using `task +<tag>`
```
❯ task +Dactyl
No matches.
```

The issue here is that it is not a good idea to use capital letters
for tag names

```
❯ task +"Dactyl"
No matches.
```
Not even wrapping the filter into quotes helps.

Anyway, we can append new tag into an existing list of tags in a task 
by using `task <task> modify +<tag>:
```
❯ task 1 modify +next
The 'next' special tag will boost the urgency of this task so it appears on the 'next' report.
Modifying task 1 'bake cake for joe'.
Modified 1 task.
Project 'joe' is 0% complete (1 task remaining).
```

Let's check the changes out:
```
❯ twl

ID Age   Project Tags                     Description             Urg
 3 54min         Dactyl Manuform          buy eggs                 0.8
 4 54min         Dactyl Manuform Keyboard buy milk                 0.8
 1  1h   joe     next                     bake cake for joe       16.8
 2 57min sally                            bake cake for sally        1

4 tasks
```

Repeat the process for the 3rd task:
```
❯ task 3 modify +next
The 'next' special tag will boost the urgency of this task so it appears on the 'next' report.
Modifying task 3 'buy eggs'.
Modified 1 task.
```

```
❯ twl

ID Age   Project Tags                     Description             Urg
 3 55min         Dactyl Manuform next     buy eggs                15.9
 4 55min         Dactyl Manuform Keyboard buy milk                 0.8
 1  1h   joe     next                     bake cake for joe       16.8
 2 57min sally                            bake cake for sally        1

4 tasks
```

Awesome!, now filter our tasks by "next" tag:
```
❯ task +next

ID Age   Project Tag                  Description       Urg
 1  1h   joe     next                 bake cake for joe 16.8
 3 55min         Dactyl Manuform next buy eggs          15.9

2 tasks
```

Let's remove the broken tags in 4th task:
```
❯ task 4 edit
Launching 'NVIM_APPNAME=LazyVim nvim "task.c7bc741b.task"' now...
Editing complete.
Edits were detected.
```

Check the changes in 4th task:
```
❯ twl

ID Age   Project Tags                 Description             Urg
 3 56min         Dactyl Manuform next buy eggs                15.9
 4 56min                              buy milk                   0
 1  1h   joe     next                 bake cake for joe       16.8
 2 59min sally                        bake cake for sally        1

4 tasks
```

```
❯ task 4 edit
Launching 'NVIM_APPNAME=LazyVim nvim "task.c7bc741b.task"' now...
Editing complete.
Edits were detected.
```

Set an specific list of tags to 4th task:
```
❯ task 4 modify +grocery +joe +sally
Modifying task 4 'buy milk'.
Modified 1 task.
```

```
❯ twl

ID Age   Project Tags                 Description             Urg
 3 58min         Dactyl Manuform next buy eggs                15.9
 4 58min         grocery joe sally    buy milk                   1
 1  1h   joe     next                 bake cake for joe       16.8
 2  1h   sally                        bake cake for sally        1

4 tasks
```

Let's filter by `grocery` tag:
```
❯ task +grocery

ID Age   Tag               Description Urg
 4 58min grocery joe sally buy milk       1

1 task
```

Let's filter by `joe` tag:
```
❯ task +joe

ID Age   Tag               Description Urg
 4 59min grocery joe sally buy milk       1

1 task
```

Add 3 tags into 2nd task:
```
❯ ttag 2 Dactyl Manuform Keyboard
Modifying task 2 'bake cake for sally'.
Modified 1 task.
Project 'sally' is 0% complete (1 task remaining).
```

```
❯ twl

ID Age  Project Tags                     Description             Urg
 3 1h           Dactyl Manuform next     buy eggs                15.9
 4 1h           grocery joe sally        buy milk                   1
 1 1h   joe     next                     bake cake for joe       16.8
 2 1h   sally   Dactyl Manuform Keyboard bake cake for sally      1.8

4 tasks
```

Here we realize why is a bad idea to use capital letters for tag names:
```
❯ task +Dactyl
No matches.
```

We compare the result with a tag assigned without any capital letters:
```
❯ task +joe

ID Age  Tag               Description Urg
 4 1h   grocery joe sally buy milk       1

1 task
```

Not even wrapping the filter into quotes helps.
```
❯ task +"Dactyl"
No matches.
```

```
❯ task +next

ID Age  Project Tag                  Description       Urg
 1 1h   joe     next                 bake cake for joe 16.8
 3 1h           Dactyl Manuform next buy eggs          15.9

2 tasks
```

```
❯ task +'Dactyl'
No matches.
```

```
❯ task +Dactyl
No matches.
```

So, finally we started to give up with the capital letters for tags,
and remove this mess:
```
❯ task 4 edit
Launching 'NVIM_APPNAME=LazyVim nvim "task.c7bc741b.task"' now...
Editing complete.
No edits were detected.
```

```
❯ task 5 edit
No matches.
```

```
❯ twl

ID Age  Project Tags                     Description             Urg
 3 1h           Dactyl Manuform next     buy eggs                15.9
 4 1h           grocery joe sally        buy milk                   1
 1 1h   joe     next                     bake cake for joe       16.8
 2 1h   sally   Dactyl Manuform Keyboard bake cake for sally      1.8

4 tasks
```

```
❯ task 2 edit
Launching 'NVIM_APPNAME=LazyVim nvim "task.e27be2f6.task"' now...
Editing complete.
Edits were detected.
```

```
❯ task 2 edit
Launching 'NVIM_APPNAME=LazyVim nvim "task.e27be2f6.task"' now...
Editing complete.
No edits were detected.
```

```
❯ task 3 edit
Launching 'NVIM_APPNAME=LazyVim nvim "task.cd82bb73.task"' now...
Editing complete.
Edits were detected.
```

Now that we remove the broken tags, let's filter by `dactyl` tag:
```
❯ task +dactyl

ID Age  Project Tag                      Description         Urg
 3 1h           dactyl manuform next     buy eggs              16
 2 1h   sally   dactyl keyboard manuform bake cake for sally    2

2 tasks
```

Great, now let's filter by `keyboard` tag:
```
❯ task +keyboard

ID Age  Project Tag                      Description         Urg
 2 1h   sally   dactyl keyboard manuform bake cake for sally    2

1 task
```

Awesome, lastly let's filter by `manuform` tag:
```
❯ task +manuform

ID Age  Project Tag                      Description         Urg
 3 1h           dactyl manuform next     buy eggs              16
 2 1h   sally   dactyl keyboard manuform bake cake for sally    2

2 tasks
```

Excellent!, now check the current state of the task list:
```
❯ twl

ID Age  Project Tags                     Description             Urg
 3 1h           dactyl manuform next     buy eggs                  16
 4 1h           grocery joe sally        buy milk                   1
 1 1h   joe     next                     bake cake for joe       16.8
 2 1h   sally   dactyl keyboard manuform bake cake for sally        2

4 tasks
```

Well, now I wonder what is going to happen if I add a set of tags
separated by a comma like this:
```
❯ ttag 4 +keyboard,manuform,dactyl
Modifying task 4 'buy milk'.
Modified 1 task.
```

```
❯ twl

ID Age  Project Tags                      Description             Urg
 3 1h           dactyl manuform next      buy eggs                  16
 4 1h           +keyboard dactyl manuform buy milk                   1
 1 1h   joe     next                      bake cake for joe       16.8
 2 1h   sally   dactyl keyboard manuform  bake cake for sally        2

4 tasks
```

Oh jezz, we screw up combining the `+` character with the `ttag` shortcut.

But the rest of the tags seems to be added correctly.

Let's filter by `keyboard` tag:
```
❯ task +keyboard

ID Age  Project Tag                      Description         Urg
 2 1h   sally   dactyl keyboard manuform bake cake for sally    2

1 task
```
It does not recognize the `+keyboard` tag

```
❯ task +manuform

ID Age  Project Tag                       Description         Urg
 3 1h           dactyl manuform next      buy eggs              16
 2 1h   sally   dactyl keyboard manuform  bake cake for sally    2
 4 1h           +keyboard dactyl manuform buy milk               1

3 tasks
```

Fix the issue by set an specify set of tags to 4th task:
```
❯ ttag 4 keyboard,manuform,dactyl
Modifying task 4 'buy milk'.
Modified 1 task.
```

Cool, now check the current state of the task list:
```
❯ twl

ID Age  Project Tags                     Description             Urg
 3 1h           dactyl manuform next     buy eggs                  16
 4 1h           dactyl keyboard manuform buy milk                   1
 1 1h   joe     next                     bake cake for joe       16.8
 2 1h   sally   dactyl keyboard manuform bake cake for sally        2

4 tasks
```

Add multiple tags with the `modify` option:
```
❯ task 4 modify +domestic,home_made
Modifying task 4 'buy milk'.
Modified 1 task.
```

```
❯ twl

ID Age  Project Tags                                                           Description             Urg
 3 1h           dactyl manuform next                                           buy eggs                  16
 4 1h           dactyl domestic domestic,home_made home_made keyboard manuform buy milk                   1
 1 1h   joe     next                                                           bake cake for joe       16.8
 2 1h   sally   dactyl keyboard manuform                                       bake cake for sally        2

4 tasks
```
It seems weird, the tags were added twice?

```
❯ task +domestic

ID Age  Tag                                                            Description Urg
 4 1h   dactyl domestic domestic,home_made home_made keyboard manuform buy milk       1

1 task
```
It filters by `domestic` tag though

```
❯ task +dactyl

ID Age  Project Tag                                                            Description         Urg
 3 1h           dactyl manuform next                                           buy eggs              16
 2 1h   sally   dactyl keyboard manuform                                       bake cake for sally    2
 4 1h           dactyl domestic domestic,home_made home_made keyboard manuform buy milk               1

3 tasks
```

## lesson 6
```
❯ task 8

Name          Value
ID            8
Description   Cake for John
Status        Waiting
Entered       2023-08-22 10:19:26 (7s)
Waiting until 2023-08-24 00:00:00
Scheduled     2023-08-25 00:00:00
Due           2023-08-29 00:00:00
Last modified 2023-08-22 10:19:26 (7s)
Virtual tags  LATEST MONTH QUARTER SCHEDULED UNBLOCKED WAITING YEAR
UUID          1656b983-7374-4fac-a19f-457d6bca9f4e
Urgency       2.797

    waiting      1 *   -3 =     -3
    due      0.483 *   12 =    5.8
                            ------
                             2.797

❯ twl

ID Age   Project Tags              Description             Urg
 3 15h           grocery joe sally buy eggs                   1
 4 15h           grocery joe sally buy milk                   1
 5  7min                           buy flour                  0
 6  7min                           buy butter                 0
 7  6min                           buy sugar                  0
 1 15h   joe                       bake cake for joe          1
 2 15h   sally                     bake cake for sally        1

7 tasks
❯ task wait
No matches.
❯ tn Cake for John \
due:2023-08-30 \
scheduled:due-4d \
wait:due-5d
Created task 9.
❯ task wait
No matches.
❯ twl

ID Age   Project Tags              Description             Urg
 3 15h           grocery joe sally buy eggs                   1
 4 15h           grocery joe sally buy milk                   1
 5  9min                           buy flour                  0
 6  9min                           buy butter                 0
 7  9min                           buy sugar                  0
 1 15h   joe                       bake cake for joe          1
 2 15h   sally                     bake cake for sally        1

7 tasks
❯ task 9

Name          Value
ID            9
Description   Cake for John
Status        Waiting
Entered       2023-08-22 10:22:05 (2min)
Waiting until 2023-08-25 00:00:00
Scheduled     2023-08-26 00:00:00
Due           2023-08-30 00:00:00
Last modified 2023-08-22 10:22:05 (2min)
Virtual tags  LATEST MONTH QUARTER SCHEDULED UNBLOCKED WAITING YEAR
UUID          da57628e-ebd1-4df3-8e46-41b731b562ee
Urgency       2.341

    waiting      1 *   -3 =     -3
    due      0.445 *   12 =   5.34
                            ------
                             2.341

❯ newcake Josh 2023-08-31 4 5
Created task 10.
The project '4' has changed.  Project '4' is 0% complete (1 task remaining).
Created task 11.
The project '4' has changed.  Project '4' is 0% complete (2 of 2 tasks remaining).
Created task 12.
The project '4' has changed.  Project '4' is 0% complete (3 of 3 tasks remaining).
Created task 13.
The project '4' has changed.  Project '4' is 0% complete (4 of 4 tasks remaining).
❯ task 10

Name          Value
ID            10
Description   Bake cake for Josh
Status        Waiting
Project       4
Entered       2023-08-22 10:25:54 (21s)
Waiting until 2023-08-26 00:00:00
Scheduled     2023-08-27 00:00:00
Due           2023-08-31 00:00:00
Last modified 2023-08-22 10:25:54 (21s)
Virtual tags  MONTH PROJECT QUARTER SCHEDULED UNBLOCKED WAITING YEAR
UUID          a15c0192-a28a-43d2-a2cc-72ae5c345d8e
Urgency       2.885

    project      1 *    1 =      1
    waiting      1 *   -3 =     -3
    due      0.407 *   12 =   4.88
                            ------
                             2.885

❯ twl

ID Age   Project Tags                      Due        Description             Urg
11  1min 4       Josh Josh,grocery grocery 2023-08-31 buy eggs                6.88
12  1min 4       Josh Josh,grocery grocery 2023-08-31 buy flour               6.88
13  1min 4       Josh Josh,grocery grocery 2023-08-31 buy milk                6.88
 3 15h           grocery joe sally                    buy eggs                   1
 4 15h           grocery joe sally                    buy milk                   1
 5 14min                                              buy flour                  0
 6 14min                                              buy butter                 0
 7 14min                                              buy sugar                  0
 1 15h   joe                                          bake cake for joe          1
 2 15h   sally                                        bake cake for sally        1

10 tasks
❯ task wait

ID Age  Project Tag                       Due  Description Urg
11 1min 4       Josh Josh,grocery grocery 8d   buy eggs    6.88
12 1min 4       Josh Josh,grocery grocery 8d   buy flour   6.88
13 1min 4       Josh Josh,grocery grocery 8d   buy milk    6.88

3 tasks
❯ newcake jessica 2023-08-23
Created task 14.
Created task 15.
Created task 16.
Created task 17.
❯ twl

ID Age   Project Tags                            Sch   Due        Description               Urg
15  8s           grocery jessica jessica,grocery       2023-08-23 buy eggs                  14.5
16  8s           grocery jessica jessica,grocery       2023-08-23 buy flour                 14.5
17  8s           grocery jessica jessica,grocery       2023-08-23 buy milk                  14.5
14  8s                                                 2023-08-23 Bake cake for jessica     13.5
11  3min 4       Josh Josh,grocery grocery        7d   2023-08-31 buy eggs                  6.89
12  3min 4       Josh Josh,grocery grocery        7d   2023-08-31 buy flour                 6.89
13  3min 4       Josh Josh,grocery grocery        7d   2023-08-31 buy milk                  6.89
 3 15h           grocery joe sally                                buy eggs                     1
 4 15h           grocery joe sally                                buy milk                     1
 5 16min                                                          buy flour                    0
 6 16min                                                          buy butter                   0
 7 16min                                                          buy sugar                    0
 1 15h   joe                                                      bake cake for joe            1
 2 15h   sally                                                    bake cake for sally          1

14 tasks
❯ task +grocery

ID Age   Project Tag                             S     Due   Description Urg
15 21s           grocery jessica jessica,grocery       13h   buy eggs    14.5
16 21s           grocery jessica jessica,grocery       13h   buy flour   14.5
17 21s           grocery jessica jessica,grocery       13h   buy milk    14.5
11  3min 4       Josh Josh,grocery grocery        7d    8d   buy eggs    6.89
12  3min 4       Josh Josh,grocery grocery        7d    8d   buy flour   6.89
13  3min 4       Josh Josh,grocery grocery        7d    8d   buy milk    6.89
 3 15h           grocery joe sally                           buy eggs       1
 4 15h           grocery joe sally                           buy milk       1

8 tasks
❯ type newcake
newcake is an alias for newcakefunction
❯ type newcakefunction
newcakefunction is a shell function from /home/tovar/.zshrc
❯ task wait

ID Age  Project Tag                             S     Due   Description           Urg
15 3min         grocery jessica jessica,grocery       13h   buy eggs              14.5
16 3min         grocery jessica jessica,grocery       13h   buy flour             14.5
17 3min         grocery jessica jessica,grocery       13h   buy milk              14.5
14 3min                                               13h   Bake cake for jessica 13.5
11 7min 4       Josh Josh,grocery grocery        7d    8d   buy eggs              6.89
12 7min 4       Josh Josh,grocery grocery        7d    8d   buy flour             6.89
13 7min 4       Josh Josh,grocery grocery        7d    8d   buy milk              6.89

7 tasks
❯ task calendar

        August 2023             September 2023             October 2023              November 2023             December 2023             January 2024              February 2024

     Su Mo Tu We Th Fr Sa      Su Mo Tu We Th Fr Sa      Su Mo Tu We Th Fr Sa      Su Mo Tu We Th Fr Sa      Su Mo Tu We Th Fr Sa      Su Mo Tu We Th Fr Sa      Su Mo Tu We Th Fr Sa
  31        1  2  3  4  5   35                 1  2   40  1  2  3  4  5  6  7   44           1  2  3  4   48                 1  2    1     1  2  3  4  5  6    5              1  2  3
  32  6  7  8  9 10 11 12   36  3  4  5  6  7  8  9   41  8  9 10 11 12 13 14   45  5  6  7  8  9 10 11   49  3  4  5  6  7  8  9    2  7  8  9 10 11 12 13    6  4  5  6  7  8  9 10
  33 13 14 15 16 17 18 19   37 10 11 12 13 14 15 16   42 15 16 17 18 19 20 21   46 12 13 14 15 16 17 18   50 10 11 12 13 14 15 16    3 14 15 16 17 18 19 20    7 11 12 13 14 15 16 17
  34 20 21 22 23 24 25 26   38 17 18 19 20 21 22 23   43 22 23 24 25 26 27 28   47 19 20 21 22 23 24 25   51 17 18 19 20 21 22 23    4 21 22 23 24 25 26 27    8 18 19 20 21 22 23 24
  35 27 28 29 30 31         39 24 25 26 27 28 29 30   44 29 30 31               48 26 27 28 29 30         52 24 25 26 27 28 29 30    5 28 29 30 31             9 25 26 27 28 29
                                                                                                          52 31

Legend: today, weekend, due, due-today, overdue, scheduled, weeknumber.
```
