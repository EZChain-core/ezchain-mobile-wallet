import 'package:wallet/roi/wallet/asset/types.dart';

abstract class AssetBalanceRawX {
  BigInt locked = BigInt.zero;
  BigInt unlocked = BigInt.zero;

  AssetBalanceRawX({required this.locked, required this.unlocked});
}

class AssetBalanceX extends AssetBalanceRawX {
  final AssetDescriptionClean meta;

  AssetBalanceX(
      {required BigInt locked, required BigInt unlocked, required this.meta})
      : super(locked: locked, unlocked: unlocked);
}

typedef WalletBalanceX = Map<String, AssetBalanceX>;
