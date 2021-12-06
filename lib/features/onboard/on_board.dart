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
  int _currentIndex = 0;

  createCircle(int index) {
    return Consumer<WalletThemeProvider>(
      builder: (context, provider, child) => AnimatedContainer(
        duration: const Duration(milliseconds: 100),
        margin: const EdgeInsets.only(right: 4),
        height: 16,
        width: 16,
        decoration: BoxDecoration(
          color: _currentIndex == index
              ? provider.themeMode.primary
              : Colors.transparent,
          border: Border.all(width: 1, color: provider.themeMode.primary),
          borderRadius: BorderRadius.circular(60),
        ),
      ),
    );
  }

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
                        _currentIndex = value;
                      });
                    },
                    children: [
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
                    ],
                  ),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 24),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(3, (index) => createCircle(index)),
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
