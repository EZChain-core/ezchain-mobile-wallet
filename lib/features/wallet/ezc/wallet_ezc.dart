import 'dart:ui';

import 'package:auto_route/src/router/auto_router_x.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';
import 'package:wallet/common/extensions.dart';
import 'package:wallet/common/router.gr.dart';
import 'package:wallet/features/common/chain_type/ezc_type.dart';
import 'package:wallet/features/wallet/ezc/wallet_ezc_store.dart';
import 'package:wallet/features/wallet/receive/wallet_receive.dart';
import 'package:wallet/generated/assets.gen.dart';
import 'package:wallet/generated/l10n.dart';
import 'package:wallet/themes/colors.dart';
import 'package:wallet/themes/theme.dart';
import 'package:wallet/themes/typography.dart';

class WalletEZCScreen extends StatefulWidget {
  const WalletEZCScreen({Key? key}) : super(key: key);

  @override
  State<WalletEZCScreen> createState() => _WalletEZCScreenState();
}

class _WalletEZCScreenState extends State<WalletEZCScreen>
    with AutomaticKeepAliveClientMixin {
  final _walletEZCStore = WalletEZCStore();

  @override
  void initState() {
    _walletEZCStore.fetchData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
                    const SizedBox(width: 18),
                    Assets.images.imgLogoEzc.svg(),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Observer(
                            builder: (_) => Text(
                              '${_walletEZCStore.totalRoi} EZC'
                                  .useCorrectEllipsis(),
                              style: EZCHeadlineSmallTextStyle(
                                  color: provider.themeMode.primary),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Observer(
                            builder: (_) => Text(
                              '\$ ${_walletEZCStore.totalUsd}'
                                  .useCorrectEllipsis(),
                              style: EZCTitleLargeTextStyle(
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
                    availableRoi: _walletEZCStore.balanceX.availableString,
                    lockRoi: _walletEZCStore.balanceX.lockString,
                    onSendPressed: () =>
                        context.router.push(WalletSendAvmRoute()),
                    onReceivePressed: () => context.router.push(
                      WalletReceiveRoute(
                        walletReceiveInfo: WalletReceiveArgs(
                            'X-Chain', _walletEZCStore.addressX),
                      ),
                    ),
                    onPressed: () => context
                        .pushRoute(TransactionsRoute(ezcType: EZCType.xChain)),
                  ),
                ),
                const SizedBox(height: 12),
                Observer(
                  builder: (_) => _WalletChainWidget(
                    chain: Strings.current.sharedPChain,
                    availableRoi: _walletEZCStore.balanceP.availableString,
                    lockRoi: _walletEZCStore.balanceP.lockString,
                    lockStakeableRoi:
                        _walletEZCStore.balanceP.lockStakeableString,
                    hasSend: false,
                    onReceivePressed: () => context.router.push(
                      WalletReceiveRoute(
                        walletReceiveInfo: WalletReceiveArgs(
                            'P-Chain', _walletEZCStore.addressP),
                      ),
                    ),
                    onPressed: () => context
                        .pushRoute(TransactionsRoute(ezcType: EZCType.pChain)),
                  ),
                ),
                const SizedBox(height: 12),
                Observer(
                  builder: (_) => _WalletChainWidget(
                    chain: Strings.current.sharedCChain,
                    availableRoi: _walletEZCStore.balanceC.availableString,
                    lockRoi: _walletEZCStore.balanceC.lockString,
                    onSendPressed: () =>
                        context.router.push(WalletSendEvmRoute()),
                    onReceivePressed: () => context.router.push(
                      WalletReceiveRoute(
                        walletReceiveInfo: WalletReceiveArgs(
                            'C-Chain', _walletEZCStore.addressC),
                      ),
                    ),
                    onPressed: () => context
                        .pushRoute(TransactionsRoute(ezcType: EZCType.cChain)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;

  Future<void> _refresh() {
    _walletEZCStore.refresh();
    return Future.delayed(const Duration(seconds: 1));
  }
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
            style: EZCTitleSmallTextStyle(color: provider.themeMode.text90),
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
  final VoidCallback? onPressed;

  const _WalletChainWidget(
      {Key? key,
      required this.chain,
      required this.availableRoi,
      this.lockRoi,
      this.hasSend,
      this.onSendPressed,
      this.onReceivePressed,
      this.lockStakeableRoi,
      this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<WalletThemeProvider>(
      builder: (context, provider, child) => GestureDetector(
        onTap: onPressed,
        child: Container(
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
                    style: EZCHeadlineSmallTextStyle(
                        color: provider.themeMode.text),
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
                    style: EZCTitleMediumTextStyle(
                        color: provider.themeMode.secondary60),
                  ),
                  Text(
                    '$availableRoi EZC',
                    style:
                        EZCTitleMediumTextStyle(color: provider.themeMode.text),
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
                      style: EZCTitleMediumTextStyle(
                          color: provider.themeMode.secondary60),
                    ),
                    Text(
                      '$lockRoi EZC',
                      style: EZCTitleMediumTextStyle(
                          color: provider.themeMode.text),
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
                      style: EZCTitleMediumTextStyle(
                          color: provider.themeMode.secondary60),
                    ),
                    Text(
                      '$lockStakeableRoi EZC',
                      style: EZCTitleMediumTextStyle(
                          color: provider.themeMode.text),
                    ),
                  ],
                ),
              ]
            ],
          ),
        ),
      ),
    );
  }
}
