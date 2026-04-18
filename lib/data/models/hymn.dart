class Hymn {
  int id = 0;
  late String category; // 'HARPA' or 'NOVO_CANTICO'
  late int number;
  late String title;
  late String lyrics;
  String? audioUrl;
  String? localPath;
  bool isFavorite = false;
}
