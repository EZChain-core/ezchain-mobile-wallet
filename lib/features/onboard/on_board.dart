import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';
import 'package:wallet/features/common/route/router.gr.dart';
import 'package:wallet/features/onboard/on_board_store.dart';
import 'package:wallet/generated/assets.gen.dart';
import 'package:wallet/generated/l10n.dart';
import 'package:wallet/themes/buttons.dart';
import 'package:wallet/themes/colors.dart';
import 'package:wallet/themes/theme.dart';

class OnBoardScreen extends StatelessWidget {
  OnBoardScreen({Key? key}) : super(key: key);

  final _onBoardStore = OnBoardStore();
  final _controller = PageController();
  final _pageSize = 3;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: Assets.images.imgBgOnBoard.image(fit: BoxFit.cover),
          ),
          Align(
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 234,
                  child: PageView(
                    scrollDirection: Axis.horizontal,
                    controller: _controller,
                    onPageChanged: _onBoardStore.selectPage,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 21),
                        child: Assets.images.imgOnboardOne.image(),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 21),
                        child: Assets.images.imgOnboardTwo.image(),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 21),
                        child: Assets.images.imgOnboardThree.image(),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 24),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      _pageSize,
                      (index) => Observer(
                        builder: (_) => _DotIndicator(
                          isSelected: index == _onBoardStore.pageSelectedIndex,
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                SizedBox(
                  width: 164,
                  child: EZCMediumPrimaryButton(
                    text: Strings.current.sharedAccessWallet,
                    onPressed: () {
                      context.router.push(const AccessWalletOptionsRoute());
                    },
                  ),
                ),
                const SizedBox(height: 4),
                SizedBox(
                  width: 164,
                  child: EZCMediumNoneButton(
                    text: Strings.current.onBoardCreateWallet,
                    onPressed: () {
                      context.router.push(CreateWalletRoute());
                    },
                  ),
                ),
                const SizedBox(height: 76),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class _DotIndicator extends StatelessWidget {
  final bool isSelected;

  const _DotIndicator({Key? key, required this.isSelected}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<WalletThemeProvider>(
      builder: (context, provider, child) => AnimatedContainer(
        duration: const Duration(milliseconds: 100),
        margin: const EdgeInsets.only(right: 18),
        height: 16,
        width: 16,
        decoration: BoxDecoration(
          color: isSelected ? provider.themeMode.primary : Colors.transparent,
          border: Border.all(width: 1, color: provider.themeMode.primary),
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}
