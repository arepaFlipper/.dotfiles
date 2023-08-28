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

## Lesson 5: TaskWarrior & bash

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

## lesson 6: Command Staking
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

## lesson 7: Reports

```
❯ twl

ID Age   Project Tags                            Sch   Due        Description               Urg
15 32min         grocery jessica jessica,grocery       2023-08-23 buy eggs                  14.6
16 32min         grocery jessica jessica,grocery       2023-08-23 buy flour                 14.6
17 32min         grocery jessica jessica,grocery       2023-08-23 buy milk                  14.6
14 32min                                               2023-08-23 Bake cake for jessica     13.6
11 36min 4       Josh Josh,grocery grocery        7d   2023-08-31 buy eggs                   6.9
12 36min 4       Josh Josh,grocery grocery        7d   2023-08-31 buy flour                  6.9
13 36min 4       Josh Josh,grocery grocery        7d   2023-08-31 buy milk                   6.9
 3 16h           grocery joe sally                                buy eggs                     1
 4 16h           grocery joe sally                                buy milk                     1
 5 49min                                                          buy flour                    0
 6 49min                                                          buy butter                   0
 7 48min                                                          buy sugar                    0
 1 16h   joe                                                      bake cake for joe            1
 2 16h   sally                                                    bake cake for sally          1

14 tasks
❯ task report

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
❯ task all

ID St UUID     A Age   Done  P Project Tags Wait Sch  Due        Description
14 P  0090aa73   33min                                2023-08-23 Bake cake for jessica
15 P  d4d5b6b0   33min                  [3]           2023-08-23 buy eggs
16 P  4337eaf9   33min                  [3]           2023-08-23 buy flour
17 P  df1ab6e1   33min                  [3]           2023-08-23 buy milk
10 W  a15c0192   37min         4            3d   4d   2023-08-31 Bake cake for Josh
11 P  3abbceb7   37min         4        [3]      7d   2023-08-31 buy eggs
12 P  105e60c9   37min         4        [3]      7d   2023-08-31 buy flour
13 P  fd3c2a43   37min         4        [3]      7d   2023-08-31 buy milk
 9 W  da57628e   41min                      2d   3d   2023-08-30 Cake for John
 8 W  1656b983   43min                      1d   2d   2023-08-29 Cake for John
 7 P  d249dbbf   50min                                           buy sugar
 6 P  16e03f8e   50min                                           buy butter
 5 P  a4acdb5a   50min                                           buy flour
 - D  5bd2ca3a   15h   15h                                       cd -5 6
                                                                   2023-08-21 cd -5
 - D  30be94ac   15h   15h                                       cd -5
                                                                   2023-08-21 cd -5
 - D  487870a1   15h   15h                                       welcome to costco
                                                                   2023-08-21 cd -5
 4 P  c7bc741b   16h                    [3]                      buy milk
 3 P  cd82bb73   16h                    [3]                      buy eggs
 2 P  e27be2f6   16h           sally                             bake cake for sally
 1 P  2f586544   16h           joe                               bake cake for joe
 - D  c7777110   17h   16h   H party    [1]                      MUST bake cake for Sally
                                                                   2023-08-21 grocery
 - D  a22ae088   17h   17h     party                             get birthday card
 - D  19f619d8   21h   16h   H party    [1]                      MUST bake cake for Joe
                                                                   2023-08-21 grocery
 - D  28ecb42d   21h   16h     grocery  [2]                      buy eggs
                                                                   2023-08-21 grocery
 - D  9eb8ea44   21h   16h     grocery  [2]                      buy milk
                                                                   2023-08-21 buy 2% milk
                                                                   2023-08-21 grocery
 - D  d0de7ba3   22h   22h                                       bake cake
 - D  31a109a3   22h   22h                                       bake cake
 - D  ffef9144   22h   22h                                       buy eggs
 - D  c99b4c15   22h   22h                                       buy milk
 - D  02f8ffad   22h   22h                                       get milk

30 tasks
❯ task waiting

ID Age   Project Wait       Remaining Sched      Due        Description
 8 43min         2023-08-24      1d   2023-08-25 2023-08-29 Cake for John
 9 41min         2023-08-25      2d   2023-08-26 2023-08-30 Cake for John
10 37min 4       2023-08-26      3d   2023-08-27 2023-08-31 Bake cake for Josh

3 tasks
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

❯ task active
No matches.
❯ twl

ID Age   Project Tags                            Sch   Due        Description               Urg
15 35min         grocery jessica jessica,grocery       2023-08-23 buy eggs                  14.6
16 35min         grocery jessica jessica,grocery       2023-08-23 buy flour                 14.6
17 35min         grocery jessica jessica,grocery       2023-08-23 buy milk                  14.6
14 35min                                               2023-08-23 Bake cake for jessica     13.6
11 38min 4       Josh Josh,grocery grocery        7d   2023-08-31 buy eggs                   6.9
12 38min 4       Josh Josh,grocery grocery        7d   2023-08-31 buy flour                  6.9
13 38min 4       Josh Josh,grocery grocery        7d   2023-08-31 buy milk                   6.9
 3 16h           grocery joe sally                                buy eggs                     1
 4 16h           grocery joe sally                                buy milk                     1
 5 51min                                                          buy flour                    0
 6 51min                                                          buy butter                   0
 7 51min                                                          buy sugar                    0
 1 16h   joe                                                      bake cake for joe            1
 2 16h   sally                                                    bake cake for sally          1

14 tasks
❯ task 14 start
Starting task 14 'Bake cake for jessica'.
Started 1 task.
You have more urgent tasks.
❯ task active

ID Started    Active Age   W          Due        Description
14 2023-08-22   8s   35min 2023-08-18 2023-08-23 Bake cake for jessica

1 task
❯ task show list

Config Variable         Value
list.all.projects       0
list.all.tags           0
report.list.columns     id,start.age,entry.age,depends.indicator,priority,project,tags,recur.indicator,scheduled.countdown,due,until.remaining,description.count,urgency
report.list.context     1
report.list.description Most details of tasks
report.list.filter      status:pending -WAITING
report.list.labels      ID,Active,Age,D,P,Project,Tags,R,Sch,Due,Until,Description,Urg
report.list.sort        start-,due+,project+,urgency-


❯ task show calendar

Config Variable           Value
calendar.details          sparse
calendar.details.report   list
calendar.holidays         none
calendar.legend           1
calendar.offset           0
calendar.offset.value     -1
color.calendar.due        color0 on color1
color.calendar.due.today  color15 on color1
color.calendar.holiday    color0 on color11
color.calendar.overdue    color0 on color9
color.calendar.scheduled  rgb013 on color15
color.calendar.today      color15 on rgb013
color.calendar.weekend    on color235
color.calendar.weeknumber rgb013


❯ task calendar.details
No matches.
❯ task calendar.report
No matches.
❯ task config report.list.labels
No entry named 'report.list.labels' found.
❯ task config report.list.labels
No entry named 'report.list.labels' found.
❯ task config report.list.labels 'ID,Active,Age,D,P,Project,Tags,R,Sch,Due,Until,Description,Urg'
Are you sure you want to add 'report.list.labels' with a value of 'ID,Active,Age,D,P,Project,Tags,R,Sch,Due,Until,Description,Urg'? (yes/no) yes
Config file /home/tovar/.taskrc modified.
❯ task config report.list.labels
Are you sure you want to remove 'report.list.labels'? (yes/no) n
No changes made.
```

