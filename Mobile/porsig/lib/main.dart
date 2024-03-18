import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:porsig/screens/home_screen.dart';
import 'package:porsig/screens/login_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Porsig',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 49, 223, 223)),
        useMaterial3: true,
      ),
      home: isLogin(),
    );
  }
}

Widget isLogin() {
  const storage = FlutterSecureStorage();
  return FutureBuilder(future: storage.read(key: "token"), builder: (builder, snapshot) {
    if (snapshot.hasData) {
      return const HomeScreen();
    } else {
      return const LoginScreen();
    }
  });
}