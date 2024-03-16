import 'package:flutter/material.dart';
import 'package:porsig/globals.dart';
import 'package:porsig/models/account/login_model.dart';
import 'package:porsig/services/account_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isVisible = false;
  final _formKey = GlobalKey<FormState>();
  final AccountService _accountService = AccountService();
  final TextEditingController _username = TextEditingController();
  final TextEditingController _password = TextEditingController();

  void _onSubmit() async {
    if (!_formKey.currentState!.validate()) return;
    LoginModel loginModel =
        LoginModel(username: _username.text, password: _password.text);
    try {
      final response = await _accountService.Login(loginModel);
      print(response.token);
    } catch (err) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              err.toString(),
            ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
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
        ),
      ),
    );
  }
}
