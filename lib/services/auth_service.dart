import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  Future<void> signUp(String username, String password) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('username', username);
    await prefs.setString('password', password);
  }

  Future<bool> login(String username, String password) async {
    final prefs = await SharedPreferences.getInstance();
    final storedUser = prefs.getString('username');
    final storedPass = prefs.getString('password');
    if (username == storedUser && password == storedPass) {
      await prefs.setBool('isLoggedIn', true);
      return true;
    }
    return false;
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', false);
  }
}
