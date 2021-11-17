import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:wallet/common/router.gr.dart';

class AccessPrivateKeyScreen extends StatefulWidget {
  const AccessPrivateKeyScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _AccessPrivateKeyScreenState();
}

class _AccessPrivateKeyScreenState extends State<AccessPrivateKeyScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: TextButton(
          onPressed: () {
            context.router.push(const DashboardRoute());
          },
          child: const Text('Access Wallet'),
        ),
      ),
    );
  }
}
