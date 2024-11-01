
class LoginService {
  // nur ein nutzer fürs herzeigen
  static const _username = 'admin';
  static const _password = 'admin';

  Future<bool> login(String username, String password) async {
    await Future.delayed(const Duration(seconds: 1)); //simuliert delay
    return username == _username && password == _password;
  }
}
