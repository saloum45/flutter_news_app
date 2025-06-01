import 'package:flutter/material.dart';
import '../models/article.dart';
import '../services/api_service.dart';

class ArticleProvider with ChangeNotifier {
  List<Article> _articles = [];
  bool _isLoading = false;

  List<Article> get articles => _articles;
  bool get isLoading => _isLoading;

  /// Charge les articles à partir de l'API
  Future<void> fetchArticles() async {
    try {
      _isLoading = true;
      notifyListeners();

      List<int> ids = await ApiService.fetchTopStoriesIds();

      // Charger les 20 premiers articles pour ne pas surcharger l’UI
      List<Article> fetchedArticles = [];
      for (int i = 0; i < 20 && i < ids.length; i++) {
        try {
          Article article = await ApiService.fetchArticle(ids[i]);
          fetchedArticles.add(article);
        } catch (_) {
          continue; // En cas d’erreur sur un article, on ignore
        }
      }

      _articles = fetchedArticles;
    } catch (e) {
      print('Erreur lors du chargement des articles: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
