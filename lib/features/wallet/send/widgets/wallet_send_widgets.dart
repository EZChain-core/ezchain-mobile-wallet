import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wallet/themes/colors.dart';
import 'package:wallet/themes/theme.dart';
import 'package:wallet/themes/typography.dart';

class WalletSendVerticalText extends StatelessWidget {
  final String title;

  final String content;

  final bool? hasDivider;

  const WalletSendVerticalText(
      {Key? key, required this.title, required this.content, this.hasDivider})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<WalletThemeProvider>(
      builder: (context, provider, child) => SizedBox(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: ROITitleLargeTextStyle(color: provider.themeMode.text60),
            ),
            const SizedBox(height: 8),
            Text(
              content,
              style: ROIBodyLargeTextStyle(color: provider.themeMode.text),
            ),
            if (hasDivider == true) const SizedBox(height: 8),
            if (hasDivider == true)
              Divider(
                height: 0,
                color: provider.themeMode.text10,
              )
          ],
        ),
      ),
    );
  }
}

class WalletSendHorizontalText extends StatelessWidget {
  final String title;

  final String content;

  final Color? leftColor;

  final Color? rightColor;

  const WalletSendHorizontalText(
      {Key? key,
      required this.title,
      required this.content,
      this.leftColor,
      this.rightColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<WalletThemeProvider>(
      builder: (context, provider, child) => SizedBox(
        width: double.infinity,
        child: Row(
          children: [
            Text(
              title,
              style: ROITitleLargeTextStyle(
                  color: leftColor ?? provider.themeMode.text60),
            ),
            const Spacer(),
            Text(
              content,
              style: ROITitleLargeTextStyle(
                  color: rightColor ?? provider.themeMode.text),
            ),
          ],
        ),
      ),
    );
  }
}
