import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';
import 'package:wallet/features/wallet/token/wallet_token_item.dart';
import 'package:wallet/features/wallet/token/wallet_token_store.dart';
import 'package:wallet/generated/l10n.dart';
import 'package:wallet/themes/colors.dart';
import 'package:wallet/themes/theme.dart';
import 'package:wallet/themes/typography.dart';

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
            child: Observer(
              builder: (_) => ListView.separated(
                  padding: const EdgeInsets.all(0),
                  itemBuilder: (BuildContext context, int index) => index == 0
                      ? _WalletTokenHeaderWidget()
                      : WalletTokenItemWidget(
                          token: _walletTokenStore.tokens[index - 1]),
                  separatorBuilder: (BuildContext context, int index) =>
                      index == 0
                          ? const SizedBox.shrink()
                          : Divider(color: provider.themeMode.text10),
                  itemCount: _walletTokenStore.tokens.length + 1),
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
}

class _WalletTokenHeaderWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<WalletThemeProvider>(
      builder: (context, provider, child) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 24),
          Row(
            children: [
              const SizedBox(width: 16),
              Text(
                Strings.current.sharedBalance,
                style:
                    EZCHeadlineSmallTextStyle(color: provider.themeMode.white),
              ),
              Expanded(
                child: Text(
                  r'$ 4.000.000',
                  textAlign: TextAlign.end,
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
