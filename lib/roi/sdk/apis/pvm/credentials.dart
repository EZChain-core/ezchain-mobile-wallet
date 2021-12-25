import 'package:wallet/roi/sdk/apis/pvm/constants.dart';
import 'package:wallet/roi/sdk/common/credentials.dart';

Credential selectCredentialClass(int inputId,
    {Map<String, dynamic> args = const {}}) {
  switch (inputId) {
    case SECPCREDENTIAL:
      return PvmSECPCredential();
    default:
      throw Exception("Error - SelectOutputClass: unknown inputId = $inputId");
  }
}

class PvmSECPCredential extends Credential {
  @override
  String get typeName => "PvmSECPCredential";

  PvmSECPCredential() {
    setCodecId(SECPCREDENTIAL);
  }

  @override
  int getCredentialId() {
    return super.getTypeId();
  }

  @override
  PvmSECPCredential clone() {
    return create()..fromBuffer(toBuffer());
  }

  @override
  PvmSECPCredential create({Map<String, dynamic> args = const {}}) {
    return PvmSECPCredential();
  }

  @override
  Credential select(int id, {Map<String, dynamic> args = const {}}) {
    return selectCredentialClass(id, args: args);
  }
}