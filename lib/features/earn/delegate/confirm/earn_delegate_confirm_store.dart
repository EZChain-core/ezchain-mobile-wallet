import 'package:mobx/mobx.dart';
import 'package:wallet/di/di.dart';
import 'package:wallet/features/common/wallet_factory.dart';

part 'earn_delegate_confirm_store.g.dart';

class EarnDelegateConfirmStore = _EarnDelegateConfirmStore
    with _$EarnDelegateConfirmStore;

abstract class _EarnDelegateConfirmStore with Store {
  final wallet = getIt<WalletFactory>().activeWallet;
}
