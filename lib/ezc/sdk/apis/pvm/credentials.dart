import 'package:wallet/ezc/sdk/apis/pvm/constants.dart';
import 'package:wallet/ezc/sdk/common/credentials.dart';

Credential selectCredentialClass(
  int credId, {
  Map<String, dynamic> args = const {},
}) {
  switch (credId) {
    case SECPCREDENTIAL:
      return PvmSECPCredential();
    default:
      throw Exception(
          "Error - SelectCredentialClass: unknown credId = $credId");
  }
}

class PvmSECPCredential extends Credential {
  @override
  String get typeName => "PvmSECPCredential";

  PvmSECPCredential() {
    setTypeId(SECPCREDENTIAL);
  }

  @override
  int getCredentialId() {
    return getTypeId();
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
