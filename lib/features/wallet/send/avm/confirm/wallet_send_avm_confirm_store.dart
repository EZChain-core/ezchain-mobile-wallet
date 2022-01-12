import 'package:mobx/mobx.dart';
import 'package:wallet/di/di.dart';
import 'package:wallet/features/common/wallet_factory.dart';
import 'package:wallet/roi/wallet/utils/number_utils.dart';

part 'wallet_send_avm_confirm_store.g.dart';

class WalletSendAvmConfirmStore = _WalletSendAvmConfirmStore
    with _$WalletSendAvmConfirmStore;

abstract class _WalletSendAvmConfirmStore with Store {
  final wallet = getIt<WalletFactory>().activeWallet;

  @observable
  bool sendSuccess = false;

  @observable
  bool isLoading = false;

  @action
  sendAvm(String address, double amount, {String? memo}) async {
    isLoading = true;
    try {
      await wallet.updateUtxosX();
      final txId =
          await wallet.sendAvaxX(address, numberToBNAvaxX(amount), memo: memo);
      print("txId = $txId");
      sendSuccess = true;
    } catch (e) {
      print(e);
    }
    isLoading = false;
  }
}
