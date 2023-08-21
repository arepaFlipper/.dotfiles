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
