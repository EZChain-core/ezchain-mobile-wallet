import 'package:decimal/decimal.dart';
import 'package:mobx/mobx.dart';
import 'package:wallet/di/di.dart';
import 'package:wallet/ezc/wallet/utils/number_utils.dart';
import 'package:wallet/features/common/balance_store.dart';
import 'package:wallet/features/common/chain_type/ezc_type.dart';
import 'package:wallet/features/common/price_store.dart';
import 'package:wallet/features/common/token/token_store.dart';
import 'package:wallet/features/wallet/token/wallet_token_item.dart';

part 'wallet_token_store.g.dart';

class WalletTokenStore = _WalletTokenStore with _$WalletTokenStore;

abstract class _WalletTokenStore with Store {
  final _balanceStore = getIt<BalanceStore>();
  final _priceStore = getIt<PriceStore>();
  final _tokenStore = getIt<TokenStore>();

  @computed
  String get tokenBalance {
    Decimal total = Decimal.zero;
    for (var element in tokens) {
      total += (element.balance * (element.price ?? Decimal.one));
    }
    return total.text(decimals: 1);
  }

  @computed
  Decimal get ezcPrice => _priceStore.avaxPrice;

  @computed
  ObservableList<WalletTokenItem> get erc20Tokens =>
      ObservableList.of(_tokenStore.erc20Tokens
          .map((token) => WalletTokenItem(
                token.name,
                token.symbol,
                bnToDecimal(token.balanceBN, denomination: token.decimals),
                token.balance,
                EZCTokenType.erc20,
                id: token.contractAddress,
                decimals: token.decimals,
              ))
          .toList());

  @computed
  ObservableList<WalletTokenItem> get antokens =>
      ObservableList.of(_balanceStore.antAssets
          .map((token) => WalletTokenItem(
                token.name,
                token.symbol,
                token.getAmount(),
                token.toString(),
                EZCTokenType.ant,
                id: token.id,
              ))
          .toList());

  @computed
  ObservableList<WalletTokenItem> get tokens =>
      ObservableList.of([...antokens, ...erc20Tokens]);

  @action
  refresh() async {
    _priceStore.updateAvaxPrice();
    _balanceStore.updateTotalBalance();
    _tokenStore.getErc20Tokens();
  }
}
