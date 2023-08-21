# Task Manager lessons

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
