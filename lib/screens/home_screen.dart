import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../db/history_dao.dart';
import '../services/ad_service.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:webview_flutter_platform_interface/webview_flutter_platform_interface.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final WebViewController _controller;
  final HistoryDao _historyDao = HistoryDao();

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.white)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageFinished: (url) async {
            if (url.contains('/reel/') || url.contains('/stories/')) {
              await _historyDao.insertUrl(url);
            }
          },
        ),
      )
      ..loadRequest(Uri.parse('https://www.instagram.com'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Shorts Tracker'),
        actions: [
          IconButton(
            icon: Icon(Icons.folder),
            onPressed: () => Navigator.pushNamed(context, '/history'),
          ),
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () => Navigator.pushNamed(context, '/settings'),
          ),
        ],
      ),
      body: WebViewWidget(controller: _controller),
      bottomNavigationBar: Container(
        height: 50,
        child: AdService.showBannerAd(),
      ),
    );
  }
}