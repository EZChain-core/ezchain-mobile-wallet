import 'package:decimal/decimal.dart';
import 'package:mobx/mobx.dart';
import 'package:wallet/common/logger.dart';
import 'package:wallet/di/di.dart';
import 'package:wallet/features/common/balance_store.dart';
import 'package:wallet/features/common/price_store.dart';
import 'package:wallet/features/common/wallet_factory.dart';
import 'package:wallet/generated/l10n.dart';
import 'package:wallet/ezc/wallet/helpers/address_helper.dart';
import 'package:wallet/ezc/wallet/helpers/gas_helper.dart';
import 'package:wallet/ezc/wallet/utils/number_utils.dart';

part 'wallet_send_evm_store.g.dart';

class WalletSendEvmStore = _WalletSendEvmStore with _$WalletSendEvmStore;

abstract class _WalletSendEvmStore with Store {
  final _wallet = getIt<WalletFactory>().activeWallet;

  final _balanceStore = getIt<BalanceStore>();
  final _priceStore = getIt<PriceStore>();

  @observable
  int gasPriceNumber = 0;

  @observable
  BigInt gasLimit = BigInt.zero;

  @computed
  Decimal get avaxPrice => _priceStore.avaxPrice;

  @observable
  Decimal amount = Decimal.zero;

  @computed
  Decimal get balanceC => _balanceStore.balanceC;

  String get balanceCString => _balanceStore.balanceCString;

  @observable
  String? addressError;

  @observable
  String? amountError;

  @observable
  bool sendSuccess = false;

  @observable
  bool confirmSuccess = false;

  @observable
  Decimal fee = Decimal.zero;

  @observable
  bool isLoading = false;

  Decimal get maxAmount => balanceC - fee;

  BigInt _gasPrice = BigInt.zero;

  @action
  getBalanceC() async {
    _balanceStore.updateBalanceC();

    _gasPrice = BigInt.from(225000000000);
    try {
      _gasPrice = await getAdjustedGasPrice();
    } catch (e) {
      logger.e(e);
    }
    gasPriceNumber =
        int.tryParse(bnToDecimalAvaxX(_gasPrice).toStringAsFixed(0)) ?? 0;

    _priceStore.updateAvaxPrice();
  }

  @action
  confirm(String address) async {
    final isAddressValid = validateAddressEvm(address);
    final isAmountValid = balanceC >= amount && amount > Decimal.zero;
    if (!isAddressValid) {
      addressError = Strings.current.sharedInvalidAddress;
    }
    if (!isAmountValid) {
      amountError = Strings.current.sharedInvalidAmount;
    }
    if (isAddressValid && isAmountValid) {
      final evmAmount = numberToBNAvaxC(amount.toBigInt());
      gasLimit =
          await _wallet.estimateAvaxGasLimit(address, evmAmount, _gasPrice);
      fee = bnToDecimalAvaxC(_gasPrice * gasLimit);
      confirmSuccess = true;
    }
  }

  @action
  removeAmountError() {
    if (amountError != null) {
      amountError = null;
    }
  }

  @action
  removeAddressError() {
    if (addressError != null) {
      addressError = null;
    }
  }

  @action
  Future<bool> sendEvm(String address) async {
    isLoading = true;
    try {
      await _wallet.sendAvaxC(address, numberToBNAvaxC(amount.toBigInt()),
          _gasPrice, gasLimit.toInt());
      isLoading = false;
      return true;
    } catch (e) {
      logger.e(e);
      isLoading = false;
      return false;
    }
  }
}
