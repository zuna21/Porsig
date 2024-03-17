import 'package:flutter/material.dart';
import 'package:porsig/models/group/create_group_model.dart';
import 'package:porsig/models/user/user_model.dart';
import 'package:porsig/screens/home_screen.dart';
import 'package:porsig/services/group_service.dart';
import 'package:porsig/services/toastr_service.dart';
import 'package:porsig/services/user_service.dart';
import 'package:porsig/widgets/user_card.dart';

class CreateGroupScreent extends StatefulWidget {
  const CreateGroupScreent({super.key});

  @override
  State<CreateGroupScreent> createState() => _CreateGroupScreentState();
}

class _CreateGroupScreentState extends State<CreateGroupScreent> {
  final TextEditingController _username = TextEditingController();
  final TextEditingController _groupName = TextEditingController();
  final ToastrService _toastrService = const ToastrService();
  final UserService _userService = const UserService();
  final GroupService _groupService = const GroupService();

  List<UserModel> selectedUsers = [];
  List<UserModel> users = [];
  bool _loadingUsers = false;
  bool _loadingCrete = false;

  void _onSearch() {
    if (_username.text.trim().isEmpty) {
      _toastrService.warning(context, "Invalid", "Please enter valid username");
      return;
    }
    try {
      setState(() {
        _loadingUsers = true;
      });
      _userService.getUsers(_username.text).then((value) {
        setState(() {
          users = [];
          for (var user in value) {
            if (!selectedUsers.any((element) => element.id == user.id)) {
              users.add(user);
            }
          }
          FocusManager.instance.primaryFocus?.unfocus();
          _loadingUsers = false;
        });
      });
    } catch (err) {
      _toastrService.error(context, "Error", err.toString());
      setState(() {
        _loadingUsers = false;
      });
    }
  }

  void onAddUser(UserModel user) {
    setState(() {
      selectedUsers.add(user);
      users.remove(user);
    });
  }

  void onRemoveUser(UserModel user) {
    setState(() {
      selectedUsers.remove(user);
      if (!users.any((element) => element.id == user.id)) {
        users.add(user);
      }
    });
  }

  void _onCreate() {
    if (_groupName.text.isEmpty || _groupName.text.length < 3) {
      _toastrService.info(context, "Invalid data",
          "Group name need to have at least 3 letters.");
      return;
    }
    if (selectedUsers.isEmpty) {
      _toastrService.info(
          context, "Invalid data", "You have to select at least one user.");
      return;
    }
    CreateGroupModel createGroupModel = CreateGroupModel(
        name: _groupName.text,
        participantsId: selectedUsers.map((e) => e.id!).toList());
    setState(() {
      _loadingCrete = true;
    });
    try {
      _groupService.create(createGroupModel).then((value) {
        _toastrService.success(
            context, "Good", "Successfully cretaed ${value.name}");
        _loadingCrete = false;
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (builder) => const HomeScreen(),
          ),
        );
      });
    } catch (err) {
      _toastrService.error(context, "Error", err.toString());
      setState(() {
        _loadingCrete = false;
      });
    }
  }

  @override
  void dispose() {
    _username.dispose();
    _groupName.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Create Group"),
        actions: [
          _loadingCrete
          ? const CircularProgressIndicator()
          : ElevatedButton(
            onPressed: _onCreate,
            style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                foregroundColor:
                    Theme.of(context).colorScheme.onPrimaryContainer),
            child: const Text("Create"),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(
                height: 20,
              ),
              TextField(
                autocorrect: false,
                controller: _groupName,
                enableSuggestions: false,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Group Name",
                    suffixIcon: Icon(Icons.group)),
              ),
              const SizedBox(
                height: 20,
              ),
              TextField(
                autocorrect: false,
                enableSuggestions: false,
                controller: _username,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  labelText: "Search User",
                  suffixIcon: _loadingUsers
                  ? const CircularProgressIndicator()
                  : IconButton(
                    onPressed: _onSearch,
                    icon: const Icon(Icons.search),
                    style: IconButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      foregroundColor: Theme.of(context).colorScheme.onPrimary,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              if (selectedUsers.isNotEmpty)
                Container(
                  width: double.infinity,
                  height: 200,
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                          color: Theme.of(context).colorScheme.primary)),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Text(
                          "Selected users",
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium!
                              .copyWith(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onPrimaryContainer),
                        ),
                        for (var user in selectedUsers)
                          UserCard(
                            user: user,
                            isSelected: true,
                            onRemoveUser: onRemoveUser,
                          ),
                      ],
                    ),
                  ),
                ),
              for (var user in users)
                UserCard(
                  user: user,
                  onAddUser: onAddUser,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
