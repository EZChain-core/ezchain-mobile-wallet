import 'package:wallet/ezc/sdk/apis/evm/constants.dart';
import 'package:wallet/ezc/sdk/common/credentials.dart';

Credential selectCredentialClass(
  int credId, {
  Map<String, dynamic> args = const {},
}) {
  switch (credId) {
    case SECPCREDENTIAL:
      return EvmSECPCredential();
    default:
      throw Exception(
          "Error - SelectCredentialClass: unknown credId = $credId");
  }
}

class EvmSECPCredential extends Credential {
  @override
  String get typeName => "EvmSECPCredential";

  EvmSECPCredential() {
    setTypeId(SECPCREDENTIAL);
  }

  @override
  int getCredentialId() {
    return getTypeId();
  }

  @override
  EvmSECPCredential clone() {
    return create()..fromBuffer(toBuffer());
  }

  @override
  EvmSECPCredential create({Map<String, dynamic> args = const {}}) {
    return EvmSECPCredential();
  }

  @override
  Credential select(int id, {Map<String, dynamic> args = const {}}) {
    return selectCredentialClass(id, args: args);
  }
}
