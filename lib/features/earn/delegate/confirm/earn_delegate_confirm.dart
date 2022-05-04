// ignore: implementation_imports
import 'package:auto_route/src/router/auto_router_x.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';
import 'package:wallet/features/common/ext/extensions.dart';
import 'package:wallet/features/auth/pin/verify/pin_code_verify.dart';
import 'package:wallet/features/common/constant/wallet_constant.dart';
import 'package:wallet/features/earn/delegate/confirm/earn_delegate_confirm_store.dart';
import 'package:wallet/features/earn/delegate/nodes/earn_delegate_node_item.dart';
import 'package:wallet/generated/l10n.dart';
import 'package:wallet/themes/buttons.dart';
import 'package:wallet/themes/colors.dart';
import 'package:wallet/themes/theme.dart';
import 'package:wallet/themes/typography.dart';
import 'package:wallet/themes/widgets.dart';

class EarnDelegateConfirmScreen extends StatelessWidget {
  final EarnDelegateConfirmArgs args;

  final _earnDelegateConfirmStore = EarnDelegateConfirmStore();

  EarnDelegateConfirmScreen({Key? key, required this.args}) : super(key: key) {
    _earnDelegateConfirmStore.calculateFee(args);
  }

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
                              args.delegateItem.nodeId.useCorrectEllipsis(),
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
                          content: args.stakingDuration()),
                      Divider(
                        height: 25,
                        color: provider.themeMode.text10,
                      ),
                      _EarnDelegateHorizontalText(
                          leftText: Strings.current.earnStakingAmount,
                          rightText: '${args.amount} $ezcSymbol'),
                      const SizedBox(height: 12),
                      Observer(
                        builder: (_) => _EarnDelegateHorizontalText(
                            leftText: Strings.current.earnDelegationFee,
                            rightText: _earnDelegateConfirmStore.feeText),
                      ),
                      const SizedBox(height: 12),
                      Observer(
                        builder: (_) => _EarnDelegateHorizontalText(
                            leftText: Strings.current.earnEstimatedReward,
                            rightText:
                                _earnDelegateConfirmStore.estimatedRewardText),
                      ),
                      Divider(
                        height: 25,
                        color: provider.themeMode.text10,
                      ),
                      _EarnDelegateVerticalText(
                          title: Strings.current.earnRewardAddress,
                          content: args.address),
                      const SizedBox(height: 32),
                      Observer(
                        builder: (_) => Column(
                          children: [
                            if (!_earnDelegateConfirmStore.submitSuccess) ...[
                              Observer(
                                builder: (_) => EZCMediumPrimaryButton(
                                  text: Strings.current.sharedSubmit,
                                  width: 162,
                                  isLoading:
                                      _earnDelegateConfirmStore.isLoading,
                                  onPressed: _onClickSubmit,
                                ),
                              ),
                              const SizedBox(height: 4),
                              EZCMediumNoneButton(
                                width: 162,
                                text: Strings.current.sharedCancel,
                                textColor: provider.themeMode.text90,
                                onPressed: () {
                                  context.popRoute();
                                },
                              )
                            ] else ...[
                              Text(
                                Strings.current.sharedCommitted,
                                style: EZCBodyMediumTextStyle(
                                    color: provider.themeMode.stateSuccess),
                              ),
                              const SizedBox(height: 8),
                              EZCMediumSuccessButton(
                                text: Strings.current.earnDelegateBackToEarn,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 56,
                                  vertical: 8,
                                ),
                                onPressed: () {
                                  context.router.popUntilRoot();
                                },
                              )
                            ],
                          ],
                        ),
                      ),
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

  _onClickSubmit() async {
    if (!await verifyPinCode()) return;
    _earnDelegateConfirmStore.delegate(args);
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
  final EarnDelegateNodeItem delegateItem;
  final String address;
  final Decimal amount;
  final DateTime endDate;

  EarnDelegateConfirmArgs(
      this.delegateItem, this.address, this.amount, this.endDate);

  /// Start delegation in 5 minutes after submit
  get startDate => DateTime.now().add(const Duration(minutes: 5));

  String stakingDuration() {
    final diffDays = endDate.difference(startDate).inDays;
    final diffHours =
        endDate.difference(startDate.add(Duration(days: diffDays))).inHours;
    final diffMinutes = endDate
        .difference(startDate.add(Duration(days: diffDays, hours: diffHours)))
        .inMinutes;
    return Strings.current.sharedDateDuration(diffDays, diffHours, diffMinutes);
  }
}
