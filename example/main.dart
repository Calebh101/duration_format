import 'dart:async';

import 'package:duration_format/duration_format.dart';

void main(List<String> args) {
  print("Starting...");
  int milliseconds = 0;

  Timer.periodic(Duration(milliseconds: 1000), (timer) {
    milliseconds = milliseconds + 1000;
    print(
        "${Duration(milliseconds: milliseconds).format(DurationFormat.pretty(showDays: true, showHours: true, showMinutes: true, showSeconds: true, showMilliseconds: false, millisecondDigits: 2, finalPhraseMode: DurationFormatFinalPhraseMode.and))} - ${Duration(milliseconds: milliseconds).format(DurationFormat.clock(showDays: true, showHours: true, showMinutes: true, showSeconds: true, showMilliseconds: DurationFormatMillisecondsClockMode.colon, millisecondDigits: 2))}");
  });
}
