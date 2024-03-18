import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:porsig/hubs/chat_hub.dart';
import 'package:porsig/models/account/account_model.dart';
import 'package:porsig/models/account/login_model.dart';
import 'package:porsig/screens/home_screen.dart';
import 'package:porsig/services/account_service.dart';
import 'package:porsig/services/toastr_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final AccountService _accountService = const AccountService();
  final TextEditingController _username = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final ToastrService _toastr = const ToastrService();
  final ChatHub _chatHub = ChatHub();

  bool _isVisible = false;
  bool _isLoading = true;
  AccountModel? account;

  @override
  void initState() {
    super.initState();
    _chatHub.stopConnection();
    _checkIfLoggedIn();
  }

  void _checkIfLoggedIn() async {
    const storage = FlutterSecureStorage();
    final token = await storage.read(key: "Token");
    if (token == null) {
      setState(() {
        _isLoading = false;
      });
    } else {
      if (!context.mounted) return;
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (builder) => const HomeScreen(),
        ),
      );
    }
  }

  void _onSubmit() async {
    if (!_formKey.currentState!.validate()) return;
    LoginModel loginModel =
        LoginModel(username: _username.text, password: _password.text);
    try {
      account = await _accountService.Login(loginModel);
    } catch (err) {
      if (context.mounted) {
        _toastr.warning(context, "Try Againg", err.toString());
      }
    }

    if (account == null || !context.mounted) return;
    const storage = FlutterSecureStorage();
    await storage.write(key: "token", value: account!.token);
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (builder) => const HomeScreen(),
      ),
    );
  }

  @override
  void dispose() {
    _username.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget content = _isLoading
        ? const CircularProgressIndicator()
        : SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Text(
                    "PORSIG",
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge!
                        .copyWith(color: Theme.of(context).colorScheme.primary),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    controller: _username,
                    validator: (value) {
                      if (value == null || value.isEmpty || value.length < 4) {
                        return "Username need to have at least 4 letters";
                      }
                      return null;
                    },
                    autocorrect: false,
                    enableSuggestions: false,
                    decoration: InputDecoration(
                      label: const Text("Username"),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    autocorrect: false,
                    controller: _password,
                    validator: (value) {
                      if (value == null || value.isEmpty || value.length < 8) {
                        return "Password need to have at least 8 characters";
                      }
                      return null;
                    },
                    enableSuggestions: false,
                    obscureText: !_isVisible,
                    decoration: InputDecoration(
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            _isVisible = !_isVisible;
                          });
                        },
                        icon: Icon(
                          _isVisible ? Icons.visibility : Icons.visibility_off,
                        ),
                      ),
                      label: const Text("Password"),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        minimumSize: const Size.fromHeight(40)),
                    onPressed: _onSubmit,
                    child: const Text("Login"),
                  ),
                ],
              ),
            ),
          );

    return Scaffold(
      body: Center(child: content),
    );
  }
}
