import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:porsig/globals.dart';
import 'package:porsig/models/user/user_model.dart';
import 'package:http/http.dart' as http;

class UserService {
  const UserService();

  Future<List<UserModel>> getUsers(String username) async {
    final queryParams = {"username": username};
    final url = Globals.isProduction
        ? Uri.https(Globals.baseUrl, '/api/users/get-users', queryParams)
        : Uri.http(Globals.baseUrl, '/api/users/get-users', queryParams);

    const storage = FlutterSecureStorage();
    final token = await storage.read(key: "token");
    final response =
        await http.get(url, headers: {'Authorization': 'Bearer $token'});

    if (response.statusCode == 200) {
      return (json.decode(response.body) as List<dynamic>)
          .map((e) => UserModel.fromJson(e))
          .toList();
    } else {
      throw Exception(response.body);
    }
  }
}
