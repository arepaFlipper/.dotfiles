# Color Themes
Taskwarrior supports color themes. These are simply configuration files with
defined color rules and rule precedence. Which can be included in your
`.taskrc` file like this:
```
include /path/to/darck-blue-256.theme
```

There are several themes included with the distribution, and the default 
`.taskrc` file you have references all of them, but these lines are commented
out. Uncomment one line to use the theme.

## Overriding Colors
You can override the color settings by placing changes after the include:

```
include /path/to/darck-blue-256.theme
color.overdue=bold white on red
```

In this way, themes are the basis upon which you specify your color
preferences.
