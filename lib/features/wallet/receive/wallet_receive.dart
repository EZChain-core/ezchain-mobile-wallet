import 'package:auto_route/src/router/auto_router_x.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:wallet/common/extensions.dart';
import 'package:wallet/generated/assets.gen.dart';
import 'package:wallet/generated/l10n.dart';
import 'package:wallet/themes/buttons.dart';
import 'package:wallet/themes/colors.dart';
import 'package:wallet/themes/theme.dart';
import 'package:wallet/themes/typography.dart';
import 'package:wallet/themes/widgets.dart';

class WalletReceiveScreen extends StatelessWidget {
  final WalletReceiveInfo walletReceiveInfo;

  const WalletReceiveScreen({Key? key, required this.walletReceiveInfo})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<WalletThemeProvider>(
      builder: (context, provider, child) => Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              ROIAppBar(
                title: Strings.current.sharedReceive,
                onPressed: () {
                  context.router.pop();
                },
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: [
                            Assets.icons.icRoi.svg(),
                            const SizedBox(width: 8),
                            Text(
                              'ROI',
                              style: ROIBodyLargeTextStyle(
                                  color: provider.themeMode.text),
                            ),
                            const SizedBox(width: 16),
                            ROIChainLabelText(text: walletReceiveInfo.chain),
                          ],
                        ),
                      ),
                      Container(
                        width: double.infinity,
                        height: 453,
                        margin: const EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(
                            color: provider.themeMode.bg,
                            borderRadius:
                                const BorderRadius.all(Radius.circular(16))),
                        child: Column(
                          children: [
                            const SizedBox(height: 24),
                            Assets.images.imgLogoRoiSecondary
                                .image(width: 77, height: 61),
                            const SizedBox(height: 8),
                            CachedNetworkImage(
                              imageUrl:
                                  "https://upload.wikimedia.org/wikipedia/commons/thumb/d/d0/QR_code_for_mobile_English_Wikipedia.svg/1200px-QR_code_for_mobile_English_Wikipedia.svg.png",
                              width: 180,
                              height: 180,
                              imageBuilder: (context, imageProvider) =>
                                  Container(
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image: imageProvider,
                                      fit: BoxFit.fitWidth),
                                ),
                              ),
                              placeholder: (context, url) =>
                                  ColoredBox(color: provider.themeMode.text10),
                              errorWidget: (context, url, error) =>
                                  ColoredBox(color: provider.themeMode.text10),
                              fadeInCurve: Curves.linear,
                              fadeInDuration: const Duration(milliseconds: 0),
                              fadeOutCurve: Curves.linear,
                              fadeOutDuration: const Duration(milliseconds: 0),
                            ),
                            const Spacer(),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 45),
                              child: Text(
                                walletReceiveInfo.address.useCorrectEllipsis(),
                                maxLines: 3,
                                style: ROIBodyLargeTextStyle(
                                    color: provider.themeMode.text),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ROIMediumNoneButton(
                                  text: Strings.current.sharedCopy,
                                  iconLeft: Assets.icons.icCopyPrimary.svg(),
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 8, horizontal: 16),
                                  onPressed: () => {},
                                ),
                                const SizedBox(width: 16),
                                ROIMediumNoneButton(
                                  text: Strings.current.sharedShare,
                                  iconLeft: Assets.icons.icSharePrimary.svg(),
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 8, horizontal: 16),
                                  onPressed: () => {},
                                )
                              ],
                            ),
                            const SizedBox(height: 16),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 16, right: 16, top: 16, bottom: 24),
                        child: RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            text: Strings.current.walletReceiveSendOnly,
                            style: ROIBodySmallTextStyle(
                                color: provider.themeMode.text90),
                            children: <TextSpan>[
                              TextSpan(
                                  text: Strings.current.walletReceiveBitcoin,
                                  style: ROISemiBoldSmallTextStyle(
                                      color: provider.themeMode.text90)),
                              TextSpan(
                                  text: Strings.current.walletReceiveToThis,
                                  style: ROIBodySmallTextStyle(
                                      color: provider.themeMode.text90)),
                            ],
                          ),
                        ),
                      ),
                      Visibility(
                        visible: false,
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.only(left: 16, bottom: 4),
                          child: Text(
                            Strings.current.walletReceiveSetAmount,
                            style: ROITitleLargeTextStyle(
                                color: provider.themeMode.text60),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class WalletReceiveInfo {
  final String chain;
  final String address;

  WalletReceiveInfo(this.chain, this.address);
}
