extension StringExtension on String {
  String useCorrectEllipsis() {
    return replaceAll('', '\u200B');
  }
}

T? tryCast<T>(dynamic x) => x is T ? x : null;