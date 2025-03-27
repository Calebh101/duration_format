import 'dart:async';

import 'package:duration_format/duration_format.dart';

void main(List<String> args) {
  print("starting...");
  int milliseconds = 0;

  Timer.periodic(Duration(milliseconds: 1), (timer) {
    milliseconds++;
    print(Duration(milliseconds: milliseconds).format(DurationFormat.pretty(showDays: true, showHours: true, showSeconds: true, showMilliseconds: true, finalPhraseMode: DurationFormatFinalPhraseMode.and)));
  });
}