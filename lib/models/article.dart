class Article {
  final int id;
  final String? title;
  final String? by;
  final int? descendants;
  final String? url;
  final List<int>? kids;
  final bool isFavorite;

  Article({
    required this.id,
    this.title,
    this.by,
    this.descendants,
    this.url,
    this.kids,
    this.isFavorite = false,
  });

  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      id: json['id'],
      title: json['title'],
      by: json['by'],
      descendants: json['descendants'],
      url: json['url'],
      kids: json['kids'] != null ? List<int>.from(json['kids']) : [],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'by': by,
      'descendants': descendants,
      'url': url,
      'kids': kids?.join(','), // SQLite ne gère pas les listes, donc on serialize
      'isFavorite': isFavorite ? 1 : 0,
    };
  }

  static Article fromMap(Map<String, dynamic> map) {
    return Article(
      id: map['id'],
      title: map['title'],
      by: map['by'],
      descendants: map['descendants'],
      url: map['url'],
      kids: map['kids'] != null && map['kids'] != ''
          ? map['kids'].split(',').map((e) => int.parse(e)).toList()
          : [],
      isFavorite: map['isFavorite'] == 1,
    );
  }
}
