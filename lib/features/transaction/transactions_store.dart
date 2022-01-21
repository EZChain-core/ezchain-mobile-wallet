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
import 'package:wallet/roi/wallet/history/raw_types.dart';

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

  @observable
  List<Transaction> transactions = [];

  @action
  setEzcType(EZCType type) {
    ezcType = type;
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

  Future<List<Transaction>> getTransactions(EZCType type) async {
    await Future.delayed(const Duration(milliseconds: 300));
    try {
      switch (ezcType) {
        case EZCType.xChain:
          return _wallet.getTransactionsX(limit: 20);
        case EZCType.pChain:
          return _wallet.getTransactionsP(limit: 20);
        case EZCType.cChain:
          return _wallet.getTransactionsC(limit: 20);
      }
    } catch (e) {
      logger.e(e);
      return [];
    }
  }
}
