import 'package:mobx/mobx.dart';
import 'package:wallet/di/di.dart';
import 'package:wallet/features/common/wallet_factory.dart';

part 'nft_mint_store.g.dart';

class NftMintStore = _NftMintStore with _$NftMintStore;

abstract class _NftMintStore with Store {
  final _wallet = getIt<WalletFactory>().activeWallet;
}
