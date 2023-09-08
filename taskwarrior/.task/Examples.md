# Usage Examples

## Creating Tasks
Creating tasks is straightforward, but here are some tips:

Create a task with due date:
```
task add "Pay the mortgage monthly payment" due:som
```

- `due:eom` means end of month.
- `due:som` means start of month.

Create a task, then add a due date later:
```
❯ task add "Pay the mortgage monthly payment" 
Created task 12

❯ task 12 modify due:som
```

Remove a due date from a task:
```
❯ task 12 modify due:
```

Create a task with a multi-line description:
```
❯ task add "Five syllables here Seven more syllables there are you happy now? Lorem ipsum dolor sit amet, officia excepteur ex fugiat reprehenderit enim labore culpa sint ad nisi Lorem pariatur mollit ex esse exercitation amet. Nisi anim cupidatat excepteur officia. Reprehenderit nostrud nostrud ipsum Lorem est aliquip amet voluptate voluptate dolor minim nulla est proident. Nostrud officia pariatur ut officia. Sit irure elit esse ea nulla sunt ex occaecat reprehenderit commodo officia dolor Lorem duis laboris cupidatat officia voluptate. Culpa proident adipisicing id nulla nisi laboris ex in Lorem sunt duis officia eiusmod. Aliqua reprehenderit commodo ex non excepteur duis sunt velit enim. Voluptate laboris sint cupidatat ullamco ut ea consectetur et est culpa et culpa duis." 
```
Just wrap the text into quotes.

## Filters
A filter is how you restrict the tasks to just those that you want to see or 
modify.

Show tasks I added in the last 4 days:
```
❯ task entry.after:today-4days list
```

Show tasks I added yesterday:
```
❯ task entry:yesterday list
```

Show tasks I added in the last hour:
```
❯ task entry.after:now-1hour list
```

Show tasks I completed between a date range:
```
❯ task end.after:2015-01-01 and end.before:2023-09-01 completed
```

```
❯ task end.after:2015-01-01 and end.before:today completed
```

Show tasks I completed in the last week:
```
❯ task end.after:today-1wk completed
```

Show tasks in `This` project or `That` project:
```
❯ task project:This or project:That
```

More complex algebraic filters:
```
❯ task project:This and \( priority:H or priority:M \) list
```

Search for pattern in description and annotations:
```
❯ task /pattern/ list
❯ task rc.search.case.sensitive:yes /pattern/ list
❯ task rc.search.case.sensitive:no /pattern/ list
```

Search for tasks with no project:
```
❯ task project: list
```

## Reports
Reports are simply a collection of configuration settings that specify display
attributes, sorting, filter and a name.

Temporarily changing the sorting of a report:
```
❯ task rc.report.next.sort=due-,urgency- next
```

## Projects
A single project may be assigned to a task, and that project may be multiple
words.

Assign a long project name:
```
❯ task add Rake the leaves project:'Home & Garden'
```

Moving all tasks to a new project:
```
❯ task project:routine modify project:NEWNAME
❯ task project:routine or project:'Home & Garden' modify project:NEWNAME
```

Moving all pending tasks to a new project:
```
❯ task project:NEWNAME and status:pending modify project:routine
```

Using a project hierarchy:
```
❯ task add project:Home.Kitchen clean the floor
❯ task add project:Home.Kitchen Replace broken light bulb
❯ task add project:Home.Garden Plant the bulbs
❯ task project:Home.Kitchen count
```

```
❯ task project:Home.Kitchen count
2
❯ task project:Home.Garden count
1
❯ task project:Home count
3
```

What projects are currently used?
```
❯ task projects

Project   Tasks
(none)       12
Home          3
  Kitchen     2
  Garden      1
routine       5

4 projects (20 tasks)

❯ task _projects
Home.Garden
Home.Kitchen
routine
```

What are all the projects I have ever used?
```
❯ task rc.list.all.projects=1 projects
❯ task rc.list.all.projects=1 _projects
❯ task _unique project

```

```
❯ task rc.list.all.projects=1 projects

Project   Tasks
(none)      142
Home          3
  Kitchen     2
  Garden      1
routine       5

4 projects (150 tasks)
Configuration override rc.list.all.projects=1


❯ task rc.list.all.projects=1 _projects
Home.Garden
Home.Kitchen
routine


❯ task _unique project
Home.Garden
Home.Kitchen
routine
```

## Tags
Tags are simply one-word alphanumeric labels, and a task may have any
number of them.
