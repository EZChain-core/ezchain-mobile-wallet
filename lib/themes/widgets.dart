import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wallet/generated/assets.gen.dart';
import 'package:wallet/themes/colors.dart';
import 'package:wallet/themes/theme.dart';
import 'package:wallet/themes/typography.dart';

class ROIAppBar extends StatelessWidget {
  final String title;
  final VoidCallback onPressed;

  const ROIAppBar({Key? key, required this.title, required this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<WalletThemeProvider>(
      builder: (context, provider, child) => Container(
        width: double.infinity,
        height: 48,
        color: provider.themeMode.secondary,
        child: Row(
          children: [
            const SizedBox(width: 4),
            IconButton(
              onPressed: onPressed,
              icon: Assets.icons.icArrowLeftWhite.svg(),
            ),
            Text(
              title,
              style: ROITitleLargeTextStyle(color: provider.themeMode.white),
            )
          ],
        ),
      ),
    );
  }
}
