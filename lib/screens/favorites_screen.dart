import 'package:flutter/material.dart';
import '../models/article.dart';
import '../services/favorite_service.dart';
import 'article_detail_screen.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  List<Article> favorites = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadFavorites();
  }

  Future<void> loadFavorites() async {
    final data = await FavoriteService.getFavorites();
    setState(() {
      favorites = data;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Articles favoris'),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : favorites.isEmpty
              ? const Center(child: Text('Aucun favori pour le moment.'))
              : ListView.builder(
                  itemCount: favorites.length,
                  itemBuilder: (context, index) {
                    final article = favorites[index];
                    return ListTile(
                      title: Text(article.title ?? 'Sans titre'),
                      subtitle: Text(article.by ?? 'Auteur inconnu'),
                      trailing: const Icon(Icons.favorite, color: Colors.red),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ArticleDetailScreen(article: article),
                          ),
                        ).then((_) => loadFavorites()); // refresh au retour
                      },
                    );
                  },
                ),
    );
  }
}
