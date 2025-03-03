class HistoryModel {
  final int? id;
  final String url;
  final String folder;
  final DateTime dateTime;

  // 🔹 생성자
  HistoryModel({
    this.id,
    required this.url,
    required this.folder,
    required this.dateTime,
  });

  // 🔹 객체를 Map (데이터베이스 저장용)으로 변환
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'url': url,
      'folder': folder,
      'dateTime': dateTime.toIso8601String(), // DateTime -> String 변환
    };
  }

  // 🔹 데이터베이스에서 가져온 Map을 객체로 변환
  factory HistoryModel.fromMap(Map<String, dynamic> map) {
    return HistoryModel(
      id: map['id'],
      url: map['url'],
      folder: map['folder'],
      dateTime: DateTime.parse(map['dateTime']), // String -> DateTime 변환
    );
  }
}
