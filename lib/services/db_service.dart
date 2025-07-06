import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../models/article.dart';

class DBService {
  static Database? _database;

  static Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDb();
    return _database!;
  }

  static Future<Database> _initDb() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'articles.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE articles (
            id INTEGER PRIMARY KEY,
            title TEXT,
            by TEXT,
            descendants INTEGER,
            url TEXT,
            kids TEXT,
            isFavorite INTEGER
          )
        ''');
      },
    );
  }

  static Future<void> insertArticle(Article article) async {
    final db = await database;
    await db.insert(
      'articles',
      article.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<List<Article>> getAllArticles() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('articles');
    return maps.map((map) => Article.fromMap(map)).toList();
  }

  static Future<Article?> getArticleById(int id) async {
    final db = await database;
    final List<Map<String, dynamic>> maps =
        await db.query('articles', where: 'id = ?', whereArgs: [id]);

    if (maps.isNotEmpty) return Article.fromMap(maps.first);
    return null;
  }

  static Future<void> deleteArticle(int id) async {
    final db = await database;
    await db.delete('articles', where: 'id = ?', whereArgs: [id]);
  }

  static Future<void> toggleFavorite(int id, bool isFavorite) async {
    final db = await database;
    await db.update(
      'articles',
      {'isFavorite': isFavorite ? 1 : 0},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  static Future<List<Article>> getFavorites() async {
    final db = await database;
    final List<Map<String, dynamic>> maps =
        await db.query('articles', where: 'isFavorite = 1');
    return maps.map((map) => Article.fromMap(map)).toList();
  }

  static Future<void> cleanNonFavoritesNotAvailable(List<int> availableIds) async {
    final db = await database;
    await db.delete(
      'articles',
      where: 'isFavorite = 0 AND id NOT IN (${availableIds.join(',')})',
    );
  }
}
