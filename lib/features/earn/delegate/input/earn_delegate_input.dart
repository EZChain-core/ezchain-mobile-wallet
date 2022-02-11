import 'package:auto_route/src/router/auto_router_x.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wallet/generated/l10n.dart';
import 'package:wallet/themes/colors.dart';
import 'package:wallet/themes/inputs.dart';
import 'package:wallet/themes/theme.dart';
import 'package:wallet/themes/typography.dart';
import 'package:wallet/themes/widgets.dart';

class EarnDelegateInputScreen extends StatelessWidget {
  const EarnDelegateInputScreen({Key? key}) : super(key: key);

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
                      ),
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
