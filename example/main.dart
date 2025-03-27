import 'dart:async';

import 'package:duration_format/duration_format.dart';

void main(List<String> args) {
  int milliseconds = 0;
  DurationFormat prettyFormat = DurationFormat.pretty(showDays: true, showHours: true, showMinutes: true, showSeconds: true, showMilliseconds: false, millisecondDigits: 2, finalPhraseMode: DurationFormatFinalPhraseMode.and);
  DurationFormat clockFormat = DurationFormat.clock(showDays: true, showHours: true, showMinutes: true, showSeconds: true, showMilliseconds: DurationFormatMillisecondsClockMode.colon, millisecondDigits: 2);

  print("clockFormat: $clockFormat");
  print("prettyFormat: $prettyFormat");

  Timer.periodic(Duration(milliseconds: 1000), (timer) {
    milliseconds = milliseconds + 1000;
    print(
        "${Duration(milliseconds: milliseconds).format(prettyFormat)} - ${Duration(milliseconds: milliseconds).format(clockFormat)}");
  });
}
