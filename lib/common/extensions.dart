import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:wallet/generated/l10n.dart';

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

  String format(String pattern) {
    return DateFormat(pattern).format(this);
  }

  DateTime applied(TimeOfDay time) {
    return DateTime(year, month, day, time.hour, time.minute);
  }

  String formatYMMdDateHoursTime() => DateFormat.yMMMd().add_jm().format(this);

  String formatYMdDateHoursTime() => DateFormat.yMd().add_jm().format(this);
}
