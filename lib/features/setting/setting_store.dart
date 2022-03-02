import 'package:mobx/mobx.dart';
import 'package:wallet/common/extensions.dart';
import 'package:wallet/di/di.dart';
import 'package:wallet/features/common/balance_store.dart';
import 'package:wallet/features/common/network_config_type.dart';
import 'package:wallet/features/common/validators_store.dart';
import 'package:wallet/features/common/wallet_factory.dart';
import 'package:wallet/generated/l10n.dart';
import 'package:wallet/roi/wallet/network/network.dart';
import 'package:wallet/roi/wallet/network/types.dart';

part 'setting_store.g.dart';

class SettingStore = _SettingStore with _$SettingStore;

abstract class _SettingStore with Store {
  final _walletFactory = getIt<WalletFactory>();
  final _balanceStore = getIt<BalanceStore>();
  final _validatorsStore = getIt<ValidatorsStore>();

  @observable
  NetworkConfigType activeNetworkConfig =
      getNetworkConfigTypeFromConfig(activeNetwork);

  @action
  setNetworkConfig(NetworkConfigType network) async {
    _balanceStore.dispose();
    _walletFactory.clearWallets();
    setRpcNetwork(network.config);
    await _walletFactory.initWallet();
    _balanceStore.init();
    _balanceStore.updateTotalBalance();
    _validatorsStore.updateValidators();
    activeNetworkConfig = network;
    _walletFactory.saveNetworkConfig(network);
    showSnackBar(Strings.current.settingNetworkConnected);
  }
}
