import 'package:flutter/material.dart';
import '../db/history_dao.dart';
import '../models/history_model.dart';
import 'package:url_launcher/url_launcher.dart';

class HistoryScreen extends StatelessWidget {
  final HistoryDao _dao = HistoryDao();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("History")),
      body: FutureBuilder<List<HistoryModel>>(
        future: _dao.getAllUrls(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return Center(child: CircularProgressIndicator());
          return ListView.separated(
            itemCount: snapshot.data!.length,
            separatorBuilder: (_, __) => Divider(),
            itemBuilder: (context, index) {
              HistoryModel history = snapshot.data![index];
              return ListTile(
                title: Text(history.url),
                subtitle: Text("${history.folder} | ${history.dateTime}"),
                onTap: () => launchUrl(Uri.parse(history.url)),
              );
            },
          );
        },
      ),
    );
  }
}
