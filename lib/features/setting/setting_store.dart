import 'package:mobx/mobx.dart';
import 'package:wallet/common/extensions.dart';
import 'package:wallet/common/logger.dart';
import 'package:wallet/di/di.dart';
import 'package:wallet/features/common/balance_store.dart';
import 'package:wallet/features/common/price_store.dart';
import 'package:wallet/features/common/validators_store.dart';
import 'package:wallet/features/common/wallet_factory.dart';
import 'package:wallet/generated/l10n.dart';
import 'package:wallet/roi/sdk/utils/mnemonic.dart';
import 'package:wallet/roi/wallet/network/network.dart';
import 'package:wallet/roi/wallet/network/types.dart';

part 'setting_store.g.dart';

class SettingStore = _SettingStore with _$SettingStore;

abstract class _SettingStore with Store {
  final _walletFactory = getIt<WalletFactory>();
  final _balanceStore = getIt<BalanceStore>();
  final _priceStore = getIt<PriceStore>();
  final _validatorsStore = getIt<ValidatorsStore>();

  @observable
  NetworkConfig activeNetworkConfig = activeNetwork;

  @action
  setNetworkConfig(NetworkConfig network) async {
    _walletFactory.clear();
    setRpcNetwork(network);
    final success = await _walletFactory.initWallet();
    if (success) {
      _balanceStore.init();
      // _balanceStore.updateBalance();
      // _priceStore.updateAvaxPrice();
      // _validatorsStore.updateValidators();
      activeNetworkConfig = network;
      showSnackBar(Strings.current.settingNetworkConnected);
    } else {}
  }
}
