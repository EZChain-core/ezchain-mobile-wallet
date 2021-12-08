import 'package:wallet/roi/sdk/utils/serialization.dart';

class OutputOwners extends Serializable {
  @override
  String get _typeName => "OutputOwners";
}

abstract class Output extends OutputOwners {
  @override
  String get _typeName => "Output";
}
