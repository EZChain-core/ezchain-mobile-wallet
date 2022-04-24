import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wallet/common/router.dart';
import 'package:wallet/features/nft/preview/nft_preview.dart';
import 'package:wallet/generated/assets.gen.dart';
import 'package:wallet/generated/l10n.dart';
import 'package:wallet/themes/colors.dart';
import 'package:wallet/themes/theme.dart';
import 'package:wallet/themes/typography.dart';

class NftCollectibleItem {
  final int count;
  final NftPayloadType type;
  final String? title;
  final String? url;
  final String? payload;

  NftCollectibleItem(this.count, this.type, this.title, this.url, this.payload);
}

enum NftPayloadType { json, utf8, url }

extension NftPayloadTypeExtension on NftPayloadType {
  String get name {
    return ["JSON", "UTF8", "URL"][index];
  }

  Widget get icon {
    return [
      Assets.icons.icCodeOutlineWhite.svg(),
      Assets.icons.icDocumentOutlineWhite.svg(),
      Assets.icons.icLinkOutlineWhite.svg(),
    ][index];
  }
}

NftPayloadType getNftPayloadType(String type) {
  return NftPayloadType.values.firstWhere((element) => element.name == type,
      orElse: () => NftPayloadType.utf8);
}

class NftCollectibleItemWidget extends StatelessWidget {
  final NftCollectibleItem item;

  const NftCollectibleItemWidget({Key? key, required this.item})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<WalletThemeProvider>(
      builder: (context, provider, child) => Container(
        width: 128,
        height: 190,
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
                    imageUrl: item.url ?? '',
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
                        color: provider.themeMode.secondary,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(8)),
                      ),
                      child: Stack(
                        children: [
                          Align(
                            alignment: Alignment.center,
                            child: item.type.icon,
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.topRight,
                  child: InkWell(
                    onTap: onClickPreview,
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: Assets.icons.icEyeOutlinePrimary.svg(),
                    ),
                  ),
                )
              ],
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if (item.title != null) ...[
                    Text(
                      item.title!,
                      style: EZCTitleSmallTextStyle(
                        color: provider.themeMode.text,
                      ),
                      maxLines: 1,
                      softWrap: false,
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                    )
                  ],
                  const SizedBox(height: 8),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(12)),
                      border: Border.all(color: provider.themeMode.text60),
                    ),
                    child: Text(
                      Strings.current.nftItems(item.count),
                      style: EZCTitleSmallTextStyle(
                        color: provider.themeMode.text70,
                      ),
                      maxLines: 1,
                    ),
                  ),
                  const SizedBox(height: 4),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  onClickPreview() {
    if (walletContext != null) {
      showDialog(
        context: walletContext!,
        builder: (_) => NftPreviewDialog(url: item.url, payload: item.payload),
      );
    }
  }
}
