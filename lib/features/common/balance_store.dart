import 'package:decimal/decimal.dart';
import 'package:eventify/eventify.dart';
import 'package:injectable/injectable.dart';
import 'package:mobx/mobx.dart';
import 'package:wallet/common/logger.dart';
import 'package:wallet/di/di.dart';
import 'package:wallet/ezc/sdk/apis/avm/constants.dart';
import 'package:wallet/ezc/sdk/apis/avm/utxos.dart';
import 'package:wallet/ezc/sdk/utils/bintools.dart';
import 'package:wallet/ezc/sdk/utils/constants.dart';
import 'package:wallet/ezc/wallet/asset/types.dart';
import 'package:wallet/features/common/chain_type/ezc_type.dart';
import 'package:wallet/features/common/wallet_factory.dart';
import 'package:wallet/ezc/wallet/network/utils.dart';
import 'package:wallet/ezc/wallet/types.dart';
import 'package:wallet/ezc/wallet/utils/number_utils.dart';

part 'balance_store.g.dart';

const decimalNumber = 3;

@LazySingleton()
class BalanceStore = _BalanceStore with _$BalanceStore;

abstract class _BalanceStore with Store {
  final _wallet = getIt<WalletFactory>().activeWallet;

  @observable
  Decimal totalEzc = Decimal.zero;

  @observable
  Decimal staking = Decimal.zero;

  @observable
  Decimal balanceX = Decimal.zero;

  @observable
  Decimal balanceP = Decimal.zero;

  @observable
  Decimal balanceC = Decimal.zero;

  @observable
  Decimal balanceLockedX = Decimal.zero;

  @observable
  Decimal balanceLockedP = Decimal.zero;

  @observable
  Decimal balanceLockedStakeableP = Decimal.zero;

  @observable
  bool isTotalLoaded = false;

  @observable
  ObservableList<AvaAsset> antAssets = ObservableList<AvaAsset>();

  @observable
  ObservableList<AssetDescriptionClean> nftAssets =
      ObservableList<AssetDescriptionClean>();

  bool _isXLoaded = false;
  bool _isPLoaded = false;
  bool _isCLoaded = false;
  bool _needFetchTotal = false;

  String get balanceXString => decimalBalance(balanceX);

  String get balanceCString => decimalBalance(balanceC);

  String get balancePString => decimalBalance(balanceP);

  init() {
    _wallet.on(WalletEventType.balanceChangedX, _handleCallback);
    _wallet.on(WalletEventType.balanceChangedP, _handleCallback);
    _wallet.on(WalletEventType.balanceChangedC, _handleCallback);
    updateTotalBalance();
  }

  @action
  dispose() {
    _wallet.off(WalletEventType.balanceChangedX, _handleCallback);
    _wallet.off(WalletEventType.balanceChangedP, _handleCallback);
    _wallet.off(WalletEventType.balanceChangedC, _handleCallback);
    totalEzc = Decimal.zero;
    staking = Decimal.zero;
    balanceX = Decimal.zero;
    balanceP = Decimal.zero;
    balanceC = Decimal.zero;
    balanceLockedX = Decimal.zero;
    balanceLockedP = Decimal.zero;
    balanceLockedStakeableP = Decimal.zero;
    antAssets = ObservableList.of([]);
    nftAssets = ObservableList.of([]);
    isTotalLoaded = false;
    _isXLoaded = false;
    _isPLoaded = false;
    _isCLoaded = false;
    _needFetchTotal = false;
  }

  @action
  updateBalance() {
    updateBalanceX();
    updateBalanceP();
    updateBalanceC();
  }

  @action
  updateTotalBalance() {
    _needFetchTotal = true;
    updateBalance();
  }

