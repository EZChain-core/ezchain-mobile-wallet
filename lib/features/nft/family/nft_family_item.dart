//ignore: implementation_imports
import 'package:auto_route/src/router/auto_router_x.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wallet/ezc/sdk/apis/avm/utxos.dart';
import 'package:wallet/features/common/route/router.gr.dart';
import 'package:wallet/features/nft/collectible/nft_collectible_item.dart';
import 'package:wallet/generated/l10n.dart';
import 'package:wallet/themes/buttons.dart';
import 'package:wallet/themes/colors.dart';
import 'package:wallet/themes/theme.dart';
import 'package:wallet/themes/typography.dart';

class NftFamilyItem {
  final String id;
  final String name;
  final String symbol;
  final bool isMintable;
  final AvmUTXO? nftMintUTXO;
  final List<NftCollectibleItem> nftCollectibles;

  NftFamilyItem({
    required this.id,
    required this.name,
    required this.symbol,
    required this.isMintable,
    required this.nftMintUTXO,
    required this.nftCollectibles,
  });

  List<NftAvmCollectibleItem> get nftAvmCollectibles =>
      nftCollectibles.whereType<NftAvmCollectibleItem>().toList();
}

class NftFamilyItemWidget extends StatelessWidget {
  final NftFamilyItem item;

  const NftFamilyItemWidget({Key? key, required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<WalletThemeProvider>(
      builder: (context, provider, child) => Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                RichText(
                  text: TextSpan(
                    text: item.name,
                    style: EZCTitleLargeTextStyle(
                      color: provider.themeMode.text,
                    ),
                    children: [
                      TextSpan(
                        text: ' | ${item.symbol}',
                        style: EZCBodyLargeTextStyle(
                          color: provider.themeMode.text60,
                        ),
                      ),
                    ],
                  ),
                ),
                if (item.isMintable)
                  EZCMediumPrimaryOutlineButton(
                    width: 75,
                    height: 28,
                    text: Strings.current.nftMint,
                    onPressed: () =>
                        context.pushRoute(NftMintRoute(nftFamily: item)),
                  ),
              ],
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.only(top: 8, bottom: 12, left: 16, right: 16),
            child: Divider(
              height: 1,
              color: provider.themeMode.text10,
            ),
          ),
          item.nftCollectibles.isNotEmpty
              ? SizedBox(
                  height: 190,
                  child: ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    scrollDirection: Axis.horizontal,
                    itemCount: item.nftCollectibles.length,
                    itemBuilder: (_, index) => NftCollectibleItemWidget(
                      item: item.nftCollectibles[index],
                    ),
                    separatorBuilder: (_, index) => const SizedBox(width: 12),
                  ),
                )
              : Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(16)),
                      color: provider.themeMode.bg),
                  child: Text(
                    Strings.current.nftEmptyCollectibles,
                    style: EZCBodyLargeTextStyle(
                      color: provider.themeMode.text60,
                    ),
                  ),
                ),
        ],
      ),
    );
  }
}

class NftSelectFamilyItemWidget extends StatelessWidget {
  final NftFamilyItem item;

  const NftSelectFamilyItemWidget({Key? key, required this.item})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<WalletThemeProvider>(
      builder: (context, provider, child) => Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                RichText(
                  text: TextSpan(
                    text: item.name,
                    style: EZCTitleLargeTextStyle(
                      color: provider.themeMode.text,
                    ),
                    children: [
                      TextSpan(
                        text: ' | ${item.symbol}',
                        style: EZCBodyLargeTextStyle(
                          color: provider.themeMode.text60,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.only(top: 8, bottom: 12, left: 16, right: 16),
            child: Divider(
              height: 1,
              color: provider.themeMode.text10,
            ),
          ),
          item.nftAvmCollectibles.isNotEmpty
              ? SizedBox(
                  height: 100,
                  child: ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    scrollDirection: Axis.horizontal,
                    itemCount: item.nftAvmCollectibles.length,
                    itemBuilder: (_, index) => NftSelectCollectibleItemWidget(
                      item: item.nftAvmCollectibles[index],
                    ),
                    separatorBuilder: (_, index) => const SizedBox(width: 12),
                  ),
                )
              : Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(16)),
                      color: provider.themeMode.bg),
                  child: Text(
                    Strings.current.nftEmptyCollectibles,
                    style: EZCBodyLargeTextStyle(
                      color: provider.themeMode.text60,
                    ),
                  ),
                ),
        ],
      ),
    );
  }
}
