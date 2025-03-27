/// Library for duration_format package.
library duration_format;

/// This extension goes onto Duration to provide it with methods to format with.
extension DurationFormatExtension on Duration {
  /// Format the [Duration] based on a [DurationFormat] object;
  String format(DurationFormat formatter) {
    return _format(this, formatter);
  }
}

/// Judges how to render the milliseconds part of the clock format.
/// hide: Don't show milliseconds.
/// colon: Show milliseconds using a colon. (7:03:47)
/// semicolon: Show milliseconds using a semicolon. (7:03;47)
enum DurationFormatMillisecondsClockMode {
  /// Don't show milliseconds.
  hide,

  /// Show milliseconds using a colon.
  /// Example: 7:03:47
  colon,

  /// Show milliseconds using a semicolon.
  /// Example: 7:03;47
  semicolon,
}

/// Judges how to format the final item of the "pretty" mode.
/// comma: 3 days, 5 hours, 7 minutes
/// and: 3 days, 5 hours and 7 minutes
/// commaAnd: 3 days, 5 hours, and 7 minutes
enum DurationFormatFinalPhraseMode {
  /// 3 days, 5 hours, 7 minutes
  comma,

  /// 3 days, 5 hours and 7 minutes
  and,

  /// 3 days, 5 hours, and 7 minutes
  commaAnd,
}

/// Class used to outline the format the duration should be formatted as.
class DurationFormat {
  /// Show milliseconds in the formatted duration.
  /// If using DurationFormat.clock: [showMilliseconds] must be a [DurationFormatMillisecondsClockMode] object.
  /// If using DurationFormat.pretty: [showMilliseconds] must be a boolean.
  dynamic showMilliseconds = DurationFormatMillisecondsClockMode.hide;

  /// Judges how to format the final item of the "pretty" mode.
  /// comma: 3 days, 5 hours, 7 minutes
  /// and: 3 days, 5 hours and 7 minutes
  /// commaAnd: 3 days, 5 hours, and 7 minutes
  DurationFormatFinalPhraseMode finalPhraseMode =
      DurationFormatFinalPhraseMode.commaAnd;

  /// Show seconds in the formatted duration.
  bool showSeconds = false;

  /// Show minutes in the formatted duration.
  bool showMinutes = true;

  /// Show hours in the formatted duration.
  bool showHours = false;

  /// Show days in the formatted duration.
  bool showDays = false;

  /// Mode of the [DurationFormat] object.
  int mode = 0;

  /// How many digits of the milliseconds are shown.
  /// Must be either 2 or 3.
  int millisecondDigits = 2;

  /// Turn
  List _generateList({required bool showMilliseconds}) {
    return [showSeconds, showMinutes, showHours, showDays, showMilliseconds];
  }

  /// Format the [Duration] into a clock-like string.
  /// Format: days:hours:minutes:seconds:milliseconds
  ///
  /// Note: [showMilliseconds] must be a [DurationFormatMillisecondsClockMode] object.
  DurationFormat.clock(
      {this.showSeconds = false,
      this.showMinutes = true,
      this.showHours = true,
      this.showDays = true,
      this.showMilliseconds = DurationFormatMillisecondsClockMode.hide,
      this.millisecondDigits = 2}) {
    mode = 1;
    if (showMilliseconds.runtimeType != DurationFormatMillisecondsClockMode) {
      throw Exception(
          "showMilliseconds must be of type \"DurationFormatMillisecondsClockMode\" in DurationFormat.clock().");
    }

    List list = _generateList(
        showMilliseconds:
            showMilliseconds != DurationFormatMillisecondsClockMode.hide);
    if (millisecondDigits < 2 || millisecondDigits > 3) {
      throw Exception(
          "millisecondsDigits must be a valid integer between 2 and 3 (inclusive).");
    }
    if (list.where((value) => value).length < 2) {
      throw Exception(
          "At least 2 time nodes need to be shown in the formatter.");
    }
    if (_invalidSelection(list)) {
      throw Exception("Invalid list of time nodes based on boolean values.");
    }
  }

  /// Format the [Duration] into a human-readable string.
  /// Example: 3 days, 7 hours, 4 minutes, 45 seconds, and 94 milliseconds.
  ///
  /// Note: [showMilliseconds] must be a non-null boolean.
  DurationFormat.pretty(
      {this.showSeconds = false,
      this.showHours = true,
      this.showMinutes = true,
      this.showDays = true,
      this.showMilliseconds = false,
      this.finalPhraseMode = DurationFormatFinalPhraseMode.commaAnd,
      this.millisecondDigits = 3}) {
    mode = 2;
    if (showMilliseconds.runtimeType != bool) {
      throw Exception(
          "showMilliseconds must be of type \"bool\" in DurationFormat.pretty().");
    }
    if (millisecondDigits < 2 || millisecondDigits > 3) {
      throw Exception(
          "millisecondsDigits must be a valid integer between 2 and 3 (inclusive).");
    }

    List list = _generateList(showMilliseconds: showMilliseconds);
    if (_invalidSelection(list)) {
      throw Exception("Invalid list of time nodes based on boolean values.");
    }
  }

