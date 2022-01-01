import 'package:auto_route/src/router/auto_router_x.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';
import 'package:wallet/features/cross/transfer/cross_transfer_store.dart';
import 'package:wallet/generated/assets.gen.dart';
import 'package:wallet/generated/l10n.dart';
import 'package:wallet/themes/buttons.dart';
import 'package:wallet/themes/colors.dart';
import 'package:wallet/themes/theme.dart';
import 'package:wallet/themes/typography.dart';

class CrossTransferScreen extends StatelessWidget {
  const CrossTransferScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final crossTransferStore = CrossTransferStore();

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
                              style: ROITitleLargeTextStyle(
                                  color: provider.themeMode.text60),
                            ),
                            Text(
                              Strings.current.sharedBalance,
                              style: ROITitleLargeTextStyle(
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
                              'X Chain',
                              style: ROIBodyLargeTextStyle(
                                  color: provider.themeMode.text),
                            ),
                            Text(
                              '1000',
                              style: ROIBodyLargeTextStyle(
                                  color: provider.themeMode.text),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                      Padding(
                        padding: const EdgeInsets.only(left: 16),
                        child: Text(
                          Strings.current.sharedExport,
                          style: ROITitleLargeTextStyle(
                              color: provider.themeMode.text60),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Container(
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
                              style: ROITitleSmallTextStyle(
                                  color: provider.themeMode.text60),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '2Z5ozYCLDqxZqDAJggm9eSH8dNVfVdfhp4bJ4Y3DvZXzqobzm1',
                              style: ROIBodySmallTextStyle(
                                  color: provider.themeMode.text),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              Strings.current.crossStatus,
                              style: ROITitleSmallTextStyle(
                                  color: provider.themeMode.text60),
                            ),
                            const SizedBox(height: 4),
                            Observer(
                              builder: (_) => Text(
                                crossTransferStore.isSourceAccepted
                                    ? Strings.current.sharedAccepted
                                    : Strings.current.sharedProcessing,
                                style: ROIBodySmallTextStyle(
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
                              style: ROITitleLargeTextStyle(
                                  color: provider.themeMode.text60),
                            ),
                            Text(
                              Strings.current.sharedBalance,
                              style: ROITitleLargeTextStyle(
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
                              'X Chain',
                              style: ROIBodyLargeTextStyle(
                                  color: provider.themeMode.text),
                            ),
                            Text(
                              '1000',
                              style: ROIBodyLargeTextStyle(
                                  color: provider.themeMode.text),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                      Padding(
                        padding: const EdgeInsets.only(left: 16),
                        child: Text(
                          Strings.current.sharedImport,
                          style: ROITitleLargeTextStyle(
                              color: provider.themeMode.text60),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Container(
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
                              style: ROITitleSmallTextStyle(
                                  color: provider.themeMode.text60),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '2Z5ozYCLDqxZqDAJggm9eSH8dNVfVdfhp4bJ4Y3DvZXzqobzm1',
                              style: ROIBodySmallTextStyle(
                                  color: provider.themeMode.text),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              Strings.current.crossStatus,
                              style: ROITitleSmallTextStyle(
                                  color: provider.themeMode.text60),
                            ),
                            const SizedBox(height: 4),
                            Observer(
                              builder: (_) => Text(
                                crossTransferStore.isDestinationAccepted
                                    ? Strings.current.sharedAccepted
                                    : Strings.current.sharedProcessing,
                                style: ROIBodySmallTextStyle(
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
                  builder: (_) => Column(
                    children: [
                      if (!crossTransferStore.isTransferred) ...[
                        const SizedBox(height: 40),
                        Text(
                          Strings.current.crossTransferring,
                          style: ROIHeadlineSmallTextStyle(
                              color: provider.themeMode.text),
                        ),
                      ] else ...[
                        const SizedBox(height: 16),
                        Text(
                          Strings.current.crossTransferCompleted,
                          style: ROIHeadlineSmallTextStyle(
                              color: provider.themeMode.text),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          Strings.current.crossTransferCompletedDes,
                          textAlign: TextAlign.center,
                          style: ROIBodyMediumTextStyle(
                              color: provider.themeMode.stateSuccess),
                        ),
                        const SizedBox(height: 8),
                        ROIMediumSuccessButton(
                          text: Strings.current.sharedStartAgain,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 64,
                            vertical: 8,
                          ),
                          onPressed: () {
                            context.router.pop();
                          },
                        )
                      ],
                    ],
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
