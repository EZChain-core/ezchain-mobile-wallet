// ignore: implementation_imports
import 'package:auto_route/src/router/auto_router_x.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';
import 'package:wallet/generated/assets.gen.dart';
import 'package:wallet/generated/l10n.dart';
import 'package:wallet/themes/theme.dart';
import 'package:wallet/themes/widgets.dart';

import '../../nft_store.dart';
import 'nft_family_item.dart';

class NftFamilyCollectibleScreen extends StatelessWidget {
  NftFamilyCollectibleScreen({Key? key}) : super(key: key);

  final _nftStore = NftStore();

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
                  if (_nftStore.nftAssets.isEmpty) {
                    return Align(
                      alignment: Alignment.center,
                      child: EZCEmpty(
                        img: Assets.images.imgNftFamilyEmpty
                            .image(width: 109, height: 121),
                        title: Strings.current.nftCollectiblesEmpty,
                        des: Strings.current.nftCollectiblesEmptyDesc,
                      ),
                    );
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
                    itemCount: _nftStore.nftAssets.length,
                    itemBuilder: (_, index) => NftFamilyItemWidget(
                      item: _nftStore.nftAssets[index],
                    ),
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
