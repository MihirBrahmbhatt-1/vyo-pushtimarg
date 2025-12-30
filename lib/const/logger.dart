import 'dart:developer';

import 'package:logger/logger.dart';
import 'package:talker_flutter/talker_flutter.dart';

import 'app_constant.dart';

final Logger logger = Logger(printer: PrettyPrinter());

final talker = TalkerFlutter.init(
  logger: TalkerLogger(
    settings: TalkerLoggerSettings(
      colors: {
        LogLevel.debug: AnsiPen()..green(),
        LogLevel.info: AnsiPen()..white(),
        LogLevel.critical: AnsiPen()..red(),
        LogLevel.error: AnsiPen()..magenta(),
        LogLevel.warning: AnsiPen()..yellow(),
        LogLevel.verbose: AnsiPen()..gray(),
      },
    ),
    output: (message) {
      printTalker(message);
    },
  ),
  settings: TalkerSettings(enabled: true),
);

void printTalker(String text) async {
  if(isDisplayLogs) {
      log(text);
  }
}
