import 'package:flutter/material.dart';
import 'package:porsig/models/user/user_model.dart';

class UserCard extends StatelessWidget {
  const UserCard({super.key, required this.user, this.isSelected = false, this.onAddUser, this.onRemoveUser});

  final UserModel user;
  final bool isSelected;
  final void Function(UserModel)? onAddUser;
  final void Function(UserModel)? onRemoveUser;

  @override
  Widget build(BuildContext context) {
    return Card(
        child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            user.username!,
            style: Theme.of(context)
                .textTheme
                .bodyLarge!
                .copyWith(color: Theme.of(context).colorScheme.onBackground),
          ),
          isSelected
          ? IconButton(
            onPressed: () {
              if (onRemoveUser != null) {
                onRemoveUser!(user);
              }
            },
            icon: const Icon(Icons.delete),
            style: IconButton.styleFrom(
                backgroundColor: Colors.red[400],
                foregroundColor: Colors.white),
          )
          : IconButton(onPressed: () {
            if (onAddUser != null) {
              onAddUser!(user);
            }
          }, icon: const Icon(Icons.add)),
        ],
      ),
    ));
  }
}
