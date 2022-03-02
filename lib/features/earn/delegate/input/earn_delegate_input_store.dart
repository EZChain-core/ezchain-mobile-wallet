import 'package:decimal/decimal.dart';
import 'package:mobx/mobx.dart';
import 'package:wallet/di/di.dart';
import 'package:wallet/features/common/balance_store.dart';
import 'package:wallet/features/common/wallet_factory.dart';
import 'package:wallet/generated/l10n.dart';
import 'package:wallet/roi/wallet/helpers/address_helper.dart';
import 'package:wallet/roi/wallet/utils/number_utils.dart';

part 'earn_delegate_input_store.g.dart';

class EarnDelegateInputStore = _EarnDelegateInputStore
    with _$EarnDelegateInputStore;

abstract class _EarnDelegateInputStore with Store {
  final _wallet = getIt<WalletFactory>().activeWallet;
  final _balanceStore = getIt<BalanceStore>();

  @computed
  Decimal get balanceP => _balanceStore.balanceP;

  @observable
  String? addressError;

  @observable
  String? amountError;

  String get balancePString => _balanceStore.balancePString;

  String get addressP => _wallet.getAddressP();

  @action
  Future<bool> validate(String address, Decimal amount) async {
    final isAddressValid = validateAddressP(address);
    final minStake =
        bnToDecimalAvaxP((await _wallet.getMinStake()).minDelegatorStakeBN);
    final isAmountValid = balanceP >= amount && amount > minStake;
    if (!isAddressValid) {
      addressError = Strings.current.earnDelegateInvalidAddress;
    }
    if (!isAmountValid) {
      amountError = Strings.current.sharedInvalidAmount;
    }
    return isAddressValid && isAmountValid;
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
}
