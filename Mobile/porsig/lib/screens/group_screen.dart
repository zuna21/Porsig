import 'dart:async';

import 'package:flutter/material.dart';
import 'package:porsig/hubs/chat_hub.dart';
import 'package:porsig/models/group/group_model.dart';
import 'package:porsig/models/message/create_message_model.dart';
import 'package:porsig/models/message/message_model.dart';
import 'package:porsig/services/message_service.dart';
import 'package:porsig/services/toastr_service.dart';
import 'package:porsig/widgets/message.dart';

class GroupScreen extends StatefulWidget {
  const GroupScreen({super.key, required this.group});

  final GroupModel group;

  @override
  State<GroupScreen> createState() => _GroupScreenState();
}

class _GroupScreenState extends State<GroupScreen> {
  final ToastrService _toastr = const ToastrService();
  final MessageService _messageService = const MessageService();
  final TextEditingController _message = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final ChatHub _chatHub = ChatHub();

  List<MessageModel> messages = [];
  StreamSubscription<MessageModel>? _messageStream;

  @override
  void initState() {
    super.initState();
    _joinGroup();
    _getMessages();
    _receiveNewMessage();
  }

  void _joinGroup() {
    if (widget.group.uniqueName == null) return;
    _chatHub.joinGroup(widget.group.uniqueName!);
  }

  void _leaveGroup() {
    if (widget.group.uniqueName == null) return;
    _chatHub.leaveGroup(widget.group.uniqueName!);
  }

  void _receiveNewMessage() {
    _messageStream = messageStream.stream.listen((newMessage) {
      setState(() {
        messages = [...messages, newMessage];
      });
    });
  }

  void _getMessages() async {
    try {
      messages = await _messageService.getMessages(widget.group.id!);
    } catch (err) {
      if (!context.mounted) return;
      _toastr.error(context, "Error", err.toString());
    }

    setState(() {
      
    });
  }

  void _onSend() {
    if (_message.text.trim().isEmpty) return;
    CreateMessageModel createMessage =
        CreateMessageModel(content: _message.text);


    _chatHub.sendMessage(widget.group.id!, createMessage);
    _message.clear();
    _scrollController.animateTo(_scrollController.position.maxScrollExtent, duration: const Duration(seconds: 1), curve: Curves.linear);

    /* MessageModel newMessage;
    try {
      newMessage =
          await _messageService.create(widget.group.id!, createMessage);
    } catch (err) {
      if (!context.mounted) return;
      _toastr.error(context, "Error", err.toString());
      return;
    }
    setState(() {
      messages = [...messages, newMessage];
      _message.clear();
      FocusManager.instance.primaryFocus?.unfocus();
      _scrollController.animateTo(_scrollController.position.maxScrollExtent,
          duration: const Duration(seconds: 1), curve: Curves.linear);
    }); */
  }


  @override
  void dispose() {
    _message.dispose();
    _scrollController.dispose();
    _messageStream!.cancel();
    _leaveGroup();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.group.name!),
      ),
      body: Column(
        children: [
          Expanded(
            child: SizedBox(
              width: double.infinity,
              height: double.infinity,
              child: SingleChildScrollView(
                controller: _scrollController,
                child: Column(
                  children: [
                    for (var message in messages) Message(message: message)
                  ],
                ),
              ),
            ),
          ),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(10),
            // height: 60,
            color: Theme.of(context).colorScheme.primary,
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    maxLines: null,
                    controller: _message,
                    autocorrect: false,
                    enableSuggestions: false,
                    decoration: InputDecoration(
                        filled: true,
                        fillColor:
                            Theme.of(context).colorScheme.secondaryContainer),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                IconButton(
                  onPressed: _onSend,
                  icon: const Icon(Icons.send),
                  style: IconButton.styleFrom(
                      backgroundColor:
                          Theme.of(context).colorScheme.primaryContainer),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
