class CountryListData {
  int? id;
  String? flag;
  String? name;
  String? abbreviation;

  CountryListData({this.id, this.flag, this.name, this.abbreviation});

  CountryListData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    flag = json['flag'];
    name = json['name'];
    abbreviation = json['Abbreviation'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['flag'] = flag;
    data['name'] = name;
    data['Abbreviation'] = abbreviation;
    return data;
  }
}
