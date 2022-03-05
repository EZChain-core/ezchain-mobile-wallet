import 'package:decimal/decimal.dart';
import 'package:wallet/ezc/wallet/asset/types.dart';
import 'package:wallet/ezc/wallet/utils/number_utils.dart';

enum ChainAlias { X, P }

enum ExportChainsX { P, C }

extension ExportChainsXString on ExportChainsX {
  String get value {
    switch (this) {
      case ExportChainsX.P:
        return "P";
      case ExportChainsX.C:
        return "C";
    }
  }
}

enum ExportChainsP { X, C }

extension ExportChainsPString on ExportChainsP {
  String get value {
    switch (this) {
      case ExportChainsP.X:
        return "X";
      case ExportChainsP.C:
        return "C";
    }
  }
}

enum ExportChainsC { X, P }

extension ExportChainsCString on ExportChainsC {
  String get value {
    switch (this) {
      case ExportChainsC.X:
        return "X";
      case ExportChainsC.P:
        return "P";
    }
  }
}

enum HdChainType { X, P }

class AvaxBalance {
  final AssetBalanceRawX x;
  final AssetBalanceP p;
  final BigInt c;

  AvaxBalance({required this.x, required this.p, required this.c});

  Decimal get totalDecimal =>
      bnToDecimalAvaxX(x.unlocked) +
      bnToDecimalAvaxP(p.unlocked) +
      bnToDecimalAvaxC(c);

  String get total => decimalToLocaleString(totalDecimal);
}

class AssetBalanceRawX {
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

class AssetBalanceP {
  BigInt locked = BigInt.zero;
  BigInt unlocked = BigInt.zero;
  BigInt lockedStakeable = BigInt.zero;

  AssetBalanceP(
      {required this.locked,
      required this.unlocked,
      required this.lockedStakeable});

  String get lockedDecimal => bnToAvaxP(locked);

  String get unlockedDecimal => bnToAvaxP(unlocked);

  String get lockedStakeableDecimal => bnToAvaxP(lockedStakeable);
}

class WalletBalanceC {
  final BigInt balance;

  WalletBalanceC({required this.balance});

  String get balanceDecimal => bnToAvaxC(balance);
}

enum WalletEventType { balanceChangedX, balanceChangedP, balanceChangedC }

extension WalletEventTypeString on WalletEventType {
  String get type {
    switch (this) {
      case WalletEventType.balanceChangedX:
        return "balanceChangedX";
      case WalletEventType.balanceChangedP:
        return "balanceChangedP";
      case WalletEventType.balanceChangedC:
        return "balanceChangedC";
    }
  }
}
