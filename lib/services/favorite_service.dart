import '../models/article.dart';
import 'db_service.dart';

class FavoriteService {
  /// Retourne tous les articles marqués comme favoris
  static Future<List<Article>> getFavorites() async {
    return await DBService.getFavorites();
  }

  /// Ajoute ou retire un article des favoris
  static Future<void> toggleFavorite(Article article) async {
    final existing = await DBService.getArticleById(article.id);

    if (existing != null && existing.isFavorite == true) {
      // Retirer des favoris
      await DBService.toggleFavorite(article.id, false);
    } else {
      // Ajouter aux favoris
      // Sauvegarder l'article s’il n’existe pas encore
      if (existing == null) {
        article.isFavorite = true;
        await DBService.insertArticle(article);
      } else {
        await DBService.toggleFavorite(article.id, true);
      }
    }
  }

  /// Vérifie si un article est favori
  static Future<bool> isFavorite(Article article) async {
    final existing = await DBService.getArticleById(article.id);
    return existing?.isFavorite ?? false;
  }
}
