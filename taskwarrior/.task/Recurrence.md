# How Recurrence works
A recurring task is a task with a due date that keeps coming back
as a reminder. Here is an example:
```
❯ task add "Pay the rent" due:1st recur:monthly until: 2023-12-31
Created task 59 (recurrence template).
```

This task has a due date, a monthly recurrence, and an optional until date coinciding 
with the end of the lease.

A recurring task is given a status of `recurring` which hides it from view,
although you can see it in the all report. The recurring task you create is called the template task, from which recurring 
tasks instances are created. So the template remains hidden, and the recurring instances that
spawn form it are the tasks that you will see and complete.

Here is a look at the template task:
```
❯ task 59 info

Name            Value
ID              59
Description     Pay the rent 2023-12-31
Status          Recurring
Recurrence      monthly
Mask            -
Recurrence type periodic
Entered         2023-09-26 06:56:05 (5min)
Due             2023-10-01 00:00:00
Last modified   2023-09-26 06:56:05 (5min)
Virtual tags    DUE PARENT TEMPLATE UNBLOCKED WEEK YEAR
UUID            330126e5-8664-4a43-830f-3279e10e59ce
Urgency         6.648

    due  0.554 *   12 =   6.65
                        ------
                         6.648

Date                Modification
2023-09-26 06:56:05 Mask set to '-'.

```
Now if you run a report, such as `task list`, you will see the first instance of that recurring task
generated. We can take a look at the instance:
```
❯ task 60

Name            Value
ID              60
Description     Pay the rent 2023-12-31
Status          Pending
Recurrence      monthly
Parent task     330126e5-8664-4a43-830f-3279e10e59ce
Mask Index      0
Recurrence type periodic
Entered         2023-09-26 06:56:05 (8min)
Due             2023-10-01 00:00:00
Last modified   2023-09-26 06:56:05 (8min)
Virtual tags    CHILD DUE INSTANCE LATEST PENDING READY UNBLOCKED WEEK YEAR
UUID            ff59a3fe-74d1-485f-bcf2-855314603d94
Urgency         6.649

    due  0.554 *   12 =   6.65
                        ------
                         6.649

```
Notice how the instance has a status `pending`, and a reference back to the
template task (Parent task). In addition, you can see it inherited the 
recurrence and description, and if there was a project, priority and tags, 
those would also be inherited.

The recurring instance has an attribute named 'Mask Index', which is zero. This
indicates that it is the first of the many recurring task instances, the counting
being zero-based.

Now if we look back at the template task, we see changes:
```
❯ task 59 info

Name            Value
ID              59
Description     Pay the rent 2023-12-31
Status          Recurring
Recurrence      monthly
Mask            -
Recurrence type periodic
Entered         2023-09-26 06:56:05 (14min)
Due             2023-10-01 00:00:00
Last modified   2023-09-26 06:56:05 (14min)
Virtual tags    DUE PARENT TEMPLATE UNBLOCKED WEEK YEAR
UUID            330126e5-8664-4a43-830f-3279e10e59ce
Urgency         6.651

    due  0.554 *   12 =   6.65
                        ------
                         6.651

Date                Modification
2023-09-26 06:56:05 Mask set to '-'.
```

The template task now has a `mask` attribute, and some change history. That `mask` is a string of
task statuses. It has a value of `-` which indicates that one instance was created, task `60`,
because it is one character long. The `-` means that instance is still pending. This is how the
template task keeps track of what it does and does not need to generate. When the task instance
changes status that `-` becomes `+` (completed) or `X` (deleted) or `W` (waiting).

Note that you never directly interact with task `59`, template task. It is hidden for a reason.
Instead, you interact with the recurring task instances, and in most cases, changes are propagated
to the template task and optionally other sibling tasks.

In this example one task instance is generated for the next due period. This is because 
the configuration setting `recurrence.limit` is set to `1`, the default. If this number is increased to 2,
then you would see the next 2 instances generated. Note that this only generates two steps into the
future, without regard for whether those two instances are completed or not - don't expect to
complete the first task and see a new one pop up immediately.
