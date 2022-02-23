import 'package:auto_route/src/router/auto_router_x.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:wallet/common/extensions.dart';
import 'package:wallet/common/router.gr.dart';
import 'package:wallet/features/earn/delegate/input/earn_delegate_input.dart';
import 'package:wallet/generated/l10n.dart';
import 'package:wallet/themes/buttons.dart';
import 'package:wallet/themes/colors.dart';
import 'package:wallet/themes/theme.dart';
import 'package:wallet/themes/typography.dart';

class EarnDelegateNodeItem {
  final String nodeId;
  final String validatorStake;
  final String available;
  final int numberOfDelegators;
  final int endTime;
  final String fee;

  EarnDelegateNodeItem(this.nodeId, this.validatorStake, this.available,
      this.numberOfDelegators, this.endTime, this.fee);

  String get endTimeDuration {
    return DateTime.fromMillisecondsSinceEpoch(endTime).parseDurationTime();
  }
}

class EarnDelegateNodeItemWidget extends StatelessWidget {
  final EarnDelegateNodeItem item;

  const EarnDelegateNodeItemWidget({Key? key, required this.item})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<WalletThemeProvider>(
      builder: (context, provider, child) => Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(16)),
            color: provider.themeMode.bg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 16),
              child: Text(
                Strings.current.sharedNodeId,
                style: EZCTitleLargeTextStyle(color: provider.themeMode.text60),
              ),
            ),
            const SizedBox(height: 4),
            Padding(
              padding: const EdgeInsets.only(left: 16),
              child: Text(
                item.nodeId,
                style: EZCTitleLargeTextStyle(color: provider.themeMode.text),
              ),
            ),
            const SizedBox(height: 12),
            _EarnDelegateNodeItemHorizontalText(
              title: Strings.current.earnValidatorStake,
              content: item.validatorStake,
              bg: provider.themeMode.secondary10,
            ),
            _EarnDelegateNodeItemHorizontalText(
              title: Strings.current.sharedAvailable,
              content: item.available,
            ),
            _EarnDelegateNodeItemHorizontalText(
              title: Strings.current.sharedDelegator,
              content: '${item.numberOfDelegators}',
              bg: provider.themeMode.secondary10,
            ),
            _EarnDelegateNodeItemHorizontalText(
              title: Strings.current.sharedEndTime,
              content: item.endTimeDuration,
            ),
            _EarnDelegateNodeItemHorizontalText(
              title: Strings.current.sharedFee,
              content: item.fee,
              bg: provider.themeMode.secondary10,
            ),
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: const EdgeInsets.only(right: 16),
                child: EZCMediumPrimaryButton(
                  text: Strings.current.sharedSelect,
                  width: 157,
                  onPressed: () {
                    context.pushRoute(EarnDelegateInputRoute(
                      args: EarnDelegateInputArgs(
                        item.nodeId,
                        item.endTime,
                      ),
                    ));
                  },
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class _EarnDelegateNodeItemHorizontalText extends StatelessWidget {
  final String title;
  final String content;
  final Color? bg;

  const _EarnDelegateNodeItemHorizontalText(
      {Key? key, required this.title, required this.content, this.bg})
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
