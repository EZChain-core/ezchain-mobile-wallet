import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wallet/generated/assets.gen.dart';
import 'package:wallet/themes/colors.dart';
import 'package:wallet/themes/theme.dart';
import 'package:wallet/themes/typography.dart';

class EZCAppBar extends StatelessWidget {
  final String title;
  final VoidCallback onPressed;

  const EZCAppBar({Key? key, required this.title, required this.onPressed})
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
              style: EZCTitleLargeTextStyle(color: provider.themeMode.white),
            )
          ],
        ),
      ),
    );
  }
}

class EZCDashedLine extends StatelessWidget {
  final Color color;

  const EZCDashedLine({Key? key, required this.color}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<WalletThemeProvider>(
      builder: (context, provider, child) => SizedBox(
        width: double.infinity,
        child: CustomPaint(
          painter: EZCDashedLinePainter(color),
          size: Size(MediaQuery.of(context).size.width, 10),
        ),
      ),
    );
  }
}

class EZCDashedLinePainter extends CustomPainter {
  final Color color;

  EZCDashedLinePainter(this.color);

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

class EZCDropdown<T> extends StatefulWidget {
  final String? label;

  final List<T> items;

  final ValueChanged<T>? onChanged;

  final bool? enabled;

  T? initValue;

  final String Function(T t) parseString;

  EZCDropdown(
      {Key? key,
      this.label,
      required this.items,
      this.onChanged,
      this.initValue,
      required this.parseString,
      this.enabled})
      : super(key: key);

  @override
  State<EZCDropdown> createState() => _EZCDropdownState<T>();
}

class _EZCDropdownState<T> extends State<EZCDropdown<T>> {
  @override
  void initState() {
    if (widget.initValue == null && widget.items.isNotEmpty) {
      widget.initValue = widget.items.first;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<WalletThemeProvider>(
      builder: (context, provider, child) => SizedBox(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (widget.label != null)
              Text(
                widget.label!,
                style: EZCTitleLargeTextStyle(color: provider.themeMode.text60),
              ),
            const SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                  color: provider.themeMode.white,
                  borderRadius: const BorderRadius.all(Radius.circular(8)),
                  border: Border.all(color: provider.themeMode.border)),
              child: DropdownButton<T>(
                value: widget.initValue,
                underline: const SizedBox.shrink(),
                isExpanded: true,
                icon: Assets.icons.icDropdownArrow.svg(),
                items: widget.items
                    .map(
                      (item) => DropdownMenuItem<T>(
                        value: item,
                        child: Text(
                          widget.parseString(item),
                          style: EZCBodyLargeTextStyle(
                              color: provider.themeMode.text),
                        ),
                      ),
                    )
                    .toList(),
                onChanged: widget.enabled != false
                    ? (s) {
                        if (s != null) {
                          setState(() {
                            widget.initValue = s;
                          });
                          widget.onChanged?.call(s);
                        }
                      }
                    : null,
              ),
            )
          ],
        ),
      ),
    );
  }
}

class EZCLoading extends StatelessWidget {
  final Color color;
  final double size;
  final double strokeWidth;

  const EZCLoading(
      {Key? key,
      required this.color,
      required this.size,
      required this.strokeWidth})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<WalletThemeProvider>(
      builder: (context, provider, child) => SizedBox(
        width: size,
        height: size,
        child: CircularProgressIndicator(
          strokeWidth: strokeWidth,
          color: color,
        ),
      ),
    );
  }
}

class EZCEmpty extends StatelessWidget {
  final Widget img;
  final String title;
  final String? des;

  const EZCEmpty({Key? key, required this.img, required this.title, this.des})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<WalletThemeProvider>(
      builder: (context, provider, child) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            img,
            const SizedBox(height: 16),
            Text(
              title,
              style: EZCTitleLargeTextStyle(color: provider.themeMode.text90),
            ),
            const SizedBox(height: 4),
            if (des != null)
              Text(
                des!,
                style: EZCBodyMediumTextStyle(color: provider.themeMode.text60),
              ),
          ],
        ),
      ),
    );
  }
}
