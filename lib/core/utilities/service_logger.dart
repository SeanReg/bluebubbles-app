import 'package:bluebubbles/utils/logger.dart';

class ServiceLogger {
  String name;

  ServiceLogger(this.name);

  info(dynamic message) => Logger.info(message, tag: name);
  warn(dynamic message) => Logger.warn(message, tag: name);
  error(dynamic message) => Logger.error(message, tag: name);
  debug(dynamic message) => Logger.debug(message, tag: name);
}