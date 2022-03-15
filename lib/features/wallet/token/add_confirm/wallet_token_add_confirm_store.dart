import 'package:auto_route/src/router/auto_router_x.dart';
import 'package:mobx/mobx.dart';
import 'package:wallet/common/logger.dart';
import 'package:wallet/common/router.dart';
import 'package:wallet/di/di.dart';
import 'package:wallet/ezc/wallet/helpers/address_helper.dart';
import 'package:wallet/ezc/wallet/network/network.dart';
import 'package:wallet/ezc/wallet/utils/number_utils.dart';
import 'package:wallet/features/auth/pin/verify/pin_code_verify.dart';
import 'package:wallet/features/common/wallet_factory.dart';
import 'package:wallet/generated/l10n.dart';

part 'wallet_token_add_confirm_store.g.dart';

class WalletTokenAddConfirmStore = _WalletTokenAddConfirmStore with _$WalletTokenAddConfirmStore;

abstract class _WalletTokenAddConfirmStore with Store {

}