  bool _invalidSelection(List list) {
    for (int i = 1; i < list.length - 1; i++) {
      if (list[i - 1] == true && list[i] == false && list[i + 1] == true) {
        return true;
      }
    }
    return false;
  }
}

String _format(Duration duration, DurationFormat formatter) {
  Map times = _values(duration, formatter);
  List values = [];

  bool showDays =
      formatter.showDays && (times["days"] > 0 || formatter.showHours == false);
  bool showHours = formatter.showHours &&
      (times["hours"] > 0 || formatter.showMinutes == false);
  bool showMinutes = formatter.showMinutes;
  bool showSeconds = formatter.showSeconds;
  bool showMilliseconds = formatter.showMilliseconds
          is DurationFormatMillisecondsClockMode
      ? formatter.showMilliseconds != DurationFormatMillisecondsClockMode.hide
      : formatter.showMilliseconds == true;

  if (showDays) values.add({"key": "day", "value": "${times["days"]}"});
  if (showHours) {
    values.add({
      "key": "hour",
      "value": "${times["hours"]}"
          .padLeft(showDays && formatter.mode == 1 ? 2 : 0, "0")
    });
  }
  if (showMinutes) {
    values.add({
      "key": "minute",
      "value": "${times["minutes"]}"
          .padLeft(showHours && formatter.mode == 1 ? 2 : 0, "0")
    });
  }
  if (showSeconds) {
    values.add({
      "key": "second",
      "value": "${times["seconds"]}"
          .padLeft(showMinutes && formatter.mode == 1 ? 2 : 0, "0")
    });
  }
  if (showMilliseconds) {
    values.add({
      "key": "millisecond",
      "value": "${times["milliseconds"]}"
          .padLeft(3, "0")
          .substring(0, formatter.millisecondDigits)
    });
  }

  if (values.length == 2 &&
      formatter.finalPhraseMode == DurationFormatFinalPhraseMode.commaAnd) {
    formatter.finalPhraseMode = DurationFormatFinalPhraseMode.and;
  }

  if (formatter.mode == 1) {
    return "${values.sublist(0, values.length - 1).map((item) => item["value"]).join(":")}${values.last["key"] == "milliseconds" ? (formatter.showMilliseconds == DurationFormatMillisecondsClockMode.colon ? ":" : ";") : ":"}${values.last["value"]}";
  } else if (formatter.mode == 2) {
    List stringValues = [];
    for (var entry in values.asMap().entries) {
      int index = entry.key;
      String value = entry.value["value"];
      String key = entry.value["key"];
      if (int.parse(value) != 1) key = "${key}s";
      if (index == (values.length - 1)) {
        // last item, respect finalPhraseMode
        if (values.length == 1) {
          stringValues.add("$value $key");
        } else {
          switch (formatter.finalPhraseMode) {
            case DurationFormatFinalPhraseMode.and ||
                  DurationFormatFinalPhraseMode.commaAnd:
              stringValues.add("and $value $key");
            case DurationFormatFinalPhraseMode.comma:
              stringValues.add("$value $key");
          }
        }
      } else {
        stringValues.add(
            "$value $key${((index == (values.length - 2)) && formatter.finalPhraseMode == DurationFormatFinalPhraseMode.and) ? "" : ","}");
      }
    }

    return stringValues.join(" ");
  } else {
    throw Exception(
        "The formatter \"mode\" property is not a valid mode in function _format().");
  }
}

Map _values(Duration duration, DurationFormat formatter) {
  int milliseconds = duration.inMilliseconds - (duration.inSeconds * 1000);
  int seconds = (duration.inMilliseconds / 1000).floor();
  int minutes =
      formatter.showHours ? (duration.inMinutes % 60) : duration.inMinutes;
  int hours = formatter.showDays ? (duration.inHours % 24) : duration.inHours;
  int days = duration.inDays;

  if (formatter.showMinutes) {
    seconds = seconds % 60;
  }

  return {
    "milliseconds": milliseconds,
    "seconds": seconds,
    "minutes": minutes,
    "hours": hours,
    "days": days,
  };
}
