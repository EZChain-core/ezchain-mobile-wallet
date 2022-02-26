import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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

  String get amountCode => '$amountText $code';

  String get totalPrice => '\$${amount * price}';
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
              size: 48,
              placeholder: Assets.icons.icEzc64.svg(),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      Text(
                        token.name,
                        style: EZCBodyLargeTextStyle(
                          color: provider.themeMode.text,
                        ),
                      ),
                      const SizedBox(width: 8),
                      if (token.type != null)
                        EZCChainLabelText(text: token.type!)
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text(
                        '\$${token.price}',
                        style: EZCTitleSmallTextStyle(
                            color: provider.themeMode.text50),
                      ),
                      const SizedBox(width: 4),
                      if (token.rate != null)
                        Text(
                          token.rateString!,
                          style: EZCTitleSmallTextStyle(
                              color: token.isGainer!
                                  ? provider.themeMode.stateSuccess
                                  : provider.themeMode.stateDanger),
                        ),
                    ],
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  token.amountCode,
                  style: EZCBodyLargeTextStyle(color: provider.themeMode.text),
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
