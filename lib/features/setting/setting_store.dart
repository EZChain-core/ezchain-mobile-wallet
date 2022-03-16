import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:mobx/mobx.dart';
import 'package:wallet/common/extensions.dart';
import 'package:wallet/di/di.dart';
import 'package:wallet/ezc/wallet/network/network.dart';
import 'package:wallet/features/common/balance_store.dart';
import 'package:wallet/features/common/network_config_type.dart';
import 'package:wallet/features/common/setting/wallet_setting.dart';
import 'package:wallet/features/common/token/token_store.dart';
import 'package:wallet/features/common/validators_store.dart';
import 'package:wallet/features/common/wallet_factory.dart';
import 'package:wallet/generated/l10n.dart';

part 'setting_store.g.dart';

class SettingStore = _SettingStore with _$SettingStore;

abstract class _SettingStore with Store {
  final _walletFactory = getIt<WalletFactory>();
  final _walletSetting = getIt<WalletSetting>();
  final _balanceStore = getIt<BalanceStore>();
  final _validatorsStore = getIt<ValidatorsStore>();
  final _tokenStore = getIt<TokenStore>();

  final _localAuthentication = LocalAuthentication();

  _SettingStore() {
    _init();
  }

  @observable
  bool touchIdEnabled = false;

  @observable
  bool touchIdAvailable = false;

  @observable
  NetworkConfigType activeNetworkConfig =
      getNetworkConfigTypeFromConfig(activeNetwork);

  @action
  setNetworkConfig(NetworkConfigType network) async {
    _balanceStore.dispose();
    _walletFactory.clearWallets();
    setRpcNetwork(network.config);
    await _walletFactory.initWallet();
    activeNetworkConfig = network;
    _walletSetting.saveNetworkConfig(network);
    showSnackBar(Strings.current.settingNetworkConnected);
    _balanceStore.init();
    _balanceStore.updateTotalBalance();
    _validatorsStore.updateValidators();
    _tokenStore.getToken();
  }

  enableTouchId(bool enabled) async {
    bool useTouchId = enabled;
    if (enabled) {
      try {
        useTouchId = await _localAuthentication.authenticate(
          localizedReason: Strings.current.sharedCompleteBiometrics,
          biometricOnly: true,
        );
      } on PlatformException catch (e) {
        showSnackBar(Strings.current.settingBiometricSystemsNotEnabled);
        useTouchId = false;
      }
    }
    touchIdEnabled = useTouchId;
    _walletSetting.enableTouchId(useTouchId);
  }

  _init() async {
    touchIdEnabled = await _walletSetting.touchIdEnabled();
    touchIdAvailable = await _localAuthentication.canCheckBiometrics;
  }
}
