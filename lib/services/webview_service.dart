import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../db/history_dao.dart';

class WebViewService {
  late WebViewController _controller;
  final HistoryDao _historyDao = HistoryDao();

  /// WebViewController를 초기화하는 함수
  void initializeController(WebViewController controller) {
    _controller = controller;
  }

  /// 현재 페이지의 URL을 가져와 방문 기록에 저장하는 함수
  Future<void> saveCurrentUrl() async {
    String? url = await _controller.currentUrl();
    if (url != null && (url.contains('/reel/') || url.contains('/stories/'))) {
      await _historyDao.insertUrl(url);
    }
  }

  /// 특정 URL로 이동하는 함수
  Future<void> loadUrl(String url) async {
    await _controller.loadUrl(url);
  }

  /// 이전 페이지로 이동
  Future<void> goBack() async {
    if (await _controller.canGoBack()) {
      await _controller.goBack();
    }
  }

  /// 다음 페이지로 이동
  Future<void> goForward() async {
    if (await _controller.canGoForward()) {
      await _controller.goForward();
    }
  }

  /// WebView에서 자동 로그인을 유지하기 위한 쿠키 설정 (OAuth 기반)
  Future<void> enableAutoLogin() async {
    await _controller.runJavaScript(
        "document.getElementById('username').value = 'your_username';"
            "document.getElementById('password').value = 'your_password';"
            "document.getElementById('login-button').click();"
    );
  }

  /// WebView 설정 초기화
  WebView buildWebView() {
    return WebView(
      initialUrl: 'https://www.instagram.com',
      javascriptMode: JavascriptMode.unrestricted,
      onWebViewCreated: (WebViewController controller) {
        _controller = controller;
      },
      onPageFinished: (String url) async {
        await saveCurrentUrl(); // 방문 기록 저장
      },
    );
  }
}
