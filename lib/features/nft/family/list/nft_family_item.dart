// ignore: implementation_imports
import 'package:auto_route/src/router/auto_router_x.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wallet/common/router.gr.dart';
import 'package:wallet/ezc/sdk/apis/avm/utxos.dart';
import 'package:wallet/generated/assets.gen.dart';
import 'package:wallet/generated/l10n.dart';
import 'package:wallet/themes/colors.dart';
import 'package:wallet/themes/theme.dart';
import 'package:wallet/themes/typography.dart';

class NftFamilyItem {
  final String id;
  final String name;
  final String symbol;
  final int groupId;
  final String? imageUrl;
  final AvmUTXO nftMintUTXO;

  NftFamilyItem({
    required this.id,
    required this.name,
    required this.symbol,
    required this.groupId,
    required this.nftMintUTXO,
    this.imageUrl,
  });
}

class NftFamilyItemWidget extends StatelessWidget {
  final NftFamilyItem item;

  const NftFamilyItemWidget({Key? key, required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<WalletThemeProvider>(
      builder: (context, provider, child) => InkWell(
        // onTap: () => context.pushRoute(NftMintRoute(nftFamily: item)),
        child: Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(8)),
            color: provider.themeMode.bg,
          ),
          child: Column(
            children: [
              Stack(
                children: [
                  AspectRatio(
                    aspectRatio: 1,
                    child: CachedNetworkImage(
                      imageUrl: item.imageUrl ?? "",
                      imageBuilder: (context, imageProvider) => Container(
                        decoration: BoxDecoration(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(8)),
                          image: DecorationImage(
                              image: imageProvider, fit: BoxFit.cover),
                        ),
                      ),
                      placeholder: (context, url) => Container(
                        decoration: BoxDecoration(
                          color: provider.themeMode.text30,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(8)),
                        ),
                      ),
                      errorWidget: (context, url, error) => Container(
                        decoration: BoxDecoration(
                          color: provider.themeMode.text30,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(8)),
                        ),
                      ),
                    ),
                  ),
                  AspectRatio(
                    aspectRatio: 1,
                    child: Align(
                      alignment: Alignment.center,
                      child: Assets.icons.icPlusCircle.svg(),
                    ),
                  )
                ],
              ),
              const SizedBox(height: 8),
              Text(
                item.name,
                style: EZCTitleLargeTextStyle(color: provider.themeMode.text),
              ),
              Text(
                item.symbol,
                style: EZCTitleSmallTextStyle(color: provider.themeMode.text70),
              ),
              const SizedBox(height: 4),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(12)),
                  border: Border.all(color: provider.themeMode.text60),
                ),
                child: Text(
                  Strings.current.nftItems(item.groupId),
                  style:
                      EZCTitleSmallTextStyle(color: provider.themeMode.text70),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class NftFamilyHorizontalItemWidget extends StatelessWidget {
  final NftFamilyItem item;

  const NftFamilyHorizontalItemWidget({Key? key, required this.item})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<WalletThemeProvider>(
      builder: (context, provider, child) => InkWell(
        // onTap: () => context.pushRoute(NftMintRoute(nftFamily: item)),
        child: Container(
          width: 132,
          height: 205,
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(8)),
            color: provider.themeMode.bg,
          ),
          child: Column(
            children: [
              Stack(
                children: [
                  AspectRatio(
                    aspectRatio: 1,
                    child: CachedNetworkImage(
                      imageUrl: item.imageUrl ?? "",
                      imageBuilder: (context, imageProvider) => Container(
                        decoration: BoxDecoration(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(8)),
                          image: DecorationImage(
                              image: imageProvider, fit: BoxFit.cover),
                        ),
                      ),
                      placeholder: (context, url) => Container(
                        decoration: BoxDecoration(
                          color: provider.themeMode.text30,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(8)),
                        ),
                      ),
                      errorWidget: (context, url, error) => Container(
                        decoration: BoxDecoration(
                          color: provider.themeMode.text30,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(8)),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                item.name,
                style: EZCTitleSmallTextStyle(color: provider.themeMode.text),
              ),
              Text(
                item.symbol,
                style: EZCLabelSmallTextStyle(color: provider.themeMode.text70),
              ),
              const SizedBox(height: 4),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(12)),
                  border: Border.all(color: provider.themeMode.text60),
                ),
                child: Text(
                  Strings.current.nftItems(item.groupId),
                  style:
                      EZCTitleSmallTextStyle(color: provider.themeMode.text70),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
