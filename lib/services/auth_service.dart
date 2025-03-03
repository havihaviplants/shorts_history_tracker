import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthService {
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  static const String _loginSessionKey = "login_session";

  Future<void> saveLoginSession(String url) async {
    await _storage.write(key: _loginSessionKey, value: url);
    print("✅ 로그인 세션 저장 완료: $url");
  }

  Future<String?> getLoginSession() async {
    return await _storage.read(key: _loginSessionKey);
  }

  Future<void> clearLoginSession() async {
    await _storage.delete(key: _loginSessionKey);
    print("✅ 로그인 세션 삭제 완료");
  }
}
