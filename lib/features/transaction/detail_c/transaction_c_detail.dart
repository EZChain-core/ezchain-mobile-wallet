import 'package:auto_route/auto_route.dart';
import 'package:auto_route/src/router/auto_router_x.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wallet/features/transaction/detail_c/transaction_c_detail_store.dart';
import 'package:wallet/generated/assets.gen.dart';
import 'package:wallet/generated/l10n.dart';
import 'package:wallet/roi/wallet/explorer/cchain/types.dart';
import 'package:wallet/themes/colors.dart';
import 'package:wallet/themes/theme.dart';
import 'package:wallet/themes/typography.dart';
import 'package:wallet/themes/widgets.dart';

class TransactionCDetailScreen extends StatelessWidget {
  final CChainExplorerTx cChainExplorerTx;

  final _transactionCDetailStore = TransactionCDetailStore();

  TransactionCDetailScreen({Key? key, required this.cChainExplorerTx})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<WalletThemeProvider>(
      builder: (context, provider, child) => Scaffold(
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              EZCAppBar(
                title: Strings.current.sharedTransactionDetail,
                onPressed: () {
                  context.router.pop();
                },
              ),
              FutureBuilder<TransactionCChainViewData?>(
                future: _transactionCDetailStore.getTransactionDetail(
                    cChainExplorerTx.hash,
                    cChainExplorerTx.nonce,
                    cChainExplorerTx.txReceiptStatus),
                builder: (_, snapshot) {
                  if (snapshot.hasData) {
                    final transaction = snapshot.data;
                    return transaction != null
                        ? Expanded(
                            child: _TransactionCDetailInfoWidget(
                              transaction: transaction,
                            ),
                          )
                        : const SizedBox.shrink();
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
            ],
          ),
        ),
      ),
    );
  }
}

class _TransactionCDetailInfoWidget extends StatelessWidget {
  final TransactionCChainViewData transaction;

  const _TransactionCDetailInfoWidget({Key? key, required this.transaction})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<WalletThemeProvider>(
      builder: (context, provider, child) => SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
        child: Column(
          children: [
            Text(
              transaction.hash,
              style: EZCTitleMediumTextStyle(color: provider.themeMode.text),
            ),
            Divider(
              color: provider.themeMode.text10,
              height: 25,
            ),
            Row(
              children: [
                Expanded(
                  child: Text(
                    Strings.current.sharedResult,
                    style: EZCTitleMediumTextStyle(
                        color: provider.themeMode.text60),
                  ),
                ),
                if (transaction.result) ...[
                  Assets.icons.icTickCircleGreen.svg(width: 16, height: 16),
                  const SizedBox(width: 4),
                  Text(
                    Strings.current.sharedSuccess,
                    style: EZCBodyMediumTextStyle(
                        color: provider.themeMode.stateSuccess),
                  )
                ] else ...[
                  Assets.icons.icInfoCircleRed.svg(width: 16, height: 16),
                  const SizedBox(width: 4),
                  Text(
                    Strings.current.sharedFail,
                    style: EZCBodyMediumTextStyle(
                        color: provider.themeMode.stateDanger),
                  )
                ],
              ],
            ),
            Divider(
              color: provider.themeMode.text10,
              height: 25,
            ),
            Row(

            ),
          ],
        ),
      ),
    );
  }
}
