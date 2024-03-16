class MessageModel {
  int? id;
  String? content;
  bool? isMine;
  String? createdAt;

  MessageModel({this.id, this.content, this.isMine, this.createdAt});

  MessageModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    content = json['content'];
    isMine = json['isMine'];
    createdAt = json['createdAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['content'] = content;
    data['isMine'] = isMine;
    data['createdAt'] = createdAt;
    return data;
  }
}