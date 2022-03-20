// ignore: implementation_imports
import 'package:auto_route/src/router/auto_router_x.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';
import 'package:wallet/features/earn/delegate/nodes/earn_delegate_node_item.dart';
import 'package:wallet/features/earn/delegate/nodes/earn_delegate_nodes_store.dart';
import 'package:wallet/generated/assets.gen.dart';
import 'package:wallet/generated/l10n.dart';
import 'package:wallet/themes/colors.dart';
import 'package:wallet/themes/inputs.dart';
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
                onPressed: context.router.pop,
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                child: EZCSearchTextField(
                  hint: Strings.current.earnValidatorAddress,
                  onChanged: (text) {
                    _earnDelegateNodesStore.keySearch = text;
                  },
                ),
              ),
              Expanded(
                child: Observer(
                  builder: (_) => FutureBuilder<List<EarnDelegateNodeItem>>(
                    future: _earnDelegateNodesStore.getNodeIds(),
                    builder: (_, snapshot) {
                      if (snapshot.hasData) {
                        final nodes = snapshot.data!;
                        return nodes.isNotEmpty
                            ? ListView.separated(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 12),
                                itemCount: nodes.length,
                                itemBuilder: (_, index) =>
                                    EarnDelegateNodeItemWidget(
                                        item: nodes[index]),
                                separatorBuilder: (_, index) =>
                                    const SizedBox(height: 24),
                              )
                            : EZCEmpty(
                                img: Assets.images.imgSearchEmpty
                                    .image(width: 181, height: 150),
                                title: Strings.current.sharedNoResultFound,
                                des: Strings.current.sharedNoResultFoundDes,
                              );
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
