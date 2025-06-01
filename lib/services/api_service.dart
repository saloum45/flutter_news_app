import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/article.dart';

class ApiService {
  static const String baseUrl = 'https://hacker-news.firebaseio.com/v0';

  /// Récupère les IDs des top stories
  static Future<List<int>> fetchTopStoriesIds() async {
    final response = await http.get(Uri.parse('$baseUrl/topstories.json'));

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      return List<int>.from(data);
    } else {
      throw Exception('Échec du chargement des IDs des articles');
    }
  }

  /// Récupère un article par son ID
  static Future<Article> fetchArticle(int id) async {
    final response = await http.get(Uri.parse('$baseUrl/item/$id.json'));

    if (response.statusCode == 200) {
      Map<String, dynamic> data = jsonDecode(response.body);
      return Article.fromJson(data);
    } else {
      throw Exception('Échec du chargement de l\'article');
    }
  }
}
