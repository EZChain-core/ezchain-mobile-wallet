import 'package:decimal/decimal.dart';
import 'package:mobx/mobx.dart';
import 'package:wallet/common/logger.dart';
import 'package:wallet/di/di.dart';
import 'package:wallet/ezc/sdk/apis/avm/utxos.dart';
import 'package:wallet/ezc/wallet/utils/number_utils.dart';
import 'package:wallet/ezc/wallet/wallet.dart';
import 'package:wallet/features/common/ext/extensions.dart';
import 'package:wallet/features/common/store/token_store.dart';
import 'package:wallet/features/common/wallet_factory.dart';
import 'package:wallet/features/wallet/send/avm/confirm/wallet_send_avm_confirm.dart';
import 'package:wallet/generated/l10n.dart';

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
  sendAnt(WalletSendAvmConfirmArgs args) async {
    _isLoading = true;
    final assetId = args.assetId;
    try {
      if (assetId == null) {
        throw Exception();
      }
      List<AvmUTXO> nftUtxos = [];
      for (var element in args.nft) {
        nftUtxos.addAll(element.avmUtxosWithQuantity);
      }

      await _wallet.sendANT(
        assetId,
        args.address,
        args.amount.toBNAvaxX(),
        memo: args.memo,
        nftUtxos: nftUtxos,
      );
      _sendSuccess = true;
    } catch (e) {
      logger.e(e);
      showSnackBar(Strings.current.sharedCommonError);
    }
    _isLoading = false;
  }

  @action
  sendAvm(WalletSendAvmConfirmArgs args) async {
    _isLoading = true;
    try {
      List<AvmUTXO> nftUtxos = [];
      for (var element in args.nft) {
        nftUtxos.addAll(element.avmUtxosWithQuantity);
      }

      await _wallet.sendAvaxX(
        args.address,
        args.amount.toBNAvaxX(),
        memo: args.memo,
        nftUtxos: nftUtxos,
      );
      _sendSuccess = true;
    } catch (e) {
      logger.e(e);
      showSnackBar(Strings.current.sharedCommonError);
    }
    _isLoading = false;
  }
}
