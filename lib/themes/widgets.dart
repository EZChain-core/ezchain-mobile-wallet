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

class ROIDashedLine extends StatelessWidget {
  final Color color;

  const ROIDashedLine({Key? key, required this.color}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<WalletThemeProvider>(
      builder: (context, provider, child) => SizedBox(
        width: double.infinity,
        child: CustomPaint(
          painter: ROIDashedLinePainter(color),
          size: Size(MediaQuery.of(context).size.width, 10),
        ),
      ),
    );
  }
}

class ROIDashedLinePainter extends CustomPainter {
  final Color color;

  ROIDashedLinePainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..strokeWidth = 1
      ..color = color;
    var max = size.width;
    var dashWidth = 5;
    var dashSpace = 5;
    double startX = 0;
    final space = (dashSpace + dashWidth);

    while (startX < max) {
      canvas.drawLine(Offset(startX, 5), Offset(startX + dashWidth, 5), paint);
      startX += space;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
