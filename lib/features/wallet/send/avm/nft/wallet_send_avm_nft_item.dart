import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wallet/features/nft/collectible/nft_collectible_item.dart';
import 'package:wallet/generated/assets.gen.dart';
import 'package:wallet/themes/colors.dart';
import 'package:wallet/themes/inputs.dart';
import 'package:wallet/themes/theme.dart';

class WalletSendAvmNftItemWidget extends StatefulWidget {
  final NftCollectibleItem item;

  const WalletSendAvmNftItemWidget({Key? key, required this.item})
      : super(key: key);

  @override
  State<WalletSendAvmNftItemWidget> createState() =>
      _WalletSendAvmNftItemWidgetState();
}

class _WalletSendAvmNftItemWidgetState
    extends State<WalletSendAvmNftItemWidget> {
  final _quantityController = TextEditingController(text: '1');

  @override
  Widget build(BuildContext context) {
    return Consumer<WalletThemeProvider>(
      builder: (context, provider, child) => SizedBox(
        width: 80,
        height: 135,
        child: Column(
          children: [
            Stack(
              children: [
                AspectRatio(
                  aspectRatio: 1,
                  child: CachedNetworkImage(
                    imageUrl: widget.item.url ?? '',
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
                            child: widget.item.type.icon,
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.topRight,
                  child: Padding(
                      padding: const EdgeInsets.all(4),
                      child: Assets.icons.icCloseCirclePrimary.svg()),
                ),
              ],
            ),
            const SizedBox(height: 4),
            EZCTextField(
              width: 80,
              height: 24,
              borderRadius: const BorderRadius.all(Radius.circular(4)),
              contentPadding: const EdgeInsets.all(0),
              controller: _quantityController,
              onChanged: (text) {
                widget.item.quantity = int.tryParse(text) ?? 1;
              },
            )
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _quantityController.dispose();
    super.dispose();
  }
}
