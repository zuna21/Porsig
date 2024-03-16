import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:porsig/globals.dart';
import 'package:porsig/models/message/create_message_model.dart';
import 'package:porsig/models/message/message_model.dart';
import 'package:http/http.dart' as http;

class MessageService {
  const MessageService();

  Future<List<MessageModel>> getMessages(int groupId) async {
    final url = Globals.isProduction
        ? Uri.https(Globals.baseUrl, '/api/messages/get-messages/$groupId')
        : Uri.http(Globals.baseUrl, '/api/messages/get-messages/$groupId');
    const storage = FlutterSecureStorage();
    final token = await storage.read(key: "token");
    final response = await http
        .get(url, headers: <String, String>{"Authorization": "Bearer $token"});

    if (response.statusCode == 200) {
      return (json.decode(response.body) as List<dynamic>)
          .map((e) => MessageModel.fromJson(e))
          .toList();
    } else {
      throw Exception(response.body);
    }
  }

  Future<MessageModel> create(int groupId, CreateMessageModel message) async {
    final url = Globals.isProduction
        ? Uri.https(Globals.baseUrl, '/api/messages/create/$groupId')
        : Uri.http(Globals.baseUrl, '/api/messages/create/$groupId');
    const storage = FlutterSecureStorage();
    final token = await storage.read(key: "token");
    final response = await http.post(
      url,
      headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token'
        },
      body: json.encode(message.toJson())
    );

    if (response.statusCode == 200) {
      return MessageModel.fromJson(json.decode(response.body));
    } else {
      throw Exception(response.body);
    }
  }
}
