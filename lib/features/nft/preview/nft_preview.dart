//ignore: implementation_imports
import 'package:auto_route/src/router/auto_router_x.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wallet/features/common/route/router.gr.dart';
import 'package:wallet/features/nft/collectible/nft_collectible_item.dart';
import 'package:wallet/features/wallet/send/erc721/wallet_send_erc721.dart';
import 'package:wallet/generated/assets.gen.dart';
import 'package:wallet/generated/l10n.dart';
import 'package:wallet/themes/buttons.dart';
import 'package:wallet/themes/colors.dart';
import 'package:wallet/themes/theme.dart';
import 'package:wallet/themes/typography.dart';
import 'package:wallet/themes/widgets.dart';

class NftPreviewDialog extends StatelessWidget {
  final NftPreviewArgs args;

  const NftPreviewDialog({Key? key, required this.args}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<WalletThemeProvider>(
      builder: (context, provider, child) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.all(16),
        child: SizedBox(
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              GestureDetector(
                onTap: () {
                  context.popRoute();
                },
                child: Assets.icons.icCloseCircleOutlinePrimary.svg(),
              ),
              const SizedBox(height: 8),
              ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(8)),
                child: CachedNetworkImage(
                  imageUrl: args.nft.url ?? '',
                  placeholder: (context, url) => Align(
                    alignment: Alignment.center,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 40),
                      child: EZCLoading(
                        color: provider.themeMode.primary,
                        size: 60,
                        strokeWidth: 4,
                      ),
                    ),
                  ),
                  errorWidget: (context, url, error) => Container(
                    width: double.infinity,
                    height: 400,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: provider.themeMode.bg,
                      borderRadius: const BorderRadius.all(Radius.circular(8)),
                    ),
                    child: Text(
                      args.textWhenUrlLoadedError,
                      style: EZCBodyMediumTextStyle(
                          color: provider.themeMode.text70),
                    ),
                  ),
                ),
              ),
              if (args.isErc721Nft) ...[
                const SizedBox(height: 32),
                Align(
                  alignment: Alignment.center,
                  child: EZCMediumPrimaryButton(
                    width: 100,
                    text: Strings.current.sharedSend,
                    onPressed: () async {
                      await context.popRoute();
                      context.pushRoute(
                        WalletSendErc721Route(
                          args: WalletSendErc721Args(
                            args.erc721.erc721,
                            args.erc721.tokenId,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class NftPreviewArgs {
  final NftCollectibleItem nft;

  NftPreviewArgs(this.nft);

  bool get isErc721Nft => nft is NftErc721CollectibleItem;

  String get textWhenUrlLoadedError {
    if (isErc721Nft) {
      return nft.url ?? '';
    } else {
      return nft.payload ?? '';
    }
  }

  NftErc721CollectibleItem get erc721 => nft as NftErc721CollectibleItem;
}
