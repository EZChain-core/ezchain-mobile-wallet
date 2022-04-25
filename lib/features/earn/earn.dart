// ignore: implementation_imports
import 'package:auto_route/src/router/auto_router_x.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';
import 'package:wallet/features/common/route/router.gr.dart';
import 'package:wallet/generated/l10n.dart';
import 'package:wallet/themes/buttons.dart';
import 'package:wallet/themes/colors.dart';
import 'package:wallet/themes/theme.dart';
import 'package:wallet/themes/typography.dart';

import 'earn_store.dart';

class EarnScreen extends StatelessWidget {
  EarnScreen({Key? key}) : super(key: key);

  final _earnStore = EarnStore();

  @override
  Widget build(BuildContext context) {
    return Consumer<WalletThemeProvider>(
      builder: (context, provider, child) => Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: provider.themeMode.bg,
                    borderRadius: const BorderRadius.all(Radius.circular(16)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        Strings.current.sharedDelegate,
                        style: EZCTitleLargeTextStyle(
                            color: provider.themeMode.text),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        Strings.current.earnDelegateDescription,
                        style: EZCBodyLargeTextStyle(
                            color: provider.themeMode.text70),
                      ),
                      Observer(
                        builder: (_) => !_earnStore.permittedAddDelegator
                            ? Container(
                                width: double.infinity,
                                height: 52,
                                margin: const EdgeInsets.only(top: 16),
                                decoration: BoxDecoration(
                                  color: provider.themeMode.primary10,
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(4)),
                                  border: Border.all(
                                      color: provider.themeMode.primary80),
                                ),
                                child: Stack(
                                  children: [
                                    Container(
                                      width: 4,
                                      height: double.infinity,
                                      decoration: BoxDecoration(
                                        borderRadius: const BorderRadius.only(
                                            topLeft: Radius.circular(4),
                                            bottomLeft: Radius.circular(4)),
                                        color: provider.themeMode.primary,
                                      ),
                                    ),
                                    Align(
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 16),
                                        child: Text(
                                          Strings.current.earnDelegateValidMess,
                                          style: EZCLabelMediumTextStyle(
                                              color:
                                                  provider.themeMode.primary),
                                        ),
                                      ),
                                      alignment: Alignment.center,
                                    ),
                                  ],
                                ),
                              )
                            : const SizedBox.shrink(),
                      ),
                      const SizedBox(height: 16),
                      Observer(
                        builder: (_) => EZCMediumPrimaryButton(
                          width: 130,
                          text: Strings.current.earnDelegateAdd,
                          enabled: _earnStore.permittedAddDelegator,
                          onPressed: () {
                            context.pushRoute(EarnDelegateNodesRoute());
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    EZCMediumNoneButton(
                      text: Strings.current.earnCrossTransfer,
                      onPressed: () {
                        context.navigateTo(
                            const DashboardRoute(children: [CrossRoute()]));
                      },
                    ),
                    EZCMediumNoneButton(
                      text: Strings.current.earnEstimatedRewards,
                      onPressed: () {
                        context.pushRoute(EarnEstimateRewardsRoute());
                      },
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
