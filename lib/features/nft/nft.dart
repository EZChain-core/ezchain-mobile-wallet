// ignore: implementation_imports
import 'package:auto_route/src/router/auto_router_x.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';
import 'package:wallet/features/common/route/router.gr.dart';
import 'package:wallet/features/nft/family/nft_family_item.dart';
import 'package:wallet/features/nft/nft_store.dart';
import 'package:wallet/generated/assets.gen.dart';
import 'package:wallet/generated/l10n.dart';
import 'package:wallet/themes/buttons.dart';
import 'package:wallet/themes/colors.dart';
import 'package:wallet/themes/inputs.dart';
import 'package:wallet/themes/theme.dart';
import 'package:wallet/themes/typography.dart';
import 'package:wallet/themes/widgets.dart';

class NftScreen extends StatelessWidget {
  NftScreen({Key? key}) : super(key: key);

  final _nftStore = NftStore();

  @override
  Widget build(BuildContext context) {
    return Consumer<WalletThemeProvider>(
      builder: (context, provider, child) => Scaffold(
        body: SafeArea(
          child: Observer(
            builder: (_) => GestureDetector(
              onTap: () {
                FocusManager.instance.primaryFocus?.unfocus();
              },
              child: ListView.separated(
                padding: const EdgeInsets.only(bottom: 20),
                itemCount: _nftStore.nftAssetsResult.length + 1,
                itemBuilder: (_, index) {
                  if (index == 0) {
                    return Column(
                      children: [
                        _NftHeader(),
                        if (_nftStore.nftAssets.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 16, right: 16, top: 12),
                            child: EZCSearchTextField(
                              hint: Strings.current.nftSearchHint,
                              onChanged: (text) {
                                _nftStore.keySearch = text;
                              },
                            ),
                          ),
                        if (_nftStore.nftAssetsResult.isEmpty)
                          Align(
                            alignment: Alignment.center,
                            child: EZCEmpty(
                              img: Assets.images.imgNftFamilyEmpty
                                  .image(width: 109, height: 121),
                              title: Strings.current.nftCollectiblesEmpty,
                              des: Strings.current.nftCollectiblesEmptyDesc,
                            ),
                          ),
                      ],
                    );
                  }
                  return NftFamilyItemWidget(
                    item: _nftStore.nftAssetsResult[index - 1],
                  );
                },
                separatorBuilder: (_, index) => const SizedBox(height: 30),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _NftHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<WalletThemeProvider>(
      builder: (context, provider, child) => Padding(
        padding: const EdgeInsets.only(left: 16, right: 16, top: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
                    style:
                        EZCTitleLargeTextStyle(color: provider.themeMode.text),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    Strings.current.nftNewFamilyDesc,
                    style:
                        EZCBodyLargeTextStyle(color: provider.themeMode.text70),
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
            const SizedBox(height: 16),
            Text(
              Strings.current.nftCollectibles,
              style: EZCHeadlineSmallTextStyle(color: provider.themeMode.text),
            ),
          ],
        ),
      ),
    );
  }
}
