import 'package:decimal/decimal.dart';
import 'package:mobx/mobx.dart';
import 'package:wallet/common/logger.dart';
import 'package:wallet/di/di.dart';
import 'package:wallet/ezc/wallet/utils/number_utils.dart';
import 'package:wallet/ezc/wallet/wallet.dart';
import 'package:wallet/features/common/wallet_factory.dart';
import 'package:wallet/features/wallet/send/ant/confirm/wallet_send_ant_confirm.dart';

part 'wallet_send_ant_confirm_store.g.dart';

class WalletSendAntConfirmStore = _WalletSendAntConfirmStore
    with _$WalletSendAntConfirmStore;

abstract class _WalletSendAntConfirmStore with Store {
  final _walletFactory = getIt<WalletFactory>();

  WalletProvider get _wallet => _walletFactory.activeWallet;

  @readonly
  bool _sendSuccess = false;

  @readonly
  bool _isLoading = false;

  @action
  sendAnt(WalletSendAntConfirmArgs args) async {
    _isLoading = true;
    try {
      await _wallet.updateUtxosX();
      final txId = await _wallet.sendANT(
          args.assetId, args.address, numberToBNAvaxX(args.amount.toBigInt()),
          memo: args.memo);
      _sendSuccess = true;
    } catch (e) {
      logger.e(e);
    }
    _isLoading = false;
  }
}
