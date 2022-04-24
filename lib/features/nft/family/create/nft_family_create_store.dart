// ignore: implementation_imports
import 'package:auto_route/src/router/auto_router_x.dart';
import 'package:mobx/mobx.dart';
import 'package:wallet/common/logger.dart';
import 'package:wallet/common/router.dart';
import 'package:wallet/common/router.gr.dart';
import 'package:wallet/di/di.dart';
import 'package:wallet/ezc/wallet/network/network.dart';
import 'package:wallet/ezc/wallet/utils/number_utils.dart';
import 'package:wallet/ezc/wallet/wallet.dart';
import 'package:wallet/features/auth/pin/verify/pin_code_verify.dart';
import 'package:wallet/features/common/wallet_factory.dart';
import 'package:wallet/features/nft/family/detail/nft_family_detail.dart';
import 'package:wallet/generated/l10n.dart';

part 'nft_family_create_store.g.dart';

class NftFamilyCreateStore = _NftFamilyCreateStore with _$NftFamilyCreateStore;

abstract class _NftFamilyCreateStore with Store {
  final _walletFactory = getIt<WalletFactory>();

  WalletProvider get _wallet => _walletFactory.activeWallet;

  @observable
  String error = '';

  @observable
  bool isLoading = false;

  String fee = '${xChain.getCreationTxFee().toDecimalAvaxX()}';

  @action
  Future<bool> createFamily(String name, String symbol, int groupNum) async {
    if (name.isEmpty) {
      error = Strings.current.nftNameEmptyError;
      return false;
    } else if (symbol.isEmpty) {
      error = Strings.current.nftSymbolEmptyError;
      return false;
    } else if (symbol.length > 4) {
      error = Strings.current.nftSymbolLengthError;
      return false;
    } else if (groupNum < 1) {
      error = Strings.current.nftNumberLengthError;
      return false;
    }
    try {
      if (!await verifyPinCode()) return false;
      isLoading = true;
      final txId = await _wallet.createNFTFamily(name, symbol, groupNum);
      isLoading = false;
      walletContext?.pushRoute(
        NftFamilyDetailRoute(
          args: NftFamilyDetailArgs(
            txId,
            name,
            symbol,
            groupNum,
          ),
        ),
      );
      return true;
    } catch (e) {
      logger.e(e);
      error = Strings.current.sharedCommonError;
      isLoading = false;
      return false;
    }
  }
}
