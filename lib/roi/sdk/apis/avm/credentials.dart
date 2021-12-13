import 'package:wallet/roi/sdk/apis/avm/constants.dart';
import 'package:wallet/roi/sdk/common/credentials.dart';

Credential selectCredentialClass(int inputId, {List<dynamic> args = const []}) {
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

  @override
  int get codecId => LATESTCODEC;

  @override
  int get typeId => codecId == 0 ? SECPCREDENTIAL : SECPCREDENTIAL_CODECONE;

  @override
  int getCredentialId() {
    return typeId;
  }

  @override
  AvmSECPCredential clone() {
    return create()..fromBuffer(toBuffer());
  }

  @override
  AvmSECPCredential create({List<dynamic> args = const []}) {
    return AvmSECPCredential();
  }

  @override
  Credential select(int id, {List<dynamic> args = const []}) {
    return selectCredentialClass(id, args: args);
  }

  void setCodecId(int codecId) {
    if (codecId != 0 && codecId != 1) {
      throw Exception(
          "Error - SECPCredential.setCodecID: invalid codecID. Valid codecIDs are 0 and 1.");
    }
    super.codecId = codecId;
    super.typeId = codecId == 0 ? SECPCREDENTIAL : SECPCREDENTIAL_CODECONE;
  }
}
