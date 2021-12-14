import 'package:wallet/roi/sdk/apis/avm/constants.dart';
import 'package:wallet/roi/sdk/common/credentials.dart';

Credential selectCredentialClass(int inputId,
    {Map<String, dynamic> args = const {}}) {
  switch (inputId) {
    case SECPCREDENTIAL:
    case SECPCREDENTIAL_CODECONE:
      return AvmSECPCredential();
    default:
      throw Exception("Error - SelectOutputClass: unknown inputId = $inputId");
  }
}

class AvmSECPCredential extends Credential {
  @override
  String get typeName => "AvmSECPCredential";

  AvmSECPCredential() {
    setCodecId(LATESTCODEC);
  }

  @override
  int getCredentialId() {
    return super.getTypeId();
  }

  @override
  AvmSECPCredential clone() {
    return create()..fromBuffer(toBuffer());
  }

  @override
  AvmSECPCredential create({Map<String, dynamic> args = const {}}) {
    return AvmSECPCredential();
  }

  @override
  Credential select(int id, {Map<String, dynamic> args = const {}}) {
    return selectCredentialClass(id, args: args);
  }

  @override
  void setCodecId(int codecId) {
    if (codecId != 0 && codecId != 1) {
      throw Exception(
          "Error - SECPCredential.setCodecID: invalid codecID. Valid codecIDs are 0 and 1.");
    }
    super.setCodecId(codecId);
    super.setTypeId(codecId == 0 ? SECPCREDENTIAL : SECPCREDENTIAL_CODECONE);
  }
}
