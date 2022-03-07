import 'dart:convert';

String? parseNFTPayload(String? payload) {
  try {
    if (payload != null && payload.isNotEmpty) {
      return utf8.decode(base64Decode(payload));
    } else {
      return null;
    }
  } catch (e) {
    return null;
  }
}
