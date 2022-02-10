import 'package:auto_route/src/router/auto_router_x.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wallet/generated/l10n.dart';
import 'package:wallet/themes/theme.dart';
import 'package:wallet/themes/widgets.dart';

class EarnEstimateRewardsScreen extends StatelessWidget {
  const EarnEstimateRewardsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<WalletThemeProvider>(
      builder: (context, provider, child) => Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              EZCAppBar(
                title: Strings.current.earnEstimatedRewards,
                onPressed: () {
                  context.router.pop();
                },
              ),
              Expanded(
                child: ListView(),
              )
            ],
          ),
        ),
      ),
    );
  }
}
