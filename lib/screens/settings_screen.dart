import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../db/history_dao.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final HistoryDao _historyDao = HistoryDao();

  Future<void> _clearHistory() async {
    await _historyDao.clearAllUrls();
    setState(() {});
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("방문 기록이 삭제되었습니다.")));
  }

  void _launchPrivacyPolicy() async {
    const url = 'https://your_privacy_policy_url';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("설정")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("방문 기록 관리", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: _clearHistory,
              child: Text("방문 기록 전체 삭제"),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            ),
            SizedBox(height: 30),
            Text("앱 정보", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: _launchPrivacyPolicy,
              child: Text("개인정보 처리방침 보기"),
            ),
          ],
        ),
      ),
    );
  }
}
