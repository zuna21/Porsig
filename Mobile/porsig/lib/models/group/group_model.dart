class GroupModel {
  int? id;
  String? name;
  String? uniqueName;

  GroupModel({this.id, this.name, this.uniqueName});

  GroupModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    uniqueName = json['uniqueName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['uniqueName'] = uniqueName;
    return data;
  }
}