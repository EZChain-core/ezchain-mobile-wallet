import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wallet/features/common/balance_store.dart';
import 'package:wallet/generated/assets.gen.dart';
import 'package:wallet/themes/colors.dart';
import 'package:wallet/themes/images.dart';
import 'package:wallet/themes/theme.dart';
import 'package:wallet/themes/typography.dart';

class WalletTokenItem {
  final String logo;
  final String name;
  final String code;
  final Decimal amount;
  final Decimal price;
  final String amountText;
  final double? rate;
  final String? type;

  const WalletTokenItem(
      this.logo, this.name, this.code, this.amount, this.price, this.amountText,
      [this.type, this.rate]);

  bool? get isGainer => rate != null ? rate! > 0 : null;

  String? get rateString {
    if (isGainer == null) {
      return null;
    } else {
      return isGainer! ? '+$rate' : '-$rate';
    }
  }

  String get totalPrice => '\$${(amount * price).text(decimals: 9)}';
}

class WalletTokenItemWidget extends StatelessWidget {
  final WalletTokenItem token;

  const WalletTokenItemWidget({Key? key, required this.token})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<WalletThemeProvider>(
      builder: (context, provider, child) => Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            EZCCircleImage(
              src: token.logo,
              size: 40,
              placeholder: token.type != null
                  ? Assets.icons.icEzc64.svg()
                  : Assets.icons.icToken.svg(),
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
                          text: token.code,
                          style: EZCTitleSmallTextStyle(
                              color: provider.themeMode.text60),
                          children: [
                            if (token.type != null)
                              TextSpan(
                                text: '  •  ',
                                style: EZCTitleSmallTextStyle(
                                    color: provider.themeMode.text60),
                              ),
                            if (token.type != null)
                              TextSpan(
                                text: token.type!,
                                style: EZCTitleSmallTextStyle(
                                    color: provider.themeMode.primary),
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
                  token.amountText,
                  style: EZCBodyMediumTextStyle(color: provider.themeMode.text),
                ),
                const SizedBox(height: 6),
                Text(
                  token.totalPrice,
                  style:
                      EZCTitleSmallTextStyle(color: provider.themeMode.text50),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
