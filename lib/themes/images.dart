import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wallet/themes/colors.dart';
import 'package:wallet/themes/theme.dart';

class EZCCircleImage extends StatelessWidget {
  final String src;

  final double size;

  final Widget? placeholder;

  const EZCCircleImage(
      {required this.src, required this.size, this.placeholder});

  @override
  Widget build(BuildContext context) {
    return Consumer<WalletThemeProvider>(
      builder: (context, provider, child) => CachedNetworkImage(
        imageUrl: src,
        width: size,
        height: size,
        imageBuilder: (context, imageProvider) => Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
          ),
        ),
        placeholder: (context, url) =>
            placeholder ??
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: provider.themeMode.bg,
              ),
            ),
        errorWidget: (context, url, error) =>
            placeholder ??
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: provider.themeMode.bg,
              ),
            ),
        fadeInCurve: Curves.linear,
        fadeInDuration: const Duration(milliseconds: 0),
        fadeOutCurve: Curves.linear,
        fadeOutDuration: const Duration(milliseconds: 0),
      ),
    );
  }
}
