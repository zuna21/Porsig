import 'dart:async';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:porsig/globals.dart';
import 'package:porsig/models/message/create_message_model.dart';
import 'package:porsig/models/message/message_model.dart';
import 'package:signalr_core/signalr_core.dart';

HubConnection? connection;
StreamController<MessageModel> messageStream = StreamController<MessageModel>.broadcast();
class ChatHub {
  ChatHub();
  // HubConnection? connection;

  Future<void> startConnection() async {
    const storage = FlutterSecureStorage();
    connection = HubConnectionBuilder()
        .withUrl(
            'http://${Globals.baseUrl}/hubs/chat',
            HttpConnectionOptions(
              withCredentials: true,
              accessTokenFactory: () => storage.read(key: "token"),
              logging: (level, message) => print(message),
            ))
            .withAutomaticReconnect()
        .build();

    connection!.on("ReceiveMyMessage", (arguments) {
      MessageModel newMessage = MessageModel.fromJson(arguments![0]);
      messageStream.add(newMessage);
     });

    if (connection != null) {
      await connection!.start();
    }
  }

  Future<void> stopConnection() async {
    if (connection != null) {
      await connection!.stop();
    }
  }

  Future<void> joinGroup(String groupName) async {
    if (connection == null) return;
    await connection!.invoke('JoinGroup', args: [groupName]);
  }

  Future<void> leaveGroup(String groupName) async {
    if (connection == null) return;
    await connection!.invoke('LeaveGroup', args: [groupName]);
  }

  Future<void> sendMessage(int groupId, CreateMessageModel createMessageModel) async {
    if (connection == null) return;
    await connection!.invoke('SendMessage', args: [groupId, createMessageModel.toJson()]);
  }


}