  _handleCallback(Event event, Object? context) async {
    final eventName = event.eventName;
    final eventData = event.eventData;
    if (eventName == WalletEventType.balanceChangedX.type &&
        eventData is WalletBalanceX) {
      final x = eventData[getAvaxAssetId()];
      if (x != null) {
        _getAssets();
        balanceX = bnToDecimalAvaxX(x.unlocked);
        balanceLockedX = bnToDecimalAvaxX(x.locked);
        if (_needFetchTotal) {
          _isXLoaded = true;
        }
      }
    }
    if (eventName == WalletEventType.balanceChangedP.type &&
        eventData is AssetBalanceP) {
      balanceP = bnToDecimalAvaxP(eventData.unlocked);
      balanceLockedP = bnToDecimalAvaxP(eventData.locked);
      balanceLockedStakeableP = bnToDecimalAvaxP(eventData.lockedStakeable);
      if (_needFetchTotal) {
        _isPLoaded = true;
      }
    }
    if (eventName == WalletEventType.balanceChangedC.type &&
        eventData is WalletBalanceC) {
      balanceC = bnToDecimalAvaxC(eventData.balance);
      if (_needFetchTotal) {
        _isCLoaded = true;
      }
    }
    if (_needFetchTotal && _isXLoaded && _isPLoaded && _isCLoaded) {
      _isXLoaded = false;
      _isPLoaded = false;
      _isCLoaded = false;
      _needFetchTotal = false;
      _fetchTotal();
    }
  }

  updateBalanceX() async {
    try {
      await _wallet.updateUtxosX();
    } catch (e) {
      logger.e(e);
    }
  }

  updateBalanceP() async {
    try {
      await _wallet.updateUtxosP();
    } catch (e) {
      logger.e(e);
    }
  }

  updateBalanceC() async {
    try {
      await _wallet.updateAvaxBalanceC();
    } catch (e) {
      logger.e(e);
      return;
    }
  }

  Decimal getBalance(EZCType chain) {
    switch (chain) {
      case EZCType.xChain:
        return balanceX;
      case EZCType.pChain:
        return balanceP;
      case EZCType.cChain:
        return balanceC;
    }
  }

  String getBalanceText(EZCType chain) {
    switch (chain) {
      case EZCType.xChain:
        return balanceXString;
      case EZCType.pChain:
        return balancePString;
      case EZCType.cChain:
        return balanceCString;
    }
  }

  _fetchTotal() async {
    final avaxBalance = _wallet.getAvaxBalance();
    final totalAvaxBalanceDecimal = avaxBalance.totalDecimal;

    final staked = await _wallet.getStake();
    staking = bnToDecimalAvaxP(staked.stakedBN);

    totalEzc = totalAvaxBalanceDecimal + staking;
    isTotalLoaded = true;
  }

  String decimalBalance(Decimal balance) {
    return decimalToLocaleString(balance, decimals: decimalNumber);
  }

  _getAssets() {
    final avaAssetId = getAvaxAssetId();
    final assetUtxoMap = <String, AvmUTXO>{};
    for (final utxo in _wallet.utxosX.utxos.values) {
      assetUtxoMap[cb58Encode(utxo.assetId)] = utxo;
    }
    final unknownAssets = _wallet.getUnknownAssets();

    final antAssets = <AssetDescriptionClean>[];
    final nftAssets = <AssetDescriptionClean>[];

    for (final unknownAsset in unknownAssets) {
      final output = assetUtxoMap[unknownAsset.assetId]?.getOutput();
      if (output == null) {
        continue;
      }
      if (output.getOutputId() == SECPXFEROUTPUTID &&
          unknownAsset.assetId != avaxAssetId) {
        antAssets.add(unknownAsset);
      }
      if (output.getOutputId() == NFTMINTOUTPUTID) {
        nftAssets.add(unknownAsset);
      }
    }

    final balanceDict = _wallet.getBalanceX();
    final assets = antAssets.map((asset) {
      final avaAsset = AvaAsset(
        id: asset.assetId,
        name: asset.name,
        symbol: asset.symbol,
        denomination: int.tryParse(asset.denomination) ?? 0,
      );
      final balanceAmt = balanceDict[avaAsset.id];
      if (balanceAmt == null) {
        avaAsset.resetBalance();
      } else {
        avaAsset.resetBalance();
        avaAsset.addBalance(balanceAmt.unlocked);
        avaAsset.addBalanceLocked(balanceAmt.locked);
      }
      return avaAsset;
    }).toList();

    assets.customSort(avaAssetId);

    this.antAssets = ObservableList.of(assets);
    this.nftAssets = ObservableList.of(nftAssets);
  }
}

extension DecimalExtension on Decimal {
  String text({int decimals = decimalNumber}) {
    return decimalToLocaleString(this, decimals: decimals);
  }
}
