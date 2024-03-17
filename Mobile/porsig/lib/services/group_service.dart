import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:porsig/globals.dart';
import 'package:porsig/models/group/create_group_model.dart';
import 'package:porsig/models/group/group_model.dart';
import 'package:http/http.dart' as http;

class GroupService {
  const GroupService();

  Future<List<GroupModel>> getGroups() async {
    const storage = FlutterSecureStorage();
    final token = await storage.read(key: "token");
    if (token == null) return [];
    final url = Globals.isProduction
        ? Uri.https(Globals.baseUrl, '/api/groups/get-groups')
        : Uri.http(Globals.baseUrl, '/api/groups/get-groups');

    final response = await http
        .get(url, headers: <String, String>{"Authorization": "Bearer $token"});

    if (response.statusCode == 200) {
      return (json.decode(response.body) as List<dynamic>)
          .map((e) => GroupModel.fromJson(e))
          .toList();
    } else {
      throw Exception(response.body);
    }
  }

  Future<GroupModel> create(CreateGroupModel createGroupModel) async {
    const storage = FlutterSecureStorage();
    final token = await storage.read(key: "token");
    final url = Globals.isProduction
    ? Uri.https(Globals.baseUrl, '/api/groups/create')
    : Uri.http(Globals.baseUrl, '/api/groups/create');

    final response = await http.post(
      url,
      headers: {
        "Authorization": "Bearer $token",
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: json.encode(createGroupModel.toJson())
    );
    if (response.statusCode == 200) {
      return GroupModel.fromJson(json.decode(response.body));
    } else {
      throw Exception(response.body);
    }
  }
}
