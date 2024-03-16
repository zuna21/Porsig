import 'package:flutter/material.dart';
import 'package:porsig/models/message/message_model.dart';

class Message extends StatelessWidget {
  const Message({super.key, required this.message});

  final MessageModel message;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        top: 2,
        bottom: 2,
        left: message.isMine! ? 50 : 5,
        right: message.isMine! ? 5 : 50
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: message.isMine!
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.primaryContainer,
              ),
              child: Text(
                message.content!,
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      color: message.isMine!
                      ? Theme.of(context).colorScheme.onPrimary
                      : Theme.of(context).colorScheme.onPrimaryContainer,
                    ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
