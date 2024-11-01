import 'package:flutter/material.dart';
import '../logon_service.dart';
import 'splash_screen.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _loginService = LoginService();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  String? _error;

  Future<void> _attemptLogin() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    final username = _usernameController.text;
    final password = _passwordController.text;

    final success = await _loginService.login(username, password);

    setState(() => _isLoading = false);

    if (success) {
      Navigator.of(context).pushReplacementNamed('/splash'); // Zu SplashScreen navigieren
    } else {
      setState(() {
        _error = 'Invalid username or password';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Login"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.flutter_dash, size: 80, color: Colors.deepPurple),
            const SizedBox(height: 20),
            const Text(
              "MyApp",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _usernameController,
              decoration: const InputDecoration(labelText: 'Username'),
            ),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            if (_error != null) ...[
              Text(
                _error!,
                style: const TextStyle(color: Colors.red),
              ),
              const SizedBox(height: 10),
            ],
            _isLoading
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: _attemptLogin,
                    child: const Text('Login'),
                  ),
          ],
        ),
      ),
    );
  }
}
