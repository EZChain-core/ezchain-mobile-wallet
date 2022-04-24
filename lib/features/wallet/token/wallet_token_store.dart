import 'package:decimal/decimal.dart';
import 'package:mobx/mobx.dart';
import 'package:wallet/di/di.dart';
import 'package:wallet/ezc/wallet/utils/number_utils.dart';
import 'package:wallet/features/common/store/balance_store.dart';
import 'package:wallet/features/common/type/ezc_type.dart';
import 'package:wallet/features/common/store/price_store.dart';
import 'package:wallet/features/common/store/token_store.dart';
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
    return total.toLocaleString(decimals: 1);
  }

  @computed
  Decimal get ezcPrice => _priceStore.ezcPrice;

  @computed
  ObservableList<WalletTokenItem> get erc20Tokens =>
      ObservableList.of(_tokenStore.erc20Tokens.map((token) {
        final price = _priceStore.prices[token.symbol.toLowerCase()];
        return WalletTokenItem(
          id: token.contractAddress,
          name: token.name,
          symbol: token.symbol,
          balance: token.balanceBN.toAvaxDecimal(denomination: token.decimals),
          balanceText: token.balance,
          type: EZCTokenType.erc20,
          decimals: token.decimals,
          logo: price?.image,
          price: price?.currentPriceDecimal,
        );
      }).toList());

  @computed
  ObservableList<WalletTokenItem> get antokens =>
      ObservableList.of(_tokenStore.antAssets.map((token) {
        final price = _priceStore.prices[token.symbol.toLowerCase()];
        return WalletTokenItem(
          id: token.id,
          name: token.name,
          symbol: token.symbol,
          balance: token.getAmount(),
          balanceText: token.toString(),
          type: EZCTokenType.ant,
          decimals: token.denomination,
          logo: price?.image,
          price: price?.currentPriceDecimal,
        );
      }).toList());

  @computed
  ObservableList<WalletTokenItem> get tokens =>
      ObservableList.of([...antokens, ...erc20Tokens]);

  @action
  refresh() async {
    _balanceStore.updateBalance();
  }
}