Set the column labels for the `task list` command:
```
❯ task config report.list.labels 'ID,Active,Age,Dependency,Priority,Project,Tags,Recur,Schedule,Due,Until,Description,Urgency'
Are you sure you want to change the value of 'report.list.labels' from 'ID,Active,Age,D,P,Project,Tags,R,Sch,Due,Until,Description,Urg' to 'ID,Active,Age,Dependency,Priority,Project,Tags,Recur,Schedule,Due,Until,Description,Urgency'? (yes/no) yes
Config file /home/tovar/.taskrc modified.
```

This way you can see the details of the tasks in the `task list` command:
```
❯ twl

ID Active Age   Project Tags                            Schedule Due        Description               Urgency
14   4min 40min                                                  2023-08-23 Bake cake for jessica        17.6
15        40min         grocery jessica jessica,grocery          2023-08-23 buy eggs                     14.6
16        40min         grocery jessica jessica,grocery          2023-08-23 buy flour                    14.6
17        40min         grocery jessica jessica,grocery          2023-08-23 buy milk                     14.6
11        43min 4       Josh Josh,grocery grocery           7d   2023-08-31 buy eggs                      6.9
12        43min 4       Josh Josh,grocery grocery           7d   2023-08-31 buy flour                     6.9
13        43min 4       Josh Josh,grocery grocery           7d   2023-08-31 buy milk                      6.9
 3        16h           grocery joe sally                                   buy eggs                        1
 4        16h           grocery joe sally                                   buy milk                        1
 5        56min                                                             buy flour                       0
 6        56min                                                             buy butter                      0
 7        56min                                                             buy sugar                       0
 1        16h   joe                                                         bake cake for joe               1
 2        16h   sally                                                       bake cake for sally             1

14 tasks
❯ task show list

Config Variable         Value
list.all.projects       0
list.all.tags           0
report.list.columns     id,start.age,entry.age,depends.indicator,priority,project,tags,recur.indicator,scheduled.countdown,due,until.remaining,description.count,urgency
report.list.context     1
report.list.description Most details of tasks
report.list.filter      status:pending -WAITING
report.list.labels      ID,Active,Age,Dependency,Priority,Project,Tags,Recur,Schedule,Due,Until,Description,Urgency
  Default value         ID,Active,Age,D,P,Project,Tags,R,Sch,Due,Until,Description,Urg
report.list.sort        start-,due+,project+,urgency-

Some of your .taskrc variables differ from the default values.
  These are highlighted in color above.

```

