import 'package:flutter/material.dart';
import 'package:wallet/themes/dialogs.dart';

extension DialogExtensions on BuildContext {
  void showWarningDialog(Widget image, String content) {
    showDialog(
        context: this,
        builder: (_) => ROIWarningDialog(image: image, content: content));
  }
}
