import 'package:auto_route/src/router/auto_router_x.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';
import 'package:provider/provider.dart';
import 'package:wallet/features/common/ext/extensions.dart';
import 'package:wallet/features/common/constant/wallet_constant.dart';
import 'package:wallet/generated/l10n.dart';
import 'package:wallet/themes/buttons.dart';
import 'package:wallet/themes/colors.dart';
import 'package:wallet/themes/inputs.dart';
import 'package:wallet/themes/theme.dart';
import 'package:wallet/themes/typography.dart';
import 'package:wallet/themes/widgets.dart';

import 'nft_family_create_store.dart';

class NftFamilyCreateScreen extends StatelessWidget {
  NftFamilyCreateScreen({Key? key}) : super(key: key);

  final _nftFamilyCreateStore = NftFamilyCreateStore();
  final _nameController = TextEditingController();
  final _symbolController = TextEditingController();
  final _numberOfGroupsController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Consumer<WalletThemeProvider>(
      builder: (context, provider, child) => ReactionBuilder(
        builder: (context) {
          return autorun((_) {
            final error = _nftFamilyCreateStore.error;
            if (error.isNotEmpty) {
              showSnackBar(error);
            }
          });
        },
        child: Scaffold(
          body: SafeArea(
            child: Column(
              children: [
                EZCAppBar(
                  title: Strings.current.nftNewFamily,
                  onPressed: context.popRoute,
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 16),
                        EZCTextField(
                          label: Strings.current.nftName,
                          controller: _nameController,
                        ),
                        const SizedBox(height: 16),
                        EZCTextField(
                          label: Strings.current.nftSymbol,
                          controller: _symbolController,
                          textCapitalization: TextCapitalization.characters,
                        ),
                        const SizedBox(height: 16),
                        EZCTextField(
                          label: Strings.current.nftNumberOfGroups,
                          controller: _numberOfGroupsController,
                          inputType: TextInputType.number,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          '${Strings.current.sharedFee}: ${_nftFamilyCreateStore.fee} $ezcCode',
                          style: EZCTitleLargeTextStyle(
                              color: provider.themeMode.text60),
                        ),
                        const SizedBox(height: 34),
                        Observer(
                          builder: (_) => EZCMediumPrimaryButton(
                            text: Strings.current.nftCreateFamily,
                            width: 130,
                            isLoading: _nftFamilyCreateStore.isLoading,
                            onPressed: _onClickCreateFamily,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  _onClickCreateFamily() async {
    final name = _nameController.text.trim();
    final symbol = _symbolController.text.trim();
    final groupNum = int.tryParse(_numberOfGroupsController.text) ?? 0;
    _nftFamilyCreateStore.createFamily(name, symbol, groupNum);
  }
}
