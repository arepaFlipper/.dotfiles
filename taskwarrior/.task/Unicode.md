# Unicode
All text in Taskwarrior is UTG-8, which means any Unicode characters can be 
entered and stored. Here is a demo:
```
❯ task add "Download U+266C U+2669 for the plane"
Created task 25.


❯ task 25 list

ID Age   Description                    Urgency
25 17s   Download ♬ ♩ for the plane           0

1 task
```

Both the `U+NNNN` and `\\uNNNN` specifiers are supported, but it is usually simpler 
to use the first, which does not require the backslashes to be escaped in shells and scripts.

Note that the font you use in your terminal determines whether those characters 
are rendered, so it is possible to enter characters for which there is no glyph.
