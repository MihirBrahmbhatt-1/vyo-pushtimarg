class CityListData {
  int? id;
  String? name;
  int? stateId;
  int? countryId;

  CityListData({this.id, this.name, this.stateId, this.countryId});

  CityListData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    stateId = json['state_id'];
    countryId = json['country_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['state_id'] = stateId;
    data['country_id'] = countryId;
    return data;
  }
}
