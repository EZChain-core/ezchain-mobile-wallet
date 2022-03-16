import 'package:auto_route/auto_route.dart';
import 'package:wallet/common/extensions.dart';
import 'package:wallet/common/router.gr.dart';

enum EZCType { xChain, pChain, cChain }

extension EZCTypeExtension on EZCType {
  String get name {
    return ["X-Chain", "P-Chain", "C-Chain"][index];
  }

  String get chainAlias {
    return ["X", "P", "C"][index];
  }

  PageRouteInfo? get sendRoute {
    return tryCast<PageRouteInfo>(
        [WalletSendAvmRoute(), null, WalletSendEvmRoute()][index]);
  }
}

EZCType chainAliasToEZCType(String chain) {
  return EZCType.values.firstWhere((element) => element.chainAlias == chain);
}


enum EZCTokenType { ant, erc20 }

extension EZCTokenTypeExtension on EZCTokenType {

  EZCType get ezcType {
    return [EZCType.xChain, EZCType.cChain][index];
  }

  String get chain => ezcType.name;
}