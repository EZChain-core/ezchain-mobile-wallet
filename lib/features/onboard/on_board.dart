import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:wallet/common/router.gr.dart';
import 'package:wallet/generated/assets.gen.dart';
import 'package:wallet/generated/l10n.dart';
import 'package:wallet/themes/buttons.dart';

class OnBoardScreen extends StatefulWidget {
  const OnBoardScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _OnBoardScreenState();
}

class _OnBoardScreenState extends State<OnBoardScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Assets.images.imgBgOnBoard.image(),
          Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Expanded(
                  child: SizedBox(),
                ),
                SizedBox(
                  width: 164,
                  child: WalletMediumPrimaryButton(
                    text: Strings.current.onBoardAccessWallet,
                    onPressed: () {
                      context.router.push(const AccessWalletOptionsRoute());
                    },
                  ),
                ),
                const SizedBox(height: 4),
                SizedBox(
                  width: 164,
                  child: WalletMediumNoneButton(
                    text: Strings.current.onBoardCreateWallet,
                    onPressed: () {
                      context.router.push(const CreateWalletRoute());
                    },
                  ),
                ),
                const SizedBox(height: 76),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
