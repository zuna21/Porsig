import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:porsig/globals.dart';
import 'package:porsig/models/account/account_model.dart';
import 'package:porsig/models/account/login_model.dart';

class AccountService {
  const AccountService();

  Future<AccountModel> Login(LoginModel loginModel) async {
    final url = Globals.isProduction
        ? Uri.https(Globals.baseUrl, '/api/account/login')
        : Uri.http(Globals.baseUrl, '/api/account/login');
    final response = await http.post(url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: json.encode(loginModel.toJson()));

    if (response.statusCode == 200) {
      return AccountModel.fromJson(
        json.decode(response.body),
      );
    } else {
      throw Exception(response.body);
    }
  }
}
