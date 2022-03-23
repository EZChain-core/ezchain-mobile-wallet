// ignore: implementation_imports
import 'package:auto_route/src/router/auto_router_x.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';
import 'package:provider/provider.dart';
import 'package:wallet/features/common/ext/extensions.dart';
import 'package:wallet/features/nft/family/list/nft_family_collectible_item.dart';
import 'package:wallet/generated/l10n.dart';
import 'package:wallet/themes/buttons.dart';
import 'package:wallet/themes/colors.dart';
import 'package:wallet/themes/inputs.dart';
import 'package:wallet/themes/theme.dart';
import 'package:wallet/themes/typography.dart';
import 'package:wallet/themes/widgets.dart';

import 'nft_mint_store.dart';

class NftMintScreen extends StatelessWidget {
  final NftFamilyCollectibleItem nftFamily;

  NftMintScreen({Key? key, required this.nftFamily}) : super(key: key) {
    _nftMintStore.setNftMintUTXO(nftFamily.nftMintUTXO);
  }

  final NftMintStore _nftMintStore = NftMintStore();

  @override
  Widget build(BuildContext context) {
    return Consumer<WalletThemeProvider>(
      builder: (context, provider, child) => ReactionBuilder(
        builder: (context) {
          return autorun((_) {
            final error = _nftMintStore.error;
            if (error.isNotEmpty) {
              showSnackBar(error);
            }
          });
        },
        child: DefaultTabController(
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
                    child: SingleChildScrollView(
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
                                                color:
                                                    provider.themeMode.text60),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            nftFamily.name,
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
                                                color:
                                                    provider.themeMode.text60),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            nftFamily.symbol,
                                            style: EZCTitleLargeTextStyle(
                                                color: provider.themeMode.text),
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                                // const SizedBox(height: 12),
                                // Text(
                                //   Strings.current.nftCollectibles,
                                //   style: EZCTitleLargeTextStyle(
                                //       color:
                                //       provider.themeMode.text60),
                                // ),
                                // const SizedBox(height: 4),
                                // ListView(
                                //   children: [
                                //
                                //   ],
                                // ),
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
                          SizedBox(
                            height: 450,
                            child: TabBarView(
                              children: [
                                _NftMintGenericTab(nftMintStore: _nftMintStore),
                                _NftMintCustomTab(nftMintStore: _nftMintStore),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _NftMintGenericTab extends StatelessWidget {
  final NftMintStore nftMintStore;

  _NftMintGenericTab({Key? key, required this.nftMintStore}) : super(key: key);

  final _titleController = TextEditingController();
  final _imgUrlController = TextEditingController();
  final _desController = TextEditingController();
  final _quantityController = TextEditingController(text: '1');

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
              controller: _imgUrlController,
              inputType: TextInputType.url,
              maxLines: 1,
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
                    controller: _quantityController,
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
                      nftMintStore.fee,
                      style: EZCTitleLargeTextStyle(
                          color: provider.themeMode.text),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 24),
            Observer(
              builder: (_) => EZCMediumPrimaryButton(
                text: Strings.current.nftMint,
                width: 95,
                isLoading: nftMintStore.isLoading,
                onPressed: _onClickMint,
              ),
            ),
          ],
        ),
      ),
    );
  }

  _onClickMint() {
    final quantity = int.tryParse(_quantityController.text) ?? 1;
    nftMintStore.mintGeneric(
      _titleController.text,
      _imgUrlController.text,
      _desController.text,
      quantity,
    );
  }
}

class _NftMintCustomTab extends StatefulWidget {
  final NftMintStore nftMintStore;

  const _NftMintCustomTab({Key? key, required this.nftMintStore})
      : super(key: key);

  @override
  State<_NftMintCustomTab> createState() => _NftMintCustomTabState();
}

class _NftMintCustomTabState extends State<_NftMintCustomTab> {
  final _quantityController = TextEditingController(text: '1');
  final _payloadController = TextEditingController();

  MintCustomType _type = MintCustomType.utf8;

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
            Row(
              children: [
                Expanded(
                  child: RadioListTile(
                    title: Text(
                      Strings.current.nftUtf8,
                      style: EZCTitleLargeTextStyle(
                          color: provider.themeMode.text),
                    ),
                    value: MintCustomType.utf8,
                    onChanged: _onChangeMintCustomType,
                    groupValue: _type,
                    activeColor: provider.themeMode.primary,
                    contentPadding: const EdgeInsets.all(0),
                  ),
                ),
                Expanded(
                  child: RadioListTile(
                    title: Text(
                      Strings.current.nftUrl,
                      style: EZCTitleLargeTextStyle(
                          color: provider.themeMode.text),
                    ),
                    value: MintCustomType.url,
                    onChanged: _onChangeMintCustomType,
                    groupValue: _type,
                    activeColor: provider.themeMode.primary,
                    contentPadding: const EdgeInsets.all(0),
                  ),
                ),
                Expanded(
                  child: RadioListTile(
                    title: Text(
                      Strings.current.nftJson,
                      style: EZCTitleLargeTextStyle(
                          color: provider.themeMode.text),
                    ),
                    value: MintCustomType.json,
                    onChanged: _onChangeMintCustomType,
                    groupValue: _type,
                    activeColor: provider.themeMode.primary,
                    contentPadding: const EdgeInsets.all(0),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            if (_type == MintCustomType.utf8)
              EZCTextField(
                label: Strings.current.nftPayload,
                controller: _payloadController,
                maxLength: 1024,
                maxLines: 3,
              ),
            if (_type == MintCustomType.url)
              EZCTextField(
                label: Strings.current.nftUrl,
                controller: _payloadController,
                hint: Strings.current.nftHttps,
                maxLines: 1,
              ),
            if (_type == MintCustomType.json)
              EZCTextField(
                label: Strings.current.nftJsonPayload,
                controller: _payloadController,
                maxLength: 1024,
                hint: '{\n\n}',
                maxLines: 3,
                inputType: TextInputType.multiline,
                textInputAction: TextInputAction.newline,
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
                    controller: _quantityController,
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
                      widget.nftMintStore.fee,
                      style: EZCTitleLargeTextStyle(
                          color: provider.themeMode.text),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 24),
            Observer(
              builder: (_) => EZCMediumPrimaryButton(
                text: Strings.current.nftMint,
                width: 95,
                isLoading: widget.nftMintStore.isLoading,
                onPressed: _onClickMint,
              ),
            ),
          ],
        ),
      ),
    );
  }

  _onClickMint() {
    final quantity = int.tryParse(_quantityController.text) ?? 1;
    widget.nftMintStore.mintCustom(_type, _payloadController.text, quantity);
  }

  _onChangeMintCustomType(MintCustomType? value) {
    if (value != null) {
      setState(() {
        _type = value;
        _payloadController.text = '';
      });
    }
  }
}

enum MintCustomType { utf8, url, json }
