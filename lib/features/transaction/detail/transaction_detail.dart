import 'package:auto_route/auto_route.dart';
import 'package:auto_route/src/router/auto_router_x.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wallet/features/transaction/detail/transaction_detail_store.dart';
import 'package:wallet/generated/l10n.dart';
import 'package:wallet/themes/theme.dart';
import 'package:wallet/themes/widgets.dart';

class TransactionDetailScreen extends StatelessWidget {
  final String txId;

  final TransactionDetailStore _transactionDetailStore =
      TransactionDetailStore();

  TransactionDetailScreen({Key? key, required this.txId}) : super(key: key) {
    _transactionDetailStore.setTxId(txId);
  }

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
            ],
          ),
        ),
      ),
    );
  }
}
