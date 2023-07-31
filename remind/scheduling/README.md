# Display calendar:
```
remind -c ~/scheduling/domestic_tasks.rem
```

# Display calendar 3 months calendar:
```
remind -c3 ~/scheduling/domestic_tasks.rem
```
# Convert to .ics file:
```
remind -s360 -irem2ics=1 ./test.rem 1 Jul 2023 | TZ=America/Bogota rem2ics -do > ./google_calendar.ics

remind -s -irem2ics=1 ./test.rem 1 Jul 2023 | TZ=America/Bogota rem2ics -do > ./google_calendar.ics
```
# Convert to .ics for 1 month only:
```
remind -s1 -irem2ics=1 ./test.rem 1 Jul 2023 | TZ=America/Bogota rem2ics -do > ./google_calendar.ics
```
