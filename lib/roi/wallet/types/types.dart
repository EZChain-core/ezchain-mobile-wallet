import 'package:wallet/roi/wallet/asset/types.dart';
import 'package:wallet/roi/wallet/utils/number_utils.dart';

abstract class AssetBalanceRawX {
  BigInt locked = BigInt.zero;
  BigInt unlocked = BigInt.zero;

  AssetBalanceRawX({required this.locked, required this.unlocked});

  String get lockedDecimal => bnToAvaxX(locked);

  String get unlockedDecimal => bnToAvaxX(unlocked);
}

class AssetBalanceX extends AssetBalanceRawX {
  final AssetDescriptionClean meta;

  AssetBalanceX(
      {required BigInt locked, required BigInt unlocked, required this.meta})
      : super(locked: locked, unlocked: unlocked);
}

typedef WalletBalanceX = Map<String, AssetBalanceX>;

enum WalletEventType {
  addressChanged,
  balanceChangedX,
  balanceChangedP,
  balanceChangedC
}

extension on WalletEventType {
  String get type {
    switch (this) {
      case WalletEventType.addressChanged:
        return "addressChanged";
      case WalletEventType.balanceChangedX:
        return "balanceChangedX";
      case WalletEventType.balanceChangedP:
        return "balanceChangedP";
      case WalletEventType.balanceChangedC:
        return "balanceChangedC";
    }
  }
}
