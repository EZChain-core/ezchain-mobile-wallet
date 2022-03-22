import 'package:mobx/mobx.dart';
import 'package:wallet/common/logger.dart';
import 'package:wallet/di/di.dart';
import 'package:wallet/ezc/sdk/apis/avm/utxos.dart';
import 'package:wallet/ezc/sdk/utils/payload.dart';
import 'package:wallet/ezc/wallet/asset/types.dart';
import 'package:wallet/ezc/wallet/network/network.dart';
import 'package:wallet/ezc/wallet/utils/number_utils.dart';
import 'package:wallet/features/common/constant/wallet_constant.dart';
import 'package:wallet/features/common/ext/extensions.dart';
import 'package:wallet/features/common/store/balance_store.dart';
import 'package:wallet/features/common/wallet_factory.dart';
import 'package:wallet/features/nft/mint/nft_mint.dart';
import 'package:wallet/generated/l10n.dart';

part 'nft_mint_store.g.dart';

class NftMintStore = _NftMintStore with _$NftMintStore;

abstract class _NftMintStore with Store {
  final _wallet = getIt<WalletFactory>().activeWallet;

  @readonly
  bool _isLoading = false;

  @readonly
  String _error = '';

  final fee = '${bnToDecimalAvaxX(xChain.getTxFee()).text()} $ezcSymbol';

  AvmUTXO? _nftMintUTXO;

  setNftMintUTXO(AvmUTXO? nftMintUTXO) {
    _nftMintUTXO = nftMintUTXO;
  }

  mintGeneric(String title, String imgUrl, String desc, int quantity) {
    if (!imgUrl.isValidUrl()) {
      _error = Strings.current.sharedInvalidUrlMess;
      return;
    }
    final generic = GenericFormType(
      avalanche: GenericNft(
        version: 1,
        type: "generic",
        title: title,
        img: imgUrl,
        desc: desc,
      ),
    );
    final genericPayload = JSONPayload(generic.toJson());
    mintNft(genericPayload, quantity);
  }

  mintCustom(MintCustomType type, String payload, int quantity) {
    PayloadBase payloadBase;
    switch (type) {
      case MintCustomType.utf8:
        payloadBase = UTF8Payload(payload);
        break;
      case MintCustomType.url:
        payloadBase = URLPayload(payload);
        break;
      case MintCustomType.json:
        payloadBase = JSONPayload(payload);
    }
    mintNft(payloadBase, quantity);
  }

  @action
  mintNft(PayloadBase payload, int quantity) async {
    _isLoading = true;
    try {
      if (_nftMintUTXO == null) {
        throw Exception();
      }
      logger.e('vit $_nftMintUTXO $quantity');
      await _wallet.mintNFT(_nftMintUTXO!, payload, quantity);
    } catch (e) {
      logger.e(e);
    }
    _isLoading = false;
  }
}
