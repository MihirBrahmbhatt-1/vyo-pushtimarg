class DashboardImageSliderResponseModel {
  String? id;
  String? imageUrl;
  String? alternativeText;
  String? redirectUrl;
  int? sequence;

  DashboardImageSliderResponseModel({
    this.id,
    this.imageUrl,
    this.alternativeText,
    this.redirectUrl,
    this.sequence,
  });

  DashboardImageSliderResponseModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    imageUrl = json['image_url'];
    alternativeText = json['alternative_text'];
    redirectUrl = json['redirect_url'];
    sequence = json['sequence'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['image_url'] = imageUrl;
    data['alternative_text'] = alternativeText;
    data['redirect_url'] = redirectUrl;
    data['sequence'] = sequence;
    return data;
  }
}
