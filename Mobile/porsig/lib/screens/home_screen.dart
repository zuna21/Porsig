import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:porsig/screens/login_screen.dart';
import 'package:porsig/widgets/chat_card.dart';
import 'package:porsig/widgets/confirmation_dialog.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {},
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
      body: const SingleChildScrollView(
        child: Column(
          children: [
            ChatCard(),
            ChatCard(),
            ChatCard(),
            ChatCard(),
            ChatCard(),
            ChatCard(),
            ChatCard(),
            ChatCard(),
            ChatCard(),
            ChatCard(),
          ],
        ),
      )
    );
  }
}
