import 'package:decimal/decimal.dart';
import 'package:mobx/mobx.dart';
import 'package:wallet/common/logger.dart';
import 'package:wallet/di/di.dart';
import 'package:wallet/ezc/wallet/wallet.dart';
import 'package:wallet/features/common/wallet_factory.dart';
import 'package:wallet/ezc/wallet/utils/number_utils.dart';

part 'wallet_send_avm_confirm_store.g.dart';

class WalletSendAvmConfirmStore = _WalletSendAvmConfirmStore
    with _$WalletSendAvmConfirmStore;

abstract class _WalletSendAvmConfirmStore with Store {
  final _walletFactory = getIt<WalletFactory>();

  WalletProvider get _wallet => _walletFactory.activeWallet;

  @readonly
  bool _sendSuccess = false;

  @readonly
  bool _isLoading = false;

  @action
  sendAvm(String address, Decimal amount, {String? memo}) async {
    _isLoading = true;
    try {
      await _wallet.updateUtxosX();
      final txId = await _wallet
          .sendAvaxX(address, numberToBNAvaxX(amount.toBigInt()), memo: memo);
      _sendSuccess = true;
    } catch (e) {
      logger.e(e);
    }
    _isLoading = false;
  }
}
