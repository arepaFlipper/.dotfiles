# Best Practices
The default report (the report that runs when you just enter `task`) is the next
report. This is a report where the tasks are sorted by urgency, with the most
urgent at the top. The report cuts uff after one page, so it is really just a 
list of the most urgent tasks. Whit a few tips to follow , the `next` report 
can be your most valuable resource. Here are the typs for making the `next`
report work in your favor.

## Tips

- Capture all the tasks and details that you can Getting the information off
your mind and onto the list reduces the amount of details you need to remember,
and reduces the thins you might forget.

- Assign a project to you tasks if possible:
```
task <ID> modify project:<project_name>

task 99 modify project:domestic
```

- Assign due date where appropiate for the important tasks:
```
task <ID> modify due:<date>

task 78 modify due:31st
```
Don't overdo this though, as a delay might force you to spend too much time reorganizing everything.

- When you start working on a task, mark it started:
```
task <ID> start

task 34 start
```
This is a great reminder after a weekend, of what you were doing on Friday that should be continued.

- If you know the priority of a task:
```
task <ID> modify priority:<priority>

task 354 modify priority:M
```
But don't fall into the trap of shifting the priorities too often, as you'll waste a lot of time.

- Add useful tags to a task:
```
task <ID> modify +<tag>

task 89 modify +work +domestic
```
This is very useful for filtering.

- Add the special tag `+next` to a task, to boost its urgency:
```
task <ID> modify +next

task 28 modify +next
```

- Represent dependencies, where appropiate, because there is a big difference in the 
urgency of a blocking task, than that of a blocked task:
```
task <ID> modify depends:OTHER_ID

task 89 modify depends:78
```

- Try not to have large, long-term tasks that will sit on your list forever. It can
be very satisfying and motivating to complete tasks, so create more, but smaller, tasks.
Don't have a 'learn Japanese' task, instead have a 'Complete chapter 1' task instead,
it's more readily achievable, and you can more easily see progress, which can be motivating.

## How That Helps

The `next` report is sorted by urgency. Urgency is just a number, but a number calcualted using a
polynomial that considers may aspects of your tasks, Wha this means is that 
the more information you provide with your tasks, the
more accurate the `next`report becomes and the more
closely it approximates your own notion of urgency.

If you follow the above tips, your `next` report output 
should be starting to get useful. Furthermore, by modifying the
urgency coefficients, you can make the `next` report adopt
your own notion of whether, for example, a priority setting is
more important than a specific project. Here are some
changes you could make:

```
task config urgency.user.tag.<problem>.coefficient 4.5
```

In `.taskrc`:
```
urgency.user.tag.<problem>.coefficient 4.5
```

This means that any task having the `+problem` tag gets an urgency
boost. 

Conversely, you can reduce the urgency for 
unimportant tasks, using negative coefficients:
```
task config urgency.user.tag.<later>.coefficient -6.0
```

In `.taskrc`:
```
urgency.user.tag.<later>.coefficient -6.0
```

If you have a project that is more important, 
you can boost the whole project:
```
task config urgency.user.project.<domestic>.coefficient 2.9
```

In `.taskrc`:
```
urgency.user.project.<domestic>.coefficient 2.9
```

Suppose you do not agree that a blocked task should have 
a reduced urgency. Override it:

```
task config urgency.blocked.coefficient 0.0
```
A zero coefficient means that blocked tasks now 
have no effect on the urgency.

## Describe Carefully
Providing good descriptions for your tasks is enormously
helpful.

A bad description is an open-ended task, for which progress will be very
hard to assess. This will be a task that sits on your task lis for some time,
and is not very helpful - you learn nothing from it , and its presence on the list will 
become demotivating.

A good approach would be this:
```
task add project:Kitchen "Select floor tiles"
task add project:Kitchen "Measure counter-top"
task add project:Kitchen "Design placement of electrical outlets"
task add project:kitchen "Locate ideal placement for extractor duct"
task add project:kitchen "Select and order counter-top material"
task add project:kitchen "Talk to the Electrician about when the work can start"
```
Here `Kitchen` is now a project name, and the tasks represent 
smaller units of work. While this means more time will be
spent breaking down the larger tasks, but planning is important.

With smaller tasks, you have the opportunity to establish links between your
tasks. For example, it would be wise to plan the placement of electrical
outlets before asking the Electrician to start work. Measuring the counter-top
is also needed before ordering the material. These are examples where
you could use task dependencies to formalize the sequence.

If your are wanting to estimate the completion of the project, having more
tasks and more details will improve your ability to estimate. With enough
detail in the tasks, you are more likely to be able to estimate the work.

Break down tasks into smaller tasks - the extra effort required to be more
precise can pay off in terms of efficiently performing the work in the right
sequence, at the right time.

## Review Your Tasks
Go over your list periodically and correct any erroneous data, like an
incorrect due date, or a priority that no longer applies because of external
factors, or even delete tasks that are no longer relevant. This keeps your list
current and up to date, more accurately reflecting the work your  need to
accomplish. Accurate metadata and good urgency coefficients mean that
Taskwarrior's idea of urgency more closely matches yours. That will be a big
help.

Consider installing and using the Taskwarrior Shell (tasksh) program, which
among a few other thins provides a `review` command that helps your
cycle through your task list and keep it current.

Some would argue that spending as little time on your task list as possible 
means more time for doing work. While this is true, it does assume that you
are doing the right work. While this is true, it does assume that you
are doing the right work. Good advice would be to spend as little time as 
you can on the task list, but enough to make sure that it is up-to-date,
correct and complete. Then rely on the tools and go get some work done.

## Common Sense
Use a task list, look at it often, correct any mistakes and remove items that
no longer apply. Choose a methodology that works for you 
(GTD, Pomodoro, ...) or devise your own - it's not complicated. Be consistent,
Backup your data.

## Future Enhancements
We are always looking into better ways to represent your task list, better
ways to display it, and better ways to supper methodologies that work. We
will be adding features that help in some way, for some people, and we will
be correcting what is not working. Taskwarrior is a toolkit, and a
comprehensive one, intended to support the different ways people do work.
You will not need every feature, but everyone uses a different set of
features, according to their own approach. But every feature that you do use
will help you work with your list better.
