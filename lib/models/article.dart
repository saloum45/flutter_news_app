class Article {
  final int id;
  final String? title;
  final String? by;
  final int? descendants;
  final String? url;
  final List<int>? kids;
  final String? text; // <-- ici le champ text est bien une String
  final bool isFavorite;

  Article({
    required this.id,
    this.title,
    this.by,
    this.descendants,
    this.url,
    this.kids,
    this.text,
    this.isFavorite = false,
  });

  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      id: json['id'],
      title: json['title'],
      by: json['by'],
      descendants: json['descendants'],
      url: json['url'],
      text: json['text'], // <-- ici aussi
      kids: json['kids'] != null ? List<int>.from(json['kids']) : [],
      isFavorite: false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'by': by,
      'descendants': descendants,
      'url': url,
      'text': text, // <-- enregistrer dans SQLite
      'kids': kids?.join(','),
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
      text: map['text'], // <-- lecture depuis SQLite
      kids: map['kids'] != null && map['kids'] != ''
          ? map['kids'].split(',').map((e) => int.parse(e)).toList()
          : [],
      isFavorite: map['isFavorite'] == 1,
    );
  }
}
