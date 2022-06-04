// ignore: implementation_imports
import 'package:auto_route/src/router/auto_router_x.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';
import 'package:wallet/features/nft/family/nft_family_item.dart';
import 'package:wallet/features/nft/nft_store.dart';
import 'package:wallet/generated/assets.gen.dart';
import 'package:wallet/generated/l10n.dart';
import 'package:wallet/themes/colors.dart';
import 'package:wallet/themes/theme.dart';
import 'package:wallet/themes/typography.dart';
import 'package:wallet/themes/widgets.dart';

class NftSelectDialog extends StatelessWidget {
  NftSelectDialog({Key? key}) : super(key: key);

  final _nftStore = NftStore();

  @override
  Widget build(BuildContext context) {
    return Consumer<WalletThemeProvider>(
      builder: (context, provider, child) => Dialog(
        insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 80),
        backgroundColor: Colors.transparent,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            GestureDetector(
              onTap: context.popRoute,
              child: Assets.icons.icCloseCircleOutlinePrimary.svg(),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: provider.themeMode.white,
                  borderRadius: const BorderRadius.all(Radius.circular(8)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 32),
                    Padding(
                      padding: const EdgeInsets.only(left: 16),
                      child: Text(
                        Strings.current.nftSelectCollectible,
                        style: EZCHeadlineSmallTextStyle(
                            color: provider.themeMode.text),
                      ),
                    ),
                    const SizedBox(height: 25),
                    Expanded(
                      child: Observer(
                        builder: (_) => _nftStore.nftAssets.isEmpty
                            ? Align(
                                alignment: Alignment.center,
                                child: EZCEmpty(
                                  img: Assets.images.imgNftFamilyEmpty
                                      .image(width: 109, height: 121),
                                  title: Strings.current.nftCollectiblesEmpty,
                                  des: Strings.current.nftCollectiblesEmptyDesc,
                                ),
                              )
                            : ListView.separated(
                                padding: const EdgeInsets.only(bottom: 20),
                                itemCount: _nftStore.nftAssets.length,
                                itemBuilder: (_, index) =>
                                    NftSelectFamilyItemWidget(
                                  item: _nftStore.nftAssets[index],
                                ),
                                separatorBuilder: (_, index) =>
                                    const SizedBox(height: 30),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
