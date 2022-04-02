// ignore: implementation_imports
import 'package:auto_route/src/router/auto_router_x.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';
import 'package:wallet/common/router.gr.dart';
import 'package:wallet/generated/assets.gen.dart';
import 'package:wallet/generated/l10n.dart';
import 'package:wallet/themes/buttons.dart';
import 'package:wallet/themes/colors.dart';
import 'package:wallet/themes/theme.dart';
import 'package:wallet/themes/typography.dart';
import 'package:wallet/themes/widgets.dart';

import 'family/list/nft_family_item.dart';
import 'nft_store.dart';

class NftScreen extends StatelessWidget {
  NftScreen({Key? key}) : super(key: key);

  final _nftStore = NftStore();

  @override
  Widget build(BuildContext context) {
    return Consumer<WalletThemeProvider>(
      builder: (context, provider, child) => Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  Strings.current.nftCollectibles,
                  style:
                      EZCHeadlineSmallTextStyle(color: provider.themeMode.text),
                ),
                const SizedBox(height: 13),
                Observer(builder: (_) {
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
                  return SizedBox(
                    height: 205,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: _nftStore.nftAssets.length,
                      itemBuilder: (_, index) => NftFamilyHorizontalItemWidget(
                        item: _nftStore.nftAssets[index],
                      ),
                      separatorBuilder: (_, index) => const SizedBox(width: 10),
                    ),
                  );
                }),
                const SizedBox(height: 21),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: provider.themeMode.bg,
                    borderRadius: const BorderRadius.all(Radius.circular(16)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        Strings.current.nftNewFamily,
                        style: EZCTitleLargeTextStyle(
                            color: provider.themeMode.text),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        Strings.current.nftNewFamilyDesc,
                        style: EZCBodyLargeTextStyle(
                            color: provider.themeMode.text70),
                      ),
                      const SizedBox(height: 24),
                      EZCMediumPrimaryButton(
                        width: 130,
                        text: Strings.current.nftNewFamily,
                        enabled: true,
                        onPressed: () {
                          context.pushRoute(NftFamilyCreateRoute());
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: provider.themeMode.bg,
                    borderRadius: const BorderRadius.all(Radius.circular(16)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        Strings.current.nftMintCollectible,
                        style: EZCTitleLargeTextStyle(
                            color: provider.themeMode.text),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        Strings.current.nftMintCollectibleDesc,
                        style: EZCBodyLargeTextStyle(
                            color: provider.themeMode.text70),
                      ),
                      const SizedBox(height: 24),
                      EZCMediumPrimaryButton(
                        width: 130,
                        text: Strings.current.nftMint,
                        enabled: true,
                        onPressed: () =>
                            context.pushRoute(NftFamilyCollectibleRoute()),
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
