import 'package:logger/logger.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

final _logger = Logger(printer: SimplePrinter());

final prettyDioLogger = PrettyDioLogger(
  requestHeader: false,
  requestBody: false,
  responseBody: false,
  responseHeader: false,
  error: false,
  compact: false,
  maxWidth: 200,
  logPrint: (obj) => _logger.i(obj),
);
