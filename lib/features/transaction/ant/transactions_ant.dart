import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';
import 'package:wallet/common/extensions.dart';
import 'package:wallet/common/router.dart';
import 'package:wallet/common/router.gr.dart';
import 'package:wallet/features/common/chain_type/ezc_type.dart';
import 'package:wallet/features/transaction/ant/transactions_ant_store.dart';
import 'package:wallet/features/transaction/transactions_item.dart';
import 'package:wallet/features/transaction/widgets/transactions_widgets.dart';
import 'package:wallet/features/wallet/receive/wallet_receive.dart';
import 'package:wallet/features/wallet/token/wallet_token_item.dart';
import 'package:wallet/generated/assets.gen.dart';
import 'package:wallet/generated/l10n.dart';
import 'package:wallet/themes/colors.dart';
import 'package:wallet/themes/theme.dart';
import 'package:wallet/themes/typography.dart';
import 'package:wallet/themes/widgets.dart';

class TransactionsAntScreen extends StatelessWidget {
  final WalletTokenItem token;
  final _transactionsAntStore = TransactionsAntStore();

  TransactionsAntScreen({Key? key, required this.token}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<WalletThemeProvider>(
      builder: (context, provider, child) => Scaffold(
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              EZCAppBar(
                title: '${token.symbol}(${token.chain})',
                onPressed: () {
                  context.router.pop();
                },
              ),
              SizedBox(
                height: 210,
                child: Stack(
                  children: [
                    Assets.images.imgBgHistory.svg(),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 64,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(width: 16),
                              Assets.icons.icEzc64.svg(),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Observer(
                                      builder: (_) => Text(
                                        '${token.balanceText} ${token.symbol}'
                                            .useCorrectEllipsis(),
                                        style: EZCHeadlineSmallTextStyle(
                                            color: provider.themeMode.text),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    if (token.price != null)
                                      Observer(
                                        builder: (_) => Text(
                                          '\$${token.totalPrice}',
                                          style: EZCTitleSmallTextStyle(
                                              color: provider.themeMode.text40),
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 8),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  EZCChainLabelText(text: token.chain),
                                ],
                              ),
                              const SizedBox(width: 16),
                            ],
                          ),
                        ),
                        const SizedBox(height: 40),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            TransactionsButton(
                              text: Strings.current.sharedSend,
                              icon: Assets.icons.icArrowUpPrimary.svg(),
                              onPressed: _onClickSend,
                            ),
                            const SizedBox(width: 40),
                            TransactionsButton(
                                text: Strings.current.sharedReceive,
                                icon: Assets.icons.icArrowDownPrimary.svg(),
                                onPressed: _onClickReceive),
                            const SizedBox(width: 40),
                            TransactionsButton(
                              text: Strings.current.sharedCopy,
                              icon: Assets.icons.icCopyPrimary.svg(),
                              onPressed: _onClickCopy,
                            ),
                          ],
                        ),
                      ],
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Divider(
                        color: provider.themeMode.text10,
                        height: 1,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 16, top: 16, bottom: 10),
                child: Text(
                  Strings.current.sharedTransactions,
                  style:
                      EZCHeadlineSmallTextStyle(color: provider.themeMode.text),
                ),
              ),
              Expanded(
                child: FutureBuilder<List<TransactionsItem>>(
                  future: _transactionsAntStore.getTransactions(token),
                  builder: (_, snapshot) {
                    if (snapshot.hasData) {
                      final transactions = snapshot.data!;
                      return transactions.isNotEmpty
                          ? ListView.separated(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 12),
                              itemCount: transactions.length,
                              itemBuilder: (_, index) =>
                                  buildTransactionWidget(transactions[index]),
                              separatorBuilder: (_, index) => Divider(
                                color: provider.themeMode.text20,
                                height: 1,
                              ),
                            )
                          : const TransactionsNoData();
                    } else {
                      return Align(
                        alignment: Alignment.topCenter,
                        child: EZCLoading(
                            color: provider.themeMode.secondary,
                            size: 40,
                            strokeWidth: 4),
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _onClickCopy() {
    Clipboard.setData(ClipboardData(text: token.id));
    showSnackBar(Strings.current.sharedCopied);
  }

  _onClickReceive() {
    String address = '';
    if (token.type == EZCTokenType.ant) {
      address = _transactionsAntStore.addressX;
    } else {
      address = _transactionsAntStore.addressC;
    }
    walletContext?.pushRoute(
      WalletReceiveRoute(
        args: WalletReceiveArgs(
            token.type.chain, address, token.symbol, token.name),
      ),
    );
  }

  _onClickSend() {
    if (token.type == EZCTokenType.ant) {
      walletContext?.pushRoute(WalletSendAntRoute(token: token));
    } else {
      walletContext?.pushRoute(WalletSendEvmRoute(fromToken: token));
    }
  }
}
