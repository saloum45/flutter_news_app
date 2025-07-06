import 'package:flutter/material.dart';
import '../services/favorite_service.dart';
import '../models/article.dart';
import 'article_detail_screen.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  List<Article> favorites = [];

  @override
  void initState() {
    super.initState();
    loadFavorites();
  }

  Future<void> loadFavorites() async {
    final favs = await FavoriteService.getFavorites();
    setState(() => favorites = favs);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Favoris')),
      body: favorites.isEmpty
          ? const Center(child: Text("Aucun favori."))
          : ListView.builder(
              itemCount: favorites.length,
              itemBuilder: (context, index) {
                final article = favorites[index];
                return ListTile(
                  title: Text(article.title ?? 'Sans titre'),
                  subtitle: Text('Auteur: ${article.by ?? 'Inconnu'}'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ArticleDetailScreen(article: article),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}
