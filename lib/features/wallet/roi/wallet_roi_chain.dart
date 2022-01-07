import 'dart:ui';

import 'package:auto_route/src/router/auto_router_x.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';
import 'package:wallet/common/extensions.dart';
import 'package:wallet/common/router.gr.dart';
import 'package:wallet/features/wallet/receive/wallet_receive.dart';
import 'package:wallet/features/wallet/roi/wallet_roi_chain_store.dart';
import 'package:wallet/generated/assets.gen.dart';
import 'package:wallet/generated/l10n.dart';
import 'package:wallet/themes/colors.dart';
import 'package:wallet/themes/theme.dart';
import 'package:wallet/themes/typography.dart';

class WalletROIChainScreen extends StatefulWidget {
  const WalletROIChainScreen({Key? key}) : super(key: key);

  @override
  State<WalletROIChainScreen> createState() => _WalletROIChainScreenState();
}

class _WalletROIChainScreenState extends State<WalletROIChainScreen> with AutomaticKeepAliveClientMixin{
  @override
  Widget build(BuildContext context) {
    final walletRoiChainStore = WalletRoiChainStore();
    walletRoiChainStore.fetchData();

    Future<void> _refresh() {
      walletRoiChainStore.refresh();
      return Future.delayed(const Duration(seconds: 1));
    }

    return Consumer<WalletThemeProvider>(
      builder: (context, provider, child) => Scaffold(
        backgroundColor: Colors.transparent,
        body: RefreshIndicator(
          onRefresh: _refresh,
          child: NotificationListener<OverscrollIndicatorNotification>(
            onNotification: (overscroll) {
              overscroll.disallowIndicator();
              return true;
            },
            child: ListView(
              padding: const EdgeInsets.all(0),
              children: [
                const SizedBox(height: 24),
                Row(
                  children: [
                    const SizedBox(width: 16),
                    Assets.images.imgLogoRoi.image(width: 63, height: 48),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Observer(
                            builder: (_) => Text(
                              '${walletRoiChainStore.totalRoi} ROI'
                                  .useCorrectEllipsis(),
                              style: ROIHeadlineSmallTextStyle(
                                  color: provider.themeMode.primary),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Observer(
                            builder: (_) => Text(
                              '\$ ${walletRoiChainStore.totalUsd}'
                                  .useCorrectEllipsis(),
                              style: ROITitleLargeTextStyle(
                                  color: provider.themeMode.white),
                              maxLines: 1,
                              softWrap: false,
                              textAlign: TextAlign.end,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                  ],
                ),
                const SizedBox(height: 22),
                const SizedBox(height: 20),
                Observer(
                  builder: (_) => _WalletChainWidget(
                    chain: Strings.current.sharedXChain,
                    availableRoi: walletRoiChainStore.balanceX.available,
                    lockRoi: walletRoiChainStore.balanceX.lock,
                    onSendPressed: () =>
                        context.router.push(const WalletSendAvmRoute()),
                    onReceivePressed: () => context.router.push(
                      WalletReceiveRoute(
                        walletReceiveInfo: WalletReceiveInfo(
                            'X-Chain', walletRoiChainStore.addressX),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Observer(
                  builder: (_) => _WalletChainWidget(
                    chain: Strings.current.sharedPChain,
                    availableRoi: walletRoiChainStore.balanceP.available,
                    lockRoi: walletRoiChainStore.balanceP.lock,
                    lockStakeableRoi:
                    walletRoiChainStore.balanceP.lockStakeable,
                    hasSend: false,
                    onReceivePressed: () => context.router.push(
                      WalletReceiveRoute(
                        walletReceiveInfo: WalletReceiveInfo(
                            'P-Chain', walletRoiChainStore.addressP),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Observer(
                  builder: (_) => _WalletChainWidget(
                    chain: Strings.current.sharedCChain,
                    availableRoi: walletRoiChainStore.balanceC.available,
                    lockRoi: walletRoiChainStore.balanceC.lock,
                    onSendPressed: () =>
                        context.router.push(const WalletSendEvmRoute()),
                    onReceivePressed: () => context.router.push(
                      WalletReceiveRoute(
                        walletReceiveInfo: WalletReceiveInfo(
                            'C-Chain', walletRoiChainStore.addressC),
                      ),
                    ),
                  ),
                ),
                // Expanded(
                //   child: RefreshIndicator(
                //     onRefresh: _refresh,
                //     child: ListView(
                //       padding: const EdgeInsets.all(0),
                //       children: [
                //
                //       ],
                //     ),
                //   ),
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class _WalletButton extends StatelessWidget {
  final String text;
  final Widget icon;
  final VoidCallback? onPressed;

  const _WalletButton(
      {Key? key,
      required this.text,
      required this.icon,
      required this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<WalletThemeProvider>(
      builder: (context, provider, child) => SizedBox(
        height: 24,
        child: TextButton.icon(
          onPressed: onPressed,
          label: Text(
            text,
            style: ROITitleSmallTextStyle(color: provider.themeMode.text90),
            textAlign: TextAlign.center,
          ),
          icon: icon,
          style: TextButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            backgroundColor: provider.themeMode.primary,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(12)),
            ),
          ),
        ),
      ),
    );
  }
}

class _WalletChainWidget extends StatelessWidget {
  final String chain;
  final String availableRoi;
  final String? lockRoi;
  final String? lockStakeableRoi;
  final bool? hasSend;
  final VoidCallback? onSendPressed;
  final VoidCallback? onReceivePressed;

  const _WalletChainWidget(
      {Key? key,
      required this.chain,
      required this.availableRoi,
      this.lockRoi,
      this.hasSend,
      this.onSendPressed,
      this.onReceivePressed,
      this.lockStakeableRoi})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<WalletThemeProvider>(
      builder: (context, provider, child) => Container(
        padding:
            const EdgeInsets.only(left: 16, right: 16, top: 12, bottom: 16),
        margin: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: provider.themeMode.bg,
          borderRadius: const BorderRadius.all(Radius.circular(8)),
        ),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  chain,
                  style:
                      ROIHeadlineSmallTextStyle(color: provider.themeMode.text),
                ),
                const Spacer(),
                if (hasSend != false)
                  _WalletButton(
                    text: Strings.current.sharedSend,
                    icon: Assets.icons.icArrowUp.svg(),
                    onPressed: onSendPressed,
                  ),
                const SizedBox(width: 8),
                _WalletButton(
                  text: Strings.current.sharedReceive,
                  icon: Assets.icons.icArrowDown.svg(),
                  onPressed: onReceivePressed,
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  Strings.current.sharedAvailable,
                  style: ROITitleMediumTextStyle(
                      color: provider.themeMode.secondary60),
                ),
                Text(
                  '$availableRoi ROI',
                  style:
                      ROITitleMediumTextStyle(color: provider.themeMode.text),
                ),
              ],
            ),
            const SizedBox(height: 8),
            if (lockRoi != null)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    Strings.current.sharedLock,
                    style: ROITitleMediumTextStyle(
                        color: provider.themeMode.secondary60),
                  ),
                  Text(
                    '$lockRoi ROI',
                    style:
                        ROITitleMediumTextStyle(color: provider.themeMode.text),
                  ),
                ],
              ),
            if (lockStakeableRoi != null) ...[
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    Strings.current.sharedLockStakeable,
                    style: ROITitleMediumTextStyle(
                        color: provider.themeMode.secondary60),
                  ),
                  Text(
                    '$lockStakeableRoi ROI',
                    style:
                        ROITitleMediumTextStyle(color: provider.themeMode.text),
                  ),
                ],
              ),
            ]
          ],
        ),
      ),
    );
  }
}
