import 'package:wallet/roi/sdk/apis/evm/constants.dart';
import 'package:wallet/roi/sdk/common/credentials.dart';

Credential selectCredentialClass(int inputId,
    {Map<String, dynamic> args = const {}}) {
  switch (inputId) {
    case SECPCREDENTIAL:
      return EvmSECPCredential();
    default:
      throw Exception(
          "Error - SelectCredentialClass: unknown inputId = $inputId");
  }
}

class EvmSECPCredential extends Credential {
  @override
  String get typeName => "EvmSECPCredential";

  EvmSECPCredential() {
    setCodecId(LATESTCODEC);
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

  @override
  int getTypeId() => SECPCREDENTIAL;
}
