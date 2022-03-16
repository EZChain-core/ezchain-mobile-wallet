import 'package:auto_route/auto_route.dart';
import 'package:auto_route/src/router/auto_router_x.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wallet/common/extensions.dart';
import 'package:wallet/features/transaction/detail/transaction_detail_store.dart';
import 'package:wallet/features/transaction/detail/transaction_detail_view_data.dart';
import 'package:wallet/generated/l10n.dart';
import 'package:wallet/themes/colors.dart';
import 'package:wallet/themes/theme.dart';
import 'package:wallet/themes/typography.dart';
import 'package:wallet/themes/widgets.dart';

class TransactionDetailScreen extends StatelessWidget {
  final String txId;

  final TransactionDetailStore _transactionDetailStore =
      TransactionDetailStore();

  TransactionDetailScreen({Key? key, required this.txId}) : super(key: key);

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
              FutureBuilder<TransactionDetailViewData?>(
                future: _transactionDetailStore.getTransactionDetail(txId),
                builder: (_, snapshot) {
                  if (snapshot.hasData) {
                    final transaction = snapshot.data;
                    return transaction != null
                        ? Expanded(
                            child: _TransactionDetailInfoWidget(
                              transaction: transaction,
                            ),
                          )
                        : const SizedBox.shrink();
                  } else {
                    return Expanded(
                      child: Align(
                        alignment: Alignment.center,
                        child: EZCLoading(
                            color: provider.themeMode.secondary,
                            size: 40,
                            strokeWidth: 4),
                      ),
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

class _TransactionDetailInfoWidget extends StatelessWidget {
  final TransactionDetailViewData transaction;

  const _TransactionDetailInfoWidget({Key? key, required this.transaction})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<WalletThemeProvider>(
      builder: (context, provider, child) => SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(16)),
                  color: provider.themeMode.bg),
              child: Column(
                children: [
                  Text(
                    transaction.id,
                    style: EZCTitleLargeTextStyle(
                        color: provider.themeMode.secondary),
                  ),
                  const SizedBox(height: 22),
                  if (transaction.accepted.isNotNullOrEmpty)
                    _TransactionDetailHorizontalText(
                        leftText: Strings.current.sharedAccepted,
                        rightText: transaction.accepted!),
                  const SizedBox(height: 12),
                  if (transaction.value.isNotNullOrEmpty)
                    _TransactionDetailHorizontalText(
                        leftText: Strings.current.sharedValue,
                        rightText: transaction.value!),
                  const SizedBox(height: 12),
                  if (transaction.burned.isNotNullOrEmpty)
                    _TransactionDetailHorizontalText(
                        leftText: Strings.current.sharedBurned,
                        rightText: transaction.burned!),
                  const SizedBox(height: 12),
                  if (transaction.blockchain != null)
                    _TransactionDetailHorizontalText(
                        leftText: Strings.current.sharedBlockchain,
                        rightText: transaction.blockchain!.name),
                  const SizedBox(height: 12),
                  if (transaction.memo.isNotNullOrEmpty)
                    _TransactionDetailHorizontalText(
                        leftText: Strings.current.sharedMemo,
                        rightText: transaction.memo!),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16, bottom: 8),
              child: Text(
                Strings.current.sharedInput,
                style: EZCTitleLargeTextStyle(color: provider.themeMode.text),
              ),
            ),
            transaction.inputs.isNotEmpty
                ? Column(
                    children: transaction.inputs
                        .map((e) => _TransactionDetailInputWidget(input: e))
                        .toList())
                : Text(Strings.current.transactionsNoInputs),
            Padding(
              padding: const EdgeInsets.only(left: 16, bottom: 8),
              child: Text(
                Strings.current.sharedOutput,
                style: EZCTitleLargeTextStyle(color: provider.themeMode.text),
              ),
            ),
            transaction.outputs.isNotEmpty
                ? Column(
                    children: transaction.outputs
                        .map((e) => _TransactionDetailOutputWidget(output: e))
                        .toList())
                : Text(Strings.current.transactionsNoOutputs),
          ],
        ),
      ),
    );
  }
}

class _TransactionDetailInputWidget extends StatelessWidget {
  final TransactionDetailInputViewData input;

  const _TransactionDetailInputWidget({Key? key, required this.input})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final from = input.from ?? '';
    final signature = input.signature ?? '';

    return Consumer<WalletThemeProvider>(
      builder: (context, provider, child) => Container(
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
        decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(16)),
            color: provider.themeMode.bg),
        child: Stack(
          children: [
            Column(
              children: [
                if (from.isNotEmpty)
                  _TransactionDetailVerticalText(
                    title: Strings.current.transactionsForm,
                    content: from,
                  ),
                const SizedBox(height: 12),
                if (signature.isNotEmpty)
                  _TransactionDetailVerticalText(
                    title: Strings.current.transactionsSignature,
                    content: signature,
                  )
              ],
            ),
            Align(
              alignment: Alignment.topRight,
              child: _TransactionDetailIndexWidget(index: input.index),
            )
          ],
        ),
      ),
    );
  }
}

class _TransactionDetailOutputWidget extends StatelessWidget {
  final TransactionDetailOutputViewData output;

  const _TransactionDetailOutputWidget({Key? key, required this.output})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final to = output.to ?? '';

    return Consumer<WalletThemeProvider>(
      builder: (context, provider, child) => Container(
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
        decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(16)),
            color: provider.themeMode.bg),
        child: Stack(
          children: [
            Column(
              children: [
                if (to.isNotEmpty)
                  _TransactionDetailVerticalText(
                    title: Strings.current.transactionsTo,
                    content: to,
                  ),
              ],
            ),
            Align(
              alignment: Alignment.topRight,
              child: _TransactionDetailIndexWidget(index: output.index),
            )
          ],
        ),
      ),
    );
  }
}

class _TransactionDetailHorizontalText extends StatelessWidget {
  final String leftText;
  final String rightText;

  const _TransactionDetailHorizontalText({
    Key? key,
    required this.leftText,
    required this.rightText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<WalletThemeProvider>(
      builder: (context, provider, child) => SizedBox(
        width: double.infinity,
        child: Row(
          children: [
            Expanded(
              child: Text(
                leftText,
                style:
                    EZCTitleMediumTextStyle(color: provider.themeMode.text60),
              ),
            ),
            Expanded(
              child: Text(
                rightText,
                style: EZCTitleMediumTextStyle(color: provider.themeMode.text),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TransactionDetailVerticalText extends StatelessWidget {
  final String title;
  final String content;

  const _TransactionDetailVerticalText({
    Key? key,
    required this.title,
    required this.content,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<WalletThemeProvider>(
      builder: (context, provider, child) => SizedBox(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: EZCTitleMediumTextStyle(color: provider.themeMode.text60),
            ),
            const SizedBox(height: 8),
            Text(
              content.useCorrectEllipsis(),
              style: EZCTitleMediumTextStyle(color: provider.themeMode.text),
            ),
          ],
        ),
      ),
    );
  }
}

class _TransactionDetailIndexWidget extends StatelessWidget {
  final int index;

  const _TransactionDetailIndexWidget({
    Key? key,
    required this.index,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<WalletThemeProvider>(
      builder: (context, provider, child) => Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
            shape: BoxShape.circle, color: provider.themeMode.primary),
        child: Text(
          '#$index',
          style: EZCLabelSmallTextStyle(color: provider.themeMode.secondary),
        ),
      ),
    );
  }
}
