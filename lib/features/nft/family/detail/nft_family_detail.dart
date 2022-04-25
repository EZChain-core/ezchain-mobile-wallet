// ignore: implementation_imports
import 'package:auto_route/src/router/auto_router_x.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wallet/features/common/route/router.gr.dart';
import 'package:wallet/generated/l10n.dart';
import 'package:wallet/themes/buttons.dart';
import 'package:wallet/themes/colors.dart';
import 'package:wallet/themes/theme.dart';
import 'package:wallet/themes/typography.dart';
import 'package:wallet/themes/widgets.dart';

class NftFamilyDetailScreen extends StatelessWidget {
  final NftFamilyDetailArgs args;

  const NftFamilyDetailScreen({Key? key, required this.args}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<WalletThemeProvider>(
      builder: (context, provider, child) => Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              EZCAppBar(
                title: Strings.current.nftNewFamily,
                onPressed: context.popRoute,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 8),
                      Text(
                        Strings.current.nftTxId,
                        style: EZCTitleLargeTextStyle(
                            color: provider.themeMode.text),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        args.txId,
                        style: EZCBodySmallTextStyle(
                            color: provider.themeMode.text70),
                      ),
                      Divider(
                        height: 33,
                        color: provider.themeMode.text10,
                      ),
                      Text(
                        Strings.current.nftStartDate,
                        style: EZCTitleLargeTextStyle(
                            color: provider.themeMode.text),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        Strings.current.nftStartDateDesc,
                        style: EZCBodySmallTextStyle(
                            color: provider.themeMode.text70),
                      ),
                      Divider(
                        height: 33,
                        color: provider.themeMode.text10,
                      ),
                      Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  Strings.current.nftFamilyName,
                                  style: EZCTitleLargeTextStyle(
                                      color: provider.themeMode.text),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  args.familyName,
                                  style: EZCBodySmallTextStyle(
                                      color: provider.themeMode.text70),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  Strings.current.nftSymbol,
                                  style: EZCTitleLargeTextStyle(
                                      color: provider.themeMode.text),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  args.symbol,
                                  style: EZCBodySmallTextStyle(
                                      color: provider.themeMode.text70),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Divider(
                        height: 33,
                        color: provider.themeMode.text10,
                      ),
                      Text(
                        Strings.current.nftNumberOfGroups,
                        style: EZCTitleLargeTextStyle(
                            color: provider.themeMode.text),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${args.numberOfGroup}',
                        style: EZCBodySmallTextStyle(
                            color: provider.themeMode.text70),
                      ),
                      const Spacer(),
                      Align(
                        alignment: Alignment.center,
                        child: EZCMediumSuccessButton(
                          text: Strings.current.nftBackMyNFT,
                          width: 223,
                          onPressed: () => context.router
                              .replaceAll([const DashboardRoute()]),
                        ),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class NftFamilyDetailArgs {
  final String txId;
  final String familyName;
  final String symbol;
  final int numberOfGroup;

  NftFamilyDetailArgs(
      this.txId, this.familyName, this.symbol, this.numberOfGroup);
}
