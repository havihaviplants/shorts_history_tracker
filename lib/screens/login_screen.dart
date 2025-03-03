import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../services/auth_service.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late final WebViewController _controller;
  final AuthService _authService = AuthService();

  @override
  void initState() {
    super.initState();
    _initializeWebView();
    _loadSavedSession();
  }

  void _initializeWebView() {
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(Uri.parse('https://www.instagram.com'));
  }

  Future<void> _loadSavedSession() async {
    String? savedSession = await _authService.getLoginSession();
    if (savedSession != null) {
      _controller.loadRequest(Uri.parse(savedSession));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('로그인')),
      body: WebViewWidget(controller: _controller), // ✅ 최신 방식으로 변경됨
    );
  }
}
