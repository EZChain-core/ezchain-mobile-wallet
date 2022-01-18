import 'package:auto_route/src/router/auto_router_x.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wallet/features/common/chain_type/ezc_type.dart';
import 'package:wallet/generated/assets.gen.dart';
import 'package:wallet/themes/theme.dart';
import 'package:wallet/themes/widgets.dart';

class HistoryScreen extends StatelessWidget {
  final EZCType ezcType;

  const HistoryScreen({Key? key, required this.ezcType}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<WalletThemeProvider>(
      builder: (context, provider, child) => Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              EZCAppBar(
                title: 'EZC(${ezcType.name})',
                onPressed: () {
                  context.router.pop();
                },
              ),
              Stack(
                children: [
                  Assets.images.imgBgHistory.svg(),
                  Column(
                    children: [
                      const SizedBox(height: 32),
                      Row(
                        children: [
                          const SizedBox(width: 16),
                          Assets.icons.icEzc64.svg(),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              children: [],
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
