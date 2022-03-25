import 'package:auto_route/auto_route.dart';

// ignore: implementation_imports
import 'package:auto_route/src/router/auto_router_x.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wallet/ezc/wallet/explorer/cchain/types.dart';
import 'package:wallet/features/transaction/detail_c/transaction_c_detail_store.dart';
import 'package:wallet/generated/assets.gen.dart';
import 'package:wallet/generated/l10n.dart';
import 'package:wallet/themes/colors.dart';
import 'package:wallet/themes/theme.dart';
import 'package:wallet/themes/typography.dart';
import 'package:wallet/themes/widgets.dart';

class TransactionCDetailScreen extends StatelessWidget {
  final String txHash;
  final String? contractAddress;

  final _transactionCDetailStore = TransactionCDetailStore();

  TransactionCDetailScreen(
      {Key? key, required this.txHash, this.contractAddress})
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
                  txHash,
                  contractAddress,
                ),
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
                    return Expanded(
                      child: Align(
                        alignment: Alignment.center,
                        child: EZCLoading(
                          color: provider.themeMode.secondary,
                          size: 40,
                          strokeWidth: 4,
                        ),
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

class _TransactionCDetailInfoWidget extends StatelessWidget {
  final TransactionCChainViewData transaction;

  final _divider = _TransactionCDetailInfoDivider();

  _TransactionCDetailInfoWidget({Key? key, required this.transaction})
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
            _divider,
            Row(
              children: [
                Expanded(
                  child: Text(
                    Strings.current.sharedResult,
                    style: EZCTitleMediumTextStyle(
                      color: provider.themeMode.text60,
                    ),
                  ),
                ),
                if (transaction.result) ...[
                  Assets.icons.icTickCircleGreen.svg(width: 16, height: 16),
                  const SizedBox(width: 4),
                  Text(
                    Strings.current.sharedSuccess,
                    style: EZCBodyMediumTextStyle(
                      color: provider.themeMode.stateSuccess,
                    ),
                  )
                ] else ...[
                  Assets.icons.icInfoCircleRed.svg(width: 16, height: 16),
                  const SizedBox(width: 4),
                  Text(
                    Strings.current.sharedFail,
                    style: EZCBodyMediumTextStyle(
                      color: provider.themeMode.stateDanger,
                    ),
                  )
                ],
              ],
            ),
            if (transaction.status != null) ...[
              _divider,
              Row(
                children: [
                  Expanded(
                    child: Text(
                      Strings.current.sharedStatus,
                      style: EZCTitleMediumTextStyle(
                        color: provider.themeMode.text60,
                      ),
                    ),
                  ),
                  _TransactionCDetailStatusLabel(
                    confirmed: transaction.status!,
                  )
                ],
              ),
            ],
            _divider,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  Strings.current.sharedBlock,
                  style:
                      EZCTitleMediumTextStyle(color: provider.themeMode.text60),
                ),
                Text(
                  transaction.block,
                  style: EZCTitleMediumTextStyle(color: provider.themeMode.text)
                      .copyWith(decoration: TextDecoration.underline),
                )
              ],
            ),
            _divider,
            _TransactionCDetailVerticalText(
                title: Strings.current.sharedFrom, content: transaction.from),
            _divider,
            _TransactionCDetailVerticalText(
                title: Strings.current.sharedTo, content: transaction.to),
            _divider,
            _TransactionCDetailHorizontalText(
                leftText: Strings.current.sharedAmount,
                rightText: transaction.amount),
            _divider,
            _TransactionCDetailHorizontalText(
                leftText: Strings.current.sharedFee,
                rightText: transaction.fee),
            _divider,
            _TransactionCDetailHorizontalText(
                leftText: Strings.current.sharedGasPrice,
                rightText: transaction.gasPrice),
            _divider,
            _TransactionCDetailHorizontalText(
                leftText: Strings.current.sharedGasLimit,
                rightText: transaction.gasLimit),
            _divider,
            _TransactionCDetailHorizontalText(
                leftText: Strings.current.transactionsGasUsedByTransaction,
                rightText: transaction.gasUsed),
            _divider,
            _TransactionCDetailHorizontalText(
                leftText: Strings.current.sharedNonce,
                rightText: transaction.nonce),
          ],
        ),
      ),
    );
  }
}

class _TransactionCDetailHorizontalText extends StatelessWidget {
  final String leftText;
  final String rightText;

  const _TransactionCDetailHorizontalText({
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
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              leftText,
              style: EZCTitleMediumTextStyle(color: provider.themeMode.text60),
            ),
            Text(
              rightText,
              style: EZCTitleMediumTextStyle(color: provider.themeMode.text),
            ),
          ],
        ),
      ),
    );
  }
}

class _TransactionCDetailVerticalText extends StatelessWidget {
  final String title;
  final String content;

  const _TransactionCDetailVerticalText({
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
              content,
              style: EZCTitleMediumTextStyle(color: provider.themeMode.text),
            ),
          ],
        ),
      ),
    );
  }
}

class _TransactionCDetailInfoDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<WalletThemeProvider>(
      builder: (context, provider, child) => Divider(
        color: provider.themeMode.text10,
        height: 25,
      ),
    );
  }
}

class _TransactionCDetailStatusLabel extends StatelessWidget {
  final bool confirmed;

  const _TransactionCDetailStatusLabel({Key? key, required this.confirmed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<WalletThemeProvider>(
      builder: (context, provider, child) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
        decoration: BoxDecoration(
            color: confirmed
                ? provider.themeMode.aquaGreen
                : provider.themeMode.wispPink,
            borderRadius: const BorderRadius.all(Radius.circular(10)),
            border: Border.all(
                color: confirmed
                    ? provider.themeMode.stateSuccess
                    : provider.themeMode.stateDanger)),
        child: Text(
          confirmed
              ? Strings.current.sharedConfirmed
              : Strings.current.sharedNotConfirm,
          style: EZCTitleSmallTextStyle(
              color: confirmed
                  ? provider.themeMode.stateSuccess
                  : provider.themeMode.stateDanger),
        ),
      ),
    );
  }
}
