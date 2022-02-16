import 'package:auto_route/src/router/auto_router_x.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wallet/common/extensions.dart';
import 'package:wallet/generated/l10n.dart';
import 'package:wallet/themes/buttons.dart';
import 'package:wallet/themes/colors.dart';
import 'package:wallet/themes/theme.dart';
import 'package:wallet/themes/typography.dart';
import 'package:wallet/themes/widgets.dart';

class EarnDelegateConfirmScreen extends StatelessWidget {
  final EarnDelegateConfirmArgs args;

  const EarnDelegateConfirmScreen({Key? key, required this.args})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<WalletThemeProvider>(
      builder: (context, provider, child) => Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              EZCAppBar(
                title: Strings.current.sharedDelegate,
                onPressed: () {
                  context.router.pop();
                },
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: provider.themeMode.bg,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(16)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              Strings.current.sharedNodeId,
                              style: EZCTitleLargeTextStyle(
                                  color: provider.themeMode.text60),
                            ),
                            Text(
                              args.nodeId,
                              style: EZCTitleLargeTextStyle(
                                  color: provider.themeMode.text),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      _EarnDelegateVerticalText(
                        title: Strings.current.sharedStartDate,
                        content: Strings.current.earnDelegateConfirmStartDate,
                      ),
                      const SizedBox(height: 12),
                      _EarnDelegateVerticalText(
                        title: Strings.current.sharedEndDate,
                        content: args.endDate.formatYMdDateHoursTime(),
                      ),
                      const SizedBox(height: 12),
                      _EarnDelegateVerticalText(
                          title: Strings.current.earnStakingDuration,
                          content: '21 days '),
                      Divider(
                        height: 25,
                        color: provider.themeMode.text10,
                      ),
                      _EarnDelegateHorizontalText(
                          leftText: Strings.current.earnStakingAmount,
                          rightText: '${args.amount} EZC'),
                      const SizedBox(height: 12),
                      _EarnDelegateHorizontalText(
                          leftText: Strings.current.earnDelegationFee,
                          rightText: '2 %'),
                      const SizedBox(height: 12),
                      _EarnDelegateHorizontalText(
                          leftText: Strings.current.earnEstimatedReward,
                          rightText: '1.13 EZC'),
                      Divider(
                        height: 25,
                        color: provider.themeMode.text10,
                      ),
                      _EarnDelegateVerticalText(
                          title: Strings.current.earnRewardAddress,
                          content: args.address),
                      const SizedBox(height: 32),
                      EZCMediumPrimaryButton(
                        text: Strings.current.sharedSubmit,
                        width: 162,
                      ),
                      const SizedBox(height: 4),
                      EZCMediumNoneButton(text: Strings.current.sharedCancel)
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _EarnDelegateHorizontalText extends StatelessWidget {
  final String leftText;
  final String rightText;

  const _EarnDelegateHorizontalText({
    Key? key,
    required this.leftText,
    required this.rightText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<WalletThemeProvider>(
      builder: (context, provider, child) => SizedBox(
        width: double.infinity,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              leftText,
              style: EZCTitleMediumTextStyle(color: provider.themeMode.text60),
            ),
            Text(
              rightText,
              style: EZCTitleMediumTextStyle(color: provider.themeMode.text),
            ),
          ],
        ),
      ),
    );
  }
}

class _EarnDelegateVerticalText extends StatelessWidget {
  final String title;
  final String content;

  const _EarnDelegateVerticalText({
    Key? key,
    required this.title,
    required this.content,
  }) : super(key: key);

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
              style: EZCTitleMediumTextStyle(color: provider.themeMode.text60),
            ),
            const SizedBox(height: 8),
            Text(
              content,
              style: EZCTitleMediumTextStyle(color: provider.themeMode.text),
            ),
          ],
        ),
      ),
    );
  }
}

class EarnDelegateConfirmArgs {
  final String nodeId;
  final String address;
  final Decimal amount;
  final DateTime endDate;

  EarnDelegateConfirmArgs(this.nodeId, this.address, this.amount, this.endDate);
}
