import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wallet/themes/theme.dart';

class EarnScreen extends StatefulWidget {
  const EarnScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _EarnScreenState();
}

class _EarnScreenState extends State<EarnScreen> {
  @override
  Widget build(BuildContext context) {
    return Consumer<WalletThemeProvider>(
      builder: (context, provider, child) => Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
            child: Column(
              children: [],
            ),
          ),
        ),
      ),
    );
  }
}
