import 'package:auto_route/auto_route.dart';
import 'package:wallet/common/extensions.dart';
import 'package:wallet/common/router.gr.dart';

enum EZCType { xChain, pChain, cChain }

extension EZCTypeExtension on EZCType {
  String get name {
    return ["X-Chain", "P-Chain", "C-chain"][index];
  }

  PageRouteInfo? get sendRoute {
    return tryCast<PageRouteInfo>(
        [WalletSendAvmRoute(), null, WalletSendEvmRoute()][index]);
  }

}
