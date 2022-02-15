import 'package:auto_route/src/router/auto_router_x.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wallet/common/router.gr.dart';
import 'package:wallet/generated/l10n.dart';
import 'package:wallet/themes/buttons.dart';
import 'package:wallet/themes/colors.dart';
import 'package:wallet/themes/inputs.dart';
import 'package:wallet/themes/theme.dart';
import 'package:wallet/themes/typography.dart';
import 'package:wallet/themes/widgets.dart';

class EarnDelegateInputScreen extends StatelessWidget {
  EarnDelegateInputScreen({Key? key}) : super(key: key);

  final intDate = DateTime.now().add(const Duration(days: 21));
  final firstDate = DateTime.now().add(const Duration(days: 14));
  final lastDate = DateTime.now().add(const Duration(days: 365));

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
                              'NodeID-3u3PQSJ3Bz1kQsB5BGm8P8iNVt2qbf4FU',
                              style: EZCTitleLargeTextStyle(
                                  color: provider.themeMode.text),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      EZCDateTimeTextField(
                        label: Strings.current.earnStakingEndDate,
                        prefixText: Strings.current.earnStakingEndDateNote,
                        initDate: intDate,
                        firstDate: firstDate,
                        lastDate: lastDate,
                      ),
                      const SizedBox(height: 16),
                      EZCAmountTextField(
                        label: Strings.current.earnStakeAmount,
                        hint: '0.0',
                        prefixText: Strings.current.earnStakeBalance(1234),
                      ),
                      const SizedBox(height: 16),
                      EZCAddressTextField(
                        label: Strings.current.earnRewardAddress,
                        enabled: false,
                      ),
                      const SizedBox(height: 100),
                      EZCMediumPrimaryButton(
                        text: Strings.current.sharedConfirm,
                        width: 169,
                        isLoading: false,
                        onPressed: () {
                          context.pushRoute(const EarnDelegateConfirmRoute());
                        },
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
