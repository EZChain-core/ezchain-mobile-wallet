import 'package:wallet/roi/sdk/utils/serialization.dart';

abstract class NBytes extends Serializable {
  @override
  String get _typeName => "NBytes";
}
