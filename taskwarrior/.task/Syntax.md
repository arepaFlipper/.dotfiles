##  Command line Syntax
There are four parts to the syntax:
- filter
- command
- modifications
- miscellaneous

And each part is optional:
`task [<filter>] [<command>] [<modifications> | <miscellaneous>]`

## Command
Each time you run `task` (Taskwarrior), you are issuing a "command"
either explicity, or implicity with the default command (there are
set of default configuration settings into `.taskrc` the lines 
with `default`.`<command>`). The `<command>` we specify determines
how the whole command line is understood by Taskwarrior:

| task  | <filter>   | <command>   | <modifications>   | <miscellaneous>   |
| ----- | ---------- | ----------- | ----------------- | ----------------- |
| `task`  |            | `list`        |                   |                   |
| `task`  |` +home      `| `list`        |                   |                   |
| `task`  | `12`         | `modify`      | `project:Garden`    |                   |
| `task`  |            | `show`        |                   |    `editor`         |

In the first the command `task list` will display a report with no filters.

The second command `task  +home list` will display a report with the filter `+home`

The third command `task 12 modify project:Garden` has both a filter and modifications.

The last example, `task show editor` will display the IDE is set in taskwarrior.

Taskwarrior looks for the first argument on the command line that looks like an exact command
name, and failing that, looks for an abbreviated command name. It is better to 
use the full name of a command to avoid ambiguity (pressing `<tab>` will autocomplete the command).

It is the position of the command argument, and the type of ccommand 
that determines how the arguments area understood.

## Fileter

A filter is a means of addressing a subset of tasks. Because filters are optional, 
the simplest case is no filter. A command with no filter addresses all tasks.

Generally filter arguments appear before the command, so any arguments to the left of the command are
considered filter arguments.

## Modifications
If a command accepts modifications, they generally appear after the command. Most commands that accept
modifications also accept filters, and so the filter arguments appear before the command, while the modifications
appear after.

`task +home status:pending modify priority:H due:eom`

This command specifies a compound filter, consisting of more than one term. These terms are logically 
combined with an `and` operator by default, unless otherwise specified. In this case, tasks that have both the `home` tag
and a `status` value of `pending` are to be modified.

The modifications, appearing after the command, set the `priority` to `H` and the `due` 
date to the end of the month (`eom`). So the modifications of adding `priority:H` and `due:eom` will be applied to the 
filtered tasks by the query `+home status:pending`.

Because the filter is evaluated at runtime, we don't know how many tasks will 
be modified. It could be none, one, many or all of the tasks. This could be determined with:

`task +home status:pending count`

The user writing this command would have an idea of how many tasks this will affect. This
way the user can decide how many tasks to modify.

## Miscellaneous

Some commands accept neither a filter, nor modifications, but do accept miscellaneous arguments. An 
example is the `show` command, that queries configuration settings, and does not accept a filter:

`task show report.list.filter`
`task report.list.filter show`

This is another special case, in which the command only accepts miscellaneous arguments, and so they
can appear before or after the command.

## Overrides

Overrides are temporary values for configuration settings, and can be specified anywhere on the command line,
because they are not considered to be either filter, modification or miscellaneous. In fact, the command itself
does not see the overrides, instead they are handled before the command runs.

`task` `rc.confirmation:off` `+home status:pending modify priority:H due:eom`
`task +home status:pending` `rc.confirmation:off ` `modify priority:H due:eom`
`task +home status:pending modify priority:H due:eom` `rc.confirmation:off`

There can be any number of overrides on the command line, and they have no effect on the syntax.
