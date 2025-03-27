/// Library for duration_format package.
library duration_format;

/// This extension goes onto Duration to provide it with methods to format with.
extension DurationFormatExtension on Duration {
  /// Format the [Duration] based on a [DurationFormat] object;
  String format(DurationFormat formatter) {
    return _format(this, formatter);
  }
}

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

enum DurationFormatFinalPhraseMode {
  /// 3 days, 5 hours, 7 minutes
  comma,

  /// 3 days, 5 hours, and 7 minutes
  commaAnd,

  /// 3 days, 5 hours and 7 minutes
  and,
}

class DurationFormat {
  /// Show milliseconds in the formatted duration.
  dynamic showMilliseconds = DurationFormatMillisecondsClockMode.hide;

  DurationFormatFinalPhraseMode finalPhraseMode = DurationFormatFinalPhraseMode.commaAnd;

  /// Show seconds in the formatted duration.
  bool showSeconds = false;

  /// Show hours in the formatted duration.
  bool showHours = false;

  /// Show days in the formatted duration.
  bool showDays = false;

  /// Mode of the [DurationFormat] object.
  int mode = 0;

  /// Format the [Duration] into a clock-like string.
  /// Format: days:hours:minutes:seconds:milliseconds
  /// 
  /// Note: [showMilliseconds] must be a [DurationFormatMillisecondsClockMode] object.
  DurationFormat.clock({this.showSeconds = false, this.showHours = true, this.showDays = true, this.showMilliseconds = DurationFormatMillisecondsClockMode.hide}) {
    mode = 1;
    if (showMilliseconds.runtimeType != DurationFormatMillisecondsClockMode) throw Exception("showMilliseconds must be of type \"DurationFormatMillisecondsClockMode\" in DurationFormat.pretty().");
  }

  /// Format the [Duration] into a human-readable string.
  /// Example: 3 days, 7 hours, 4 minutes, 45 seconds, and 94 milliseconds.
  /// 
  /// Note: [showMilliseconds] must be a non-null boolean.
  DurationFormat.pretty({this.showSeconds = false, this.showHours = true, this.showDays = true, this.showMilliseconds = false, this.finalPhraseMode = DurationFormatFinalPhraseMode.commaAnd}) {
    mode = 2;
    if (showMilliseconds.runtimeType != bool) throw Exception("showMilliseconds must be of type \"bool\" in DurationFormat.pretty().");
  }
}

String _format(Duration duration, DurationFormat formatter) {
  Map times = _values(duration, formatter);
  List values = [];

  bool showDays = formatter.showDays && times["days"] > 0;
  bool showHours = formatter.showHours && times["hours"] > 0;
  bool showSeconds = formatter.showSeconds;
  bool showMilliseconds = formatter.showMilliseconds is DurationFormatMillisecondsClockMode ? formatter.showMilliseconds != DurationFormatMillisecondsClockMode.hide : formatter.showMilliseconds == true;
  
  if (showDays) values.add({"key": "days", "value": "${times["days"]}"});
  if (showHours) values.add({"key": "hours", "value": "${times["hours"]}".padLeft(showDays && formatter.mode == 1 ? 2 : 0, "0")});
  values.add({"key": "minutes", "value": "${times["minutes"]}".padLeft(showHours && formatter.mode == 1 ? 2 : 0, "0")});
  if (showSeconds) values.add({"key": "seconds", "value": "${times["seconds"]}".padLeft(2, "0")});
  if (showMilliseconds) values.add({"key": "milliseconds", "value": "${times["minutes"]}".padLeft(2, "0")});

  if (formatter.mode == 1) {
    return values.map((item) => item["value"]).join(":");
  } else if (formatter.mode == 2) {
    List stringValues = [];
    for (var entry in values.asMap().entries) {
      int index = entry.key;
      String value = entry.value["value"];
      String key = entry.value["key"];
      if (index == (values.length - 1)) { // last item, respect finalPhraseMode
        switch (formatter.finalPhraseMode) {
          case DurationFormatFinalPhraseMode.and || DurationFormatFinalPhraseMode.commaAnd: stringValues.add("and $value $key");
          case DurationFormatFinalPhraseMode.comma: stringValues.add("$value $key");
        }
      } else {
        stringValues.add("$value $key${((index == (values.length - 2)) && formatter.finalPhraseMode == DurationFormatFinalPhraseMode.and) ? "" : ","}");
      }
    }

    return stringValues.join(" ");
  } else {
    throw Exception("The formatter \"mode\" property is not a valid mode in function _format().");
  }
}

Map _values(Duration duration, DurationFormat formatter) {
  int milliseconds = duration.inMilliseconds - (duration.inSeconds * 1000);
  int seconds = duration.inSeconds - (duration.inMinutes * 60);
  int minutes = formatter.showHours ? (duration.inMinutes % 60) : duration.inMinutes;
  int hours = formatter.showDays ? (duration.inHours % 24) : duration.inHours;
  int days = duration.inDays;

  return {
    "milliseconds": milliseconds,
    "seconds": seconds,
    "minutes": minutes,
    "hours": hours,
    "days": days,
  };
}
