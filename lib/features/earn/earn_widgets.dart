import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wallet/features/common/ext/extensions.dart';
import 'package:wallet/generated/l10n.dart';
import 'package:wallet/themes/colors.dart';
import 'package:wallet/themes/images.dart';
import 'package:wallet/themes/theme.dart';
import 'package:wallet/themes/typography.dart';

class EarnNodeIdWidget extends StatelessWidget {
  final String id;
  final String? name;
  final String? src;

  const EarnNodeIdWidget({Key? key, required this.id, this.name, this.src})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<WalletThemeProvider>(
      builder: (context, provider, child) => SizedBox(
        width: double.infinity,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            EZCCircleImage(
              src: src ?? '',
              size: 64,
              placeholder: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                      width: 2, color: provider.themeMode.whiteSmoke),
                  color: provider.themeMode.text10,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name ?? Strings.current.sharedNodeId,
                    style: EZCSemiBoldLargeTextStyle(
                        color: provider.themeMode.text90),
                  ),
                  Text(
                    id.useCorrectEllipsis(),
                    style:
                        EZCBodySmallTextStyle(color: provider.themeMode.text60),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
