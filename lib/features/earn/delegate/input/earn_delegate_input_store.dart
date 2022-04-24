import 'package:decimal/decimal.dart';
import 'package:mobx/mobx.dart';
import 'package:wallet/di/di.dart';
import 'package:wallet/ezc/wallet/wallet.dart';
import 'package:wallet/features/common/store/balance_store.dart';
import 'package:wallet/features/common/store/validators_store.dart';
import 'package:wallet/features/common/wallet_factory.dart';
import 'package:wallet/generated/l10n.dart';
import 'package:wallet/ezc/wallet/helpers/address_helper.dart';
import 'package:wallet/ezc/wallet/utils/number_utils.dart';

part 'earn_delegate_input_store.g.dart';

class EarnDelegateInputStore = _EarnDelegateInputStore
    with _$EarnDelegateInputStore;

abstract class _EarnDelegateInputStore with Store {
  final _walletFactory = getIt<WalletFactory>();

  WalletProvider get _wallet => _walletFactory.activeWallet;

  final _balanceStore = getIt<BalanceStore>();

  final _validatorsStore = getIt<ValidatorsStore>();

  @computed
  Decimal get balanceP => _balanceStore.balanceP;

  @readonly
  String? _addressError;

  @readonly
  String? _amountError;

  String get balancePString => _balanceStore.balancePString;

  String get addressP => _wallet.getAddressP();

  @action
  bool validate(String address, Decimal amount) {
    final isAddressValid = validateAddressP(address);
    final minStake = _validatorsStore.minDelegatorStake.toDecimalAvaxP();
    final isAmountValid = balanceP >= amount && amount > minStake;
    if (!isAddressValid) {
      _addressError = Strings.current.earnDelegateInvalidAddress;
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
