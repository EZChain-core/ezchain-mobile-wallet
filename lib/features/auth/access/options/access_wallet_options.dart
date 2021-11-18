import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:wallet/common/router.gr.dart';

class AccessWalletOptionsScreen extends StatefulWidget {
  const AccessWalletOptionsScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _AccessWalletOptionsScreenState();
}

class _AccessWalletOptionsScreenState extends State<AccessWalletOptionsScreen> {
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
                context.router.push(const AccessPrivateKeyRoute());
              },
              child: const Text('Private Key'),
            ),
          ],
        ),
      ),
    );
  }
}
