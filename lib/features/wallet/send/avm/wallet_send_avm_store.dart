import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';
import 'package:wallet/common/logger.dart';
import 'package:wallet/di/di.dart';
import 'package:wallet/ezc/wallet/helpers/address_helper.dart';
import 'package:wallet/ezc/wallet/utils/fee_utils.dart';
import 'package:wallet/ezc/wallet/utils/number_utils.dart';
import 'package:wallet/features/common/ext/extensions.dart';
import 'package:wallet/features/common/route/router.dart';
import 'package:wallet/features/common/store/balance_store.dart';
import 'package:wallet/features/common/store/price_store.dart';
import 'package:wallet/features/nft/collectible/nft_collectible_item.dart';
import 'package:wallet/features/nft/select/nft_select.dart';
import 'package:wallet/features/wallet/token/wallet_token_item.dart';
import 'package:wallet/generated/l10n.dart';

part 'wallet_send_avm_store.g.dart';

class WalletSendAvmStore = _WalletSendAvmStore with _$WalletSendAvmStore;

abstract class _WalletSendAvmStore with Store {
  final _balanceStore = getIt<BalanceStore>();
  final _priceStore = getIt<PriceStore>();

  @observable
  WalletTokenItem? _token;

  @computed
  bool get fromToken => _token != null;

  @computed
  Decimal? get avaxPrice => fromToken ? _token!.price : _priceStore.ezcPrice;

  @computed
  Decimal get balanceX => fromToken ? _token!.balance : _balanceStore.balanceX;

  String get balanceXString =>
      fromToken ? _token!.balanceText : _balanceStore.balanceXString;

  @readonly
  String? _addressError;

  @readonly
  String? _amountError;

  @observable
  Decimal amount = Decimal.zero;

  @readonly
  Decimal _fee = Decimal.zero;

  @computed
  Decimal get total => (amount + _fee) * (avaxPrice ?? Decimal.zero);

  @readonly
  ObservableList<NftCollectibleItem> _nft = ObservableList.of([]);

  get maxAmount {
    final max = balanceX - _fee;
    return max >= Decimal.zero ? max : Decimal.zero;
  }

  @action
  setWalletToken(WalletTokenItem? tokenItem) {
    _token = tokenItem;
  }

  @action
  getBalanceX() async {
    _balanceStore.updateBalanceX();
    _fee = getTxFeeX().toDecimalAvaxX();
  }

  @action
  bool validate(String address) {
    final isAddressValid = validateAddressX(address);
    final isAmountValid =
        balanceX >= (amount + _fee) && amount.toBNAvaxX() > BigInt.zero;
    if (!isAddressValid) {
      _addressError = Strings.current.sharedInvalidAddress;
    }
    if (!isAmountValid) {
      _amountError = Strings.current.sharedInvalidAmount;
    }
    final isQuantityValid = !_nft.any((element) => !element.isQuantityValid);
    if (!isQuantityValid) {
      showSnackBar(Strings.current.walletSendQuantityInvalidMess);
    }
    return isAddressValid && isAmountValid && isQuantityValid;
  }

  @action
  removeAmountError() {
    if (_amountError != null) {
      _amountError = null;
    }
  }

  @action
  removeAddressError() {
    if (_addressError != null) {
      _addressError = null;
    }
  }

  @action
  onPickNft() async {
    if (walletContext != null) {
      NftCollectibleItem nftPicked = await showDialog(
        context: walletContext!,
        builder: (_) => NftSelectDialog(),
      );
      if(!_nft.contains(nftPicked)) {
        _nft.add(nftPicked);
      }
    }
  }

  @action
  deleteNft(NftCollectibleItem item) {
    _nft.remove(item);
  }
}
