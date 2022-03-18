import 'package:auto_route/auto_route.dart';
import 'package:decimal/decimal.dart';
import 'package:mobx/mobx.dart';
import 'package:wallet/common/logger.dart';
import 'package:wallet/common/router.gr.dart';
import 'package:wallet/di/di.dart';
import 'package:wallet/ezc/wallet/utils/number_utils.dart';
import 'package:wallet/features/common/store/balance_store.dart';
import 'package:wallet/features/common/type/ezc_type.dart';
import 'package:wallet/features/common/store/price_store.dart';
import 'package:wallet/features/common/store/validators_store.dart';
import 'package:wallet/features/common/wallet_factory.dart';
import 'package:wallet/features/transaction/transactions_item.dart';
import 'package:wallet/features/wallet/receive/wallet_receive.dart';
import 'package:wallet/ezc/sdk/apis/pvm/model/get_current_validators.dart';
import 'package:wallet/ezc/wallet/explorer/ortelius/types.dart';

part 'transactions_store.g.dart';

class TransactionsStore = _TransactionsStore with _$TransactionsStore;

abstract class _TransactionsStore with Store {
  final _wallet = getIt<WalletFactory>().activeWallet;

  final _balanceStore = getIt<BalanceStore>();
  final _priceStore = getIt<PriceStore>();
  final _validatorsStore = getIt<ValidatorsStore>();

  @observable
  EZCType ezcType = EZCType.xChain;

  @computed
  Decimal get balance => _balanceStore.getBalance(ezcType);

  @computed
  String get balanceText => _balanceStore.decimalBalance(balance);

  @computed
  String get balanceUsd =>
      decimalToLocaleString(balance * _priceStore.avaxPrice,
          decimals: decimalNumber);

  @computed
  List<Validator> get validators => _validatorsStore.validators;

  @action
  setEzcType(EZCType type) {
    ezcType = type;
  }

  String get _addressX => _wallet.getAddressX();

  String get _addressP => _wallet.getAddressP();

  String get _addressC => _wallet.getAddressC();

  String get address {
    switch (ezcType) {
      case EZCType.xChain:
        return _addressX;
      case EZCType.pChain:
        return _addressP;
      case EZCType.cChain:
        return _addressC;
    }
  }

  PageRouteInfo get receiveRoute {
    switch (ezcType) {
      case EZCType.xChain:
        return WalletReceiveRoute(
            args: WalletReceiveArgs(ezcType.name, _addressX));
      case EZCType.pChain:
        return WalletReceiveRoute(
            args: WalletReceiveArgs(ezcType.name, _addressP));
      case EZCType.cChain:
        return WalletReceiveRoute(
            args: WalletReceiveArgs(ezcType.name, _addressC));
    }
  }

  Future<List<TransactionsItem>> getTransactions(EZCType type) async {
    try {
      switch (ezcType) {
        case EZCType.xChain:
          final transactions = await _wallet.getXTransactions();
          return await mapToTransactionsItemsV2(transactions);
        case EZCType.pChain:
          final transactions = await _wallet.getPTransactions();
          return await mapToTransactionsItemsV2(transactions);
        case EZCType.cChain:
          final transactions = await _wallet.getCChainTransactions();
          return mapCChainToTransactionsItem(transactions, type);
      }
    } catch (e) {
      logger.e(e);
      return [];
    }
  }
}
