import 'package:auto_route/src/router/auto_router_x.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';
import 'package:wallet/features/cross/cross_store.dart';
import 'package:wallet/features/cross/transfer/cross_transfer_store.dart';
import 'package:wallet/generated/assets.gen.dart';
import 'package:wallet/generated/l10n.dart';
import 'package:wallet/themes/buttons.dart';
import 'package:wallet/themes/colors.dart';
import 'package:wallet/themes/theme.dart';
import 'package:wallet/themes/typography.dart';
import 'package:wallet/themes/widgets.dart';

class CrossTransferScreen extends StatelessWidget {
  final CrossTransferInfo crossTransferInfo;
  final CrossTransferStore _crossTransferStore = CrossTransferStore();

  CrossTransferScreen({Key? key, required this.crossTransferInfo}) : super(key: key) {
    _crossTransferStore.setCrossTransferInfo(crossTransferInfo);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<WalletThemeProvider>(
      builder: (context, provider, child) => Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: provider.themeMode.bg,
                    borderRadius: const BorderRadius.all(Radius.circular(16)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 16),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              Strings.current.sharedSource,
                              style: EZCTitleLargeTextStyle(
                                  color: provider.themeMode.text60),
                            ),
                            Text(
                              Strings.current.sharedBalance,
                              style: EZCTitleLargeTextStyle(
                                  color: provider.themeMode.text60),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 4),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              _crossTransferStore.sourceChain.nameTwo,
                              style: EZCBodyLargeTextStyle(
                                  color: provider.themeMode.text),
                            ),
                            Observer(
                              builder: (_) => Text(
                                _crossTransferStore.sourceBalance.toString(),
                                style: EZCBodyLargeTextStyle(
                                    color: provider.themeMode.text),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                      Padding(
                        padding: const EdgeInsets.only(left: 16),
                        child: Row(
                          children: [
                            Text(
                              Strings.current.sharedExport,
                              style: EZCTitleLargeTextStyle(
                                  color: provider.themeMode.text60),
                            ),
                            const SizedBox(width: 8),
                            Observer(
                              builder: (_) => _crossTransferStore.exportState.when(
                                loading: () => EZCLoading(
                                    color: provider.themeMode.text60,
                                    size: 12,
                                    strokeWidth: 2),
                                success: () =>
                                    Assets.icons.icTickCircleGreen.svg(),
                                error: (_) =>
                                    Assets.icons.icInfoCircleRed.svg(),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                            border:
                                Border.all(color: provider.themeMode.border),
                            color: provider.themeMode.white,
                            borderRadius:
                                const BorderRadius.all(Radius.circular(8))),
                        padding: const EdgeInsets.all(12),
                        margin: const EdgeInsets.symmetric(horizontal: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              Strings.current.crossId,
                              style: EZCTitleSmallTextStyle(
                                  color: provider.themeMode.text60),
                            ),
                            const SizedBox(height: 4),
                            Observer(
                              builder: (_) => Text(
                                _crossTransferStore.exportTxId,
                                style: EZCBodySmallTextStyle(
                                    color: provider.themeMode.text),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              Strings.current.crossStatus,
                              style: EZCTitleSmallTextStyle(
                                  color: provider.themeMode.text60),
                            ),
                            const SizedBox(height: 4),
                            Observer(
                              builder: (_) => Text(
                                _crossTransferStore.exportState.status(),
                                style: EZCBodySmallTextStyle(
                                    color: provider.themeMode.text),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      Stack(
                        children: [
                          Divider(
                            height: 48,
                            thickness: 1,
                            color: provider.themeMode.text10,
                          ),
                          Align(
                            alignment: Alignment.centerRight,
                            child: Container(
                              width: 48,
                              height: 48,
                              margin: const EdgeInsets.only(right: 16),
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                  color: provider.themeMode.white,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                      width: 1,
                                      color: provider.themeMode.text10)),
                              child: Assets.icons.icArrowDownBlack.svg(),
                            ),
                          )
                        ],
                      ),
                      const SizedBox(height: 12),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              Strings.current.sharedDestination,
                              style: EZCTitleLargeTextStyle(
                                  color: provider.themeMode.text60),
                            ),
                            Text(
                              Strings.current.sharedBalance,
                              style: EZCTitleLargeTextStyle(
                                  color: provider.themeMode.text60),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 4),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              _crossTransferStore.destinationChain.nameTwo,
                              style: EZCBodyLargeTextStyle(
                                  color: provider.themeMode.text),
                            ),
                            Observer(
                              builder: (_) => Text(
                                _crossTransferStore.destinationBalance.toString(),
                                style: EZCBodyLargeTextStyle(
                                    color: provider.themeMode.text),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                      Padding(
                        padding: const EdgeInsets.only(left: 16),
                        child: Row(
                          children: [
                            Text(
                              Strings.current.sharedImport,
                              style: EZCTitleLargeTextStyle(
                                  color: provider.themeMode.text60),
                            ),
                            const SizedBox(width: 8),
                            Observer(
                              builder: (_) => _crossTransferStore.importState.when(
                                loading: () => EZCLoading(
                                    color: provider.themeMode.text60,
                                    size: 12,
                                    strokeWidth: 2),
                                success: () =>
                                    Assets.icons.icTickCircleGreen.svg(),
                                error: (_) =>
                                    Assets.icons.icInfoCircleRed.svg(),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                            border:
                                Border.all(color: provider.themeMode.border),
                            color: provider.themeMode.white,
                            borderRadius:
                                const BorderRadius.all(Radius.circular(8))),
                        padding: const EdgeInsets.all(12),
                        margin: const EdgeInsets.symmetric(horizontal: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              Strings.current.crossId,
                              style: EZCTitleSmallTextStyle(
                                  color: provider.themeMode.text60),
                            ),
                            const SizedBox(height: 4),
                            Observer(
                              builder: (_) => Text(
                                _crossTransferStore.importTxId,
                                style: EZCBodySmallTextStyle(
                                    color: provider.themeMode.text),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              Strings.current.crossStatus,
                              style: EZCTitleSmallTextStyle(
                                  color: provider.themeMode.text60),
                            ),
                            const SizedBox(height: 4),
                            Observer(
                              builder: (_) => Text(
                                _crossTransferStore.importState.status(),
                                style: EZCBodySmallTextStyle(
                                    color: provider.themeMode.text),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
                Observer(
                  builder: (_) => _crossTransferStore.transferringState.when(
                    loading: () => Column(
                      children: [
                        const SizedBox(height: 40),
                        Text(
                          Strings.current.crossTransferring,
                          style: EZCHeadlineSmallTextStyle(
                              color: provider.themeMode.text),
                        ),
                      ],
                    ),
                    success: () => Column(
                      children: [
                        const SizedBox(height: 16),
                        Text(
                          Strings.current.crossTransferCompleted,
                          style: EZCHeadlineSmallTextStyle(
                              color: provider.themeMode.text),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          Strings.current.crossTransferCompletedDes,
                          textAlign: TextAlign.center,
                          style: EZCBodyMediumTextStyle(
                              color: provider.themeMode.stateSuccess),
                        ),
                        const SizedBox(height: 8),
                        EZCMediumSuccessButton(
                          text: Strings.current.sharedStartAgain,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 64,
                            vertical: 8,
                          ),
                          onPressed: () {
                            context.router.pop<bool>(true);
                          },
                        )
                      ],
                    ),
                    error: (_) => Column(
                      children: [
                        const SizedBox(height: 16),
                        Text(
                          Strings.current.crossTransferIncomplete,
                          style: EZCHeadlineSmallTextStyle(
                              color: provider.themeMode.text),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          Strings.current.crossTransferWrong,
                          textAlign: TextAlign.center,
                          style: EZCBodyMediumTextStyle(
                              color: provider.themeMode.stateDanger),
                        ),
                        const SizedBox(height: 8),
                        EZCMediumPrimaryButton(
                          text: Strings.current.sharedStartAgain,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 64,
                            vertical: 8,
                          ),
                          onPressed: () async {
                            await context.router.pop<bool>(true);
                          },
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CrossTransferInfo {
  final CrossChainType sourceChain;
  final CrossChainType destinationChain;
  final Decimal amount;

  CrossTransferInfo(this.sourceChain, this.destinationChain, this.amount);
}
