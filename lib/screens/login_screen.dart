import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool isLoginMode = true;
  final Box userBox = Hive.box('users');

  void _submit() {
    final username = _usernameController.text.trim();
    final password = _passwordController.text.trim();

    if (username.isEmpty || password.isEmpty) return;

    if (isLoginMode) {
      if (userBox.containsKey(username) && userBox.get(username) == password) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen(username: username)),
        );

      } else {
        _showMessage('Hatalı kullanıcı adı veya şifre');
      }
    } else {
      if (userBox.containsKey(username)) {
        _showMessage('Bu kullanıcı adı zaten alınmış.');
      } else {
        userBox.put(username, password);
        _showMessage('Kayıt başarılı! Giriş yapabilirsiniz.');
        setState(() => isLoginMode = true);
      }
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEAF4F2),
      body: Padding(
        padding: const EdgeInsets.all(32),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                const Text('Yemek Menüsü', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
                const SizedBox(height: 30),
                TextField(
                  controller: _usernameController,
                  decoration: const InputDecoration(labelText: 'Kullanıcı Adı'),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(labelText: 'Şifre'),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _submit,
                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF4C9F70)),
                  child: Text(isLoginMode ? 'Giriş Yap' : 'Kayıt Ol'),
                ),
                const SizedBox(height: 12),
                TextButton(
                  onPressed: () => setState(() => isLoginMode = !isLoginMode),
                  child: Text(isLoginMode
                      ? 'Hesabınız yok mu? Kayıt olun'
                      : 'Zaten hesabınız var mı? Giriş yapın'),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
