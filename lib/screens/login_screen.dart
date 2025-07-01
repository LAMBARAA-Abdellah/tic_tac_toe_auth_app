import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import 'game_screen.dart';
import 'signup_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  String? error;

  void login() async {
    final auth = AuthService();
    final success = await auth.login(
      _usernameController.text,
      _passwordController.text,
    );

    if (success) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const GameScreen()),
      );
    } else {
      setState(() => error = "Nom d'utilisateur ou mot de passe incorrect.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Connexion")),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (error != null)
              Text(error!, style: const TextStyle(color: Colors.red)),
            TextField(
              controller: _usernameController,
              decoration: const InputDecoration(labelText: "Nom d'utilisateur"),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(labelText: "Mot de passe"),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: login,
              child: const Text("Se connecter"),
            ),
            TextButton(
              onPressed: () {
                Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const SignUpScreen()));
              },
              child: const Text("Créer un compte"),
            )
          ],
        ),
      ),
    );
  }
}
