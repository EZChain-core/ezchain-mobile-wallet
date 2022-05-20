// ignore: implementation_imports
import 'package:auto_route/src/router/auto_router_x.dart';
import 'package:decimal/decimal.dart';
import 'package:mobx/mobx.dart';
import 'package:wallet/common/logger.dart';
import 'package:wallet/di/di.dart';
import 'package:wallet/ezc/wallet/helpers/address_helper.dart';
import 'package:wallet/ezc/wallet/helpers/gas_helper.dart';
import 'package:wallet/ezc/wallet/utils/number_utils.dart';
import 'package:wallet/ezc/wallet/wallet.dart';
import 'package:wallet/features/auth/pin/verify/pin_code_verify.dart';
import 'package:wallet/features/common/constant/wallet_constant.dart';
import 'package:wallet/features/common/ext/extensions.dart';
import 'package:wallet/features/common/route/router.dart';
import 'package:wallet/features/common/route/router.gr.dart';
import 'package:wallet/features/common/store/balance_store.dart';
import 'package:wallet/features/common/store/price_store.dart';
import 'package:wallet/features/common/store/token_store.dart';
import 'package:wallet/features/common/wallet_factory.dart';
import 'package:wallet/features/wallet/token/wallet_token_item.dart';
import 'package:wallet/generated/l10n.dart';

import 'confirm/wallet_send_evm_confirm.dart';

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
  String address = '';

  @observable
  Decimal amount = Decimal.zero;

  @observable
  int customGasLimit = 0;

  @observable
  BigInt customGasPrice = BigInt.zero;

  @observable
  int nonce = 0;

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
  bool _customFeeConfirmSuccess = false;

  @readonly
  Decimal _fee = Decimal.zero;

  @readonly
  Decimal _customFee = Decimal.zero;

  @readonly
  bool _isLoading = false;

  @readonly
  bool _customFeeIsLoading = false;

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
  confirm(bool isCustomFee) async {
    final isAddressValid = validateAddressEvm(address);
    final isAmountValid = balanceC >= amount && amountBN > BigInt.zero;
    if (!isAddressValid) {
      _addressError = Strings.current.sharedInvalidAddress;
    }
    if (!isAmountValid) {
      _amountError = Strings.current.sharedInvalidAmount;
    }
    if (!isAddressValid || !isAmountValid) return;
    if (isCustomFee) {
      _customFee =
          (customGasPrice * BigInt.from(customGasLimit)).toDecimalAvaxC();

      _customFeeConfirmSuccess = true;
      return;
    }
    if (_token != null) {
      _gasLimit = await _wallet.estimateErc20Gas(
        _token!.id,
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
  Future sendEvm(bool isCustomFee) async {
    final verified = await verifyPinCode();
    if (!verified) return;

    final gasPrice = isCustomFee ? customGasPrice : _gasPrice;
    final gasLimit = isCustomFee ? BigInt.from(customGasLimit) : _gasLimit;
    final nonceValue = isCustomFee ? nonce : null;
    if (isCustomFee) {
      _customFeeIsLoading = true;
    } else {
      _isLoading = true;
    }
    try {
      if (_token != null) {
        await _wallet.sendErc20(
          address,
          amountBN,
          gasPrice,
          gasLimit.toInt(),
          _token!.id,
          nonce: nonceValue,
        );
        _tokenStore.updateErc20Balance();
      } else {
        await _wallet.sendAvaxC(
          address,
          amountBN,
          gasPrice,
          gasLimit.toInt(),
          nonce: nonceValue,
        );
      }
      if (isCustomFee) {
        _customFeeIsLoading = false;
      } else {
        _isLoading = false;
      }

      final symbol = _token != null ? _token!.symbol : ezcSymbol;
      final gasPriceNumber =
          int.tryParse(gasPrice.toDecimalAvaxX().toStringAsFixed(0)) ?? 0;
      walletContext?.router.push(
        WalletSendEvmConfirmRoute(
          transactionInfo: WalletSendEvmTransactionViewData(
            address,
            gasPriceNumber,
            gasLimit,
            amount,
            _fee,
            symbol,
          ),
        ),
      );
    } catch (e) {
      logger.e(e.toString());
      showSnackBar(e.toString());
      if (isCustomFee) {
        _customFeeIsLoading = false;
      } else {
        _isLoading = false;
      }
      return false;
    }
  }
}
