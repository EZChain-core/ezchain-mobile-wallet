// ignore: implementation_imports
import 'package:auto_route/src/router/auto_router_x.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';
import 'package:provider/provider.dart';
import 'package:wallet/features/common/ext/extensions.dart';
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
      builder: (context, provider, child) => ScaffoldMessenger(
        // to show snack bar on dialog
        child: Builder(
          builder: (context) => Scaffold(
            backgroundColor: Colors.transparent,
            body: ReactionBuilder(
              builder: (_) {
                return autorun((_) {
                  final error = _nftAddCollectibleStore.error;
                  if (error.isNotEmpty) {
                    showSnackBar(error, context: context);
                  }
                });
              },
              child: GestureDetector(
                onTap: context.popRoute,
                child: SingleChildScrollView(
                  // case overflow do keyboard bật lên
                  child: Dialog(
                    insetPadding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 100),
                    backgroundColor: Colors.transparent,
                    child: ScaffoldMessenger(
                      child: GestureDetector(
                        onTap: () {},
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            GestureDetector(
                              onTap: context.popRoute,
                              child: Assets.icons.icCloseCircleOutlinePrimary
                                  .svg(),
                            ),
                            const SizedBox(height: 8),
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: provider.themeMode.white,
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(8)),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    Strings.current.nftAddCollectible,
                                    style: EZCHeadlineSmallTextStyle(
                                        color: provider.themeMode.text),
                                  ),
                                  const SizedBox(height: 22),
                                  EZCTextField(
                                    label: Strings
                                        .current.nftErc721ContractAddress,
                                    hint: '0x',
                                    maxLines: 1,
                                    onChanged: (text) {
                                      _nftAddCollectibleStore.validate(text);
                                    },
                                  ),
                                  const SizedBox(height: 16),
                                  Container(
                                    width: double.infinity,
                                    padding: const EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                        color: provider.themeMode.bg,
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(8))),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          Strings.current.nftCollectibleName,
                                          style: EZCTitleLargeTextStyle(
                                              color: provider.themeMode.text60),
                                        ),
                                        const SizedBox(height: 16),
                                        Observer(
                                          builder: (_) => Text(
                                            _nftAddCollectibleStore.name,
                                            style: EZCTitleLargeTextStyle(
                                                color:
                                                    provider.themeMode.text60),
                                          ),
                                        ),
                                        const SizedBox(height: 24),
                                        Text(
                                          Strings.current.nftCollectibleSymbol,
                                          style: EZCTitleLargeTextStyle(
                                              color: provider.themeMode.text60),
                                        ),
                                        const SizedBox(height: 16),
                                        Observer(
                                          builder: (_) => Text(
                                            _nftAddCollectibleStore.symbol,
                                            style: EZCTitleLargeTextStyle(
                                                color:
                                                    provider.themeMode.text60),
                                          ),
                                        ),
                                        const SizedBox(height: 24),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 48),
                                  Align(
                                    alignment: Alignment.bottomCenter,
                                    child: Observer(
                                      builder: (_) => EZCMediumPrimaryButton(
                                        width: 181,
                                        isLoading:
                                            _nftAddCollectibleStore.isLoading,
                                        text: Strings.current.nftAddCollectible,
                                        onPressed: _nftAddCollectibleStore
                                            .addCollectible,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 24),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
