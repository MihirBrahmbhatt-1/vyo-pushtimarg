class MediaModel {
  String id;
  String name;
  String description;
  String subcategoryId;
  String mediaUrl;
  bool isActive;

  /// Loaded later
  String? thumbnail;

  MediaModel({
    required this.id,
    required this.name,
    required this.description,
    required this.subcategoryId,
    required this.mediaUrl,
    required this.isActive,
    this.thumbnail,
  });

  factory MediaModel.fromJson(Map<String, dynamic> json) {
    return MediaModel(
      id: json["id"],
      name: json["name"],
      description: json["description"] ?? '',
      subcategoryId: json["subcategory_id"],
      mediaUrl: json["media_url"],
      isActive: json["is_active"] == "true",
    );
  }
}
