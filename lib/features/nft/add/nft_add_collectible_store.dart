// ignore: implementation_imports
import 'package:auto_route/src/router/auto_router_x.dart';
import 'package:mobx/mobx.dart';
import 'package:wallet/common/logger.dart';
import 'package:wallet/di/di.dart';
import 'package:wallet/ezc/wallet/asset/erc721/types.dart';
import 'package:wallet/ezc/wallet/network/network.dart';
import 'package:wallet/features/common/route/router.dart';
import 'package:wallet/features/common/store/token_store.dart';
import 'package:wallet/generated/l10n.dart';

part 'nft_add_collectible_store.g.dart';

class NftAddCollectibleStore = _NftAddCollectibleStore
    with _$NftAddCollectibleStore;

abstract class _NftAddCollectibleStore with Store {
  final _tokenStore = getIt<TokenStore>();

  @readonly
  String _error = '';

  @readonly
  Erc721Token? _token;

  @readonly
  bool _isLoading = false;

  @computed
  String get name => _token?.name ?? '--';

  @computed
  String get symbol => _token?.symbol ?? '--';

  String _address = '';

  @action
  validate(String address) async {
    try {
      _address = address;
      _token = await Erc721Token.getData(
        address,
        web3Client,
        getEvmChainId(),
      );
    } catch (e) {
      logger.e(e);
    }
  }

  @action
  addCollectible() async {
    try {
      final erc721 = _token;
      if (erc721 == null) {
        _error = Strings.current.walletTokenAddressInvalid;
        return;
      }
      if (_tokenStore.isErc721Exists(_address)) {
        _error = Strings.current.walletTokenAddressExists;
        return;
      }
      _isLoading = true;
      final added = await _tokenStore.addErc721Token(erc721);
      _isLoading = false;
      if (added) {
        walletContext?.router.pop();
      } else {
        _error = Strings.current.sharedCommonError;
      }
    } catch (e) {
      _error = Strings.current.walletTokenAddressInvalid;
      logger.e(e);
    }
  }
}
