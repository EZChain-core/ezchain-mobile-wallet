import 'package:decimal/decimal.dart';
import 'package:mobx/mobx.dart';
import 'package:wallet/common/logger.dart';
import 'package:wallet/di/di.dart';
import 'package:wallet/ezc/wallet/helpers/address_helper.dart';
import 'package:wallet/ezc/wallet/helpers/gas_helper.dart';
import 'package:wallet/ezc/wallet/utils/number_utils.dart';
import 'package:wallet/features/common/store/balance_store.dart';
import 'package:wallet/features/common/store/price_store.dart';
import 'package:wallet/features/common/store/token_store.dart';
import 'package:wallet/features/common/wallet_factory.dart';
import 'package:wallet/features/wallet/token/wallet_token_item.dart';
import 'package:wallet/generated/l10n.dart';

part 'wallet_send_evm_store.g.dart';

class WalletSendEvmStore = _WalletSendEvmStore with _$WalletSendEvmStore;

abstract class _WalletSendEvmStore with Store {
  final _wallet = getIt<WalletFactory>().activeWallet;

  final _balanceStore = getIt<BalanceStore>();
  final _priceStore = getIt<PriceStore>();
  final _tokenStore = getIt<TokenStore>();

  @observable
  WalletTokenItem? _token;

  @observable
  int gasPriceNumber = 0;

  @observable
  BigInt gasLimit = BigInt.zero;

  @computed
  Decimal? get avaxPrice =>
      _token != null ? _token!.price : _priceStore.avaxPrice;

  @observable
  Decimal amount = Decimal.zero;

  @computed
  Decimal get balanceC =>
      _token != null ? _token!.balance : _balanceStore.balanceC;

  String get balanceCString =>
      _token != null ? _token!.balanceText : _balanceStore.balanceCString;

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

  BigInt get amountBN {
    if (_token != null) {
      return numberToBN(amount.toBigInt(), _token!.decimals ?? 9);
    } else {
      return numberToBNAvaxC(amount.toBigInt());
    }
  }

  setWalletToken(WalletTokenItem? tokenItem) {
    _token = tokenItem;
  }

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
      if (_token != null) {
        gasLimit =
            await _wallet.estimateErc20Gas(_token!.id!, address, amountBN);
      } else {
        gasLimit =
            await _wallet.estimateAvaxGasLimit(address, amountBN, _gasPrice);
      }
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
      if (_token != null) {
        await _wallet.sendErc20(
            address, amountBN, _gasPrice, gasLimit.toInt(), _token!.id!);
        _tokenStore.updateErc20Balance();
      } else {
        await _wallet.sendAvaxC(address, amountBN, _gasPrice, gasLimit.toInt());
      }

      isLoading = false;
      return true;
    } catch (e) {
      logger.e(e);
      isLoading = false;
      return false;
    }
  }
}
