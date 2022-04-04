import 'package:decimal/decimal.dart';
import 'package:mobx/mobx.dart';
import 'package:wallet/di/di.dart';
import 'package:wallet/features/common/store/balance_store.dart';
import 'package:wallet/features/common/store/price_store.dart';
import 'package:wallet/generated/l10n.dart';
import 'package:wallet/ezc/wallet/helpers/address_helper.dart';
import 'package:wallet/ezc/wallet/utils/fee_utils.dart';
import 'package:wallet/ezc/wallet/utils/number_utils.dart';

part 'wallet_send_avm_store.g.dart';

class WalletSendAvmStore = _WalletSendAvmStore with _$WalletSendAvmStore;

abstract class _WalletSendAvmStore with Store {
  final _balanceStore = getIt<BalanceStore>();
  final _priceStore = getIt<PriceStore>();

  @computed
  Decimal get avaxPrice => _priceStore.ezcPrice;

  @computed
  Decimal get balanceX => _balanceStore.balanceX;

  String get balanceXString => _balanceStore.balanceXString;

  @readonly
  String? _addressError;

  @readonly
  String? _amountError;

  @observable
  Decimal amount = Decimal.zero;

  @readonly
  Decimal _fee = Decimal.zero;

  @computed
  Decimal get total => (amount + _fee) * avaxPrice;

  get maxAmount => balanceX - _fee;

  @action
  getBalanceX() async {
    _balanceStore.updateBalanceX();
    _fee = bnToDecimalAvaxX(getTxFeeX());
  }

  @action
  bool validate(String address) {
    final isAddressValid = validateAddressX(address);
    final isAmountValid =
        _balanceStore.balanceX >= (amount + _fee) && amount > Decimal.zero;
    if (!isAddressValid) {
      _addressError = Strings.current.sharedInvalidAddress;
    }
    if (!isAmountValid) {
      _amountError = Strings.current.sharedInvalidAmount;
    }
    return isAddressValid && isAmountValid;
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
}
