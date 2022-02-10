import 'package:mobx/mobx.dart';
import 'package:wallet/di/di.dart';
import 'package:wallet/features/common/wallet_factory.dart';

part 'earn_delegate_input_store.g.dart';

class EarnDelegateInputStore = _EarnDelegateInputStore
    with _$EarnDelegateInputStore;

abstract class _EarnDelegateInputStore with Store {
  final wallet = getIt<WalletFactory>().activeWallet;
}
