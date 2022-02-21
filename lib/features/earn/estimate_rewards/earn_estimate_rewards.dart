import 'package:auto_route/src/router/auto_router_x.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';
import 'package:wallet/features/earn/estimate_rewards/earn_estimate_rewards_item.dart';
import 'package:wallet/generated/l10n.dart';
import 'package:wallet/themes/colors.dart';
import 'package:wallet/themes/theme.dart';
import 'package:wallet/themes/widgets.dart';

import 'earn_estimate_rewards_store.dart';

class EarnEstimateRewardsScreen extends StatelessWidget {
  final _earnEstimateRewardsStore = EarnEstimateRewardsStore();

  EarnEstimateRewardsScreen({Key? key}) : super(key: key);

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
                child: Observer(
                  builder: (_) => FutureBuilder<List<EarnEstimateRewardsItem>>(
                    future: _earnEstimateRewardsStore.getEstimateRewards(),
                    builder: (_, snapshot) {
                      if (snapshot.hasData) {
                        final nodes = snapshot.data!;
                        return nodes.isNotEmpty
                            ? ListView.separated(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 12),
                                itemCount: nodes.length,
                                itemBuilder: (_, index) =>
                                    EarnEstimateRewardsItemWidget(
                                        item: nodes[index]),
                                separatorBuilder: (_, index) =>
                                    const SizedBox(height: 16),
                              )
                            : const SizedBox.shrink();
                      } else {
                        return Align(
                          alignment: Alignment.center,
                          child: EZCLoading(
                              color: provider.themeMode.secondary,
                              size: 40,
                              strokeWidth: 4),
                        );
                      }
                    },
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
