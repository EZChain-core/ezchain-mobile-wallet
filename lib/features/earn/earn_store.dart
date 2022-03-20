import 'package:decimal/decimal.dart';
import 'package:mobx/mobx.dart';
import 'package:wallet/di/di.dart';
import 'package:wallet/features/common/store/balance_store.dart';

part 'earn_store.g.dart';

class EarnStore = _EarnStore with _$EarnStore;

abstract class _EarnStore with Store {
  final _balanceStore = getIt<BalanceStore>();

  @computed
  bool get permittedAddDelegator => _balanceStore.balanceP > Decimal.one;
}
