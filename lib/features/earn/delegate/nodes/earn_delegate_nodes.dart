// ignore: implementation_imports
import 'package:auto_route/src/router/auto_router_x.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';
import 'package:wallet/features/earn/delegate/nodes/earn_delegate_node_item.dart';
import 'package:wallet/features/earn/delegate/nodes/earn_delegate_nodes_store.dart';
import 'package:wallet/generated/assets.gen.dart';
import 'package:wallet/generated/l10n.dart';
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
          child: GestureDetector(
            onTap: () {
              FocusManager.instance.primaryFocus?.unfocus();
            },
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
                  child: Observer(builder: (_) {
                    if (_earnDelegateNodesStore.nodes.isEmpty) {
                      return Align(
                        alignment: Alignment.center,
                        child: EZCEmpty(
                          img: Assets.images.imgSearchEmpty.image(
                            width: 181,
                            height: 150,
                          ),
                          title: Strings.current.sharedNoResultFound,
                          des: Strings.current.sharedNoResultFoundDes,
                        ),
                      );
                    }
                    return RefreshIndicator(
                      onRefresh: _refresh,
                      child: ListView.separated(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        itemCount: _earnDelegateNodesStore.nodes.length,
                        itemBuilder: (_, index) => EarnDelegateNodeItemWidget(
                          item: _earnDelegateNodesStore.nodes[index],
                        ),
                        separatorBuilder: (_, index) =>
                            const SizedBox(height: 24),
                      ),
                    );
                  }),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _refresh() {
    _earnDelegateNodesStore.refresh();
    return Future.delayed(const Duration(seconds: 1));
  }
}
