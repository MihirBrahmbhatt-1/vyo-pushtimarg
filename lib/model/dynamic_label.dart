class DynamicLabel {
  final String key;
  final String value;
  // final String langCode;

  DynamicLabel({
    required this.key,
    required this.value,
    // required this.langCode,
  });

  factory DynamicLabel.fromJson(Map<String, dynamic> json) {
    return DynamicLabel(
      key: json["Label_key"],
      value: json["Label_value"],
      // langCode: json["Language_code"],
    );
  }
}
