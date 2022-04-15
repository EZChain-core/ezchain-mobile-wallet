import 'package:auto_route/src/router/auto_router_x.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wallet/generated/assets.gen.dart';
import 'package:wallet/themes/colors.dart';
import 'package:wallet/themes/theme.dart';
import 'package:wallet/themes/typography.dart';

class NftPreviewDialog extends StatelessWidget {
  final String? url;
  final String? payload;

  const NftPreviewDialog({Key? key, this.url, this.payload}) : super(key: key);

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
                child: Assets.icons.icCloseCirclePrimary.svg(),
              ),
              const SizedBox(height: 4),
              ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(8)),
                child: CachedNetworkImage(
                  imageUrl: url ?? '',
                  errorWidget: (context, url, error) => Container(
                    width: double.infinity,
                    height: 400,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: provider.themeMode.bg,
                      borderRadius: const BorderRadius.all(Radius.circular(8)),
                    ),
                    child: Text(
                      payload ?? '',
                      style: EZCBodyMediumTextStyle(
                          color: provider.themeMode.text70),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
