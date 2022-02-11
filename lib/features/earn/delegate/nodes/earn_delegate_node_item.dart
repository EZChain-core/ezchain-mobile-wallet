import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:wallet/generated/l10n.dart';
import 'package:wallet/themes/colors.dart';
import 'package:wallet/themes/theme.dart';
import 'package:wallet/themes/typography.dart';

class EarnDelegateNodeItem {
  final String nodeId;
  final String validatorStake;
  final String available;
  final int numberOfDelegators;
  final String endTime;
  final String fee;

  EarnDelegateNodeItem(this.nodeId, this.validatorStake, this.available,
      this.numberOfDelegators, this.endTime, this.fee);
}

class EarnDelegateNodeItemWidget extends StatelessWidget {
  final EarnDelegateNodeItem item;

  const EarnDelegateNodeItemWidget({Key? key, required this.item})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<WalletThemeProvider>(
      builder: (context, provider, child) => Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(16)),
            color: provider.themeMode.bg),
        child: Column(
          children: [
            Text(
              Strings.current.sharedNodeId,
              style: EZCTitleLargeTextStyle(color: provider.themeMode.text60),
            ),
            const SizedBox(height: 4),
            Text(
              Strings.current.sharedNodeId,
              style: EZCTitleLargeTextStyle(color: provider.themeMode.text),
            ),
          ],
        ),
      ),
    );
  }
}

class _EarnDelegateNodeItemHorizontalText extends StatelessWidget {
  final String title;
  final String content;
  final Color bg;

  const _EarnDelegateNodeItemHorizontalText(
      {Key? key, required this.title, required this.content, required this.bg})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<WalletThemeProvider>(
      builder: (context, provider, child) => Container(
        color: bg,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: EZCTitleLargeTextStyle(color: provider.themeMode.text60),
            ),
            Text(
              content,
              style: EZCTitleLargeTextStyle(color: provider.themeMode.text),
            ),
          ],
        ),
      ),
    );
  }
}
