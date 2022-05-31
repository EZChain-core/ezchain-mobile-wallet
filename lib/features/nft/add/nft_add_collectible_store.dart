import 'package:mobx/mobx.dart';
import 'package:wallet/common/logger.dart';
import 'package:wallet/di/di.dart';
import 'package:wallet/ezc/wallet/asset/erc721/types.dart';
import 'package:wallet/ezc/wallet/network/network.dart';
import 'package:wallet/ezc/wallet/wallet.dart';
import 'package:wallet/features/common/store/token_store.dart';
import 'package:wallet/features/common/wallet_factory.dart';
import 'package:wallet/generated/l10n.dart';

part 'nft_add_collectible_store.g.dart';

class NftAddCollectibleStore = _NftAddCollectibleStore
    with _$NftAddCollectibleStore;

abstract class _NftAddCollectibleStore with Store {
  final _walletFactory = getIt<WalletFactory>();

  WalletProvider get _wallet => _walletFactory.activeWallet;

  final _tokenStore = getIt<TokenStore>();

  @readonly
  String _error = '';

  @action
  validate(String address) async {
    try {
      if (_tokenStore.isErc20Exists(address)) {
        _error = Strings.current.walletTokenAddressExists;
        return;
      }
      final erc721Data = await Erc721Token.getData(
        address,
        web3Client,
        getEvmChainId(),
      );

      if (erc721Data == null) {
        _error = Strings.current.walletTokenAddressInvalid;
        return;
      }
    } catch (e) {
      _error = Strings.current.walletTokenAddressInvalid;
      logger.e(e);
    }
  }
}
