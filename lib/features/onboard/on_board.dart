import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wallet/common/router.gr.dart';
import 'package:wallet/generated/assets.gen.dart';
import 'package:wallet/generated/l10n.dart';
import 'package:wallet/themes/buttons.dart';
import 'package:wallet/themes/colors.dart';
import 'package:wallet/themes/theme.dart';

class OnBoardScreen extends StatefulWidget {
  const OnBoardScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _OnBoardScreenState();
}

class _OnBoardScreenState extends State<OnBoardScreen> {
  final _controller = PageController();
  int _pageSelectedIndex = 0;

  final _pageImages = <Widget>[
    Padding(
      padding: const EdgeInsets.symmetric(horizontal: 21),
      child: Assets.images.imgOnboardOne.image(),
    ),
    Padding(
      padding: const EdgeInsets.symmetric(horizontal: 21),
      child: Assets.images.imgOnboardOne.image(),
    ),
    Padding(
      padding: const EdgeInsets.symmetric(horizontal: 21),
      child: Assets.images.imgOnboardOne.image(),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                    onPageChanged: (value) {
                      setState(() {
                        _pageSelectedIndex = value;
                      });
                    },
                    children: _pageImages,
                  ),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 24),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      _pageImages.length,
                      (index) => _DotIndicator(
                        isSelected: index == _pageSelectedIndex,
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
                  child: ROIMediumPrimaryButton(
                    text: Strings.current.sharedAccessWallet,
                    onPressed: () {
                      context.router.push(const AccessWalletOptionsRoute());
                    },
                  ),
                ),
                const SizedBox(height: 4),
                SizedBox(
                  width: 164,
                  child: ROIMediumNoneButton(
                    text: Strings.current.onBoardCreateWallet,
                    onPressed: () {
                      context.router.push(const CreateWalletRoute());
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
