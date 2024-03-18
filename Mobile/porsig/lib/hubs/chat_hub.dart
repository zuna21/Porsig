import 'package:porsig/globals.dart';
import 'package:signalr_core/signalr_core.dart';

class ChatHub {
  ChatHub();
  HubConnection? connection;

  Future<void> startConnection() async {
    connection = HubConnectionBuilder()
        .withUrl(
            'http://${Globals.baseUrl}/hubs/chat',
            HttpConnectionOptions(
              logging: (level, message) => print(message),
            ))
            .withAutomaticReconnect()
        .build();

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
}
