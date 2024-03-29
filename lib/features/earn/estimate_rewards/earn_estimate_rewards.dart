// ignore: implementation_imports
import 'package:auto_route/src/router/auto_router_x.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';
import 'package:wallet/features/earn/estimate_rewards/earn_estimate_rewards_item.dart';
import 'package:wallet/features/earn/estimate_rewards/earn_estimate_rewards_store.dart';
import 'package:wallet/generated/assets.gen.dart';
import 'package:wallet/generated/l10n.dart';
import 'package:wallet/themes/colors.dart';
import 'package:wallet/themes/theme.dart';
import 'package:wallet/themes/typography.dart';
import 'package:wallet/themes/widgets.dart';

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
                onPressed: context.router.pop,
              ),
              Expanded(
                child: Observer(builder: (_) {
                  if (_earnEstimateRewardsStore.estimateRewards.isEmpty) {
                    return Align(
                      alignment: Alignment.center,
                      child: EZCEmpty(
                        img: Assets.images.imgDelegationEmpty.image(
                          width: 182,
                          height: 182,
                        ),
                        title: Strings.current.earnEstimateRewardsEmpty,
                        des: Strings.current.earnEstimateRewardsEmptyDes,
                      ),
                    );
                  }
                  return RefreshIndicator(
                    onRefresh: _refresh,
                    child: ListView.separated(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      itemCount:
                          _earnEstimateRewardsStore.estimateRewards.length + 1,
                      itemBuilder: (_, index) {
                        if (index == 0) {
                          return _EarnEstimateRewardsHeader(
                            totalRewards:
                                _earnEstimateRewardsStore.totalRewards,
                          );
                        } else {
                          return EarnEstimateRewardsItemWidget(
                            item: _earnEstimateRewardsStore
                                .estimateRewards[index - 1],
                          );
                        }
                      },
                      separatorBuilder: (_, index) =>
                          const SizedBox(height: 16),
                    ),
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _refresh() {
    _earnEstimateRewardsStore.refresh();
    return Future.delayed(const Duration(seconds: 1));
  }
}

class _EarnEstimateRewardsHeader extends StatelessWidget {
  final String totalRewards;

  const _EarnEstimateRewardsHeader({Key? key, required this.totalRewards})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<WalletThemeProvider>(
      builder: (context, provider, child) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            Strings.current.earnDelegation,
            style: EZCHeadlineSmallTextStyle(color: provider.themeMode.text),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(16)),
                color: provider.themeMode.blue1),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  Strings.current.earnTotalRewards,
                  style:
                      EZCTitleLargeTextStyle(color: provider.themeMode.white),
                ),
                Text(
                  totalRewards,
                  style:
                      EZCBoldMediumTextStyle(color: provider.themeMode.white),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
