import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefs {
  static const String _keyUsername = "username";
  static const String _keyPassword = "password";
  static const String _keyIsLoggedIn = "is_logged_in";
  static const String _keyIsPremium = "is_premium";

  /// SharedPreferences 인스턴스 가져오기
  static Future<SharedPreferences> get _prefs async => await SharedPreferences.getInstance();

  /// 🔹 자동 로그인: 사용자 로그인 정보 저장
  static Future<void> saveLoginInfo(String username, String password) async {
    final prefs = await _prefs;
    await prefs.setString(_keyUsername, username);
    await prefs.setString(_keyPassword, password);
    await prefs.setBool(_keyIsLoggedIn, true);
  }

  /// 🔹 자동 로그인: 저장된 로그인 정보 가져오기
  static Future<Map<String, String?>> getLoginInfo() async {
    final prefs = await _prefs;
    return {
      "username": prefs.getString(_keyUsername),
      "password": prefs.getString(_keyPassword),
    };
  }

  /// 🔹 로그인 상태 확인
  static Future<bool> isLoggedIn() async {
    final prefs = await _prefs;
    return prefs.getBool(_keyIsLoggedIn) ?? false;
  }

  /// 🔹 로그아웃 (저장된 로그인 정보 삭제)
  static Future<void> logout() async {
    final prefs = await _prefs;
    await prefs.remove(_keyUsername);
    await prefs.remove(_keyPassword);
    await prefs.setBool(_keyIsLoggedIn, false);
  }

  /// 🔹 프리미엄 사용자 여부 저장 (광고 제거 여부 확인)
  static Future<void> setPremiumStatus(bool isPremium) async {
    final prefs = await _prefs;
    await prefs.setBool(_keyIsPremium, isPremium);
  }

  /// 🔹 프리미엄 사용자 여부 확인
  static Future<bool> isPremiumUser() async {
    final prefs = await _prefs;
    return prefs.getBool(_keyIsPremium) ?? false;
  }
}
