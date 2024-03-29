// ignore: implementation_imports
import 'package:auto_route/src/router/auto_router_x.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';
import 'package:wallet/features/common/route/router.dart';
import 'package:wallet/features/common/route/router.gr.dart';
import 'package:wallet/features/common/ext/extensions.dart';
import 'package:wallet/features/wallet/token/wallet_token_item.dart';
import 'package:wallet/features/wallet/token/wallet_token_store.dart';
import 'package:wallet/generated/assets.gen.dart';
import 'package:wallet/generated/l10n.dart';
import 'package:wallet/themes/buttons.dart';
import 'package:wallet/themes/colors.dart';
import 'package:wallet/themes/theme.dart';
import 'package:wallet/themes/typography.dart';
import 'package:wallet/themes/widgets.dart';

class WalletTokenScreen extends StatefulWidget {
  const WalletTokenScreen({Key? key}) : super(key: key);

  @override
  State<WalletTokenScreen> createState() => _WalletTokenScreenState();
}

class _WalletTokenScreenState extends State<WalletTokenScreen>
    with AutomaticKeepAliveClientMixin {
  final _walletTokenStore = WalletTokenStore();

  @override
  Widget build(BuildContext context) {
    super.build(context);
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
            child: Column(
              children: [
                Observer(
                  builder: (_) => _WalletTokenHeaderWidget(
                    balance: _walletTokenStore.tokenBalance,
                  ),
                ),
                Expanded(
                  child: Observer(
                    builder: (_) => _walletTokenStore.tokens.isNotEmpty
                        ? ListView.separated(
                            padding: const EdgeInsets.all(0),
                            itemBuilder: (BuildContext context, int index) =>
                                WalletTokenItemWidget(
                                    token: _walletTokenStore.tokens[index]),
                            separatorBuilder:
                                (BuildContext context, int index) =>
                                    Divider(color: provider.themeMode.text10),
                            itemCount: _walletTokenStore.tokens.length)
                        : EZCEmpty(
                            img: Assets.images.imgTokenEmpty
                                .image(width: 188, height: 140),
                            title: Strings.current.walletTokenEmpty,
                            des: Strings.current.walletTokenEmptyDes,
                          ),
                  ),
                ),
                const SizedBox(height: 10),
                EZCMediumPrimaryButton(
                  text: Strings.current.walletAddToken,
                  width: 202,
                  onPressed: _onClickAddToken,
                ),
                const SizedBox(height: 24),
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
    _walletTokenStore.refresh();
    return Future.delayed(const Duration(seconds: 1));
  }

  _onClickAddToken() {
    walletContext?.pushRoute(WalletTokenAddRoute());
  }
}

class _WalletTokenHeaderWidget extends StatelessWidget {
  final String balance;

  const _WalletTokenHeaderWidget({Key? key, required this.balance})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<WalletThemeProvider>(
      builder: (context, provider, child) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 24),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(width: 16),
              Text(
                Strings.current.sharedBalance,
                style:
                    EZCHeadlineSmallTextStyle(color: provider.themeMode.white),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  '\$ $balance'.useCorrectEllipsis(),
                  textAlign: TextAlign.end,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: EZCHeadlineSmallTextStyle(
                      color: provider.themeMode.primary),
                ),
              ),
              const SizedBox(width: 16),
            ],
          ),
          const SizedBox(height: 65),
          Padding(
            padding: const EdgeInsets.only(left: 16),
            child: Text(
              Strings.current.sharedToken,
              style: EZCHeadlineSmallTextStyle(color: provider.themeMode.text),
            ),
          ),
        ],
      ),
    );
  }
}
