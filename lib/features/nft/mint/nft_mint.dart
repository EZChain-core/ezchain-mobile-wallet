// ignore: implementation_imports
import 'package:auto_route/src/router/auto_router_x.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wallet/generated/l10n.dart';
import 'package:wallet/themes/buttons.dart';
import 'package:wallet/themes/colors.dart';
import 'package:wallet/themes/inputs.dart';
import 'package:wallet/themes/theme.dart';
import 'package:wallet/themes/typography.dart';
import 'package:wallet/themes/widgets.dart';

import 'nft_mint_store.dart';

class NftMintScreen extends StatelessWidget {
  NftMintScreen({Key? key}) : super(key: key);

  final NftMintStore _nftMintStore = NftMintStore();

  @override
  Widget build(BuildContext context) {
    return Consumer<WalletThemeProvider>(
      builder: (context, provider, child) => DefaultTabController(
        length: 2,
        child: Scaffold(
          body: SafeArea(
            child: Column(
              children: [
                EZCAppBar(
                  title: Strings.current.nftMintCollectible,
                  onPressed: context.popRoute,
                ),
                Expanded(
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(16),
                        margin: const EdgeInsets.only(
                            top: 24, left: 16, right: 16, bottom: 16),
                        decoration: BoxDecoration(
                          color: provider.themeMode.bg,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(8)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        Strings.current.nftFamilyName,
                                        style: EZCTitleLargeTextStyle(
                                            color: provider.themeMode.text60),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        'ABC',
                                        style: EZCTitleLargeTextStyle(
                                            color: provider.themeMode.text),
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        Strings.current.nftSymbol,
                                        style: EZCTitleLargeTextStyle(
                                            color: provider.themeMode.text60),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        'ABC',
                                        style: EZCTitleLargeTextStyle(
                                            color: provider.themeMode.text),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                      Container(
                        height: 40,
                        padding: const EdgeInsets.all(4),
                        margin: const EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(
                          color: provider.themeMode.secondary10,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: TabBar(
                          indicator: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            color: provider.themeMode.secondary,
                          ),
                          labelStyle: EZCTitleLargeTextStyle(
                              color: provider.themeMode.primary),
                          labelColor: provider.themeMode.primary,
                          unselectedLabelStyle: EZCTitleLargeTextStyle(
                              color: provider.themeMode.text40),
                          unselectedLabelColor: provider.themeMode.text40,
                          tabs: [
                            Tab(text: Strings.current.sharedGeneric),
                            Tab(text: Strings.current.sharedCustom),
                          ],
                        ),
                      ),
                      Expanded(
                        child: TabBarView(
                          children: [
                            _NftMintGenericTab(),
                            _NftMintGenericTab(),
                          ],
                        ),
                      ),
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

class _NftMintGenericTab extends StatelessWidget {
  final _titleController = TextEditingController();
  final _desController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Consumer<WalletThemeProvider>(
      builder: (context, provider, child) => Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            EZCTextField(
              label: Strings.current.sharedTitle,
              hint: Strings.current.nftChooseTitle,
              controller: _titleController,
            ),
            const SizedBox(height: 16),
            EZCTextField(
              label: Strings.current.nftImageUrl,
              hint: Strings.current.nftHttps,
              controller: _titleController,
              inputType: TextInputType.url,
            ),
            const SizedBox(height: 16),
            EZCTextField(
              label: Strings.current.sharedDescription,
              hint: Strings.current.nftAboutCollectible,
              controller: _desController,
            ),
            const SizedBox(height: 16),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 112,
                  child: EZCTextField(
                    label: Strings.current.sharedQuantity,
                    hint: '0',
                    inputType: TextInputType.number,
                    controller: _desController,
                  ),
                ),
                const SizedBox(width: 24),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      Strings.current.sharedFee,
                      style: EZCTitleLargeTextStyle(
                          color: provider.themeMode.text60),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      '0.02 EZC',
                      style: EZCTitleLargeTextStyle(
                          color: provider.themeMode.text),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 24),
            EZCMediumPrimaryButton(
              text: Strings.current.nftMint,
              width: 95,
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}

class _NftMintCustomTab extends StatefulWidget {
  @override
  State<_NftMintCustomTab> createState() => _NftMintCustomTabState();
}

class _NftMintCustomTabState extends State<_NftMintCustomTab> {
  final _titleController = TextEditingController();

  final _desController = TextEditingController();

  final MintCustom _type = MintCustom.utf8;

  @override
  Widget build(BuildContext context) {
    return Consumer<WalletThemeProvider>(
      builder: (context, provider, child) => Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              Strings.current.sharedType,
              style: EZCTitleLargeTextStyle(color: provider.themeMode.text60),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                ListTile(
                  title: Text(
                    Strings.current.nftUtf8,
                    style:
                        EZCTitleLargeTextStyle(color: provider.themeMode.text),
                  ),
                  leading: Radio(value: MintCustom.utf8, groupValue: _type, onChanged: (value) {
                    setState(() {
                      // _type = value;
                    });
                  }),
                ),
              ],
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 112,
                  child: EZCTextField(
                    label: Strings.current.sharedQuantity,
                    hint: '0',
                    inputType: TextInputType.number,
                    controller: _desController,
                  ),
                ),
                const SizedBox(width: 24),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      Strings.current.sharedFee,
                      style: EZCTitleLargeTextStyle(
                          color: provider.themeMode.text60),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      '0.02 EZC',
                      style: EZCTitleLargeTextStyle(
                          color: provider.themeMode.text),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 24),
            EZCMediumPrimaryButton(
              text: Strings.current.nftMint,
              width: 95,
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}

enum MintCustom {utf8, url, json}
