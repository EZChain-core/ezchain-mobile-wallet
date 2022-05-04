import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:wallet/features/common/constant/wallet_constant.dart';
import 'package:wallet/features/common/ext/extensions.dart';
import 'package:wallet/generated/assets.gen.dart';
import 'package:wallet/generated/l10n.dart';
import 'package:wallet/themes/colors.dart';
import 'package:wallet/themes/images.dart';
import 'package:wallet/themes/theme.dart';
import 'package:wallet/themes/typography.dart';

class EarnEstimateRewardsItem {
  final String nodeId;
  final String stake;
  final String potentialReward;
  final String startTime;
  final String endTime;
  final int percent;
  final String? nodeName;
  final String? nodeLogoUrl;

  EarnEstimateRewardsItem(
    this.nodeId,
    this.stake,
    this.potentialReward,
    this.startTime,
    this.endTime,
    this.percent,
    this.nodeName,
    this.nodeLogoUrl,
  );
}

class EarnEstimateRewardsItemWidget extends StatelessWidget {
  final EarnEstimateRewardsItem item;

  const EarnEstimateRewardsItemWidget({Key? key, required this.item})
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _EarnNodeIdWidget(
              id: item.nodeId,
              name: item.nodeName,
              src: item.nodeLogoUrl,
            ),
            const SizedBox(height: 24),
            _EarnEstimateRewardsItemDateBar(
              startTime: item.startTime,
              endTime: item.endTime,
              percent: item.percent,
            ),
            const SizedBox(height: 8),
            _EarnEstimateRewardsItemHorizontalText(
              title: Strings.current.sharedStake,
              content: item.stake,
            ),
            _EarnEstimateRewardsItemHorizontalText(
              title: Strings.current.sharedPotentialReward,
              content: item.potentialReward,
            ),
          ],
        ),
      ),
    );
  }
}

class _EarnEstimateRewardsItemHorizontalText extends StatelessWidget {
  final String title;
  final String content;

  const _EarnEstimateRewardsItemHorizontalText(
      {Key? key, required this.title, required this.content})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<WalletThemeProvider>(
      builder: (context, provider, child) => Container(
        padding: const EdgeInsets.only(top: 12),
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

class _EarnEstimateRewardsItemDateBar extends StatelessWidget {
  final String startTime;
  final String endTime;
  final int percent;

  const _EarnEstimateRewardsItemDateBar({
    Key? key,
    required this.startTime,
    required this.endTime,
    required this.percent,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<WalletThemeProvider>(
      builder: (context, provider, child) => Stack(children: [
        Container(
          height: 40,
          decoration: BoxDecoration(
            color: provider.themeMode.white,
            borderRadius: const BorderRadius.all(Radius.circular(4)),
          ),
          child: Row(
            children: [
              Expanded(
                flex: percent,
                child: Container(
                  decoration: BoxDecoration(
                    color: provider.themeMode.stateSuccess,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(4),
                      bottomLeft: Radius.circular(4),
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 100 - percent,
                child: const SizedBox.shrink(),
              ),
            ],
          ),
        ),
        Container(
          height: 40,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                startTime,
                style: EZCBodySmallTextStyle(color: provider.themeMode.text),
              ),
              Assets.icons.icArrowRightBlack.svg(),
              Text(
                endTime,
                style: EZCBodySmallTextStyle(color: provider.themeMode.text),
              ),
            ],
          ),
        ),
      ]),
    );
  }
}

class _EarnNodeIdWidget extends StatelessWidget {
  final String id;
  final String? name;
  final String? src;

  const _EarnNodeIdWidget({Key? key, required this.id, this.name, this.src})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<WalletThemeProvider>(
      builder: (context, provider, child) => SizedBox(
        width: double.infinity,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            EZCCircleImage(
              src: src ?? defaultNodeLogo,
              size: 64,
              placeholder: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: provider.themeMode.text10,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name ?? Strings.current.sharedNodeId,
                    style: EZCTitleCustomTextStyle(
                        color: provider.themeMode.text90, size: 20),
                  ),
                  Text(
                    id.useCorrectEllipsis(),
                    style:
                        EZCBodySmallTextStyle(color: provider.themeMode.text60),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
