import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:porsig/models/group/group_model.dart';
import 'package:porsig/screens/create_group_screen.dart';
import 'package:porsig/screens/group_screen.dart';
import 'package:porsig/screens/login_screen.dart';
import 'package:porsig/services/group_service.dart';
import 'package:porsig/services/toastr_service.dart';
import 'package:porsig/widgets/chat_card.dart';
import 'package:porsig/widgets/confirmation_dialog.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GroupService _groupService = const GroupService();
  final ToastrService _toastr = const ToastrService();

  bool _isLoading = true;
  List<GroupModel> _groups = [];

  @override
  void initState() {
    super.initState();
    _getGroups();
  }

  void _onLogout() async {
    final result = await showDialog(
      context: context,
      builder: (builder) => const ConfirmationDialog(
        question: "Are you sure?",
      ),
    );

    if (!result) return;
    const storage = FlutterSecureStorage();
    await storage.delete(key: "token");
    if (!context.mounted) return;
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (builder) => const LoginScreen(),
      ),
    );
  }

  void _getGroups() async {
    try {
      _groups = await _groupService.getGroups();
    } catch (err) {
      if (!context.mounted) return;
      _toastr.error(context, "Error", err.toString());
    }

    setState(() {
      _isLoading = false;
    });
  }

  void _onGroup(GroupModel group) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (builder) => GroupScreen(group: group),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          actions: [
            IconButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (builder) => const CreateGroupScreent(),
                  ),
                );
              },
              icon: const Icon(Icons.add_circle_outline),
            ),
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.account_circle_outlined),
            ),
            IconButton(
              onPressed: _onLogout,
              icon: const Icon(Icons.logout),
            )
          ],
        ),
        body: _isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : SingleChildScrollView(
                child: Column(
                  children: [
                    for (var group in _groups)
                      ChatCard(
                        group: group,
                        onGroup: (group) => _onGroup(group),
                      ),
                  ],
                ),
              ),
      ),
    );
  }
}
