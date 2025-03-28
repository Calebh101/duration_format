# What is this?

This is a simple package to help you format a Duration object to a human-readable format. It's very helpful for timers and stopwatches.

This package does not format dates or times; use something like [intl](https://pub.dev/packages/intl).

# Usage

General syntax:

```dart
Duration().format(DurationFormat())
```

`Duration()` is the Duration object to be formatted, and `DurationFormat()` is the formatter.

## Clock format

General syntax:

```dart
Duration().format(DurationFormat.clock(showDays: bool, showHours: bool, showMinutes: bool, showSeconds: bool, showMilliseconds: DurationFormatMillisecondsClockMode, millisecondsDigits: int))
```

Options:
- showDays: show the days in the formatted string
- showHours: show the hours in the formatted string
- showMinutes: show the minutes in the formatted string
- showSeconds: show the seconds in the formatted string
- showMilliseconds: behavior of the milliseconds in the formatted string
    - This must be a `DurationFormatMillisecondsClockMode`, even though it's marked as a `dynamic`.
    - Valid values:
        hide: hide milliseconds in formatted string
        colon: separate the milliseconds from the seconds by a colon, like how all the other time values are separated
        semicolon: separate the milliseconds from the seconds by a semicolon
- millisecondsDigits: how many digits of the milliseconds will be shown in the formatted string
    - This must be a valid integer between 2 and 3 (inclusive).

This is the produced format: days:hours:minutes:seconds:milliseconds

Example: 3 days, 2 hours, 17 minutes, 52 seconds, and 97 milliseconds will produce:

`3:02:17:52:97`

## Pretty format

General syntax:

```dart
Duration().format(DurationFormat.pretty(showDays: bool, showHours: bool, showMinutes: bool, showSeconds: bool, showMilliseconds: bool, millisecondsDigits: int, finalPhraseMode: DurationFormatFinalPhraseMode))
```

Options:
- showDays: show the days in the formatted string
- showHours: show the hours in the formatted string
- showMinutes: show the minutes in the formatted string
- showSeconds: show the seconds in the formatted string
- showMilliseconds: show the milliseconds in the formatted string
- millisecondsDigits: how many digits of the milliseconds will be shown in the formatted string
    - This must be a valid integer between 2 and 3 (inclusive).
- finalPhraseMode: how to handle the final phrase of the formatted string
    - DurationFormatFinalPhraseMode.comma: 3 hours, 7 minutes, 47 seconds
    - DurationFormatFinalPhraseMode.and: 3 hours, 7 minutes and 47 seconds
    - DurationFormatFinalPhraseMode.commaAnd: 3 hours, 7 minutes, and 47 seconds

Example: 3 days, 2 hours, 17 minutes, 52 seconds, and 97 milliseconds

# How does it work?

This package creates an extension on the `Duration` object called DurationFormatExtension and adds the `format()` function. The `format()` function takes a `DurationFormat` object in as its primary parameter, which will be used as the guidelines for the formatting process.

# Errors that can occur

- `DurationFormatException`: called when there is an issue with how you setup the formatter (a `DurationFormat` object)
    - "showMilliseconds must be of type "DurationFormatMillisecondsClockMode" in DurationFormat.clock()."
        - You put an invalid type for showMilliseconds in `DurationFormat`.clock. You need to input a non-null DurationFormatMillisecondsClockMode value (`DurationFormatMillisecondsClockMode.hide`, `DurationFormatMillisecondsClockMode.colon`, or `DurationFormatMillisecondsClockMode.semicolon`).
    - "showMilliseconds must be of type "bool" in DurationFormat.pretty()."
        - You put an invalid type for showMilliseconds in `DurationFormat`.pretty. You need to input a non-null boolean value (`true` or `false`).
    - "millisecondsDigits must be a valid integer between 2 and 3 (inclusive)."
        - millisecondsDigits has to be a non-null integer between 2 and 3 (inclusive). This means that you basically have two options: `2` or `3`.
    - "At least 2 time nodes need to be shown in the formatter."
        - You need to show at least two time values in `DurationFormat`. For example, you can't *just* show minutes, you need to show at least minutes and seconds, or days and hours, etcetera. You just have to show at least 2 time values.
    - "Invalid list of time nodes based on boolean values."
        - This error is thrown when you show two separated values, like hours and seconds, but don't the value in between, like minutes (in this example). You can't show two separated things, without showing everything in between.
- `StateError`: called when an issue has occurred that can only have happened by user intervention
    - "The formatter's "mode" property is not a valid mode in function _format()."
        - The `mode` property of `DurationFormat` was manually set to something that was not valid. This is typically set to a separate value based on whether you used `DurationFormat.clock()` or `DurationFormat.pretty()`; but if it was manually set to an invalid value by the user, then this error will be thrown.