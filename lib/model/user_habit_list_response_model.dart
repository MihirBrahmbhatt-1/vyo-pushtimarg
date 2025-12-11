class UserHabitListResponseModel {
  int? type;
  String? name;
  String? mobileNo;
  String? typeName;
  String? id;

  UserHabitListResponseModel({this.type, this.name, this.mobileNo, this.typeName, this.id});

  UserHabitListResponseModel.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    name = json['name'];
    mobileNo = json['mobile_no'];
    typeName = json['type_name'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['type'] = type;
    data['name'] = name;
    data['mobile_no'] = mobileNo;
    data['type_name'] = typeName;
    data['id'] = id;
    return data;
  }
}
