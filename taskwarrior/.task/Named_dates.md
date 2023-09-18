# Named Dates
The term 'date' is used here to describe a 'timestamp' of varying precision and
specificity. The terms 'timestamp', or 'datetime' also apply.

Taskwarrior supports the notion of specifying dates in several ways. There are 
`ISO-8601` dates:

```
2024-06-07T16:55:04-05:00
2024-W23
20240607
```

There are `rc.dateformat` dates, the default being `YYYY-MM-DD`:
```
2024-06-07
```

This document enumerates and defines other dates, such as `tomorrow` and
many other.

## Days of the week
The days of the week are interpreted as the next day in the future. To specify a
day in the past, use a different date format.
- `mon`, `monday` The date of the nearest future monday at `00:00:00` local.

## Day Ordinals
Day ordinals are the days in the month, numbered starting from 1, to either the
28th, 29th, 30th or 31st, depending on the current month.
- `1st`, `2nd`, `3rd`,... The date of the nearest future `Nth` day at `00:00:00`
local.

Note that if today is February `20th`, specifying `31st` is an error, and does not
mean March 31. For this, use a precise date format.

## Months of the Year
The months of the year are interpreted as the first day of the next month of that
name in the future. To specify a month in the past, use a different date format.
- `jan`, `january` The date of the nearest future January 1st, at `00:00:00` local.

The months are reognized in three-letter abbreviated form and the full month
name only.

## Year Dates
Year dates are abbreviated names for dates within the year, that occur at various
boundaries. The abbreviations use `s` to mean the start, and `e` to mean the end
of the period. The periods are indicated using `m` (month), `q` (quarter) and `y`
(year). So the date `socy` means 'start of current year'.
- `socy` Start of the current year. Time is `00:00:00` local.
- `eocy` End of the current year. Time is `00:00:00` local.

- `socq` Start of the current quarter. Time is `00:00:00` local.
- `eocq` End of the current quarter. Time is `00:00:00` local.

- `socm` Start of the current month. Time is `00:00:00` local.
- `eocm`  End of the current month. Time is `00:00:00` local.

| Abbreviation   | Description   |
|---------- | --------- |
| `socy`    | Start Of the Current Year |
| `eocy`    | End Of the Current Year   |
|         |                           |
| `socq`    | Start Of the Current Quarter |
| `eocq`   | End Of the Current Quater  | 
|         |                          |
| `socm`   | Start Of the Current Month   |
| `eocm`   | End Of the Current Month     |
|         |                          |
| `soy`   | Start Of the next Year.  |
| `eoy`   | End Of the Year. |
|         |                          |
| `soq`   | Start Of the Quater. |
| `eoq`   | End Of the Quater. |
|         |                          |
| `som`   | Start Of the Month. |
| `eom`   | End Of the Month. |

There is redundancy in the table, and it exists for the sake of symmetry. For
example, `eom` and `eocm` are always the same, but exist so that every date has
a matching pair.

![Year Dates](/taskwarrior/.task/named_dates0.png)

## Week Dates
Week dates are abbreviated names for dates within the week, that occur at
various boundaries. The abbreviations use `s` to mean the start, and `e` to mean
the end of the period. The periods are indicated using `d` (day), `w` (week):
| Abbreviation   | Description   |
|---------- | --------- |
| `socw`    | Start of the current week. | 
| `eocw`    | End of the current week. | 
|         |                       |
| `sow`    | Start of the next week. | 
| `eow`    | End of the next week. | 
|         |                       |
| `soww`    | Start of the next work week. | 
| `eoww`    | End of the next work week. | 
|         |                       |
| `sod`    | Start of today. | 
| `eod`    | End of today. | 
|         |                       |
| `yesterday`    | Start of yesterday. | 
| `today`    | Start of today. | 
| `now`    | Right now. | 
| `tomorrow`    | Start of tomorrow. | 

Again, there is redundancy in the table, for the sake of symmetry:
![Week Dates](/taskwarrior/.task/named_dates1.png)

## Calculated Dates
These dates are from algorithms, and easily calculated:
- `later`, `someday` January 18th, 2038, the end of time. Time is `00:00:00`
local.
- `easter`, `eastermonday`, `pentecost`, `ascension`, `goodfriday` Time
is `00:00:00` local.
- `midsommarafton`, `midsommar` First Friday and Saturday after 19th
June. Time is `00:00:00` local.
