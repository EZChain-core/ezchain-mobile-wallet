import 'package:wallet/ezc/sdk/apis/avm/constants.dart';
import 'package:wallet/ezc/sdk/common/credentials.dart';

Credential selectCredentialClass(
  int credId, {
  Map<String, dynamic> args = const {},
}) {
  switch (credId) {
    case SECPCREDENTIAL:
    case SECPCREDENTIAL_CODECONE:
      return AvmSECPCredential();
    case NFTCREDENTIAL:
    case NFTCREDENTIAL_CODECONE:
      return AvmNFTCredential();
    default:
      throw Exception(
          "Error - SelectCredentialClass: unknown credId = $credId");
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
          "Error - AvmSECPCredential.setCodecID: invalid codecID. Valid codecIDs are 0 and 1.");
    }
    super.setCodecId(codecId);
    super.setTypeId(codecId == 0 ? SECPCREDENTIAL : SECPCREDENTIAL_CODECONE);
  }
}

class AvmNFTCredential extends Credential {
  @override
  String get typeName => "AvmNFTCredential";

  AvmNFTCredential() {
    setCodecId(LATESTCODEC);
  }

  @override
  int getCredentialId() {
    return super.getTypeId();
  }

  @override
  AvmNFTCredential clone() {
    return create()..fromBuffer(toBuffer());
  }

  @override
  AvmNFTCredential create({Map<String, dynamic> args = const {}}) {
    return AvmNFTCredential();
  }

  @override
  Credential select(int id, {Map<String, dynamic> args = const {}}) {
    return selectCredentialClass(id, args: args);
  }

  @override
  void setCodecId(int codecId) {
    if (codecId != 0 && codecId != 1) {
      throw Exception(
          "Error - AvmNFTCredential.setCodecID: invalid codecID. Valid codecIDs are 0 and 1.");
    }
    super.setCodecId(codecId);
    super.setTypeId(codecId == 0 ? NFTCREDENTIAL : NFTCREDENTIAL_CODECONE);
  }
}
