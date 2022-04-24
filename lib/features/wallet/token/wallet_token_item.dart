// ignore: implementation_imports
import 'package:auto_route/src/router/auto_router_x.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wallet/common/router.dart';
import 'package:wallet/common/router.gr.dart';
import 'package:wallet/ezc/wallet/utils/number_utils.dart';
import 'package:wallet/features/common/type/ezc_type.dart';
import 'package:wallet/generated/assets.gen.dart';
import 'package:wallet/themes/colors.dart';
import 'package:wallet/themes/images.dart';
import 'package:wallet/themes/theme.dart';
import 'package:wallet/themes/typography.dart';

class WalletTokenItem {
  final String id;
  final String name;
  final String symbol;
  final Decimal balance;
  final String balanceText;
  final EZCTokenType type;
  final double? rate;
  final String? logo;
  final Decimal? price;
  final int decimals;

  const WalletTokenItem({
    required this.id,
    required this.name,
    required this.symbol,
    required this.balance,
    required this.balanceText,
    required this.type,
    required this.decimals,
    this.logo,
    this.price,
    this.rate,
  });

  bool? get isGainer => rate != null ? rate! > 0 : null;

  String? get rateString {
    if (isGainer == null) {
      return null;
    } else {
      return isGainer! ? '+$rate' : '-$rate';
    }
  }

  String get totalPrice => price != null
      ? '\$${(balance * price!).toLocaleString(decimals: 9)}'
      : '';

  String get chain => type.chain;
}

class WalletTokenItemWidget extends StatelessWidget {
  final WalletTokenItem token;

  const WalletTokenItemWidget({Key? key, required this.token})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<WalletThemeProvider>(
      builder: (context, provider, child) => InkWell(
        onTap: _onClickToken,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              EZCCircleImage(
                src: token.logo ?? '',
                size: 40,
                placeholder: Assets.icons.icEzc64.svg(),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      token.name,
                      style: EZCBodyMediumTextStyle(
                        color: provider.themeMode.text,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        RichText(
                          text: TextSpan(
                            text: token.symbol,
                            style: EZCTitleSmallTextStyle(
                              color: provider.themeMode.text60,
                            ),
                            children: [
                              TextSpan(
                                text: '  •  ',
                                style: EZCTitleSmallTextStyle(
                                  color: provider.themeMode.text60,
                                ),
                              ),
                              TextSpan(
                                text: token.chain,
                                style: EZCTitleSmallTextStyle(
                                  color: provider.themeMode.primary,
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    token.balanceText,
                    style: EZCBodyMediumTextStyle(
                      color: provider.themeMode.text,
                    ),
                  ),
                  if (token.price != null) ...[
                    const SizedBox(height: 6),
                    Text(
                      token.totalPrice,
                      style: EZCTitleSmallTextStyle(
                        color: provider.themeMode.text50,
                      ),
                    ),
                  ]
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  _onClickToken() {
    switch (token.type) {
      case EZCTokenType.ant:
        walletContext?.pushRoute(TransactionsTokenRoute(token: token));
        break;
      case EZCTokenType.erc20:
        walletContext?.pushRoute(TransactionsTokenRoute(token: token));
        break;
    }
  }
}
