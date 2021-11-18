import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:wallet/common/router.gr.dart';

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
            TextButton(
              onPressed: () {
                context.router.push(const AccessWalletOptionsRoute());
              },
              child: const Text('Access Wallet'),
            ),
            TextButton(
              onPressed: () {
                context.router.push(const CreateWalletRoute());
              },
              child: const Text('Create Wallet'),
            ),
          ],
        ),
      ),
    );
  }
}
