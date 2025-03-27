import 'package:duration_format/duration_format.dart';

void main(List<String> args) {
  print(Duration(milliseconds: 365837095).format(DurationFormat.clock(showDays: true, showHours: false, showSeconds: true, showMilliseconds: DurationFormatMillisecondsClockMode.colon)));
}