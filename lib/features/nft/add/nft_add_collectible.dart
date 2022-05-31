import 'package:auto_route/src/router/auto_router_x.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wallet/features/nft/add/nft_add_collectible_store.dart';
import 'package:wallet/generated/assets.gen.dart';
import 'package:wallet/generated/l10n.dart';
import 'package:wallet/themes/buttons.dart';
import 'package:wallet/themes/colors.dart';
import 'package:wallet/themes/inputs.dart';
import 'package:wallet/themes/theme.dart';
import 'package:wallet/themes/typography.dart';

class NftAddCollectibleDialog extends StatelessWidget {
  NftAddCollectibleDialog({Key? key}) : super(key: key);

  final _nftAddCollectibleStore = NftAddCollectibleStore();

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
              child: Assets.icons.icCloseCirclePrimary.svg(),
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
                    const SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsets.only(left: 16),
                      child: Text(
                        Strings.current.nftAddCollectible,
                        style: EZCHeadlineSmallTextStyle(
                            color: provider.themeMode.text),
                      ),
                    ),
                    const SizedBox(height: 22),
                    EZCTextField(
                      label: Strings.current.nftErc721ContractAddress,
                      hint: '0x',
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                          color: provider.themeMode.bg,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(8))),
                      child: Column(
                        children: [
                          Text(
                            Strings.current.nftCollectibleName,
                            style: EZCTitleLargeTextStyle(
                                color: provider.themeMode.text60),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '--',
                            style: EZCTitleLargeTextStyle(
                                color: provider.themeMode.text60),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            Strings.current.nftCollectibleSymbol,
                            style: EZCTitleLargeTextStyle(
                                color: provider.themeMode.text60),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '--',
                            style: EZCTitleLargeTextStyle(
                                color: provider.themeMode.text60),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 70),
                    EZCMediumPrimaryButton(
                      width: 181,
                      text: Strings.current.nftAddCollectible,
                      enabled: true,
                      onPressed: () {},
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
