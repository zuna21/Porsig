import 'package:flutter/material.dart';
import 'package:porsig/models/group/group_model.dart';

class ChatCard extends StatelessWidget {
  const ChatCard({super.key, required this.group, required this.onGroup});

  final GroupModel group;
  final void Function(GroupModel group) onGroup;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onGroup(group);
      },
      child: Container(
        width: double.infinity,
        height: 100,
        margin: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primaryContainer,
          borderRadius: BorderRadius.circular(5),
          boxShadow: [
            BoxShadow(
                color: Colors.grey.shade600,
                spreadRadius: 1,
                blurRadius: 15,
                offset: const Offset(0, 15))
          ],
        ),
        child: Center(
          child: Text(
            group.name!,
            style: Theme.of(context).textTheme.titleLarge!.copyWith(
                color: Theme.of(context).colorScheme.onPrimaryContainer),
          ),
        ),
      ),
    );
  }
}
