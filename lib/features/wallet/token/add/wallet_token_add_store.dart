// ignore: implementation_imports
import 'package:auto_route/src/router/auto_router_x.dart';
import 'package:mobx/mobx.dart';
import 'package:wallet/common/logger.dart';
import 'package:wallet/common/router.dart';
import 'package:wallet/common/router.gr.dart';
import 'package:wallet/di/di.dart';
import 'package:wallet/ezc/wallet/asset/erc20/types.dart';
import 'package:wallet/ezc/wallet/network/network.dart';
import 'package:wallet/ezc/wallet/wallet.dart';
import 'package:wallet/features/common/store/token_store.dart';
import 'package:wallet/features/common/wallet_factory.dart';
import 'package:wallet/features/wallet/token/add_confirm/wallet_token_add_confirm.dart';
import 'package:wallet/generated/l10n.dart';

part 'wallet_token_add_store.g.dart';

class WalletTokenAddStore = _WalletTokenAddStore with _$WalletTokenAddStore;

abstract class _WalletTokenAddStore with Store {
  final _walletFactory = getIt<WalletFactory>();

  WalletProvider get _wallet => _walletFactory.activeWallet;

  final _tokenStore = getIt<TokenStore>();

  @observable
  String error = '';

  @action
  validate(String address) async {
    try {
      if (_tokenStore.isErc20Exists(address)) {
        error = Strings.current.walletTokenAddressExists;
        return;
      }
      final erc20TokenData = await Erc20TokenData.getData(
        address,
        web3Client,
        getEvmChainId(),
      );

      if (erc20TokenData == null) {
        error = Strings.current.walletTokenAddressInvalid;
        return;
      }
      await erc20TokenData.getBalance(
        _wallet.getAddressC(),
        web3Client,
      );

      walletContext?.pushRoute(WalletTokenAddConfirmRoute(
          args: WalletTokenAddConfirmArgs(erc20TokenData)));
    } catch (e) {
      error = Strings.current.walletTokenAddressInvalid;
      logger.e(e);
    }
  }
}
