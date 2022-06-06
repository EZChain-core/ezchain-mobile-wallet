
import 'package:flutter/material.dart';
import 'package:wallet/generated/assets.gen.dart';

enum NftPayloadType { json, utf8, url }

extension NftPayloadTypeExtension on NftPayloadType {
  String get name {
    return ["JSON", "UTF8", "URL"][index];
  }

  Widget get icon {
    return [
      Assets.icons.icCodeOutlineWhite.svg(),
      Assets.icons.icDocumentOutlineWhite.svg(),
      Assets.icons.icLinkOutlineWhite.svg(),
    ][index];
  }
}

NftPayloadType getNftPayloadType(String type) {
  return NftPayloadType.values.firstWhere((element) => element.name == type,
      orElse: () => NftPayloadType.utf8);
}