class CreateMessageModel {
  String? content;

  CreateMessageModel({this.content});

  CreateMessageModel.fromJson(Map<String, dynamic> json) {
    content = json['content'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['content'] = content;
    return data;
  }
}