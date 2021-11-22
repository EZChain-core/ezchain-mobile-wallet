import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:wallet/common/router.gr.dart';
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
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 164,
              child: WalletMediumPrimaryButton(
                text: "Access Wallet",
                onPressed: () {
                  context.router.push(const AccessWalletOptionsRoute());
                },
              ),
            ),
            SizedBox(
              width: 164,
              child: WalletMediumNoneButton(
                text: "Create Wallet",
                onPressed: () {
                  context.router.push(const CreateWalletRoute());
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
