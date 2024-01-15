class Utils {
  static bool isEmpty(Object? text) {
    if (text is String) return text.isEmpty;
    if (text is List) return text.isEmpty;
    return text == null;
  }

  static bool isEmptyArray(List? list) {
    return list == null || list.isEmpty;
  }
}
