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
