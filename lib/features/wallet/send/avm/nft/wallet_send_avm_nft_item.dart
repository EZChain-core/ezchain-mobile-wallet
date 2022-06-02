import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wallet/features/nft/collectible/nft_collectible_item.dart';
import 'package:wallet/generated/assets.gen.dart';
import 'package:wallet/themes/colors.dart';
import 'package:wallet/themes/inputs.dart';
import 'package:wallet/themes/theme.dart';
import 'package:wallet/themes/typography.dart';

class WalletSendAvmNftItemWidget extends StatefulWidget {
  final NftCollectibleItem item;
  final Function(NftCollectibleItem) onDeleteNft;

  const WalletSendAvmNftItemWidget(
      {Key? key, required this.item, required this.onDeleteNft})
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
                  child: InkWell(
                    onTap: () => widget.onDeleteNft(widget.item),
                    child: Padding(
                        padding: const EdgeInsets.all(4),
                        child: Assets.icons.icCloseCirclePrimary.svg()),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            EZCTextField(
              width: 80,
              height: 24,
              maxLines: 1,
              borderRadius: const BorderRadius.all(Radius.circular(4)),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
              controller: _quantityController,
              textAlign: TextAlign.end,
              inputType: TextInputType.number,
              style: EZCBodyMediumTextStyle(color: provider.themeMode.text),
              onChanged: (text) {
                final quantity = int.tryParse(text) ?? 1;
                if (quantity > widget.item.count) {
                  _quantityController.text = widget.item.count.toString();
                } else {
                  widget.item.quantity = quantity;
                }
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
