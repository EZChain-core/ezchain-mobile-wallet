import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';
import 'package:wallet/features/common/route/router.dart';
import 'package:wallet/generated/l10n.dart';
import 'package:wallet/themes/typography.dart';

extension StringExtension on String {
  String useCorrectEllipsis() {
    return replaceAll('', '\u200B');
  }

  DateTime? parseDateTime() {
    try {
      return DateFormat("yyyy-MM-dd'T'HH:mm:ss'Z'").parse(this, true).toLocal();
    } catch (e) {
      return null;
    }
  }

  DateTime? parseDateTimeFromTimestamp() {
    try {
      final timestamp = int.parse(this);
      return DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
    } catch (e) {
      return null;
    }
  }

  bool isValidUrl() {
    String pattern =
        r'(http|https)://[\w-]+(\.[\w-]+)+([\w.,@?^=%&amp;:/~+#-]*[\w@?^=%&amp;/~+#-])?';
    RegExp regExp = RegExp(pattern);
    if (length == 0) {
      return false;
    }
    return regExp.hasMatch(this);
  }

  bool isValidJson() {
    try {
      json.decode(this) as Map<String, dynamic>;
      return true;
    } catch (e) {
      return false;
    }
  }
}

extension StringNullableExtension on String? {
  bool get isNotNullOrEmpty => this != null && this != "";
}

T? tryCast<T>(dynamic x) => x is T ? x : null;

extension DateTimeExtension on DateTime {
  String parseTimeAgo() {
    final now = DateTime.now();
    final diffDays = now.difference(this).inDays;
    final diffHours = now.difference(this).inHours;
    final diffMinutes = now.difference(this).inMinutes;

    if (diffDays > 0) {
      return DateFormat.yMMMd().format(now);
    } else if (diffHours > 0) {
      return Strings.current.sharedHourAgo(diffHours);
    } else if (diffMinutes > 0) {
      return Strings.current.sharedMinuteAgo(diffMinutes);
    } else {
      return Strings.current.sharedJustNow;
    }
  }

  String parseDurationTime() {
    final now = DateTime.now();
    final diffDays = difference(now).inDays;
    final diffYears = diffDays ~/ 365;

    if (diffYears > 0) {
      return Strings.current.sharedInYears(diffYears);
    } else {
      return Strings.current.sharedInDays(diffDays);
    }
  }

  String format(String pattern) {
    return DateFormat(pattern).format(this);
  }

  DateTime applied(TimeOfDay time) {
    return DateTime(year, month, day, time.hour, time.minute);
  }

  String formatYMMdDateHoursTime() => DateFormat.yMMMd().add_jm().format(this);

  String formatYMdDateHoursTime() => DateFormat.yMd().add_jm().format(this);
}

showSnackBar(String text, {int milliseconds = 2500, BuildContext? context}) {
  final showContext = context ?? walletContext;
  if (showContext == null) return;
  ScaffoldMessenger.of(showContext).showSnackBar(
    SnackBar(
      duration: Duration(milliseconds: milliseconds),
      backgroundColor: Theme.of(showContext).primaryColor,
      content: Text(
        text,
        style: const EZCTitleMediumTextStyle(color: Colors.white),
      ),
    ),
  );
}

shareText(String text) {
  Share.share('$text \n');
}