## Lesson 8: User Defined Attributes (UDAs)

```
❯ task 14 15 16 17 11 12 13 done
This command will alter 7 tasks.
  - End will be set to '2023-08-22'.
  - Status will be changed from 'pending' to 'completed'.
Complete task 11 'buy eggs'? (yes/no/all/quit) a
Completed task 11 'buy eggs'.
Completed task 12 'buy flour'.
Completed task 13 'buy milk'.
Completed task 14 'Bake cake for jessica'.
Completed task 15 'buy eggs'.
Completed task 16 'buy flour'.
Completed task 17 'buy milk'.
Completed 7 tasks.
Warning: You have specified that the 'scheduled' date is after the 'end' date.
The project '4' has changed.  Project '4' is 75% complete (1 of 4 tasks remaining).
❯ twl

ID Age   Project     Tags                                Due        Description             Urgency
12  1min baby-shower christine christine,grocery grocery 2023-08-31 buy eggs                    6.9
13  1min baby-shower christine christine,grocery grocery 2023-08-31 buy flour                   6.9
14  1min baby-shower christine christine,grocery grocery 2023-08-31 buy milk                    6.9
 3 16h               grocery joe sally                              buy eggs                      1
 4 16h               grocery joe sally                              buy milk                      1
 5  1h                                                              buy flour                     0
 6  1h                                                              buy butter                    0
 7  1h                                                              buy sugar                     0
 1 16h   joe                                                        bake cake for joe             1
 2 16h   sally                                                      bake cake for sally           1

10 tasks
❯ task waiting

ID Age   Project     Wait       Remaining Sched      Due        Description
 8 59min             2023-08-24      1d   2023-08-25 2023-08-29 Cake for John
 9 56min             2023-08-25      2d   2023-08-26 2023-08-30 Cake for John
10 53min 4           2023-08-26      3d   2023-08-27 2023-08-31 Bake cake for Josh
11  2min baby-shower 2023-08-26      3d   2023-08-27 2023-08-31 Bake cake for christine

4 tasks
❯ task 11

Name          Value
ID            11
Description   Bake cake for christine
Status        Waiting
Project       baby-shower
Entered       2023-08-22 11:16:43 (3min)
Waiting until 2023-08-26 00:00:00
Scheduled     2023-08-27 00:00:00
Due           2023-08-31 00:00:00
Last modified 2023-08-22 11:16:43 (3min)
Virtual tags  MONTH PROJECT QUARTER SCHEDULED UNBLOCKED WAITING YEAR
UUID          e89d4d4f-ea17-485a-ac29-aba0fa329454
Urgency       2.902

    project      1 *    1 =      1
    waiting      1 *   -3 =     -3
    due      0.408 *   12 =    4.9
                            ------
                             2.902

❯ task config uda.cost.type numeric
Are you sure you want to add 'uda.cost.type' with a value of 'numeric'? (yes/no) yes
Config file /home/tovar/.taskrc modified.
❯ task config uda.cost.label Cost
Are you sure you want to add 'uda.cost.label' with a value of 'Cost'? (yes/no) yes
Config file /home/tovar/.taskrc modified.
❯ task 11

Name          Value
ID            11
Description   Bake cake for christine
Status        Waiting
Project       baby-shower
Entered       2023-08-22 11:16:43 (4min)
Waiting until 2023-08-26 00:00:00
Scheduled     2023-08-27 00:00:00
Due           2023-08-31 00:00:00
Last modified 2023-08-22 11:16:43 (4min)
Virtual tags  MONTH PROJECT QUARTER SCHEDULED UNBLOCKED WAITING YEAR
UUID          e89d4d4f-ea17-485a-ac29-aba0fa329454
Urgency       2.902

    project      1 *    1 =      1
    waiting      1 *   -3 =     -3
    due      0.409 *   12 =    4.9
                            ------
                             2.902

❯ task 11 edit
Launching 'NVIM_APPNAME=LazyVim nvim "task.e89d4d4f.task"' now...
Editing complete.
Edits were detected.
UDA cost modified.
❯ task 11

Name          Value
ID            11
Description   Bake cake for christine
Status        Waiting
Project       baby-shower
Entered       2023-08-22 11:16:43 (5min)
Waiting until 2023-08-26 00:00:00
Scheduled     2023-08-27 00:00:00
Due           2023-08-31 00:00:00
Last modified 2023-08-22 11:22:05 (3s)
Virtual tags  MONTH PROJECT QUARTER SCHEDULED UDA UNBLOCKED WAITING YEAR
UUID          e89d4d4f-ea17-485a-ac29-aba0fa329454
Urgency       2.902
Cost          50.00

    project      1 *    1 =      1
    waiting      1 *   -3 =     -3
    due      0.409 *   12 =    4.9
                            ------
                             2.902

Date                Modification
2023-08-22 11:22:05 Cost set to '50.00'.

❯ task 11

Name          Value
ID            11
Description   Bake cake for christine
Status        Waiting
Project       baby-shower
Entered       2023-08-22 11:16:43 (8min)
Waiting until 2023-08-26 00:00:00
Scheduled     2023-08-27 00:00:00
Due           2023-08-31 00:00:00
Last modified 2023-08-22 11:22:05 (2min)
Virtual tags  MONTH PROJECT QUARTER SCHEDULED UDA UNBLOCKED WAITING YEAR
UUID          e89d4d4f-ea17-485a-ac29-aba0fa329454
Urgency       2.903
Cost          50.00

    project      1 *    1 =      1
    waiting      1 *   -3 =     -3
    due      0.409 *   12 =    4.9
                            ------
                             2.903

Date                Modification
2023-08-22 11:22:05 Cost set to '50.00'.

❯ task 11 edit
Launching 'NVIM_APPNAME=LazyVim nvim "task.e89d4d4f.task"' now...
Editing complete.
Edits were detected.
UDA color modified.
❯ task 11

Name          Value
ID            11
Description   Bake cake for christine
Status        Waiting
Project       baby-shower
Entered       2023-08-22 11:16:43 (8min)
Waiting until 2023-08-26 00:00:00
Scheduled     2023-08-27 00:00:00
Due           2023-08-31 00:00:00
Last modified 2023-08-22 11:25:10 (5s)
Virtual tags  MONTH PROJECT QUARTER SCHEDULED UDA UNBLOCKED WAITING YEAR
UUID          e89d4d4f-ea17-485a-ac29-aba0fa329454
Urgency       2.903
color         red
Cost          50.00

    project      1 *    1 =      1
    waiting      1 *   -3 =     -3
    due      0.409 *   12 =    4.9
                            ------
                             2.903

Date                Modification
2023-08-22 11:22:05 Cost set to '50.00'.
2023-08-22 11:25:10 Color set to 'red'.

❯ task 11 modify color:white
Modifying task 11 'Bake cake for christine'.
Modified 1 task.
Project 'baby-shower' is 0% complete (4 of 4 tasks remaining).
❯ task 11

Name          Value
ID            11
Description   Bake cake for christine
Status        Waiting
Project       baby-shower
Entered       2023-08-22 11:16:43 (8min)
Waiting until 2023-08-26 00:00:00
Scheduled     2023-08-27 00:00:00
Due           2023-08-31 00:00:00
Last modified 2023-08-22 11:25:31 (4s)
Virtual tags  MONTH PROJECT QUARTER SCHEDULED UDA UNBLOCKED WAITING YEAR
UUID          e89d4d4f-ea17-485a-ac29-aba0fa329454
Urgency       2.903
color         white
Cost          50.00

    project      1 *    1 =      1
    waiting      1 *   -3 =     -3
    due      0.409 *   12 =    4.9
                            ------
                             2.903

Date                Modification
2023-08-22 11:22:05 Cost set to '50.00'.
2023-08-22 11:25:10 Color set to 'red'.
2023-08-22 11:25:31 Color changed from 'red' to 'white'.

❯ task 11 modify color:gray
The 'color' attribute does not allow a value of 'gray'.
❯ twl

ID Age   Project     Tags                                Due        Description             Urgency
12 11min baby-shower christine christine,grocery grocery 2023-08-31 buy eggs                    6.9
13 11min baby-shower christine christine,grocery grocery 2023-08-31 buy flour                   6.9
14 11min baby-shower christine christine,grocery grocery 2023-08-31 buy milk                    6.9
 3 16h               grocery joe sally                              buy eggs                      1
 4 16h               grocery joe sally                              buy milk                      1
 5  1h                                                              buy flour                     0
 6  1h                                                              buy butter                    0
 7  1h                                                              buy sugar                     0
 1 16h   joe                                                        bake cake for joe             1
 2 16h   sally                                                      bake cake for sally           1

10 tasks
❯ task waiting

ID Age   Project     Wait       Remaining Sched      Due        Description
 8  1h               2023-08-24      1d   2023-08-25 2023-08-29 Cake for John
 9  1h               2023-08-25      2d   2023-08-26 2023-08-30 Cake for John
10  1h   4           2023-08-26      3d   2023-08-27 2023-08-31 Bake cake for Josh
11 11min baby-shower 2023-08-26      3d   2023-08-27 2023-08-31 Bake cake for christine

4 tasks
❯ task waiting list
No matches.
❯ task show waiting

Config Variable             Value
report.waiting.columns      id,start.active,entry.age,depends.indicator,priority,project,tags,recur.indicator,wait,wait.remaining,scheduled,due,until,description
report.waiting.context      1
report.waiting.description  Waiting (hidden) tasks
report.waiting.filter       +WAITING
report.waiting.labels       ID,A,Age,D,P,Project,Tags,R,Wait,Remaining,Sched,Due,Until,Description
report.waiting.sort         due+,wait+,entry+
urgency.waiting.coefficient -3.0


❯ task show waiting

Config Variable             Value
report.waiting.columns      id,start.active,entry.age,depends.indicator,priority,project,tags,recur.indicator,wait,wait.remaining,scheduled,due,until,description, urgency
  Default value             id,start.active,entry.age,depends.indicator,priority,project,tags,recur.indicator,wait,wait.remaining,scheduled,due,until,description
report.waiting.context      1
report.waiting.description  Waiting (hidden) tasks
report.waiting.filter       +WAITING
report.waiting.labels       ID,A,Age,D,P,Project,Tags,R,Wait,Remaining,Sched,Due,Until,Description,Urgency
  Default value             ID,A,Age,D,P,Project,Tags,R,Wait,Remaining,Sched,Due,Until,Description
report.waiting.sort         due+,wait+,entry+
urgency.waiting.coefficient -3.0

Some of your .taskrc variables differ from the default values.
  These are highlighted in color above.


❯ task waiting
Unrecognized column name ' urgency'.
❯ task waiting
Unrecognized column name 'Urgency'.
❯ task waiting
Unrecognized column name 'Urgency'.
❯ twl

ID Age   Project     Tags                                Due        Description             Urgency
12 15min baby-shower christine christine,grocery grocery 2023-08-31 buy eggs                   6.91
13 15min baby-shower christine christine,grocery grocery 2023-08-31 buy flour                  6.91
14 15min baby-shower christine christine,grocery grocery 2023-08-31 buy milk                   6.91
 3 16h               grocery joe sally                              buy eggs                      1
 4 16h               grocery joe sally                              buy milk                      1
 5  1h                                                              buy flour                     0
 6  1h                                                              buy butter                    0
 7  1h                                                              buy sugar                     0
 1 16h   joe                                                        bake cake for joe             1
 2 16h   sally                                                      bake cake for sally           1

10 tasks
❯ task waiting

ID Age   Project     Wait       Remaining Sched      Due        Description
 8  1h               2023-08-24      1d   2023-08-25 2023-08-29 Cake for John
 9  1h               2023-08-25      2d   2023-08-26 2023-08-30 Cake for John
10  1h   4           2023-08-26      3d   2023-08-27 2023-08-31 Bake cake for Josh
11 15min baby-shower 2023-08-26      3d   2023-08-27 2023-08-31 Bake cake for christine

4 tasks
❯ task waiting

ID Age   Project     Wait       Remaining Sched      Due        Description             Urgency
 8  1h               2023-08-24      1d   2023-08-25 2023-08-29 Cake for John              2.82
 9  1h               2023-08-25      2d   2023-08-26 2023-08-30 Cake for John              2.36
10  1h   4           2023-08-26      3d   2023-08-27 2023-08-31 Bake cake for Josh         2.91
11 15min baby-shower 2023-08-26      3d   2023-08-27 2023-08-31 Bake cake for christine    32.9

4 tasks
❯ task waiting

ID Age   Project     Wait       Remaining Sched      Due        Description             Urgency
 8  1h               2023-08-24      1d   2023-08-25 2023-08-29 Cake for John              2.82
 9  1h               2023-08-25      2d   2023-08-26 2023-08-30 Cake for John              2.36
10  1h   4           2023-08-26      3d   2023-08-27 2023-08-31 Bake cake for Josh         2.91
11 17min baby-shower 2023-08-26      3d   2023-08-27 2023-08-31 Bake cake for christine    32.9

4 tasks
```

## Lesson 9: Reports and UDAs
