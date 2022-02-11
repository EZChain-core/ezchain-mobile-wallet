import 'package:auto_route/src/router/auto_router_x.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wallet/features/earn/delegate/nodes/earn_delegate_node_item.dart';
import 'package:wallet/features/earn/delegate/nodes/earn_delegate_nodes_store.dart';
import 'package:wallet/generated/l10n.dart';
import 'package:wallet/themes/colors.dart';
import 'package:wallet/themes/theme.dart';
import 'package:wallet/themes/widgets.dart';

class EarnDelegateNodesScreen extends StatelessWidget {
  final _earnDelegateNodesStore = EarnDelegateNodesStore();

  EarnDelegateNodesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<WalletThemeProvider>(
      builder: (context, provider, child) => Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              EZCAppBar(
                title: Strings.current.sharedDelegate,
                onPressed: () {
                  context.router.pop();
                },
              ),
              Expanded(
                child: FutureBuilder<List<EarnDelegateNodeItem>>(
                  future: _earnDelegateNodesStore.getNodeIds(),
                  builder: (_, snapshot) {
                    if (snapshot.hasData) {
                      final nodes = snapshot.data!;
                      return nodes.isNotEmpty
                          ? ListView.builder(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 12),
                              itemCount: nodes.length,
                              itemBuilder: (_, index) =>
                                  EarnDelegateNodeItemWidget(
                                      item: nodes[index]),
                            )
                          : const SizedBox.shrink();
                    } else {
                      return Align(
                        alignment: Alignment.center,
                        child: EZCLoading(
                            color: provider.themeMode.secondary,
                            size: 40,
                            strokeWidth: 4),
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
