import 'package:auto_route/src/router/auto_router_x.dart';
import 'package:mobx/mobx.dart';
import 'package:wallet/common/router.dart';
import 'package:wallet/common/router.gr.dart';
import 'package:wallet/ezc/wallet/helpers/address_helper.dart';
import 'package:wallet/features/wallet/token/add_confirm/wallet_token_add_confirm.dart';
import 'package:wallet/generated/l10n.dart';

part 'wallet_token_add_store.g.dart';

class WalletTokenAddStore = _WalletTokenAddStore with _$WalletTokenAddStore;

abstract class _WalletTokenAddStore with Store {
  @observable
  String error = '';

  @action
  validate(String address, String name, String symbol, int decimal) {
    final isAddressValid = validateAddressEvm(address);
    if (!isAddressValid) {
      error = Strings.current.walletTokenAddressInvalid;
      return;
    } else if (name.isEmpty) {
      error = Strings.current.walletTokenNameInvalid;
      return;
    } else if (symbol.isEmpty) {
      error = Strings.current.walletTokenSymbolInvalid;
      return;
    } else if (symbol.length > 4) {
      error = Strings.current.walletTokenSymbolLengthInvalid;
      return;
    } else if (decimal < 1) {
      error = Strings.current.walletTokenDecimalInvalid;
      return;
    }
    walletContext?.pushRoute(WalletTokenAddConfirmRoute(
        args: WalletTokenAddConfirmArgs(address, name, symbol, decimal)));
  }
}
