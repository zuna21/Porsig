class CreateGroupModel {
  String? name;
  List<int>? participantsId;

  CreateGroupModel({this.name, this.participantsId});

  CreateGroupModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    participantsId = json['participantsId'].cast<int>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['participantsId'] = participantsId;
    return data;
  }
}