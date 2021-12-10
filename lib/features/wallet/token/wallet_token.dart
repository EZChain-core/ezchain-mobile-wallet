import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wallet/generated/l10n.dart';
import 'package:wallet/themes/colors.dart';
import 'package:wallet/themes/images.dart';
import 'package:wallet/themes/theme.dart';
import 'package:wallet/themes/typography.dart';

class WalletTokenScreen extends StatelessWidget {
  const WalletTokenScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List tokens = <WalletTokenViewData>[
      const WalletTokenViewData(
          "https://upload.wikimedia.org/wikipedia/commons/thumb/9/9a/BTC_Logo.svg/1200px-BTC_Logo.svg.png", "Bitcoin", "BTC", "X-Chain", 20, 66887.47, 1.01),
      const WalletTokenViewData(
          "https://downloads.coindesk.com/arc-hosted-images/eth.png", "Ethereum", "ETH", "P-Chain", 30, 600, -1.01),
    ];

    return Consumer<WalletThemeProvider>(
      builder: (context, provider, child) => Scaffold(
        backgroundColor: Colors.transparent,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 24),
            Row(
              children: [
                const SizedBox(width: 16),
                Text(
                  Strings.current.sharedBalance,
                  style: ROIHeadlineSmallTextStyle(
                      color: provider.themeMode.white),
                ),
                Expanded(
                  child: Text(
                    r'$ 4.000.000',
                    textAlign: TextAlign.end,
                    style: ROIHeadlineSmallTextStyle(
                        color: provider.themeMode.primary),
                  ),
                ),
                const SizedBox(width: 16),
              ],
            ),
            const SizedBox(height: 65),
            Padding(
              padding: const EdgeInsets.only(left: 16),
              child: Text(
                Strings.current.sharedToken,
                style:
                    ROIHeadlineSmallTextStyle(color: provider.themeMode.text),
              ),
            ),
            Expanded(
              child: ListView.separated(
                  padding: const EdgeInsets.only(top: 16),
                  itemBuilder: (BuildContext context, int index) =>
                      _WalletTokenItem(token: tokens[index]),
                  separatorBuilder: (BuildContext context, int index) =>
                      Divider(color: provider.themeMode.text10),
                  itemCount: tokens.length),
            )
          ],
        ),
      ),
    );
  }
}

class _WalletTokenItem extends StatelessWidget {
  final WalletTokenViewData token;

  const _WalletTokenItem({Key? key, required this.token}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<WalletThemeProvider>(
      builder: (context, provider, child) => Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            ROICircleImage(src: token.logo, size: 48),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      Text(
                        token.name,
                        style: ROIBodyLargeTextStyle(
                          color: provider.themeMode.text,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(4)),
                          color: provider.themeMode.primary,
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 2),
                        child: Text(
                          token.type,
                          style: ROITitleMediumTextStyle(
                              color: provider.themeMode.text90),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text(
                        '\$${token.price}',
                        style: ROITitleSmallTextStyle(
                            color: provider.themeMode.text50),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        token.rateString,
                        style: ROITitleSmallTextStyle(
                            color: token.isGainer
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
                  token.quantityString,
                  style: ROIBodyLargeTextStyle(color: provider.themeMode.text),
                ),
                const SizedBox(height: 6),
                Text(
                  token.totalPrice,
                  style:
                      ROITitleSmallTextStyle(color: provider.themeMode.text50),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class WalletTokenViewData {
  final String logo;
  final String name;
  final String code;
  final String type;
  final double quantity;
  final double price;
  final double rate;

  const WalletTokenViewData(this.logo, this.name, this.code, this.type,
      this.quantity, this.price, this.rate);

  bool get isGainer => rate > 0;

  String get rateString => isGainer ? '+$rate' : '$rate';

  String get quantityString => '$quantity $code';

  String get totalPrice => '\$${quantity * price}';
}
