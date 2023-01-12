import 'package:logger/logger.dart';

final logger = new Logger(
  printer: PrettyPrinter(
      noBoxingByDefault: true,
      methodCount: 1,
      lineLength: 50,
      errorMethodCount: 3,
      colors: true,
      printEmojis: true),
);
