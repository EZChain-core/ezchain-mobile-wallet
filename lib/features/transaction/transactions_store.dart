import 'package:auto_route/auto_route.dart';
import 'package:decimal/decimal.dart';
import 'package:mobx/mobx.dart';
import 'package:wallet/common/logger.dart';
import 'package:wallet/common/router.gr.dart';
import 'package:wallet/di/di.dart';
import 'package:wallet/features/common/balance_store.dart';
import 'package:wallet/features/common/chain_type/ezc_type.dart';
import 'package:wallet/features/common/price_store.dart';
import 'package:wallet/features/common/wallet_factory.dart';
import 'package:wallet/features/wallet/receive/wallet_receive.dart';

part 'transactions_store.g.dart';

class TransactionsStore = _TransactionsStore with _$TransactionsStore;

abstract class _TransactionsStore with Store {
  final _wallet = getIt<WalletFactory>().activeWallet;

  final _balanceStore = getIt<BalanceStore>();
  final _priceStore = getIt<PriceStore>();

  @observable
  EZCType ezcType = EZCType.xChain;

  @computed
  Decimal get balance => _balanceStore.getBalance(ezcType);

  @computed
  String get balanceText => _balanceStore.decimalBalance(balance);

  @computed
  String get balanceUsd => _priceStore.getBalanceInUsd(balance);

  setEzcType(EZCType type) {
    ezcType = type;
    getTransactions(type);
  }

  String get addressX => _wallet.getAddressX();

  String get addressP => _wallet.getAddressP();

  String get addressC => _wallet.getAddressC();

  PageRouteInfo get receiveRoute {
    switch (ezcType) {
      case EZCType.xChain:
        return WalletReceiveRoute(
            walletReceiveInfo: WalletReceiveInfo(ezcType.name, addressX));
      case EZCType.pChain:
        return WalletReceiveRoute(
            walletReceiveInfo: WalletReceiveInfo(ezcType.name, addressP));
      case EZCType.cChain:
        return WalletReceiveRoute(
            walletReceiveInfo: WalletReceiveInfo(ezcType.name, addressC));
    }
  }

  getTransactions(EZCType type) async {
    try {
      switch (ezcType) {
        case EZCType.xChain:
          final transactions = await _wallet.getHistoryX(limit: 20);
          logger.i("getHistoryX = ${transactions.length}");
          break;
        case EZCType.pChain:
          final transactions = await _wallet.getHistoryP(limit: 20);
          logger.i("getHistoryP = ${transactions.length}");
          break;
        case EZCType.cChain:
          final transactions = await _wallet.getHistoryC(limit: 20);
          logger.i("getHistoryC = ${transactions.length}");
          break;
      }
    } catch (e) {
      logger.e(e);
    }
  }
}
