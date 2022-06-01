import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:decimal/decimal.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:wallet/ezc/sdk/apis/avm/outputs.dart';
import 'package:wallet/ezc/sdk/apis/avm/utxos.dart';
import 'package:wallet/ezc/sdk/utils/payload.dart';
import 'package:wallet/ezc/wallet/utils/number_utils.dart';

part 'types.g.dart';

typedef AssetCache = Map<String, AssetDescriptionClean>;

class AssetDescriptionClean {
  final String name;
  final String symbol;
  final String assetId;
  final String denomination;

  AssetDescriptionClean(
    this.name,
    this.symbol,
    this.assetId,
    this.denomination,
  );
}

class AvaAsset {
  String id;
  String name;
  String symbol;
  int denomination;
  BigInt amount = BigInt.zero;
  BigInt amountLocked = BigInt.zero;
  BigInt amountExtra = BigInt.zero;
  Decimal pow = Decimal.zero;

  AvaAsset(
      {required this.id,
      required this.name,
      required this.symbol,
      required this.denomination}) {
    pow = 10.toDecimal().pow(denomination);
  }

  addBalance(BigInt value) {
    amount += value;
  }

  addBalanceLocked(BigInt value) {
    amountLocked += value;
  }

  addExtra(BigInt value) {
    amountExtra += value;
  }

  resetBalance() {
    amount = BigInt.zero;
    amountLocked = BigInt.zero;
    amountExtra = BigInt.zero;
  }

  Decimal getAmount({bool locked = false}) {
    if (locked) {
      return (amountLocked.toDecimal() / pow).toDecimal();
    } else {
      return (amount.toDecimal() / pow).toDecimal();
    }
  }

  BigInt getTotalAmount() {
    return amount + amountLocked + amountExtra;
  }

  String toStringTotal() {
    return getTotalAmount().toLocaleString(denomination: denomination);
  }

  @override
  String toString() {
    return amount.toLocaleString(denomination: denomination);
  }
}

extension AvaAssets on List<AvaAsset> {
  customSort(String avaAssetId) {
    sort((a, b) {
      final symbolA = a.symbol.toUpperCase();
      final symbolB = b.symbol.toUpperCase();
      final amtA = a.getAmount();
      final amtB = b.getAmount();
      final idA = a.id;
      final idB = b.id;

      if (idA == avaAssetId) {
        return -1;
      } else if (idB == avaAssetId) {
        return 1;
      }

      if (amtA > amtB) {
        return -1;
      } else if (amtA < amtB) {
        return 1;
      }

      return symbolA.compareTo(symbolB);
    });
  }
}

class AvaNFTFamily {
  final AssetDescriptionClean asset;
  final AvmUTXO nftMintUTXO;
  final List<AvmUTXO> nftUTXOs;
  final Map<int, PayloadBase> groupIdPayloadDict;

  AvaNFTFamily({
    required this.asset,
    required this.nftMintUTXO,
    required this.nftUTXOs,
    required this.groupIdPayloadDict,
  });

  int get groupId => (nftMintUTXO.getOutput() as AvmNFTMintOutput).getGroupId();

  GenericNft? get firstGenericNft {
    final payloadBase = groupIdPayloadDict.values.firstOrNull;
    if (payloadBase == null || payloadBase is! JSONPayload) {
      return null;
    }
    try {
      final json = utf8.decode(payloadBase.getContent());
      return GenericFormType.fromJson(jsonDecode(json)).avalanche;
    } catch (e) {
      return null;
    }
  }
}

class AvaNFTCollectible {
  final AssetDescriptionClean asset;
  final List<AvmUTXO> nftUTXOs;
  final AvmUTXO? nftMintUTXO;
  final Map<int, PayloadBase> groupIdPayloadDict;
  final Map<int, List<AvmUTXO>> groupIdNFTUTXOsDict;

  bool get canMint => nftMintUTXO != null;

  AvaNFTCollectible({
    required this.asset,
    required this.nftUTXOs,
    this.nftMintUTXO,
    required this.groupIdPayloadDict,
    required this.groupIdNFTUTXOsDict,
  });
}

@JsonSerializable()
class GenericFormType {
  final GenericNft? avalanche;

  GenericFormType({this.avalanche});

  factory GenericFormType.fromJson(Map<String, dynamic> json) =>
      _$GenericFormTypeFromJson(json);

  Map<String, dynamic> toJson() => _$GenericFormTypeToJson(this);
}

@JsonSerializable()
class GenericNft {
  final int version;
  final String type;
  final String title;
  final String img;
  final String? desc;
  final int? radius;

  @JsonKey(name: "img_b")
  final String? imgB;

  @JsonKey(name: "img_m")
  final String? imgM;

  GenericNft({
    required this.version,
    required this.type,
    required this.title,
    required this.img,
    this.desc,
    this.radius,
    this.imgB,
    this.imgM,
  });

  factory GenericNft.fromJson(Map<String, dynamic> json) =>
      _$GenericNftFromJson(json);

  Map<String, dynamic> toJson() => _$GenericNftToJson(this);
}
