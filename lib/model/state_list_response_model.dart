class StateListData {
  int? id;
  String? name;
  String? abbreviation;
  int? countryId;

  StateListData({this.id, this.name, this.abbreviation, this.countryId});

  StateListData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['Name'];
    abbreviation = json['Abbreviation'];
    countryId = json['country_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['Name'] = name;
    data['Abbreviation'] = abbreviation;
    data['country_id'] = countryId;
    return data;
  }
}
