// ignore: implementation_imports
import 'package:auto_route/src/router/auto_router_x.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';
import 'package:wallet/generated/l10n.dart';
import 'package:wallet/themes/theme.dart';
import 'package:wallet/themes/widgets.dart';

import 'nft_family_collectible_item.dart';
import 'nft_family_collectible_store.dart';

class NftFamilyCollectibleScreen extends StatelessWidget {
  NftFamilyCollectibleScreen({Key? key}) : super(key: key);

  final NftFamilyCollectibleStore _nftFamilyCollectibleStore =
      NftFamilyCollectibleStore();

  @override
  Widget build(BuildContext context) {
    return Consumer<WalletThemeProvider>(
      builder: (context, provider, child) => Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              EZCAppBar(
                title: Strings.current.nftMintCollectible,
                onPressed: context.popRoute,
              ),
              Expanded(
                child: Observer(builder: (_) {
                  if (_nftFamilyCollectibleStore.nftAssets.isEmpty) {
                    return const SizedBox.shrink();
                  }
                  return GridView.builder(
                    padding: const EdgeInsets.all(16),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      mainAxisExtent: 255,
                    ),
                    itemCount: _nftFamilyCollectibleStore.nftAssets.length,
                    itemBuilder: (_, index) => NftFamilyCollectibleItemWidget(
                        item: _nftFamilyCollectibleStore.nftAssets[index]),
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
