import 'package:decimal/decimal.dart';
import 'package:wallet/ezc/wallet/utils/number_utils.dart';

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
    return bnToLocaleString(getTotalAmount(), denomination: denomination);
  }

  @override
  String toString() {
    return bnToLocaleString(amount, denomination: denomination);
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
