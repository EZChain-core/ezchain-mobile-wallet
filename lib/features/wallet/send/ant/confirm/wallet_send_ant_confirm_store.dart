import 'package:decimal/decimal.dart';
import 'package:mobx/mobx.dart';
import 'package:wallet/di/di.dart';
import 'package:wallet/ezc/wallet/utils/number_utils.dart';
import 'package:wallet/features/common/wallet_factory.dart';
import 'package:wallet/features/wallet/send/ant/confirm/wallet_send_ant_confirm.dart';

part 'wallet_send_ant_confirm_store.g.dart';

class WalletSendAntConfirmStore = _WalletSendAntConfirmStore
    with _$WalletSendAntConfirmStore;

abstract class _WalletSendAntConfirmStore with Store {
  final _wallet = getIt<WalletFactory>().activeWallet;

  @observable
  bool sendSuccess = false;

  @observable
  bool isLoading = false;

  @action
  sendAnt(WalletSendAntConfirmArgs args) async {
    isLoading = true;
    try {
      await _wallet.updateUtxosX();
      final txId = await _wallet.sendANT(
          args.assetId, args.address, numberToBNAvaxX(args.amount.toBigInt()),
          memo: args.memo);
      print("txId = $txId");
      sendSuccess = true;
    } catch (e) {
      print(e);
    }
    isLoading = false;
  }
}
