import 'package:decimal/decimal.dart';
import 'package:mobx/mobx.dart';
import 'package:wallet/common/logger.dart';
import 'package:wallet/di/di.dart';
import 'package:wallet/ezc/wallet/helpers/address_helper.dart';
import 'package:wallet/ezc/wallet/helpers/gas_helper.dart';
import 'package:wallet/ezc/wallet/utils/number_utils.dart';
import 'package:wallet/ezc/wallet/wallet.dart';
import 'package:wallet/features/common/ext/extensions.dart';
import 'package:wallet/features/common/store/balance_store.dart';
import 'package:wallet/features/common/store/price_store.dart';
import 'package:wallet/features/common/store/token_store.dart';
import 'package:wallet/features/common/wallet_factory.dart';
import 'package:wallet/features/wallet/token/wallet_token_item.dart';
import 'package:wallet/generated/l10n.dart';
import 'package:collection/collection.dart';

part 'wallet_send_evm_store.g.dart';

class WalletSendEvmStore = _WalletSendEvmStore with _$WalletSendEvmStore;

abstract class _WalletSendEvmStore with Store {
  final _walletFactory = getIt<WalletFactory>();

  WalletProvider get _wallet => _walletFactory.activeWallet;

  final _balanceStore = getIt<BalanceStore>();
  final _priceStore = getIt<PriceStore>();
  final _tokenStore = getIt<TokenStore>();

  @observable
  WalletTokenItem? _token;

  @readonly
  int _gasPriceNumber = 0;

  @readonly
  BigInt _gasLimit = BigInt.zero;

  @computed
  Decimal? get avaxPrice =>
      _token != null ? _token!.price : _priceStore.ezcPrice;

  @observable
  Decimal amount = Decimal.zero;

  @computed
  Decimal get balanceC =>
      _token != null ? _token!.balance : _balanceStore.balanceC;

  String get balanceCString =>
      _token != null ? _token!.balanceText : _balanceStore.balanceCString;

  @readonly
  String? _addressError;

  @readonly
  String? _amountError;

  @readonly
  bool _confirmSuccess = false;

  @readonly
  Decimal _fee = Decimal.zero;

  @readonly
  bool _isLoading = false;

  Decimal get maxAmount {
    final max = balanceC - _fee;
    return max >= Decimal.zero ? max : Decimal.zero;
  }

  BigInt _gasPrice = BigInt.zero;

  BigInt get amountBN {
    if (_token != null) {
      return amount.toBN(denomination: _token!.decimals);
    } else {
      return amount.toBNAvaxC();
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
    _gasPriceNumber =
        int.tryParse(_gasPrice.toDecimalAvaxX().toStringAsFixed(0)) ?? 0;
  }

  @action
  confirm(String address) async {
    final isAddressValid = validateAddressEvm(address);
    final isAmountValid = balanceC >= amount && amountBN > BigInt.zero;
    if (!isAddressValid) {
      _addressError = Strings.current.sharedInvalidAddress;
    }
    if (!isAmountValid) {
      _amountError = Strings.current.sharedInvalidAmount;
    }
    if (isAddressValid && isAmountValid) {
      final erc20Token = _tokenStore.erc20Tokens.toList().singleWhereOrNull(
          (element) => element.contractAddress == _token?.id);
      if (erc20Token != null) {
        _gasLimit = await _wallet.estimateErc20Gas(
          erc20Token,
          address,
          amountBN,
        );
      } else {
        _gasLimit = await _wallet.estimateAvaxGasLimit(
          address,
          amountBN,
          _gasPrice,
        );
      }
      _fee = (_gasPrice * _gasLimit).toDecimalAvaxC();

      _confirmSuccess = true;
    }
  }

  @action
  removeAmountError() {
    if (_amountError != null) {
      _amountError = null;
    }
  }

  @action
  removeAddressError() {
    if (_addressError != null) {
      _addressError = null;
    }
  }

  @action
  Future<bool> sendEvm(String address) async {
    _isLoading = true;
    try {
      final erc20Token = _tokenStore.erc20Tokens.toList().singleWhereOrNull(
          (element) => element.contractAddress == _token?.id);
      if (erc20Token != null) {
        await _wallet.sendErc20(
          erc20Token,
          address,
          amountBN,
          _gasPrice,
          _gasLimit.toInt(),
        );
        _tokenStore.updateErc20Balance();
      } else {
        await _wallet.sendAvaxC(
          address,
          amountBN,
          _gasPrice,
          _gasLimit.toInt(),
        );
      }
      _isLoading = false;
      return true;
    } catch (e) {
      logger.e(e);
      showSnackBar(Strings.current.sharedCommonError);
      _isLoading = false;
      return false;
    }
  }
}
