import 'package:mobx/mobx.dart';
import 'package:wallet/di/di.dart';
import 'package:wallet/features/common/wallet_factory.dart';
import 'package:wallet/roi/sdk/utils/mnemonic.dart';

part 'setting_security_store.g.dart';

class SettingSecurityStore = _SettingSecurityStore with _$SettingSecurityStore;

abstract class _SettingSecurityStore with Store {
  final _walletFactory = getIt<WalletFactory>();
  final _wallet = getIt<WalletFactory>().activeWallet;

  @observable
  String privateKey = '';

  @observable
  String mnemonicKey = '';

  String get addressX => _wallet.getAddressX();

  String get addressP => _wallet.getAddressP();

  String get addressC => _wallet.getAddressC();

  _SettingSecurityStore() {
    getPrivateKey();
  }

  @action
  getPrivateKey() async {
    final key = await _walletFactory.getAccessKey();
    if (key.isEmpty) return;
    if (key.split(' ').length == Mnemonic.mnemonicLength) {
      mnemonicKey = key;
    } else {
      privateKey = key;
    }
  }
}
