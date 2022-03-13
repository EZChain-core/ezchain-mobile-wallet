import 'package:mobx/mobx.dart';
import 'package:wallet/common/logger.dart';
import 'package:wallet/di/di.dart';
import 'package:wallet/ezc/wallet/network/network.dart';
import 'package:wallet/ezc/wallet/utils/number_utils.dart';
import 'package:wallet/features/common/constant/wallet_constant.dart';
import 'package:wallet/features/common/wallet_factory.dart';
import 'package:wallet/generated/l10n.dart';

part 'nft_family_create_store.g.dart';

class NftFamilyCreateStore = _NftFamilyCreateStore with _$NftFamilyCreateStore;

abstract class _NftFamilyCreateStore with Store {
  final _wallet = getIt<WalletFactory>().activeWallet;

  @observable
  String error = '';

  String fee = '${bnToDecimalAvaxX(xChain.getCreationTxFee())}';

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
      final txId =
          await _wallet.createNFTFamily(name.trim(), symbol.trim(), groupNum);
      logger.i("createNFTFamily = $txId");
      return true;
    } catch (e) {
      logger.e(e);
      return false;
    }
  }
}
